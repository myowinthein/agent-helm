"""Offline normalize mechanics tests; synthetic inputs only, no Git/live state."""

import copy
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import unittest

sys.dont_write_bytecode = True
HELPER = Path(__file__).resolve().parents[1] / "helpers/normalize_check.py"
SPEC = importlib.util.spec_from_file_location("normalize_check", HELPER)
mod = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(mod)


def oid(number):
    return f"{number:040x}"


def policy():
    return {"resolved": True, "rules": {"types": ["feat", "fix", "docs"],
            "scope_required": True, "scopes": None, "type_case_sensitive": True,
            "header_max_length": 80}, "semantic_rules": ["Preserve language and true intent"]}


def baseline(number, effective=None):
    return {"last_checked_commit": oid(number), "last_checked_date": "2026-10-27",
            "review_kind": "semantic", "review_contract": 1,
            "policy_fingerprint": mod.policy_info(effective or policy())[0]}


def ledger(records):
    return {"schema_version": 2, "branches": records}


def graph(*records):
    return [{"id": oid(number), "parents": [oid(p) for p in parents]}
            for number, parents in records]


class NormalizeTests(unittest.TestCase):
    def check_message(self, text, effective=None):
        return mod.execute({"policy": effective or policy(),
                            "commits": [{"id": oid(1), "message": text}]}, "check")

    def plan(self, commits, tips=None, records=None, **extra):
        return mod.execute({"policy": policy(), "commits": commits,
                            "tips": tips or {"main": commits[-1]["id"]},
                            "ledger": ledger(records) if records is not None else None,
                            **extra}, "plan")

    def test_valid_syntax_never_means_semantic_acceptance(self):
        for message in ("fix(auth): update login\n", "feat(auth): fix login typo\n"):
            result = self.check_message(message)
            self.assertEqual(result["records"][0]["syntax"], "pass")
            self.assertEqual(result["records"][0]["semantic"], "not_reviewed")
            self.assertEqual(result["counts"]["semantically_reviewed"], 0)

    def test_header_scope_type_and_body_rules(self):
        cases = {"updated login": "header_grammar", "fix: login": "scope_required",
                 "chore(core): update": "type_policy", "fix(core): update\nbody": "body_separator"}
        for message, diagnostic in cases.items():
            self.assertIn(diagnostic, self.check_message(message)["records"][0]["diagnostics"])

    def test_scopes_and_length_are_project_policy(self):
        effective = policy()
        effective["rules"].update(scopes=["api"], header_max_length=12)
        result = self.check_message("fix(auth): update login", effective)["records"][0]
        self.assertEqual(result["diagnostics"], ["scope_policy", "header_length"])

    def test_case_and_optional_scope_are_not_universal_rules(self):
        effective = policy()
        effective["rules"].update(scope_required=False, type_case_sensitive=False)
        self.assertEqual(self.check_message("FIX: update", effective)["records"][0]["syntax"], "pass")

    def test_only_formal_breaking_markers(self):
        for message in ("fix(api)!: change\n", "fix(api): change\n\nBREAKING CHANGE: removed option\n",
                        "fix(api): change\n\nBREAKING-CHANGE: removed option\n"):
            self.assertTrue(self.check_message(message)["records"][0]["formal_breaking_marker"])
        self.assertFalse(self.check_message("fix(api): avoid breaking links\n")["records"][0]["formal_breaking_marker"])

    def test_unsupported_rules_and_unresolved_policy_are_not_clean(self):
        effective = policy()
        effective["rules"]["custom_rule"] = "owner constraint"
        result = self.check_message("fix(api): update", effective)
        self.assertEqual(result["records"][0]["syntax"], "unresolved")
        self.assertEqual(result["unsupported_rules"], ["custom_rule"])
        effective = policy()
        effective["resolved"] = False
        self.assertEqual(self.check_message("fix(api): update", effective)["records"][0]["syntax"], "unresolved")

    def test_messages_never_echo_in_diagnostics(self):
        result = self.check_message("fix(api): PRIVATE_SYNTHETIC_SENTINEL\n\nbody\n")
        self.assertNotIn("PRIVATE_SYNTHETIC_SENTINEL", json.dumps(result))
        self.assertNotIn("body", json.dumps(result))

    def test_missing_baseline_reviews_entire_history(self):
        result = self.plan(graph((1, []), (2, [1]), (3, [2])))
        self.assertEqual(result["records"], [oid(1), oid(2), oid(3)])
        self.assertEqual(result["counts"]["reused"], 0)

    def test_compatible_baseline_reuses_only_covered_ancestors(self):
        result = self.plan(graph((1, []), (2, [1]), (3, [2])), records={"main": baseline(2)})
        self.assertEqual(result["records"], [oid(3)])
        self.assertEqual(result["counts"], {"selected": 3, "reused": 2, "needs_semantic": 1})

    def test_new_merge_side_history_is_never_skipped(self):
        result = self.plan(graph((1, []), (2, [1]), (3, [1]), (4, [2, 3])), records={"main": baseline(2)})
        self.assertEqual(result["records"], [oid(3), oid(4)])

    def test_another_branch_cannot_hide_unreviewed_membership(self):
        result = self.plan(graph((1, []), (2, [1])), tips={"main": oid(2), "feature": oid(2)},
                           records={"main": baseline(2)})
        self.assertEqual(result["records"], [oid(1), oid(2)])
        self.assertEqual(result["counts"]["reused"], 0)

    def test_changed_policy_contract_or_nonancestor_falls_back(self):
        changed_policy = baseline(1)
        changed_policy["policy_fingerprint"] = "f" * 64
        changed_contract = baseline(1)
        changed_contract["review_contract"] = 2
        for record, reason in ((changed_policy, "policy_changed"), (changed_contract, "review_contract_changed"),
                               (baseline(9), "baseline_not_ancestor")):
            result = self.plan(graph((1, []), (2, [1])), records={"main": record})
            self.assertEqual(result["records"], [oid(1), oid(2)])
            self.assertEqual(result["branches"]["main"]["baseline_status"], reason)

    def test_new_concern_invalidates_reused_prefix(self):
        result = self.plan(graph((1, []), (2, [1]), (3, [2])), records={"main": baseline(2)},
                           recheck_ids=[oid(1)])
        self.assertEqual(result["records"], [oid(1), oid(2), oid(3)])
        self.assertEqual(result["branches"]["main"]["baseline_status"], "baseline_invalidated")

    def test_reused_noop_returns_no_semantic_work(self):
        result = self.plan(graph((1, [])), records={"main": baseline(1)})
        self.assertEqual(result["records"], [])
        self.assertEqual(result["counts"]["needs_semantic"], 0)

    def test_unresolved_policy_never_reuses_a_matching_record(self):
        effective = policy()
        effective["resolved"] = False
        result = self.plan(graph((1, []), (2, [1])), policy=effective,
                           records={"main": baseline(1, effective)})
        self.assertEqual(result["records"], [oid(1), oid(2)])
        self.assertEqual(result["branches"]["main"]["baseline_status"], "unresolved_policy")

    def test_sha256_graph_and_ledger_are_supported(self):
        first, second = "a" * 64, "b" * 64
        record = baseline(1)
        record["last_checked_commit"] = first
        result = self.plan([{"id": first, "parents": []}, {"id": second, "parents": [first]}],
                           records={"main": record})
        self.assertEqual(result["records"], [second])

    def test_full_policy_fingerprint_includes_semantic_constraints(self):
        old, new = policy(), policy()
        new["semantic_rules"].append("An additional owner decision")
        self.assertNotEqual(mod.policy_info(old)[0], mod.policy_info(new)[0])
        self.assertEqual(mod.policy_info(old)[0], mod.policy_info(copy.deepcopy(old))[0])

    def test_graph_requires_complete_acyclic_unambiguous_input(self):
        for commits in (graph((1, [9])), graph((1, [2]), (2, [1])), graph((1, []), (1, []))):
            with self.assertRaises(mod.Invalid):
                self.plan(commits)

    def test_schema_one_and_incomplete_schema_two_are_rejected(self):
        for record in ({"schema_version": 1, "branches": {}}, ledger({"main": {"last_checked_commit": oid(1)}})):
            with self.assertRaises(mod.Invalid):
                mod.validate_ledger(record)

    def test_invalid_dates_kinds_and_boolean_contract_are_rejected(self):
        for key, value in (("last_checked_date", "2026-02-30"), ("review_kind", "syntax"),
                           ("review_contract", True), ("policy_fingerprint", "invalid")):
            record = baseline(1)
            record[key] = value
            with self.assertRaises(mod.Invalid):
                mod.validate_ledger(ledger({"main": record}))

    def test_unknown_state_fields_are_preserved(self):
        record = ledger({"main": baseline(1)})
        record["owner_history"] = {"keep": True}
        record["branches"]["main"]["extra"] = ["retained"]
        self.assertIs(mod.validate_ledger(record), record)
        self.assertEqual(record["branches"]["main"]["extra"], ["retained"])

    def test_digest_bound_pages_reconcile_all_ids(self):
        payload = {"policy": policy(), "commits": graph((1, []), (2, [1]), (3, [2])), "tips": {"main": oid(3)}}
        first = mod.execute(payload, "plan", limit=1)
        second = mod.execute(payload, "plan", offset=1, limit=2, expected_digest=first["input_digest"])
        self.assertEqual(first["records"] + second["records"], [oid(1), oid(2), oid(3)])
        self.assertIsNone(second["next_offset"])
        payload["tips"]["main"] = oid(2)
        with self.assertRaises(mod.Invalid):
            mod.execute(payload, "plan", expected_digest=first["input_digest"])

    def test_invalid_page_bounds_and_conflicting_message_ids_stop(self):
        payload = {"policy": policy(), "commits": [{"id": oid(1), "message": "fix(api): update"}]}
        for bounds in ({"limit": 0}, {"limit": 201}, {"offset": -1}, {"offset": 9}):
            with self.assertRaises(mod.Invalid):
                mod.execute(payload, "check", **bounds)
        payload["commits"] *= 2
        with self.assertRaises(mod.Invalid):
            mod.execute(payload, "check")

    def test_continuations_require_a_matching_digest_for_each_operation(self):
        payload = {"policy": policy(), "tips": {"main": oid(2)}, "commits": [
            {"id": oid(1), "parents": [], "message": "fix(api): first"},
            {"id": oid(2), "parents": [oid(1)], "message": "fix(api): second"}]}
        for operation in ("check", "plan"):
            with self.subTest(operation=operation):
                first = mod.execute(payload, operation, limit=1)
                for missing_or_wrong in (None, "", "0" * 64):
                    with self.subTest(digest=missing_or_wrong), self.assertRaises(mod.Invalid):
                        mod.execute(payload, operation, offset=1, expected_digest=missing_or_wrong)
                last = mod.execute(payload, operation, offset=1, expected_digest=first["input_digest"])
                self.assertEqual(last["records"], mod.execute(payload, operation)["records"][1:])
                self.assertIsNone(last["next_offset"])

                # Exercise argparse and its safe error boundary, not only execute().
                command = [sys.executable, "-I", "-B", str(HELPER), operation, "--offset", "1"]
                rejected = subprocess.run(command, input=json.dumps(payload), text=True,
                                          capture_output=True, check=False)
                self.assertEqual(rejected.returncode, 2)
                self.assertEqual(json.loads(rejected.stdout), {
                    "interface_version": 1, "error": "Invalid or unsupported normalize input"})
                self.assertEqual(rejected.stderr, "")
                accepted = subprocess.run(command + ["--expect-digest", first["input_digest"]],
                                          input=json.dumps(payload), text=True, capture_output=True, check=False)
                self.assertEqual(accepted.returncode, 0, accepted.stderr)
                self.assertEqual(json.loads(accepted.stdout), last)

    def test_cli_parse_failure_never_echoes_input(self):
        for data in ('{"private":"SYNTHETIC_SENTINEL",', '{"policy":null,"policy":null}', '{"policy":NaN}'):
            run = subprocess.run([sys.executable, "-I", "-B", str(HELPER), "check"], input=data,
                                 text=True, capture_output=True, check=False)
            self.assertEqual(run.returncode, 2)
            self.assertNotIn("SYNTHETIC_SENTINEL", run.stdout + run.stderr)
            self.assertEqual(run.stderr, "")

    def test_cli_accepts_structured_check_and_plan_inputs(self):
        shared = {"policy": policy(), "tips": {"main": oid(1)},
                  "commits": [{"id": oid(1), "parents": [], "message": "fix(api): update\n"}]}
        for operation in ("check", "plan"):
            run = subprocess.run([sys.executable, "-I", "-B", str(HELPER), operation],
                                 input=json.dumps(shared), text=True, capture_output=True, check=False)
            self.assertEqual(run.returncode, 0, run.stderr)
            result = json.loads(run.stdout)
            self.assertEqual(result["review_contract"], 1)
            self.assertEqual(len(result["records"]), 1)
            self.assertEqual(run.stderr, "")


if __name__ == "__main__":
    unittest.main()
