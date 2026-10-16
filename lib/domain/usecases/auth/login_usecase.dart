import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginParams({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
      rememberMe: params.rememberMe,
    );
  }
}
