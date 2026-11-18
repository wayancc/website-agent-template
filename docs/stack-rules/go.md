# Go Rule Pack

Covers: Go web apps with `net/http` (built-in routing patterns), Chi, Echo, Gin; templates via `html/template` or templ; htmx for interactivity. For Hugo, use `static.md`.

## Recommended defaults
- `net/http` + `html/template` (or templ) for most sites — fewest dependencies.
- Chi if middleware/routing needs grow; Echo/Gin if the team already uses them.
- Interactivity: htmx or small vanilla JS; avoid a separate SPA unless needed.

## scripts/check.sh
```bash
install() { go mod download; }
lint()    { test -z "$(gofmt -l .)" || { gofmt -l .; return 1; }
            go vet ./...
            go run honnef.co/go/tools/cmd/staticcheck@latest ./...; }   # or: golangci-lint run
types()   { go build ./...; }                        # the compiler is the type checker
test_()   { go test -race ./...; }
build()   { CGO_ENABLED=0 go build -o bin/server ./cmd/server; }
```
templ: run `go run github.com/a-h/templ/cmd/templ@latest generate` in `build()` before `go build`, and check generated files are committed and current.

## Version file
`go` directive in `go.mod` (CI reads it).

## Project structure & web root
`cmd/server/main.go`, `internal/…` for app code, `web/templates`, `web/static` (served via `http.FileServer` on a dedicated path only). Config from environment.

## Coding rules
- Handle every error; no silent `_ =` on errors without a comment.
- `context.Context` passed through request paths; timeouts on outgoing calls.
- Small packages under `internal/`; no global mutable state.

## Security
- **Templates:** `html/template` (auto-escaping) — never `text/template` for HTML; never wrap user input in `template.HTML`.
- **Database:** `database/sql` (or sqlc/pgx) with placeholders (`$1` / `?`). Never `fmt.Sprintf` SQL with input.
- **CSRF:** a CSRF middleware on state-changing routes (e.g. Go 1.25+ `http.CrossOriginProtection`, or gorilla/csrf).
- **Server:** set `ReadHeaderTimeout`, `ReadTimeout`, `WriteTimeout`, `IdleTimeout` on `http.Server`.
- **Audit:** `go run golang.org/x/vuln/cmd/govulncheck@latest ./...`.

## Performance & SEO
- Cache-Control + hashed filenames for static assets; gzip/brotli via proxy or middleware.
- Render meta tags and sitemap from templates.

## .gitignore additions
```
bin/
*.test
coverage.out
```

## CI notes
Go setup automatic (reads `go.mod`).

## Hosting & previews
Single binary or container: Fly.io, Cloud Run, Railway, Render, VPS. Previews where supported; otherwise staging.

## Reviewer checks
- [ ] `govulncheck`: no reachable vulnerabilities
- [ ] No `text/template` for HTML; no `template.HTML(userInput)`
- [ ] Errors handled; `http.Server` timeouts set
- [ ] CSRF protection on state-changing routes
