"""Locator mechanics in disposable clones; no models, live records or remote writes."""

import importlib.util
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import types
import unittest
from unittest.mock import patch
from contextlib import redirect_stdout

sys.dont_write_bytecode = True
HELPER = Path(__file__).resolve().parents[1] / "helpers/normalize_handoff.py"
SPEC = importlib.util.spec_from_file_location("normalize_handoff", HELPER)
mod = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(mod)
RETENTION_SPEC = importlib.util.spec_from_file_location("normalize_retention", HELPER.with_name("normalize_retention.py"))
retention = importlib.util.module_from_spec(RETENTION_SPEC)
RETENTION_SPEC.loader.exec_module(retention)


@unittest.skipUnless(hasattr(os, "O_NOFOLLOW") and hasattr(os, "getuid"), "POSIX locator checks")
class HandoffTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="helm-handoff-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name).resolve()
        self.workspace = self.root / "consumer with spaces"
        self.common = self.workspace / ".git"
        self.common.mkdir(parents=True)
        self.recovery = self.root / "private recovery"
        self.recovery.mkdir(mode=0o700)
        self.entry = self.recovery / "handoff.json"
        self.entry.write_text('{"pending":true}\n')
        self.entry.chmod(0o600)
        self.data = {"run_id": "run-one", "recovery_directory": str(self.recovery), "entrypoint": "handoff.json"}
        self.registry = self.common / "agent-helm/normalize-handoffs"

    def cli(self, action, common=None, data=None):
        command = [sys.executable, "-I", "-B", str(HELPER), action, "--git-common-dir", str(common or self.common)]
        if data:
            for key, value in data.items():
                command += ["--" + key.replace("_", "-"), value]
        return subprocess.run(command, capture_output=True, text=True, cwd=self.root)

    def snapshot(self):
        return {str(p.relative_to(self.root)): (p.lstat().st_mode, p.read_bytes())
                for p in self.root.rglob("*") if p.is_file() and not p.is_symlink()}

    def test_fresh_process_handoff_is_read_only_and_outside_project_content(self):
        result = self.cli("register", data=self.data)
        self.assertEqual(result.returncode, 0, result.stdout)
        before = self.snapshot()
        result = self.cli("discover")  # Independent process, no conversational state.
        self.assertEqual(result.returncode, 0, result.stdout)
        found = json.loads(result.stdout)
        self.assertEqual(found, {"candidates": [dict(self.data, availability="present")], "issues": []})
        self.assertEqual(self.snapshot(), before)
        self.assertEqual(self.registry.stat().st_mode & 0o777, 0o700)
        self.assertEqual((self.registry / "run-one.json").stat().st_mode & 0o777, 0o600)

    def test_no_rewrite_or_unknown_clone_has_no_directory_side_effect(self):
        self.assertEqual(mod.discover(str(self.common)), {"candidates": [], "issues": []})
        self.assertFalse((self.common / "agent-helm").exists())
        self.assertNotEqual(self.cli("register").returncode, 0)
        self.assertFalse((self.common / "agent-helm").exists())

    def test_repeated_runs_are_retained_without_latest_selection(self):
        mod.register(str(self.common), self.data)
        second = dict(self.data, run_id="run-two")
        mod.register(str(self.common), second)
        found = mod.discover(str(self.common))
        self.assertEqual({x["run_id"] for x in found["candidates"]}, {"run-one", "run-two"})
        self.assertNotIn("selected", found)
        self.assertEqual(json.loads((self.registry / "run-one.json").read_text()), self.data)

    def test_identical_retry_preserves_file_and_conflicting_identity_cannot_overwrite(self):
        mod.register(str(self.common), self.data)
        file = self.registry / "run-one.json"
        before = (file.stat().st_ino, file.stat().st_mtime_ns, file.read_bytes())
        mod.register(str(self.common), self.data)
        self.assertEqual((file.stat().st_ino, file.stat().st_mtime_ns, file.read_bytes()), before)
        other = self.recovery / "other.json"
        other.write_text('{}\n')
        other.chmod(0o600)
        with self.assertRaises(mod.Invalid):
            mod.register(str(self.common), dict(self.data, entrypoint="other.json"))
        self.assertEqual((file.stat().st_ino, file.stat().st_mtime_ns, file.read_bytes()), before)

    def test_atomic_no_clobber_even_if_destination_appears_during_publication(self):
        original = os.link
        occupied = b'Existing user-owned handoff; preserve it.\n'

        def collide(source, destination, **kwargs):
            fd = os.open(destination, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600, dir_fd=kwargs["dst_dir_fd"])
            with os.fdopen(fd, "wb") as file:
                file.write(occupied)
            return original(source, destination, **kwargs)

        with patch.object(mod.os, "link", side_effect=collide), self.assertRaises(FileExistsError):
            mod.register(str(self.common), self.data)
        self.assertEqual((self.registry / "run-one.json").read_bytes(), occupied)
        self.assertEqual([p.name for p in self.registry.iterdir()], ["run-one.json"])

    def test_failed_registration_leaves_backup_and_no_published_locator(self):
        with patch.object(mod.os, "link", side_effect=PermissionError("synthetic publication failure")):
            with self.assertRaises(PermissionError):
                mod.register(str(self.common), self.data)
        self.assertEqual(self.entry.read_text(), '{"pending":true}\n')
        self.assertEqual(list(self.registry.iterdir()), [])

    def test_pending_proof_stale_paths_and_invalid_proof_are_hints_not_acceptance(self):
        self.entry.write_text("UNREAD_BODY_NOT_VALID_PROOF\n")
        mod.register(str(self.common), self.data)
        self.assertEqual(mod.discover(str(self.common))["candidates"][0]["availability"], "present")
        self.recovery.rename(self.root / "moved backup")
        found = mod.discover(str(self.common))["candidates"][0]
        self.assertEqual(found["availability"], "missing")
        self.assertTrue((self.registry / "run-one.json").exists())

    def test_symlinked_locators_and_recovery_ancestors_are_not_followed(self):
        mod.register(str(self.common), self.data)
        file = self.registry / "run-one.json"
        saved = file.read_bytes()
        file.unlink()
        file.symlink_to(self.entry)
        self.assertEqual(len(mod.discover(str(self.common))["issues"]), 1)
        file.unlink()
        file.write_bytes(saved)
        file.chmod(0o600)
        actual = self.root / "actual private proof"
        self.recovery.rename(actual)
        self.recovery.symlink_to(actual, target_is_directory=True)
        self.assertEqual(mod.discover(str(self.common))["candidates"][0]["availability"], "invalid")

    def test_symlinked_ancestor_is_refused_until_the_path_is_resolved(self):
        link = self.root / "linked home"
        link.symlink_to(self.root, target_is_directory=True)
        through_link = link / self.recovery.name
        with self.assertRaises(mod.Invalid):
            mod.register(str(self.common), dict(self.data, recovery_directory=str(through_link)))
        mod.register(str(self.common), dict(self.data, recovery_directory=str(through_link.resolve())))
        self.assertEqual(mod.discover(str(self.common))["candidates"][0]["availability"], "present")

    def test_symlinked_registry_and_nonprivate_permissions_are_rejected(self):
        outer = self.common / "agent-helm"
        outer.symlink_to(self.recovery, target_is_directory=True)
        with self.assertRaises(OSError):
            mod.discover(str(self.common))
        outer.unlink()
        mod.register(str(self.common), self.data)
        self.registry.chmod(0o755)
        with self.assertRaises(mod.Invalid):
            mod.discover(str(self.common))

    def test_unsafe_locator_and_entrypoint_metadata_never_exposes_body(self):
        self.entry.write_text("SYNTHETIC_UNREAD_RECOVERY_BODY\n")
        mod.register(str(self.common), self.data)
        pointer = self.registry / "run-one.json"
        pointer.chmod(0o644)
        self.assertEqual(len(mod.discover(str(self.common))["issues"]), 1)
        pointer.chmod(0o600)
        self.entry.chmod(0o644)
        self.assertEqual(mod.discover(str(self.common))["candidates"][0]["availability"], "invalid")
        self.entry.chmod(0o600)
        original_open = os.open

        def no_proof_read(path, *args, **kwargs):
            if path == self.entry.name or str(path) == str(self.entry):
                raise AssertionError("Discovery attempted a recovery-body read")
            return original_open(path, *args, **kwargs)

        with patch.object(mod.os, "open", side_effect=no_proof_read):
            result = mod.discover(str(self.common))
        self.assertEqual(result["candidates"][0]["availability"], "present")
        self.assertNotIn("SYNTHETIC_UNREAD_RECOVERY_BODY", json.dumps(result))
        outside = self.root / "unrelated.json"
        outside.write_text("SYNTHETIC_UNREAD_OUTSIDE_BODY")
        self.entry.unlink()
        self.entry.symlink_to(outside)
        self.assertEqual(mod.discover(str(self.common))["candidates"][0]["availability"], "invalid")
        self.entry.unlink()
        self.entry.write_bytes(b"x" * 262145)
        self.entry.chmod(0o600)
        self.assertEqual(mod.discover(str(self.common))["candidates"][0]["availability"], "invalid")

    def test_non_private_recovery_directory_is_invalid_and_cannot_be_registered(self):
        mod.register(str(self.common), self.data)
        self.recovery.chmod(0o755)
        self.assertEqual(mod.discover(str(self.common))["candidates"][0]["availability"], "invalid")
        with self.assertRaises(mod.Invalid):
            mod.register(str(self.common), dict(self.data, run_id="run-two"))
        self.assertFalse((self.registry / "run-two.json").exists())

    def test_unfinished_and_unknown_entries_are_not_opened_or_selected(self):
        mod.register(str(self.common), self.data)
        (self.registry / (".pending-" + "a" * 32)).write_text("UNREAD_INCOMPLETE_LOCATOR")
        (self.registry / "unknown.py").write_text("UNREAD_UNEXPECTED_FILE")
        found = mod.discover(str(self.common))
        self.assertEqual(len(found["candidates"]), 1)
        self.assertEqual(found["issues"], [{"reason": "Unexpected handoff entry; not opened"}])
        self.assertNotIn("UNREAD", json.dumps(found))

    def test_malformed_oversized_duplicate_fields_and_nonregular_leaves_are_visible(self):
        mod.register(str(self.common), self.data)
        bad = self.registry / "bad.json"
        for raw in (b'{"run_id":"bad","run_id":"bad"}', b"x" * (mod.MAX_BYTES + 1), b'{}'):
            with self.subTest(raw_length=len(raw)):
                bad.write_bytes(raw)
                bad.chmod(0o600)
                found = mod.discover(str(self.common))
                self.assertEqual(len(found["candidates"]), 1)
                self.assertEqual(found["issues"][0]["run_id"], "bad")
        bad.unlink()
        os.mkfifo(bad, 0o600)
        self.assertEqual(mod.discover(str(self.common))["issues"][0]["run_id"], "bad")
        bad.unlink()
        os.link(self.registry / "run-one.json", bad)
        self.assertEqual(len(mod.discover(str(self.common))["issues"]), 2)

    def test_bounds_paths_ownership_and_entrypoints_are_checked_before_registration(self):
        for changes in ({"run_id": "../bad"}, {"run_id": "x" * 81}, {"entrypoint": "../proof.json"},
                        {"entrypoint": "run.py"}, {"recovery_directory": "relative"},
                        {"recovery_directory": str(self.recovery) + "/../private recovery"}):
            with self.subTest(changes=changes), self.assertRaises(mod.Invalid):
                mod.register(str(self.common), dict(self.data, **changes))
        self.assertFalse(self.registry.exists())
        foreign = types.SimpleNamespace(st_mode=0o100600, st_uid=os.getuid() + 1, st_nlink=1)
        with self.assertRaises(mod.Invalid):
            mod.owned(foreign, private=True, regular=True)

    def test_entry_limit_never_returns_a_truncated_candidate_set(self):
        mod.register(str(self.common), self.data)
        mod.register(str(self.common), dict(self.data, run_id="run-two"))
        with patch.object(mod, "MAX_ENTRIES", 1):
            with self.assertRaises(mod.Invalid):
                mod.discover(str(self.common))
            with self.assertRaises(mod.Invalid):
                mod.register(str(self.common), dict(self.data, run_id="run-three"))
        self.assertEqual(len(list(self.registry.iterdir())), 2)

    def git(self, *args, cwd=None):
        env = {k: v for k, v in os.environ.items() if not k.startswith("GIT_")}
        env.update(GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_SYSTEM=os.devnull,
                   GIT_OPTIONAL_LOCKS="0", GIT_NO_LAZY_FETCH="1", GIT_TERMINAL_PROMPT="0")
        return subprocess.check_output(["git", "-c", "core.fsmonitor=false", "-c", "core.hooksPath=" + os.devnull,
            "-c", "user.name=Helm fixture", "-c", "user.email=fixture@example.invalid", *args],
            cwd=cwd or self.workspace, env=env, stderr=subprocess.PIPE).decode().strip()

    def test_git_worktrees_share_handoff_but_a_new_clone_does_not(self):
        self.git("init", "--quiet", "--initial-branch=main")
        self.git("commit", "--quiet", "--allow-empty", "-m", "chore(fixture): initialize")
        mod.register(str(self.common), self.data)
        worktree = self.root / "second terminal checkout"
        self.git("worktree", "add", "--quiet", "-b", "fixture", str(worktree))
        shared = self.git("rev-parse", "--path-format=absolute", "--git-common-dir", cwd=worktree)
        self.assertEqual(shared, str(self.common))
        self.assertEqual(json.loads(self.cli("discover", common=shared).stdout)["candidates"][0]["run_id"], "run-one")
        clone = self.root / "different clone"
        self.git("clone", "--quiet", "--local", "--no-hardlinks", str(self.workspace), str(clone))
        self.assertEqual(json.loads(self.cli("discover", common=clone / ".git").stdout)["candidates"], [])
        self.assertFalse((clone / ".git/agent-helm").exists())

    def test_locator_moves_with_renamed_checkout_while_external_backup_stays(self):
        mod.register(str(self.common), self.data)
        renamed = self.root / "renamed consumer"
        self.workspace.rename(renamed)
        self.assertEqual(mod.discover(str(renamed / ".git"))["candidates"][0], dict(self.data, availability="present"))


