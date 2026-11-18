# Static Sites Rule Pack

Covers: plain HTML/CSS/JS (no build), and static site generators — Eleventy (JS), Hugo (Go binary), Jekyll (Ruby), Zola (Rust binary). For Astro, use `javascript.md`.

## Recommended defaults
- **1–5 pages, no CMS, rarely changes** → plain HTML/CSS with a small `package.json` for tooling only.
- **More pages, blog, shared layouts** → Eleventy (JS teams) or Hugo (fastest builds, single binary).
- Jekyll only if the user already uses it or GitHub Pages' built-in Jekyll is a requirement.
- Content editors who aren't developers → consider a git-based CMS (Decap, TinaCMS, CloudCannon) — record in `docs/stack.md`.

## scripts/check.sh

Plain HTML (tooling via npm):
```bash
install() { npm ci; }
lint()    { npx html-validate "public/**/*.html" && npx stylelint "public/**/*.css" && npx prettier --check public; }
types()   { skip types "plain JS, no TypeScript"; }
test_()   { npx playwright test; }        # smoke: every page loads, nav works, forms submit
build()   { skip build "no build step — files are served as-is"; }
```

Eleventy:
```bash
install() { npm ci; }
lint()    { npx prettier --check . && npx html-validate "_site/**/*.html"; }   # run after build in CI, or build first
types()   { skip types "no TypeScript"; }
test_()   { npx playwright test; }
build()   { npx @11ty/eleventy; }
```

Hugo:
```bash
install() { :; }                                   # Hugo is a single binary — install via CI step
lint()    { hugo --gc --printPathWarnings --panicOnWarning --renderToMemory; }
types()   { skip types "templates checked by Hugo at build"; }
test_()   { skip test "covered by build + link check"; }   # add Playwright if forms/JS exist
build()   { hugo --gc --minify; }
```

Jekyll: `install() { bundle install; }`, `build() { bundle exec jekyll build; }`.

**Link check** (recommended for every static site): run lychee on the built output in CI (`lycheeverse/lychee-action`).

## Version file
`.nvmrc` (Eleventy / tooling), `.ruby-version` (Jekyll). Hugo/Zola: pin the version in the CI setup step (e.g. `peaceiris/actions-hugo`) and in `docs/stack.md`.

## Project structure & web root
- Plain: serve from `public/` — **never the repo root**, which would publish `docs/` (client details), `work/` and `AGENTS.md`.
- Eleventy / Jekyll read the repo root by default: exclude `docs/`, `work/`, `.claude/`, `AGENTS.md` (`.eleventyignore`; Jekyll `exclude:` in `_config.yml`), and add them to `.prettierignore`.
- Eleventy → `_site/`, Hugo → `public/`, Jekyll → `_site/`, Zola → `public/` (build output, not committed).

## Coding rules
- Semantic HTML, one H1 per page, shared header/footer via SSG layouts/partials (plain HTML: keep them identical across pages).
- CSS custom properties for design tokens; no frameworks unless the architect approves.
- Minimal JS, loaded with `defer` or `type="module"`.

## Security
- Everything shipped is public — no API keys or secrets in JS or HTML.
- Forms go to a form service (host forms, Formspree, own endpoint) with spam protection (honeypot, Turnstile/reCAPTCHA).
- Third-party scripts only when necessary; set security headers (CSP, X-Content-Type-Options) via host config (`_headers`, `netlify.toml`, etc.).

## Performance & SEO
- Optimize images at build (Eleventy Image, Hugo image processing) or pre-optimize; width/height on every `<img>`.
- Generate `sitemap.xml`, `robots.txt`, canonical URLs, Open Graph tags from layouts.

## .gitignore additions
```
_site/
public/            # Hugo/Zola output only — NOT for plain sites served from public/
resources/_gen/
.hugo_build.lock
.jekyll-cache/
```

## CI notes
Node is set up automatically when `package.json` exists. Hugo/Zola/Jekyll need a setup step added under "Architect: add stack-specific steps" in `ci.yml`.

## Hosting & previews
Netlify, Cloudflare Pages, Vercel: free per-branch/PR previews. GitHub Pages: no PR previews → review locally + screenshots, or use a staging branch.

## Reviewer checks
- [ ] HTML valid (html-validate or W3C) on changed pages
- [ ] No broken internal or external links (lychee)
- [ ] Every page has unique title, meta description, OG tags, canonical
- [ ] 404 page exists and is served by the host
- [ ] Form submissions arrive and spam protection works
