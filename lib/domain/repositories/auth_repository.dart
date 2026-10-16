import 'package:fpdart/fpdart.dart';

import '../../core/error/failures.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required int role,
  });

  Future<Either<Failure, Unit>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    String? code,
    String? token,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<Failure, Unit>> setNewPassword({
    required String userId,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, User?>> getSession();

  Future<Either<Failure, AuthTokens>> refreshToken();
}
