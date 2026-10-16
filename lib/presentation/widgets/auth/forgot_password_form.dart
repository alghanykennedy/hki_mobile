import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/presentation/controllers/auth/forgot_password_controller.dart';
import 'package:hki_mobile/presentation/widgets/auth/auth_header.dart';
import 'package:hki_mobile/presentation/widgets/common/app_button.dart';
import 'package:hki_mobile/presentation/widgets/common/app_link_text.dart';
import 'package:hki_mobile/presentation/widgets/common/app_text_field.dart';

class ForgotPasswordForm extends StatelessWidget {
  final VoidCallback? onLoginTap;
  final void Function(String email)? onSuccess;

  const ForgotPasswordForm({
    super.key,
    this.onLoginTap,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.xxxl),
        const AuthHeader(
          title: AppStrings.forgotPasswordTitle,
          subtitle: AppStrings.forgotPasswordSubtitle,
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Email Field
        Obx(
          () => AppTextField(
            label: AppStrings.emailLabel,
            hint: AppStrings.emailHint,
            controller: controller.emailController,
            errorText: controller.emailError.value,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !controller.isLoading.value,
            onChanged: (_) => controller.clearErrors(),
            onSubmitted: (_) => controller.submit(onSuccess: onSuccess),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Lanjutkan Button
        Obx(
          () => AppButton(
            text: AppStrings.continueButton,
            isLoading: controller.isLoading.value,
            onPressed: () => controller.submit(onSuccess: onSuccess),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Footer Link: Atau sudah punya akun? Masuk
        if (onLoginTap != null)
          AppLinkText(
            prefixText: AppStrings.orHaveAccountPrompt,
            actionText: AppStrings.loginLink,
            onTap: onLoginTap!,
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
