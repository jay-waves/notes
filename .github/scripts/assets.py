#!/usr/bin/env python3
"""Manage the assets branch mapped to attach/img."""
import argparse
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]
WORKTREE = ROOT / "attach/img"
REF = "refs/heads/assets"


def git(*args, cwd=None):
    result = subprocess.run(["git", *args], cwd=ROOT if cwd is None else cwd, check=True,
                            stdout=subprocess.PIPE, text=True, encoding="utf-8")
    return result.stdout.strip()


def check_worktree():
    if WORKTREE.is_symlink() or not (WORKTREE / ".git").is_file():
        raise ValueError("attach/img must be the assets worktree; run assets.py setup")
    top = Path(git("rev-parse", "--show-toplevel", cwd=WORKTREE)).resolve()
    branch = git("symbolic-ref", "HEAD", cwd=WORKTREE)
    common = git("rev-parse", "--path-format=absolute", "--git-common-dir", cwd=WORKTREE)
    expected = git("rev-parse", "--path-format=absolute", "--git-common-dir")
    if top != WORKTREE.resolve() or branch != REF or Path(common).resolve() != Path(expected).resolve():
        raise ValueError("attach/img is not this repository's assets worktree")


def setup():
    if WORKTREE.exists():
        check_worktree()
    elif git("branch", "--list", "assets"):
        git("worktree", "add", str(WORKTREE), "assets")
    elif git("ls-remote", "--heads", "origin", "assets"):
        git("fetch", "origin", "refs/heads/assets:refs/remotes/origin/assets")
        git("worktree", "add", "-b", "assets", str(WORKTREE), "origin/assets")
    else:
        git("worktree", "add", "--orphan", "-b", "assets", str(WORKTREE))
        git("commit", "--allow-empty", "-m", "Initialize assets branch", cwd=WORKTREE)
    print(f"assets worktree ready: {WORKTREE}")


def reset_history(push=False, dry_run=False):
    check_worktree()
    if git("status", "--porcelain", cwd=WORKTREE):
        raise ValueError("Commit or remove pending changes in attach/img before resetting history")
    old = git("rev-parse", REF)
    expected = ""
    if push:
        remote = git("ls-remote", "--heads", "origin", "assets")
        if remote:
            git("fetch", "origin", "refs/heads/assets")
            expected = git("rev-parse", "FETCH_HEAD")
            git("merge-base", "--is-ancestor", expected, old)
    if dry_run:
        count = git("rev-list", "--count", old)
        print(f"Would replace {count} assets commit(s) with one root commit; push={push}")
        return
    tree = git("rev-parse", f"{old}^{{tree}}")
    new = git("commit-tree", tree, "-m", "Reset assets history")
    # The tree is unchanged, so the worktree and index need no destructive reset.
    git("update-ref", "-m", "Reset assets history", REF, new, old)
    print(f"Reset assets history: {old} -> {new}")
    if push:
        try:
            git("push", f"--force-with-lease={REF}:{expected}", "origin", f"{new}:{REF}")
        except subprocess.CalledProcessError:
            git("update-ref", "-m", "Restore assets after failed push", REF, old, new)
            raise


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("setup", help="create or verify the assets worktree at attach/img")
    reset = commands.add_parser("reset-history", help="replace assets history with one current snapshot")
    reset.add_argument("--push", action="store_true", help="also replace remote history using force-with-lease")
    reset.add_argument("--dry-run", action="store_true", help="preview without changing commits or pushing")
    args = parser.parse_args()
    try:
        if args.command == "setup":
            setup()
        else:
            reset_history(args.push, dry_run=args.dry_run)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        raise SystemExit(str(error)) from error
