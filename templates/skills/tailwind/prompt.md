---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Tailwind CSS

## When to use this skill

Use this skill when:

- Adding or modifying styles in a project that uses Tailwind CSS
- Designing responsive layouts with breakpoint utilities
- Building component UIs with utility-first classes
- Creating custom design tokens via `tailwind.config`
- Migrating from CSS/SCSS to Tailwind utility classes
- Debugging unexpected styles or specificity conflicts

## Overview

Tailwind CSS is a utility-first CSS framework. Instead of writing custom CSS, you compose pre-defined utility classes directly in HTML/JSX/templates. The compiler scans source files and generates only the CSS that is actually used.

### Core concepts

- **Utility classes** — single-purpose classes like `flex`, `mt-4`, `text-blue-600`
- **Responsive prefixes** — `sm:`, `md:`, `lg:`, `xl:`, `2xl:` apply utilities at breakpoints (mobile-first)
- **State variants** — `hover:`, `focus:`, `active:`, `disabled:`, `group-hover:`, `peer-focus:`
- **Dark mode** — `dark:` prefix when `darkMode: 'class'` or `darkMode: 'media'` is configured
- **Arbitrary values** — `w-[342px]`, `bg-[#1a2b3c]`, `top-[calc(100%-1rem)]` for one-off values
- **`@apply`** — extracts repeated utility groups into reusable CSS classes (use sparingly)

### Tailwind v3 vs v4

Tailwind v4 (2025) replaces `tailwind.config.js` with CSS-first configuration using `@theme` in a CSS file. Check `package.json` to determine which version is in use before writing configuration.

## Best Practices

### Layout

1. **Use flexbox and grid utilities** — avoid custom `display` CSS; reach for `flex`, `grid`, `grid-cols-{n}`
2. **Gap over margin for spacing in flex/grid** — `gap-4` instead of `margin` on children
3. **Container with `mx-auto`** — `<div class="container mx-auto px-4">` for centred page content
4. **Avoid nesting flex containers unnecessarily** — keep layouts flat for readability

### Responsive design

Apply the smallest breakpoint first (mobile), then layer larger breakpoints:

```html
<!-- Mobile: stacked, md+: side-by-side -->
<div class="flex flex-col md:flex-row gap-4">
  <aside class="w-full md:w-64">...</aside>
  <main class="flex-1">...</main>
</div>
```

Breakpoints:

| Prefix | Min-width |
| ------ | --------- |
| `sm:`  | 640px     |
| `md:`  | 768px     |
| `lg:`  | 1024px    |
| `xl:`  | 1280px    |
| `2xl:` | 1536px    |

### Typography

```html
<h1 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white">Heading</h1>
<p class="text-base text-gray-600 dark:text-gray-300 leading-relaxed">Body text</p>
<span class="text-sm font-medium text-blue-600 hover:text-blue-800">Link</span>
```

### Colors and theming

Use the semantic color scale (50–950). Keep a consistent palette per project:

```js
// tailwind.config.js — extend, never replace
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          50:  '#eff6ff',
          500: '#3b82f6',
          900: '#1e3a8a',
        },
      },
    },
  },
}
```

Access custom colors the same way as defaults: `bg-brand-500`, `text-brand-900`.

### State and interaction

```html
<!-- Button with multiple state variants -->
<button class="
  bg-blue-600 text-white font-semibold px-4 py-2 rounded-lg
  hover:bg-blue-700
  focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
  active:scale-95
  disabled:opacity-50 disabled:cursor-not-allowed
  transition-colors duration-150
">
  Submit
</button>
```

### Group and peer

```html
<!-- group: parent controls child styles -->
<div class="group flex items-center gap-2">
  <span class="text-gray-600 group-hover:text-blue-600 transition-colors">Icon</span>
  <span class="text-gray-800 group-hover:font-semibold">Label</span>
</div>

<!-- peer: sibling controls sibling styles -->
<input id="cb" type="checkbox" class="peer sr-only" />
<label for="cb" class="peer-checked:text-blue-600 peer-checked:font-bold cursor-pointer">
  Toggle me
</label>
```

### Dark mode

```html
<div class="bg-white text-gray-900 dark:bg-gray-900 dark:text-gray-100">
  <p class="text-gray-600 dark:text-gray-400">Secondary text</p>
</div>
```

Enable in config:

```js
module.exports = {
  darkMode: 'class', // toggle via <html class="dark">
}
```

### @apply — use sparingly

Reserve `@apply` for genuine reuse (e.g., button base styles shared across components):

```css
/* Avoid for one-off styles — just use utilities inline */
.btn-primary {
  @apply inline-flex items-center gap-2 px-4 py-2 bg-blue-600 text-white
         font-semibold rounded-lg hover:bg-blue-700 focus:ring-2 focus:ring-blue-500
         transition-colors duration-150;
}
```

## Common Patterns

### Card component

```html
<div class="rounded-xl border border-gray-200 bg-white shadow-sm p-6 dark:border-gray-700 dark:bg-gray-800">
  <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Card title</h2>
  <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">Card description goes here.</p>
  <div class="mt-4 flex items-center justify-between">
    <span class="text-sm font-medium text-blue-600">View more</span>
    <button class="text-xs text-gray-400 hover:text-gray-600">Dismiss</button>
  </div>
</div>
```

### Responsive grid

```html
<ul class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
  <li class="...">Item 1</li>
  <li class="...">Item 2</li>
</ul>
```

### Form input

```html
<div class="flex flex-col gap-1">
  <label for="email" class="text-sm font-medium text-gray-700 dark:text-gray-300">
    Email address
  </label>
  <input
    id="email"
    type="email"
    class="rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm
           placeholder-gray-400 shadow-sm
           focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500
           dark:border-gray-600 dark:bg-gray-800 dark:text-white"
    placeholder="you@example.com"
  />
</div>
```

### Sidebar layout

```html
<div class="flex min-h-screen">
  <nav class="w-64 shrink-0 border-r border-gray-200 bg-gray-50 dark:border-gray-700 dark:bg-gray-900 p-4">
    <!-- Sidebar content -->
  </nav>
  <main class="flex-1 overflow-y-auto p-8">
    <!-- Main content -->
  </main>
</div>
```

### Badge / pill

```html
<span class="inline-flex items-center rounded-full bg-green-100 px-2.5 py-0.5 text-xs font-semibold text-green-800 dark:bg-green-900 dark:text-green-200">
  Active
</span>
```

## Tailwind v4 (CSS-first config)

```css
/* app.css — replaces tailwind.config.js */
@import "tailwindcss";

@theme {
  --color-brand-500: #3b82f6;
  --font-sans: "Inter", sans-serif;
  --radius-lg: 0.75rem;
}
```

## Resources

- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Tailwind UI Components](https://tailwindui.com)
- [Tailwind Play (sandbox)](https://play.tailwindcss.com)
