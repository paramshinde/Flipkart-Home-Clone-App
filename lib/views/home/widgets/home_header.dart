import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/home_models.dart';
import '../../../widgets/network_image_view.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.data, super.key});

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final categories = data.categories;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE33455), Color(0xFFFF7A70), Color(0xFFFFD6BB)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(width * 0.035, 12, width * 0.035, 0),
        child: Column(
          children: [
            _ShortcutRow(items: data.serviceTabs),
            const SizedBox(height: 10),
            _AddressRow(location: data.deliveryAddress, supercoinBalance: data.supercoinBalance),
            const SizedBox(height: 12),
            _SearchRow(hint: data.searchHint, voiceEnabled: data.search.voiceEnabled, scanEnabled: data.search.scanEnabled),
            const SizedBox(height: 12),
            SizedBox(
              height: 74,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: width * 0.025),
                itemBuilder: (context, index) => SizedBox(
                  width: (width - width * 0.07) * 0.145,
                  child: _CategoryItem(category: categories[index], selected: categories[index].selected),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _serviceSymbol(String slug) => switch (slug) { 'flipkart' => 'f', 'minutes' => '⚡', 'travel' => '✈', 'value-365' => '₹', _ => '•' };

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({required this.items});
  final List<ServiceTab> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(width: 7),
          Expanded(child: _ShortcutTile(data: items[index])),
        ],
      ],
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({required this.data});
  final ServiceTab data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: data.selected ? AppConstants.brandYellow : Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 34,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (data.iconUrl.isNotEmpty)
                  SizedBox(
                    width: 48,
                    height: 32,
                    child: NetworkImageView(
                      imageUrl: data.iconUrl,
                      fit: BoxFit.contain,
                      fallbackIcon: Icons.shopping_bag_outlined,
                      backgroundColor: Colors.transparent,
                    ),
                  )
                else
                  Text(
                    _serviceSymbol(data.slug),
                    style: TextStyle(
                      color: data.selected ? AppConstants.brandBlue : const Color(0xFFB83C68),
                      fontSize: data.selected ? 30 : 25,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                if (data.badgeText.isNotEmpty)
                  Positioned(
                    top: -5,
                    right: -7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        data.badgeText,
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              data.name,
              style: const TextStyle(
                color: Color(0xFF454545),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.location, required this.supercoinBalance});
  final String location;
  final int supercoinBalance;

  @override
  Widget build(BuildContext context) {
    final label = location.isEmpty ? 'Deliver to your location' : location;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.42),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Color(0xFF8B5260)),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF754D57)),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF754D57)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 7),
        _SmallStatusChip(icon: Icons.bolt, color: const Color(0xFFB95BDB), label: ''),
        const SizedBox(width: 6),
        _SmallStatusChip(icon: Icons.flash_on, color: const Color(0xFFF4A52C), label: supercoinBalance.toString()),
      ],
    );
  }
}

class _SmallStatusChip extends StatelessWidget {
  const _SmallStatusChip({required this.icon, required this.color, required this.label});
  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 3),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.hint, required this.voiceEnabled, required this.scanEnabled});
  final String hint;
  final bool voiceEnabled;
  final bool scanEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF4EA5F3), width: 1.6),
            ),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.black87, size: 28),
                suffixIcon: voiceEnabled ? const Icon(Icons.mic_none, color: Colors.grey, size: 25) : null,
                hintText: hint.isEmpty ? 'Search for products, brands and more' : hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (scanEnabled)
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.qr_code_scanner, color: Color(0xFF814D57), size: 27),
          ),
      ],
    );
  }
}

Icon _categoryFallback(String slug) => Icon(
      switch (slug) {
        'for-you' => Icons.auto_awesome_outlined,
        'fashion' => Icons.checkroom_outlined,
        'mobiles' => Icons.phone_iphone_outlined,
        'electronics' => Icons.devices_other_outlined,
        'beauty' => Icons.face_retouching_natural_outlined,
        'home' => Icons.chair_outlined,
        'appliances' => Icons.kitchen_outlined,
        _ => Icons.category_outlined,
      },
      size: 25,
      color: const Color(0xFF715B54),
    );

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category, required this.selected});
  final HomeCategory category;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 34,
          child: category.iconUrl.isNotEmpty
              ? NetworkImageView(
                  imageUrl: category.iconUrl,
                  fit: BoxFit.contain,
                  fallbackIcon: Icons.category_outlined,
                  backgroundColor: Colors.transparent,
                )
              : Center(
                  child: _categoryFallback(category.slug)
                ),
        ),
        const SizedBox(height: 3),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Color(0xFF48403D)),
            ),
          ),
        ),
        if (selected)
          Container(
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppConstants.brandBlue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
