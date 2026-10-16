import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/error/failures.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/core/utils/validators.dart';
import 'package:hki_mobile/domain/usecases/auth/login_usecase.dart';
import 'package:hki_mobile/presentation/controllers/session_controller.dart';
import 'package:hki_mobile/presentation/widgets/common/app_snackbar.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;

  LoginController({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase;

  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;

  final RxnString identifierError = RxnString();
  final RxnString passwordError = RxnString();
  final RxnString genericError = RxnString();

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void clearErrors() {
    identifierError.value = null;
    passwordError.value = null;
    genericError.value = null;
  }

  Future<void> submit() async {
    if (isLoading.value) return;

    clearErrors();

    // Client-side validation
    final idErr = Validators.validateIdentifier(identifierController.text);
    final passErr = Validators.validatePassword(passwordController.text);

    if (idErr != null || passErr != null) {
      identifierError.value = idErr;
      passwordError.value = passErr;
      return;
    }

    isLoading.value = true;

    final result = await _loginUseCase(
      LoginParams(
        email: identifierController.text.trim(),
        password: passwordController.text,
        rememberMe: rememberMe.value,
      ),
    );

    isLoading.value = false;

    result.fold(
      (failure) {
        if (failure is UnauthorizedFailure) {
          // Spec: Failed login state: red text under password field:
          // "Periksa kembali email dan kata sandimu, lalu coba lagi." (generic, do not reveal which field is wrong)
          genericError.value = AppStrings.failedLoginGeneric;
        } else if (failure is ValidationFailure) {
          genericError.value = failure.message;
        } else {
          AppSnackbar.error(failure.message);
        }
      },
      (user) {
        // Close bottom sheet if open before navigating
        final ctx = Get.context;
        if (ctx != null) {
          final navigator = Navigator.maybeOf(ctx);
          if (navigator != null && navigator.canPop()) {
            navigator.pop();
          }
        }
        SessionController.to.setUser(user);
        Get.offAllNamed(Routes.home);
      },
    );
  }

  @override
  void onClose() {
    identifierController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
