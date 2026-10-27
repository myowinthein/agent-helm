"""Locator mechanics in disposable clones; no models, live records or remote writes."""

import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import types
import unittest
from unittest.mock import patch

sys.dont_write_bytecode = True
HELPER = Path(__file__).resolve().parents[1] / "helpers/normalize_handoff.py"
SPEC = importlib.util.spec_from_file_location("normalize_handoff", HELPER)
mod = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(mod)


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


if __name__ == "__main__":
    unittest.main()
