#!/usr/bin/env python3
"""Bounded same-clone recovery retention after verified Ship completion.

Ship owns publication, release and dependency judgments. This helper runs no
Git/project/network commands and never reads a ledger. Inspect is read-only;
complete records the supplied verified result and keeps three completed runs.
"""

from datetime import datetime
import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import pwd
import re
import shutil
import stat
import sys

SPEC = importlib.util.spec_from_file_location(
    "helm_retention_locator", Path(__file__).resolve().with_name("normalize_handoff.py"))
locator = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(locator)
Invalid = locator.Invalid
RECEIPT = ".helm-retention.json"
KEEP = 3
MAX_RECEIPT = 2 * 1024 * 1024
MAX_FILES = 8192
MAX_DEPTH = 32
UUID = re.compile(r"[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}\Z")
SHA = re.compile(r"(?:[0-9a-f]{40}|[0-9a-f]{64})\Z")
REQUEST_FIELDS = {"schema_version", "run_id", "git_common_dir", "completed_at",
                  "published_refs", "release_outcome", "required_runs"}
REGISTRIES = {"normalize": "normalize-handoffs", "ship": "ship-backups"}


def home_directory():
    return Path(pwd.getpwuid(os.getuid()).pw_dir)


def root_directory(kind="normalize"):
    if kind not in REGISTRIES:
        raise Invalid("Unsupported backup type")
    return home_directory() / "Agent Helm" / kind


def safe_run(data, kind="normalize"):
    run_id = data["run_id"]
    expected = root_directory(kind) / run_id
    if not UUID.fullmatch(run_id) or data["recovery_directory"] != str(expected):
        raise Invalid("Run is outside fixed same-user retention storage")
    return expected


def register_ship(common_dir, data):
    safe_run(data, "ship")
    return locator.register(common_dir, data, registry_name=REGISTRIES["ship"])


def registrations(common_dir):
    result = []
    ids = set()
    for kind, name in REGISTRIES.items():
        with locator.registry(common_dir, name=name) as fd:
            if fd is None:
                continue
            for entry in locator.entries(fd):
                if len(result) >= locator.MAX_ENTRIES:
                    raise Invalid("Too many combined recovery registrations")
                if locator.PENDING.fullmatch(entry):
                    result.append((kind, None, entry.encode()))
                    continue
                data, raw = locator.load(fd, entry)
                if data["run_id"] in ids:
                    raise Invalid("Run identity occurs in both backup types")
                ids.add(data["run_id"])
                result.append((kind, data, raw))
    return result


def request_valid(data, common_dir):
    if not isinstance(data, dict) or set(data) != REQUEST_FIELDS:
        raise Invalid("Invalid completion fields")
    if type(data["schema_version"]) is not int or data["schema_version"] != 1:
        raise Invalid("Unsupported completion version")
    if data["git_common_dir"] != str(locator.absolute(common_dir)):
        raise Invalid("Completion belongs to a different clone")
    if not isinstance(data["run_id"], str) or not UUID.fullmatch(data["run_id"]):
        raise Invalid("Invalid completion run identity")
    date = data["completed_at"]
    if not isinstance(date, str):
        raise Invalid("Invalid completion time")
    parsed = datetime.strptime(date, "%Y-%m-%dT%H:%M:%SZ")
    if parsed.strftime("%Y-%m-%dT%H:%M:%SZ") != date:
        raise Invalid("Use a canonical UTC completion time")
    if data["release_outcome"] not in ("completed", "skipped", "not_applicable"):
        raise Invalid("Selected release work is not complete")
    refs = data["published_refs"]
    if not isinstance(refs, list) or not refs or len(refs) > 256:
        raise Invalid("Completion needs every affected branch's publication")
    identities = set()
    for item in refs:
        if not isinstance(item, dict) or set(item) != {"local_ref", "remote_ref", "commit", "destination_id"}:
            raise Invalid("Invalid publication identity")
        if not all(isinstance(value, str) for value in item.values()):
            raise Invalid("Invalid publication identity")
        for key in ("local_ref", "remote_ref"):
            ref = item[key]
            if not ref.startswith("refs/heads/") or any(c.isspace() for c in ref) or any(
                    token in ref for token in ("..", "@{", "\\", "\0")):
                raise Invalid("Invalid published branch")
        if not SHA.fullmatch(item["commit"]) or not re.fullmatch(r"[0-9a-f]{64}", item["destination_id"]):
            raise Invalid("Invalid published commit or destination identity")
        identity = (item["destination_id"], item["remote_ref"])
        if identity in identities:
            raise Invalid("Duplicate publication destination")
        identities.add(identity)
    required = data["required_runs"]
    if not isinstance(required, list) or len(required) > locator.MAX_ENTRIES or any(
            not isinstance(run, str) or not locator.RUN_ID.fullmatch(run) for run in required):
        raise Invalid("Invalid required recovery runs")
    if len(set(required)) != len(required) or data["run_id"] in required:
        raise Invalid("Invalid recovery dependencies")
    return data


