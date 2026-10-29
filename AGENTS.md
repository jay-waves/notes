# lib.comrak D3 charts

When creating a `viz` chart for lib.comrak:

- Put the chart in a local JavaScript ES module. Place a complete tag in its own Markdown block, with its path relative to the Markdown file:

  ```html
  <viz src="charts/example.js" width="75%" caption="Chart description"></viz>
  ```

- `width` and `caption` are optional; width accepts integer percentages (1–100) or pixels (1–10000). The default is centered at up to 640px. Mermaid diagrams use `<mermaid src="charts/flow.mmd" caption="Flow"></mermaid>` or inline source between `<mermaid>` and `</mermaid>`. Mermaid code fences still work but produce a warning.
- Import only `d3` (`import * as d3 from 'd3'`). Inline the data; other module imports and remote modules are unsupported. Keep the chart file inside the compilation `--root`.
- Default-export a synchronous `render(container)` that draws into the supplied container. It runs at compile time in QuickJS and LinkeDOM: use explicit dimensions and an SVG `viewBox`; do not depend on layout measurement, network access, Canvas, timers, animation, or browser-only globals. Output is cached by module source, so avoid time and unseeded randomness. Keep module top-level code compatible with this environment.
- For interaction, also export `hydrate(container)`. The browser calls only `hydrate` on the pre-rendered container; attach event handlers and use browser-only APIs there. D3 bound data is not preserved by SVG serialization: rebind data in `hydrate` before callbacks use it. Without this export, the chart is static and its JavaScript is not included in the HTML. Scope selections to `container` and prefix any SVG IDs with `container.id`.
- Match the document theme with the separate D3 stylesheet's basic palette, typography, axes, grids, and common mark classes. `.series-1` through `.series-4` are subdued data colors; `.accent` / `.series-5` and `.accent-2` / `.series-6` are emphasis colors. Use emphasis selectively. `--viz-accent`, `--viz-accent-2`, `--viz-muted`, and `--viz-grid` are available. Apply `.axis`, `.grid`, `.bar`, `.point`, `.line`, `.area`, `.slice`, `.cell`, `.box`, `.whisker`, `.median`, `.outlier`, `.error-bar`, `.reference`, `.legend`, or `.caption` to suitable SVG elements. Specialized forms such as heatmaps, Sankey diagrams, violin plots, and contours should define their own geometry and any chart-specific styling in the chart module. Give charts a descriptive SVG title or accessible label, and support keyboard interaction when applicable.
- Compile the Markdown with `lib.comrak compile note.md output.html` (add `--root` if needed). Report compile errors and ask the user to check actual browser rendering and interactions. Use `--standalone` for a self-contained preview.

See `examples/viz/boxplot.js` and `examples/viz/note.md` for an interactive example.
