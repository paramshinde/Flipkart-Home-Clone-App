# `get_home.php` response mapping

The Flutter model layer maps the response structure supplied for:

`GET https://your-keeper.com/keeper/api/home/get_home.php`

The parser reads the outer fields `success`, `status`, `message`, and `data`. Under `data`, it maps these exact snake_case API keys:

| API key | Dart model / property | Displayed in |
|---|---|---|
| `delivery_address` | `HomeData.deliveryAddress` | Delivery address row |
| `supercoin_balance` | `HomeData.supercoinBalance` | Header coin balance |
| `search.placeholder` | `HomeSearch.placeholder` | Search field hint |
| `search.voice_enabled` | `HomeSearch.voiceEnabled` | Microphone affordance |
| `search.scan_enabled` | `HomeSearch.scanEnabled` | QR scanner affordance |
| `service_tabs[]` | `ServiceTab` | Top Flipkart / Minutes / Travel / Value 365 shortcuts |
| `categories[]` | `HomeCategory` | Category rail |
| `banners[]` | `HomeBanner` | Banner carousel |
| `ad_products[]` | `HomeAdProduct` | Sponsored product tiles |
| `suggested_for_you[]` | `HomeProduct` | Suggested For You product shelf |
| `live_streams[]` | `HomeLiveStream` | Live Shopping row |
| `bottom_nav[]` | `HomeNavItem` | Bottom navigation |

## Per-item fields

- Service tabs: `id`, `name`, `slug`, `badge_text`, `is_selected`, `sort_order`, `status`, `icon_url`.
- Categories: `id`, `name`, `slug`, `is_selected`, `sort_order`, `status`, `icon_url`.
- Banners: `id`, `tag_text`, `title`, `subtitle`, `offer_text`, `brand_label`, `terms_text`, `redirect_url`, `sort_order`, `status`, `image_url`.
- Ad products: `id`, `brand`, `product_name`, `cta_text`, `is_ad`, `redirect_url`, `sort_order`, `status`, `image_url`.
- Suggested products: `id`, `category_id`, `brand`, `name`, `rating`, `rating_count`, `price`, `mrp`, `discount_percent`, `is_suggested`, `sort_order`, `status`, `category_name`, `category_slug`, `image_url`.
- Live streams: `id`, `title`, `badge_text`, `offer_text`, `is_live`, `stream_url`, `status`, `thumbnail_url`.
- Bottom navigation: `id`, `label`, `slug`, `is_selected`, `sort_order`, `status`, `icon_url`.

Rows with `status: false` are excluded. Remaining sorted collections are ordered by `sort_order` where that field exists. Nullable text and image fields are converted to empty strings so the UI can safely display fallbacks.

## Important image URL note

The sample response uses `https://your-domain.com/...` for image URLs. That appears to be a placeholder host. Replace it in the backend response with the real publicly reachable image domain (or configure the backend to emit the correct URLs). If your real API returns relative paths, `NetworkImageView` resolves them against the host in `AppConstants.homeApiUrl`.

The sample `redirect_url` and `stream_url` values use `example.com` placeholder destinations; the current UI displays the API content but does not yet launch those destinations.
