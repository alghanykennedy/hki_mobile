import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../services/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
      if (sanitizedHeaders.containsKey('Authorization')) {
        sanitizedHeaders['Authorization'] = 'Bearer [REDACTED]';
      }

      final dynamic data = _sanitizeData(options.data);
      AppLogger.debug('--> ${options.method} ${options.uri}\nHeaders: $sanitizedHeaders\nData: $data');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.debug('<-- ${response.statusCode} ${response.requestOptions.uri}\nData: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.error(
        '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}: ${err.message}',
        err.error,
        err.stackTrace,
      );
    }
    handler.next(err);
  }

  dynamic _sanitizeData(dynamic data) {
    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);
      for (final key in sanitized.keys) {
        final lower = key.toLowerCase();
        if (lower.contains('password') ||
            lower.contains('token') ||
            lower.contains('secret') ||
            lower.contains('credential')) {
          sanitized[key] = '[REDACTED]';
        }
      }
      return sanitized;
    }
    return data;
  }
}
