import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_text_styles.dart';

class AppLinkText extends StatelessWidget {
  final String prefixText;
  final String actionText;
  final VoidCallback onTap;
  final TextStyle? prefixStyle;
  final TextStyle? actionStyle;

  const AppLinkText({
    super.key,
    required this.prefixText,
    required this.actionText,
    required this.onTap,
    this.prefixStyle,
    this.actionStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: '$prefixText ',
          style: prefixStyle ??
              AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
          children: [
            TextSpan(
              text: actionText,
              style: actionStyle ??
                  AppTextStyles.link.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
