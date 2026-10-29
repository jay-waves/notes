#!/usr/bin/env python3
"""Build a static notes site from Git-tracked and non-ignored files."""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time

from pages_index import generate


ROOT = Path(__file__).resolve().parents[2]
PAGES = ROOT / ".github" / "pages"
MARKER = ".notes-site-output"


def inputs(output):
    result = subprocess.run(
        ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard", "--deduplicate"],
        cwd=ROOT, check=True, stdout=subprocess.PIPE,
    )
    files = []
    for name in result.stdout.split(b"\0"):
        if not name:
            continue
        relative = Path(os.fsdecode(name))
        if relative.parts[0] in (".github", ".git", "_shared"):
            continue
        path = ROOT / relative
        if path == output or output in path.parents:
            continue
        if path.is_symlink():
            raise ValueError(f"Symlinks are not supported: {relative}")
        if path.is_file():
            files.append(relative)
    return sorted(set(files), key=lambda p: p.as_posix().casefold())


def plan(files):
    result = []
    claimed = {"index.html": "site index", "404.html": "site 404", MARKER: "site marker"}
    article_paths = {}
    for path in files:
        ext = path.suffix.lower()
        kind = "Markdown" if ext in (".md", ".markdown") else "Typst" if ext == ".typ" else "Raw"
        if kind != "Raw":
            article = path.with_suffix("").as_posix().casefold()
            if article in article_paths:
                raise ValueError(f"Article URL collision: {path} and {article_paths[article]}")
            article_paths[article] = path
        dest = path.with_suffix(".html") if kind == "Markdown" else path.with_suffix("") / "index.html" if kind == "Typst" else path
        key = dest.as_posix().casefold()
        if key in claimed:
            raise ValueError(f"Output collision: {path} and {claimed[key]} -> {dest}")
        claimed[key] = path
        result.append((path, dest, kind))
    keys = set(claimed)
    for key in keys:
        parent = Path(key).parent
        while parent.as_posix() != ".":
            if parent.as_posix() in keys:
                raise ValueError(f"File/directory output collision: {key} and {parent}")
            parent = parent.parent
    return result


def build(args):
    output = Path(args.output).resolve()
    if output == ROOT or ROOT in output.parents and output.parts[len(ROOT.parts)] in (".git", ".github"):
        raise ValueError("Output cannot be the repository root or inside .git or .github")
    if output.exists() and (not output.is_dir() or not (output / MARKER).is_file()):
        raise ValueError(f"Refusing to replace an unmanaged output directory: {output}")
    files = inputs(output)
    entries = plan(files)
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".notes-site-build-", dir=output.parent) as temporary:
        stage = Path(temporary) / "site"
        stage.mkdir()
        manifest = []
        failures = []
        durations = []
        for source, dest, kind in entries:
            target = stage / dest
            if kind == "Raw":
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(ROOT / source, target)
            else:
                if kind == "Markdown":
                    command = [args.comrak, "compile", str(ROOT / source), "--root", str(ROOT), "--site-root", str(stage)]
                else:
                    command = [sys.executable, str(Path(args.typst_wrapper).resolve()), "compile", str(ROOT / source), "--site-root", str(stage), "--", "--root", str(ROOT)]
                    if args.typst_font_path:
                        command.extend(["--font-path", str(Path(args.typst_font_path).resolve())])
                print(f"Compiling {source}", flush=True)
                started = time.monotonic()
                result = subprocess.run(command, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding="utf-8", errors="replace")
                durations.append({"source": source.as_posix(), "kind": kind, "seconds": round(time.monotonic() - started, 3)})
                if result.stdout:
                    print(result.stdout, end="", flush=True)
                if result.stderr:
                    print(result.stderr, end="", file=sys.stderr, flush=True)
                if result.returncode != 0 or not target.is_file():
                    reason = f"exit code {result.returncode}" if result.returncode else "expected output missing"
                    failures.append({"source": source.as_posix(), "kind": kind, "reason": reason, "diagnostic": result.stderr[-4000:]})
                    print(f"Skipping {source}: {reason}", file=sys.stderr, flush=True)
                    target.unlink(missing_ok=True)
                    continue
            url = dest.parent.as_posix() + "/" if kind == "Typst" else dest.as_posix()
            manifest.append({"source": source.as_posix(), "url": url, "kind": kind})
        shared = stage / "_shared" / "site"
        shared.mkdir(parents=True, exist_ok=True)
        shutil.copy2(PAGES / "theme.css", shared / "theme.css")
        shutil.copy2(PAGES / "404.html", stage / "404.html")
        generate(stage, manifest, PAGES)
        (stage / MARKER).write_text("Generated by .github/scripts/build_site.py\n", encoding="utf-8", newline="\n")
        backup = Path(temporary) / "previous"
        if output.exists():
            output.rename(backup)
        try:
            stage.rename(output)
        except OSError:
            if backup.exists():
                backup.rename(output)
            raise
    print(f"Built site in {output}")
    report = Path(args.report).resolve() if args.report else output.parent / "site-build-report.json"
    report.parent.mkdir(parents=True, exist_ok=True)
    report.write_text(json.dumps({"published": len(manifest), "failed": failures, "durations": durations}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"Published {len(manifest)} files; skipped {len(failures)} failed documents. Report: {report}")
    return failures


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", default=str(ROOT / "_site"))
    parser.add_argument("--comrak", default="lib.comrak", help="path to the site-mode lib.comrak executable")
    parser.add_argument("--typst-wrapper", default=os.environ.get("TYPST_WRAPPER", "E:/typst-template/typst.py"), help="path to typst.py")
    parser.add_argument("--typst-font-path", help="path to additional Typst fonts")
    parser.add_argument("--report", help="path to JSON build report")
    args = parser.parse_args()
    try:
        build(args)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Build failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
