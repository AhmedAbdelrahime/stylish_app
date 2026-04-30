# Store Configuration

Edit `store_config.dart` when reusing this app for another store.

Main sections:

- `StoreConfig`: brand, country, delivery fee, currency, catalog scope,
  stock behavior, and default-size behavior.
- `StoreAssets`: logo, app icon, common SVG/image assets.
- `StoreContact`: WhatsApp number, support phone, support email, support messages.
- `StoreLocation`: default map center and sample address.
- `StorePayment`: payment method labels and descriptions.
- `StoreOrderMessages`: WhatsApp order notes and confirmation text.
- `StoreSizes`: clothing and shoe sizes.
- `StoreColors`: app theme colors.
- `AppPrice`: shared price formatting.

For Supabase, run the matching migration:

`supabase/migrations/20260430_configure_fashion_egypt_store.sql`

That migration changes sizes to text values and sets the default order currency to `EGP`.
Run later migrations too, including `20260501_decrement_stock_on_order.sql`,
so checkout reduces tracked product stock after an order is created.
