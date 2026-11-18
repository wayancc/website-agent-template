# Stack

Status: not chosen        # not chosen | proposed | approved by user
Rule pack: [TBD — docs/stack-rules/<pack>.md]

Written by the architect during Foundation and approved by the user. Every agent reads this file instead of assuming a language. Changing anything here after approval is a human gate.

## Choices

| Layer | Choice | Version |
|---|---|---|
| Language | [TBD] | |
| Framework | [TBD] | |
| Package manager | [TBD] | |
| Templating / UI | [TBD] | |
| Styling | [TBD] | |
| Database | [TBD — or none] | |
| CMS / content editing | [TBD — or none] | |
| Forms | [TBD] | |
| Analytics | [TBD] | |
| Hosting | [TBD] | |

Why this stack (1–3 lines, link to `docs/decisions.md`): [TBD]

## Commands (implemented in `scripts/check.sh`)

| Command | Runs | Notes |
|---|---|---|
| install | [TBD] | |
| lint | [TBD] | |
| types | [TBD] | |
| test | [TBD] | |
| build | [TBD] | |

Skipped commands and why: [TBD — e.g. "types: plain JS, no TypeScript"]

## Local development

- Requirements (runtimes, Docker, database): [TBD]
- Start dev server: [TBD]
- Local URL: [TBD]
- Seed / sample data: [TBD]

## Version files

[TBD — e.g. `.nvmrc`, `.php-version`, `.python-version`, `.ruby-version`, `.java-version`, `go.mod`, `global.json`, `rust-toolchain.toml`. CI reads these.]

## Previews & environments

- Preview type: [TBD — per-branch preview | shared staging | local + screenshots]
- Staging URL: [TBD]
- Production deploy: [TBD — e.g. automatic on merge to `main` via <host>]
- Rollback: [TBD]

## Web root & secrets

- Public web root (only this folder is reachable from the web): [TBD]
- Environment variables: listed in `.env.example`; production values stored in: [TBD]

## CI additions

[TBD — extra setup steps added to `.github/workflows/ci.yml` (database service, Hugo, browsers…), or "none"]
