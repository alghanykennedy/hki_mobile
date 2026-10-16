import 'package:flutter/material.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';

import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  const AppPasswordField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      errorText: widget.errorText,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      keyboardType: TextInputType.visiblePassword,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: _toggleObscure,
        splashRadius: 20,
      ),
    );
  }
}
