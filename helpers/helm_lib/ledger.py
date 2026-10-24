"""Validate and retrieve one current ledger. No writer, subprocess or network."""

from collections import Counter
from datetime import date
from pathlib import Path
import re
import sys

from .common import Problem, digest, encode, loads, read_file, require, tripwire, workspace


PACKAGE_ROOT = Path(__file__).resolve().parents[2]
# The fixed package contract is small; this cap also bounds parsing before its limits load.
CONTRACT_BYTES = 262144
BOOTSTRAP_LIMITS = {"depth": 64, "nodes": 50000}
EXIT_CODES = {"invalid_input": 2, "runtime_unavailable": 3, "invalid_state": 4,
              "unsupported_state": 4, "conflict": 5, "io_error": 6, "internal_error": 7}


def contract():
    raw = read_file(PACKAGE_ROOT, ("helpers", "ledger-contract.json"), CONTRACT_BYTES)
    require(raw is not None, "Missing bundled ledger contract; repair the package", kind="internal_error")
    value = loads(raw, BOOTSTRAP_LIMITS, "internal_error")
    require(isinstance(value, dict) and type(value.get("interface_version")) is int
            and value["interface_version"] == 1,
            "Unsupported bundled helper contract; repair the package", kind="internal_error")
    require(set(value["owners"]) == {"refactor", "test"}
            and all(spec["filename"] == owner + "-log.json" for owner, spec in value["owners"].items()),
            "Invalid bundled owner path mapping; repair the package", kind="internal_error")
    return value


def shape(value, rule, definitions, location):
    require(not set(rule) - {"ref", "type", "enum", "nonblank", "format", "min_items", "unique", "items", "required", "properties"},
            "Unsupported bundled structural rule; repair the package", kind="internal_error")
    if "ref" in rule:
        require(set(rule) == {"ref"}, "Invalid bundled structural reference", kind="internal_error")
        return shape(value, definitions[rule["ref"]], definitions, location)
    require(rule.get("format") in (None, "commit", "date", "path"),
            "Unsupported bundled field format", kind="internal_error")
    types = rule["type"] if isinstance(rule["type"], list) else [rule["type"]]
    checks = {"object": isinstance(value, dict), "array": isinstance(value, list),
              "string": isinstance(value, str), "integer": type(value) is int, "null": value is None}
    require(any(checks[kind] for kind in types), "Incorrect field type", location, "invalid_state")
    if value is None:
        return
    require("enum" not in rule or value in rule["enum"], "Unsupported field value", location, "invalid_state")
    if isinstance(value, str):
        require(not rule.get("nonblank") or bool(value.strip()), "Expected nonempty text", location, "invalid_state")
        if rule.get("format") == "commit":
            require(re.fullmatch(r"(?:[0-9a-fA-F]{40}|[0-9a-fA-F]{64})", value) is not None,
                    "Expected a full literal commit identity", location, "invalid_state")
        elif rule.get("format") == "date":
            try:
                require(re.fullmatch(r"[0-9]{4}-[0-9]{2}-[0-9]{2}", value) is not None,
                        "Expected YYYY-MM-DD", location, "invalid_state")
                date.fromisoformat(value)
            except ValueError:
                raise Problem("invalid_state", "Invalid calendar date", location) from None
        elif rule.get("format") == "path":
            require(bool(value) and not re.match(r"^[A-Za-z]:", value)
                    and "\\" not in value and not any(ord(char) < 32 for char in value)
                    and all(part not in ("", ".", "..") for part in value.split("/")),
                    "Expected a project-relative slash-separated path", location, "invalid_state")
    elif isinstance(value, list):
        require(len(value) >= rule.get("min_items", 0), "Array has too few items", location, "invalid_state")
        if rule.get("unique"):
            require(len(value) == len({encode(item) for item in value}),
                    "Duplicate array item", location, "invalid_state")
        for index, item in enumerate(value):
            shape(item, rule["items"], definitions, f"{location}[{index}]")
    elif isinstance(value, dict):
        for key in rule.get("required", []):
            require(key in value, "Missing required field", f"{location}.{key}", "invalid_state")
        for key, child in rule.get("properties", {}).items():
            if key in value:
                shape(value[key], child, definitions, f"{location}.{key}")


