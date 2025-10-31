import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

@freezed
class NetworkException with _$NetworkException implements Exception {
  const factory NetworkException.requestCancelled() = RequestCancelled;
  const factory NetworkException.unauthorised() = Unauthorised;
  const factory NetworkException.badRequest() = BadRequest;
  const factory NetworkException.forbidden() = Forbidden;
  const factory NetworkException.notFound() = NotFound;
  const factory NetworkException.methodNotAllowed() = MethodNotAllowed;
  const factory NetworkException.notAcceptable() = NotAcceptable;
  const factory NetworkException.requestTimeout() = RequestTimeout;
  const factory NetworkException.conflict() = Conflict;
  const factory NetworkException.internalServerError() = InternalServerError;
  const factory NetworkException.notImplemented() = NotImplemented;
  const factory NetworkException.serviceUnavailable() = ServiceUnavailable;
  const factory NetworkException.noInternetConnection() = NoInternetConnection;
  const factory NetworkException.formatException() = FormatException;
  const factory NetworkException.unableToProcess() = UnableToProcess;
  const factory NetworkException.defaultError(String error) = DefaultError;
  const factory NetworkException.unexpectedError() = UnexpectedError;
}

extension NetworkExceptionExtension on NetworkException {
  String get message {
    return when(
      requestCancelled: () => "Request was cancelled",
      unauthorised: () => "Unauthorised access",
      badRequest: () => "Bad request",
      forbidden: () => "Access forbidden",
      notFound: () => "Resource not found",
      methodNotAllowed: () => "Method not allowed",
      notAcceptable: () => "Not acceptable",
      requestTimeout: () => "Request timeout",
      conflict: () => "Conflict occurred",
      internalServerError: () => "Internal server error",
      notImplemented: () => "Not implemented",
      serviceUnavailable: () => "Service unavailable",
      noInternetConnection: () => "No internet connection",
      formatException: () => "Format exception",
      unableToProcess: () => "Unable to process",
      defaultError: (error) => error,
      unexpectedError: () => "Something went wrong. Please try again later.",
    );
  }

  bool get isNetworkError {
    return when(
      noInternetConnection: () => true,
      requestTimeout: () => true,
      serviceUnavailable: () => true,
      internalServerError: () => true,
      unexpectedError: () => true,
      requestCancelled: () => false,
      unauthorised: () => false,
      badRequest: () => false,
      forbidden: () => false,
      notFound: () => false,
      methodNotAllowed: () => false,
      notAcceptable: () => false,
      conflict: () => false,
      notImplemented: () => false,
      formatException: () => false,
      unableToProcess: () => false,
      defaultError: (_) => false,
    );
  }
}
