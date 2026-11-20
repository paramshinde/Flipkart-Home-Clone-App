import 'package:flutter_test/flutter_test.dart';
import 'package:flipkart_home_clone/data/models/home_models.dart';

void main() {
  test('maps the actual get_home.php response keys', () {
    final response = HomeResponse.fromJson({
      'success': true,
      'status': 'success',
      'message': 'Home screen data fetched successfully.',
      'data': {
        'delivery_address': 'SHIVSAGAR SOCIETY 716, ROOM NO 24, Sector 7, Mumbai',
        'supercoin_balance': 0,
        'search': {
          'placeholder': 'shoes',
          'voice_enabled': true,
          'scan_enabled': true,
        },
        'service_tabs': [
          {
            'id': 1,
            'name': 'Flipkart',
            'slug': 'flipkart',
            'badge_text': null,
            'is_selected': true,
            'sort_order': 1,
            'status': true,
            'icon_url': 'https://images.example.com/flipkart.jpg',
          },
          {
            'id': 2,
            'name': 'Minutes',
            'slug': 'minutes',
            'badge_text': '12',
            'is_selected': false,
            'sort_order': 2,
            'status': false,
            'icon_url': null,
          },
        ],
        'categories': [
          {
            'id': 1,
            'name': 'For You',
            'slug': 'for-you',
            'is_selected': true,
            'sort_order': 1,
            'status': true,
            'icon_url': 'https://images.example.com/for-you.jpg',
          },
          {
            'id': 2,
            'name': 'Hidden category',
            'slug': 'hidden',
            'is_selected': false,
            'sort_order': 2,
            'status': false,
            'icon_url': null,
          },
        ],
        'banners': [
          {
            'id': 1,
            'tag_text': 'Get everything in MINUTES',
            'title': "Celebrate Men's Day",
            'subtitle': null,
            'offer_text': 'Up to 80% Off',
            'brand_label': 'MINUTES',
            'terms_text': null,
            'redirect_url': 'https://example.com/offers/mens-day',
            'sort_order': 1,
            'status': true,
            'image_url': 'https://images.example.com/banner.jpg',
          },
        ],
        'ad_products': [
          {
            'id': 1,
            'brand': 'Urban Choice',
            'product_name': 'Shelf Cabinet',
            'cta_text': 'Shop now',
            'is_ad': true,
            'redirect_url': 'https://example.com/p/shelf-cabinet',
            'sort_order': 1,
            'status': true,
            'image_url': 'https://images.example.com/ad.jpg',
          },
        ],
        'suggested_for_you': [
          {
            'id': 1,
            'category_id': 1,
            'brand': 'OnePlus',
            'name': 'OnePlus True Wireless Earbuds',
            'rating': 4.400000000000000355,
            'rating_count': 18250,
            'price': 2999,
            'mrp': 5999,
            'discount_percent': 50,
            'is_suggested': true,
            'sort_order': 1,
            'status': true,
            'category_name': 'For You',
            'category_slug': 'for-you',
            'image_url': 'https://images.example.com/earbuds.jpg',
          },
        ],
        'live_streams': [
          {
            'id': 1,
            'title': 'Smart Living Hub',
            'badge_text': 'LIVE',
            'offer_text': 'Extra 15% Off',
            'is_live': true,
            'stream_url': 'https://example.com/live/smart-living-hub',
            'status': true,
            'thumbnail_url': 'https://images.example.com/live.jpg',
          },
        ],
        'bottom_nav': [
          {
            'id': 1,
            'label': 'Home',
            'slug': 'home',
            'is_selected': true,
            'sort_order': 1,
            'status': true,
            'icon_url': 'https://images.example.com/home.jpg',
          },
          {
            'id': 2,
            'label': 'Cart',
            'slug': 'cart',
            'is_selected': false,
            'sort_order': 2,
            'status': true,
            'icon_url': null,
          },
        ],
      },
    });

    final data = response.data;
    expect(response.success, isTrue);
    expect(response.status, 'success');
    expect(response.message, 'Home screen data fetched successfully.');
    expect(data.deliveryAddress, contains('Mumbai'));
    expect(data.supercoinBalance, 0);
    expect(data.search.placeholder, 'shoes');
    expect(data.search.voiceEnabled, isTrue);
    expect(data.search.scanEnabled, isTrue);

    // Inactive API rows are omitted and the remaining rows retain sort order.
    expect(data.serviceTabs, hasLength(1));
    expect(data.serviceTabs.single.name, 'Flipkart');
    expect(data.serviceTabs.single.selected, isTrue);
    expect(data.categories, hasLength(1));
    expect(data.categories.single.slug, 'for-you');

    expect(data.banners.single.title, "Celebrate Men's Day");
    expect(data.banners.single.subtitle, isEmpty);
    expect(data.banners.single.offerText, 'Up to 80% Off');
    expect(data.banners.single.brandLabel, 'MINUTES');
    expect(data.adProducts.single.brand, 'Urban Choice');
    expect(data.adProducts.single.productName, 'Shelf Cabinet');
    expect(data.adProducts.single.ctaText, 'Shop now');

    final product = data.suggestedForYou.single;
    expect(product.brand, 'OnePlus');
    expect(product.price, 2999);
    expect(product.mrp, 5999);
    expect(product.discountLabel, '50% off');
    expect(product.rating, closeTo(4.4, 0.0001));
    expect(product.ratingCount, 18250);

    expect(data.liveStreams.single.title, 'Smart Living Hub');
    expect(data.liveStreams.single.isLive, isTrue);
    expect(data.bottomNav, hasLength(2));
    expect(data.bottomNav.first.selected, isTrue);
  });

  test('handles null optional fields and missing arrays safely', () {
    final response = HomeResponse.fromJson({
      'success': true,
      'status': 'success',
      'message': 'ok',
      'data': {
        'search': {'placeholder': 'shoes'},
        'categories': [
          {
            'id': 1,
            'name': 'Appliances',
            'slug': 'appliances',
            'is_selected': false,
            'sort_order': 1,
            'status': true,
            'icon_url': null,
          },
        ],
        'banners': [
          {
            'id': 2,
            'title': 'Mivi One',
            'subtitle': null,
            'terms_text': null,
            'status': true,
            'sort_order': 2,
            'image_url': null,
          },
        ],
      },
    });

    expect(response.data.deliveryAddress, isEmpty);
    expect(response.data.categories.single.iconUrl, isEmpty);
    expect(response.data.banners.single.subtitle, isEmpty);
    expect(response.data.adProducts, isEmpty);
    expect(response.data.suggestedForYou, isEmpty);
    expect(response.data.liveStreams, isEmpty);
    expect(response.data.bottomNav, isEmpty);
  });
}
