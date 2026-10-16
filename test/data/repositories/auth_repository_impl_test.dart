import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hki_mobile/core/error/exceptions.dart';
import 'package:hki_mobile/core/error/failures.dart';
import 'package:hki_mobile/core/network/network_info.dart';
import 'package:hki_mobile/data/datasources/auth/auth_local_datasource.dart';
import 'package:hki_mobile/data/datasources/auth/auth_remote_datasource.dart';
import 'package:hki_mobile/data/models/auth_tokens_model.dart';
import 'package:hki_mobile/data/models/user_model.dart';
import 'package:hki_mobile/data/repositories/auth_repository_impl.dart';
import 'package:hki_mobile/domain/entities/user_role.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;
  late AuthRepositoryImpl repository;

  const testUser = UserModel(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    nik: '1234567890123456',
    role: UserRole.admin,
  );

  const testTokens = AuthTokensModel(
    accessToken: 'access',
    refreshToken: 'refresh',
  );

  setUpAll(() {
    registerFallbackValue(testUser);
    registerFallbackValue(testTokens);
  });

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('AuthRepositoryImpl - login', () {
    test('successful login saves tokens and user, returns Right(User)', () async {
      when(() => mockRemote.login(
            email: 'test@example.com',
            password: 'password',
          )).thenAnswer((_) async => (user: testUser, tokens: testTokens));

      when(() => mockLocal.saveTokens(any())).thenAnswer((_) async {});
      when(() => mockLocal.setRememberMe(any())).thenAnswer((_) async {});
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async {});

      final result = await repository.login(
        email: 'test@example.com',
        password: 'password',
        rememberMe: true,
      );

      expect(result, Right(testUser.toEntity()));
      verify(() => mockLocal.saveTokens(testTokens)).called(1);
      verify(() => mockLocal.setRememberMe(true)).called(1);
      verify(() => mockLocal.saveUser(testUser)).called(1);
    });

    test('failed login maps UnauthorizedException to UnauthorizedFailure', () async {
      when(() => mockRemote.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const UnauthorizedException());

      final result = await repository.login(
        email: 'wrong',
        password: 'wrong',
        rememberMe: false,
      );

      expect(result, isA<Left<Failure, dynamic>>());
      result.fold(
        (failure) => expect(failure, isA<UnauthorizedFailure>()),
        (_) => fail('Should have returned a failure'),
      );
    });
  });

  group('AuthRepositoryImpl - logout', () {
    test('clears local session even if remote logout throws', () async {
      when(() => mockRemote.logout()).thenThrow(const ServerException());
      when(() => mockLocal.clearSession()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result, const Right(unit));
      verify(() => mockLocal.clearSession()).called(1);
    });
  });
}
