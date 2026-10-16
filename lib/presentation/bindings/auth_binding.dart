import 'package:get/get.dart';
import 'package:hki_mobile/core/config/app_config.dart';
import 'package:hki_mobile/core/network/dio_client.dart';
import 'package:hki_mobile/core/network/network_info.dart';
import 'package:hki_mobile/core/services/token_storage.dart';
import 'package:hki_mobile/data/datasources/auth/auth_local_datasource.dart';
import 'package:hki_mobile/data/datasources/auth/auth_mock_datasource.dart';
import 'package:hki_mobile/data/datasources/auth/auth_remote_datasource.dart';
import 'package:hki_mobile/data/repositories/auth_repository_impl.dart';
import 'package:hki_mobile/domain/repositories/auth_repository.dart';
import 'package:hki_mobile/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/get_session_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/login_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/logout_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/refresh_token_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/register_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/reset_password_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/set_new_password_usecase.dart';
import 'package:hki_mobile/presentation/controllers/auth/forgot_password_controller.dart';
import 'package:hki_mobile/presentation/controllers/auth/login_controller.dart';
import 'package:hki_mobile/presentation/controllers/auth/register_controller.dart';
import 'package:hki_mobile/presentation/controllers/auth/reset_password_controller.dart';
import 'package:hki_mobile/presentation/controllers/session_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    final AuthRemoteDataSource remoteDataSource = AppConfig.useMock
        ? AuthMockDataSource()
        : AuthRemoteDataSourceImpl(Get.find<DioClient>());
    Get.lazyPut<AuthRemoteDataSource>(() => remoteDataSource, fenix: true);

    final localDataSource = AuthLocalDataSourceImpl(Get.find<TokenStorage>());
    Get.lazyPut<AuthLocalDataSource>(() => localDataSource, fenix: true);

    // Repository
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: Get.find<NetworkInfo>(),
    );
    Get.lazyPut<AuthRepository>(() => authRepository, fenix: true);

    // Use Cases
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final forgotPasswordUseCase = ForgotPasswordUseCase(authRepository);
    final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
    final setNewPasswordUseCase = SetNewPasswordUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final getSessionUseCase = GetSessionUseCase(authRepository);
    final refreshTokenUseCase = RefreshTokenUseCase(authRepository);

    Get.lazyPut<LoginUseCase>(() => loginUseCase, fenix: true);
    Get.lazyPut<RegisterUseCase>(() => registerUseCase, fenix: true);
    Get.lazyPut<ForgotPasswordUseCase>(() => forgotPasswordUseCase,
        fenix: true);
    Get.lazyPut<ResetPasswordUseCase>(() => resetPasswordUseCase, fenix: true);
    Get.lazyPut<SetNewPasswordUseCase>(() => setNewPasswordUseCase, fenix: true);
    Get.lazyPut<LogoutUseCase>(() => logoutUseCase, fenix: true);
    Get.lazyPut<GetSessionUseCase>(() => getSessionUseCase, fenix: true);
    Get.lazyPut<RefreshTokenUseCase>(() => refreshTokenUseCase, fenix: true);

    // Session Controller (Permanent across app)
    if (!Get.isRegistered<SessionController>()) {
      Get.put<SessionController>(
        SessionController(
          getSessionUseCase: getSessionUseCase,
          logoutUseCase: logoutUseCase,
        ),
        permanent: true,
      );
    }

    // Feature Controllers
    Get.lazyPut<LoginController>(
      () => LoginController(loginUseCase: loginUseCase),
      fenix: true,
    );
    Get.lazyPut<RegisterController>(
      () => RegisterController(registerUseCase: registerUseCase),
      fenix: true,
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
          forgotPasswordUseCase: forgotPasswordUseCase),
      fenix: true,
    );
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(resetPasswordUseCase: resetPasswordUseCase),
      fenix: true,
    );
  }
}
