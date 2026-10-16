import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/routes/app_pages.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HkiApp());
}

class HkiApp extends StatelessWidget {
  const HkiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HKI Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.counter,
      getPages: AppPages.pages,
    );
  }
}
