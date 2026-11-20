import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/home_models.dart';
import '../../../widgets/network_image_view.dart';

class HomeBottomNavigation extends GetView<HomeController> {
  const HomeBottomNavigation({required this.items, super.key});

  final List<HomeNavItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 15,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Obx(
          () => Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = controller.selectedNavIndex.value == index;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () => controller.selectNavigation(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFE7EAF1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 25,
                          width: 26,
                          child: item.iconUrl.isNotEmpty
                              ? NetworkImageView(
                                  imageUrl: item.iconUrl,
                                  fit: BoxFit.contain,
                                  fallbackIcon: _iconFor(item.slug),
                                  backgroundColor: Colors.transparent,
                                )
                              : Icon(
                                  _iconFor(item.slug),
                                  size: 25,
                                  color: selected
                                      ? AppConstants.brandBlue
                                      : Colors.black87,
                                ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                            color: selected ? AppConstants.brandBlue : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String slug) => switch (slug) {
        'home' => Icons.home_rounded,
        'play' => Icons.play_circle_outline_rounded,
        'categories' => Icons.grid_view_rounded,
        'account' => Icons.person_outline_rounded,
        'cart' => Icons.shopping_cart_outlined,
        _ => Icons.circle_outlined,
      };
}
