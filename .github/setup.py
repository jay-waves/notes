#!/usr/bin/env python3
"""Prepare the assets worktree and update the local ypst template."""
import io
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
from urllib.request import urlopen
from zipfile import ZipFile

from scripts.assets import setup as setup_assets

LATEST_RELEASE = "https://api.github.com/repos/jay-waves/ypst/releases/latest"


def package_directory():
    if sys.platform == "win32":
        base = Path(os.environ["APPDATA"])
    elif sys.platform == "darwin":
        base = Path.home() / "Library/Application Support"
    else:
        base = Path(os.environ.get("XDG_DATA_HOME", ""))
        if not base.is_absolute():
            base = Path.home() / ".local/share"
    return base / "typst/packages/local/ypst-template/0.1.0"


def download_package():
    with urlopen(LATEST_RELEASE, timeout=60) as response:
        release = json.load(response)
    for asset in release["assets"]:
        if asset["name"].startswith("ypst-template-") and asset["name"].endswith(".zip"):
            with urlopen(asset["browser_download_url"], timeout=60) as response:
                return response.read()
    raise ValueError("Latest release has no template ZIP")


def extract_package(data, staging):
    with ZipFile(io.BytesIO(data)) as archive:
        archive.extractall(staging)
    templates = list(staging.glob("ypst-template-*/lib.typ"))
    if len(templates) != 1:
        raise ValueError("Expected one template package in the archive")
    return templates[0].parent


def install_package(staging, destination, commit):
    files = [path for path in staging.rglob("*") if path.is_file()]
    targets = [destination / path.relative_to(staging) for path in files]
    targets.append(destination / ".ypst-commit")
    for target in targets:
        if any(path.is_symlink() for path in [target, *target.parents]):
            raise ValueError(f"Refusing to overwrite a symlink: {target}")
    # Overlay only released files; preserve local fonts and other installed resources.
    shutil.copytree(staging, destination, dirs_exist_ok=True)
    (destination / ".ypst-commit").write_text(commit, encoding="utf-8", newline="\n")


def ypst_setup():
    version = subprocess.run(["ypst", "--version"], check=True, capture_output=True, text=True)
    match = re.search(r"\(commit ([0-9a-f]+)\)", version.stdout)
    if not match:
        raise ValueError("Cannot determine the installed ypst commit")
    data = download_package()
    with tempfile.TemporaryDirectory(prefix="ypst-template-") as temporary:
        staging = extract_package(data, Path(temporary))
        destination = package_directory()
        install_package(staging, destination, match[1])
    print(f"Updated @local/ypst-template:0.1.0 at {destination}")


def main():
    setup_assets()
    ypst_setup()


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        raise SystemExit(str(error)) from error