def read_receipt(fd):
    opened = os.open(RECEIPT, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK, dir_fd=fd)
    with os.fdopen(opened, "rb") as stream:
        info = os.fstat(stream.fileno())
        locator.owned(info, private=True, regular=True)
        if info.st_size > MAX_RECEIPT:
            raise Invalid("Completion record exceeds the size limit")
        raw = stream.read(MAX_RECEIPT + 1)
        after = os.fstat(stream.fileno())
        if len(raw) != info.st_size or (info.st_size, info.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
            raise Invalid("Completion changed while reading")
    record = json.loads(raw.decode("utf-8"), object_pairs_hook=locator.unique)
    if not isinstance(record, dict) or set(record) != {"request", "root_identity", "inventory"}:
        raise Invalid("Invalid completion record")
    if not isinstance(record["inventory"], dict) or len(record["inventory"]) > MAX_FILES:
        raise Invalid("Invalid recovery inventory")
    return record, raw


def receipt_seal(common_dir, run_id, digest=None, remove=False):
    # A separate clone-local checksum detects changes to the completion
    # receipt itself; the receipt cannot certify its own unchanged bytes.
    with locator.directory(str(Path(common_dir) / "agent-helm"), private=True) as parent:
        if digest is not None:
            try:
                os.mkdir("normalize-completions", 0o700, dir_fd=parent)
            except FileExistsError:
                pass
        fd = os.open("normalize-completions", os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=parent)
        try:
            locator.owned(os.fstat(fd), private=True)
            name = run_id + ".sha256"
            if remove:
                os.unlink(name, dir_fd=fd)
                os.fsync(fd)
                return
            flags = os.O_WRONLY | os.O_CREAT | os.O_EXCL if digest is not None else os.O_RDONLY
            opened = os.open(name, flags | os.O_NOFOLLOW | os.O_NONBLOCK, 0o600, dir_fd=fd)
            with os.fdopen(opened, "wb" if digest is not None else "rb") as stream:
                locator.owned(os.fstat(stream.fileno()), private=True, regular=True)
                if digest is not None:
                    stream.write((digest + "\n").encode("ascii"))
                    stream.flush()
                    os.fsync(stream.fileno())
                else:
                    raw = stream.read(66)
                    if not re.fullmatch(rb"[0-9a-f]{64}\n", raw):
                        raise Invalid("Invalid completion checksum")
                    return raw[:-1].decode("ascii")
            os.fsync(fd)
        finally:
            os.close(fd)


def inventory(fd, prefix="", result=None, depth=0):
    if result is None:
        result = {}
    if depth > MAX_DEPTH:
        raise Invalid("Recovery nesting exceeds the retention limit")
    with os.scandir(fd) as iterator:
        for item in iterator:
            if not prefix and item.name == RECEIPT:
                continue
            if len(result) >= MAX_FILES:
                raise Invalid("Recovery inventory exceeds the retention limit")
            name = prefix + item.name
            info = item.stat(follow_symlinks=False)
            if stat.S_ISDIR(info.st_mode):
                opened = os.open(item.name, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=fd)
                try:
                    current = os.fstat(opened)
                    locator.owned(current)
                    if (info.st_dev, info.st_ino) != (current.st_dev, current.st_ino):
                        raise Invalid("Recovery directory changed")
                    result[name + "/"] = {"mode": stat.S_IMODE(current.st_mode)}
                    inventory(opened, name + "/", result, depth + 1)
                finally:
                    os.close(opened)
            else:
                opened = os.open(item.name, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK, dir_fd=fd)
                with os.fdopen(opened, "rb") as stream:
                    before = os.fstat(stream.fileno())
                    locator.owned(before, regular=True)
                    if (info.st_dev, info.st_ino) != (before.st_dev, before.st_ino):
                        raise Invalid("Recovery file changed")
                    digest = hashlib.sha256()
                    while chunk := stream.read(1024 * 1024):
                        digest.update(chunk)
                    after = os.fstat(stream.fileno())
                    if (before.st_size, before.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
                        raise Invalid("Recovery file changed while reading")
                result[name] = {"size": before.st_size, "sha256": digest.hexdigest(),
                                "mode": stat.S_IMODE(before.st_mode)}
    return result


def inspect(common_dir):
    records, public, opaque = {}, [], False
    digest = hashlib.sha256()
    for kind, data, raw in registrations(common_dir):
        digest.update(kind.encode() + b"\0" + raw)
        if data is None:
            opaque = True
            public.append({"backup_kind": kind, "state": "unfinished_locator"})
            continue
        run_id = data["run_id"]
        hint = {"run_id": run_id, "backup_kind": kind}
        try:
            path = safe_run(data, kind)
            hint.update(recovery_directory=str(path), entrypoint=data["entrypoint"])
            with locator.directory(str(path), private=True) as run_fd:
                record, saved = read_receipt(run_fd)
            request_valid(record["request"], common_dir)
            if record["request"]["run_id"] != run_id:
                raise Invalid("Completion identity differs from its locator")
            if receipt_seal(common_dir, run_id) != hashlib.sha256(saved).hexdigest():
                raise Invalid("Completion receipt changed after recording")
            digest.update(saved)
            records[run_id] = (kind, data, record, saved)
            public.append(dict(hint, state="completed", completed_at=record["request"]["completed_at"],
                               required_runs=record["request"]["required_runs"]))
        except (OSError, ValueError):
            # No receipt, legacy/out-of-root runs and unsafe inputs cannot
            # establish completion or absence of cross-run dependencies.
            opaque = True
            public.append(dict(hint, state="protected_unclassified"))
    return records, public, digest.hexdigest(), opaque


def complete(common_dir, request, expected_digest):
    request_valid(request, common_dir)
    run_id = request["run_id"]
    with locator.writer_lock(common_dir):
        _, _, digest, _ = inspect(common_dir)
        if digest != expected_digest:
            raise Invalid("Recovery registry changed; preserve all backups")
        matches = [(kind, data) for kind, data, _ in registrations(common_dir)
                   if data is not None and data["run_id"] == run_id]
        if len(matches) != 1:
            raise Invalid("Completion needs one exact registered backup")
        kind, data = matches[0]
        path = safe_run(data, kind)
        with locator.directory(str(path), private=True) as fd:
            try:
                existing, _ = read_receipt(fd)
            except FileNotFoundError:
                pass
            else:
                if existing["request"] != request:
                    raise Invalid("Existing completion must not be replaced")
                if receipt_seal(common_dir, run_id) != hashlib.sha256(read_receipt(fd)[1]).hexdigest():
                    raise Invalid("Existing completion checksum differs")
                return {"status": "already_completed", "deleted_runs": [], "recovered_bytes": 0}
            info = os.fstat(fd)
            record = {"request": request, "root_identity": [info.st_dev, info.st_ino],
                      "inventory": inventory(fd)}
            raw = (json.dumps(record, sort_keys=True, ensure_ascii=True) + "\n").encode()
            if len(raw) > MAX_RECEIPT:
                raise Invalid("Completion inventory exceeds the size limit")
            temporary = ".pending-" + locator.secrets.token_hex(16)
            opened = os.open(temporary, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600, dir_fd=fd)
            try:
                with os.fdopen(opened, "wb") as stream:
                    stream.write(raw)
                    stream.flush()
                    os.fsync(stream.fileno())
                os.link(temporary, RECEIPT, src_dir_fd=fd, dst_dir_fd=fd, follow_symlinks=False)
            finally:
                os.unlink(temporary, dir_fd=fd)
            os.fsync(fd)
            if read_receipt(fd)[1] != raw:
                raise Invalid("Completion readback failed")
            receipt_seal(common_dir, run_id, hashlib.sha256(raw).hexdigest())
            if receipt_seal(common_dir, run_id) != hashlib.sha256(raw).hexdigest():
                raise Invalid("Completion checksum readback failed")
        return cleanup(common_dir)


def cleanup(common_dir):
    records, public, _, opaque = inspect(common_dir)
    result = {"status": "completed", "deleted_runs": [], "recovered_bytes": 0,
              "removed_backup_runs": [], "removed_locator_runs": [],
              "kept_completed": len(records), "protected_runs": []}
    if opaque:
        return dict(result, cleanup="skipped", reason="Unclassified or unfinished runs have unknown dependencies")
    if not getattr(shutil.rmtree, "avoids_symlink_attacks", False):
        return dict(result, cleanup="skipped", reason="Safe directory removal is unavailable")
    ordered = sorted(records, key=lambda run: (records[run][2]["request"]["completed_at"], run), reverse=True)
    keep = set(ordered[:KEEP])
    pending = list(keep)
    while pending:
        for required in records[pending.pop()][2]["request"]["required_runs"]:
            if required not in records:
                return dict(result, cleanup="skipped", reason="Required historical evidence is missing or unclassified")
            if required not in keep:
                keep.add(required)
                pending.append(required)
    result["protected_runs"] = sorted(keep - set(ordered[:KEEP]))
    # Validate the entire deletion set before its first removal. Changed or
    # added files are user work, not permission to delete a completed folder.
    selected = [run for run in reversed(ordered) if run not in keep]
    active_removal = None
    try:
        for run in selected:
            kind, data, record, saved = records[run]
            with locator.directory(str(safe_run(data, kind)), private=True) as fd:
                info = os.fstat(fd)
                if [info.st_dev, info.st_ino] != record["root_identity"] or read_receipt(fd)[1] != saved or inventory(fd) != record["inventory"]:
                    raise Invalid("Recovery contents changed after completion")
        for run in selected:
            kind, data, record, saved = records[run]
            with locator.directory(str(root_directory(kind)), private=True) as parent_fd, locator.registry(common_dir, name=REGISTRIES[kind]) as registry_fd:
                current, _ = locator.load(registry_fd, run + ".json")
                if current != data:
                    raise Invalid("Recovery pointer changed before cleanup")
                with locator.directory(str(safe_run(data, kind)), private=True) as fd:
                    info = os.fstat(fd)
                    if [info.st_dev, info.st_ino] != record["root_identity"] or read_receipt(fd)[1] != saved or inventory(fd) != record["inventory"]:
                        raise Invalid("Recovery changed before cleanup")
                # Claim a fresh private staging container atomically, then
                # verify the renamed root. A replaced original path is kept,
                # never recursively removed on the strength of an earlier fd.
                staging = ".retiring-" + run
                os.mkdir(staging, 0o700, dir_fd=parent_fd)
                result["pending_retirement_directory"] = str(root_directory(kind) / staging)
                active_removal = run
                staging_fd = os.open(staging, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=parent_fd)
                try:
                    locator.owned(os.fstat(staging_fd), private=True)
                    os.rename(run, "backup", src_dir_fd=parent_fd, dst_dir_fd=staging_fd)
                    with locator.directory(str(root_directory(kind) / staging / "backup"), private=True) as fd:
                        info = os.fstat(fd)
                        if [info.st_dev, info.st_ino] != record["root_identity"] or read_receipt(fd)[1] != saved or inventory(fd) != record["inventory"]:
                            raise Invalid("Claimed recovery root differs from the completed run")
                    shutil.rmtree("backup", dir_fd=staging_fd)
                    if os.listdir(staging_fd):
                        raise Invalid("Retirement container changed")
                    result["removed_backup_runs"].append(run)
                    result["recovered_bytes"] += sum(item.get("size", 0) for item in record["inventory"].values()) + len(saved)
                finally:
                    os.close(staging_fd)
                os.rmdir(staging, dir_fd=parent_fd)
                os.unlink(run + ".json", dir_fd=registry_fd)
                result["removed_locator_runs"].append(run)
                os.fsync(registry_fd)
                receipt_seal(common_dir, run, remove=True)
                result["deleted_runs"].append(run)
                active_removal = None
                result.pop("pending_retirement_directory", None)
        result["kept_completed"] = len(records) - len(result["deleted_runs"])
        result["cleanup"] = "finished"
    except (OSError, ValueError):
        result.update(cleanup="incomplete", reason="Cleanup stopped after a file, path or I/O check failed; inspect actual retained state")
        result["kept_completed"] = len(records) - len(result["removed_backup_runs"])
        if active_removal and active_removal not in result["removed_backup_runs"]:
            result["uncertain_run"] = active_removal
            result["kept_completed"] = None
            result["recovered_bytes_are_lower_bound"] = True
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("inspect", "complete", "register-ship"))
    parser.add_argument("--git-common-dir", required=True)
    parser.add_argument("--expect-digest")
    parser.add_argument("--run-id")
    parser.add_argument("--recovery-directory")
    parser.add_argument("--entrypoint")
    args = parser.parse_args()
    try:
        registration = (args.run_id, args.recovery_directory, args.entrypoint)
        if args.action != "register-ship" and any(registration):
            raise Invalid("Registration arguments require register-ship")
        if args.action == "register-ship":
            if not all(registration) or args.expect_digest is not None:
                raise Invalid("Ship registration requires exact identity and paths")
            result = register_ship(args.git_common_dir, {"run_id": args.run_id,
                "recovery_directory": args.recovery_directory, "entrypoint": args.entrypoint})
        elif args.action == "inspect":
            if args.expect_digest is not None:
                raise Invalid("Inspect accepts only the Git common directory")
            _, runs, digest, _ = inspect(args.git_common_dir)
            result = {"runs": runs, "digest": digest}
        else:
            if not args.expect_digest or not re.fullmatch(r"[0-9a-f]{64}", args.expect_digest):
                raise Invalid("Completion requires the inspected registry digest")
            raw = sys.stdin.buffer.read(262145)
            if len(raw) > 262144:
                raise Invalid("Completion request exceeds the size limit")
            request = json.loads(raw.decode("utf-8"), object_pairs_hook=locator.unique)
            result = complete(args.git_common_dir, request, args.expect_digest)
        print(json.dumps(result, ensure_ascii=True))
        return 0
    except (OSError, ValueError, TypeError, RecursionError):
        # Private record/configuration contents and arbitrary path errors must
        # not enter chat/logs. Publication remains a separately verified result.
        print(json.dumps({"status": "retention_pending", "reason": "Retention validation or I/O failed; preserve evidence and report cleanup separately"}))
        return 2


if __name__ == "__main__":
    sys.exit(main())
