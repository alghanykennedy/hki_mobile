import 'package:dio/dio.dart';

import '../constants/app_strings.dart';
import '../network/api_response_parser.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorMapper {
  ErrorMapper._();

  /// Maps a DioException or generic Object to an AppException
  static AppException fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NoInternetException();

      case DioExceptionType.badCertificate:
        return const BadCertificateException();

      case DioExceptionType.cancel:
        return const CancelledException();

      case DioExceptionType.badResponse:
        return _fromResponse(dioException.response);

      case DioExceptionType.unknown:
      default:
        if (dioException.error is AppException) {
          return dioException.error as AppException;
        }
        return UnknownException(
          message: dioException.message ?? AppStrings.unknownErrorMessage,
        );
    }
  }

  static AppException _fromResponse(Response? response) {
    if (response == null) {
      return const ServerException();
    }

    final statusCode = response.statusCode ?? 500;
    final data = response.data;
    final serverMessage = ApiResponseParser.extractMessage(data);

    switch (statusCode) {
      case 400:
      case 422:
        final fieldErrors = ApiResponseParser.extractFieldErrors(data);
        return ValidationException(
          message: serverMessage ?? AppStrings.fieldRequired,
          statusCode: statusCode,
          fieldErrors: fieldErrors,
        );

      case 401:
        return UnauthorizedException(
          message: serverMessage ?? AppStrings.unauthorizedMessage,
          statusCode: 401,
        );

      case 403:
        return ForbiddenException(
          message: serverMessage ?? AppStrings.forbiddenMessage,
          statusCode: 403,
        );

      case 404:
        return NotFoundException(
          message: serverMessage ?? AppStrings.notFoundMessage,
          statusCode: 404,
        );

      case 429:
        return const TooManyRequestsException();

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: serverMessage ?? AppStrings.serverErrorMessage,
          statusCode: statusCode,
        );

      default:
        return UnknownException(
          message: serverMessage ?? AppStrings.unknownErrorMessage,
          statusCode: statusCode,
        );
    }
  }

  /// Maps an AppException or generic Object to a domain Failure
  static Failure toFailure(Object error) {
    if (error is DioException) {
      final appException = fromDioException(error);
      return toFailure(appException);
    }

    if (error is NoInternetException) {
      return const NetworkFailure(AppStrings.offlineMessage);
    } else if (error is TimeoutException) {
      return const TimeoutFailure(AppStrings.timeoutMessage);
    } else if (error is UnauthorizedException) {
      return const UnauthorizedFailure(AppStrings.unauthorizedMessage);
    } else if (error is ForbiddenException) {
      return const ForbiddenFailure(AppStrings.forbiddenMessage);
    } else if (error is NotFoundException) {
      return const NotFoundFailure(AppStrings.notFoundMessage);
    } else if (error is ValidationException) {
      return ValidationFailure(
        message: error.message,
        fieldErrors: error.fieldErrors,
      );
    } else if (error is ServerException) {
      return const ServerFailure(AppStrings.serverErrorMessage);
    } else if (error is CacheException) {
      return const CacheFailure(AppStrings.unknownErrorMessage);
    } else if (error is ParsingException) {
      return const ParsingFailure(AppStrings.parsingErrorMessage);
    } else if (error is AppException) {
      return UnknownFailure(error.message);
    }

    return const UnknownFailure(AppStrings.unknownErrorMessage);
  }
}
