import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/presentation/controllers/auth/reset_password_controller.dart';
import 'package:hki_mobile/presentation/widgets/auth/auth_header.dart';
import 'package:hki_mobile/presentation/widgets/common/app_button.dart';
import 'package:hki_mobile/presentation/widgets/common/app_link_text.dart';
import 'package:hki_mobile/presentation/widgets/common/app_password_field.dart';

class ResetPasswordForm extends StatelessWidget {
  final VoidCallback? onLoginTap;
  final VoidCallback? onSuccess;

  const ResetPasswordForm({
    super.key,
    this.onLoginTap,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResetPasswordController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.sm),
        const AuthHeader(
          title: AppStrings.resetPasswordTitle,
          subtitle: AppStrings.resetPasswordSubtitle,
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Password Baru
        Obx(
          () => AppPasswordField(
            label: AppStrings.newPasswordLabel,
            hint: AppStrings.newPasswordHint,
            controller: controller.newPasswordController,
            errorText: controller.newPasswordError.value,
            textInputAction: TextInputAction.next,
            enabled: !controller.isLoading.value,
            onChanged: (_) => controller.clearErrors(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Konfirmasi Password Baru
        Obx(
          () => AppPasswordField(
            label: AppStrings.confirmNewPasswordLabel,
            hint: AppStrings.confirmNewPasswordHint,
            controller: controller.confirmPasswordController,
            errorText: controller.confirmPasswordError.value,
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
