# Website Agent Template

A reusable Claude Code setup for building custom-code websites for any brand. Six agents plan, design, build and review each site; you approve by merging pull requests.

> **Using this template:** click **Use this template → Create a new repository** and choose **Private** for client projects — each site holds the client's business details, goals and unreleased work. **Don't fork:** a fork of a public repo stays public.

- **Agent rules:** `AGENTS.md` (Claude Code reads it automatically)
- **Agents:** `.claude/agents/` — planner, ux-designer, architect, coder, reviewer, builder
- **Brand & goals (per site):** `docs/project-context.md` — blank in the template, filled by the intake interview
- **Intake questions:** `docs/intake-questions.md`
- **Quality bar:** `docs/review-standards.md`
- **Decisions:** `docs/decisions.md`
- **Feature history:** `work/`

---

## One-time: set up the template

1. Create a GitHub repo named `website-agent-template` (public or private) (empty — no README).
2. In this folder:
   ```bash
   git init -b main
   git add .
   git commit -m "chore: website agent template"
   git remote add origin https://github.com/wayancc/website-agent-template.git
   git push -u origin main
   ```
3. On GitHub → **Settings → General → tick "Template repository"**.
4. Use Claude Code 2.1.277 or newer (`claude --version`) so it reads `AGENTS.md`.

Don't build sites inside the template repo itself — it stays blank.

---

## Every new website

1. On GitHub, open `website-agent-template` → **Use this template → Create a new repository** — e.g. `wyn-site`, `brandx-site`. Keep it private.
2. Clone it:
   ```bash
   git clone https://github.com/wayancc/<brand>-site.git
   cd <brand>-site
   ```
3. On the new repo → Settings → Branches → add a rule for `main`: require a pull request and require the **CI** check to pass.
4. Open Claude Code in the folder and say:
   > Start a new project.
5. Answer the intake questions (3 short rounds). Share links to an old site, Instagram or a brand guide and the agents will propose answers for you to confirm.
6. Confirm the summary. The agents then run Foundation: plan → (you approve) → design + stack → (you approve) → build → review → PR for you to merge.

---

## Day to day

- **New page or big change:** "Plan the <page> page" → full build workflow.
- **Small change (after launch — set `mode: maintain` in `AGENTS.md`):** "Builder: change the hero headline to …".
- **You approve by merging PRs.** Nothing reaches `main` without you.

## Improving the template

Improve agents, rules or checks **in the template repo**, so every future site gets them. To bring an improvement into an existing site, copy the changed files across (or cherry-pick the commit). Never put brand-specific content in the template — that goes in each site's `docs/project-context.md`.

## License

MIT — see `LICENSE`. Free to use, copy and adapt, including for client work.
