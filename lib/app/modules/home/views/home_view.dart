import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/bazaar_card.dart';
import '../../../widgets/product_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final hasData = controller.bazaars.isNotEmpty;
          if ((controller.isResolvingZone.value || controller.isLoading.value) &&
              !hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          // Zone must be resolved before data can load; show its error first.
          if (controller.zoneError.value != null && !hasData) {
            return _ErrorState(
              message: controller.zoneError.value!,
              onRetry: controller.initialize,
            );
          }
          if (controller.errorMessage.value != null && !hasData) {
            return _ErrorState(
              message: controller.errorMessage.value!,
              onRetry: controller.loadData,
            );
          }
          return RefreshIndicator(
            onRefresh: controller.initialize,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(controller: controller),
                ),
                _SectionHeader(title: 'Bazaars near you'),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.bazaars.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final bazaar = controller.bazaars[index];
                        return BazaarCard(
                          bazaar: bazaar,
                          onTap: () => controller.openBazaar(bazaar),
                        );
                      },
                    ),
                  ),
                ),
                _SectionHeader(title: 'Featured products'),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = controller.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () => controller.editProductPrice(product),
                        );
                      },
                      childCount: controller.products.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LocationLine(controller: controller),
                const SizedBox(height: 2),
                Text(
                  'Bazardhor',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _IconBox(icon: Icons.logout_rounded, onTap: controller.logout),
        ],
      ),
    );
  }
}

/// Shows the resolved zone next to a pin icon, reflecting the live resolution
/// state (locating / resolved / failed-with-retry).
class _LocationLine extends StatelessWidget {
  const _LocationLine({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final resolving = controller.isResolvingZone.value;
      final name = controller.zoneName.value;
      final hasError = controller.zoneError.value != null;

      late final String label;
      if (resolving && name == null) {
        label = 'Locating you…';
      } else if (name != null) {
        label = name;
      } else if (hasError) {
        label = 'Zone unavailable · Retry';
      } else {
        label = 'Set your location';
      }

      return InkWell(
        onTap: hasError ? controller.initialize : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasError ? Icons.location_off_outlined : Icons.location_on,
              size: 15,
              color: hasError ? AppColors.error : AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: hasError ? AppColors.error : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (resolving && name == null) ...[
              const SizedBox(width: 6),
              const SizedBox(
                height: 11,
                width: 11,
                child: CircularProgressIndicator(strokeWidth: 1.6),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon),
        ),
      ),
    );
  }
}

/// Sliver section title with consistent padding.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(160, 48),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
