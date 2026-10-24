"""Strict JSON and read-only, bounded file access; never import consumer code."""

from contextlib import ExitStack
from decimal import Decimal
import hashlib
import json
import os
from pathlib import Path
import stat


class Problem(Exception):
    def __init__(self, kind, message, location=None):
        super().__init__(message)
        self.kind = kind
        self.location = location


def require(condition, message, location=None, kind="invalid_input"):
    if not condition:
        raise Problem(kind, message, location)


def encode(value):
    """Keep unknown JSON numbers numeric and exact in retrieved records."""
    if isinstance(value, Decimal):
        return str(value)
    if isinstance(value, dict):
        return "{" + ",".join(encode(key) + ":" + encode(item) for key, item in value.items()) + "}"
    if isinstance(value, list):
        return "[" + ",".join(encode(item) for item in value) + "]"
    return json.dumps(value, ensure_ascii=False, allow_nan=False)


def loads(raw, limits, kind):
    def unique(pairs):
        value = {}
        for key, item in pairs:
            require(key not in value, "Duplicate JSON key", "json", kind)
            value[key] = item
        return value

    def reject_constant(_):
        raise Problem(kind, "Non-finite JSON number", "json")

    try:
        # UTF-8 BOMs are rejected rather than silently normalised.
        value = json.loads(raw.decode("utf-8"), object_pairs_hook=unique,
                           parse_float=Decimal, parse_constant=reject_constant)
    except (UnicodeError, ValueError, ArithmeticError, RecursionError):
        raise Problem(kind, "Expected complete UTF-8 JSON within parser limits", "json") from None
    pending = [(value, 0)]
    nodes = 0
    while pending:
        item, depth = pending.pop()
        nodes += 1
        require(depth <= limits["depth"] and nodes <= limits["nodes"],
                "JSON nesting or node limit exceeded", "json", kind)
        if isinstance(item, str):
            require(not any(0xD800 <= ord(char) <= 0xDFFF for char in item),
                    "JSON contains an unpaired Unicode surrogate", "json", kind)
        elif isinstance(item, dict):
            pending.extend((child, depth + 1) for pair in item.items() for child in pair)
        elif isinstance(item, list):
            pending.extend((child, depth + 1) for child in item)
    return value


def identity(info):
    return info.st_dev, info.st_ino, info.st_mode


def file_identity(info):
    return identity(info), info.st_size, info.st_mtime_ns, info.st_ctime_ns


def metadata(root, parts):
    """lstat each component; never traverse a symlink/junction or special file."""
    current = root
    for index, name in enumerate(parts):
        current = current / name
        try:
            info = current.lstat()
        except FileNotFoundError:
            return None
        require(not stat.S_ISLNK(info.st_mode) and not getattr(info, "st_reparse_tag", 0),
                "Symlink or reparse point blocks ledger access", "path", "unsupported_state")
        if index < len(parts) - 1:
            require(stat.S_ISDIR(info.st_mode), "Conflicting parent blocks ledger access",
                    "path", "unsupported_state")
        else:
            require(stat.S_ISREG(info.st_mode), "Expected a regular file",
                    "path", "unsupported_state")
    return info


def read_file(root, parts, limit):
    before = metadata(root, parts)
    if before is None:
        return None
    require(before.st_size <= limit, "File byte limit exceeded", "ledger", "invalid_state")
    parents = [(root, identity(root.lstat()))]
    current = root
    for name in parts[:-1]:
        current = current / name
        info = current.lstat()
        require(stat.S_ISDIR(info.st_mode) and not getattr(info, "st_reparse_tag", 0),
                "Parent changed before reading", "path", "conflict")
        parents.append((current, identity(info)))
    flags = os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0) | getattr(os, "O_NONBLOCK", 0) | getattr(os, "O_BINARY", 0)
    with ExitStack() as stack:
        if os.open in os.supports_dir_fd and hasattr(os, "O_DIRECTORY") and hasattr(os, "O_NOFOLLOW"):
            directory_flags = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW
            parent_fd = os.open(root, directory_flags)
            stack.callback(os.close, parent_fd)
            require(identity(os.fstat(parent_fd)) == parents[0][1],
                    "Workspace changed before reading", "path", "conflict")
            for index, name in enumerate(parts[:-1]):
                parent_fd = os.open(name, directory_flags, dir_fd=parent_fd)
                stack.callback(os.close, parent_fd)
                require(identity(os.fstat(parent_fd)) == parents[index + 1][1],
                        "Parent changed before reading", "path", "conflict")
            descriptor = os.open(parts[-1], flags, dir_fd=parent_fd)
        else:
            descriptor = os.open(root.joinpath(*parts), flags)
        with os.fdopen(descriptor, "rb") as handle:
            opened = os.fstat(handle.fileno())
            require(stat.S_ISREG(opened.st_mode) and file_identity(opened) == file_identity(before)
                    and all(identity(path.lstat()) == stamp for path, stamp in parents),
                    "File or parent changed before reading; repeat preflight", "ledger", "conflict")
            raw = handle.read(limit + 1)
            require(file_identity(os.fstat(handle.fileno())) == file_identity(before),
                    "File changed while reading; repeat preflight", "ledger", "conflict")
    after = metadata(root, parts)
    require(after is not None and file_identity(after) == file_identity(before)
            and all(identity(path.lstat()) == stamp for path, stamp in parents),
            "File or parent changed while reading; repeat preflight", "ledger", "conflict")
    require(len(raw) <= limit, "File byte limit exceeded", "ledger", "invalid_state")
    return raw


def workspace(value, package_root):
    require(isinstance(value, str) and not any(ord(char) < 32 for char in value) and Path(value).is_absolute(),
            "workspace must be an absolute existing directory", "workspace")
    root = Path(value).resolve(strict=True)
    require(root.is_dir(), "workspace must be an existing directory", "workspace")
    require(root != package_root and package_root not in root.parents,
            "Consumer workspace must be outside the loaded package", "workspace")
    return root


def tripwire(root, filename):
    # Only this owner's known unsupported locations; existence checks read no bytes.
    for parts in [(".claude", "helm", filename), (".claude", filename)]:
        require(metadata(root, parts) is None,
                "Unsupported state path exists; preserve it and follow the upgrade guide",
                "path", "unsupported_state")


def digest(raw):
    return hashlib.sha256(raw).hexdigest()
