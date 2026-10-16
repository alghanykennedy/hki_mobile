import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final int role;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, role];
}

class RegisterUseCase implements UseCase<Unit, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      role: params.role,
    );
  }
}
