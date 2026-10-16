import 'dart:async';
import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../constants/api_endpoints.dart';
import '../../services/app_logger.dart';
import '../../services/token_storage.dart';

typedef OnSessionExpiredCallback = Future<void> Function();

class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final OnSessionExpiredCallback? _onSessionExpired;

  // Single completer for concurrent 401 requests
  Completer<String?>? _refreshCompleter;

  static const String requiresAuthKey = 'requiresAuth';
  static const String isRetryKey = 'isRetry';

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio,
    OnSessionExpiredCallback? onSessionExpired,
  })  : _tokenStorage = tokenStorage,
        _refreshDio = refreshDio,
        _onSessionExpired = onSessionExpired;

  bool _isPublicEndpoint(String path) {
    return path.contains(ApiEndpoints.login) ||
        path.contains(ApiEndpoints.register) ||
        path.contains(ApiEndpoints.forgotPassword) ||
        path.contains(ApiEndpoints.resetPassword) ||
        path.contains(ApiEndpoints.refreshToken) ||
        path.contains('/auth/set-new-password');
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final bool requiresAuth = options.extra[requiresAuthKey] ?? !_isPublicEndpoint(options.path);

    if (requiresAuth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final requestOptions = err.requestOptions;

    // Check if error is 401 on a protected request
    final is401 = response?.statusCode == 401;
    final isPublic = _isPublicEndpoint(requestOptions.path);
    final isAlreadyRetried = requestOptions.extra[isRetryKey] == true;

    if (!is401 || isPublic || isAlreadyRetried) {
      return handler.next(err);
    }

    // If refresh token mechanism is disabled by config, expire session immediately
    if (!AppConfig.useRefreshToken) {
      AppLogger.warning('401 received and useRefreshToken is disabled. Expiring session.');
      await _handleSessionExpired();
      return handler.next(err);
    }

    // Refresh token flow
    try {
      final newToken = await _performTokenRefresh();

      if (newToken != null && newToken.isNotEmpty) {
        // Retry original request with new token
        final retryOptions = requestOptions.copyWith(
          headers: Map<String, dynamic>.from(requestOptions.headers)
            ..['Authorization'] = 'Bearer $newToken',
          extra: Map<String, dynamic>.from(requestOptions.extra)..[isRetryKey] = true,
        );

        final retryResponse = await _refreshDio.fetch(retryOptions);
        return handler.resolve(retryResponse);
      } else {
        await _handleSessionExpired();
        return handler.next(err);
      }
    } catch (e, st) {
      AppLogger.error('Token refresh failed: $e', e, st);
      await _handleSessionExpired();
      return handler.next(err);
    }
  }

  /// Ensures that concurrent 401s share a single refresh call
  Future<String?> _performTokenRefresh() async {
    if (_refreshCompleter != null) {
      AppLogger.info('Refresh already in progress. Awaiting existing completer.');
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.warning('No refresh token available in storage.');
        _refreshCompleter!.complete(null);
        return null;
      }

      AppLogger.info('Attempting token refresh with endpoint: ${ApiEndpoints.refreshToken}');
      
      final response = await _refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
        ),
      );

      final data = response.data;
      String? newAccessToken;
      String? newRefreshToken;

      if (data is Map<String, dynamic>) {
        final payload = data['data'] is Map<String, dynamic> ? data['data'] : data;
        newAccessToken = payload['access_token'] ?? payload['accessToken'] ?? payload['token'];
        newRefreshToken = payload['refresh_token'] ?? payload['refreshToken'];
      }

      if (newAccessToken != null) {
        await _tokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken ?? refreshToken,
        );
        AppLogger.info('Token refresh succeeded.');
        _refreshCompleter!.complete(newAccessToken);
        return newAccessToken;
      } else {
        AppLogger.warning('Response did not contain valid access token');
        _refreshCompleter!.complete(null);
        return null;
      }
    } catch (e) {
      AppLogger.error('Exception during refresh token call: $e');
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<void> _handleSessionExpired() async {
    await _tokenStorage.clearTokens();
    if (_onSessionExpired != null) {
      await _onSessionExpired();
    }
  }
}
