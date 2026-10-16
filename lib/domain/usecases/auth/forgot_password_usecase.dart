import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordUseCase implements UseCase<Unit, ForgotPasswordParams> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(email: params.email);
  }
}
