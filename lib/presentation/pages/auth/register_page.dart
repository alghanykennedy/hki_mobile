import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/presentation/widgets/auth/auth_scaffold.dart';
import 'package:hki_mobile/presentation/widgets/auth/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      onBack: () => Get.offNamed(Routes.welcome),
      child: RegisterForm(
        onLoginTap: () => Get.offNamed(Routes.login),
      ),
    );
  }
}
