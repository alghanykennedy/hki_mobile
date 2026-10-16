import 'package:fpdart/fpdart.dart';

import '../../core/error/error_mapper.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_local_datasource.dart';
import '../datasources/auth/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save tokens
      await _localDataSource.saveTokens(result.tokens);
      await _localDataSource.setRememberMe(rememberMe);

      // Save user profile
      await _localDataSource.saveUser(result.user);

      return Right(result.user.toEntity());
    } catch (e) {
      return Left(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required int role,
  }) async {
    try {
      await _remoteDataSource.register(
        name: name,
        email: email,
        role: role,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    String? code,
    String? token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        code: code,
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> setNewPassword({
    required String userId,
    required String password,
  }) async {
    try {
      await _remoteDataSource.setNewPassword(
        userId: userId,
        password: password,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // Best-effort remote logout
      await _remoteDataSource.logout();
    } catch (_) {
      // Spec: Always clears local session even if the API call fails
    } finally {
      await _localDataSource.clearSession();
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, User?>> getSession() async {
    try {
      final rememberMe = await _localDataSource.getRememberMe();
      if (!rememberMe) {
        // Spec: When unchecked, session is not persisted across app restarts
        await _localDataSource.clearSession();
        return const Right(null);
      }

      final tokens = await _localDataSource.getTokens();
      if (tokens == null) {
        return const Right(null);
      }

      // Read local cached user
      final cachedUser = await _localDataSource.getUser();

      // If connected, attempt to refresh profile via getMe
      final isOnline = await _networkInfo.isConnected;
      if (isOnline) {
        try {
          final liveUser = await _remoteDataSource.getMe();
          await _localDataSource.saveUser(liveUser);
          return Right(liveUser.toEntity());
        } catch (_) {
          // If profile call fails (e.g. temporary server glitch), fall back to cached user
          if (cachedUser != null) {
            return Right(cachedUser.toEntity());
          }
        }
      }

      return Right(cachedUser?.toEntity());
    } catch (e) {
      return Left(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    try {
      final tokens = await _localDataSource.getTokens();
      if (tokens == null || tokens.refreshToken.isEmpty) {
        return const Left(UnauthorizedFailure());
      }

      final newTokens = await _remoteDataSource.refreshToken(tokens.refreshToken);
      await _localDataSource.saveTokens(newTokens);

      return Right(newTokens.toEntity());
    } catch (e) {
      return Left(ErrorMapper.toFailure(e));
    }
  }
}
