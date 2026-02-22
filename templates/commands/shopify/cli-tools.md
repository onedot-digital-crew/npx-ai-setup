---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Apply Shopify CLI and developer tools expertise to this task: $ARGUMENTS

You are a Shopify CLI expert. Use this reference for the current task.

## Installation

```bash
npm install -g @shopify/cli @shopify/theme
shopify version
shopify auth login
```

## Theme Commands

### Development
```bash
shopify theme init my-theme                              # Clone Skeleton theme
shopify theme dev                                        # Start dev server
shopify theme dev --store my-store.myshopify.com         # Connect to specific store
shopify theme dev --theme THEME_ID                       # Work on specific theme
shopify theme dev --live-reload hot-reload               # Hot reload mode
```

### Push & Pull
```bash
shopify theme push                                       # Push to Shopify
shopify theme push --unpublished                         # Push as new theme
shopify theme push --theme THEME_ID                      # Push to specific theme
shopify theme push --only templates/*.json               # Push specific files
shopify theme push --ignore config/settings_data.json    # Ignore specific files
shopify theme pull                                       # Pull from Shopify
shopify theme pull --theme THEME_ID                      # Pull specific theme
```

### Management
```bash
shopify theme list                                       # List all themes
shopify theme publish --theme THEME_ID                   # Publish theme
shopify theme rename --theme THEME_ID --name "New Name"  # Rename theme
shopify theme delete --theme THEME_ID                    # Delete theme
shopify theme package                                    # Package for upload
shopify theme open --theme THEME_ID                      # Open in browser
```

### Linting (Theme Check)
```bash
shopify theme check                                      # Lint current directory
shopify theme check --path ./sections                    # Check specific path
shopify theme check --auto-correct                       # Auto-fix issues
shopify theme check --output json                        # JSON output
shopify theme check --fail-level warning                 # CI mode
```

## App Commands

```bash
shopify app init                                         # Create new app
shopify app dev                                          # Start dev server
shopify app dev --reset                                  # Reset app config
shopify app deploy                                       # Deploy app
shopify app generate extension                           # Generate extension
shopify app info                                         # View app info
shopify app env show                                     # Show env variables
shopify app function run --path extensions/my-function   # Test function
shopify app function typegen --path extensions/my-function # Generate types
shopify app versions list                                # List versions
```

## Hydrogen Commands

```bash
npm create @shopify/hydrogen@latest                      # Create Hydrogen project
npx shopify hydrogen link                                # Link to store
npx shopify hydrogen deploy                              # Deploy to Oxygen
npx shopify hydrogen preview                             # Preview production build
```

## VS Code Setup

```bash
code --install-extension Shopify.theme-check-vscode
```

```json
// .vscode/settings.json
{
  "shopifyLiquid.formatterDevPreview": true,
  "editor.formatOnSave": true,
  "[liquid]": { "editor.defaultFormatter": "Shopify.theme-check-vscode" },
  "files.associations": { "*.liquid": "liquid" }
}
```

## Theme Check Config (.theme-check.yml)

```yaml
extends: :default
SyntaxError: { enabled: true, severity: error }
DeprecatedFilter: { enabled: true, severity: warning }
MissingTemplate: { enabled: true }
UnusedAssign: { enabled: true }
AssetSizeCSS: { enabled: true, threshold_in_bytes: 100000 }
AssetSizeJavaScript: { enabled: true, threshold_in_bytes: 50000 }
ignore:
  - vendor/**/*
```

## CI/CD (GitHub Actions)

```yaml
# .github/workflows/theme-check.yml
name: Theme Check
on: [push, pull_request]
jobs:
  theme-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with: { node-version: "18" }
      - run: npm install -g @shopify/cli @shopify/theme
      - run: shopify theme check --fail-level error
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| CLI not found | `npm install -g @shopify/cli` |
| Auth issues | `shopify auth logout && shopify auth login --reset` |
| Theme not syncing | Check `.shopify-cli.yml` and store URL |
| Port in use | `shopify theme dev --port 9293` |

## Resources
- [Shopify CLI Reference](https://shopify.dev/docs/api/shopify-cli)
- [Theme Check Docs](https://shopify.dev/docs/storefronts/themes/tools/theme-check)
- [VS Code Extension](https://shopify.dev/docs/storefronts/themes/tools/shopify-liquid-vscode)
