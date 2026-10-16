import 'package:dio/dio.dart';

import '../../error/error_mapper.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = ErrorMapper.fromDioException(err);
    final mappedDioException = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appException,
      message: appException.message,
    );
    handler.next(mappedDioException);
  }
}
