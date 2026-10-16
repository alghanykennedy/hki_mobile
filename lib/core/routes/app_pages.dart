import 'package:get/get.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/core/routes/auth_middleware.dart';
import 'package:hki_mobile/presentation/bindings/auth_binding.dart';
import 'package:hki_mobile/presentation/pages/auth/forgot_password_page.dart';
import 'package:hki_mobile/presentation/pages/auth/login_page.dart';
import 'package:hki_mobile/presentation/pages/auth/register_page.dart';
import 'package:hki_mobile/presentation/pages/auth/reset_password_page.dart';
import 'package:hki_mobile/presentation/pages/auth/welcome_page.dart';
import 'package:hki_mobile/presentation/pages/home/home_page.dart';
import 'package:hki_mobile/presentation/pages/splash/splash_page.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
  ];
}
