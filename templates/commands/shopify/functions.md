---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Apply Shopify Functions expertise to this task: $ARGUMENTS

You are a Shopify Functions expert. Use this knowledge for the current task.

## What are Shopify Functions?

Serverless WebAssembly modules that extend Shopify's backend logic. They run on Shopify's infrastructure, execute in milliseconds, scale automatically, and are upgrade-safe.

## Function Types

| API | Purpose |
|-----|---------|
| **Discounts** | Product, order, and shipping discounts |
| **Delivery Customization** | Rename, reorder, hide shipping options |
| **Payment Customization** | Filter, reorder payment methods |
| **Cart & Checkout Validation** | Block checkout with errors |
| **Order Routing** | Control fulfillment locations |
| **Cart Transform** | Modify cart contents |

## Getting Started

```bash
shopify app generate extension
# Select function type (Delivery customization, Product discount, etc.)
```

### Function Structure
```
extensions/
└── my-discount/
    ├── src/run.rs (or run.js)
    ├── input.graphql
    ├── shopify.extension.toml
    └── Cargo.toml (for Rust)
```

### Configuration
```toml
api_version = "2025-01"

[[extensions]]
name = "Volume Discount"
handle = "volume-discount"
type = "function"

[[extensions.targeting]]
target = "purchase.product-discount.run"
input_query = "src/run.graphql"
export = "run"

[extensions.build]
command = "cargo wasi build --release"
path = "target/wasm32-wasi/release/volume-discount.wasm"
```

### Input Query
```graphql
query RunInput {
  cart {
    lines {
      id
      quantity
      merchandise { ... on ProductVariant { id product { id title hasAnyTag(tags: ["discount-eligible"]) } } }
      cost { amountPerQuantity { amount currencyCode } }
    }
  }
  discountNode { metafield(namespace: "volume-discount", key: "config") { value } }
}
```

## Product Discount (JavaScript)

```javascript
export function run(input) {
  const config = JSON.parse(input.discountNode.metafield?.value ?? '{"minimumQuantity": 5, "percentage": "10"}');
  const discounts = [];

  for (const line of input.cart.lines) {
    const variant = line.merchandise;
    if (line.quantity >= config.minimumQuantity && variant.__typename === "ProductVariant" && variant.product.hasAnyTag) {
      discounts.push({
        targets: [{ productVariant: { id: variant.id } }],
        value: { percentage: { value: config.percentage } },
        message: `${config.percentage}% volume discount`,
      });
    }
  }
  return { discounts, discountApplicationStrategy: DiscountApplicationStrategy.First };
}
```

## Product Discount (Rust)

```rust
use shopify_function::prelude::*;
use shopify_function::Result;

#[shopify_function_target(query_path = "src/run.graphql", schema_path = "schema.graphql")]
fn run(input: input::ResponseData) -> Result<output::FunctionRunResult> {
    let mut discounts = vec![];
    let config: Config = input.discount_node.metafield.as_ref()
        .map(|m| serde_json::from_str(&m.value).unwrap()).unwrap_or_default();

    for line in input.cart.lines {
        if line.quantity >= config.minimum_quantity {
            let merchandise = match &line.merchandise {
                input::InputCartLinesMerchandise::ProductVariant(v) => v,
                _ => continue,
            };
            if merchandise.product.has_any_tag {
                discounts.push(output::Discount {
                    targets: vec![output::Target::ProductVariant(output::ProductVariantTarget { id: merchandise.id.clone(), quantity: None })],
                    value: output::Value::Percentage(output::Percentage { value: Decimal::from_str(&config.discount_percentage).unwrap() }),
                    message: Some(format!("{}% volume discount", config.discount_percentage)),
                });
            }
        }
    }
    Ok(output::FunctionRunResult { discounts, discount_application_strategy: output::DiscountApplicationStrategy::FIRST })
}
```

## Payment Customization (JavaScript)

```javascript
export function run(input) {
  const operations = [];
  const total = parseFloat(input.cart.cost.totalAmount.amount);
  if (total > 500) {
    const cod = input.paymentMethods.find(m => m.name.includes("Cash on Delivery"));
    if (cod) operations.push({ hide: { paymentMethodId: cod.id } });
  }
  return { operations };
}
```

## Cart & Checkout Validation (Rust)

```rust
fn run(input: input::ResponseData) -> Result<output::FunctionRunResult> {
    let mut errors = vec![];
    let total: f64 = input.cart.cost.total_amount.amount.parse().unwrap();
    if total < 25.0 {
        errors.push(output::FunctionError {
            localized_message: "Minimum order value is $25.00".to_string(),
            target: output::Target::Cart,
        });
    }
    Ok(output::FunctionRunResult { errors })
}
```

## Testing

```bash
shopify app function run --path extensions/my-function
cat input.json | shopify app function run --path extensions/my-function
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `shopify app generate extension` | Create function |
| `shopify app function run` | Test locally |
| `shopify app function typegen` | Generate types |
| `shopify app deploy` | Deploy function |

## Best Practices
- Use Rust for large carts (JavaScript can timeout)
- Minimize input query (only request needed data)
- Keep logic simple, avoid complex loops
- Parse metafield configuration once
- Test with realistic cart data

## Resources
- [Functions Overview](https://shopify.dev/docs/apps/build/functions)
- [Discount Functions](https://shopify.dev/docs/apps/build/discounts)
- [Delivery Customization](https://shopify.dev/docs/apps/build/checkout/delivery-shipping)
