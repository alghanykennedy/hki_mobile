import 'package:get/get.dart';
import 'package:hki_mobile/features/counter/data/repositories/in_memory_counter_repository.dart';
import 'package:hki_mobile/features/counter/domain/repositories/counter_repository.dart';
import 'package:hki_mobile/features/counter/domain/usecases/get_counter.dart';
import 'package:hki_mobile/features/counter/domain/usecases/increment_counter.dart';
import 'package:hki_mobile/features/counter/presentation/controllers/counter_controller.dart';

class CounterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounterRepository>(InMemoryCounterRepository.new);
    Get.lazyPut(() => GetCounter(Get.find<CounterRepository>()));
    Get.lazyPut(() => IncrementCounter(Get.find<CounterRepository>()));
    Get.lazyPut(
      () => CounterController(
        getCounter: Get.find<GetCounter>(),
        incrementCounter: Get.find<IncrementCounter>(),
      ),
    );
  }
}
