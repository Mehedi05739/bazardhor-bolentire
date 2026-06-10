import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/bazaar_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../widgets/update_price_dialog.dart';

/// Shows the products of a single bazaar (passed via route arguments) and
/// handles the price-edit flow for them.
class BazaarDetailController extends GetxController {
  BazaarDetailController({required this.productRepository});

  final ProductRepository productRepository;

  late final BazaarModel bazaar;

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    bazaar = Get.arguments as BazaarModel;
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      products.value =
          await productRepository.fetchProductsByBazaar(bazaar.id);
    } catch (_) {
      errorMessage.value = 'Could not load products. Pull to retry.';
    } finally {
      isLoading.value = false;
    }
  }

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
