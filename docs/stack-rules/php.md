# PHP Rule Pack

Covers: plain PHP (with Composer), Laravel, Symfony, Slim. For WordPress use `wordpress.md`.

## Recommended defaults
- **Most dynamic sites** (forms, admin, database, auth) → Laravel.
- **Very small site on shared hosting** → plain PHP + Composer + a small router, front controller in `public/`.
- **Team already on Symfony** → Symfony.
- Front-end assets: Vite (Laravel default) — then also apply the build/lint parts of `javascript.md`.

## scripts/check.sh
```bash
install() { composer install --no-interaction --prefer-dist; if [ -f package.json ]; then npm ci; fi; }
lint()    { vendor/bin/pint --test; }                  # or: vendor/bin/php-cs-fixer fix --dry-run --diff · vendor/bin/phpcs
types()   { vendor/bin/phpstan analyse --no-progress; } # Laravel: Larastan · or Psalm
test_()   { vendor/bin/pest; }                         # or: vendor/bin/phpunit · php artisan test
build()   { composer validate --strict; if [ -f package.json ]; then npm run build; fi; }
```
Laravel production optimizations (`php artisan config:cache route:cache view:cache`) run at deploy, not in `check.sh`.

## Version file
`.php-version` (CI reads it) and `"require": { "php": "^8.x" }` in `composer.json`.

## Project structure & web root
- **Only `public/` is the web root** (`public/index.php` front controller). `.env`, `vendor/`, app code, storage and config stay outside it.
- Shared hosting that forces `public_html/`: point the domain's document root to `public/`, or deploy so `public_html/` contains only the contents of `public/`. Never expose the project root.

## Coding rules
- `declare(strict_types=1);` in plain PHP files; typed properties, parameters and returns.
- PER Coding Style / PSR-12; PSR-4 autoloading via Composer.
- No business logic in templates (Blade / Twig / plain PHP views).
- Configuration from environment (`.env` + `.env.example`), never hard-coded.

## Security
- **Database:** PDO prepared statements with bound parameters, or Eloquent / Doctrine query builder. Never concatenate input into SQL (`"... WHERE id = $id"`).
- **Output:** Blade `{{ }}`, Twig autoescape, or `htmlspecialchars($v, ENT_QUOTES, 'UTF-8')` in plain PHP. `{!! !!}` / `|raw` only for trusted HTML.
- **CSRF:** token on every POST form (`@csrf`, Symfony forms, or own session token).
- **Input:** validate server-side (Laravel validation, Symfony Validator).
- **Passwords:** `password_hash()` / `password_verify()` (or framework auth).
- **Sessions:** cookies `Secure`, `HttpOnly`, `SameSite=Lax` or stricter; regenerate ID on login.
- **Uploads:** validate type and size, random filenames, store outside the web root.
- **Production:** `display_errors=Off`, `APP_DEBUG=false`.
- **Audit:** `composer audit`.

## Performance & SEO
- OPcache enabled in production; Laravel config/route/view caching at deploy.
- Hashed asset filenames (Vite); HTTP caching headers for static files.
- Avoid N+1 queries (eager loading).

## .gitignore additions
```
vendor/
.phpunit.result.cache
.phpunit.cache/
public/build/
public/hot
storage/*.key
```
(Laravel ships its own `.gitignore` files in `storage/` and `bootstrap/cache/` — keep them.)

## CI notes
PHP setup is automatic (`shivammathur/setup-php`, reads `.php-version`). Add extensions if needed (`extensions: mbstring, intl, pdo_sqlite`). Add a MySQL/Postgres service if tests need a real database.

## Hosting & previews
Laravel Cloud / Forge / Ploi, VPS, containers, or shared hosting (cPanel). Shared hosting rarely supports per-branch previews → use a staging subdomain. Deploy via CI (SSH/rsync/SFTP) or host git deploy — **never edit files directly on the server.**

## Reviewer checks
- [ ] No SQL built by string concatenation or interpolation with input
- [ ] No unescaped output of user data (`{!! !!}`, `|raw`, missing `htmlspecialchars`)
- [ ] CSRF token on every changed POST form
- [ ] Debug off and errors hidden in production config
- [ ] Migrations included for schema changes
- [ ] `composer audit`: no unresolved high/critical
