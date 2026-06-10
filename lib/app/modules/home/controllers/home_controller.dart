import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/bazaar_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/bazaar_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/update_price_dialog.dart';

/// Drives the home screen: loads bazaars + featured products, handles
/// navigation to a bazaar, and the inline price-edit flow.
class HomeController extends GetxController {
  HomeController({
    required this.bazaarRepository,
    required this.productRepository,
  });

  final BazaarRepository bazaarRepository;
  final ProductRepository productRepository;

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final bazaars = <BazaarModel>[].obs;
  final products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final results = await Future.wait([
        bazaarRepository.fetchBazaars(),
        productRepository.fetchProducts(),
      ]);
      bazaars.value = results[0] as List<BazaarModel>;
      products.value = results[1] as List<ProductModel>;
    } catch (_) {
      errorMessage.value = 'Could not load data. Pull to retry.';
    } finally {
      isLoading.value = false;
    }
  }

  void openBazaar(BazaarModel bazaar) {
    Get.toNamed(Routes.bazaarDetail, arguments: bazaar);
  }

  /// Opens the price dialog and, on save, persists + reflects the new price.
  Future<void> editProductPrice(ProductModel product) async {
    final newPrice = await UpdatePriceDialog.show(product);
    if (newPrice == null || newPrice == product.price) return;

    final updated = await productRepository.updatePrice(
      product: product,
      newPrice: newPrice,
    );

    final index = products.indexWhere((p) => p.id == updated.id);
    if (index != -1) products[index] = updated;

    Get.snackbar(
      'Price updated',
      '${updated.name} is now ৳${updated.price.toStringAsFixed(0)} per ${updated.unit}',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
