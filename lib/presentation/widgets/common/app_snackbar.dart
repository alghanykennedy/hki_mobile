import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/core/theme/app_radius.dart';
import 'package:hki_mobile/core/theme/app_text_styles.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String title = 'Berhasil'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.successBackground,
      colorText: AppColors.success,
      icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
      borderRadius: AppRadius.md,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      titleText: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.success,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  static void error(String message, {String title = 'Terjadi Kesalahan'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.errorBackground,
      colorText: AppColors.error,
      icon: const Icon(Icons.error_outline, color: AppColors.error),
      borderRadius: AppRadius.md,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      titleText: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.error,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  static void info(String message, {String title = 'Informasi'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      icon: const Icon(Icons.info_outline, color: AppColors.info),
      borderRadius: AppRadius.md,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      titleText: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.info,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
