"""Pure, read-only normalize mechanics. JSON stdin/stdout; no Git, files or network.

The caller owns policy resolution, Git object collection, secret-safe presentation,
semantic review and state writes. A mechanical pass is never semantic acceptance.
"""

import argparse
from collections import deque
from datetime import date
import hashlib
import json
import re
import sys

sys.dont_write_bytecode = True

REVIEW_CONTRACT = 1
MAX_BYTES = 32 * 1024 * 1024
MAX_COMMITS = 100_000
MAX_MESSAGE_BYTES = 1024 * 1024
OID = re.compile(r"(?:[0-9a-f]{40}|[0-9a-f]{64})\Z")
HEADER = re.compile(r"([^\s():!]+)(?:\(([^()\r\n]+)\))?(!)?: (\S.*)\Z")
RULES = {"types", "scope_required", "scopes", "type_case_sensitive", "header_max_length"}


class Invalid(ValueError):
    """Messages are fixed diagnostics, never raw input or parser excerpts."""


def require(condition, message):
    if not condition:
        raise Invalid(message)


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True)


def digest(value):
    return hashlib.sha256(canonical(value).encode("ascii")).hexdigest()


def object_pairs(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, "Duplicate JSON key")
        result[key] = value
    return result


def branch_name(name):
    return (isinstance(name, str) and bool(name) and name != "@"
            and not re.search(r"[\x00-\x20\x7f~^:?*\[\\]", name)
            and ".." not in name and "@{" not in name
            and not name.startswith(("-", "/")) and not name.endswith(("/", "."))
            and all(part and not part.startswith(".") and not part.endswith(".lock")
                    for part in name.split("/")))


def validate_ledger(ledger):
    require(isinstance(ledger, dict) and type(ledger.get("schema_version")) is int
            and ledger["schema_version"] == 2, "Normalize requires schema 2")
    branches = ledger.get("branches")
    require(isinstance(branches, dict) and len(branches) <= 256, "Invalid branch records")
    for name, record in branches.items():
        require(branch_name(name) and isinstance(record, dict), "Invalid branch record")
        require(isinstance(record.get("last_checked_commit"), str)
                and OID.fullmatch(record["last_checked_commit"]), "Invalid baseline commit")
        stamp = record.get("last_checked_date")
        require(isinstance(stamp, str), "Invalid baseline date")
        try:
            require(date.fromisoformat(stamp).isoformat() == stamp, "Invalid baseline date")
        except ValueError:
            raise Invalid("Invalid baseline date") from None
        require(record.get("review_kind") == "semantic", "Baseline must record semantic review")
        require(type(record.get("review_contract")) is int and record["review_contract"] > 0,
                "Invalid review contract")
        fingerprint = record.get("policy_fingerprint")
        require(isinstance(fingerprint, str) and re.fullmatch(r"[0-9a-f]{64}", fingerprint),
                "Invalid policy fingerprint")
    return ledger  # Unknown fields are data; never strip them for a future writer.


def policy_info(policy):
    require(isinstance(policy, dict) and type(policy.get("resolved")) is bool
            and isinstance(policy.get("rules"), dict)
            and isinstance(policy.get("semantic_rules"), list)
            and all(isinstance(rule, str) for rule in policy["semantic_rules"]),
            "Invalid effective policy")
    rules = policy["rules"]
    for key in ("types", "scopes"):
        value = rules.get(key)
        require(value is None or (isinstance(value, list)
                                 and all(isinstance(item, str) and item for item in value)),
                "Invalid policy enumeration")
    for key in ("scope_required", "type_case_sensitive"):
        require(type(rules.get(key)) is bool, "Missing policy boolean")
    limit = rules.get("header_max_length")
    require(limit is None or (type(limit) is int and limit > 0), "Invalid header limit")
    # These two enumerations are membership sets, not precedence lists. Keep
    # semantic/unknown fields exact: their ordering or wording can carry meaning.
    normalized = dict(policy)
    normalized["rules"] = dict(rules)
    for key in ("types", "scopes"):
        values = rules.get(key)
        if values is not None:
            if key == "types" and not rules["type_case_sensitive"]:
                values = [value.lower() for value in values]
            normalized["rules"][key] = sorted(set(values))
    return digest(normalized), sorted(set(rules) - RULES)


