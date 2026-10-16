import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/constants/asset_paths.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/core/theme/app_text_styles.dart';
import 'package:hki_mobile/presentation/controllers/auth/register_controller.dart';
import 'package:hki_mobile/presentation/widgets/auth/forgot_password_form.dart';
import 'package:hki_mobile/presentation/widgets/auth/login_form.dart';
import 'package:hki_mobile/presentation/widgets/auth/register_form.dart';
import 'package:hki_mobile/presentation/widgets/auth/reset_password_form.dart';
import 'package:hki_mobile/presentation/widgets/common/app_bottom_sheet.dart';
import 'package:hki_mobile/presentation/widgets/common/app_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // ──────────────────────────────────────────────────────
  // Bottom-sheet navigation helpers (all use AppBottomSheet.show)
  // ──────────────────────────────────────────────────────

  void _showLoginSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      child: LoginForm(
        onRegisterTap: () {
          Navigator.pop(context);
          _showRegisterSheet(context);
        },
        onForgotPasswordTap: () {
          Navigator.pop(context);
          _showForgotPasswordSheet(context);
        },
      ),
    );
  }

  void _showRegisterSheet(BuildContext context) {
    // Set success callback so after register we switch to login sheet
    final registerCtrl = Get.find<RegisterController>();
    registerCtrl.onRegisterSuccess = () {
      Navigator.pop(context);
      _showLoginSheet(context);
    };

    AppBottomSheet.show(
      context: context,
      child: RegisterForm(
        onLoginTap: () {
          Navigator.pop(context);
          _showLoginSheet(context);
        },
      ),
    );
  }

  void _showForgotPasswordSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      child: ForgotPasswordForm(
        onLoginTap: () {
          Navigator.pop(context);
          _showLoginSheet(context);
        },
        onSuccess: (email) {
          Navigator.pop(context);
          _showResetPasswordSheet(context);
        },
      ),
    );
  }

  void _showResetPasswordSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      child: ResetPasswordForm(
        onLoginTap: () {
          Navigator.pop(context);
          _showLoginSheet(context);
        },
        onSuccess: () {
          Navigator.pop(context);
          _showLoginSheet(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed Hero Background
          Image.asset(
            AssetPaths.authHero,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primaryLight, AppColors.primaryDark],
                ),
              ),
            ),
          ),

          // Gradient overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryDark.withOpacity(0.35),
                  AppColors.primaryDark.withOpacity(0.65),
                  AppColors.primaryDark.withOpacity(0.95),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 3),

                  // Center Logo
                  Center(
                    child: Image.asset(
                      AssetPaths.hkiLogo,
                      height: 80,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.apartment_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Headline & Tagline
                  Center(
                    child: Text(
                      AppStrings.welcomeHeadline,
                      style: AppTextStyles.welcomeHeadline,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      AppStrings.welcomeTagline,
                      style: AppTextStyles.welcomeTagline,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Action Buttons opening Modal Bottom Sheets
                  AppButton(
                    text: AppStrings.welcomeLoginBtn,
                    variant: AppButtonVariant.onDarkPrimary,
                    onPressed: () => _showLoginSheet(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    text: AppStrings.welcomeRegisterBtn,
                    variant: AppButtonVariant.onDarkOutlined,
                    onPressed: () => _showRegisterSheet(context),
                  ),

                  SizedBox(
                    height: mediaQuery.padding.bottom > 0
                        ? AppSpacing.sm
                        : AppSpacing.lg,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
