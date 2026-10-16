import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/utils/validators.dart';
import 'package:hki_mobile/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:hki_mobile/presentation/widgets/common/app_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordController(
      {required ForgotPasswordUseCase forgotPasswordUseCase})
      : _forgotPasswordUseCase = forgotPasswordUseCase;

  final emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxnString emailError = RxnString();

  void clearErrors() {
    emailError.value = null;
  }

  Future<void> submit({void Function(String email)? onSuccess}) async {
    if (isLoading.value) return;

    clearErrors();

    final err = Validators.validateEmail(emailController.text);
    if (err != null) {
      emailError.value = err;
      return;
    }

    isLoading.value = true;

    final email = emailController.text.trim();
    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: email),
    );

    isLoading.value = false;

    result.fold(
      (failure) {
        AppSnackbar.error(failure.message);
      },
      (_) {
        AppSnackbar.success(AppStrings.forgotPasswordSuccessMessage);
        if (onSuccess != null) {
          onSuccess(email);
        }
      },
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
