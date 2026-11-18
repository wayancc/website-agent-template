# <Stack> Rule Pack

Covers: <languages / frameworks>
Status: draft | approved by user

## Recommended defaults
<when to pick which framework; package manager; why>

## scripts/check.sh
```bash
install() { ...; }
lint()    { ...; }   # formatter check + linter
types()   { ...; }   # type checker / static analysis / compiler — or: skip types "<reason>"
test_()   { ...; }   # unit + integration; e2e for forms and navigation
build()   { ...; }   # production build — or: skip build "<reason>"
```

## Version file
<file CI reads; add a setup step to ci.yml if the language isn't detected yet>

## Project structure & web root
<folders; which folder is public; where config and secrets live>

## Coding rules
-

## Security
- Input validation:
- Output escaping / templating:
- Database queries (parameterized):
- CSRF:
- Sessions / auth:
- Secrets:
- Dependency audit command:

## Performance & SEO
-

## .gitignore additions
```
```

## CI notes
<setup action, services, caches>

## Hosting & previews
<typical hosts; per-branch previews available or staging needed; deploy method>

## Reviewer checks (in addition to docs/review-standards.md)
- [ ]
