import '../../../core/services/token_storage.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getTokens();
  Future<void> clearTokens();

  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();

  Future<void> setRememberMe(bool remember);
  Future<bool> getRememberMe();

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenStorage _tokenStorage;

  AuthLocalDataSourceImpl(this._tokenStorage);

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    await _tokenStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
  }

  @override
  Future<AuthTokensModel?> getTokens() async {
    final accessToken = await _tokenStorage.getAccessToken();
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (accessToken == null || refreshToken == null) {
      return null;
    }
    return AuthTokensModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> clearTokens() async {
    await _tokenStorage.clearTokens();
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _tokenStorage.saveUserData(user.toJsonString());
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await _tokenStorage.getUserData();
    if (userJson == null || userJson.isEmpty) {
      return null;
    }
    try {
      return UserModel.fromJsonString(userJson);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _tokenStorage.clearUserData();
  }

  @override
  Future<void> setRememberMe(bool remember) async {
    await _tokenStorage.saveRememberMe(remember);
  }

  @override
  Future<bool> getRememberMe() async {
    return _tokenStorage.getRememberMe();
  }

  @override
  Future<void> clearSession() async {
    await _tokenStorage.clearAll();
  }
}
