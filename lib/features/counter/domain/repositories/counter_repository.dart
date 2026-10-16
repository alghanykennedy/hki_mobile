import 'package:hki_mobile/features/counter/domain/entities/counter.dart';

abstract interface class CounterRepository {
  Future<Counter> getCounter();

  Future<Counter> increment();
}
