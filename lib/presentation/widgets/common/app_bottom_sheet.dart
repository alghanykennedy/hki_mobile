import 'package:flutter/material.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_radius.dart';
import 'package:hki_mobile/core/theme/app_spacing.dart';

/// Reusable helper for showing a styled modal bottom sheet.
///
/// Centralises the Container decoration, drag handle, scroll physics,
/// and keyboard-aware padding so callers only provide the [child] widget.
class AppBottomSheet {
  AppBottomSheet._();

  /// Shows a modal bottom sheet with the standard app styling.
  ///
  /// [child] – the form/content widget placed inside the scrollable area.
  /// [maxHeightFactor] – fraction of screen height (default 0.88).
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double maxHeightFactor = 0.88,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        final mediaQuery = MediaQuery.of(modalContext);
        return Container(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * maxHeightFactor,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.sheetTop,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.md),
              // Drag Handle
              Container(
                width: AppSpacing.handleWidth,
                height: AppSpacing.handleHeight,
                decoration: BoxDecoration(
                  color: AppColors.sheetHandle,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.handleHeight),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: AppSpacing.screenPadding,
                    right: AppSpacing.screenPadding,
                    top: AppSpacing.xs,
                    bottom: mediaQuery.viewInsets.bottom +
                        mediaQuery.padding.bottom +
                        AppSpacing.xl,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
