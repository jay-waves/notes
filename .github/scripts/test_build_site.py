import argparse
import tempfile
import unittest
import subprocess
from pathlib import Path
from unittest.mock import patch

import build_site
import check_site
import pages_index


class BuildTest(unittest.TestCase):
    def test_index_browses_one_directory_at_a_time(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            entries = [{"source": "math/a&b/note.md", "url": "math/a&b/note.html", "kind": "Markdown"}]
            pages_index.generate(root, entries, build_site.PAGES)
            page = (root / "index.html").read_text(encoding="utf-8")
            self.assertIn('href="_directory/math/"', page)
            self.assertNotIn("note.md", page)
            child = (root / "_directory/math/index.html").read_text(encoding="utf-8")
            self.assertIn('href="a%26b/"', child)
            nested = (root / "_directory/math/a&b/index.html").read_text(encoding="utf-8")
            self.assertIn('href="../../../math/a%26b/note.html"', nested)
            self.assertIn('href="../../../"', nested)
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
                page = stage / (source.stem + ".html") if command[0] == "comrak" else stage / source.stem / "index.html"
                page.parent.mkdir(parents=True, exist_ok=True)
                page.write_text("compiled", encoding="utf-8")
                return subprocess.CompletedProcess(command, 0, "", "")

            with patch.object(build_site, "ROOT", root), patch.object(build_site, "inputs", return_value=files), patch.object(build_site.subprocess, "run", side_effect=compile_stub):
                build_site.build(args)
                self.assertEqual((output / "raw.txt").read_text(), "raw")
                self.assertIn('href="a.html"', (output / "index.html").read_text(encoding="utf-8"))
                with patch.object(build_site.subprocess, "run", side_effect=OSError("compiler failed")):
                    with self.assertRaises(OSError):
                        build_site.build(args)
                self.assertTrue((output / "a.html").is_file())

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


if __name__ == "__main__":
    unittest.main()
