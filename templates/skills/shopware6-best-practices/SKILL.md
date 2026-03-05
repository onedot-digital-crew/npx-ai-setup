---
name: shopware6-best-practices
description: Shopware 6 development guidance for plugins and shop repos (DAL, services, migrations, subscribers, admin extensions, and safe working boundaries)
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Shopware 6 Best Practices

## When to use this skill

Use this skill when:

- Working in a Shopware 6 plugin or full shop repository
- Implementing DAL entities, repositories, or criteria queries
- Creating services, subscribers, controllers, or migrations
- Extending Admin UI with Vue.js components
- Debugging Shopware-specific lifecycle or cache issues

## Core principles

- Prefer DAL repositories over raw SQL/DBAL for business data access.
- Keep business logic in services and wire dependencies via DI.
- Write idempotent migrations and keep schema changes forward-safe.
- Minimize criteria associations to avoid over-fetching and slow queries.
- Use strict typing and PSR-12 conventions for maintainable PHP code.

## Safe working boundaries

- Allowed: `custom/static-plugins/`, plugin `src/`, `Resources/`, `config/`.
- Read-only: `vendor/`, `public/`, `var/`, generated cache/artifacts.
- Never edit core Shopware packages under `vendor/shopware/`.
- Never edit admin-managed plugins in `custom/plugins/` unless explicitly requested.

## Plugin structure checklist

- Bootstrap class (`*Plugin.php` or `*Bundle.php`) in `src/`.
- Services and subscribers registered in `Resources/config/services.xml`.
- Routes configured via attributes or `Resources/config/routes.xml`.
- Migrations in `src/Migration/`.
- Storefront/Admin assets in `Resources/public/`.
- Twig templates in `Resources/views/`.

## Runtime checks after changes

```bash
bin/console cache:clear
bin/console plugin:refresh
```

Use project-specific install/activate/update commands as needed for the target plugin.
