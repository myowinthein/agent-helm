"""Bounded dotenv key projection on stdin/stdout; never emit existing values.

Lexical extraction only, not a loader, syntax certificate or environment audit.
No files, subprocesses, imports of consumer code, network, writes or execution.
"""

import json
import re
import sys

MAX_INPUT = 1024 * 1024
MAX_OUTPUT = 64 * 1024
ASSIGNMENT = re.compile(r"\s*(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=(.*)")


class Unsupported(ValueError):
    def __init__(self, line=None, reason="Unsupported dotenv syntax"):
        self.line = line
        self.reason = reason


def closing_quote(text, quote, start):
    escaped = False
    for index in range(start, len(text)):
        char = text[index]
        if escaped:
            escaped = False
        elif char == "\\":
            escaped = True
        elif char == quote:
            return index
    return None


def classification(value):
    value = value.strip()
    if not value:
        return "empty"
    if value.lower() in ("null", "(null)"):
        return "null_like"
    if re.search(r"change[_-]?me|replace[_-]?me|your[_-]|example\.com|<[^>]+>", value, re.I):
        return "placeholder_like"
    return "present_unverified"


def project(raw):
    if len(raw) > MAX_INPUT:
        raise Unsupported(reason="Dotenv input exceeds 1 MiB")
    if b"\0" in raw:
        raise Unsupported(reason="Binary dotenv input is unsupported")
    try:
        text = raw.decode("utf-8-sig")
    except UnicodeError:
        raise Unsupported(reason="Expected UTF-8 dotenv input") from None
    keys, quote, opening = [], None, None
    for number, line in enumerate(text.split("\n"), 1):
        line = line.removesuffix("\r")
        if quote:
            end = closing_quote(line, quote, 0)
            if end is None:
                continue
            tail = line[end + 1:].strip()
            if tail and not tail.startswith("#"):
                raise Unsupported(number)
            quote = None
            continue  # A continuation's assignment-looking text is never a key.
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        match = ASSIGNMENT.fullmatch(line)
        if not match:
            raise Unsupported(number)
        key, value = match.groups()
        value = value.lstrip() if value.lstrip().startswith(("'", '"')) else value
        if value.startswith(("'", '"')):
            end = closing_quote(value, value[0], 1)
            if end is None:
                quote, opening = value[0], number
                kind = "multiline_unassessed"
            else:
                tail = value[end + 1:].strip()
                if tail and not tail.startswith("#"):
                    raise Unsupported(number)
                kind = classification(value[1:end])
        else:
            # Do not guess shell continuation, mixed quoting or heredoc dialects.
            value = re.split(r"\s+#", value, maxsplit=1)[0]
            if "'" in value or '"' in value or value.rstrip().endswith("\\") or "<<" in value:
                raise Unsupported(number)
            kind = classification(value)
        keys.append({"key": key, "line": number, "classification": kind})
    if quote:
        raise Unsupported(opening)
    return {"interface_version": 1, "keys": keys, "loader_validation": False}


def main():
    try:
        if len(sys.argv) != 1:
            raise Unsupported(reason="Pass dotenv bytes on stdin without arguments")
        result = project(sys.stdin.buffer.read(MAX_INPUT + 1))
        encoded = json.dumps(result, ensure_ascii=True).encode("ascii")
        if len(encoded) > MAX_OUTPUT:
            raise Unsupported(reason="Dotenv key projection exceeds 64 KiB")
    except Unsupported as error:
        diagnostic = {"interface_version": 1, "error": error.reason}
        if error.line is not None:
            diagnostic["line"] = error.line
        print(json.dumps(diagnostic), file=sys.stderr)
        return 2
    sys.stdout.buffer.write(encoded + b"\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
