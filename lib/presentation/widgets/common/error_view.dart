import 'package:flutter/material.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/core/theme/app_text_styles.dart';

import 'app_button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryText;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText = AppStrings.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 56,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: 160,
                child: AppButton(
                  text: retryText,
                  onPressed: onRetry,
                  variant: AppButtonVariant.primary,
                  height: 44,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
