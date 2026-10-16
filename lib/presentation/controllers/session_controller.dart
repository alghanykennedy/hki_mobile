import 'package:get/get.dart';
import 'package:hki_mobile/core/routes/app_routes.dart';
import 'package:hki_mobile/core/routes/auth_middleware.dart';
import 'package:hki_mobile/domain/entities/user.dart';
import 'package:hki_mobile/domain/entities/user_role.dart';
import 'package:hki_mobile/domain/usecases/auth/get_session_usecase.dart';
import 'package:hki_mobile/domain/usecases/auth/logout_usecase.dart';
import 'package:hki_mobile/domain/usecases/usecase.dart';
import 'package:hki_mobile/presentation/widgets/common/app_snackbar.dart';

class SessionController extends GetxController implements AuthStatusProvider {
  static SessionController get to => Get.find();

  final GetSessionUseCase _getSessionUseCase;
  final LogoutUseCase _logoutUseCase;

  SessionController({
    required GetSessionUseCase getSessionUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getSessionUseCase = getSessionUseCase,
        _logoutUseCase = logoutUseCase;

  final Rxn<User> _currentUser = Rxn<User>();
  User? get currentUser => _currentUser.value;

  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  bool get isAuthenticated => _isLoggedIn.value;

  UserRole? get userRole => _currentUser.value?.role;
  String get userName => _currentUser.value?.name ?? '';
  String get userEmail => _currentUser.value?.email ?? '';
  String get userNik => _currentUser.value?.nik ?? '';

  final RxBool isCheckingSession = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkSession();
  }

  Future<bool> checkSession() async {
    isCheckingSession.value = true;
    final result = await _getSessionUseCase(const NoParams());
    isCheckingSession.value = false;

    return result.fold(
      (failure) {
        _currentUser.value = null;
        _isLoggedIn.value = false;
        return false;
      },
      (user) {
        if (user != null) {
          _currentUser.value = user;
          _isLoggedIn.value = true;
          return true;
        } else {
          _currentUser.value = null;
          _isLoggedIn.value = false;
          return false;
        }
      },
    );
  }

  void setUser(User user) {
    _currentUser.value = user;
    _isLoggedIn.value = true;
  }

  Future<void> logout() async {
    await _logoutUseCase(const NoParams());
    _currentUser.value = null;
    _isLoggedIn.value = false;

    Get.offAllNamed(Routes.welcome);
    AppSnackbar.info('Anda telah keluar dari aplikasi.');
  }

  void resetSession() {
    _currentUser.value = null;
    _isLoggedIn.value = false;
  }
}
