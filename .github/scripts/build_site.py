#!/usr/bin/env python3
"""Build a static notes site from Git-tracked and non-ignored files."""
import argparse
import hashlib
import html
import json
import os
from pathlib import Path
import posixpath
import shutil
import subprocess
import sys
import tempfile
import time
from urllib.parse import quote

from pages_index import generate


ROOT = Path(__file__).resolve().parents[2]
PAGES = ROOT / ".github" / "pages"
MARKER = ".notes-site-output"
CODE_LANGUAGES = {".c": "c", ".h": "c", ".cpp": "cpp", ".cc": "cpp", ".hpp": "cpp", ".py": "python", ".js": "javascript", ".ts": "typescript", ".go": "go", ".rs": "rust", ".java": "java", ".sh": "bash", ".sql": "sql", ".css": "css", ".json": "json", ".yaml": "yaml", ".yml": "yaml"}


def code_page(source, target, site_root):
    text = source.read_text(encoding="utf-8")
    name = html.escape(source.name)
    raw = html.escape(quote(source.name, safe=""), quote=True)
    language = CODE_LANGUAGES[source.suffix.lower()]
    script = posixpath.relpath("_shared/site/highlight.min.js", target.parent.relative_to(site_root).as_posix())
    page = f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="color-scheme" content="light dark"><title>{name}</title>
