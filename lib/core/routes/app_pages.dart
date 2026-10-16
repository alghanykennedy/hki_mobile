import 'package:get/get.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/features/counter/presentation/bindings/counter_binding.dart';
import 'package:hki_mobile/features/counter/presentation/pages/counter_page.dart';

abstract final class AppPages {
  static final pages = <GetPage<void>>[
    GetPage<void>(
      name: AppRoutes.counter,
      page: () => const CounterPage(),
      binding: CounterBinding(),
    ),
  ];
}
