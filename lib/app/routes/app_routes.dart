part of 'app_pages.dart';

/// Route name constants. Reference these instead of raw strings when
/// navigating, e.g. `Get.toNamed(Routes.home)`.
abstract class Routes {
  Routes._();

  static const login = _Paths.login;
  static const home = _Paths.home;
  static const bazaarDetail = _Paths.bazaarDetail;
}

abstract class _Paths {
  _Paths._();

  static const login = '/login';
  static const home = '/home';
  static const bazaarDetail = '/bazaar-detail';
}
