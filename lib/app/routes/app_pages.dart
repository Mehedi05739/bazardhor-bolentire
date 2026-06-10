import 'package:get/get.dart';

import '../modules/bazaar_detail/bindings/bazaar_detail_binding.dart';
import '../modules/bazaar_detail/views/bazaar_detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

/// Central route table. Each [GetPage] wires a path to its view and binding,
/// so dependencies are injected exactly when the route is opened.
class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = <GetPage>[
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.bazaarDetail,
      page: () => const BazaarDetailView(),
      binding: BazaarDetailBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
