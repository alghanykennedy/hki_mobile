import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../services/token_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_info.dart';

class DioClient {
  late final Dio dio;
  late final Dio refreshDio;

  DioClient({
    required NetworkInfo networkInfo,
    required TokenStorage tokenStorage,
    OnSessionExpiredCallback? onSessionExpired,
    Dio? customDio,
    Dio? customRefreshDio,
  }) {
    final baseOptions = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'id-ID,id;q=0.9,en;q=0.8',
      },
    );

    // Refresh Dio: separate instance with no auth interceptor to avoid refresh loops
    refreshDio = customRefreshDio ?? Dio(baseOptions);

    dio = customDio ?? Dio(baseOptions);

    // Interceptor order: Connectivity -> Auth -> Logging -> Error
    dio.interceptors.addAll([
      ConnectivityInterceptor(networkInfo),
      AuthInterceptor(
        tokenStorage: tokenStorage,
        refreshDio: refreshDio,
        onSessionExpired: onSessionExpired,
      ),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  // Typed HTTP helpers
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // Multipart file upload helper
  Future<Response<T>> upload<T>(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final uploadOptions = (options ?? Options()).copyWith(
      headers: {
        ...?options?.headers,
        'Content-Type': 'multipart/form-data',
      },
    );

    return dio.post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: uploadOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