def validate(document, owner, spec, definitions, limits):
    shape(document, spec["schema"], definitions, "ledger")
    records = document[spec["records"]]
    require(len(records) <= limits["records"], "Record limit exceeded", "ledger", "invalid_state")
    ids = {record["id"] for record in records}
    require(len(ids) == len(records), "Duplicate record ID", spec["records"], "invalid_state")
    predecessors = {}
    for index, record in enumerate(records):
        location = f"{spec['records']}[{index}]"
        closure = record.get("closure")
        require((record["state"] == "open") == (closure is None),
                "Open records have no closure; closed records require one", location, "invalid_state")
        if owner == "refactor":
            require(all(item in ids and item != record["id"] for item in record["depends_on"]),
                    "Dependency must name another existing finding", location + ".depends_on", "invalid_state")
            if "recurrence_of" in record:
                require(record["recurrence_of"] in ids and record["recurrence_of"] != record["id"],
                        "Recurrence must name another existing finding", location + ".recurrence_of", "invalid_state")
                predecessors[record["id"]] = record["recurrence_of"]
            if record["state"] == "open" and record["assessment"]["priority"] == "unknown":
                require(record.get("blocker", {}).get("kind") == "clarification",
                        "Open unknown priority requires a clarification blocker", location, "invalid_state")
            if closure is not None:
                require((record["state"] == "resolved") == (closure["kind"] == "fixed"),
                        "Closure kind does not match state", location + ".closure", "invalid_state")
                require(closure["method"] != "runtime" or bool(closure.get("checks")),
                        "Runtime closure requires actual checks", location + ".closure.checks", "invalid_state")
        elif closure is not None:
            require("blocker" not in record, "Closed test cases cannot retain an active blocker", location, "invalid_state")
            require((record["state"] == "obsolete") == (closure["reason"] == "obsolete"),
                    "Closure reason does not match state", location + ".closure.reason", "invalid_state")
            require(closure["method"] != "runtime" or all(key in closure for key in ("command", "scope")),
                    "Runtime closure requires command and scope", location + ".closure", "invalid_state")
    finished = set()
    for start in predecessors:
        seen = set()
        current = start
        while current in predecessors and current not in finished:
            require(current not in seen, "Recurrence cycle", "findings.recurrence_of", "invalid_state")
            seen.add(current)
            current = predecessors[current]
        finished.update(seen)
    return records


def filters(request, owner, definitions, limits):
    selected = request.get("filters", {})
    allowed = {"ids", "paths", "states", "priorities", "terms"}
    if owner == "refactor":
        allowed.update(("categories", "risks"))
    require(isinstance(selected, dict) and not set(selected) - allowed,
            "Unknown or unsupported view filter", "filters")
    enums = {"states": "state", "priorities": "priority", "categories": "category", "risks": "risk"}
    for key, values in selected.items():
        require(isinstance(values, list) and 0 < len(values) <= limits["page_max"]
                and all(isinstance(value, str) and value.strip() for value in values),
                "Filters require a bounded nonempty string array", "filters")
        if key in enums:
            require(set(values) <= set(definitions[enums[key]]["enum"]),
                    "Unsupported filter value", "filters")
    return selected


def matching(record, owner, selected):
    assessment = record["assessment"] if owner == "refactor" else record
    fields = {"ids": record["id"], "states": record["state"], "priorities": assessment["priority"]}
    if owner == "refactor":
        fields.update(categories=record["category"], risks=assessment["risk"])
    if any(key in selected and value not in selected[key] for key, value in fields.items()):
        return False
    if "paths" in selected and not any(path == prefix or path.startswith(prefix.rstrip("/") + "/")
                                       for path in record["paths"] for prefix in selected["paths"]):
        return False
    # Literal text retrieval is deliberately broad, including custom evidence fields.
    if "terms" in selected:
        terms = [term.casefold() for term in selected["terms"]]
        pending = [record]
        while pending:
            value = pending.pop()
            if isinstance(value, str) and any(term in value.casefold() for term in terms):
                return True
            if isinstance(value, dict):
                pending.extend(child for pair in value.items() for child in pair)
            elif isinstance(value, list):
                pending.extend(value)
        return False
    return True


def index_row(record, owner):
    assessment = record["assessment"] if owner == "refactor" else record
    result = {"id": record["id"], "state": record["state"], "paths": record["paths"],
              "priority": assessment["priority"],
              "assessed_commit": assessment["commit"] if owner == "refactor" else record["assessed_commit"],
              "held": record["state"] == "open" and "decision" in record,
              "blocked": record["state"] == "open" and "blocker" in record}
    if owner == "refactor":
        result.update(category=record["category"], risk=assessment["risk"], summary=record["summary"],
                      depends_on=record["depends_on"])
        if "recurrence_of" in record:
            result["recurrence_of"] = record["recurrence_of"]
    else:
        result.update(expected=record["expected"], action=record["action"])
    return result


