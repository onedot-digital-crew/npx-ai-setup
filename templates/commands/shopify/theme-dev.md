---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Apply Shopify theme development best practices to this task: $ARGUMENTS

You are a Shopify theme development expert. Use this knowledge for the current task.

## Theme Architecture

```
your-theme/
├── assets/          # CSS, JS, images, fonts
├── config/          # Theme settings (settings_schema.json, settings_data.json)
├── layout/          # Layout files (theme.liquid required)
├── locales/         # Translation files (en.default.json, etc.)
├── sections/        # Reusable section components
├── snippets/        # Reusable code snippets
└── templates/       # Page templates (JSON or Liquid)
    └── customers/   # Customer account templates
```

**Minimum Requirements:** Only `layout/theme.liquid` is required for upload.

### Component Hierarchy

```
Layout (theme.liquid)
  └── Template (product.json)
        └── Sections (product-details.liquid)
              └── Blocks (price, quantity, add-to-cart)
                    └── Snippets (icon-cart.liquid)
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `shopify theme init` | Clone Skeleton theme |
| `shopify theme dev` | Start development server |
| `shopify theme push` | Upload theme to store |
| `shopify theme pull` | Download theme from store |
| `shopify theme check` | Run theme linter |
| `shopify theme list` | List all themes |
| `shopify theme publish` | Publish unpublished theme |

## Key Concepts

### Layouts

Main layout file `layout/theme.liquid`:

```liquid
<!DOCTYPE html>
<html lang="{{ request.locale.iso_code }}">
<head>
  <title>{{ page_title }}</title>
  {{ content_for_header }}
</head>
<body>
  {% sections 'header-group' %}
  <main>{{ content_for_layout }}</main>
  {% sections 'footer-group' %}
</body>
</html>
```

### JSON Templates

```json
{
  "sections": {
    "main": {
      "type": "product-details",
      "settings": {}
    }
  },
  "order": ["main"]
}
```

### Sections with Schema

```liquid
{% schema %}
{
  "name": "Featured Collection",
  "settings": [
    { "type": "collection", "id": "collection", "label": "Collection" },
    { "type": "range", "id": "products_to_show", "min": 2, "max": 12, "step": 1, "default": 4, "label": "Products to show" }
  ],
  "presets": [{ "name": "Featured Collection" }]
}
{% endschema %}

<section class="featured-collection">
  {% if section.settings.collection != blank %}
    {% for product in section.settings.collection.products limit: section.settings.products_to_show %}
      {% render 'product-card', product: product %}
    {% endfor %}
  {% endif %}
</section>
```

### Blocks

```liquid
{% schema %}
{
  "name": "Slideshow",
  "blocks": [
    {
      "type": "slide",
      "name": "Slide",
      "settings": [
        { "type": "image_picker", "id": "image", "label": "Image" },
        { "type": "text", "id": "heading", "label": "Heading" }
      ]
    }
  ]
}
{% endschema %}

{% for block in section.blocks %}
  <div class="slide" {{ block.shopify_attributes }}>
    <img src="{{ block.settings.image | image_url: width: 1920 }}">
    <h2>{{ block.settings.heading }}</h2>
  </div>
{% endfor %}
```

## Best Practices

### Performance
- Lazy load images below the fold (`loading="lazy"`)
- Use `image_url` filter with appropriate widths
- Defer non-critical CSS/JS
- Prefer CSS over JavaScript

```liquid
{{ product.featured_image | image_url: width: 800 | image_tag:
  loading: 'lazy',
  widths: '300, 500, 800, 1200',
  sizes: '(max-width: 600px) 100vw, 50vw'
}}
```

### Accessibility
- Use semantic HTML (`<main>`, `<nav>`, `<article>`)
- Provide alt text for images
- Ensure proper heading hierarchy
- Support keyboard navigation

### Theme Settings (settings_schema.json)

```json
[
  { "name": "theme_info", "theme_name": "My Theme", "theme_version": "1.0.0" },
  {
    "name": "Colors",
    "settings": [
      { "type": "color", "id": "primary_color", "label": "Primary color", "default": "#000000" }
    ]
  }
]
```

Access in Liquid: `{{ settings.primary_color }}`

## Resources
- [Dawn Theme (Reference)](https://github.com/Shopify/dawn)
- [Skeleton Theme (Starter)](https://github.com/shopify/skeleton-theme)
- [Theme Architecture Docs](https://shopify.dev/docs/storefronts/themes/architecture)
