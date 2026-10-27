#!/usr/bin/env python3
"""Private locator I/O only: no Git, recovery-body reads, ledgers or publication."""

import argparse
from contextlib import contextmanager, ExitStack
import json
import os
from pathlib import Path
import re
import secrets
import stat
import sys

MAX_BYTES = 8192
MAX_ENTRIES = 1024
RUN_ID = re.compile(r"[a-z0-9][a-z0-9-]{0,79}\Z")
ENTRYPOINT = re.compile(r"[a-z0-9][a-z0-9._-]{0,119}\.json\Z")
PENDING = re.compile(r"\.pending-[0-9a-f]{32}\Z")
FIELDS = {"run_id", "recovery_directory", "entrypoint"}


class Invalid(ValueError):
    pass


def absolute(value):
    if not isinstance(value, str) or "\0" in value or len(value) > 4096:
        raise Invalid("Invalid absolute path")
    path = Path(value)
    if not path.is_absolute() or value != os.path.normpath(value):
        raise Invalid("Use a canonical absolute path")
    return path


def owned(info, private=False, regular=False):
    expected = stat.S_ISREG if regular else stat.S_ISDIR
    if not expected(info.st_mode) or info.st_uid != os.getuid():
        raise Invalid("Expected an owned regular file or directory")
    mode = stat.S_IMODE(info.st_mode)
    if mode & 0o022 or (private and mode != (0o600 if regular else 0o700)):
        raise Invalid("Unsafe ownership or permissions")
    if regular and info.st_nlink != 1:
        raise Invalid("Linked files are not supported")


@contextmanager
def directory(value, private=False):
    path = absolute(value)
    fd = os.open(path.anchor, os.O_RDONLY | os.O_DIRECTORY)
    try:
        for part in path.parts[1:]:
            child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=fd)
            os.close(fd)
            fd = child
        owned(os.fstat(fd), private=private)
        yield fd
    finally:
        os.close(fd)


@contextmanager
def registry(common_dir, create=False):
    with directory(common_dir) as root, ExitStack() as stack:
        fd = root
        for name in ("agent-helm", "normalize-handoffs"):
            if create:
                try:
                    os.mkdir(name, 0o700, dir_fd=fd)
                except FileExistsError:
                    pass
            try:
                child = os.open(name, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=fd)
            except FileNotFoundError:
                if create:
                    raise
                yield None
                return
            stack.callback(os.close, child)
            owned(os.fstat(child), private=True)
            fd = child
        yield fd


def entries(fd):
    names = []
    with os.scandir(fd) as iterator:
        for item in iterator:
            names.append(item.name)
            if len(names) > MAX_ENTRIES:
                raise Invalid("Too many handoffs; identify the required run explicitly")
    return sorted(names)


