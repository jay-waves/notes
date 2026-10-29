# Static site build

Run from the repository root:

```sh
python .github/scripts/build_site.py --comrak /path/to/lib.comrak --typst-wrapper /path/to/typst.py
```

The default output is `_site/`. The Typst wrapper defaults to `E:/typst-template/typst.py` locally and can also be specified with the `TYPST_WRAPPER` environment variable. Both compilers must support `--site-root`; the Typst package, dependencies, and fonts must already be installed.

For CI, use [jay-waves/ypst-template](https://github.com/jay-waves/ypst-template), pinned to commit `0cd3b2358c0cdbebe13a7934c30d82f2ce531d63` until deliberately updated. Install the package with `python3 install.py`, install its `requirements.txt`, and pass the checkout's `typst.py` via `--typst-wrapper`. The template requires Typst 0.15 or newer. Validate the exact Typst version, fonts, and generated output in the Linux build.

The input list comes from `git ls-files --cached --others --exclude-standard`: tracked files and untracked files not ignored by Git are included. As with Git, already tracked files remain included even if an ignore rule matches them. Deleted files are skipped. The build infrastructure in `.github/`, Git internals, the reserved `_shared/` root, and the output directory are excluded. Symlinks are rejected. Review untracked files before building or publishing: files not ignored by Git are eligible for publication.

Markdown is compiled to `<source-without-extension>.html`; Typst is compiled to `<source-without-extension>/index.html`. Every other input is copied as a raw file at the same path and appears in the index. Whether a browser opens or downloads a raw file depends on the server's content type and browser support. A document compiler error skips that document and records its diagnostic in a JSON report; the rest of the site is built. Missing executables, output collisions and other infrastructure errors still stop the build. The output directory must be absent or contain the build's `.notes-site-output` marker.

The index and 404 templates and their shared CSS live in `.github/pages/`; `.github/scripts/pages_index.py` generates the index from the actual build manifest. The 404 links assume the site is served at the domain root, as in a standard Pages project.

The workflow downloads the Linux x86-64 lib.comrak archive from the `0.5.2` release, installs Typst 0.15.1 and the pinned template, checks generated URLs and uploads the site as an artifact. The fixed release must be published first. Its SHA-256 is logged; it is not yet checked against a pinned digest. Builds run on pushes to `main`, pull requests and manual dispatch. Skipped documents appear in the Actions summary and the separate `site-build-report` artifact.

For deployment, create a Cloudflare Pages Direct Upload project and configure the GitHub environment `cloudflare-pages`: set secrets `ACCOUNT_ID` and `API_TOKEN` (a Cloudflare API token with Pages Edit permission), and variable `PAGES` to the project name. Manually run the workflow on `main` with the `deploy` input enabled; deployment runs only after the build and checks succeed and any environment protection rules are satisfied. Never commit credentials. Review the preview in a real browser first. The check detects file and localhost URLs and missing shared resources; it does not validate all article links, images, or browser interactions.