@unittest.skipUnless(hasattr(os, "O_NOFOLLOW") and hasattr(os, "getuid"), "POSIX retention checks")
class RetentionTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="helm-retention-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name).resolve()
        self.common = self.root / "consumer/.git"
        self.common.mkdir(parents=True)
        self.home = self.root / "owned test home"
        self.base = self.home / "Agent Helm/normalize"
        self.base.mkdir(parents=True, mode=0o700)
        self.patch = patch.object(retention, "home_directory", return_value=self.home)
        self.patch.start()
        self.addCleanup(self.patch.stop)

    def run_id(self, number):
        return f"00000000-0000-4000-8000-{number:012d}"

    def add_run(self, number, kind="normalize"):
        run = self.run_id(number)
        base = self.home / "Agent Helm" / kind
        base.mkdir(mode=0o700, parents=True, exist_ok=True)
        path = base / run
        path.mkdir(mode=0o700)
        bundle = "recovery.bundle" if kind == "normalize" else "remote-before.bundle"
        for name, raw in (("handoff.json", b'{"verified":true}\n'), (bundle, b"Synthetic recovery bytes\n")):
            (path / name).write_bytes(raw)
            (path / name).chmod(0o600)
        data = {"run_id": run, "recovery_directory": str(path), "entrypoint": "handoff.json"}
        if kind == "normalize":
            mod.register(str(self.common), data)
        else:
            retention.register_ship(str(self.common), data)
        return path

    def request(self, number, required=()):
        return {"schema_version": 1, "run_id": self.run_id(number), "git_common_dir": str(self.common),
                "completed_at": f"2026-01-{number:02d}T00:00:00Z", "published_refs": [{
                    "local_ref": "refs/heads/main", "remote_ref": "refs/heads/main",
                    "commit": "a" * 40, "destination_id": "b" * 64}],
                "release_outcome": "skipped", "required_runs": list(required)}

    def finish(self, number, required=()):
        digest = retention.inspect(str(self.common))[2]
        return retention.complete(str(self.common), self.request(number, required), digest)

    def test_symlinked_os_home_supports_canonical_backup_registration_and_retention(self):
        self.patch.stop()
        alias = self.root / "home alias"
        alias.symlink_to(self.home, target_is_directory=True)
        account = types.SimpleNamespace(pw_dir=str(alias))
        with patch.object(retention.pwd, "getpwuid", return_value=account):
            self.assertEqual(retention.home_directory(), self.home)
            for number in range(1, 5):
                self.add_run(number, "normalize" if number % 2 else "ship")
                result = self.finish(number)
            self.assertEqual(result["deleted_runs"], [self.run_id(1)])
            self.assertEqual(result["kept_completed"], 3)
            self.assertFalse((self.base / self.run_id(1)).exists())
            _, runs, _, opaque = retention.inspect(str(self.common))
            self.assertFalse(opaque)
            self.assertEqual({run["backup_kind"] for run in runs}, {"normalize", "ship"})

    def test_unavailable_or_cyclic_os_home_stops_without_exposing_the_path(self):
        self.patch.stop()
        cycle = self.root / "private-home-cycle"
        cycle.symlink_to(cycle, target_is_directory=True)
        for path in (self.root / "private-missing-home", cycle):
            with self.subTest(path=path.name), patch.object(retention.pwd, "getpwuid",
                    return_value=types.SimpleNamespace(pw_dir=str(path))):
                with self.assertRaises(retention.Invalid) as caught:
                    retention.home_directory()
                self.assertEqual(str(caught.exception), "OS home directory cannot be resolved safely")

    def test_fourth_completed_cycle_removes_only_oldest_folder_and_matching_locator(self):
        for number in range(1, 5):
            self.add_run(number)
            result = self.finish(number)
        self.assertEqual(result["deleted_runs"], [self.run_id(1)])
        self.assertEqual(result["kept_completed"], 3)
        self.assertGreater(result["recovered_bytes"], 0)
        self.assertFalse((self.base / self.run_id(1)).exists())
        found = mod.discover(str(self.common))
        self.assertFalse(found["issues"])
        self.assertEqual({x["run_id"] for x in found["candidates"]}, {self.run_id(n) for n in (2, 3, 4)})

    def test_completion_time_not_folder_mtime_orders_retention(self):
        for number in range(1, 4):
            self.add_run(number)
            self.finish(number)
        os.utime(self.base / self.run_id(1), (2100000000, 2100000000))
        self.add_run(4)
        self.assertEqual(self.finish(4)["deleted_runs"], [self.run_id(1)])

    def test_mixed_backup_types_share_three_total_slots_and_keep_registries_distinct(self):
        paths = {}
        for number, kind in ((1, "normalize"), (2, "ship"), (3, "normalize"), (4, "ship")):
            paths[number] = self.add_run(number, kind)
            result = self.finish(number)
        self.assertEqual(result["deleted_runs"], [self.run_id(1)])
        self.assertEqual(result["kept_completed"], 3)
        self.assertFalse(paths[1].exists())
        self.assertTrue(all(paths[n].exists() for n in (2, 3, 4)))
        self.assertEqual({x["run_id"] for x in mod.discover(str(self.common))["candidates"]}, {self.run_id(3)})
        self.assertEqual({x["backup_kind"] for x in retention.inspect(str(self.common))[1]}, {"normalize", "ship"})
        self.add_run(5)
        result = self.finish(5)
        self.assertEqual(result["deleted_runs"], [self.run_id(2)])
        self.assertFalse(paths[2].exists())
        self.assertFalse((self.common / "agent-helm/ship-backups" / (self.run_id(2) + ".json")).exists())
        self.assertTrue(paths[3].exists())

    def test_dependencies_cross_backup_types_and_unknown_ship_work_protects_both(self):
        self.add_run(1, "ship")
        self.finish(1)
        self.add_run(2)
        self.finish(2, [self.run_id(1)])
        self.add_run(3, "ship")
        self.finish(3, [self.run_id(2)])
        for number, kind in ((4, "normalize"), (5, "ship")):
            self.add_run(number, kind)
            result = self.finish(number)
        self.assertEqual(result["kept_completed"], 5)
        self.assertEqual(result["protected_runs"], [self.run_id(1), self.run_id(2)])
        self.add_run(9, "ship")
        self.add_run(6)
        self.assertEqual(self.finish(6)["cleanup"], "skipped")
        self.assertTrue((self.home / "Agent Helm/ship" / self.run_id(1)).exists())

    def test_ship_registration_requires_fixed_storage_and_unique_cross_type_identity(self):
        normal = self.add_run(1)
        wrong = {"run_id": self.run_id(1), "recovery_directory": str(normal), "entrypoint": "handoff.json"}
        with self.assertRaises(ValueError):
            retention.register_ship(str(self.common), wrong)
        ship = self.home / "Agent Helm/ship" / self.run_id(1)
        ship.mkdir(parents=True, mode=0o700)
        entry = ship / "handoff.json"
        entry.write_text('{}\n')
        entry.chmod(0o600)
        with self.assertRaises(ValueError):
            retention.register_ship(str(self.common), dict(wrong, recovery_directory=str(ship)))
        self.assertFalse((self.common / "agent-helm/ship-backups" / (self.run_id(1) + ".json")).exists())
        self.add_run(2, "ship")
        with self.assertRaises(ValueError):
            self.add_run(2)
        self.assertEqual(len(mod.discover(str(self.common))["candidates"]), 1)

    def test_ship_cli_registration_is_pending_discoverable_and_not_normalize_proof(self):
        run = self.run_id(1)
        path = self.home / "Agent Helm/ship" / run
        path.mkdir(parents=True, mode=0o700)
        index = path / "backup-index.json"
        index.write_text('{"pending":true}\n')
        index.chmod(0o600)
        arguments = [str(HELPER.with_name("normalize_retention.py")), "register-ship",
                     "--git-common-dir", str(self.common), "--run-id", run,
                     "--recovery-directory", str(path), "--entrypoint", index.name]
        output = io.StringIO()
        with patch.object(retention.sys, "argv", arguments), redirect_stdout(output):
            self.assertEqual(retention.main(), 0)
        self.assertEqual(json.loads(output.getvalue())["run_id"], run)
        self.assertEqual(mod.discover(str(self.common)), {"candidates": [], "issues": []})
        found = retention.inspect(str(self.common))[1][0]
        self.assertEqual((found["backup_kind"], found["state"]), ("ship", "protected_unclassified"))
        self.assertEqual((found["recovery_directory"], found["entrypoint"]), (str(path), index.name))
        self.assertFalse((path / retention.RECEIPT).exists())

    def test_changed_fallback_backup_blocks_combined_retirement(self):
        first = self.add_run(1, "ship")
        self.finish(1)
        for number in (2, 3):
            self.add_run(number)
            self.finish(number)
        (first / "remote-before.bundle").write_bytes(b"Preserve changed remote backup")
        self.add_run(4)
        result = self.finish(4)
        self.assertEqual(result["cleanup"], "incomplete")
        self.assertEqual(result["deleted_runs"], [])
        self.assertEqual((first / "remote-before.bundle").read_bytes(), b"Preserve changed remote backup")

    def test_pending_or_unclassified_run_preserves_all_potential_dependencies(self):
        self.add_run(9)
        for number in range(1, 5):
            self.add_run(number)
            result = self.finish(number)
        self.assertEqual(result["cleanup"], "skipped")
        self.assertEqual(len(list(self.base.iterdir())), 5)
        self.assertFalse((self.base / self.run_id(9) / retention.RECEIPT).exists())

    def test_transitive_required_runs_are_kept_outside_three_run_target(self):
        self.add_run(1)
        self.finish(1)
        self.add_run(2)
        self.finish(2, [self.run_id(1)])
        self.add_run(3)
        self.finish(3, [self.run_id(2)])
        for number in (4, 5):
            self.add_run(number)
            result = self.finish(number)
        self.assertEqual(result["deleted_runs"], [])
        self.assertEqual(result["protected_runs"], [self.run_id(1), self.run_id(2)])
        self.assertEqual(result["kept_completed"], 5)

    def test_new_file_changed_file_or_link_blocks_whole_deletion_set(self):
        for number in range(1, 4):
            self.add_run(number)
            self.finish(number)
        added = self.base / self.run_id(1) / "developer-note.txt"
        added.write_text("Preserve new work")
        added.chmod(0o600)
        self.add_run(4)
        result = self.finish(4)
        self.assertEqual(result["cleanup"], "incomplete")
        self.assertEqual(result["deleted_runs"], [])
        self.assertEqual(added.read_text(), "Preserve new work")
        added.unlink()
        bundle = added.parent / "recovery.bundle"
        bundle.write_bytes(b"Changed recovery")
        self.add_run(5)
        self.assertEqual(self.finish(5)["deleted_runs"], [])
        outside = self.root / "outside"
        outside.write_bytes(b"Never delete me")
        bundle.unlink()
        bundle.symlink_to(outside)
        self.add_run(6)
        self.assertEqual(self.finish(6)["deleted_runs"], [])
        self.assertEqual(outside.read_bytes(), b"Never delete me")

    def test_changed_later_candidate_preserves_the_entire_deletion_set(self):
        self.add_run(9)  # Keep two deletion candidates until this cycle completes.
        for number in range(1, 5):
            self.add_run(number)
            self.finish(number)
        candidates = [self.base / self.run_id(number) for number in (1, 2)]
        (candidates[1] / "recovery.bundle").write_bytes(b"Preserve changed later recovery")
        protected = {path: path.read_bytes() for folder in candidates
                     for path in folder.rglob("*") if path.is_file()}
        for number in (1, 2):
            for directory, suffix in (("normalize-handoffs", ".json"),
                                      ("normalize-completions", ".sha256")):
                path = self.common / "agent-helm" / directory / (self.run_id(number) + suffix)
                protected[path] = path.read_bytes()

        result = self.finish(9)

        self.assertEqual(result["cleanup"], "incomplete")
        self.assertEqual(result["deleted_runs"], [])
        self.assertEqual(result["removed_backup_runs"], [])
        self.assertEqual(result["removed_locator_runs"], [])
        self.assertEqual(result["recovered_bytes"], 0)
        self.assertEqual(result["kept_completed"], 5)
        self.assertEqual({path: path.read_bytes() for path in protected}, protected)
        for folder in candidates:
            self.assertEqual({str(path.relative_to(folder)) for path in folder.rglob("*")},
                             {"handoff.json", "recovery.bundle", retention.RECEIPT})
        self.assertFalse(list(self.base.glob(".retiring-*")))
        self.assertNotIn("pending_retirement_directory", result)

    def test_wrong_clone_or_incomplete_release_creates_no_completion(self):
        path = self.add_run(1)
        for changes in ({"git_common_dir": str(self.root / "another/.git")},
                        {"release_outcome": "failed"}, {"published_refs": []}):
            request = dict(self.request(1), **changes)
            with self.subTest(changes=changes), self.assertRaises(ValueError):
                retention.complete(str(self.common), request, retention.inspect(str(self.common))[2])
        self.assertFalse((path / retention.RECEIPT).exists())

    def test_registry_movement_blocks_completion_and_registration_shares_cleanup_lock(self):
        path = self.add_run(1)
        digest = retention.inspect(str(self.common))[2]
        self.add_run(2)
        with self.assertRaises(ValueError):
            retention.complete(str(self.common), self.request(1), digest)
        self.assertFalse((path / retention.RECEIPT).exists())
        with mod.writer_lock(str(self.common)), self.assertRaises(BlockingIOError):
            mod.register(str(self.common), {"run_id": "new-pending-run", "recovery_directory": str(path), "entrypoint": "handoff.json"})
        self.assertFalse((self.common / "agent-helm/normalize-handoffs/new-pending-run.json").exists())

    def test_inspect_is_read_only_and_receipt_retry_is_immutable(self):
        path = self.add_run(1)
        before = {p: p.read_bytes() for p in self.root.rglob("*") if p.is_file()}
        self.assertEqual(retention.inspect(str(self.common))[1][0]["state"], "protected_unclassified")
        self.assertEqual({p: p.read_bytes() for p in self.root.rglob("*") if p.is_file()}, before)
        self.finish(1)
        receipt = path / retention.RECEIPT
        stamp = (receipt.stat().st_ino, receipt.stat().st_mtime_ns, receipt.read_bytes())
        self.assertEqual(self.finish(1)["status"], "already_completed")
        self.assertEqual((receipt.stat().st_ino, receipt.stat().st_mtime_ns, receipt.read_bytes()), stamp)
        with self.assertRaises(ValueError):
            retention.complete(str(self.common), dict(self.request(1), completed_at="2026-02-01T00:00:00Z"), retention.inspect(str(self.common))[2])

    def test_cleanup_failure_preserves_pointer_and_reports_separately(self):
        for number in range(1, 4):
            self.add_run(number)
            self.finish(number)
        self.add_run(4)
        with patch.object(retention.shutil, "rmtree", side_effect=PermissionError("Synthetic cleanup failure")) as remove:
            remove.avoids_symlink_attacks = True
            result = self.finish(4)
        self.assertEqual(result["status"], "completed")
        self.assertEqual(result["cleanup"], "incomplete")
        self.assertTrue((Path(result["pending_retirement_directory"]) / "backup/recovery.bundle").exists())
        self.assertIsNone(result["kept_completed"])
        self.assertEqual(len(mod.discover(str(self.common))["candidates"]), 4)

    def test_partial_success_and_post_folder_pointer_failure_report_actual_effects(self):
        self.add_run(9)  # Defer cleanup so the final cycle has two candidates.
        for number in range(1, 5):
            self.add_run(number)
            self.finish(number)
        remove = retention.shutil.rmtree
        calls = []

        def fail_second(path, **kwargs):
            calls.append(path)
            if len(calls) == 2:
                raise PermissionError("Synthetic second deletion failure")
            return remove(path, **kwargs)

        with patch.object(retention.shutil, "rmtree", side_effect=fail_second) as mocked:
            mocked.avoids_symlink_attacks = True
            result = self.finish(9)
        self.assertEqual(result["deleted_runs"], [self.run_id(1)])
        self.assertEqual(result["removed_backup_runs"], [self.run_id(1)])
        self.assertEqual(result["removed_locator_runs"], [self.run_id(1)])
        self.assertEqual(result["uncertain_run"], self.run_id(2))
        self.assertGreater(result["recovered_bytes"], 0)
        self.assertFalse((self.base / self.run_id(1)).exists())
        self.assertTrue((Path(result["pending_retirement_directory"]) / "backup").exists())

    def test_pointer_unlink_failure_does_not_hide_successful_backup_deletion(self):
        for number in range(1, 4):
            self.add_run(number)
            self.finish(number)
        self.add_run(4)
        unlink = retention.os.unlink

        def refuse_pointer(path, **kwargs):
            if path == self.run_id(1) + ".json":
                raise PermissionError("Synthetic pointer failure")
            return unlink(path, **kwargs)

        with patch.object(retention.os, "unlink", side_effect=refuse_pointer):
            result = self.finish(4)
        self.assertEqual(result["removed_backup_runs"], [self.run_id(1)])
        self.assertEqual(result["removed_locator_runs"], [])
        self.assertEqual(result["deleted_runs"], [])
        self.assertEqual(result["kept_completed"], 3)
        self.assertGreater(result["recovered_bytes"], 0)
        self.assertTrue((self.common / "agent-helm/normalize-handoffs" / (self.run_id(1) + ".json")).exists())

    def test_hardlink_and_wrong_clone_receipt_are_protected(self):
        for number in range(1, 4):
            self.add_run(number)
            self.finish(number)
        bundle = self.base / self.run_id(1) / "recovery.bundle"
        os.link(bundle, self.root / "shared-hardlink")
        self.add_run(4)
        result = self.finish(4)
        self.assertEqual(result["deleted_runs"], [])
        self.assertTrue(bundle.exists())
        receipt = bundle.parent / retention.RECEIPT
        saved = json.loads(receipt.read_text())
        saved["request"]["git_common_dir"] = str(self.root / "other/.git")
        receipt.write_text(json.dumps(saved))
        self.add_run(5)
        self.assertEqual(self.finish(5)["cleanup"], "skipped")

    def test_replaced_root_is_preserved_after_atomic_claim(self):
        for number in range(1, 4):
            self.add_run(number)
            self.finish(number)
        self.add_run(4)
        rename = retention.os.rename
        original = self.base / self.run_id(1)
        preserved = self.root / "original completed recovery"

        def replace_root(source, destination, **kwargs):
            if source == self.run_id(1):
                rename(original, preserved)
                original.mkdir(mode=0o700)
                (original / "new-user-work").write_text("Preserve replacement contents")
            return rename(source, destination, **kwargs)

        with patch.object(retention.os, "rename", side_effect=replace_root):
            result = self.finish(4)
        self.assertEqual(result["deleted_runs"], [])
        self.assertTrue((preserved / "recovery.bundle").exists())
        staged = Path(result["pending_retirement_directory"]) / "backup/new-user-work"
        self.assertEqual(staged.read_text(), "Preserve replacement contents")

    def test_missing_dependency_and_malformed_completion_preserve_backups(self):
        for number in range(1, 4):
            self.add_run(number)
            self.finish(number)
        self.add_run(4)
        result = self.finish(4, [self.run_id(8)])
        self.assertEqual(result["cleanup"], "skipped")
        self.assertEqual(result["deleted_runs"], [])
        receipt = self.base / self.run_id(1) / retention.RECEIPT
        receipt.write_bytes(b'{"malformed-private-canary":')
        self.add_run(5)
        result = self.finish(5)
        self.assertEqual(result["cleanup"], "skipped")
        self.assertTrue((self.base / self.run_id(1)).exists())
        self.assertNotIn("malformed-private-canary", json.dumps(result))

    def test_changed_completion_time_or_dependencies_cannot_authorize_cleanup(self):
        for number in range(1, 4):
            self.add_run(number)
            self.finish(number)
        receipt = self.base / self.run_id(1) / retention.RECEIPT
        record = json.loads(receipt.read_text())
        record["request"]["completed_at"] = "2025-01-01T00:00:00Z"
        receipt.write_text(json.dumps(record))
        self.add_run(4)
        result = self.finish(4)
        self.assertEqual(result["cleanup"], "skipped")
        self.assertEqual(result["deleted_runs"], [])
        self.assertTrue((receipt.parent / "recovery.bundle").exists())

    def test_cli_isolated_import_read_only_inspection_and_secret_safe_errors(self):
        path = self.add_run(1)
        helper = str(HELPER.with_name("normalize_retention.py"))
        command = [sys.executable, "-I", "-B", helper, "inspect", "--git-common-dir", str(self.common)]
        before = {p: p.read_bytes() for p in self.root.rglob("*") if p.is_file()}
        result = subprocess.run(command, cwd=self.root, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout)["runs"][0]["state"], "protected_unclassified")
        command[4] = "complete"
        command += ["--expect-digest", json.loads(result.stdout)["digest"]]
        result = subprocess.run(command, cwd=self.root, input='{"private-canary":', capture_output=True, text=True)
        self.assertEqual(result.returncode, 2)
        self.assertEqual(result.stderr, "")
        self.assertNotIn("private-canary", result.stdout)
        self.assertFalse((path / retention.RECEIPT).exists())
        self.assertEqual({p: p.read_bytes() for p in self.root.rglob("*") if p.is_file()}, before)
        linked_entry = self.root / "linked-retention.py"
        linked_entry.symlink_to(helper)
        linked = subprocess.run([sys.executable, "-I", "-B", str(linked_entry), "inspect", "--git-common-dir", str(self.common)],
                                cwd=self.root, capture_output=True, text=True)
        self.assertEqual(linked.returncode, 0, linked.stderr)
        self.assertEqual(json.loads(linked.stdout)["runs"][0]["state"], "protected_unclassified")


if __name__ == "__main__":
    unittest.main()
