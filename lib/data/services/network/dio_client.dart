import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'connectivity_service.dart';
import 'network_exceptions.dart';

/// Dio client with error handling and connectivity checks
class DioClient {
  static const int _connectTimeout = 30000; // 30 seconds
  static const int _receiveTimeout = 30000; // 30 seconds
  static const int _sendTimeout = 30000; // 30 seconds

  final Dio _dio;
  final Logger _log = Logger('DioClient');

  DioClient({String? baseUrl}) : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: const Duration(milliseconds: _connectTimeout),
      receiveTimeout: const Duration(milliseconds: _receiveTimeout),
      sendTimeout: const Duration(milliseconds: _sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    if (kDebugMode) {
      _dio.interceptors.add(_createLogInterceptor());
    }
    _dio.interceptors.add(_createErrorInterceptor());
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// Create log interceptor for debugging (only in debug mode)
  Interceptor _createLogInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
      logPrint: (object) {
        // Print to console in debug mode for better visibility
        if (kDebugMode) {
          // print('DIO LOG: $object');
        }
        _log.info(object.toString());
      },
    );
  }

  /// Create error interceptor for handling network errors
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Debug logging for requests
        if (kDebugMode) {
          print('REQUEST: ${options.method} ${options.uri}');
          if (options.data != null) {
            print('REQUEST DATA: ${options.data}');
          }
          if (options.headers.isNotEmpty) {
            print('REQUEST HEADERS: ${options.headers}');
          }
        }

        // Check connectivity before making request
        final hasConnection = await ConnectivityService.hasInternetConnection();
        if (!hasConnection) {
          if (kDebugMode) {
            print('NO INTERNET CONNECTION');
          }
          return handler.reject(
            DioException(
              requestOptions: options,
              error: const NetworkException.noInternetConnection(),
              type: DioExceptionType.connectionError,
            ),
          );
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        // Debug logging for successful responses
        if (kDebugMode) {
          print('RESPONSE: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}');
          if (response.data != null) {
            // print('RESPONSE DATA: ${response.data}');
          }
        }
        handler.next(response);
      },
      onError: (error, handler) {
        // Debug logging for errors
        if (kDebugMode) {
          print('ERROR: ${error.type} ${error.requestOptions.method} ${error.requestOptions.uri}');
          print('ERROR MESSAGE: ${error.message}');
          if (error.response != null) {
            print('ERROR RESPONSE: ${error.response?.statusCode} - ${error.response?.data}');
          }
        }

        final networkException = _handleDioError(error);
        _log.severe('Network error: $networkException');

        // Create new DioException with our custom error
        final newError = DioException(
          requestOptions: error.requestOptions,
          error: networkException,
          type: error.type,
          response: error.response,
        );

        handler.next(newError);
      },
    );
  }

  /// Convert DioException to NetworkException
  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException.requestTimeout();
      
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response?.statusCode);
      
      case DioExceptionType.cancel:
        return const NetworkException.requestCancelled();
      
      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return const NetworkException.noInternetConnection();
        }
        return const NetworkException.unexpectedError();
      
      case DioExceptionType.badCertificate:
        return const NetworkException.unexpectedError();
      
      case DioExceptionType.unknown:
      if (error.error is SocketException) {
          return const NetworkException.noInternetConnection();
        }
        return const NetworkException.unexpectedError();
    }
  }

  /// Handle HTTP response errors
  NetworkException _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const NetworkException.badRequest();
      case 401:
        return const NetworkException.unauthorised();
      case 403:
        return const NetworkException.forbidden();
      case 404:
        return const NetworkException.notFound();
      case 409:
        return const NetworkException.conflict();
      case 408:
        return const NetworkException.requestTimeout();
      case 500:
        return const NetworkException.internalServerError();
      case 503:
        return const NetworkException.serviceUnavailable();
      default:
        return const NetworkException.unexpectedError();
    }
  }
}
