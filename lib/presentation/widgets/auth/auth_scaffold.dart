import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/asset_paths.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_radius.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBack;
  final double screenRatio;

  const AuthScaffold({
    super.key,
    required this.child,
    this.showBackButton = true,
    this.onBack,
    this.screenRatio = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final heroHeight = screenHeight * screenRatio;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Top Hero Area (~32% height)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: Container(
              color: AppColors.primaryDark,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AssetPaths.authHero,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primaryLight,
                              AppColors.primaryDark
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    color: AppColors.primaryDark.withOpacity(0.4),
                  ),
                  if (showBackButton)
                    Positioned(
                      top: mediaQuery.padding.top + AppSpacing.sm,
                      left: AppSpacing.md,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: onBack ?? () => Get.back(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.25),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom White Sheet
          Positioned.fill(
            top: heroHeight - 20, // slight overlap for clean curved junction
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.sheetTop,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),
                  // Sheet Drag Handle
                  Container(
                    width: AppSpacing.handleWidth,
                    height: AppSpacing.handleHeight,
                    decoration: BoxDecoration(
                      color: AppColors.sheetHandle,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.handleHeight),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: AppSpacing.screenPadding,
                        right: AppSpacing.screenPadding,
                        top: AppSpacing.xs,
                        bottom: mediaQuery.padding.bottom + AppSpacing.xl,
                      ),
                      child: child,
                    ),
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
