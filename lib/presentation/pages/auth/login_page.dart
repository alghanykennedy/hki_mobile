import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/presentation/widgets/auth/auth_scaffold.dart';
import 'package:hki_mobile/presentation/widgets/auth/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      onBack: () => Get.offNamed(Routes.welcome),
      child: LoginForm(
        onRegisterTap: () => Get.offNamed(Routes.register),
        onForgotPasswordTap: () => Get.toNamed(Routes.forgotPassword),
      ),
    );
  }
}
