import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/di/initial_binding.dart';
import 'package:hki_mobile/core/routes/app_pages.dart';
import 'package:hki_mobile/core/services/connectivity_service.dart';
import 'package:hki_mobile/core/theme/app_theme.dart';
import 'package:hki_mobile/presentation/widgets/common/offline_banner.dart';

class HkiApp extends StatelessWidget {
  const HkiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      builder: (context, child) {
        return Obx(() {
          final isOnline = Get.isRegistered<ConnectivityService>()
              ? ConnectivityService.to.isOnline.value
              : true;
          return OfflineBanner(
            isOffline: !isOnline,
            child: child ?? const SizedBox.shrink(),
          );
        });
      },
    );
  }
}
