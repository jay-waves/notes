#!/usr/bin/env python3
"""Warn about missing local paths referenced by Markdown and Typst notes."""
import os
import re
from pathlib import Path
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[2]
PATTERNS = (
    re.compile(r"!?\[[^\]]*\]\(\s*<?([^\s)>]+)>?(?:\s+[^)]*)?\)"),
    re.compile(r"^[ \t]*\[(?!\^)[^\]]+\]:[ \t]*<?([^\s>]+)>?", re.MULTILINE),
    re.compile(r"\b(?:src|href|poster)\s*=\s*[\"']([^\"']+)[\"']", re.IGNORECASE),
    re.compile(r"\b(?:image|link|read|include|import)\s*\(\s*[\"']([^\"']+)[\"']"),
    re.compile(r"#(?:include|import)\s+[\"']([^\"']+)[\"']"),
)


def notes():
    for directory, dirs, files in os.walk(ROOT):
        dirs[:] = [name for name in dirs if not name.startswith('.') and name not in ('_site', 'node_modules')]
        for name in files:
            if Path(name).suffix.lower() in ('.md', '.typ'):
                yield Path(directory) / name


def scan(path):
    text = path.read_text(encoding='utf-8')
    # Fenced examples often contain illustrative paths rather than actual links.
    text = re.sub(
        r'(?ms)^[ \t]*(`{3,}|~{3,})[^\n]*\n.*?^[ \t]*\1[ \t]*$',
        lambda match: '\n' * match.group().count('\n'),
        text,
    )
    text = re.sub(r'`+[^`\n]*`+', lambda match: ' ' * len(match.group()), text)
    seen = set()
    patterns = PATTERNS[2:] if path.suffix.lower() == '.typ' else PATTERNS[:3]
    for pattern in patterns:
        for match in pattern.finditer(text):
            url = match.group(1)
            parsed = urlsplit(url)
            if parsed.scheme or parsed.netloc or not parsed.path or parsed.path.startswith('@'):
                continue
            relative = unquote(parsed.path)
            target = ROOT / relative.lstrip('/') if relative.startswith('/') else path.parent / relative
            if target.exists():
                continue
            line = text.count('\n', 0, match.start()) + 1
            key = (line, url)
            if key not in seen:
                seen.add(key)
                yield line, url


def main():
    count = 0
    for path in notes():
        try:
            for line, url in scan(path):
                count += 1
                message = f'{path.relative_to(ROOT).as_posix()}:{line}: missing path: {url}'
                if os.environ.get('GITHUB_ACTIONS') == 'true':
                    escaped = message.replace('%', '%25').replace('\r', '%0D').replace('\n', '%0A')
                    print(f'::warning::{escaped}')
                else:
                    print(f'Warning: {message}')
        except (OSError, UnicodeError) as error:
            print(f'Warning: could not scan {path.relative_to(ROOT)}: {error}')
    print(f'Path scan: {count} missing reference(s)')


if __name__ == '__main__':
    main()
