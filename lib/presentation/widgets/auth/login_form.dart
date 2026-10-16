import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/core/theme/app_text_styles.dart';
import 'package:hki_mobile/presentation/controllers/auth/login_controller.dart';
import 'package:hki_mobile/presentation/widgets/auth/auth_header.dart';
import 'package:hki_mobile/presentation/widgets/common/app_button.dart';
import 'package:hki_mobile/presentation/widgets/common/app_checkbox_tile.dart';
import 'package:hki_mobile/presentation/widgets/common/app_link_text.dart';
import 'package:hki_mobile/presentation/widgets/common/app_password_field.dart';
import 'package:hki_mobile/presentation/widgets/common/app_text_field.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback? onRegisterTap;
  final VoidCallback? onForgotPasswordTap;

  const LoginForm({
    super.key,
    this.onRegisterTap,
    this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.sm),
        const AuthHeader(
          title: AppStrings.loginTitle,
          subtitle: AppStrings.loginSubtitle,
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Identifier (Email / NIK) Field
        Obx(
          () => AppTextField(
            label: AppStrings.emailOrNikLabel,
            hint: AppStrings.emailOrNikHint,
            controller: controller.identifierController,
            errorText: controller.identifierError.value,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !controller.isLoading.value,
            onChanged: (_) => controller.clearErrors(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Password Field
        Obx(
          () => AppPasswordField(
            label: AppStrings.passwordLabel,
            hint: AppStrings.passwordHint,
            controller: controller.passwordController,
            errorText: controller.genericError.value ?? controller.passwordError.value,
            textInputAction: TextInputAction.done,
            enabled: !controller.isLoading.value,
            onChanged: (_) => controller.clearErrors(),
            onSubmitted: (_) => controller.submit(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Row: Ingat Saya (left) & Lupa Password (right)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => AppCheckboxTile(
                value: controller.rememberMe.value,
                onChanged: controller.isLoading.value
                    ? (_) {}
                    : controller.toggleRememberMe,
                label: AppStrings.rememberMe,
              ),
            ),
            if (onForgotPasswordTap != null)
              InkWell(
                onTap: onForgotPasswordTap,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    AppStrings.forgotPasswordLink,
                    style: AppTextStyles.linkUnderlined,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Login Button
        Obx(
          () => AppButton(
            text: AppStrings.loginButton,
            isLoading: controller.isLoading.value,
            onPressed: controller.submit,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Footer Link: Belum punya akun? Daftar
        if (onRegisterTap != null)
          AppLinkText(
            prefixText: AppStrings.noAccountPrompt,
            actionText: AppStrings.registerLink,
            onTap: onRegisterTap!,
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
