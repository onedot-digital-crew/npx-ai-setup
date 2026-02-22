---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Apply Shopify Liquid templating expertise to this task: $ARGUMENTS

You are a Shopify Liquid expert. Use this reference for the current task.

## Liquid Basics

### Output Tags
```liquid
{{ product.title }}
{{ shop.name }}
{{ 'hello' | upcase }}
```

### Logic Tags
```liquid
{% if product.available %}
  <p>In Stock</p>
{% else %}
  <p>Sold Out</p>
{% endif %}
```

### Whitespace Control
```liquid
{%- if condition -%}content{%- endif -%}
```

## Core Objects

### Product
```liquid
{{ product.title }}
{{ product.description }}
{{ product.price | money }}
{{ product.compare_at_price | money }}
{{ product.vendor }}
{{ product.type }}
{{ product.tags | join: ', ' }}
{{ product.available }}
{{ product.url }}
{{ product.featured_image | image_url: width: 500 | image_tag }}

{% for variant in product.variants %}
  {{ variant.title }} - {{ variant.price | money }}
{% endfor %}

{{ product.metafields.custom.care_instructions }}
```

### Collection
```liquid
{{ collection.title }}
{{ collection.products_count }}

{% paginate collection.products by 12 %}
  {% for product in collection.products %}
    {% render 'product-card', product: product %}
  {% endfor %}
  {{ paginate | default_pagination }}
{% endpaginate %}
```

### Cart
```liquid
{{ cart.item_count }}
{{ cart.total_price | money }}
{% for item in cart.items %}
  {{ item.product.title }} x {{ item.quantity }} = {{ item.line_price | money }}
{% endfor %}
```

### Customer
```liquid
{% if customer %}
  Hello, {{ customer.first_name }}!
  {{ customer.orders_count }} orders, {{ customer.total_spent | money }} spent
{% endif %}
```

### Shop & Request
```liquid
{{ shop.name }} | {{ shop.domain }} | {{ shop.currency }}
{{ request.locale.iso_code }} | {{ request.page_type }} | {{ request.path }}
```

## Essential Filters

### String
```liquid
{{ 'hello' | capitalize }}      <!-- Hello -->
{{ 'hello' | upcase }}          <!-- HELLO -->
{{ 'hello' | append: ' world' }}
{{ 'hello world' | truncate: 8 }}
{{ 'hello world' | split: ' ' }}
{{ 'hello' | replace: 'e', 'a' }}
```

### Number & Money
```liquid
{{ 5 | plus: 3 }}  {{ 10 | divided_by: 3 }}  {{ 4.567 | round: 2 }}
{{ product.price | money }}
{{ product.price | money_with_currency }}
{{ product.price | money_without_trailing_zeros }}
```

### Array
```liquid
{{ array | first }}  {{ array | last }}  {{ array | size }}
{{ array | join: ', ' }}  {{ array | sort }}  {{ array | reverse }}
{{ array | map: 'title' }}  {{ array | where: 'available', true }}
```

### URL & Image
```liquid
{{ 'style.css' | asset_url }}
{{ image | image_url: width: 800 }}
{{ image | image_url: width: 800 | image_tag: loading: 'lazy', widths: '300, 600, 900, 1200', sizes: '(max-width: 600px) 100vw, 50vw' }}
```

### Date
```liquid
{{ article.created_at | date: '%B %d, %Y' }}
{{ 'now' | date: '%H:%M' }}
```

## Control Flow

```liquid
{% if product.price > 1000 %}...{% endif %}
{% unless product.available %}Sold Out{% endunless %}

{% case product.type %}
  {% when 'Shirt' %}<p>Shirt</p>
  {% else %}<p>Other</p>
{% endcase %}

{% if product.available and product.price < 5000 %}Affordable{% endif %}
{% if product.tags contains 'sale' %}On Sale{% endif %}
```

## Loops

```liquid
{% for product in collection.products limit: 4 offset: 2 %}
  {{ forloop.index }}: {{ product.title }}
  {{ forloop.first }} {{ forloop.last }} {{ forloop.length }}
{% else %}
  No products found.
{% endfor %}
```

## Variables

```liquid
{% assign price_in_dollars = product.price | divided_by: 100.0 %}
{% capture full_name %}{{ customer.first_name }} {{ customer.last_name }}{% endcapture %}
```

## Snippets & Sections

```liquid
{% render 'product-card', product: product, show_price: true %}
{% render 'product-card' for collection.products as product %}
{% section 'header' %}
{% sections 'footer-group' %}
{{ content_for_layout }}
```

## Forms

```liquid
{% form 'product', product %}
  <select name="id">
    {% for variant in product.variants %}
      <option value="{{ variant.id }}">{{ variant.title }}</option>
    {% endfor %}
  </select>
  <button type="submit">Add to Cart</button>
{% endform %}

{% form 'contact' %}
  <input type="email" name="contact[email]" required>
  <textarea name="contact[body]"></textarea>
  <button type="submit">Send</button>
{% endform %}
```

## Common Patterns

### Sale Badge
```liquid
{% if product.compare_at_price > product.price %}
  {% assign savings = product.compare_at_price | minus: product.price %}
  {% assign percent_off = savings | times: 100.0 | divided_by: product.compare_at_price | round %}
  <span class="sale-badge">{{ percent_off }}% OFF</span>
{% endif %}
```

### Variant Selector
```liquid
{% unless product.has_only_default_variant %}
  {% for option in product.options_with_values %}
    <label>{{ option.name }}</label>
    <select name="options[{{ option.name }}]">
      {% for value in option.values %}
        <option value="{{ value }}">{{ value }}</option>
      {% endfor %}
    </select>
  {% endfor %}
{% endunless %}
```

## Best Practices
- Use `render` not `include` (faster, scopes variables)
- Handle blank states: always check for `blank` or empty arrays
- Use descriptive variable names
- Use schema defaults in sections

## Resources
- [Liquid Reference](https://shopify.dev/docs/api/liquid)
- [Objects Reference](https://shopify.dev/docs/api/liquid/objects)
- [Filters Reference](https://shopify.dev/docs/api/liquid/filters)
