import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class LogoutUseCase implements UseCase<Unit, NoParams> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.logout();
  }
}
