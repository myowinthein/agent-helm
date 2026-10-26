"""Offline ledger contracts using disposable consumers, never project records."""

import copy
from decimal import Decimal
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

sys.dont_write_bytecode = True
HELPERS = Path(__file__).resolve().parents[1] / "helpers"
sys.path.insert(0, str(HELPERS))
from helm_lib import common, ledger


A, B = "a" * 40, "b" * 40
CANARY = "SYNTHETIC_PRIVATE_VALUE_NOT_FOR_DIAGNOSTICS"


def test_case(identity, state="open", path="src/api.py", priority="medium"):
    case = {"id": identity, "expected": "Reject duplicate submissions", "basis": ["docs/api.md#retry"],
            "paths": [path], "priority": priority, "reason": "A duplicate changes observable results",
            "action": "add", "state": state, "assessed_commit": A}
    if state != "open":
        case["closure"] = {"reason": "tested" if state == "resolved" else "obsolete",
                           "refs": ["tests/api.py::retry"], "method": "runtime" if state == "resolved" else "static",
                           "outcome": "The stated guarantee was checked", "commit": B}
        if state == "resolved":
            case["closure"].update(command="python3 tests/api.py", scope="Synthetic retry contract")
    return case


def finding(identity, state="open"):
    item = {"id": identity, "category": "Architecture", "summary": "Separate request validation",
            "paths": ["src/api.py"], "found": {"origin": "native", "commit": A, "date": "2026-10-27"},
            "assessment": {"origin": "native", "commit": A, "date": "2026-10-27", "priority": "medium",
                           "risk": "safe", "reason": "The boundary has repeated validation",
                           "evidence": ["src/api.py::submit"], "invariant": "Preserve accepted inputs"},
            "state": state, "depends_on": []}
    if state != "open":
        item["closure"] = {"origin": "native", "kind": "fixed" if state == "resolved" else "no-longer-applicable",
                           "commit": B, "date": "2026-10-27", "method": "static",
                           "evidence": ["src/api.py::submit"]}
    return item


def document(owner="test", records=None):
    return {"schema_version": 3 if owner == "test" else 2,
            "assessed_commit": A, "full_scan_commit": A,
            "cases" if owner == "test" else "findings": records if records is not None else
            [test_case("one")] if owner == "test" else [finding("one")]}


def snapshot(root):
    result = {}
    for parent, directories, files in os.walk(root, followlinks=False):
        for name in directories + files:
            path = Path(parent) / name
            info = path.lstat()
            identity = (info.st_mode, info.st_ino, info.st_size, info.st_mtime_ns, info.st_ctime_ns)
            if stat.S_ISLNK(info.st_mode):
                content = os.readlink(path)
            elif stat.S_ISREG(info.st_mode):
                content = hashlib.sha256(path.read_bytes()).hexdigest()
            else:
                content = None
            result[str(path.relative_to(root))] = identity, content
    return result


class LedgerTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="helm-ledger-test-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name).resolve()
        self.consumer = self.root / "consumer"
        self.consumer.mkdir()
        self.settings = ledger.contract()

    def write(self, value, owner="test", raw=None):
        path = self.consumer / ".helm" / (owner + "-log.json")
        path.parent.mkdir(exist_ok=True)
        path.write_bytes(raw if raw is not None else common.encode(value).encode("utf-8"))
        return path

    def request(self, owner="test", **extra):
        return {"interface_version": 1, "owner": owner, "workspace": str(self.consumer), **extra}

    def execute(self, operation="ledger-check", owner="test", settings=None, **extra):
        return ledger.execute(operation, self.request(owner, **extra), settings or self.settings)["result"]

    def view(self, owner="test", **extra):
        checked = self.execute(owner=owner)
        return self.execute("ledger-view", owner, expected_digest=checked["sha256"], **extra)

    def problem(self, kind, callback):
        with self.assertRaises(common.Problem) as caught:
            callback()
        self.assertEqual(caught.exception.kind, kind)
        return str(caught.exception)

    def cli(self, operation="ledger-check", payload=None, raw=None):
        before = snapshot(self.root)
        run = subprocess.run([sys.executable, "-I", "-B", str(HELPERS / "helm.py"), operation],
                             input=raw if raw is not None else common.encode(payload or self.request()).encode("utf-8"),
                             cwd=self.consumer, capture_output=True, timeout=10)
        self.assertEqual(snapshot(self.root), before, "A read-only helper changed its synthetic consumer")
        return run

    def test_missing_state_creates_nothing(self):
        for owner in ("test", "refactor"):
            with self.subTest(owner=owner):
                run = self.cli(payload=self.request(owner))
                self.assertEqual(run.returncode, 0)
                result = json.loads(run.stdout)["result"]
                self.assertEqual((result["status"], result["sha256"], result["records_total"]), ("missing", None, 0))
                self.assertFalse(result["structurally_validated"])
                self.assertFalse((self.consumer / ".helm").exists())

    def test_valid_native_owners_never_claim_review_execution_or_permission(self):
        for owner in ("test", "refactor"):
            with self.subTest(owner=owner):
                self.write(document(owner), owner)
                run = self.cli(payload=self.request(owner))
                self.assertEqual(run.returncode, 0, run.stderr)
                result = json.loads(run.stdout)["result"]
                self.assertTrue(result["structurally_validated"])
                self.assertEqual(result["records_total"], 1)
                self.assertEqual(result["anchors"], {"assessed_commit": A, "full_scan_commit": A})
                for field in ("source_review", "runtime_verification", "human_authorization"):
                    self.assertIs(result[field], False)

    def test_workspace_cannot_be_the_package_or_its_descendant(self):
        package = self.root / "fictional package"
        child = package / "child"
        child.mkdir(parents=True)
        for path in (package, child):
            with self.subTest(path=path.name), mock.patch.object(ledger, "PACKAGE_ROOT", package):
                request = self.request(workspace=str(path))
                self.problem("invalid_input", lambda: ledger.execute("ledger-check", request, self.settings))

    def test_symlinked_canonical_file_and_parent_are_rejected_before_open(self):
        outside = self.root / "outside.json"
        outside.write_text(common.encode(document()))
        canonical = self.consumer / ".helm"
        canonical.mkdir()
        (canonical / "test-log.json").symlink_to(outside)
        with mock.patch.object(common.os, "open", wraps=os.open) as opened:
            self.problem("unsupported_state", self.execute)
            opened.assert_not_called()
        self.assertEqual(self.cli().returncode, 4)
        (canonical / "test-log.json").unlink()
        canonical.rmdir()
        canonical.symlink_to(self.root, target_is_directory=True)
        with mock.patch.object(common.os, "open", wraps=os.open) as opened:
            self.problem("unsupported_state", self.execute)
            opened.assert_not_called()
        self.assertEqual(self.cli().returncode, 4)

    def test_conflicting_parent_and_nonregular_canonical_occupants_stop(self):
        canonical = self.consumer / ".helm"
        canonical.write_text(CANARY)
        self.assertEqual(self.cli().returncode, 4)
        canonical.unlink()
        canonical.mkdir()
        (canonical / "test-log.json").mkdir()
        self.assertEqual(self.cli().returncode, 4)

    def test_each_legacy_location_blocks_without_opening_its_bytes(self):
        self.write(document())
        for relative in (".claude/test-log.json", ".claude/helm/test-log.json"):
            with self.subTest(relative=relative):
                legacy = self.consumer / relative
                legacy.parent.mkdir(parents=True, exist_ok=True)
                legacy.write_bytes(b"\xff" + CANARY.encode())
                with mock.patch.object(common.os, "open", wraps=os.open) as opened:
                    self.problem("unsupported_state", self.execute)
                    opened.assert_not_called()
                run = self.cli()
                self.assertEqual(run.returncode, 4)
                self.assertNotIn(CANARY.encode(), run.stderr)
                legacy.unlink()

    def test_symlinked_or_conflicting_legacy_parents_stop(self):
        external = self.root / "legacy"
        external.mkdir()
        parent = self.consumer / ".claude"
        parent.symlink_to(external, target_is_directory=True)
        self.assertEqual(self.cli().returncode, 4)
        parent.unlink()
        parent.write_text(CANARY)
        self.assertEqual(self.cli().returncode, 4)

    def test_other_owner_state_is_opaque(self):
        for relative in (".helm/refactor-log.json", ".claude/refactor-log.json", ".claude/helm/refactor-log.json"):
            path = self.consumer / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(b"\xff" + CANARY.encode())
        run = self.cli()
        self.assertEqual(run.returncode, 0)
        self.assertEqual(json.loads(run.stdout)["result"]["status"], "missing")
        self.assertNotIn(CANARY.encode(), run.stdout + run.stderr)

    def test_consumer_modules_are_never_imported(self):
        trap = self.consumer / "helm_lib"
        trap.mkdir()
        (trap / "__init__.py").write_text("raise RuntimeError('" + CANARY + "')\n")
        self.assertEqual(self.cli().returncode, 0)

    def test_file_replacement_during_open_returns_conflict_not_contents(self):
        path = self.write(document())
        replacement = self.consumer / "replacement.json"
        replacement.write_text(common.encode(document(records=[test_case(CANARY)])))
        fdopen = common.os.fdopen

        def replace_after_open(descriptor, *args, **kwargs):
            replacement.replace(path)
            return fdopen(descriptor, *args, **kwargs)

        with mock.patch.object(common.os, "fdopen", side_effect=replace_after_open):
            message = self.problem("conflict", lambda: common.read_file(self.consumer, (".helm", "test-log.json"), 65536))
        self.assertNotIn(CANARY, message)

    def test_parent_replacement_during_open_returns_conflict_not_contents(self):
        self.write(document())
        replacement = self.consumer / "replacement"
        replacement.mkdir()
        (replacement / "test-log.json").write_text(common.encode(document(records=[test_case(CANARY)])))
        fdopen = common.os.fdopen

        def replace_after_open(descriptor, *args, **kwargs):
            (self.consumer / ".helm").rename(self.consumer / "original-helm")
            replacement.rename(self.consumer / ".helm")
            return fdopen(descriptor, *args, **kwargs)

        with mock.patch.object(common.os, "fdopen", side_effect=replace_after_open):
            message = self.problem("conflict", lambda: common.read_file(self.consumer, (".helm", "test-log.json"), 65536))
        self.assertNotIn(CANARY, message)

    def test_bad_json_is_rejected_without_disclosing_values_or_keys(self):
        examples = [b'{"schema_version":3,"schema_version":3,"cases":[]}',
                    ('{"schema_version":3,"cases":[],"extra":{"' + CANARY + '":1,"' + CANARY + '":2}}').encode(),
                    b'{"schema_version":3,"cases":[],"extra":NaN}',
                    b'{"schema_version":3,"cases":[],"extra":"\\ud800"}',
                    b'\xef\xbb\xbf{"schema_version":3,"cases":[]}', b"\xff", b'{"cases":']
        for raw in examples:
            with self.subTest(raw_length=len(raw)):
                self.write(None, raw=raw)
                run = self.cli()
                self.assertEqual(run.returncode, 4)
                self.assertEqual(run.stdout, b"")
                self.assertEqual(json.loads(run.stderr)["error"]["kind"], "invalid_state")
                self.assertNotIn(CANARY.encode(), run.stderr)

    def test_test_shape_identity_paths_dates_and_closures_are_validated(self):
        def changed(edit):
            value = document()
            edit(value)
            return value
        invalid = [changed(lambda v: v.update(schema_version=2)),
                   changed(lambda v: v.update(schema_version=True)),
                   changed(lambda v: v["cases"][0].pop("expected")),
                   changed(lambda v: v["cases"][0].update(basis=[])),
                   changed(lambda v: v["cases"][0].update(paths=[])),
                   changed(lambda v: v["cases"].append(copy.deepcopy(v["cases"][0]))),
                   changed(lambda v: v["cases"][0].update(paths=["../outside"])),
                   changed(lambda v: v["cases"][0].update(paths=["/absolute"])),
                   changed(lambda v: v["cases"][0].update(assessed_commit="HEAD~1")),
                   changed(lambda v: v["cases"][0].update(priority=CANARY)),
                   changed(lambda v: v["cases"][0].update(state="resolved")),
                   changed(lambda v: v["cases"][0].update(decision={"type": "deferred", "note": "Owner choice",
                                                                  "date": "2026-02-30", "commit": A}))]
        resolved = document(records=[test_case("closed", "resolved")])
        for edit in (lambda v: v["cases"][0]["closure"].pop("scope"),
                     lambda v: v["cases"][0].update(blocker={"kind": "verification", "note": "Pending"}),
                     lambda v: v["cases"][0]["closure"].update(reason="obsolete")):
            value = copy.deepcopy(resolved)
            edit(value)
            invalid.append(value)
        for index, value in enumerate(invalid):
            with self.subTest(mutation=index):
                self.write(value)
                run = self.cli()
                self.assertEqual(run.returncode, 4)
                self.assertEqual(run.stdout, b"")
                self.assertNotIn(CANARY.encode(), run.stderr)

    def test_refactor_provenance_references_cycles_and_closures_are_validated(self):
        original = document("refactor", [finding("one"), finding("two")])
        edits = [lambda v: v["findings"][0]["found"].update(origin="imported"),
                 lambda v: v["findings"][0]["found"].update(date="2026-02-30"),
                 lambda v: v["findings"][0].update(depends_on=["missing"]),
                 lambda v: v["findings"][0].update(depends_on=["one"]),
                 lambda v: v["findings"][0].update(recurrence_of="missing"),
                 lambda v: (v["findings"][0].update(recurrence_of="two"), v["findings"][1].update(recurrence_of="one")),
                 lambda v: v["findings"][0]["assessment"].update(priority="unknown")]
        for index, edit in enumerate(edits):
            value = copy.deepcopy(original)
            edit(value)
            self.write(value, "refactor")
            with self.subTest(mutation=index):
                self.assertEqual(self.cli(payload=self.request("refactor")).returncode, 4)
        unknown = copy.deepcopy(original)
        unknown["findings"][0]["assessment"]["priority"] = "unknown"
        unknown["findings"][0]["blocker"] = {"kind": "clarification", "reason": "Need improvement value"}
        unknown["findings"][1].update(depends_on=["one"], recurrence_of="one")
        self.write(unknown, "refactor")
        self.assertEqual(self.cli(payload=self.request("refactor")).returncode, 0)
        closed = document("refactor", [finding("closed", "resolved")])
        closed["findings"][0]["closure"]["method"] = "runtime"
        self.write(closed, "refactor")
        self.assertEqual(self.cli(payload=self.request("refactor")).returncode, 4)
        closed["findings"][0]["closure"]["checks"] = [{"command": "fixture check", "scope": "Contract", "outcome": "Passed"}]
        self.write(closed, "refactor")
        self.assertEqual(self.cli(payload=self.request("refactor")).returncode, 0)
        for state, kind in (("resolved", "no-longer-applicable"), ("obsolete", "fixed")):
            value = document("refactor", [finding("mismatched", state)])
            value["findings"][0]["closure"]["kind"] = kind
            self.write(value, "refactor")
            with self.subTest(state=state, closure=kind):
                self.assertEqual(self.cli(payload=self.request("refactor")).returncode, 4)

    def test_invalid_cli_requests_have_no_success_output_or_input_echo(self):
        for raw in (b'{"private":"' + CANARY.encode() + b'",',
                    b'{"interface_version":1,"interface_version":1}', b'{"private":NaN}'):
            run = self.cli(raw=raw)
            self.assertEqual(run.returncode, 2)
            self.assertEqual(run.stdout, b"")
            self.assertEqual(json.loads(run.stderr)["error"]["kind"], "invalid_input")
            self.assertNotIn(CANARY.encode(), run.stderr)

    def test_pages_include_all_states_and_preserve_order_and_full_summaries(self):
        records = [test_case("z-open"), test_case("a-closed", "resolved"), test_case("m-obsolete", "obsolete")]
        records[0]["expected"] = "Long meaningful context " * 120
        self.write(document(records=records))
        first = self.view(limit=2)
        second = self.execute("ledger-view", expected_digest=first["sha256"], offset=first["next_offset"], limit=2)
        self.assertEqual([r["id"] for r in first["records"] + second["records"]], [r["id"] for r in records])
        self.assertEqual((first["total_matched"], first["returned"], second["next_offset"]), (3, 2, None))
        self.assertEqual(first["records"][0]["expected"], records[0]["expected"])
        self.assertEqual(self.view(projection="records")["records"], records)

    def test_unknown_values_and_exact_numbers_survive_full_retrieval_unchanged(self):
        value = document()
        value["custom_root"] = {"retained": [True, None]}
        value["cases"][0]["custom"] = {"amount": Decimal("123456789.123456789012345678901"),
                                        "large": 10 ** 80, "nested": ["Unicode ไทย", False]}
        path = self.write(value)
        before = path.read_bytes()
        checked = self.execute()
        run = self.cli("ledger-view", self.request(expected_digest=checked["sha256"], projection="records"))
        self.assertEqual(run.returncode, 0)
        result = json.loads(run.stdout, parse_float=Decimal)["result"]
        self.assertEqual(result["records"], value["cases"])
        self.assertEqual(path.read_bytes(), before)

    def test_filter_or_within_and_across_keys_and_path_boundaries(self):
        records = [test_case("one", path="api/order.py", priority="high"),
                   test_case("two", path="api2/order.py", priority="high"),
                   test_case("three", path="api/user.py", priority="low"),
                   test_case("four", "resolved", path="api/order.py", priority="medium")]
        records[0]["extra"] = {"CUSTOM_evidence": "Retry ORDER"}
        self.write(document(records=records))
        result = self.view(filters={"paths": ["api"], "priorities": ["high", "low"], "states": ["open"]})
        self.assertEqual([r["id"] for r in result["records"]], ["one", "three"])
        self.assertEqual([r["id"] for r in self.view(filters={"paths": ["api/order.py"]})["records"]], ["one", "four"])
        self.assertEqual([r["id"] for r in self.view(filters={"terms": ["not present", "custom_EVIDENCE"]})["records"]], ["one"])
        self.assertEqual(self.view(filters={"ids": ["absent"]})["records"], [])
        self.assertEqual(self.view(filters={"paths": ["API"]})["records"], [])

    def test_refactor_filters_index_and_held_flags_use_assessment_fields(self):
        first, second = finding("held"), finding("other")
        first["decision"] = {"origin": "native", "action": "defer", "commit": A, "date": "2026-10-27",
                             "reason": "Owner postponed", "context": {"paths": ["src/api.py"], "evidence": ["Owner choice"]}}
        first["blocker"] = {"kind": "verification", "reason": "Need runner"}
        second["assessment"].update(priority="low", risk="needs-review")
        self.write(document("refactor", [first, second]), "refactor")
        result = self.view("refactor", filters={"categories": ["Architecture"], "risks": ["safe"], "priorities": ["medium"]})
        self.assertEqual([r["id"] for r in result["records"]], ["held"])
        row = result["records"][0]
        self.assertTrue(row["held"] and row["blocked"])
        self.assertEqual(row["summary"], first["summary"])
        self.assertEqual(row["assessed_commit"], A)

    def test_digest_is_required_and_changes_or_disappearance_conflict(self):
        path = self.write(document())
        checked = self.execute()
        self.problem("invalid_input", lambda: self.execute("ledger-view"))
        self.problem("invalid_input", lambda: self.execute("ledger-view", expected_digest="not-a-digest"))
        path.write_text(common.encode(document(records=[test_case("changed")])))
        self.problem("conflict", lambda: self.execute("ledger-view", expected_digest=checked["sha256"]))
        self.problem("conflict", lambda: self.execute(expected_digest=checked["sha256"]))
        path.unlink()
        self.problem("conflict", lambda: self.execute("ledger-view", expected_digest=checked["sha256"]))

    def test_invalid_request_bounds_and_filters_reject_without_state_changes(self):
        self.write(document())
        before = snapshot(self.root)
        for fields in ({"limit": 0}, {"limit": 101}, {"offset": -1}, {"offset": True}, {"projection": "unknown"},
                       {"filters": {"states": ["missing"]}}, {"filters": {"categories": ["Architecture"]}},
                       {"filters": {"ids": []}}, {"filters": {"ids": ["one"] * 101}}):
            with self.subTest(fields=fields):
                self.problem("invalid_input", lambda: self.view(**fields))
        for fields in ({"owner": "legal"}, {"workspace": "relative"}, {"filename": "other.json"}, {"interface_version": True}):
            with self.subTest(fields=fields):
                self.problem("invalid_input", lambda: ledger.execute("ledger-check", self.request(**fields), self.settings))
        self.assertEqual(snapshot(self.root), before)

    def test_resource_limits_fail_instead_of_truncating(self):
        self.write(document())
        small = copy.deepcopy(self.settings)
        small["limits"]["ledger_bytes"] = 8
        self.problem("invalid_state", lambda: self.execute(settings=small))
        small = copy.deepcopy(self.settings)
        small["limits"]["records"] = 1
        self.write(document(records=[test_case("one"), test_case("two")]))
        self.problem("invalid_state", lambda: self.execute(settings=small))
        for raw, limits in ((b'[[[[0]]]]', {"depth": 2, "nodes": 100}),
                            (b'[1,2,3]', {"depth": 64, "nodes": 2})):
            self.problem("invalid_state", lambda: common.loads(raw, limits, "invalid_state"))
        run = self.cli(raw=b" " * (self.settings["limits"]["request_bytes"] + 1))
        self.assertEqual(run.returncode, 2)
        self.assertEqual(run.stdout, b"")
        value = document()
        value["cases"][0]["extra"] = CANARY + "x" * self.settings["limits"]["response_bytes"]
        self.write(value)
        checked = self.execute()
        run = self.cli("ledger-view", self.request(expected_digest=checked["sha256"], projection="records"))
        self.assertEqual(run.returncode, 2)
        self.assertEqual(run.stdout, b"")
        self.assertNotIn(CANARY.encode(), run.stderr)
        self.assertEqual(self.view()["records"][0]["id"], "one")


if __name__ == "__main__":
    unittest.main()
