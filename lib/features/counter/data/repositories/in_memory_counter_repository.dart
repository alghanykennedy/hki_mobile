import 'package:hki_mobile/features/counter/domain/entities/counter.dart';
import 'package:hki_mobile/features/counter/domain/repositories/counter_repository.dart';

class InMemoryCounterRepository implements CounterRepository {
  Counter _counter = const Counter(0);

  @override
  Future<Counter> getCounter() async => _counter;

  @override
  Future<Counter> increment() async {
    _counter = _counter.increment();
    return _counter;
  }
}
