---
name: shopify-new-block
description: Scaffold a new Shopify section block with Liquid template, schema, doc comment, standard spacing, and translation key stubs following project conventions. Use when adding a new block type to a Shopify theme.
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Scaffold a New Shopify Block

Arguments: $ARGUMENTS = block name in kebab-case (e.g. `icon-list`, `testimonial`)

## Steps

1. **Read reference block**: Read `blocks/button.liquid` (or another existing block) to understand:
   - `{% doc %}` comment structure
   - `{{ block.shopify_attributes }}` usage
   - Standard spacing settings pattern
   - `visible_if` usage for advanced settings
   - Translation key conventions in `locales/en.default.json`

2. **Read locale file**: Read `locales/en.default.json` to understand the existing `blocks` key structure.

3. **Create block file** `blocks/<name>.liquid` with:

```liquid
{%- doc -%}
  Renders <description>.

  @param {type} setting_name - Description
{%- enddoc -%}

{%- liquid
  assign example_setting = block.settings.example_setting
-%}

<div
  class="block-<name>"
  style="{% render 'spacings', padding_top: block.settings.padding_top, padding_bottom: block.settings.padding_bottom %}"
  {{ block.shopify_attributes }}
>
  {%- comment -%} Block content here {%- endcomment -%}
</div>

{% schema %}
{
  "name": "t:blocks.<name>.name",
  "settings": [
    {
      "type": "header",
      "content": "t:schema.headers.content"
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
    },
    {
      "type": "checkbox",
      "id": "advanced_settings",
      "label": "t:schema.settings.advanced_settings.label"
    },
    {
      "type": "text",
      "id": "custom_class",
      "label": "t:schema.settings.custom_class.label",
      "visible_if": "{{ block.settings.advanced_settings }}"
    }
  ],
  "presets": [
    {
      "name": "t:blocks.<name>.name",
      "category": "Content"
    }
  ]
}
{% endschema %}
```

4. **Output translation key stubs** (do NOT write to locale file automatically):

```json
// Add to locales/en.default.json -> blocks -> <name>:
"<name>": {
  "name": "<Human Readable Name>",
  "settings": {
    "example_setting": {
      "label": "Example Setting"
    }
  }
}
```

5. **Summary**: Report:
   - Created file: `blocks/<name>.liquid`
   - Translation keys to add to `locales/en.default.json`
   - Reminder: Register block in the parent section's `{% schema %}` under `"blocks": [{"type": "<name>"}]`

## Rules
- Always include `{{ block.shopify_attributes }}` on the wrapper element
- Always include standard spacing settings (padding_top, padding_bottom) at the end
- Always include `advanced_settings` checkbox + `custom_class` as the last settings
- Use `visible_if` for optional/conditional settings
- Use `{%- doc -%}` comment at the top documenting parameters
- Underscore-prefix (`_name.liquid`) only for product sub-blocks in `sections/product.liquid`
- Use Tailwind CSS classes, no inline styles (except dynamic spacing)
- Read the actual project first — adapt the template to match existing conventions
- If a `spacings` snippet does not exist, use plain padding classes instead
