import 'package:hki_mobile/features/counter/domain/entities/counter.dart';
import 'package:hki_mobile/features/counter/domain/repositories/counter_repository.dart';

class GetCounter {
  const GetCounter(this._repository);

  final CounterRepository _repository;

  Future<Counter> call() => _repository.getCounter();
}
