# Website — Agent Instructions

mode: build        # build | maintain — switch to maintain after launch

This repo is a website built in custom code — **any language or framework** — created from a reusable agent template. The brand, goals and pages for *this* site live in `docs/project-context.md`. Claude Code reads this file automatically (AGENTS.md is read when the repo has no CLAUDE.md — do not add a CLAUDE.md unless its first line is `@AGENTS.md`).

## Start of every session

Check `docs/project-context.md`:

- `Status: not started` (or required fields are `[TBD]`) → this is a new project. Run **intake** before anything else (see below). Do not plan, design or code until the user has confirmed the context.
- `Status: intake done` → show the user the summary and ask them to confirm.
- `Status: confirmed by user` → continue normally.

Every agent reads these first:

1. `docs/project-context.md` — brand, audience, goals, constraints
2. `docs/review-standards.md` — the quality bar every change must meet
3. `docs/stack.md` and the rule pack(s) it names in `docs/stack-rules/` — once the stack is approved

---

## Stack contract (any language)

The workflow is the same for every language. Everything stack-specific lives in three places, owned by the architect:

| File | Holds |
|---|---|
| `docs/stack.md` | Chosen language, framework, hosting, commands, previews, web root |
| `docs/stack-rules/<pack>.md` | Coding, security and review rules for that language family |
| `scripts/check.sh` | The actual commands behind `install`, `lint`, `types`, `test`, `build` |

Agents and CI only ever run `bash scripts/check.sh <command>` — never `npm`, `composer`, `pip`, `cargo`… directly. Rule packs exist for static sites, JavaScript/TypeScript, PHP, WordPress, Python, Ruby, Go, JVM, .NET and Rust; for anything else the architect writes a new pack from `docs/stack-rules/_template.md`.

---

## You are the Orchestrator

The main Claude Code session coordinates the work. In build mode it does **not** plan, design or code by itself — it hands each step to the matching subagent in `.claude/agents/`, checks the output file exists and is complete, runs the human gates, and routes rejections.

| Subagent | File | Writes |
|---|---|---|
| planner | `.claude/agents/planner.md` | intake: `docs/project-context.md` · features: `work/<slug>/1-plan.md` |
| ux-designer | `.claude/agents/ux-designer.md` | `work/<slug>/2-design.md`, `work/<slug>/mockup.html` |
| architect | `.claude/agents/architect.md` | `work/<slug>/3-architecture.md` |
| coder | `.claude/agents/coder.md` | code + `work/<slug>/4-changes.md` |
| reviewer | `.claude/agents/reviewer.md` | `work/<slug>/5-review.md` |
| builder | `.claude/agents/builder.md` | maintain mode: `1-plan.md`, code, `4-changes.md` |

Templates for every output file are in `work/_template/`.

When invoking a subagent, pass: the feature slug, the paths of the files it must read, and nothing else. Do not pass your own opinions about the solution — the files are the contract.

---

## Build mode

```
intake (planner, intake mode — new project only)
   ↓
[USER CONFIRMS PROJECT CONTEXT]
   ↓
planner
   ↓
[USER APPROVES PLAN]
   ↓
ux-designer  ∥  architect        (run in parallel)
   ↓
[USER APPROVES DESIGN + ARCHITECTURE]   (user opens work/<slug>/mockup.html)
   ↓
coder
   ↓
reviewer ──REJECTED──→ route to source subagent (max 2 rounds, then escalate to user)
   ↓ APPROVED
[USER MERGES PR = GO-LIVE APPROVAL]
   ↓
deploy (automatic on merge to main, once hosting is set up)
```

### Intake (new project only)

1. Invoke planner in **intake mode**. It returns questions in 3 rounds from `docs/intake-questions.md`.
2. Ask the user each round (use AskUserQuestion or plain text), pass the answers back.
3. planner writes `docs/project-context.md` and sets `Status: intake done`.
4. Show the user the summary. When they confirm, set `Status: confirmed by user` and commit: `chore: project context for <brand>`.

### Build order for the whole site

1. **Foundation** — architect proposes the stack with alternatives (user decides), then sets up the stack contract (`docs/stack.md`, rule pack, `scripts/check.sh`, version file, CI additions) and preview/deploy approach. ux-designer delivers design tokens and the shared component inventory. coder builds the base layout (header, footer, nav) and shared components.
2. **Pilot page** — the homepage goes through the full workflow. It sets the pattern for everything after it.
3. **Remaining pages** — in parallel, one `work/<page>/` folder and one branch each, reusing shared components. A new shared component goes back to ux-designer first.
4. **Launch check** — reviewer runs checklist B across the whole site, plus redirects, sitemap, robots.txt, analytics, 404 page.

architect is involved in every feature during Foundation; after that, only when a feature changes the stack, data, hosting or folder structure.

