#!/usr/bin/env python3
"""Build a static notes site from Git-tracked and non-ignored files."""
import argparse
import json
import os
from pathlib import Path
import posixpath
import re
import shutil
import subprocess
import sys
import tempfile
import time

from pages_index import generate
from related_notes import is_recommendable, related


ROOT = Path(__file__).resolve().parents[2]
PAGES = ROOT / ".github" / "pages"
MARKER = ".notes-site-output"
CODE_EXTENSIONS = {
    ".c", ".h", ".cpp", ".cc", ".hpp", ".py", ".js", ".ts", ".go", ".rs", ".java",
    ".sh", ".sql", ".css", ".json", ".yaml", ".yml", ".bib",
}


def add_related(stage, manifest):
    """Write recommendation data and add a stable loader to article pages."""
    articles = {entry["url"]: entry for entry in manifest
                if entry["kind"] in ("Markdown", "Typst") and is_recommendable(entry["source"])}
    documents = {url: (ROOT / entry["source"]).read_text(encoding="utf-8")
                 for url, entry in articles.items()}
    recommendations = related(documents)
    data = {url: [{"url": target, "source": articles[target]["source"]}
                  for target in targets] for url, targets in recommendations.items()}
    (stage / "_shared" / "site" / "related-notes.json").write_text(
        json.dumps(data, ensure_ascii=False, separators=(",", ":")) + "\n",
        encoding="utf-8", newline="\n")
    for entry in manifest:
        if entry["kind"] not in ("Markdown", "Typst"):
            continue
        url = entry["url"]
        page = stage / url / "index.html"
        content = page.read_text(encoding="utf-8")
        content = re.sub(r"<!-- related-notes:start -->.*?<!-- related-notes:end -->", "", content, flags=re.S)
        if url in articles:
            assets = posixpath.relpath("_shared/site", url)
            block = (f'<!-- related-notes:start --><link rel="stylesheet" href="{assets}/related-notes.css">'
                     f'<script src="{assets}/related-notes.js" defer></script><!-- related-notes:end -->')
            if re.search(r"</body\s*>", content, flags=re.I):
                content = re.sub(r"</body\s*>", lambda match: block + match.group(), content, count=1, flags=re.I)
        page.write_text(content, encoding="utf-8", newline="\n")


def cached_changes(cache):
    try:
        metadata = json.loads((cache / "metadata.json").read_text(encoding="utf-8"))
        if not (cache / "site" / "_shared").is_dir():
            return None
        result = subprocess.run(["git", "diff", "--no-renames", "--name-only", "-z", metadata["commit"], "--"], cwd=ROOT, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        untracked = subprocess.run(["git", "ls-files", "-z", "--others", "--exclude-standard"], cwd=ROOT, check=True, stdout=subprocess.PIPE)
        changed = {os.fsdecode(item).replace("\\", "/") for item in (result.stdout + untracked.stdout).split(b"\0") if item}
        return changed
    except (OSError, KeyError, ValueError, subprocess.CalledProcessError):
        return None


def inputs(output):
    result = subprocess.run(
        ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard", "--deduplicate"],
        cwd=ROOT, check=True, stdout=subprocess.PIPE,
    )
    assets = ROOT / "attach/tmp"
    if not (assets / ".git").exists():
        raise ValueError("Missing assets checkout at attach/tmp; run .github/setup.py")
    attached = subprocess.run(
        ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard", "--deduplicate"],
        cwd=assets, check=True, stdout=subprocess.PIPE,
    )
    names = list(result.stdout.split(b"\0"))
    names.extend(b"attach/tmp/" + name for name in attached.stdout.split(b"\0") if name)
    files = []
    for name in names:
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
    for path in files:
        ext = path.suffix.lower()
        kind = ("Markdown" if ext in (".md", ".markdown") else
                "Typst" if ext == ".typ" else "Code" if ext in CODE_EXTENSIONS else "Raw")
        dest = path / "index.html" if kind != "Raw" else path
        key = dest.as_posix().casefold()
        if key in claimed:
            raise ValueError(f"Output collision: {path} and {claimed[key]} -> {dest}")
        claimed[key] = path
        result.append((path, dest, kind))
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
    changed = cached_changes(cache) if cache and not getattr(args, "full", False) else None
    if changed is not None:
        print(f"Incremental build: {len(changed)} changed paths", flush=True)
    elif cache:
        print("Full build: cache unavailable or explicitly bypassed", flush=True)
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".notes-site-build-", dir=output.parent) as temporary:
        stage = Path(temporary) / "site"
        stage.mkdir()
        if changed is not None and (cache / "site" / "_shared").is_dir():
            shutil.copytree(cache / "site" / "_shared", stage / "_shared", dirs_exist_ok=True)
            # Site-owned assets are rebuilt below; do not carry old files forward.
            shutil.rmtree(stage / "_shared" / "site", ignore_errors=True)
        manifest = []
        failures = []
        durations = []
        reused = 0
        for source, dest, kind in entries:
            target = stage / dest
            if kind == "Raw":
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(ROOT / source, target)
            else:
                cached_page = cache / "site" / dest if changed is not None else None
                if cached_page is not None and source.as_posix() not in changed and cached_page.is_file():
                    target.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(cached_page, target)
                    reused += 1
                    url = dest.parent.as_posix() + "/"
                    manifest.append({"source": source.as_posix(), "url": url, "kind": kind})
                    continue
                compiler = "ypst" if kind == "Typst" else "cmrak"
                command = [compiler, "compile", str(ROOT / source), "--root", str(ROOT),
                           "--site-root", str(stage)]
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
            manifest.append({"source": source.as_posix(), "url": url, "kind": kind})
        shared = stage / "_shared" / "site"
        shared.mkdir(parents=True, exist_ok=True)
        for name in ("theme.css", "related-notes.css", "related-notes.js"):
            shutil.copy2(PAGES / name, shared / name)
        shutil.copy2(PAGES / "404.html", stage / "404.html")
        generate(stage, manifest, PAGES)
        add_related(stage, manifest)
        # Typst bundles are versioned directories. Retain whole bundles referenced
        # by generated pages, including assets loaded indirectly by their scripts.
        typst_shared = stage / "_shared" / "typst"
        if typst_shared.is_dir():
            pages = [page.read_text(encoding="utf-8") for page in stage.rglob("*.html")]
            for bundle in typst_shared.iterdir():
                if bundle.is_dir() and not any(f"_shared/typst/{bundle.name}/" in page for page in pages):
                    shutil.rmtree(bundle)
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
        (cache / "metadata.json").write_text(json.dumps({"commit": commit}) + "\n", encoding="utf-8", newline="\n")
    report = Path(args.report).resolve() if args.report else output.parent / "site-build-report.json"
    report.parent.mkdir(parents=True, exist_ok=True)
    report.write_text(json.dumps({"published": len(manifest), "failed": failures, "durations": durations, "reused": reused}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"Published {len(manifest)} files; reused {reused}; skipped {len(failures)} failed documents. Report: {report}")
    return failures


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", default=str(ROOT / "_site"))
    parser.add_argument("--report", help="path to JSON build report")
    parser.add_argument("--full", action="store_true", help="recompile every document")
    args = parser.parse_args()
    args.cache_dir = os.environ.get("SITE_CACHE_DIR")
    try:
        build(args)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Build failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
