---
name: shopify-new-section
description: Scaffold a new Shopify section with Liquid template, schema, and optional JS/CSS entrypoints following project conventions. Use when creating a new section for a Shopify theme.
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Scaffold a New Shopify Section

Arguments: $ARGUMENTS = section name in kebab-case (e.g. `featured-collection`, `hero-banner`)

## Steps

1. **Read project patterns**: Read an existing section from `sections/` to understand the project's conventions for:
   - HTML structure and Tailwind class usage
   - Schema structure (settings, blocks, presets)
   - Translation key patterns in `locales/en.default.json`
   - Whether Vite entrypoints are used (`src/entrypoints/`)

2. **Create section file** `sections/<name>.liquid` with:

```liquid
{%- liquid
  assign title = section.settings.title
-%}

<section
  class="section-<name>"
  style="{% render 'spacings', padding_top: section.settings.padding_top, padding_bottom: section.settings.padding_bottom %}"
  {{ section.shopify_attributes }}
>
  <div class="page-width">
    {% if title != blank %}
      <h2 class="text-2xl font-bold">{{ title }}</h2>
    {% endif %}

    {%- comment -%} Section content here {%- endcomment -%}
  </div>
</section>

{% schema %}
{
  "name": "t:sections.<name>.name",
  "tag": "section",
  "class": "section-<name>",
  "settings": [
    {
      "type": "header",
      "content": "t:schema.headers.content"
    },
    {
      "type": "text",
      "id": "title",
      "label": "t:sections.<name>.settings.title.label"
    },
    {
      "type": "header",
      "content": "t:schema.headers.spacing"
    },
    {
      "type": "select",
      "id": "padding_top",
      "label": "t:schema.settings.padding_top.label",
      "options": [
        { "value": "none", "label": "t:schema.options.none" },
        { "value": "s", "label": "t:schema.options.s" },
        { "value": "m", "label": "t:schema.options.m" },
        { "value": "l", "label": "t:schema.options.l" }
      ],
      "default": "none"
    },
    {
      "type": "select",
      "id": "padding_bottom",
      "label": "t:schema.settings.padding_bottom.label",
      "options": [
        { "value": "none", "label": "t:schema.options.none" },
        { "value": "s", "label": "t:schema.options.s" },
        { "value": "m", "label": "t:schema.options.m" },
        { "value": "l", "label": "t:schema.options.l" }
      ],
      "default": "none"
    }
  ],
  "presets": [
    {
      "name": "t:sections.<name>.name"
    }
  ]
}
{% endschema %}
```

3. **If JS is needed**: Create `src/entrypoints/<name>.js` as a Vite entrypoint (only if `src/entrypoints/` exists).

4. **If CSS is needed**: Create `src/css/components/<name>.css` (only if `src/css/components/` exists).

5. **Output translation key stubs** (do NOT write to locale file automatically):

```json
// Add to locales/en.default.json -> sections -> <name>:
"<name>": {
  "name": "<Human Readable Name>",
  "settings": {
    "title": {
      "label": "Title"
    }
  }
}
```

6. **Summary**: Report created files and manual steps needed:
   - Which template JSON file to add the section to (e.g. `templates/index.json`)
   - Translation keys to add to `locales/en.default.json`

## Rules
- Always include `{{ section.shopify_attributes }}` on the outermost element
- Always include standard spacing settings (padding_top, padding_bottom) at the end
- Use `t:` translation keys for all user-facing strings in schema
- Use Tailwind CSS classes, never inline styles (except for dynamic spacing)
- Read the actual project first — adapt the template to match existing conventions
- If a `spacings` snippet does not exist, use plain padding classes instead
