# Flipkart-style Home Screen Clone (Flutter)

A responsive Flutter home-screen starter based on the supplied screenshot. It uses MVC-style folders, GetX state management, Dio for the GET request, and `cached_network_image` for remote images.

## Included

- Gradient shopping header with shortcut tiles, delivery location, search and category rail.
- API-driven banner carousel, promotion tiles and product shelves.
- Loading, initial error, retry and pull-to-refresh states.
- A two-second minimum Flutter splash page while the first API request runs.
- Native splash and Android/iOS launcher icon generation configuration.
- Responsive sizing through `MediaQuery` and `LayoutBuilder`; there are no fixed screen-width assumptions.

## 1. Create the native platform folders

This project contains the Flutter source and package configuration. Android/iOS platform scaffolding is not checked in. From this folder run:

```bash
flutter create --platforms=android,ios .
```

If you only need Android, use `--platforms=android`. After scaffolding, set the Android application label to `Flipkart` in `android/app/src/main/AndroidManifest.xml` and the iOS display name in `ios/Runner/Info.plist` if you want the installed app name to match.

## 2. Install dependencies and generate app assets

```bash
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Then run:

```bash
flutter run
```

## 3. API configuration

The GET endpoint is configured in:

`lib/core/constants/app_constants.dart`

```dart
static const String homeApiUrl =
    'https://your-keeper.com/keeper/api/home/get_home.php';
```

The models now map the actual response keys supplied for this task:

| API key under `data` | Model / UI mapping |
|---|---|
| `delivery_address`, `supercoin_balance` | Header delivery row and coin balance |
| `search` | Search placeholder, microphone and scanner settings |
| `service_tabs` | Top service shortcut tiles |
| `categories` | Category icon rail |
| `banners` | Banner carousel, including tag, offer, brand and terms text |
| `ad_products` | Sponsored product tiles |
| `suggested_for_you` | Suggested product shelf with brand, price, MRP, rating and discount |
| `live_streams` | Live Shopping row |
| `bottom_nav` | API-driven bottom navigation |

See `docs/api_mapping.md` for the full per-item field map. Rows with `status: false` are excluded and collections with `sort_order` are sorted before display. Optional null values are safely treated as empty values.

**Image host warning:** the sample JSON uses `https://your-domain.com/...` for image URLs. Make sure the actual API response contains the real reachable image host; otherwise `cached_network_image` will show its fallback widget. The API endpoint itself should also be checked against your actual server hostname before running the app.

## 4. MVC / GetX structure

```text
lib/
├── controllers/
│   └── home_controller.dart
├── core/constants/
│   └── app_constants.dart
├── data/
│   ├── models/
│   │   └── home_models.dart
│   └── services/
│       └── home_api_service.dart
├── views/
│   ├── home/
│   │   ├── home_page.dart
│   │   └── widgets/
│   └── splash/
│       └── splash_page.dart
├── widgets/
│   └── network_image_view.dart
└── main.dart
```

`HomeController` owns the observable loading, response, error and bottom-navigation state. `HomePage` listens with `Obx`. `HomeApiService` performs the GET request and converts network/format errors into user-readable messages.

## 5. Notes

- The top service shortcuts, categories, banners, ad products, suggested products, live streams and bottom navigation are populated from the API response. The current search, scan, voice and navigation controls are UI affordances; backend search, QR scanning, voice input and destination routing are not wired to additional endpoints in this task.
- No product or banner demo data is inserted when the API is empty. This keeps the home content API-driven.
- A successful API response with unrecognised or empty content displays an empty-state message instead of fabricated products.
- The endpoint is used as supplied. Confirm it is reachable from the target device and permits the app's network requests.

## 6. Android network permission

After creating the Android platform folder, confirm this permission is inside the root `<manifest>` element in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 7. Run the model tests

```bash
flutter test
```
