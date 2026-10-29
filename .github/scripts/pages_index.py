"""Generate a catalogue from the build manifest."""
import html
from urllib.parse import quote


def generate(root, entries, template_dir):
    groups = {}
    for entry in entries:
        path = entry["source"]
        group = path.split("/", 1)[0] if "/" in path else "Other"
        groups.setdefault(group, []).append(entry)
    sections = []
    for group, items in sorted(groups.items(), key=lambda item: item[0].casefold()):
        rows = []
        for entry in sorted(items, key=lambda item: item["source"].casefold()):
            label = html.escape(entry["source"])
            url = html.escape(quote(entry["url"], safe="/"), quote=True)
            kind = html.escape(entry["kind"])
            search = html.escape(entry["source"].casefold(), quote=True)
            rows.append(f'<li data-search="{search}"><a href="{url}">{label}</a><span>{kind}</span></li>')
        sections.append(f'<section><h2>{html.escape(group)}</h2><ul>{"".join(rows)}</ul></section>')
    body = "\n".join(sections) or '<p class="muted">No files to display.</p>'
    template = (template_dir / "index.html").read_text(encoding="utf-8")
    (root / "index.html").write_text(template.replace("<!-- CONTENT -->", body).replace("<!-- COUNT -->", str(len(entries))), encoding="utf-8", newline="\n")
