// Basic smoke test: with no stored session, the app boots into the login screen.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bazardhor_bolentair/app/data/services/storage_service.dart';
import 'package:bazardhor_bolentair/main.dart';

void main() {
  testWidgets('App launches on the login screen when logged out',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await Get.putAsync<StorageService>(() => StorageService().init());
    addTearDown(Get.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
