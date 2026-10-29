import argparse
import json
import tempfile
import unittest
import subprocess
from pathlib import Path
from unittest.mock import patch

import build_site
import check_site
import pages_index


class BuildTest(unittest.TestCase):
    def test_site_check_clamps_parent_paths_at_url_root(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            page = root / "ai" / "nlp" / "note.html"
            page.parent.mkdir(parents=True)
            page.write_text('<img src="../../../assets/example.png">', encoding="utf-8")
            self.assertEqual(check_site.check(root), [])

    def test_git_diff_tracks_edits_deletions_and_untracked(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            subprocess.run(["git", "init", "-q", str(root)], check=True)
            (root / "old.md").write_text("old", encoding="utf-8")
            (root / "changed.typ").write_text("old", encoding="utf-8")
            subprocess.run(["git", "add", "old.md", "changed.typ"], cwd=root, check=True)
            subprocess.run(["git", "-c", "user.name=Test", "-c", "user.email=test@example.org", "commit", "-qm", "base"], cwd=root, check=True)
            commit = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip()
            (root / "old.md").unlink()
            (root / "changed.typ").write_text("new", encoding="utf-8")
            (root / "new.md").write_text("new", encoding="utf-8")
            cache = root / ".cache"
            (cache / "site" / "_shared").mkdir(parents=True)
            (cache / "metadata.json").write_text(json.dumps({"commit": commit, "fingerprint": "v1"}), encoding="utf-8")
            with patch.object(build_site, "ROOT", root):
                changed = build_site.cached_changes(cache, "v1")
            self.assertTrue({"old.md", "changed.typ", "new.md"} <= changed)

    def test_index_browses_one_directory_at_a_time(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            entries = [{"source": "math/a&b/note.md", "url": "math/a&b/note.html", "kind": "Markdown"}]
            pages_index.generate(root, entries, build_site.PAGES)
            page = (root / "index.html").read_text(encoding="utf-8")
            self.assertIn('href="math/"', page)
            self.assertNotIn("note.md", page)
            child = (root / "math/index.html").read_text(encoding="utf-8")
            self.assertIn('href="a%26b/"', child)
            nested = (root / "math/a&b/index.html").read_text(encoding="utf-8")
            self.assertIn('href="note.html"', nested)
            self.assertIn('href="../../"', nested)
            self.assertNotIn('type="search"', page)

    def test_site_check(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "_shared").mkdir()
            (root / "_shared" / "theme.css").write_text("", encoding="utf-8")
            page = root / "index.html"
            page.write_text('<link href="_shared/theme.css"><a href="file:///tmp/a">x</a><script src="/_shared/missing.js"></script>', encoding="utf-8")
            errors = check_site.check(root)
            self.assertEqual(len(errors), 2)
            self.assertTrue(any("local-only" in error for error in errors))
            self.assertTrue(any("missing shared resource" in error for error in errors))

    def test_collisions(self):
        with self.assertRaisesRegex(ValueError, "collision"):
            build_site.plan([Path("a.md"), Path("a.typ")])
        with self.assertRaisesRegex(ValueError, "collision"):
            build_site.plan([Path("a.typ"), Path("a")])
        with self.assertRaisesRegex(ValueError, "collision"):
            build_site.plan([Path("a.typ"), Path("a/note.md")])

    def test_build_and_keep_previous_on_failure(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "a.md").write_text("hello", encoding="utf-8")
            (root / "b.typ").write_text("hello", encoding="utf-8")
            (root / "raw.txt").write_text("raw", encoding="utf-8")
            output = root / "_site"
            args = argparse.Namespace(output=str(output), comrak="comrak", typst_wrapper="typst.py", typst_font_path=None, report=None)
            files = [Path("a.md"), Path("b.typ"), Path("raw.txt")]

            def compile_stub(command, **kwargs):
                stage = Path(command[command.index("--site-root") + 1])
                source = Path(command[2] if command[0] == "comrak" else command[3])
                page = stage / source.stem / "index.html"
                page.parent.mkdir(parents=True, exist_ok=True)
                page.write_text("compiled", encoding="utf-8")
                return subprocess.CompletedProcess(command, 0, "", "")

            with patch.object(build_site, "ROOT", root), patch.object(build_site, "inputs", return_value=files), patch.object(build_site.subprocess, "run", side_effect=compile_stub):
                build_site.build(args)
                self.assertEqual((output / "raw.txt").read_text(), "raw")
                self.assertIn('href="a/"', (output / "index.html").read_text(encoding="utf-8"))
                with patch.object(build_site.subprocess, "run", side_effect=OSError("compiler failed")):
                    with self.assertRaises(OSError):
                        build_site.build(args)
                self.assertTrue((output / "a" / "index.html").is_file())

    def test_failed_article_is_reported_and_omitted(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            output = root / "_site"
            args = argparse.Namespace(output=str(output), comrak="comrak", typst_wrapper="typst.py", typst_font_path=None, report=None)
            files = [Path("broken.typ"), Path("raw.txt")]
            (root / "broken.typ").write_text("broken", encoding="utf-8")
            (root / "raw.txt").write_text("raw", encoding="utf-8")
            with patch.object(build_site, "ROOT", root), patch.object(build_site, "inputs", return_value=files), patch.object(build_site.subprocess, "run", return_value=subprocess.CompletedProcess([], -11, "", "segmentation fault")):
                failures = build_site.build(args)
            self.assertEqual(failures[0]["source"], "broken.typ")
            self.assertIn("-11", failures[0]["reason"])
            self.assertNotIn("broken.typ", (output / "index.html").read_text(encoding="utf-8"))
            self.assertTrue((output / "raw.txt").exists())
            self.assertTrue((root / "site-build-report.json").exists())

    def test_incremental_reuses_only_unchanged_successful_pages(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            output, cache = root / "_site", root / "cache"
            (cache / "site" / "_shared").mkdir(parents=True)
            (cache / "site" / "unchanged").mkdir()
            (cache / "site" / "unchanged" / "index.html").write_text("cached", encoding="utf-8")
            for name in ("unchanged.md", "changed.md", "raw.txt"):
                (root / name).write_text(name, encoding="utf-8")
            args = argparse.Namespace(output=str(output), comrak="comrak", typst_wrapper="typst.py", typst_font_path=None, report=None, cache_dir=str(cache), full=False)
            files = [Path("unchanged.md"), Path("changed.md"), Path("raw.txt")]
            compiled = []

            def run_stub(command, **kwargs):
                if command[:2] == ["git", "rev-parse"]:
                    return subprocess.CompletedProcess(command, 0, "abc\n")
                compiled.append(Path(command[2]).name)
                stage = Path(command[command.index("--site-root") + 1])
                (stage / "changed").mkdir()
                (stage / "changed" / "index.html").write_text("new", encoding="utf-8")
                return subprocess.CompletedProcess(command, 0, "", "")

            with patch.object(build_site, "ROOT", root), patch.object(build_site, "inputs", return_value=files), patch.object(build_site, "cache_fingerprint", return_value="v1"), patch.object(build_site, "cached_changes", return_value={"changed.md", "raw.txt"}), patch.object(build_site.subprocess, "run", side_effect=run_stub):
                build_site.build(args)
            self.assertEqual(compiled, ["changed.md"])
            self.assertEqual((output / "unchanged" / "index.html").read_text(), "cached")
            self.assertEqual((output / "raw.txt").read_text(), "raw.txt")
            self.assertTrue((cache / "site" / "changed" / "index.html").exists())


if __name__ == "__main__":
    unittest.main()
