import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/bazaar_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/bazaar_repository.dart';
import '../../../data/repositories/config_repository.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/update_price_dialog.dart';

/// Drives the home screen: resolves the user's zone from their location,
/// loads bazaars + featured products, handles navigation to a bazaar, the
/// inline price-edit flow, and logout.
class HomeController extends GetxController {
  HomeController({
    required this.authRepository,
    required this.configRepository,
    required this.bazaarRepository,
    required this.productRepository,
    required this.locationService,
    required this.storage,
  });

  final AuthRepository authRepository;
  final ConfigRepository configRepository;
  final BazaarRepository bazaarRepository;
  final ProductRepository productRepository;
  final LocationService locationService;
  final StorageService storage;

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final bazaars = <BazaarModel>[].obs;
  final products = <ProductModel>[].obs;

  // Zone resolution state.
  final isResolvingZone = false.obs;
  final zoneName = RxnString();
  final zoneError = RxnString();

  @override
  void onInit() {
    super.onInit();
    // Show any previously stored zone immediately, then refresh from location.
    zoneName.value = storage.zone?.name;
    initialize();
  }

  /// Resolve the zone from the current location, then load screen data once a
  /// zone id is available (so requests carry the `zoneId` header).
  Future<void> initialize() async {
    final resolved = await resolveZone();
    if (resolved) await loadData();
  }

  /// Gets the device location and calls the get-zone API, persisting the id.
  /// Returns true on success. Safe to call from a retry button.
  Future<bool> resolveZone() async {
    try {
      isResolvingZone.value = true;
      zoneError.value = null;
      final position = await locationService.getCurrentPosition();
      final zone = await configRepository.getZone(
        lat: position.latitude,
        lng: position.longitude,
      );
      zoneName.value = zone.name;
      return true;
    } on LocationException catch (e) {
      zoneError.value = e.message;
    } on ApiException catch (e) {
      zoneError.value = e.message;
    } catch (_) {
      zoneError.value = 'Could not determine your zone. Please retry.';
    } finally {
      isResolvingZone.value = false;
    }
    return false;
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

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back<bool>(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back<bool>(result: true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await authRepository.logout();
    Get.offAllNamed(Routes.login);
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