def unique(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise Invalid("Duplicate locator field")
        result[key] = value
    return result


def validate(data, name):
    if not isinstance(data, dict) or set(data) != FIELDS or not all(isinstance(v, str) for v in data.values()):
        raise Invalid("Invalid locator fields")
    if not RUN_ID.fullmatch(data["run_id"]) or name != data["run_id"] + ".json":
        raise Invalid("Invalid run identity")
    absolute(data["recovery_directory"])
    if not ENTRYPOINT.fullmatch(data["entrypoint"]):
        raise Invalid("Expected a JSON data entrypoint basename")
    return data


def load(fd, name):
    opened = os.open(name, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK, dir_fd=fd)
    with os.fdopen(opened, "rb") as stream:
        before = os.fstat(stream.fileno())
        owned(before, private=True, regular=True)
        if before.st_size > MAX_BYTES:
            raise Invalid("Locator exceeds the size limit")
        raw = stream.read(MAX_BYTES + 1)
        after = os.fstat(stream.fileno())
        if len(raw) != before.st_size or (before.st_size, before.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
            raise Invalid("Locator changed while reading")
    return validate(json.loads(raw.decode("utf-8"), object_pairs_hook=unique), name), raw


def availability(data):
    try:
        with directory(data["recovery_directory"], private=True) as fd:
            info = os.stat(data["entrypoint"], dir_fd=fd, follow_symlinks=False)
            owned(info, private=True, regular=True)
            if info.st_size > 262144:
                raise Invalid("Recovery entrypoint exceeds the size limit")
        return "present"
    except FileNotFoundError:
        return "missing"
    except (OSError, Invalid):
        return "invalid"


def register(common_dir, data):
    name = data["run_id"] + ".json"
    validate(data, name)
    if availability(data) != "present":
        raise Invalid("Recovery directory and data entrypoint must already be private and present")
    raw = (json.dumps(data, sort_keys=True, ensure_ascii=True) + "\n").encode("ascii")
    if len(raw) > MAX_BYTES:
        raise Invalid("Locator exceeds the size limit")
    with registry(common_dir, create=True) as fd:
        try:
            existing, saved = load(fd, name)
        except FileNotFoundError:
            pass
        else:
            if existing != data or saved != raw:
                raise Invalid("Run identity already belongs to a different handoff")
            return data
        if len(entries(fd)) >= MAX_ENTRIES:
            raise Invalid("Too many handoffs; preserve them and stop before rewriting")
        temporary = ".pending-" + secrets.token_hex(16)
        opened = os.open(temporary, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600, dir_fd=fd)
        stamp = os.fstat(opened)
        try:
            with os.fdopen(opened, "wb") as stream:
                stream.write(raw)
                stream.flush()
                os.fsync(stream.fileno())
            os.link(temporary, name, src_dir_fd=fd, dst_dir_fd=fd, follow_symlinks=False)
        finally:
            current = os.stat(temporary, dir_fd=fd, follow_symlinks=False)
            if (current.st_dev, current.st_ino) == (stamp.st_dev, stamp.st_ino):
                os.unlink(temporary, dir_fd=fd)
        os.fsync(fd)
        if load(fd, name)[1] != raw:
            raise Invalid("Locator readback failed")
    return data


def discover(common_dir):
    candidates, issues = [], []
    with registry(common_dir) as fd:
        if fd is None:
            return {"candidates": [], "issues": []}
        for name in entries(fd):
            if PENDING.fullmatch(name):
                continue  # An unpublished locator cannot authorize a rewrite.
            if not name.endswith(".json") or not RUN_ID.fullmatch(name[:-5]):
                issues.append({"reason": "Unexpected handoff entry; not opened"})
                continue
            try:
                data, _ = load(fd, name)
                candidates.append(dict(data, availability=availability(data)))
            except (OSError, ValueError, UnicodeError):
                issues.append({"run_id": name[:-5], "reason": "Invalid or unreadable locator"})
    return {"candidates": candidates, "issues": issues}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("register", "discover"))
    parser.add_argument("--git-common-dir", required=True)
    parser.add_argument("--run-id")
    parser.add_argument("--recovery-directory")
    parser.add_argument("--entrypoint")
    args = parser.parse_args()
    try:
        if not all(hasattr(os, key) for key in ("O_NOFOLLOW", "O_DIRECTORY", "getuid")):
            raise Invalid("Use equivalent safe host tools; no-follow directory operations are unavailable")
        if args.action == "register":
            if not all((args.run_id, args.recovery_directory, args.entrypoint)):
                raise Invalid("Registration requires run identity, recovery directory and entrypoint")
            result = register(args.git_common_dir, {"run_id": args.run_id,
                "recovery_directory": args.recovery_directory, "entrypoint": args.entrypoint})
        else:
            if any((args.run_id, args.recovery_directory, args.entrypoint)):
                raise Invalid("Discovery accepts only the verified Git common directory")
            result = discover(args.git_common_dir)
        print(json.dumps(result, ensure_ascii=True))
        return 0
    except (OSError, ValueError, UnicodeError) as error:
        print(json.dumps({"error": str(error)}, ensure_ascii=True))
        return 2


if __name__ == "__main__":
    sys.exit(main())
