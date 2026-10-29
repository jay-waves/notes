#!/usr/bin/env python3
"""Check that generated pages use deployable URLs for shared resources."""
import ipaddress
import posixpath
from html.parser import HTMLParser
from pathlib import Path
import sys
from urllib.parse import unquote, urlsplit


class Links(HTMLParser):
    def __init__(self):
        super().__init__()
        self.urls = []

    def handle_starttag(self, tag, attrs):
        for name, value in attrs:
            if name in ("href", "src", "poster") and value:
                self.urls.append(value)


def check(root):
    root = root.resolve()
    errors = []
    for page in root.rglob("*.html"):
        parser = Links()
        parser.feed(page.read_text(encoding="utf-8"))
        for url in parser.urls:
            parsed = urlsplit(url)
            host = (parsed.hostname or "").lower()
            try:
                loopback = ipaddress.ip_address(host).is_loopback
            except ValueError:
                loopback = host == "localhost" or host.endswith(".localhost")
            if parsed.scheme.lower() == "file" or loopback:
                errors.append(f"{page.relative_to(root)}: local-only URL: {url}")
                continue
            if parsed.scheme or parsed.netloc or not parsed.path:
                continue
            path = unquote(parsed.path)
            page_dir = page.parent.relative_to(root).as_posix()
            if path.startswith("/"):
                url_path = posixpath.normpath(path)
            else:
                url_path = posixpath.normpath("/" + page_dir + "/" + path)
            resolved = (root / url_path.lstrip("/")).resolve()
            try:
                resolved.relative_to(root)
            except ValueError:
                errors.append(f"{page.relative_to(root)}: URL leaves site root: {url}")
                continue
            if "_shared" in resolved.relative_to(root).parts and not resolved.is_file():
                errors.append(f"{page.relative_to(root)}: missing shared resource: {url}")
    return errors


if __name__ == "__main__":
    site = Path(sys.argv[1]).resolve()
    failures = check(site)
    for failure in failures:
        print(failure, file=sys.stderr)
    print(f"Checked HTML in {site}: {len(failures)} error(s)")
    sys.exit(bool(failures))
