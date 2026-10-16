import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/error/error_mapper.dart';
import 'package:hki_mobile/core/error/exceptions.dart';
import 'package:hki_mobile/core/error/failures.dart';

void main() {
  group('ErrorMapper - fromDioException', () {
    test('maps connection timeout to TimeoutException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = ErrorMapper.fromDioException(dioException);
      expect(result, isA<TimeoutException>());
    });

    test('maps connectionError to NoInternetException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final result = ErrorMapper.fromDioException(dioException);
      expect(result, isA<NoInternetException>());
    });

    test('maps 401 to UnauthorizedException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'message': 'Unauthenticated.'},
        ),
      );

      final result = ErrorMapper.fromDioException(dioException);
      expect(result, isA<UnauthorizedException>());
      expect((result as UnauthorizedException).statusCode, 401);
    });

    test('maps 422 with field errors to ValidationException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'message': 'The given data was invalid.',
            'errors': {
              'email': ['Email sudah dipakai'],
              'nik': ['NIK sudah dipakai'],
            },
          },
        ),
      );

      final result = ErrorMapper.fromDioException(dioException);
      expect(result, isA<ValidationException>());
      final valEx = result as ValidationException;
      expect(valEx.statusCode, 422);
      expect(valEx.fieldErrors['email'], ['Email sudah dipakai']);
      expect(valEx.fieldErrors['nik'], ['NIK sudah dipakai']);
    });

    test('maps 500 to ServerException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      final result = ErrorMapper.fromDioException(dioException);
      expect(result, isA<ServerException>());
      expect((result as ServerException).statusCode, 500);
    });
  });

  group('ErrorMapper - toFailure', () {
    test('maps NoInternetException to NetworkFailure with user-friendly Indonesian message', () {
      final failure = ErrorMapper.toFailure(const NoInternetException());
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, AppStrings.offlineMessage);
    });

    test('maps TimeoutException to TimeoutFailure', () {
      final failure = ErrorMapper.toFailure(const TimeoutException());
      expect(failure, isA<TimeoutFailure>());
      expect(failure.message, AppStrings.timeoutMessage);
    });

    test('maps ValidationException to ValidationFailure preserving fieldErrors', () {
      const exception = ValidationException(
        message: 'Validasi gagal',
        fieldErrors: {'email': ['Email tidak valid']},
      );
      final failure = ErrorMapper.toFailure(exception);
      expect(failure, isA<ValidationFailure>());
      final valFailure = failure as ValidationFailure;
      expect(valFailure.fieldErrors['email'], ['Email tidak valid']);
    });

    test('maps ServerException to ServerFailure', () {
      final failure = ErrorMapper.toFailure(const ServerException());
      expect(failure, isA<ServerFailure>());
      expect(failure.message, AppStrings.serverErrorMessage);
    });
  });
}
