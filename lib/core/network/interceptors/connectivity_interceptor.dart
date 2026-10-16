import 'package:dio/dio.dart';

import '../../error/exceptions.dart';
import '../network_info.dart';

class ConnectivityInterceptor extends Interceptor {
  final NetworkInfo _networkInfo;

  ConnectivityInterceptor(this._networkInfo);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const NoInternetException(),
        ),
      );
    }
    return handler.next(options);
  }
}