def precheck(message, rules, unsupported, resolved):
    require(isinstance(message, str), "Missing full message")
    try:
        size = len(message.encode("utf-8"))
    except UnicodeError:
        raise Invalid("Unsupported message encoding") from None
    require(size <= MAX_MESSAGE_BYTES and "\0" not in message, "Invalid message size/content")
    lines = message.splitlines()
    header = lines[0] if lines else ""
    match = HEADER.fullmatch(header)
    findings = []
    breaking = False
    if not match:
        findings.append("header_grammar")
    else:
        kind, scope, bang = match.group(1, 2, 3)
        breaking = bool(bang)
        kinds = rules.get("types")
        if kinds is not None:
            if not rules["type_case_sensitive"]:
                kind, kinds = kind.lower(), [item.lower() for item in kinds]
            if kind not in kinds:
                findings.append("type_policy")
        if rules["scope_required"] and not scope:
            findings.append("scope_required")
        if scope and rules.get("scopes") is not None and scope not in rules["scopes"]:
            findings.append("scope_policy")
    if rules.get("header_max_length") and len(header) > rules["header_max_length"]:
        findings.append("header_length")
    if len(lines) > 1 and lines[1].strip():
        findings.append("body_separator")
    for line in lines[1:]:
        if re.match(r"^BREAKING(?: CHANGE|-CHANGE): \S", line):
            breaking = True
    return {"syntax": "findings" if findings else "unresolved" if unsupported or not resolved else "pass",
            "diagnostics": findings, "formal_breaking_marker": breaking,
            "semantic": "not_reviewed"}


def graph_order(commits):
    require(isinstance(commits, list) and len(commits) <= MAX_COMMITS, "Invalid graph size")
    graph = {}
    for commit in commits:
        require(isinstance(commit, dict), "Invalid commit record")
        oid, parents = commit.get("id"), commit.get("parents")
        require(isinstance(oid, str) and OID.fullmatch(oid) and oid not in graph,
                "Invalid or duplicate commit ID")
        require(isinstance(parents, list) and len(parents) <= 1024
                and all(isinstance(p, str) and OID.fullmatch(p) for p in parents)
                and len(set(parents)) == len(parents), "Invalid parents")
        graph[oid] = parents
    children = {oid: [] for oid in graph}
    degree = {oid: len(parents) for oid, parents in graph.items()}
    for oid, parents in graph.items():
        for parent in parents:
            require(parent in graph, "Incomplete parent graph")
            children[parent].append(oid)
    ready = deque(oid for oid in graph if not degree[oid])
    order = []
    while ready:
        oid = ready.popleft()
        order.append(oid)
        for child in children[oid]:
            degree[child] -= 1
            if not degree[child]:
                ready.append(child)
    require(len(order) == len(graph), "Cyclic parent graph")
    return graph, order


def reachable(graph, tip):
    require(tip in graph, "Missing requested tip")
    seen, pending = set(), [tip]
    while pending:
        oid = pending.pop()
        if oid in seen:
            continue
        seen.add(oid)
        pending.extend(graph[oid])
    return seen


