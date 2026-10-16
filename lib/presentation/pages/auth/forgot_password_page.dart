import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/presentation/widgets/auth/auth_scaffold.dart';
import 'package:hki_mobile/presentation/widgets/auth/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      onBack: () => Get.back(),
      child: ForgotPasswordForm(
        onLoginTap: () => Get.offNamed(Routes.login),
      ),
    );
  }
}
