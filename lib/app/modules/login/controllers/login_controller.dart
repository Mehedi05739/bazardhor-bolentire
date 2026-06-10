import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/api_client.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  LoginController({required this.repository});

  final AuthRepository repository;

  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  void toggleObscure() => obscurePassword.toggle();

  String? validateIdentifier(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Enter your email or phone number';

    final isEmail = GetUtils.isEmail(input);
    final isPhone = GetUtils.isPhoneNumber(input);
    if (!isEmail && !isPhone) {
      return 'Enter a valid email or phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'Enter your password';
    if ((value ?? '').length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      isLoading.value = true;
      await repository.login(
        identifier: identifierCtrl.text.trim(),
        password: passwordCtrl.text,
      );
      Get.offAllNamed(Routes.home);
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Unable to sign in. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Login failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      colorText: Colors.black87,
    );
  }

  @override
  void onClose() {
    identifierCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
