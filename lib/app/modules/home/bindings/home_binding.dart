import 'package:get/get.dart';

import '../../../data/repositories/bazaar_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        bazaarRepository: Get.find<BazaarRepository>(),
        productRepository: Get.find<ProductRepository>(),
      ),
    );
  }
}
