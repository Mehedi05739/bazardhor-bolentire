import 'package:get/get.dart';

import '../data/providers/api_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/bazaar_repository.dart';
import '../data/repositories/product_repository.dart';

/// App-wide dependencies that live for the entire session.
///
/// Wired into `GetMaterialApp.initialBinding`, so the [ApiClient] and all
/// repositories are available to any controller via `Get.find<...>()`.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(
      ApiClient(baseUrl: 'https://jsonplaceholder.typicode.com'),
      permanent: true,
    );

    Get.put<AuthRepository>(
      AuthRepository(apiClient: Get.find<ApiClient>()),
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