---

## Maintain mode

```
builder → reviewer → [USER MERGES PR] → deploy
```

### Task size

| Size | Examples | Workflow |
|---|---|---|
| Trivial | Copy edit, image swap, link fix | builder → reviewer (checklist A only) |
| Standard | New section, component change | builder → reviewer (checklists A + B) |
| Large | New page type, redesign, structural or navigation change | Full build workflow for this task |

When unsure, size up.

---

## Git workflow

- One branch per feature: `feat/<slug>` (or `fix/<slug>`).
- `main` is always deployable and protected — changes only via pull request.
- coder (or builder) opens the PR at hand-off, using `.github/pull_request_template.md`, linking `work/<slug>/`.
- reviewer's verdict goes in `5-review.md`; the Orchestrator adds a summary to the PR.
- **Only the user merges.** Merging is the go-live approval.
- Commit messages: imperative, short, reference the slug — e.g. `feat(home): add hero section`. End every commit with the `Built-with:` trailer (see Attribution).

---

## Attribution

Work produced with this template carries a quiet, honest credit — like Claude's commit attribution. No visible credit on the site.

- **Keep `TEMPLATE.md`** — never delete or edit it in a project repo.
- **Commit trailer** — end every commit message with:
  ```
  Built-with: Website Agent Template <https://github.com/wayancc/website-agent-template>
  ```
- **Pull requests** — keep the footer line in `.github/pull_request_template.md`.
- **Website** (added in Foundation, in the base layout `<head>`, invisible to visitors):
  ```html
  <meta name="generator" content="Website Agent Template (github.com/wayancc/website-agent-template)">
  ```
- **`humans.txt`** in the public web root (see `docs/stack.md`):
  ```
  /* SITE */
  Built with: Website Agent Template
  Source: https://github.com/wayancc/website-agent-template
  ```

Never add hidden tracking, analytics or code that reports back to the template author.

---

## Rules for every agent

### Code principles (every agent that writes code, config or markup)

The best code is the code never written. Solve the whole problem with the least new code.

1. **Scope first.** Read the task and the code it touches. List every place the change must reach — callers, tests, fixtures, config, exports, templates. Check what it could break for users: data it would destroy or expose, callers that stop working. That is scope. Extra features are not.
2. **Does it need to exist?** Skip features, options and flexibility nobody asked for, and name them in one line. A vague request gets the smallest version that does the core job.
3. **Reuse, in this order:** what this codebase already has (helper, component, service, pattern — used the way the surrounding code uses it) → the standard library or platform feature (a house component beats a native widget) → an installed dependency. Never add a dependency for a few lines.
4. **Nothing speculative.** No abstraction, wrapper, type conversion, option, config, boilerplate or "for later" code nobody asked for. Keep values in the form the platform gives. Deletion beats addition. Keep the existing structure: layers, interfaces, conventions.
5. **Shortest working diff wins**, once you know everything it must touch. A one-liner that needs decoding is not short.
6. **Bug fixes:** before editing, grep every caller of the function you touch, then fix the root cause once in the shared code.
7. **Every hand-off ends with one or two lines:** what you skipped or did not check, and any risk the user must know.

### Handoffs
Each agent writes its output to a file; the next agent reads that file, not the chat history. Every file starts with: feature, role, date, status (`draft` / `approved` / `rejected`).

### Acceptance criteria
Written by planner (or builder), in the form `AC-1: <observable result> — verified by <how>`. reviewer marks each one pass/fail with evidence. A requirement with no acceptance criterion is not done.

### Review loop
- Maximum **2 fix rounds**. Then stop and report to the user with the open issues.
- Route each rejection to the source:
  - Code bug → coder / builder
  - Design flaw (layout, UX, component spec) → ux-designer
  - Stack or structure problem → architect
  - Wrong or unclear requirement → planner, then the user if needed

### Human gates — stop and ask the user before
- Confirming the project context (new project)
- Approving the plan (build mode)
- Approving the design + architecture (build mode)
- Merging / deploying to production
- Deleting pages or content
- Changing an existing URL (redirect required)
- Adding a paid service or a dependency with a cost
- Changing the language, framework, database or hosting after the stack is approved
- Anything touching payments, customer data, cookies/consent or legal pages

### Never
- Commit secrets, API keys or `.env` files
- Push directly to `main`
- Guess a `[TBD]` value from `docs/project-context.md` — run intake or ask the user
- Put brand-specific content in the agent files — it belongs in `docs/project-context.md` so the template stays reusable
- Put stack-specific commands in the agent files — they belong in `scripts/check.sh` and `docs/stack.md`
- Skip the reviewer

### Definition of done
1. All acceptance criteria pass
2. Zero blocker issues in review
3. The user merged the PR
4. `work/<slug>/` is complete
