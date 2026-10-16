import 'package:flutter_test/flutter_test.dart';
import 'package:hki_mobile/features/counter/data/repositories/in_memory_counter_repository.dart';
import 'package:hki_mobile/features/counter/domain/usecases/increment_counter.dart';

void main() {
  group('IncrementCounter', () {
    test('increments and returns the updated counter', () async {
      final repository = InMemoryCounterRepository();
      final useCase = IncrementCounter(repository);

      final result = await useCase();

      expect(result.value, 1);
      expect((await repository.getCounter()).value, 1);
    });
  });
}
