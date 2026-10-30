
Do not modify or delete the user's knowledge content unless explicitly requested.

Write clearly, accurately and concisely, with sound logic and restrained detail. 
Avoid excessive caveats, defensive language, and unnecessary assumptions. 

# Repository guidelines

- This repository contains Markdown and Typst notes organized by subject. Follow the writing, 
    naming, citation, and license guidelines in README.md; see appx/personal-coding-styles.md 
    for code style.
- Store images under `assets/<subject>/` and references in the subject's `references.bib`. Preserve 
    third-party attribution and license information.
- Use spaces for indentation, with an indent size of 4.
- Aim for 100 display columns in prose, counting full-width characters as two; 
    allow longer lines when wrapping would break syntax or readability.
- Use Markdown hard line breaks and standard syntax. 
- Use lowercase and hyphens for ordinary file and directory names 

## Site Workflow (.github)

- Markdown: use `lib.comrak.exe`; supported extensions include tables, KaTeX, footnotes,
  YAML front matter, HTML, Mermaid, and D3 `<viz>` charts.
- Typst: use `@local/ypst-template:0.1.0` and its `typst.py` wrapper for HTML export.
  Use native Typst syntax and the template's helpers; see the template README.
- Build the site with `.github/scripts/build_site.py`; its CLI options are listed in `--help`.
- Changes to images, bibliographies, Typst imports, charts, and other dependencies do not 
    automatically recompile notes; use the workflow's `full_build` when rendered output must be 
    refreshed.

## Markdown 

- Compile with `lib.comrak`. It renders math with KaTeX, code with highlight.js,
  charts with D3, and Mermaid with Pele.
- Use `<mermaid>...</mermaid>` or `<mermaid src="charts/flow.mmd"></mermaid>`
  for diagrams.
- Use a standalone tag for D3 charts:

  ```html
  <viz src="charts/example.js" width="75%" caption="Description"></viz>
  ```

  The path is relative to the Markdown file. See `./github/examples/viz` for details.
- Run `lib.comrak compile note.md --standalone` to check a document.

## Typst

- Import `template` and any needed helpers from `@local/ypst-template:0.1.0`, then use
    `#show: template`. Place `#set document(...)` before the show rule.
- `typst.py` html export allows you to use *pele.js* to render mermaid charts.
- Use absolute #link(https://notes.jay-waves.cn/..) URLs for links between Typst notes. 
