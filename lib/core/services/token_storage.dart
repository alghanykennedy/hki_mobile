import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: StorageKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  Future<void> saveUserData(String jsonString) async {
    await _storage.write(key: StorageKeys.userData, value: jsonString);
  }

  Future<String?> getUserData() async {
    return _storage.read(key: StorageKeys.userData);
  }

  Future<void> clearUserData() async {
    await _storage.delete(key: StorageKeys.userData);
  }

  /// Remember-me flag:
  /// When true, session data and refresh token are retained across app restarts.
  /// When false, session data should be cleared on app start/close.
  Future<void> saveRememberMe(bool remember) async {
    await _storage.write(key: StorageKeys.rememberMe, value: remember ? 'true' : 'false');
  }

  Future<bool> getRememberMe() async {
    final value = await _storage.read(key: StorageKeys.rememberMe);
    return value == 'true';
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
