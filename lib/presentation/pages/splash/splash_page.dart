import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/asset_paths.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/core/theme/app_colors.dart';
import 'package:hki_mobile/presentation/controllers/session_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _handleRouting();
  }

  Future<void> _handleRouting() async {
    // Artificial minimum delay for brand perception
    await Future.delayed(const Duration(milliseconds: 1200));

    final sessionController = Get.find<SessionController>();
    final hasSession = await sessionController.checkSession();

    if (hasSession) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetPaths.hkiLogo,
              height: 72,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.apartment_rounded,
                size: 72,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
