import 'package:flutter/material.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_radius.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/core/theme/app_text_styles.dart';

enum AppButtonVariant {
  primary,
  outlined,
  onDarkPrimary,
  onDarkOutlined,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonVariant variant;
  final double height;
  final Widget? prefixIcon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.primary,
    this.height = AppSpacing.buttonHeight,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = isEnabled ? AppColors.primary : AppColors.disabled;
        foregroundColor = isEnabled ? Colors.white : AppColors.disabledText;
        break;
      case AppButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = isEnabled ? AppColors.primary : AppColors.disabledText;
        borderSide = BorderSide(
          color: isEnabled ? AppColors.primary : AppColors.disabled,
          width: 1.5,
        );
        break;
      case AppButtonVariant.onDarkPrimary:
        backgroundColor = isEnabled ? Colors.white : AppColors.disabled;
        foregroundColor = isEnabled ? AppColors.primary : AppColors.disabledText;
        break;
      case AppButtonVariant.onDarkOutlined:
        backgroundColor = Colors.transparent;
        foregroundColor = isEnabled ? Colors.white : AppColors.disabledText;
        borderSide = BorderSide(
          color: isEnabled ? Colors.white : AppColors.disabled,
          width: 1.5,
        );
        break;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.roundedPill,
        side: borderSide,
      ),
    );

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null && !isLoading) ...[
          prefixIcon!,
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          text,
          style: AppTextStyles.buttonPrimary.copyWith(
            color: foregroundColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    if (isLoading) {
      content = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: content,
      ),
    );
  }
}
