import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class GetSessionUseCase implements UseCase<User?, NoParams> {
  final AuthRepository _repository;

  GetSessionUseCase(this._repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return _repository.getSession();
  }
}
