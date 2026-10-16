import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_response_parser.dart';
import '../../../core/network/dio_client.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<({UserModel user, AuthTokensModel tokens})> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required int role,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> resetPassword({
    required String email,
    String? code,
    String? token,
    required String newPassword,
    required String confirmPassword,
  });

  Future<void> setNewPassword({
    required String userId,
    required String password,
  });

  Future<void> logout();

  Future<UserModel> getMe();

  Future<AuthTokensModel> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<({UserModel user, AuthTokensModel tokens})> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = ApiResponseParser.extractData(response.data) as Map<String, dynamic>;
    final userJson = data['user'] is Map<String, dynamic> ? data['user'] as Map<String, dynamic> : data;
    final tokensJson = data['tokens'] is Map<String, dynamic> ? data['tokens'] as Map<String, dynamic> : data;

    return (
      user: UserModel.fromJson(userJson),
      tokens: AuthTokensModel.fromJson(tokensJson),
    );
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required int role,
  }) async {
    await _dioClient.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'role': role,
      },
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _dioClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    String? code,
    String? token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _dioClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        if (code != null) 'code': code,
        if (token != null) 'token': token,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );
  }

  @override
  Future<void> setNewPassword({
    required String userId,
    required String password,
  }) async {
    await _dioClient.post(
      ApiEndpoints.setNewPassword(userId),
      data: {
        'password': password,
      },
    );
  }

  @override
  Future<void> logout() async {
    await _dioClient.post(ApiEndpoints.logout);
  }

  @override
  Future<UserModel> getMe() async {
    final response = await _dioClient.get(ApiEndpoints.me);
    final data = ApiResponseParser.extractData(response.data) as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    final response = await _dioClient.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
    );
    final data = ApiResponseParser.extractData(response.data) as Map<String, dynamic>;
    return AuthTokensModel.fromJson(data);
  }
}
