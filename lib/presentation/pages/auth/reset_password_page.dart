import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/presentation/widgets/auth/auth_scaffold.dart';
import 'package:hki_mobile/presentation/widgets/auth/reset_password_form.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      onBack: () => Get.back(),
      child: ResetPasswordForm(
        onLoginTap: () => Get.offNamed(Routes.login),
      ),
    );
  }
}
