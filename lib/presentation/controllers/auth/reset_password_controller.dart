import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/core/utils/validators.dart';
import 'package:hki_mobile/domain/usecases/auth/reset_password_usecase.dart';
import 'package:hki_mobile/presentation/widgets/common/app_snackbar.dart';

class ResetPasswordController extends GetxController {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordController({required ResetPasswordUseCase resetPasswordUseCase})
      : _resetPasswordUseCase = resetPasswordUseCase;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  final RxnString newPasswordError = RxnString();
  final RxnString confirmPasswordError = RxnString();

  String email = '';
  String? code;
  String? token;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      email = args['email']?.toString() ?? '';
      code = args['code']?.toString();
      token = args['token']?.toString();
    }
  }

  void clearErrors() {
    newPasswordError.value = null;
    confirmPasswordError.value = null;
  }

  Future<void> submit({VoidCallback? onSuccess}) async {
    if (isLoading.value) return;

    clearErrors();

    final pErr = Validators.validatePassword(newPasswordController.text);
    final cpErr = Validators.validateConfirmPassword(
      newPasswordController.text,
      confirmPasswordController.text,
    );

    if (pErr != null || cpErr != null) {
      newPasswordError.value = pErr;
      confirmPasswordError.value = cpErr;
      return;
    }

    isLoading.value = true;

    final result = await _resetPasswordUseCase(
      ResetPasswordParams(
        email: email,
        code: code,
        token: token,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      ),
    );

    isLoading.value = false;

    result.fold(
      (failure) {
        AppSnackbar.error(failure.message);
      },
      (_) {
        AppSnackbar.success(AppStrings.resetPasswordSuccessMessage);
        if (onSuccess != null) {
          onSuccess();
        } else {
          Get.offAllNamed(Routes.login);
        }
      },
    );
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
