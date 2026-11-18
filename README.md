# Website Agent Template

A reusable Claude Code setup for building custom-code websites for any brand, in almost any language. Six agents plan, design, build and review each site; you approve by merging pull requests.

> **Using this template:** click **Use this template → Create a new repository** and choose **Private** for client projects — each site holds the client's business details, goals and unreleased work. **Don't fork:** a fork of a public repo stays public.

- **Agent rules:** `AGENTS.md` (Claude Code reads it automatically)
- **Agents:** `.claude/agents/` — planner, ux-designer, architect, coder, reviewer, builder
- **Brand & goals (per site):** `docs/project-context.md` — blank in the template, filled by the intake interview
- **Intake questions:** `docs/intake-questions.md`
- **Stack (per site):** `docs/stack.md` + `scripts/check.sh` — filled by the architect
- **Language rule packs:** `docs/stack-rules/`
- **Quality bar:** `docs/review-standards.md`
- **Decisions:** `docs/decisions.md`
- **Feature history:** `work/`

---

## Supported stacks

The architect recommends a stack (or uses the one you require) and applies the matching rule pack:

| Family | Examples |
|---|---|
| Static | Plain HTML/CSS/JS, Eleventy, Hugo, Jekyll, Zola |
| JavaScript / TypeScript | Astro, Next.js, Nuxt, SvelteKit, React Router, Vite, Express/Hono |
| PHP | Plain PHP, Laravel, Symfony |
| WordPress | Custom block/classic themes, child themes, custom plugins |
| Python | Django, Wagtail, Flask, FastAPI |
| Ruby | Rails, Sinatra |
| Go | net/http, Chi, Echo, Gin, templ |
| JVM | Spring Boot (Java/Kotlin), Quarkus, Ktor |
| .NET | ASP.NET Core, Razor Pages, Blazor |
| Rust | Axum, Actix, Leptos |

Anything else: the architect writes a new rule pack from `docs/stack-rules/_template.md` for you to approve. Every stack runs the same checks through `bash scripts/check.sh`, locally and in CI.

---

## Requirements

- Claude Code 2.1.277 or newer (`claude --version`) so it reads `AGENTS.md`
- A GitHub account
- The runtime for your chosen stack (Node, PHP, Python…) — the architect tells you what to install
- Windows: use Git Bash or WSL to run `scripts/check.sh`

---

## Every new website

1. On GitHub, open `website-agent-template` → **Use this template → Create a new repository** — e.g. `acme-site`. Keep it private.
2. Clone it:
   ```bash
   git clone https://github.com/<your-account>/<brand>-site.git
   cd <brand>-site
   ```
3. On the new repo → Settings → Branches → add a rule for `main`: require a pull request and require the **CI** check to pass. (Private repos need GitHub Pro or Team for this; on the Free plan, skip it — agents are still blocked from pushing to `main`.)
4. Open Claude Code in the folder and say:
   > Start a new project.
5. Answer the intake questions (3 short rounds). Share links to an old site, Instagram or a brand guide and the agents will propose answers for you to confirm.
6. Confirm the summary. The agents then run Foundation: plan → (you approve) → design + stack → (you approve) → build → review → PR for you to merge.

---

## Day to day

- **New page or big change:** "Plan the <page> page" → full build workflow.
- **Small change (after launch — set `mode: maintain` in `AGENTS.md`):** "Builder: change the hero headline to …".
- **You approve by merging PRs.** Nothing reaches `main` without you.

## Reusing it for many sites

If you build sites often, make your own copy as a template: **Use this template** → create the repo → **Settings → General → tick "Template repository"**. Improve agents, rules and checks there, so every future site gets them. Keep brand-specific content out of it — that belongs in each site's `docs/project-context.md`.

## License

MIT — see `LICENSE`. Free to use, copy and adapt, including for client work.
