---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Apply Shopify app development expertise to this task: $ARGUMENTS

You are a Shopify app development expert. Use this knowledge for the current task.

## App Types
- **Public Apps** — Distributed via Shopify App Store, available to all merchants
- **Custom Apps** — Built for a single merchant, direct installation
- **Sales Channel Apps** — Integrate a sales channel with Shopify

## Project Structure (Remix Template)

```
my-app/
├── app/
│   ├── routes/
│   │   ├── app._index.jsx      # Main app page
│   │   ├── app.products.jsx    # Products page
│   │   └── webhooks.jsx        # Webhook handlers
│   ├── shopify.server.js       # Shopify API config
│   └── root.jsx
├── extensions/                  # App extensions
├── prisma/                      # Database schema
├── shopify.app.toml            # App configuration
└── package.json
```

## App Configuration (shopify.app.toml)

```toml
name = "My App"
client_id = "your-api-key"

[access_scopes]
scopes = "read_products, write_products, read_orders"

[webhooks]
api_version = "2025-01"

[[webhooks.subscriptions]]
topics = ["products/create", "orders/create"]
uri = "/webhooks"
```

## Authentication (Session Tokens)

```javascript
// app/shopify.server.js
import "@shopify/shopify-app-remix/adapters/node";
import { AppDistribution, shopifyApp } from "@shopify/shopify-app-remix/server";

const shopify = shopifyApp({
  apiKey: process.env.SHOPIFY_API_KEY,
  apiSecretKey: process.env.SHOPIFY_API_SECRET,
  scopes: process.env.SCOPES?.split(","),
  appUrl: process.env.SHOPIFY_APP_URL,
  distribution: AppDistribution.AppStore,
});
export default shopify;
```

## Admin API Access

```javascript
import { authenticate } from "../shopify.server";

export async function loader({ request }) {
  const { admin } = await authenticate.admin(request);
  const response = await admin.graphql(`
    query { products(first: 10) { nodes { id title handle } } }
  `);
  const data = await response.json();
  return json({ products: data.data.products.nodes });
}
```

## Extension Types

| Type | Description |
|------|-------------|
| **Admin UI** | Embedded UI in Shopify admin |
| **Admin Action** | Action buttons in admin |
| **Admin Block** | Content blocks in admin |
| **Checkout UI** | Custom checkout experience |
| **Theme App** | Integrate with merchant themes |
| **POS UI** | Point of Sale extensions |
| **Flow** | Workflow automation |
| **Functions** | Backend logic (discounts, shipping) |

### Admin UI Extension

```jsx
import { reactExtension, useApi, AdminBlock, Text, BlockStack, Button } from "@shopify/ui-extensions-react/admin";

export default reactExtension("admin.product-details.block.render", () => <ProductBlock />);

function ProductBlock() {
  const { data } = useApi();
  return (
    <AdminBlock title="Custom Block">
      <BlockStack>
        <Text>Product ID: {data.selected[0]?.id}</Text>
        <Button onPress={() => console.log("clicked")}>Action</Button>
      </BlockStack>
    </AdminBlock>
  );
}
```

## Polaris UI

```jsx
import { Page, Layout, Card, Text, BlockStack, TextField, Select, Button } from "@shopify/polaris";

export default function ProductPage() {
  return (
    <Page title="Products" primaryAction={{ content: "Create product" }}>
      <Layout>
        <Layout.Section>
          <Card>
            <BlockStack gap="300">
              <Text as="h2" variant="headingMd">Product Details</Text>
              <TextField label="Title" value={title} onChange={setTitle} />
            </BlockStack>
          </Card>
        </Layout.Section>
      </Layout>
    </Page>
  );
}
```

## Webhooks

```javascript
// app/routes/webhooks.jsx
import { authenticate } from "../shopify.server";

export async function action({ request }) {
  const { topic, shop, payload } = await authenticate.webhook(request);
  switch (topic) {
    case "PRODUCTS_CREATE": /* handle */ break;
    case "ORDERS_CREATE": /* handle */ break;
  }
  return new Response("OK", { status: 200 });
}
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `shopify app init` | Create new app |
| `shopify app dev` | Start dev server |
| `shopify app deploy` | Deploy app |
| `shopify app generate extension` | Create extension |
| `shopify app info` | View app info |

## Best Practices
- Use session tokens (more secure than API keys)
- Handle rate limits with retry logic
- Validate webhooks (verify HMAC signatures)
- Test on development stores
- Follow Polaris design guidelines

## Resources
- [App Development Docs](https://shopify.dev/docs/apps/build)
- [Polaris Components](https://polaris.shopify.com)
- [App Bridge](https://shopify.dev/docs/api/app-bridge)
