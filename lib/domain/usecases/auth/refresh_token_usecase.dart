import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../entities/auth_tokens.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class RefreshTokenUseCase implements UseCase<AuthTokens, NoParams> {
  final AuthRepository _repository;

  RefreshTokenUseCase(this._repository);

  @override
  Future<Either<Failure, AuthTokens>> call(NoParams params) {
    return _repository.refreshToken();
  }
}
