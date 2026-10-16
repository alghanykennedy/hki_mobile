import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hki_mobile/core/constants/api_endpoints.dart';
import 'package:hki_mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:hki_mobile/core/services/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}
class MockRefreshDio extends Mock implements Dio {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late MockTokenStorage mockTokenStorage;
  late MockRefreshDio mockRefreshDio;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
    registerFallbackValue(Response<dynamic>(requestOptions: RequestOptions(path: '/')));
    registerFallbackValue(DioException(requestOptions: RequestOptions(path: '/')));
  });

  setUp(() {
    mockTokenStorage = MockTokenStorage();
    mockRefreshDio = MockRefreshDio();
    interceptor = AuthInterceptor(
      tokenStorage: mockTokenStorage,
      refreshDio: mockRefreshDio,
    );
  });

  test('parallel 401 errors trigger only ONE refresh call and retry both requests', () async {
    when(() => mockTokenStorage.getRefreshToken())
        .thenAnswer((_) async => 'old_refresh_token');
    when(() => mockTokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        )).thenAnswer((_) async {});

    int refreshCallCount = 0;
    when(() => mockRefreshDio.post(
          ApiEndpoints.refreshToken,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async {
      refreshCallCount++;
      // Artificial delay to simulate network latency
      await Future.delayed(const Duration(milliseconds: 50));
      return Response(
        requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
        statusCode: 200,
        data: {
          'data': {
            'access_token': 'new_access_token',
            'refresh_token': 'new_refresh_token',
          }
        },
      );
    });

    when(() => mockRefreshDio.fetch(any())).thenAnswer((invocation) async {
      final reqOptions = invocation.positionalArguments[0] as RequestOptions;
      return Response(
        requestOptions: reqOptions,
        statusCode: 200,
        data: {'success': true},
      );
    });

    final handler1 = MockErrorInterceptorHandler();
    final handler2 = MockErrorInterceptorHandler();

    final err1 = DioException(
      requestOptions: RequestOptions(path: '/api/v1/profile'),
      response: Response(
        requestOptions: RequestOptions(path: '/api/v1/profile'),
        statusCode: 401,
      ),
    );

    final err2 = DioException(
      requestOptions: RequestOptions(path: '/api/v1/reports'),
      response: Response(
        requestOptions: RequestOptions(path: '/api/v1/reports'),
        statusCode: 401,
      ),
    );

    // Trigger both 401s in parallel
    await Future.wait([
      interceptor.onError(err1, handler1),
      interceptor.onError(err2, handler2),
    ]);

    // Verify only ONE refresh call was performed
    expect(refreshCallCount, 1);
    verify(() => mockRefreshDio.post(
          ApiEndpoints.refreshToken,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);

    // Verify both handlers resolved retried requests
    verify(() => handler1.resolve(any())).called(1);
    verify(() => handler2.resolve(any())).called(1);
  });
}