def execute(command, request, settings):
    require(command in ("ledger-check", "ledger-view"), "Expected ledger-check or ledger-view")
    allowed = {"interface_version", "owner", "workspace", "expected_digest"}
    if command == "ledger-view":
        allowed.update(("filters", "offset", "limit", "projection"))
    require(isinstance(request, dict) and not set(request) - allowed
            and {"interface_version", "owner", "workspace"} <= set(request),
            "Incorrect request fields")
    require(type(request["interface_version"]) is int and request["interface_version"] == 1,
            "Unsupported helper interface version", "interface_version")
    owner = request["owner"]
    require(isinstance(owner, str) and owner in settings["owners"], "Expected refactor or test owner", "owner")
    spec = settings["owners"][owner]
    limits = settings["limits"]
    expected = request.get("expected_digest")
    require((expected is None and command == "ledger-check" and "expected_digest" not in request)
            or isinstance(expected, str) and re.fullmatch(r"[0-9a-f]{64}", expected) is not None,
            "View/revalidation requires the previous check's SHA-256", "expected_digest")
    if command == "ledger-view":
        selected = filters(request, owner, settings["definitions"], limits)
        offset, limit = request.get("offset", 0), request.get("limit", limits["page_default"])
        require(type(offset) is int and 0 <= offset <= limits["records"]
                and type(limit) is int and 1 <= limit <= limits["page_max"],
                "Invalid page bounds", "page")
        require(request.get("projection", "index") in ("index", "records"), "Invalid projection", "projection")
    root = workspace(request["workspace"], PACKAGE_ROOT)
    tripwire(root, spec["filename"])
    raw = read_file(root, (".helm", spec["filename"]), limits["ledger_bytes"])
    actual = digest(raw) if raw is not None else None
    require(expected is None or expected == actual, "Ledger changed; repeat owning preflight", "expected_digest", "conflict")
    result = {"status": "missing" if raw is None else "valid", "path": ".helm/" + spec["filename"],
              "sha256": actual, "schema_version": spec["schema_version"],
              "source_review": False, "runtime_verification": False, "human_authorization": False}
    if raw is None:
        result.update(records_total=0, structurally_validated=False)
    else:
        document = loads(raw, limits, "invalid_state")
        records = validate(document, owner, spec, settings["definitions"], limits)
        result.update(structurally_validated=True, records_total=len(records),
                      anchors={key: document.get(key) for key in ("assessed_commit", "full_scan_commit")})
        if command == "ledger-check":
            result["counts"] = {"states": dict(Counter(item["state"] for item in records)),
                                "priorities": dict(Counter((item["assessment"] if owner == "refactor" else item)["priority"]
                                                           for item in records)),
                                "with_decisions": sum("decision" in item for item in records),
                                "with_blockers": sum("blocker" in item for item in records)}
        else:
            matches = [record for record in records if matching(record, owner, selected)]
            page = matches[offset:offset + limit]
            result.update(total_matched=len(matches), offset=offset, returned=len(page),
                          next_offset=offset + len(page) if offset + len(page) < len(matches) else None,
                          projection=request.get("projection", "index"),
                          records=page if request.get("projection") == "records" else [index_row(item, owner) for item in page])
    tripwire(root, spec["filename"])
    return {"interface_version": 1, "owner": owner, "result": result}


def run(arguments):
    try:
        settings = contract()
        require(len(arguments) == 1, "Pass one operation and a JSON request on stdin")
        raw = sys.stdin.buffer.read(settings["limits"]["request_bytes"] + 1)
        require(len(raw) <= settings["limits"]["request_bytes"], "Request byte limit exceeded")
        result = execute(arguments[0], loads(raw, settings["limits"], "invalid_input"), settings)
        output = (encode(result) + "\n").encode("utf-8")
        require(len(output) <= settings["limits"]["response_bytes"],
                "Response byte limit exceeded; narrow filters, reduce limit or use index projection", "page")
        sys.stdout.buffer.write(output)
        return 0
    except Problem as error:
        failure = {"kind": error.kind, "message": str(error)}
        if error.location is not None:
            failure["location"] = error.location
        code = EXIT_CODES[error.kind]
    except OSError:
        failure, code = {"kind": "io_error", "message": "Read failed; inspect path availability and permissions without exposing content"}, 6
    except Exception:
        failure, code = {"kind": "internal_error", "message": "Bundled helper failed; stop dependent work and report a defect"}, 7
    sys.stderr.write(encode({"interface_version": 1, "error": failure}) + "\n")
    return code
