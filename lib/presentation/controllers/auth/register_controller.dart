import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/error/failures.dart';
import 'package:hki_mobile/core/utils/validators.dart';
import 'package:hki_mobile/domain/usecases/auth/register_usecase.dart';
import 'package:hki_mobile/presentation/widgets/common/app_snackbar.dart';

class RegisterController extends GetxController {
  final RegisterUseCase _registerUseCase;

  RegisterController({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;

  final RxnString nameError = RxnString();
  final RxnString emailError = RxnString();

  /// Callback to invoke when registration is successful (e.g. switch to login sheet).
  VoidCallback? onRegisterSuccess;

  void clearErrors() {
    nameError.value = null;
    emailError.value = null;
  }

  Future<void> submit() async {
    if (isLoading.value) return;

    clearErrors();

    // Client-side validation
    final nErr = Validators.validateName(nameController.text);
    final eErr = Validators.validateEmail(emailController.text);

    if (nErr != null || eErr != null) {
      nameError.value = nErr;
      emailError.value = eErr;
      return;
    }

    isLoading.value = true;

    final result = await _registerUseCase(
      RegisterParams(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        role: 3, // Default role: Petugas Lapangan
      ),
    );

    isLoading.value = false;

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          // Map server field errors inline
          final errors = failure.fieldErrors;
          if (errors.containsKey('name')) {
            nameError.value = errors['name']?.first ?? AppStrings.nameAlreadyTaken;
          }
          if (errors.containsKey('email')) {
            emailError.value = errors['email']?.first ?? AppStrings.emailAlreadyTaken;
          }

          if (nameError.value == null && emailError.value == null) {
            AppSnackbar.error(failure.message);
          }
        } else {
          AppSnackbar.error(failure.message);
        }
      },
      (_) {
        AppSnackbar.success(AppStrings.registerSuccessMessage);
        if (onRegisterSuccess != null) {
          onRegisterSuccess!();
        }
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
