import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_radius.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/core/theme/app_text_styles.dart';
import 'package:hki_mobile/presentation/controllers/session_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showLogoutDialog(BuildContext context, SessionController session) {
    Get.dialog(
      AlertDialog(
        title: Text(
          AppStrings.logoutConfirmTitle,
          style: AppTextStyles.h3,
        ),
        content: Text(
          AppStrings.logoutConfirmMessage,
          style: AppTextStyles.body,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppStrings.cancel,
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              session.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.roundedPill),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.homeTitle,
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () => _showLogoutDialog(context, session),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              // User Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.roundedLg,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              AppColors.primaryLight.withOpacity(0.15),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.welcomeUser,
                                style: AppTextStyles.bodySmall,
                              ),
                              Obx(
                                () => Text(
                                  session.userName.isNotEmpty
                                      ? session.userName
                                      : 'Pengguna HKI',
                                  style: AppTextStyles.h3,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: AppSpacing.xxl),

                    // User Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.userRoleLabel,
                            style: AppTextStyles.bodySmall),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: AppRadius.roundedPill,
                            ),
                            child: Text(
                              session.userRole?.label ?? '-',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.userEmailLabel,
                            style: AppTextStyles.bodySmall),
                        Obx(
                          () => Text(
                            session.userEmail.isNotEmpty
                                ? session.userEmail
                                : '-',
                            style: AppTextStyles.body
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.userNikLabel,
                            style: AppTextStyles.bodySmall),
                        Obx(
                          () => Text(
                            session.userNik.isNotEmpty ? session.userNik : '-',
                            style: AppTextStyles.body
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Logout Button
            ],
          ),
        ),
      ),
    );
  }
}
