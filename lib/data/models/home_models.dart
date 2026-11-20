/// Models for the exact response returned by get_home.php.
///
/// The API uses snake_case keys. Nullable values are normalized to empty
/// strings so views can safely render optional labels and image URLs.
Map<String, dynamic> asStringMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return <String, dynamic>{};
}

String readText(dynamic value) => value == null ? '' : value.toString();

bool readBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    return const {'1', 'true', 'yes', 'active', 'success'}
        .contains(value.toLowerCase());
  }
  return fallback;
}

int readInt(dynamic value, {int fallback = 0}) {
  if (value is num) return value.toInt();
  return int.tryParse(readText(value)) ?? fallback;
}

double readDouble(dynamic value, {double fallback = 0}) {
  if (value is num) return value.toDouble();
  return double.tryParse(readText(value)) ?? fallback;
}

List<Map<String, dynamic>> readMapList(dynamic value) {
  if (value is! List) return <Map<String, dynamic>>[];
  return value.whereType<Map>().map(asStringMap).toList();
}

List<T> _activeSorted<T>(
  dynamic value,
  T Function(Map<String, dynamic>) fromJson,
  bool Function(T) isActive,
  int Function(T) sortOrder,
) {
  final items = readMapList(value).map(fromJson).where(isActive).toList();
  items.sort((a, b) => sortOrder(a).compareTo(sortOrder(b)));
  return items;
}

class HomeResponse {
  const HomeResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  final bool success;
  final String status;
  final String message;
  final HomeData data;

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
        success: readBool(json['success']),
        status: readText(json['status']),
        message: readText(json['message']),
        data: HomeData.fromJson(asStringMap(json['data'])),
      );
}

class HomeData {
  const HomeData({
    required this.deliveryAddress,
    required this.supercoinBalance,
    required this.search,
    required this.serviceTabs,
    required this.categories,
    required this.banners,
    required this.adProducts,
    required this.suggestedForYou,
    required this.liveStreams,
    required this.bottomNav,
  });

  final String deliveryAddress;
  final int supercoinBalance;
  final HomeSearch search;
  final List<ServiceTab> serviceTabs;
  final List<HomeCategory> categories;
  final List<HomeBanner> banners;
  final List<HomeAdProduct> adProducts;
  final List<HomeProduct> suggestedForYou;
  final List<HomeLiveStream> liveStreams;
  final List<HomeNavItem> bottomNav;

  String get searchHint => search.placeholder;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        deliveryAddress: readText(json['delivery_address']),
        supercoinBalance: readInt(json['supercoin_balance']),
        search: HomeSearch.fromJson(asStringMap(json['search'])),
        serviceTabs: _activeSorted(
          json['service_tabs'],
          ServiceTab.fromJson,
          (item) => item.status,
          (item) => item.sortOrder,
        ),
        categories: _activeSorted(
          json['categories'],
          HomeCategory.fromJson,
          (item) => item.status,
          (item) => item.sortOrder,
        ),
        banners: _activeSorted(
          json['banners'],
          HomeBanner.fromJson,
          (item) => item.status,
          (item) => item.sortOrder,
        ),
        adProducts: _activeSorted(
          json['ad_products'],
          HomeAdProduct.fromJson,
          (item) => item.status,
          (item) => item.sortOrder,
        ),
        suggestedForYou: _activeSorted(
          json['suggested_for_you'],
          HomeProduct.fromJson,
          (item) => item.status,
          (item) => item.sortOrder,
        ),
        liveStreams: _activeSorted(
          json['live_streams'],
          HomeLiveStream.fromJson,
          (item) => item.status,
          (item) => readInt(item.id),
        ),
        bottomNav: _activeSorted(
          json['bottom_nav'],
          HomeNavItem.fromJson,
          (item) => item.status,
          (item) => item.sortOrder,
        ),
      );
}

class HomeSearch {
  const HomeSearch({
    required this.placeholder,
    required this.voiceEnabled,
    required this.scanEnabled,
  });

  final String placeholder;
  final bool voiceEnabled;
  final bool scanEnabled;

  factory HomeSearch.fromJson(Map<String, dynamic> json) => HomeSearch(
        placeholder: readText(json['placeholder']),
        voiceEnabled: readBool(json['voice_enabled']),
        scanEnabled: readBool(json['scan_enabled']),
      );
}

class ServiceTab {
  const ServiceTab({
    required this.id,
    required this.name,
    required this.slug,
    required this.badgeText,
    required this.selected,
    required this.sortOrder,
    required this.status,
    required this.iconUrl,
  });

  final String id;
  final String name;
  final String slug;
  final String badgeText;
  final bool selected;
  final int sortOrder;
  final bool status;
  final String iconUrl;

  factory ServiceTab.fromJson(Map<String, dynamic> json) => ServiceTab(
        id: readText(json['id']),
        name: readText(json['name']),
        slug: readText(json['slug']),
        badgeText: readText(json['badge_text']),
        selected: readBool(json['is_selected']),
        sortOrder: readInt(json['sort_order']),
        status: readBool(json['status']),
        iconUrl: readText(json['icon_url']),
      );
}

class HomeCategory {
  const HomeCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.selected,
    required this.sortOrder,
    required this.status,
    required this.iconUrl,
  });

  final String id;
  final String name;
  final String slug;
  final bool selected;
  final int sortOrder;
  final bool status;
  final String iconUrl;

  factory HomeCategory.fromJson(Map<String, dynamic> json) => HomeCategory(
        id: readText(json['id']),
        name: readText(json['name']),
        slug: readText(json['slug']),
        selected: readBool(json['is_selected']),
        sortOrder: readInt(json['sort_order']),
        status: readBool(json['status']),
        iconUrl: readText(json['icon_url']),
      );
}

