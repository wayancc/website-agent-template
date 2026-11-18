# Rust Rule Pack

Covers: Axum, Actix Web, Rocket (server-rendered with Askama / Maud / Tera, plus htmx), and full-stack Leptos / Dioxus. For Zola, use `static.md`.

## Recommended defaults
- Axum + Askama (compile-time templates) + htmx for server-rendered sites.
- Leptos if a rich interactive UI is needed in Rust.
- Database: sqlx (compile-time checked queries) or SeaORM.

## scripts/check.sh
```bash
install() { cargo fetch; }
lint()    { cargo fmt --all --check && cargo clippy --all-targets --all-features -- -D warnings; }
types()   { cargo check --all-targets --all-features; }
test_()   { cargo test --all-features; }
build()   { cargo build --release; }
```
Leptos: build with `cargo leptos build --release` (install cargo-leptos in CI).

## Version file
`rust-toolchain.toml` (pins toolchain + components).

## Project structure & web root
Static assets in a dedicated folder served on a fixed path (e.g. `/static` via `tower-http` ServeDir). Config from environment.

## Coding rules
- No `unwrap()` / `expect()` on anything user-controlled in request paths — return errors.
- Errors via `thiserror` / `anyhow` mapped to proper HTTP responses.
- Clippy clean with `-D warnings`.

## Security
- **Templates:** Askama, Tera and Maud escape HTML by default — never mark user input as safe.
- **Database:** sqlx `query!` / `.bind()` parameters. Never `format!` SQL with input.
- **CSRF:** a CSRF layer for form posts (token or strict origin checking) plus `SameSite` cookies.
- **Timeouts / limits:** request body size limits and timeouts (tower layers).
- **Audit:** `cargo audit` (install `cargo-audit`) or `cargo deny check`.

## Performance & SEO
- Compression and cache headers via tower-http; hashed static filenames.
- Meta tags/sitemap rendered from templates.

## .gitignore additions
```
target/
```

## CI notes
Rust is preinstalled on GitHub runners; CI adds rustfmt + clippy. Respect `rust-toolchain.toml`.

## Hosting & previews
Container or binary: Fly.io, Shuttle, Cloud Run, Railway, VPS. Usually staging.

## Reviewer checks
- [ ] Clippy clean with `-D warnings`
- [ ] `cargo audit`: no unresolved advisories
- [ ] No panics reachable from requests (`unwrap` on input)
- [ ] No user input marked safe in templates; no formatted SQL
