import 'package:get/get.dart';

import '../data/providers/api_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/bazaar_repository.dart';
import '../data/repositories/config_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/services/location_service.dart';
import '../data/services/storage_service.dart';

/// App-wide dependencies that live for the entire session.
///
/// [StorageService] is initialized earlier in `main()`; here the [ApiClient] is
/// given providers that read the stored bearer token and zone id, so every
/// request automatically carries both headers.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final storage = Get.find<StorageService>();

    Get.put<ApiClient>(
      ApiClient(
        baseUrl: 'https://bazardor.mainul.tech',
        tokenProvider: () => storage.token,
        zoneIdProvider: () => storage.zoneId,
      ),
      permanent: true,
    );

    Get.put<LocationService>(LocationService(), permanent: true);

    Get.put<AuthRepository>(
      AuthRepository(apiClient: Get.find<ApiClient>(), storage: storage),
      permanent: true,
    );
    Get.put<ConfigRepository>(
      ConfigRepository(apiClient: Get.find<ApiClient>(), storage: storage),
      permanent: true,
    );
    Get.put<BazaarRepository>(
      BazaarRepository(apiClient: Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put<ProductRepository>(
      ProductRepository(apiClient: Get.find<ApiClient>()),
      permanent: true,
    );
  }
}
