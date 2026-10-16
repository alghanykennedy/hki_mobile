import 'package:equatable/equatable.dart';

import '../constants/app_strings.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppStrings.offlineMessage]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = AppStrings.timeoutMessage]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = AppStrings.unauthorizedMessage]);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = AppStrings.forbiddenMessage]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = AppStrings.notFoundMessage]);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure({
    String message = AppStrings.fieldRequired,
    this.fieldErrors = const {},
  }) : super(message);

  @override
  List<Object?> get props => [message, fieldErrors];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = AppStrings.serverErrorMessage]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = AppStrings.unknownErrorMessage]);
}

class ParsingFailure extends Failure {
  const ParsingFailure([super.message = AppStrings.parsingErrorMessage]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = AppStrings.unknownErrorMessage]);
}
