import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/bazaar_repository.dart';
import '../../../data/repositories/config_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/storage_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        authRepository: Get.find<AuthRepository>(),
        configRepository: Get.find<ConfigRepository>(),
        bazaarRepository: Get.find<BazaarRepository>(),
        productRepository: Get.find<ProductRepository>(),
        locationService: Get.find<LocationService>(),
        storage: Get.find<StorageService>(),
      ),
    );
  }
}
