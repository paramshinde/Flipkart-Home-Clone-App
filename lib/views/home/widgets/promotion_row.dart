import 'package:flutter/material.dart';

import '../../../data/models/home_models.dart';
import '../../../widgets/network_image_view.dart';

class PromotionRow extends StatelessWidget {
  const PromotionRow({required this.promotions, super.key});

  final List<HomeAdProduct> promotions;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final tileWidth = width * (width > 720 ? 0.22 : 0.30);
    final imageHeight = tileWidth * 0.92;

    return SizedBox(
      height: imageHeight + 76,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: promotions.length,
        separatorBuilder: (_, __) => SizedBox(width: width * 0.045),
        itemBuilder: (context, index) {
          final item = promotions[index];
          return SizedBox(
            width: tileWidth,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: imageHeight,
                    width: tileWidth,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        NetworkImageView(
                          imageUrl: item.imageUrl,
                          fallbackIcon: Icons.local_offer_outlined,
                        ),
                        if (item.isAd)
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'Ad',
                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                if (item.brand.isNotEmpty)
                  Text(
                    item.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                Text(
                  item.ctaText.isEmpty ? 'Shop now' : item.ctaText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2874F0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
