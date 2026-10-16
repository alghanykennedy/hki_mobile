import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/error/failures.dart';
import 'package:hki_mobile/domain/entities/user.dart';
import 'package:hki_mobile/domain/entities/user_role.dart';
import 'package:hki_mobile/domain/usecases/auth/get_session_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/login_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/logout_usecase.dart';
import 'package:hki_mobile/domain/usecases/usecase.dart';
import 'package:hki_mobile/presentation/controllers/auth/login_controller.dart';
import 'package:hki_mobile/presentation/controllers/session_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockGetSessionUseCase extends Mock implements GetSessionUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockGetSessionUseCase mockGetSessionUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late LoginController controller;

  const testUser = User(
    id: 'usr_1',
    name: 'Admin',
    email: 'admin@test.com',
    nik: '1111222233334444',
    role: UserRole.admin,
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const LoginParams(
      email: 'test@example.com',
      password: 'password',
      rememberMe: false,
    ));
  });

  setUp(() {
    Get.reset();
    Get.testMode = true;
    mockLoginUseCase = MockLoginUseCase();
    mockGetSessionUseCase = MockGetSessionUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    when(() => mockGetSessionUseCase(any())).thenAnswer((_) async => const Right(null));

    Get.put(SessionController(
      getSessionUseCase: mockGetSessionUseCase,
      logoutUseCase: mockLogoutUseCase,
    ));

    controller = LoginController(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    Get.reset();
  });

  group('LoginController', () {
    test('validation prevents submit when fields are empty', () async {
      await controller.submit();

      expect(controller.identifierError.value, isNotNull);
      expect(controller.passwordError.value, isNotNull);
      verifyNever(() => mockLoginUseCase(any()));
    });

    test('shows exact generic error message on UnauthorizedFailure', () async {
      controller.identifierController.text = 'admin@test.com';
      controller.passwordController.text = 'WrongPassword';

      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Left(UnauthorizedFailure()));

      await controller.submit();

      expect(controller.genericError.value, AppStrings.failedLoginGeneric);
    });

    test('successful login sets session user and clears loading', () async {
      controller.identifierController.text = 'admin@test.com';
      controller.passwordController.text = 'Test1234';

      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Right(testUser));

      await controller.submit();

      expect(controller.isLoading.value, false);
      expect(SessionController.to.currentUser, testUser);
      expect(SessionController.to.isLoggedIn, true);
    });
  });
}
