import 'package:flutter_test/flutter_test.dart';
import 'package:hki_mobile/features/counter/data/repositories/in_memory_counter_repository.dart';
import 'package:hki_mobile/features/counter/domain/usecases/get_counter.dart';
import 'package:hki_mobile/features/counter/domain/usecases/increment_counter.dart';
import 'package:hki_mobile/features/counter/presentation/controllers/counter_controller.dart';

void main() {
  group('CounterController', () {
    late InMemoryCounterRepository repository;
    late CounterController controller;

    setUp(() {
      repository = InMemoryCounterRepository();
      controller = CounterController(
        getCounter: GetCounter(repository),
        incrementCounter: IncrementCounter(repository),
      );
    });

    test('loads the initial counter value', () async {
      await controller.loadCounter();

      expect(controller.count.value, 0);
      expect(controller.isLoading.value, isFalse);
    });

    test('updates its state after incrementing', () async {
      await controller.loadCounter();
      await controller.increment();

      expect(controller.count.value, 1);
    });
  });
}
