import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

abstract class AuthStatusProvider {
  bool get isAuthenticated;
}

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (Get.isRegistered<AuthStatusProvider>()) {
      final authProvider = Get.find<AuthStatusProvider>();
      if (!authProvider.isAuthenticated) {
        return const RouteSettings(name: Routes.login);
      }
    }
    return null;
  }
}
