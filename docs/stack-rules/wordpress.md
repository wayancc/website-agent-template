# WordPress Rule Pack

Covers: custom WordPress themes (block themes with `theme.json`, or classic themes), child themes, and custom plugins. **Not** WordPress core or third-party plugins — those are never edited.

> WordPress content (pages, posts, menus, settings) lives in the **database**, not in git. This repo holds only custom code. Content changes are a checklist for the user or done in wp-admin with approval.

## Recommended defaults
- **New site, client edits content** → custom block theme (`theme.json`, block patterns, template parts) so the editor matches the design.
- **Existing site on a commercial theme** → child theme for changes; never edit the parent.
- **Features (custom post types, integrations)** → a small custom plugin, not `functions.php`, so they survive a theme change.
- Local dev: `@wordpress/env` (wp-env, needs Docker), DDEV, or Local.

## Repo layout (architect decides and records in `docs/stack.md`)
```
wp-content/themes/<theme-slug>/
wp-content/plugins/<plugin-slug>/   (if any)
```
or repo root = the theme folder (simplest when there's only a theme).

## scripts/check.sh
```bash
install() { composer install --no-interaction; if [ -f package.json ]; then npm ci; fi; }
lint()    { vendor/bin/phpcs; }                      # phpcs.xml.dist with WordPress-Coding-Standards (wpcs)
types()   { vendor/bin/phpstan analyse --no-progress; }  # with szepeviktor/phpstan-wordpress
test_()   { if [ -f package.json ]; then npx playwright test; else skip test "no e2e configured"; fi; }
          # PHPUnit with the WP test suite for plugins with logic
build()   { if [ -f package.json ]; then npm run build; else skip build "no assets to compile"; fi; }  # @wordpress/scripts for blocks
```

## Version file
`.php-version` (match the host's PHP), `.nvmrc` if using `@wordpress/scripts`.

## Coding rules
- Prefix every function, class, hook, option and handle with the theme/plugin slug.
- Enqueue assets with `wp_enqueue_script()` / `wp_enqueue_style()` — no hard-coded `<script>` or `<link>` in templates.
- All user-facing strings translatable: `__()`, `esc_html__()`, with the text domain.
- Use hooks and filters; never modify core or third-party plugin files.
- Block themes: design tokens in `theme.json`; patterns for reusable layouts.

## Security
- **Escape late:** `esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()` on every output.
- **Sanitize early:** `sanitize_text_field()`, `sanitize_email()`, `absint()` etc. on every input.
- **Nonces** on every form and AJAX request: `wp_nonce_field()` + `check_admin_referer()` / `wp_verify_nonce()` / `check_ajax_referer()`.
- **Capabilities:** `current_user_can()` before any privileged action.
- **Database:** `$wpdb->prepare()` for every query with variables; prefer WP APIs (`WP_Query`, `get_posts`).
- Never commit `wp-config.php`, salts or database credentials.

## Performance & SEO
- Register image sizes; use `wp_get_attachment_image()` (responsive `srcset`).
- Minimal plugins; caching via host or a caching plugin (user decides).
- SEO plugin choice is a user decision; the theme outputs clean headings and supports it.

## .gitignore additions
```
vendor/
node_modules/
wp-config.php
wp-content/uploads/
build/        # only if compiled assets are built at deploy, not committed
```

## Extra human gates
- Installing, updating or removing plugins
- Changing settings or content in wp-admin
- Any database change on staging or production

## CI notes
PHP setup automatic via `composer.json`; Node if `package.json`. For PHPUnit with the WP test suite, add a MySQL service.

## Hosting & previews
Managed WordPress hosts usually provide a staging site → preview there. Deploy the theme/plugin via host git integration or CI (rsync/SFTP). Never edit theme files in wp-admin's file editor (disable it with `DISALLOW_FILE_EDIT`).

## Reviewer checks
- [ ] PHPCS (WordPress standard) clean on changed files
- [ ] Every output escaped, every input sanitized
- [ ] Nonce + capability check on every form, AJAX and admin action
- [ ] No PHP notices/warnings with `WP_DEBUG` on
- [ ] Works with the site's active plugins (staging)
- [ ] Content steps the user must do in wp-admin listed in `4-changes.md`
