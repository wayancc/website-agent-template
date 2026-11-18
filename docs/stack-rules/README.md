# Stack Rule Packs

One pack per language family. The architect picks the pack that matches the approved stack and records it in `docs/stack.md`. The coder, builder and reviewer load that pack on every task.

Each pack gives: recommended defaults, how to fill `scripts/check.sh`, project structure and web root, coding and security rules, `.gitignore` additions, CI notes, hosting/preview options, and extra reviewer checks.

| Pack | Covers |
|---|---|
| `static.md` | Plain HTML/CSS/JS; static site generators: Eleventy, Hugo, Jekyll, Zola |
| `javascript.md` | TypeScript/JavaScript: Astro, Next.js, Nuxt, SvelteKit, React Router (Remix), Vite SPAs, Express/Fastify/Hono |
| `php.md` | Plain PHP, Laravel, Symfony, Slim |
| `wordpress.md` | Custom WordPress themes (block or classic), child themes, custom plugins |
| `python.md` | Django, Wagtail, Flask, FastAPI |
| `ruby.md` | Ruby on Rails, Sinatra |
| `go.md` | net/http, Chi, Echo, Gin, templ |
| `jvm.md` | Spring Boot (Java/Kotlin), Quarkus, Micronaut, Ktor |
| `dotnet.md` | ASP.NET Core: Razor Pages, MVC, Blazor, Minimal APIs |
| `rust.md` | Axum, Actix Web, Rocket, Leptos |

## A stack that isn't listed

(Elixir/Phoenix, Deno, Bun-only, Crystal, a headless-CMS combo…)

1. The architect copies `_template.md` to `docs/stack-rules/<name>.md`.
2. Fills every section, checking current tooling with a web search — not from memory.
3. The user approves the new pack together with the stack.
4. Add it to the table above.

## Mixed stacks

If the site uses two families (e.g. a Laravel back end with a Vite/TypeScript front end), list both packs in `docs/stack.md`. `scripts/check.sh` runs both sets of commands; agents apply both packs.

## Rules that apply to every stack

These come from `docs/review-standards.md` and the agent files, whatever the language:
- Only the public web root is reachable from the web; secrets live in environment variables, never in the repo.
- Validate input on the server; escape output; parameterize every database query; CSRF protection on server-handled forms.
- Lockfile committed; one package manager per ecosystem; dependencies audited with the ecosystem's audit tool.
- Accessibility, SEO, performance and responsive checks are the same for every stack.
