---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Apply Shopify Hydrogen/headless commerce expertise to this task: $ARGUMENTS

You are a Shopify Hydrogen expert. Use this knowledge for the current task.

## What is Hydrogen?

Shopify's headless commerce framework built on React Router, React, GraphQL, and Oxygen (edge hosting).

## Project Structure

```
hydrogen-app/
├── app/
│   ├── components/        # React components
│   ├── routes/            # Page routes
│   │   ├── _index.tsx     # Home page
│   │   ├── products.$handle.tsx
│   │   └── collections.$handle.tsx
│   ├── styles/
│   ├── entry.client.tsx
│   └── entry.server.tsx
├── public/
├── .env
├── hydrogen.config.ts
└── package.json
```

## Environment Setup

```env
SESSION_SECRET=your-session-secret
PUBLIC_STOREFRONT_API_TOKEN=your-storefront-api-token
PUBLIC_STORE_DOMAIN=your-store.myshopify.com
```

## Routes and Data Loading

```tsx
// app/routes/products.$handle.tsx
import { useLoaderData, type LoaderFunctionArgs } from "@remix-run/react";

export async function loader({ params, context }: LoaderFunctionArgs) {
  const { storefront } = context;
  const { product } = await storefront.query(PRODUCT_QUERY, {
    variables: { handle: params.handle },
  });
  if (!product) throw new Response("Not Found", { status: 404 });
  return { product };
}

export default function ProductPage() {
  const { product } = useLoaderData<typeof loader>();
  return (
    <div className="product-page">
      <h1>{product.title}</h1>
      <p>{product.description}</p>
      <ProductPrice data={product} />
      <AddToCartButton variantId={product.variants.nodes[0].id} />
    </div>
  );
}

const PRODUCT_QUERY = `#graphql
  query Product($handle: String!) {
    product(handle: $handle) {
      id title description handle
      variants(first: 1) { nodes { id price { amount currencyCode } } }
      featuredImage { url altText }
    }
  }
`;
```

## Hydrogen Components

```tsx
import { Image, Money, CartForm, useCart } from '@shopify/hydrogen';

<Image data={product.featuredImage} aspectRatio="1/1" sizes="(min-width: 45em) 50vw, 100vw" />
<Money data={product.price} />
<CartForm route="/cart" action={CartForm.ACTIONS.LinesAdd}
  inputs={{ lines: [{ merchandiseId: variantId, quantity: 1 }] }}>
  <button type="submit">Add to Cart</button>
</CartForm>
```

## Cart Management

```tsx
// app/routes/cart.tsx
export async function action({ request, context }: ActionFunctionArgs) {
  const { cart } = context;
  const formData = await request.formData();
  const { action, inputs } = CartForm.getFormInput(formData);
  switch (action) {
    case CartForm.ACTIONS.LinesAdd: return await cart.addLines(inputs.lines);
    case CartForm.ACTIONS.LinesUpdate: return await cart.updateLines(inputs.lines);
    case CartForm.ACTIONS.LinesRemove: return await cart.removeLines(inputs.lineIds);
  }
}
```

## Collections

```tsx
export async function loader({ params, context }: LoaderFunctionArgs) {
  const { collection } = await context.storefront.query(COLLECTION_QUERY, {
    variables: { handle: params.handle, first: 24 },
  });
  return { collection };
}

const COLLECTION_QUERY = `#graphql
  query Collection($handle: String!, $first: Int!) {
    collection(handle: $handle) {
      id title description
      products(first: $first) {
        nodes {
          id title handle
          featuredImage { url altText }
          priceRange { minVariantPrice { amount currencyCode } }
        }
      }
    }
  }
`;
```

## Search

```tsx
export async function loader({ request, context }: LoaderFunctionArgs) {
  const searchTerm = new URL(request.url).searchParams.get("q");
  if (!searchTerm) return { results: null };
  const { products } = await context.storefront.query(SEARCH_QUERY, {
    variables: { query: searchTerm, first: 20 },
  });
  return { results: products };
}
```

## Oxygen Deployment

```bash
npx shopify hydrogen link
npx shopify hydrogen deploy
```

## Bring Your Own Stack (Next.js)

```typescript
const domain = process.env.SHOPIFY_STORE_DOMAIN;
const storefrontAccessToken = process.env.SHOPIFY_STOREFRONT_ACCESS_TOKEN;

export async function shopifyFetch({ query, variables }) {
  const response = await fetch(`https://${domain}/api/2025-01/graphql.json`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-Shopify-Storefront-Access-Token": storefrontAccessToken,
    },
    body: JSON.stringify({ query, variables }),
  });
  return response.json();
}
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `npm create @shopify/hydrogen` | Create new project |
| `npm run dev` | Start dev server |
| `npx shopify hydrogen link` | Link to store |
| `npx shopify hydrogen deploy` | Deploy to Oxygen |

## Performance Best Practices
- Server-side rendering for initial page load
- Use React Suspense for streaming/progressive loading
- Use Hydrogen's Image component for optimization
- Code splitting with lazy loading
- Configure appropriate cache headers
- Prefetch links on hover

## Resources
- [Hydrogen Documentation](https://shopify.dev/docs/storefronts/headless/hydrogen)
- [Storefront API Reference](https://shopify.dev/docs/api/storefront)
- [Oxygen Hosting](https://shopify.dev/docs/storefronts/headless/hydrogen/deployments)
