import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_radius.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';
import 'package:hki_mobile/core/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.fieldLabel,
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: maxLines == 1 ? AppSpacing.inputHeight : null,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            enabled: enabled,
            maxLines: maxLines,
            style: AppTextStyles.fieldInput,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.fieldHint,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: enabled ? AppColors.inputBackground : AppColors.background,
              border: OutlineInputBorder(
                borderRadius: AppRadius.roundedMd,
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.border,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.roundedMd,
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.border,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.roundedMd,
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.borderFocused,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: AppTextStyles.fieldError,
          ),
        ],
      ],
    );
  }
}
