# Ruby Rule Pack

Covers: Ruby on Rails (Hotwire / Turbo / Stimulus), Sinatra. For Jekyll, use `static.md`.

## Recommended defaults
- **Most dynamic sites** → Rails with Hotwire (interactive pages without a separate JS app).
- **Tiny app or API** → Sinatra.
- Assets: Rails defaults (Propshaft + importmap) unless a JS build is needed.

## scripts/check.sh
```bash
install() { bundle install; }
lint()    { bundle exec rubocop && bundle exec brakeman --no-pager --quiet; }
types()   { skip types "Ruby is dynamically typed (add Sorbet/RBS only if the user wants it)"; }
test_()   { bin/rails test && bin/rails test:system; }   # or: bundle exec rspec
build()   { RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile; }
```
Record the `types` skip in `docs/stack.md`.

## Version file
`.ruby-version` (CI reads it).

## Project structure & web root
Rails conventions. `public/` is the web root. Secrets in Rails credentials (`bin/rails credentials:edit`) or env vars — `config/master.key` is never committed.

## Coding rules
- Follow Rails conventions; RuboCop config (Rails omakase or project config).
- Strong parameters in controllers; logic in models/service objects, not views.
- Schema changes only via migrations; keep `db/schema.rb` committed.

## Security
- **Database:** ActiveRecord with placeholders (`where("email = ?", email)` or hash conditions). Never interpolate input into SQL strings.
- **Output:** ERB escapes by default — no `raw` / `html_safe` on user input.
- **CSRF:** `protect_from_forgery` (default) stays on; `form_with` includes the token.
- **Production:** `config.force_ssl = true`; secrets from credentials/env.
- **Audit:** Brakeman (in lint) + `bundle exec bundler-audit check --update` or `bundle audit`.

## Performance & SEO
- Avoid N+1 (`includes`); consider the Bullet gem in development.
- Fragment / Russian-doll caching on heavy pages.
- Meta tags and sitemap (e.g. `sitemap_generator`).

## .gitignore additions
Rails' generated `.gitignore` covers it (`/log/*`, `/tmp/*`, `/storage/*`, `/config/master.key`, `/public/assets`). Keep it.

## CI notes
Ruby setup automatic (reads `.ruby-version`). System tests need Chrome (preinstalled on GitHub runners). Add Postgres/MySQL service if not using SQLite.

## Hosting & previews
Kamal to a VPS (Rails 8 default), Render, Heroku, Fly.io. Review apps/previews where the host supports them; otherwise staging.

## Reviewer checks
- [ ] Brakeman: zero new warnings (or justified)
- [ ] Migrations included, reversible; `schema.rb` updated
- [ ] No `raw` / `html_safe` on user data; no interpolated SQL
- [ ] No N+1 queries on changed pages
