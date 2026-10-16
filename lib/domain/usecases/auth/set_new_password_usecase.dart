import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class SetNewPasswordParams extends Equatable {
  final String userId;
  final String password;

  const SetNewPasswordParams({
    required this.userId,
    required this.password,
  });

  @override
  List<Object?> get props => [userId, password];
}

class SetNewPasswordUseCase implements UseCase<Unit, SetNewPasswordParams> {
  final AuthRepository _repository;

  SetNewPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SetNewPasswordParams params) {
    return _repository.setNewPassword(
      userId: params.userId,
      password: params.password,
    );
  }
}
