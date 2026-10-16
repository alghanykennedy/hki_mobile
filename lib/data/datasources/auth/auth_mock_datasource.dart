import 'dart:math';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/user_role.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthMockDataSource implements AuthRemoteDataSource {
  final Random _random = Random();

  Future<void> _simulateDelay() async {
    final delayMs = AppConstants.mockDelayMinMs +
        _random.nextInt(AppConstants.mockDelayMaxMs - AppConstants.mockDelayMinMs + 1);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  // Pre-configured mock users for the 3 roles
  final List<UserModel> _mockUsers = const [
    UserModel(
      id: 'usr_admin_001',
      name: 'Ahmad Admin',
      email: 'admin@test.com',
      nik: '1111222233334444',
      role: UserRole.admin,
    ),
    UserModel(
      id: 'usr_pengawas_002',
      name: 'Bambang Pengawas',
      email: 'pengawas@test.com',
      nik: '2222333344445555',
      role: UserRole.pengawas,
    ),
    UserModel(
      id: 'usr_petugas_003',
      name: 'Candra Petugas',
      email: 'petugas@test.com',
      nik: '3333444455556666',
      role: UserRole.petugasLapangan,
    ),
  ];

  @override
  Future<({UserModel user, AuthTokensModel tokens})> login({
    required String email,
    required String password,
  }) async {
    await _simulateDelay();

    // Check credentials (password must be Test1234)
    if (password != 'Test1234') {
      throw const UnauthorizedException(
        message: AppStrings.failedLoginGeneric,
        statusCode: 401,
      );
    }

    final trimmedId = email.trim().toLowerCase();
    final user = _mockUsers.firstWhere(
      (u) => u.email.toLowerCase() == trimmedId || u.nik == trimmedId,
      orElse: () => throw const UnauthorizedException(
        message: AppStrings.failedLoginGeneric,
        statusCode: 401,
      ),
    );

    final tokens = AuthTokensModel(
      accessToken: 'mock_jwt_access_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_jwt_refresh_token_${user.id}',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    return (user: user, tokens: tokens);
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required int role,
  }) async {
    await _simulateDelay();

    final Map<String, List<String>> errors = {};

    // Simulate already-taken errors per Figma spec
    if (email.toLowerCase() == 'used@test.com' ||
        email.toLowerCase() == 'admin@test.com' ||
        email.toLowerCase().contains('used')) {
      errors['email'] = [AppStrings.emailAlreadyTaken];
    }

    if (errors.isNotEmpty) {
      throw ValidationException(
        message: 'Data yang dimasukkan tidak valid',
        statusCode: 422,
        fieldErrors: errors,
      );
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _simulateDelay();

    if (email.toLowerCase() == 'notfound@test.com') {
      throw const NotFoundException(message: 'Email tidak terdaftar dalam sistem.');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    String? code,
    String? token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _simulateDelay();

    if (newPassword != confirmPassword) {
      throw const ValidationException(
        message: AppStrings.passwordMismatch,
        fieldErrors: {
          'password_confirmation': [AppStrings.passwordMismatch],
        },
      );
    }
  }

  @override
  Future<void> setNewPassword({
    required String userId,
    required String password,
  }) async {
    await _simulateDelay();
  }

  @override
  Future<void> logout() async {
    await _simulateDelay();
  }

  @override
  Future<UserModel> getMe() async {
    await _simulateDelay();
    return _mockUsers.first;
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    await _simulateDelay();
    return AuthTokensModel(
      accessToken: 'refreshed_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }
}
