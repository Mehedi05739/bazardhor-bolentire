import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/storage_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage before the app starts so the session is
  // known synchronously (token for API calls + startup routing decision).
  await Get.putAsync<StorageService>(() => StorageService().init(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();

    return GetMaterialApp(
      title: 'Bazardhor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      // Skip login if a valid session is already stored.
      initialRoute: storage.isLoggedIn ? Routes.home : Routes.login,
      getPages: AppPages.routes,
    );
  }
}
