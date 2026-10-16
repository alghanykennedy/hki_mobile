import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/presentation/controllers/auth/register_controller.dart';
import 'package:hki_mobile/presentation/widgets/auth/auth_header.dart';
import 'package:hki_mobile/presentation/widgets/common/app_button.dart';
import 'package:hki_mobile/presentation/widgets/common/app_link_text.dart';
import 'package:hki_mobile/presentation/widgets/common/app_text_field.dart';

class RegisterForm extends StatelessWidget {
  final VoidCallback? onLoginTap;

  const RegisterForm({
    super.key,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.sm),
        const AuthHeader(
          title: AppStrings.registerTitle,
          subtitle: AppStrings.registerSubtitle,
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Nama Lengkap
        Obx(
          () => AppTextField(
            label: AppStrings.fullNameLabel,
            hint: AppStrings.fullNameHint,
            controller: controller.nameController,
            errorText: controller.nameError.value,
            textInputAction: TextInputAction.next,
            enabled: !controller.isLoading.value,
            onChanged: (_) => controller.nameError.value = null,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Email
        Obx(
          () => AppTextField(
            label: AppStrings.emailLabel,
            hint: AppStrings.emailHint,
            controller: controller.emailController,
            errorText: controller.emailError.value,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !controller.isLoading.value,
            onChanged: (_) => controller.emailError.value = null,
            onSubmitted: (_) => controller.submit(),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Register Button
        Obx(
          () => AppButton(
            text: AppStrings.registerButton,
            isLoading: controller.isLoading.value,
            onPressed: controller.submit,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Footer Link: Sudah punya akun? Masuk
        if (onLoginTap != null)
          AppLinkText(
            prefixText: AppStrings.haveAccountPrompt,
            actionText: AppStrings.loginLink,
            onTap: onLoginTap!,
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
