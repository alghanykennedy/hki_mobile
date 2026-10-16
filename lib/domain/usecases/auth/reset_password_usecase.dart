import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class ResetPasswordParams extends Equatable {
  final String email;
  final String? code;
  final String? token;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordParams({
    required this.email,
    this.code,
    this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, code, token, newPassword, confirmPassword];
}

class ResetPasswordUseCase implements UseCase<Unit, ResetPasswordParams> {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ResetPasswordParams params) {
    return _repository.resetPassword(
      email: params.email,
      code: params.code,
      token: params.token,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}
