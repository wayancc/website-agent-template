# Review Standards

The reviewer applies these checks, the custom-code checks in `.claude/agents/reviewer.md`, and the Reviewer checks in the stack's rule pack (`docs/stack-rules/`).

## Severity

| Level | Meaning | Effect |
|---|---|---|
| Blocker | Broken function, failed acceptance criterion, security/privacy risk, broken on mobile, accessibility failure that blocks use | Must fix. Cannot approve. |
| Major | Clear quality problem: off-brand, slow, poor UX, missing SEO basics | Fix before go-live unless the user accepts it |
| Minor | Polish, naming, small inconsistency | Note it; fix if cheap |

**Approve only with zero blockers.** List majors so the user can decide.

## Evidence rule

Every "pass" needs evidence: command output, a screenshot, a URL checked, or a file and line reference. "Looks fine" is not evidence.

---

## Checklist A — every change

- [ ] Each acceptance criterion: pass / fail with evidence
- [ ] Nothing else broke on the changed page(s)
- [ ] Mobile (375px) and desktop (1440px) checked visually
- [ ] No console errors
- [ ] Copy matches the tone of voice in `docs/project-context.md`; no typos
- [ ] Links in the changed area work
- [ ] CI is green on the PR (`bash scripts/check.sh all`)
- [ ] Previewed the way `docs/stack.md` defines (per-branch preview, staging, or local + screenshots)

## Checklist B — standard and larger changes

### Responsive
- [ ] 375px, 768px, 1024px, 1440px — no horizontal scroll, no overlap, tap targets ≥ 44px

### Accessibility (WCAG 2.2 AA)
- [ ] Text contrast ≥ 4.5:1 (≥ 3:1 for large text)
- [ ] Meaningful images have alt text; decorative images have empty alt
- [ ] Full keyboard navigation with a visible focus state
- [ ] One H1 per page; headings in order
- [ ] Form fields have labels; errors are announced and explained

### SEO
- [ ] Unique title (≤ 60 chars) and meta description (≤ 155 chars)
- [ ] Clean, descriptive URL; any changed URL has a redirect
- [ ] Structured data where relevant (Organization, Breadcrumb, FAQ, LocalBusiness)
- [ ] Open Graph image and title for sharing
- [ ] Page is indexable unless intentionally not; included in the sitemap

### Performance (mobile, Lighthouse or PageSpeed)
- [ ] LCP < 2.5s, CLS < 0.1, INP < 200ms
- [ ] Images sized responsively, modern format, lazy-loaded below the fold
- [ ] No non-essential render-blocking scripts

### Function
- [ ] Forms submit and land in the right place
- [ ] Analytics and pixels still fire on key events
- [ ] 404 page works
- [ ] Tested in Chrome and Safari (incl. iOS Safari)

### Security / privacy
- [ ] No secrets or API keys in front-end code or the repo
- [ ] Server-side input validated; output escaped; database queries parameterized
- [ ] CSRF protection on every server-handled form
- [ ] Only the public web root is reachable; config, `.env` and dependencies are not
- [ ] Dependency audit (the stack's audit tool) shows no unresolved high/critical issues
- [ ] Third-party scripts are necessary and from trusted sources
- [ ] Cookie/consent behavior matches what the user requires

---

## Review output format (`work/<slug>/5-review.md`)

```markdown
# Review — <feature>
Role: reviewer | Date: YYYY-MM-DD
Round: 1 | 2
Verdict: APPROVED | REJECTED | ESCALATE TO USER

## Acceptance criteria
| AC | Result | Evidence |
|---|---|---|

## Issues
| # | Severity | Where | Problem | Route to |
|---|---|---|---|---|

## Checks run
<commands and their output, screenshots taken>

## Notes for the user
<majors they need to decide on, anything out of scope>
```
