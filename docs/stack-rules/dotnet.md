# .NET Rule Pack

Covers: ASP.NET Core — Razor Pages, MVC, Blazor (static SSR / Server / WebAssembly), Minimal APIs. C# (F# follows the same checks).

## Recommended defaults
- **Content / marketing site** → Razor Pages (or Blazor static SSR).
- **Interactive app** → Blazor.
- **API** → Minimal APIs.
- Pin the SDK with `global.json`.

## scripts/check.sh
```bash
install() { dotnet restore; }
lint()    { dotnet format --verify-no-changes --no-restore; }
types()   { dotnet build --no-restore -warnaserror; }       # compiler + analyzers; nullable enabled
test_()   { dotnet test --no-restore; }                     # xUnit/NUnit/MSTest · Playwright for .NET for pages
build()   { dotnet publish -c Release -o out --no-restore; } # name the web project if the solution has several
```
**Windows:** run `check.sh` from Git Bash or WSL.

## Version file
`global.json` (SDK pin — CI reads it). Without it, CI installs the current LTS.

## Project structure & web root
`wwwroot/` is the only publicly served folder. Config in `appsettings.json` (no secrets) + environment-specific overrides.

## Coding rules
- `<Nullable>enable</Nullable>` and `<TreatWarningsAsErrors>` (or `-warnaserror` in CI).
- Dependency injection via the built-in container; thin page models/controllers.
- Schema changes via EF Core migrations.

## Security
- **Output:** Razor encodes by default — no `Html.Raw` / `MarkupString` on user input.
- **CSRF:** antiforgery is on by default for Razor Pages/forms; MVC POST actions use `[ValidateAntiForgeryToken]` (or global filter).
- **Database:** EF Core LINQ or `FromSqlInterpolated` / `FromSql` (parameterized). Never `FromSqlRaw` with concatenated input.
- **Secrets:** User Secrets in development; environment variables / Key Vault in production — never in `appsettings.json`.
- **Transport:** HTTPS redirection + HSTS in production.
- **Audit:** `dotnet list package --vulnerable --include-transitive`.

## Performance & SEO
- Response compression and static file caching; output caching where safe.
- Tag helpers for meta/canonical; sitemap endpoint.

## .gitignore additions
```
bin/
obj/
out/
*.user
.vs/
```

## CI notes
.NET setup automatic (uses `global.json`, or the current LTS SDK).

## Hosting & previews
Azure App Service (deployment slots = staging), containers, IIS, Linux VPS.

## Reviewer checks
- [ ] Build passes with warnings as errors; no new nullable warnings
- [ ] No `Html.Raw` / `MarkupString` on user data; no `FromSqlRaw` with input
- [ ] Antiforgery on every changed form/POST
- [ ] EF migration included for model changes
- [ ] No vulnerable packages