def plan_review(payload, fingerprint):
    graph, order = graph_order(payload.get("commits"))
    tips = payload.get("tips")
    require(isinstance(tips, dict) and 0 < len(tips) <= 256
            and all(branch_name(name) and isinstance(tip, str) and OID.fullmatch(tip)
                    for name, tip in tips.items()), "Invalid requested tips")
    ledger = payload.get("ledger")
    records = validate_ledger(ledger)["branches"] if ledger is not None else {}
    recheck = payload.get("recheck_ids", [])
    require(isinstance(recheck, list) and all(isinstance(oid, str) and oid in graph for oid in recheck),
            "Invalid recheck IDs")
    recheck = set(recheck)
    selected, needs = set(), set()
    branches = {}
    for name, tip in tips.items():
        history = reachable(graph, tip)
        selected.update(history)
        record, covered, status = records.get(name), set(), "no_baseline"
        if record:
            if not payload["policy"]["resolved"]:
                status = "unresolved_policy"
            elif record["review_contract"] != REVIEW_CONTRACT:
                status = "review_contract_changed"
            elif record["policy_fingerprint"] != fingerprint:
                status = "policy_changed"
            elif record["last_checked_commit"] not in history:
                status = "baseline_not_ancestor"
            else:
                covered = reachable(graph, record["last_checked_commit"])
                status = "reused"
                if covered & recheck:
                    covered, status = set(), "baseline_invalidated"
        remaining = history - covered
        needs.update(remaining)
        branches[name] = {"baseline_status": status, "selected": len(history),
                          "reused": len(covered), "needs_semantic": len(remaining)}
    # A branch's unproven membership wins over another branch's reusable baseline.
    ids = [oid for oid in order if oid in needs]
    return {"counts": {"selected": len(selected), "reused": len(selected - needs),
                       "needs_semantic": len(ids)}, "branches": branches}, ids


def execute(payload, operation, offset=0, limit=100, expected_digest=None):
    require(isinstance(payload, dict), "Expected JSON object")
    require(type(offset) is int and offset >= 0 and type(limit) is int and 1 <= limit <= 200,
            "Invalid page bounds")
    require(offset == 0 or expected_digest is not None, "Continuation requires the first page digest")
    fingerprint, unsupported = policy_info(payload.get("policy"))
    identity = digest({"operation": operation, "payload": payload})
    require(expected_digest is None or expected_digest == identity, "Input changed between pages")
    result = {"interface_version": 1, "review_contract": REVIEW_CONTRACT,
              "input_digest": identity, "policy_fingerprint": fingerprint,
              "unsupported_rules": unsupported}
    if operation == "plan":
        summary, records = plan_review(payload, fingerprint)
        result.update(summary)
    elif operation == "check":
        commits = payload.get("commits")
        require(isinstance(commits, list) and len(commits) <= MAX_COMMITS, "Invalid commit list")
        seen, records = set(), []
        for commit in commits:
            require(isinstance(commit, dict), "Invalid commit record")
            oid = commit.get("id")
            require(isinstance(oid, str) and OID.fullmatch(oid) and oid not in seen,
                    "Invalid or duplicate commit ID")
            seen.add(oid)
            record = precheck(commit.get("message"), payload["policy"]["rules"],
                              unsupported, payload["policy"]["resolved"])
            record["id"] = oid
            records.append(record)
        result["counts"] = {"syntax_checked": len(records),
                            "findings": sum(r["syntax"] == "findings" for r in records),
                            "unresolved": sum(r["syntax"] == "unresolved" for r in records),
                            "semantically_reviewed": 0}
    else:
        raise Invalid("Unknown operation")
    require(offset <= len(records), "Page offset exceeds results")
    result.update(offset=offset, records=records[offset:offset + limit],
                  next_offset=offset + limit if offset + limit < len(records) else None)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("operation", choices=("check", "plan"))
    parser.add_argument("--offset", type=int, default=0)
    parser.add_argument("--limit", type=int, default=100)
    parser.add_argument("--expect-digest", help="First page input_digest; required when --offset is greater than zero")
    args = parser.parse_args()
    try:
        raw = sys.stdin.buffer.read(MAX_BYTES + 1)
        require(len(raw) <= MAX_BYTES, "Input exceeds resource limit")
        payload = json.loads(raw, object_pairs_hook=object_pairs,
                             parse_constant=lambda _: (_ for _ in ()).throw(Invalid("Non-finite JSON")))
        result = execute(payload, args.operation, args.offset, args.limit, args.expect_digest)
    except (ValueError, TypeError, UnicodeError, RecursionError):
        # Do not echo malformed JSON, messages, policy values or parser excerpts.
        print(json.dumps({"interface_version": 1, "error": "Invalid or unsupported normalize input"}))
        return 2
    print(json.dumps(result, ensure_ascii=True, allow_nan=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
