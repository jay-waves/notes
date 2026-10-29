# Static site build

Run from the repository root:

```sh
python .github/scripts/build_site.py --comrak /path/to/lib.comrak --typst-wrapper /path/to/typst.py
```

The default output is `_site/`. The Typst wrapper defaults to `E:/typst-template/typst.py` locally and can also be specified with the `TYPST_WRAPPER` environment variable. Both compilers must support `--site-root`; the Typst package, dependencies, and fonts must already be installed.

For CI, use the default branch of [jay-waves/ypst-template](https://github.com/jay-waves/ypst-template). The workflow records its commit SHA and includes it in the compilation cache fingerprint. Install the package with `python3 install.py`, install its `requirements.txt`, and pass the checkout's `typst.py` via `--typst-wrapper`. The template requires Typst 0.15 or newer. Validate the exact Typst version, fonts, and generated output in the Linux build.

The input list comes from `git ls-files --cached --others --exclude-standard`: tracked files and untracked files not ignored by Git are included. As with Git, already tracked files remain included even if an ignore rule matches them. Deleted files are skipped. The build infrastructure in `.github/`, Git internals, the reserved `_shared/` root, and the output directory are excluded. Symlinks are rejected. Review untracked files before building or publishing: files not ignored by Git are eligible for publication.

Markdown and Typst are compiled to `<source-without-extension>/index.html`. Every other input is copied as a raw file at the same path and appears in the index. Whether a browser opens or downloads a raw file depends on the server's content type and browser support. A document compiler error skips that document and records its diagnostic in a JSON report; the rest of the site is built. Missing executables, output collisions and other infrastructure errors still stop the build. The output directory must be absent or contain the build's `.notes-site-output` marker.

The index and 404 templates and their shared CSS live in `.github/pages/`; `.github/scripts/pages_index.py` generates directory indexes at their corresponding site paths from the actual build manifest. The build rejects collisions between directory indexes and document or raw-file output. The 404 links assume the site is served at the domain root, as in a standard Pages project.

The workflow downloads the Linux x86-64 lib.comrak archive from the latest GitHub release, verifies its SHA-256 against GitHub release metadata, installs Typst 0.15.1 and the current template, checks generated URLs and uploads the site as an artifact. The compiler executable is fingerprinted for caching. The recorded commit and digest identify each build's inputs; since upstream versions move, future builds may differ or encounter incompatible changes. Builds run on pushes to `main`, pull requests and manual dispatch. Skipped documents appear in the Actions summary and the separate `site-build-report` artifact.

The workflow restores a cache of previously compiled pages and compares the cached commit with the current working tree using Git. Unchanged Markdown and Typst pages are reused; changed, new, or previously failed pages are compiled. Raw files and directory pages are regenerated from the current repository. Compiler binaries, template files, fonts, or build-script changes invalidate the cache. If the cache or base commit is unavailable, the build is full. The summary reports the number of reused pages.

**Resource changes do not trigger article recompilation.** This assumes documents compile independently: changes to images, bibliography files, imported Typst sources, chart modules, or other dependencies can leave embedded or rendered content stale. When such a change should affect an article, manually run the workflow on `main` and select `full_build`; this recompiles all documents and refreshes the cache. Compilers' shared resources are preserved in the cache. Typst bundle reuse currently assumes its output is the page HTML plus shared resources.

For deployment, create a Cloudflare Pages Direct Upload project and configure the GitHub environment `cloudflare-pages`: set secrets `ACCOUNT_ID` and `API_TOKEN` (a Cloudflare API token with Pages Edit permission), and variable `PAGES` to the project name. Pushes to `main` deploy automatically after the build and checks succeed; a manual run on `main` can deploy using the `deploy` input. Pull requests only build a preview. Environment protection rules still apply. Never commit credentials. The check detects file and localhost URLs and missing shared resources; it does not validate all article links, images, or browser interactions.
