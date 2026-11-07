
Do not modify or delete the user's knowledge content unless explicitly requested.

Write clearly, accurately and concisely, with sound logic and restrained detail.
Avoid excessive caveats, defensive language, and unnecessary assumptions.

# Repository guidelines

- This repository contains Markdown and Typst notes organized by subject. Follow the writing,
    naming, citation, and license guidelines in README.md; see attach/personal-coding-styles.md
    for code style.
- Store images under `attach/img/<subject>/` and references in the subject's `BIBLIO.bib`. Preserve
    third-party attribution and license information.
- Use spaces for indentation, with an indent size of 4.
- Aim for 100 display columns in prose, counting full-width characters as two;
    allow longer lines when wrapping would break syntax or readability.
- Use Markdown hard line breaks and standard syntax.
- Use lowercase and hyphens for ordinary file and directory names

## Site Workflow (.github)

- Markdown: use `comrakk`; supported extensions include tables, KaTeX, footnotes,
  YAML front matter, HTML, `<mermaid>` diagrams, and `<chartist>` charts.
- Typst: use `@local/ypst-template:0.1.0` and `ypst` for HTML export.
  Use native Typst syntax and the template's helpers; see the template README.
- Build the site with `.github/scripts/build_site.py`; its CLI options are listed in `--help`.
- Changes to images, bibliographies, Typst imports, charts, and other dependencies do not
    automatically recompile notes; use the workflow's `full_build` when rendered output must be
    refreshed.

## Chart Style

- Use Paul Tol's Muted qualitative palette for categorical series, with its original color values.
  Choose colors that remain distinct against the background and in grayscale.
- For line charts, emphasize data points with clearly visible, hollow markers with solid outlines.
  Use distinct marker shapes for different series and connect points with lines. Use line styles as
  an additional distinction when helpful, and provide a matching legend.
- Keep axes, units, and any illustrative data clear. Use a sequential or diverging color scale when
  color represents ordered values or deviations from a meaningful midpoint.

## Markdown

- Compile with `comrakk`. It renders math with KaTeX, code with highlight.js,
  Chartist charts, and Mermaid with Pele.
- Use `<mermaid>...</mermaid>` or `<mermaid src="charts/flow.mmd"></mermaid>`
  for diagrams.
- Use a standalone tag for Chartist charts:

  ```html
  <chartist src="charts/example.js" width="75%" caption="Description"></chartist>
  ```

  The path is relative to the Markdown file. See the comrakk repository examples for details.
- Run `comrakk compile note.md --standalone` to check a document.

## Typst

- Import `template` and any needed helpers from `@local/ypst-template:0.1.0`, then use
    `#show: template`. Place `#set document(...)` before the show rule.
- `ypst` supports `#mermaid` and `#chartist` diagrams.
- Pass Mermaid source directly to `#mermaid`, as a literal string or a fenced
    `mermaid` code block in its content argument. A filename string is interpreted
    as diagram text, not loaded as a file. For separate sources, put the whole
    `#mermaid` call in a `.typ` file and `#include` it.
- Import `mermaid` from the template. For example:

  ````typst
  #mermaid(width: 80%, caption: [Workflow])[
  ```mermaid
  flowchart LR
      A[Input] --> B[Output]
  ```
  ]
  ````

- Use `ypst compile main.typ main.html` or
    `ypst compile main.typ main.pdf --pdf` from the document's project directory.
    ypst pre-renders `#mermaid` to SVG for both outputs; plain Typst uses the
    template's placeholder. Bare Mermaid code blocks are a separate HTML-only
    rendering path and remain code in PDF.
- Use absolute #link(https://notes.jay-waves.cn/..) URLs for links between Typst notes.
