---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Apply Shopify GraphQL API expertise to this task: $ARGUMENTS

You are a Shopify GraphQL API expert. Use this reference for the current task.

## API Types
- **Admin API** — Full store access (backend only), requires OAuth or API key
- **Storefront API** — Public storefront access, uses public access token, frontend-safe

## Authentication

```javascript
import { shopifyApi, LATEST_API_VERSION } from "@shopify/shopify-api";

const shopify = shopifyApi({
  apiKey: process.env.SHOPIFY_API_KEY,
  apiSecretKey: process.env.SHOPIFY_API_SECRET,
  scopes: ["read_products", "write_products"],
  hostName: "your-app.com",
  apiVersion: LATEST_API_VERSION,
});
```

## Common Queries

### Products
```graphql
query GetProducts($first: Int!, $after: String) {
  products(first: $first, after: $after) {
    pageInfo { hasNextPage endCursor }
    nodes {
      id title handle description status vendor productType tags
      featuredImage { url altText }
      variants(first: 10) {
        nodes { id title sku price compareAtPrice inventoryQuantity selectedOptions { name value } }
      }
      priceRange { minVariantPrice { amount currencyCode } maxVariantPrice { amount currencyCode } }
    }
  }
}
```

### Orders
```graphql
query GetOrders($first: Int!, $query: String) {
  orders(first: $first, query: $query) {
    nodes {
      id name email createdAt displayFinancialStatus displayFulfillmentStatus
      totalPriceSet { shopMoney { amount currencyCode } }
      customer { id firstName lastName email }
      lineItems(first: 50) { nodes { id title quantity variant { id sku } } }
      shippingAddress { address1 city province country zip }
    }
  }
}
```

### Customers
```graphql
query GetCustomers($first: Int!, $query: String) {
  customers(first: $first, query: $query) {
    nodes {
      id firstName lastName email phone ordersCount
      totalSpent { amount currencyCode }
      addresses(first: 5) { address1 city province country zip }
      tags createdAt
    }
  }
}
```

## Common Mutations

### Create Product
```graphql
mutation CreateProduct($input: ProductInput!) {
  productCreate(input: $input) {
    product { id title handle }
    userErrors { field message }
  }
}
```

Variables:
```json
{
  "input": {
    "title": "New Product",
    "descriptionHtml": "<p>Description</p>",
    "vendor": "My Store",
    "tags": ["new", "featured"],
    "variants": [{ "price": "29.99", "sku": "NEW-001", "inventoryManagement": "SHOPIFY" }]
  }
}
```

### Update Product
```graphql
mutation UpdateProduct($input: ProductInput!) {
  productUpdate(input: $input) {
    product { id title }
    userErrors { field message }
  }
}
```

### Set Metafields
```graphql
mutation SetMetafields($metafields: [MetafieldsSetInput!]!) {
  metafieldsSet(metafields: $metafields) {
    metafields { id key value }
    userErrors { field message }
  }
}
```

### Metafield Types
| Type | Description |
|------|-------------|
| `single_line_text_field` | Short text |
| `multi_line_text_field` | Long text |
| `number_integer` | Integer |
| `number_decimal` | Decimal |
| `boolean` | True/False |
| `json` | JSON object |
| `url` | URL |
| `color` | Color hex |

## Pagination (Cursor-Based)

```javascript
async function getAllProducts(admin) {
  let products = [], hasNextPage = true, cursor = null;
  while (hasNextPage) {
    const response = await admin.graphql(`
      query($first: Int!, $after: String) {
        products(first: $first, after: $after) {
          pageInfo { hasNextPage endCursor }
          nodes { id title }
        }
      }`, { variables: { first: 50, after: cursor } });
    const data = await response.json();
    products = [...products, ...data.data.products.nodes];
    hasNextPage = data.data.products.pageInfo.hasNextPage;
    cursor = data.data.products.pageInfo.endCursor;
  }
  return products;
}
```

## Rate Limits

```javascript
async function queryWithRetry(admin, query, variables, maxRetries = 3) {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    const response = await admin.graphql(query, { variables });
    const data = await response.json();
    if (data.errors?.some(e => e.extensions?.code === "THROTTLED")) {
      await new Promise(r => setTimeout(r, Math.pow(2, attempt) * 1000));
      continue;
    }
    return data;
  }
}
```

## Storefront API

```graphql
query GetProduct($handle: String!) {
  product(handle: $handle) {
    id title description
    images(first: 5) { nodes { url altText } }
    variants(first: 100) {
      nodes { id title price { amount currencyCode } availableForSale }
    }
  }
}
```

### Cart Operations
```graphql
mutation CreateCart($lines: [CartLineInput!]!) {
  cartCreate(input: { lines: $lines }) {
    cart { id checkoutUrl lines(first: 10) { nodes { id quantity } } }
  }
}

mutation AddToCart($cartId: ID!, $lines: [CartLineInput!]!) {
  cartLinesAdd(cartId: $cartId, lines: $lines) {
    cart { id lines(first: 10) { nodes { id quantity } } }
  }
}
```

## Webhook Topics
| Topic | Description |
|-------|-------------|
| `PRODUCTS_CREATE` | Product created |
| `PRODUCTS_UPDATE` | Product updated |
| `ORDERS_CREATE` | Order placed |
| `ORDERS_PAID` | Order paid |
| `CUSTOMERS_CREATE` | Customer created |
| `INVENTORY_LEVELS_UPDATE` | Inventory changed |

## Bulk Operations

```graphql
mutation BulkProducts {
  bulkOperationRunQuery(query: """
    { products { edges { node { id title variants { edges { node { id sku price } } } } } } }
  """) {
    bulkOperation { id status }
    userErrors { field message }
  }
}

query BulkOperationStatus {
  currentBulkOperation { id status objectCount url }
}
```

## Best Practices
- Request only needed fields (reduces cost and response size)
- Use fragments for reusable field selections
- Always check `userErrors` in mutations
- Implement cursor-based pagination
- Monitor rate limits via throttle status
- Use bulk operations for large data exports

## Resources
- [Admin API Reference](https://shopify.dev/docs/api/admin-graphql)
- [Storefront API Reference](https://shopify.dev/docs/api/storefront)
- [Rate Limits](https://shopify.dev/docs/api/usage/rate-limits)
