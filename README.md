# NASA ODSI Contributor Network

An interactive visualization of NASA ODSI's contributions to open-source projects.

<img src="./public/img/site-image.jpg" height="600px" />

This repo is a thin overlay over [`developmentseed/contributor-network`](https://github.com/developmentseed/contributor-network). All visualization code (Python CLI + frontend) lives upstream; this repo holds NASA-specific configuration, branding, and generated data.

This visual is derived from the excellent [ORCA top-contributor-network](https://github.com/nbremer/ORCA/tree/main/top-contributor-network) by Nadieh Bremer.

## Local development

Install dependencies:

```sh
uv sync       # installs the upstream Python CLI pinned by uv.lock
```

Start a dev server:

```sh
scripts/dev.sh
# Open http://localhost:8000/
```

`scripts/dev.sh` syncs the upstream repo into `.upstream-cache/` (gitignored), overlays our `config.toml`, branding assets, and generated data, then runs Vite from inside the cache. Edits to overlay files (`config.toml`, etc.) require restarting the script to take effect.

## Build

Produces `dist/`:

```sh
scripts/build.sh
```

## Refresh data

```sh
export GITHUB_TOKEN="your_token_here"
uv run contributor-network fetch
uv run contributor-network build --directory public/data
```

The weekly `Build data` GitHub Action does this automatically and opens a PR.

## Bump upstream

The `Bump upstream contributor-network` workflow runs weekly and opens a PR when upstream `main` advances. To bump manually:

```sh
scripts/bump-upstream.sh
git add .upstream-ref uv.lock
git commit -m "chore: bump upstream to <sha>"
```

## Configuration

Edit `config.toml` to control:

- **repositories** — GitHub repos to track (`"owner/repo"` format)
- **contributors.core** — NASA ODSI contributors (`github_username = "Display Name"`)
- **branding** — site colors (`primary_color`, `secondary_color`, `text_color`)
- **og_url, og_image, theme_color** — SEO meta tags
- **`.upstream-ref`** (separate file) — SHA of the upstream commit this site builds from

## License

Derived from [ORCA top-contributor-network](https://github.com/nbremer/ORCA/tree/main/top-contributor-network) by Nadieh Bremer and licensed under MPL.
