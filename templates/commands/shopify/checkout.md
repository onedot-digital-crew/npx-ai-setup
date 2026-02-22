---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Apply Shopify checkout customization expertise to this task: $ARGUMENTS

You are a Shopify checkout customization expert. Use this knowledge for the current task.

## Extension Types

| Type | Description |
|------|-------------|
| **Checkout UI** | Add custom UI to checkout |
| **Post-purchase** | Upsells after order |
| **Customer Accounts** | Extend account pages |
| **Thank You** | Customize order confirmation |
| **Order Status** | Extend order tracking |

## Getting Started

```bash
shopify app generate extension
# Select: Checkout UI
```

### Extension Structure
```
extensions/
└── checkout-ui/
    ├── src/Checkout.jsx
    ├── locales/en.default.json
    └── shopify.extension.toml
```

### Configuration
```toml
api_version = "2025-01"

[[extensions]]
type = "ui_extension"
name = "Custom Checkout"
handle = "custom-checkout"

[[extensions.targeting]]
module = "./src/Checkout.jsx"
target = "purchase.checkout.block.render"
```

## Checkout UI Extensions

### Basic Extension
```jsx
import { reactExtension, Banner, useTranslate } from "@shopify/ui-extensions-react/checkout";

export default reactExtension("purchase.checkout.block.render", () => <Extension />);

function Extension() {
  const translate = useTranslate();
  return <Banner title={translate("welcomeMessage")}>Thank you for shopping!</Banner>;
}
```

### Extension Targets
```jsx
"purchase.checkout.shipping-option-list.render-before"
"purchase.checkout.shipping-option-list.render-after"
"purchase.checkout.payment-method-list.render-before"
"purchase.checkout.cart-line-list.render-after"
"purchase.checkout.header.render-after"
"purchase.checkout.footer.render-after"
"purchase.checkout.block.render"
"purchase.checkout.delivery-address.render-before"
```

### Using Checkout Data
```jsx
import { useCartLines, useTotalAmount, useShippingAddress, useCustomer, useDiscountCodes } from "@shopify/ui-extensions-react/checkout";

function Extension() {
  const cartLines = useCartLines();
  const totalAmount = useTotalAmount();
  const customer = useCustomer();
  const itemCount = cartLines.reduce((sum, line) => sum + line.quantity, 0);

  return (
    <BlockStack>
      <Text>Items: {itemCount}</Text>
      <Text>Total: ${totalAmount?.amount}</Text>
      {customer && <Text>Welcome back, {customer.firstName}!</Text>}
    </BlockStack>
  );
}
```

### UI Components
```jsx
import { Banner, BlockStack, InlineStack, Text, Button, Checkbox, TextField, Select, Heading } from "@shopify/ui-extensions-react/checkout";
```

### Custom Fields with Metafields
```jsx
import { useApplyMetafieldsChange } from "@shopify/ui-extensions-react/checkout";

function GiftMessage() {
  const [message, setMessage] = useState("");
  const applyMetafieldsChange = useApplyMetafieldsChange();

  const handleChange = async (value) => {
    setMessage(value);
    await applyMetafieldsChange({
      type: "updateMetafield", namespace: "custom", key: "gift_message",
      valueType: "string", value,
    });
  };
  return <TextField label="Gift message" value={message} onChange={handleChange} />;
}
```

### Buyer Journey Intercept (Validation)
```jsx
import { useBuyerJourneyIntercept } from "@shopify/ui-extensions-react/checkout";

function AgeVerification() {
  const [verified, setVerified] = useState(false);
  useBuyerJourneyIntercept(({ canBlockProgress }) => {
    if (!verified && canBlockProgress) {
      return { behavior: "block", reason: "Age verification required",
        errors: [{ message: "Please verify your age to continue" }] };
    }
    return { behavior: "allow" };
  });
  return <Checkbox checked={verified} onChange={setVerified}>I confirm I am 21 or older</Checkbox>;
}
```

## Post-Purchase Upsell
```jsx
import { extend, render, useExtensionInput, BlockStack, Button, Text, CalloutBanner } from "@shopify/post-purchase-ui-extensions-react";

extend("Checkout::PostPurchase::ShouldRender", async ({ storage }) => {
  const upsellProduct = await fetchUpsellProduct();
  await storage.update({ upsellProduct });
  return { render: true };
});

render("Checkout::PostPurchase::Render", () => <App />);
```

## Localization
```json
// locales/en.default.json
{ "welcomeMessage": "Welcome to checkout", "giftLabel": "Gift options" }
```

```jsx
import { useTranslate } from "@shopify/ui-extensions-react/checkout";
const translate = useTranslate();
<Text>{translate("welcomeMessage")}</Text>
```

## Best Practices
- Keep extensions fast (minimize API calls)
- Handle errors gracefully with user-friendly messages
- Support localization via translation files
- Test on mobile (checkout is often mobile)
- Follow Shopify's checkout design guidelines
- Use progressive enhancement

## Resources
- [Checkout UI Extensions](https://shopify.dev/docs/api/checkout-ui-extensions)
- [Checkout UI Components](https://shopify.dev/docs/api/checkout-ui-extensions/components)
- [Extension Targets Reference](https://shopify.dev/docs/api/checkout-ui-extensions/extension-targets-overview)
