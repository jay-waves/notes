"""Generate a catalogue from the build manifest."""
import html
import posixpath
from urllib.parse import quote


def generate(root, entries, template_dir):
    tree = {"directories": {}, "files": []}
    for entry in entries:
        parts = entry["source"].split("/")
        directory = tree
        for part in parts[:-1]:
            directory = directory["directories"].setdefault(part, {"directories": {}, "files": []})
        directory["files"].append((parts[-1], entry))

    template = (template_dir / "index.html").read_text(encoding="utf-8")

    def page_url(path):
        return "/".join(path) + "/" if path else ""

    def link(target, current):
        value = posixpath.relpath(target or ".", current or ".")
        if not value.endswith("/"):
            value += "/"
        return html.escape(quote(value, safe="/."), quote=True)

    def render(directory, path):
        current = page_url(path)
        rows = []
        for name, child in sorted(directory["directories"].items(), key=lambda item: item[0].casefold()):
            child_path = path + [name]
            url = link(page_url(child_path), current)
            rows.append(f'<li class="directory"><a href="{url}">{html.escape(name)}/</a></li>')
            render(child, child_path)
        for name, entry in sorted(directory["files"], key=lambda item: item[0].casefold()):
            relative = posixpath.relpath(entry["url"], current or ".")
            if entry["url"].endswith("/"):
                relative += "/"
            url = html.escape(quote(relative, safe="/."), quote=True)
            rows.append(f'<li class="file"><a href="{url}">{html.escape(name)}</a></li>')
        body = f'<ul>{"".join(rows)}</ul>' if rows else '<p class="muted">No files to display.</p>'
        crumbs = [f'<a href="{link("", current)}">notes</a>']
        for index, name in enumerate(path):
            if index == len(path) - 1:
                crumbs.append(f'<span aria-current="page">{html.escape(name)}</span>')
            else:
                crumbs.append(f'<a href="{link(page_url(path[:index + 1]), current)}">{html.escape(name)}</a>')
        stylesheet = html.escape(quote(posixpath.relpath("_shared/site/theme.css", current or "."), safe="/."), quote=True)
        content = (template.replace("<!-- CONTENT -->", body)
                   .replace("<!-- BREADCRUMBS -->", " / ".join(crumbs))
                   .replace("<!-- STYLESHEET -->", stylesheet))
        output = root / current / "index.html"
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(content, encoding="utf-8", newline="\n")

    render(tree, [])