class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.tagText,
    required this.title,
    required this.subtitle,
    required this.offerText,
    required this.brandLabel,
    required this.termsText,
    required this.redirectUrl,
    required this.sortOrder,
    required this.status,
    required this.imageUrl,
  });

  final String id;
  final String tagText;
  final String title;
  final String subtitle;
  final String offerText;
  final String brandLabel;
  final String termsText;
  final String redirectUrl;
  final int sortOrder;
  final bool status;
  final String imageUrl;

  factory HomeBanner.fromJson(Map<String, dynamic> json) => HomeBanner(
        id: readText(json['id']),
        tagText: readText(json['tag_text']),
        title: readText(json['title']),
        subtitle: readText(json['subtitle']),
        offerText: readText(json['offer_text']),
        brandLabel: readText(json['brand_label']),
        termsText: readText(json['terms_text']),
        redirectUrl: readText(json['redirect_url']),
        sortOrder: readInt(json['sort_order']),
        status: readBool(json['status']),
        imageUrl: readText(json['image_url']),
      );
}

class HomeAdProduct {
  const HomeAdProduct({
    required this.id,
    required this.brand,
    required this.productName,
    required this.ctaText,
    required this.isAd,
    required this.redirectUrl,
    required this.sortOrder,
    required this.status,
    required this.imageUrl,
  });

  final String id;
  final String brand;
  final String productName;
  final String ctaText;
  final bool isAd;
  final String redirectUrl;
  final int sortOrder;
  final bool status;
  final String imageUrl;

  factory HomeAdProduct.fromJson(Map<String, dynamic> json) => HomeAdProduct(
        id: readText(json['id']),
        brand: readText(json['brand']),
        productName: readText(json['product_name']),
        ctaText: readText(json['cta_text']),
        isAd: readBool(json['is_ad']),
        redirectUrl: readText(json['redirect_url']),
        sortOrder: readInt(json['sort_order']),
        status: readBool(json['status']),
        imageUrl: readText(json['image_url']),
      );
}

class ProductSection {
  const ProductSection({required this.title, required this.products});

  final String title;
  final List<HomeProduct> products;
}

class HomeProduct {
  const HomeProduct({
    required this.id,
    required this.categoryId,
    required this.brand,
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.price,
    required this.mrp,
    required this.discountPercent,
    required this.suggested,
    required this.sortOrder,
    required this.status,
    required this.categoryName,
    required this.categorySlug,
    required this.imageUrl,
  });

  final String id;
  final String categoryId;
  final String brand;
  final String name;
  final double rating;
  final int ratingCount;
  final num price;
  final num mrp;
  final int discountPercent;
  final bool suggested;
  final int sortOrder;
  final bool status;
  final String categoryName;
  final String categorySlug;
  final String imageUrl;

  String get discountLabel => discountPercent > 0 ? '$discountPercent% off' : '';

  factory HomeProduct.fromJson(Map<String, dynamic> json) => HomeProduct(
        id: readText(json['id']),
        categoryId: readText(json['category_id']),
        brand: readText(json['brand']),
        name: readText(json['name']),
        rating: readDouble(json['rating']),
        ratingCount: readInt(json['rating_count']),
        price: json['price'] is num ? json['price'] as num : readInt(json['price']),
        mrp: json['mrp'] is num ? json['mrp'] as num : readInt(json['mrp']),
        discountPercent: readInt(json['discount_percent']),
        suggested: readBool(json['is_suggested']),
        sortOrder: readInt(json['sort_order']),
        status: readBool(json['status']),
        categoryName: readText(json['category_name']),
        categorySlug: readText(json['category_slug']),
        imageUrl: readText(json['image_url']),
      );
}

class HomeLiveStream {
  const HomeLiveStream({
    required this.id,
    required this.title,
    required this.badgeText,
    required this.offerText,
    required this.isLive,
    required this.streamUrl,
    required this.status,
    required this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String badgeText;
  final String offerText;
  final bool isLive;
  final String streamUrl;
  final bool status;
  final String thumbnailUrl;

  factory HomeLiveStream.fromJson(Map<String, dynamic> json) => HomeLiveStream(
        id: readText(json['id']),
        title: readText(json['title']),
        badgeText: readText(json['badge_text']),
        offerText: readText(json['offer_text']),
        isLive: readBool(json['is_live']),
        streamUrl: readText(json['stream_url']),
        status: readBool(json['status']),
        thumbnailUrl: readText(json['thumbnail_url']),
      );
}

class HomeNavItem {
  const HomeNavItem({
    required this.id,
    required this.label,
    required this.slug,
    required this.selected,
    required this.sortOrder,
    required this.status,
    required this.iconUrl,
  });

  final String id;
  final String label;
  final String slug;
  final bool selected;
  final int sortOrder;
  final bool status;
  final String iconUrl;

  factory HomeNavItem.fromJson(Map<String, dynamic> json) => HomeNavItem(
        id: readText(json['id']),
        label: readText(json['label']),
        slug: readText(json['slug']),
        selected: readBool(json['is_selected']),
        sortOrder: readInt(json['sort_order']),
        status: readBool(json['status']),
        iconUrl: readText(json['icon_url']),
      );
}
