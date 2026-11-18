# JavaScript / TypeScript Rule Pack

Covers: Astro, Next.js, Nuxt, SvelteKit, React Router (framework mode, formerly Remix), Vite single-page apps (React/Vue/Svelte), Express / Fastify / Hono back ends. TypeScript by default.

## Recommended defaults
- **Marketing / content site** → Astro (static by default, ships little JS, islands for interactivity).
- **App-like site, logged-in areas, heavy interactivity** → Next.js (React), Nuxt (Vue) or SvelteKit — pick by team familiarity.
- **API only** → Hono or Fastify.
- Package manager: npm unless the user prefers pnpm/bun. One lockfile only.
- Content editing by non-developers → headless CMS (Sanity, Storyblok, Contentful, Payload, Strapi) or git-based CMS; record in `docs/stack.md`.

## scripts/check.sh
```bash
install() { npm ci; }
lint()    { npx eslint . && npx prettier --check .; }   # or: npx biome check .
types()   { npx tsc --noEmit; }
          # Astro: npx astro check · Svelte: npx svelte-check · Nuxt: npx nuxi typecheck
test_()   { npx vitest run && npx playwright test; }    # e2e for forms and navigation
build()   { npm run build; }
```
Playwright in CI needs browsers: add `npx playwright install --with-deps` to `install()` or a CI step.

## Version file
`.nvmrc` (CI reads it). Set `"engines"` in `package.json` to match.

## Project structure & web root
Follow the framework's conventions. Static assets in the framework's public folder (`public/` or `static/`). Build output is never committed.

Environment variables: only prefixed vars reach the browser (`PUBLIC_`, `NEXT_PUBLIC_`, `VITE_`, `NUXT_PUBLIC_`). **Never put secrets in prefixed vars.**

## Coding rules
- Server-render or pre-render by default; client components / islands only where interaction needs it.
- Use the framework's image component and metadata API.
- ES modules; no unused dependencies; prefer platform APIs over libraries.
- Strict TypeScript (`"strict": true`); no `any` without a comment explaining why.

## Security
- Secrets only in server code (API routes, server actions, server load functions).
- Validate all input on the server (e.g. Zod / Valibot schemas).
- Never render untrusted HTML (`dangerouslySetInnerHTML`, `v-html`, `{@html}`, `set:html`) without sanitizing (DOMPurify / sanitize-html).
- CSRF: use framework form actions (most check origin) or add tokens for custom POST endpoints.
- Security headers / CSP via framework middleware or host config.
- Audit: `npm audit --omit=dev` — high/critical must be resolved or justified.

## Performance & SEO
- Check client bundle size on changed pages; lazy-load heavy components.
- Sitemap and robots via framework integration; canonical URLs; structured data in layouts.
- Fonts self-hosted or with `font-display: swap`.

## .gitignore additions
Framework build folders are already in the base `.gitignore` (`.next/`, `.astro/`, `.nuxt/`, `.output/`, `.svelte-kit/`, `dist/`).

## CI notes
Node setup is automatic (reads `.nvmrc`). Cache via `actions/setup-node` `cache: npm` if wanted.

## Hosting & previews
Vercel, Netlify, Cloudflare Pages: automatic per-branch previews. Node server on VPS/containers (Fly.io, Render, Railway): shared staging environment.

## Reviewer checks
- [ ] No secrets in the client bundle (search the build output for keys/tokens)
- [ ] No hydration errors or warnings in the browser console
- [ ] Lockfile committed; only one package manager's lockfile present
- [ ] Server-side validation on every form/API input
- [ ] `npm audit --omit=dev`: no unresolved high/critical
