# Python Rule Pack

Covers: Django, Wagtail (Django CMS), Flask, FastAPI (with Jinja templates or a JS front end).

## Recommended defaults
- **Content site with admin, auth, database** → Django.
- **Client edits pages and content** → Wagtail.
- **API / back end for a JS front end** → FastAPI.
- **Small app** → Flask.
- Package manager: uv (fast, lockfile) — or pip + `requirements*.txt` if the host requires it.

## scripts/check.sh
```bash
install() { python -m pip install --upgrade uv && uv sync --frozen; }
          # pip alternative: pip install -r requirements.txt -r requirements-dev.txt
lint()    { uv run ruff check . && uv run ruff format --check .; }
types()   { uv run mypy .; }                 # or: uv run pyright · Django: add django-stubs
test_()   { uv run pytest; }                 # Django: pytest-django · e2e: pytest-playwright
build()   { uv run python manage.py makemigrations --check --dry-run \
            && DJANGO_DEBUG=0 uv run python manage.py check --deploy \
            && uv run python manage.py collectstatic --noinput; }
          # Flask/FastAPI: skip build "no build step" (or build front-end assets)
```
(The `DJANGO_DEBUG` variable name is whatever the settings file reads — match it.)

## Version file
`.python-version` (CI reads it); `requires-python` in `pyproject.toml`.

## Project structure & web root
- Django: settings driven by environment variables; static files via `collectstatic` + WhiteNoise or a CDN; user uploads (`MEDIA_ROOT`) never inside the code folder.
- Never serve with `runserver` / `flask run` in production — use gunicorn / uvicorn behind the host's proxy.

## Coding rules
- Type hints on all functions; Ruff formatting.
- Business logic out of views/templates (services/models).
- Database changes only via migrations (Django) or Alembic (Flask/FastAPI with SQLAlchemy).

## Security
- **Production settings:** `DEBUG=False`, `SECRET_KEY` from env, `ALLOWED_HOSTS` set, `SECURE_SSL_REDIRECT`, `SESSION_COOKIE_SECURE`, `CSRF_COOKIE_SECURE`, HSTS.
- **CSRF:** Django middleware on, `{% csrf_token %}` in every POST form; Flask: Flask-WTF.
- **Database:** ORM or parameterized queries. Never f-strings/`%` into SQL; no `.raw()` / `.extra()` with input.
- **Templates:** autoescape on; no `|safe` / `mark_safe` / `Markup` on user input.
- **Input:** Django forms / DRF serializers / Pydantic models.
- **CORS** (APIs): restrict origins.
- **Audit:** `uvx pip-audit` (or `pip-audit`).

## Performance & SEO
- Avoid N+1: `select_related` / `prefetch_related`; check query counts on changed pages.
- Cache expensive views/fragments; compressed, hashed static files.
- Django sitemap framework; per-page meta in templates.

## .gitignore additions
```
__pycache__/
*.pyc
.venv/
staticfiles/
media/
.pytest_cache/
.mypy_cache/
.ruff_cache/
```

## CI notes
Python setup automatic (reads `.python-version`). Add a Postgres service if tests need it, and set `DATABASE_URL` for the job.

## Hosting & previews
Render, Railway, Fly.io (some offer preview environments), PythonAnywhere, VPS (gunicorn + nginx). Otherwise a shared staging environment.

## Reviewer checks
- [ ] `manage.py check --deploy` clean (Django)
- [ ] Migrations included and `makemigrations --check` passes
- [ ] No raw SQL with input; no `|safe` on user data
- [ ] CSRF token in every changed POST form
- [ ] `pip-audit`: no unresolved high/critical
