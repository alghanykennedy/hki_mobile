import 'package:get/get.dart';
import 'package:hki_mobile/features/counter/domain/usecases/get_counter.dart';
import 'package:hki_mobile/features/counter/domain/usecases/increment_counter.dart';

class CounterController extends GetxController {
  CounterController({
    required GetCounter getCounter,
    required IncrementCounter incrementCounter,
  })  : _getCounter = getCounter,
        _incrementCounter = incrementCounter;

  final GetCounter _getCounter;
  final IncrementCounter _incrementCounter;
  final count = 0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCounter();
  }

  Future<void> loadCounter() async {
    isLoading.value = true;
    try {
      count.value = (await _getCounter()).value;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> increment() async {
    count.value = (await _incrementCounter()).value;
  }
}