<style>body {{ max-width: 1000px; margin: 2rem auto; padding: 0 1rem; font-family: sans-serif; color: light-dark(#292929,#dedede); background: light-dark(#fafafa,#202020); color-scheme: light dark }} a {{ color: inherit }} pre, code {{ font-family: ui-monospace, SFMono-Regular, Consolas, "Liberation Mono", monospace }} pre {{ overflow-x: auto; padding: 1rem; background: light-dark(#eee,#292929); line-height: 1.5 }} .hljs-comment {{ color: light-dark(#777,#999) }} .hljs-keyword, .hljs-selector-tag {{ color: light-dark(#77535c,#d3a6b0) }} .hljs-string, .hljs-number {{ color: light-dark(#586772,#a9bdcb) }} .hljs-title, .hljs-function {{ font-weight: bold }}</style></head>
<body><p><a href="./">← Directory</a> · <a href="{raw}">Raw file</a></p><h1>{name}</h1><pre><code class="language-{language}">{html.escape(text)}</code></pre>
<script src="{script}" defer onload="hljs.highlightAll()"></script></body></html>
'''
    target.write_text(page, encoding="utf-8", newline="\n")


def cache_fingerprint(args):
    """Fingerprint the compilers and template files that affect output."""
    digest = hashlib.sha256(b"notes-site-cache-v1\0")
    digest.update(os.environ.get("TEMPLATE_COMMIT", "").encode("ascii"))
    paths = [Path(args.comrak).resolve(), Path(args.typst_wrapper).resolve(), Path(__file__).resolve()]
    typst = shutil.which("typst")
    if not typst:
        raise ValueError("Typst executable not found")
    paths.append(Path(typst).resolve())
    template = Path(args.typst_wrapper).resolve().parent
    for name in ("lib.typ", "typst.toml", "html", "fonts", "tools"):
        path = template / name
        paths.extend(sorted(path.rglob("*")) if path.is_dir() else [path])
    if args.typst_font_path:
        path = Path(args.typst_font_path).resolve()
        paths.extend(sorted(path.rglob("*")) if path.is_dir() else [path])
    for path in paths:
        if path.is_file():
            digest.update(str(path.relative_to(template) if path.is_relative_to(template) else path.name).encode("utf-8"))
            with path.open("rb") as file:
                while chunk := file.read(1024 * 1024):
                    digest.update(chunk)
    return digest.hexdigest()


def cached_changes(cache, fingerprint):
    try:
        metadata = json.loads((cache / "metadata.json").read_text(encoding="utf-8"))
        if metadata["fingerprint"] != fingerprint or not (cache / "site" / "_shared").is_dir():
            return None
        result = subprocess.run(["git", "diff", "--no-renames", "--name-only", "-z", metadata["commit"], "--"], cwd=ROOT, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        untracked = subprocess.run(["git", "ls-files", "-z", "--others", "--exclude-standard"], cwd=ROOT, check=True, stdout=subprocess.PIPE)
        return {os.fsdecode(item).replace("\\", "/") for item in (result.stdout + untracked.stdout).split(b"\0") if item}
    except (OSError, KeyError, ValueError, subprocess.CalledProcessError):
        return None


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
        dest = path.with_suffix("") / "index.html" if kind != "Raw" else path
        key = dest.as_posix().casefold()
        if key in claimed:
            raise ValueError(f"Output collision: {path} and {claimed[key]} -> {dest}")
        claimed[key] = path
        result.append((path, dest, kind))
    for path, dest, kind in result:
        if kind == "Raw" and path.suffix.lower() in CODE_LANGUAGES:
            viewer = Path(str(dest) + ".html").as_posix().casefold()
            if viewer in claimed:
                raise ValueError(f"Output collision: code viewer for {path} and {claimed[viewer]}")
            claimed[viewer] = path
    directories = set()
    for path in files:
        parent = path.parent
        while parent.as_posix() != ".":
            directories.add(parent.as_posix().casefold())
            parent = parent.parent
    for directory in directories:
        index = directory + "/index.html"
        if index in claimed:
            raise ValueError(f"Directory index collision: {directory}/ and {claimed[index]}")
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
    cache = Path(args.cache_dir).resolve() if getattr(args, "cache_dir", None) else None
    fingerprint = cache_fingerprint(args) if cache else None
    changed = cached_changes(cache, fingerprint) if cache and not getattr(args, "full", False) else None
    if changed is not None:
        print(f"Incremental build: {len(changed)} changed paths", flush=True)
    elif cache:
        print("Full build: cache unavailable, incompatible, or explicitly bypassed", flush=True)
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".notes-site-build-", dir=output.parent) as temporary:
        stage = Path(temporary) / "site"
        stage.mkdir()
        if changed is not None and (cache / "site" / "_shared").is_dir():
            shutil.copytree(cache / "site" / "_shared", stage / "_shared", dirs_exist_ok=True)
        manifest = []
        failures = []
        durations = []
        reused = 0
        for source, dest, kind in entries:
            target = stage / dest
            if kind == "Raw":
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(ROOT / source, target)
                if source.suffix.lower() in CODE_LANGUAGES:
                    try:
                        code_page(ROOT / source, Path(str(target) + ".html"), stage)
                    except UnicodeDecodeError:
                        pass
            else:
                cached_page = cache / "site" / dest if changed is not None else None
                if cached_page is not None and source.as_posix() not in changed and cached_page.is_file():
                    target.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(cached_page, target)
                    reused += 1
                    url = dest.parent.as_posix() + "/"
                    manifest.append({"source": source.as_posix(), "url": url, "kind": kind})
                    continue
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
            url = dest.parent.as_posix() + "/" if kind != "Raw" else dest.as_posix()
            if kind == "Raw" and source.suffix.lower() in CODE_LANGUAGES and Path(str(target) + ".html").is_file():
                url += ".html"
            manifest.append({"source": source.as_posix(), "url": url, "kind": kind})
        shared = stage / "_shared" / "site"
        shared.mkdir(parents=True, exist_ok=True)
        shutil.copy2(PAGES / "theme.css", shared / "theme.css")
        shutil.copy2(PAGES / "vendor" / "highlight.min.js", shared / "highlight.min.js")
        shutil.copy2(PAGES / "vendor" / "highlight-LICENSE.txt", shared / "highlight-LICENSE.txt")
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
    if cache:
        commit = subprocess.run(["git", "rev-parse", "HEAD"], cwd=ROOT, check=True, stdout=subprocess.PIPE, text=True).stdout.strip()
        cache.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="next-", dir=cache) as temporary:
            next_cache = Path(temporary) / "site"
            next_cache.mkdir()
            shared_output = output / "_shared"
            if shared_output.is_dir():
                shutil.copytree(shared_output, next_cache / "_shared")
            for source, dest, kind in entries:
                if kind != "Raw" and (output / dest).is_file():
                    (next_cache / dest).parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(output / dest, next_cache / dest)
            old = cache / "site"
            if old.exists():
                shutil.rmtree(old)
            next_cache.rename(old)
        (cache / "metadata.json").write_text(json.dumps({"commit": commit, "fingerprint": fingerprint}) + "\n", encoding="utf-8", newline="\n")
    report = Path(args.report).resolve() if args.report else output.parent / "site-build-report.json"
    report.parent.mkdir(parents=True, exist_ok=True)
    report.write_text(json.dumps({"published": len(manifest), "failed": failures, "durations": durations, "reused": reused}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"Published {len(manifest)} files; reused {reused}; skipped {len(failures)} failed documents. Report: {report}")
    return failures


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", default=str(ROOT / "_site"))
    parser.add_argument("--comrak", default="lib.comrak", help="path to the site-mode lib.comrak executable")
    parser.add_argument("--typst-wrapper", default=os.environ.get("TYPST_WRAPPER", "E:/typst-template/typst.py"), help="path to typst.py")
    parser.add_argument("--typst-font-path", help="path to additional Typst fonts")
    parser.add_argument("--report", help="path to JSON build report")
    parser.add_argument("--cache-dir", help="directory for incremental build state")
    parser.add_argument("--full", action="store_true", help="recompile every document")
    args = parser.parse_args()
    try:
        build(args)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Build failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
