import 'package:get/get.dart';

import '../../../data/repositories/product_repository.dart';
import '../controllers/bazaar_detail_controller.dart';

class BazaarDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BazaarDetailController>(
      () => BazaarDetailController(
        productRepository: Get.find<ProductRepository>(),
      ),
    );
  }
}
