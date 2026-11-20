import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/home_models.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/home_header.dart';
import 'widgets/product_section.dart';
import 'widgets/promotion_row.dart';
import 'widgets/live_stream_row.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Obx(() {
        final response = controller.homeResponse.value;
        if (response == null || response.data.bottomNav.isEmpty) {
          return const SizedBox.shrink();
        }
        return HomeBottomNavigation(items: response.data.bottomNav);
      }),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final response = controller.homeResponse.value;
          final isInitialLoading = controller.isLoading.value && response == null;
          if (isInitialLoading) return const _LoadingView();
          if (response == null && controller.errorMessage.value.isNotEmpty) {
            return _ErrorView(
              message: controller.errorMessage.value,
              onRetry: controller.fetchHome,
            );
          }
          if (response == null) {
            return _ErrorView(
              message: 'No home data is available.',
              onRetry: controller.fetchHome,
            );
          }

          final data = response.data;
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.fetchHome,
                color: AppConstants.brandBlue,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: HomeHeader(data: data)),
                    if (controller.errorMessage.value.isNotEmpty)
                      SliverToBoxAdapter(
                        child: _RefreshError(message: controller.errorMessage.value),
                      ),
                    if (data.banners.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: BannerCarousel(banners: data.banners),
                        ),
                      ),
                    if (data.adProducts.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: PromotionRow(promotions: data.adProducts),
                        ),
                      ),
                    if (data.liveStreams.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: LiveStreamRow(streams: data.liveStreams),
                        ),
                      ),
                    if (data.suggestedForYou.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: ProductSectionView(
                            section: ProductSection(
                              title: 'Suggested For You',
                              products: data.suggestedForYou,
                            ),
                          ),
                        ),
                      ),
                    if (data.banners.isEmpty &&
                        data.adProducts.isEmpty &&
                        data.suggestedForYou.isEmpty &&
                        data.liveStreams.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyHomeView(),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
              if (controller.isLoading.value && response != null)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.42,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE33455), Color(0xFFFFD6BB)],
            ),
          ),
        ),
        const Spacer(),
        const CircularProgressIndicator(),
        const SizedBox(height: 12),
        const Text('Loading your home screen…', style: TextStyle(color: AppConstants.muted)),
        const Spacer(),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 50, color: Colors.black38),
            const SizedBox(height: 14),
            const Text(
              'Unable to load the home screen',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RefreshError extends StatelessWidget {
  const _RefreshError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        'Refresh failed: $message',
        style: const TextStyle(fontSize: 12, color: Color(0xFF805000)),
      ),
    );
  }
}

class _EmptyHomeView extends StatelessWidget {
  const _EmptyHomeView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, size: 48, color: Colors.black38),
            SizedBox(height: 12),
            Text(
              'No home content found',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            SizedBox(height: 5),
            Text(
              'The API responded successfully, but did not contain any banners, ad products, suggested products or live streams.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
