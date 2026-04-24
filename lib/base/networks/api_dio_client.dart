import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/interceptors/auth_interceptor.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/interceptors/logging_interceptor.dart';

class HttpDioClient {
  late Dio _dio;
  HttpDioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 100), // Add this
        receiveTimeout: const Duration(seconds: 100), // Add this
        sendTimeout: const Duration(seconds: 100), // Add this
      ),
    );
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    // _dio.interceptors.add(TokenInterceptor(_dio));
    _dio.interceptors.add(AuthInterceptor(_dio));
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: log, // Print retry logs to console
        retries: 3, // Number of retries
        retryDelays: const [
          Duration(seconds: 1), // Wait 1 second before first retry
          Duration(seconds: 2), // Wait 2 seconds before second retry
          Duration(seconds: 3), // Wait 3 seconds before third retry
        ],
        retryEvaluator: (error, attempt) {
          // Only retry on network errors or for idempotent requests
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.connectionError ||
              (error.requestOptions.method == 'GET' ||
                  error.requestOptions.method == 'HEAD' ||
                  error.requestOptions.method == 'OPTIONS' ||
                  error.requestOptions.method == 'PUT' ||
                  error.requestOptions.method == 'DELETE');
        },
      ),
    );
  }

  Future<T> get<T>(
    String baseUrl,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    ResponseType? responseType,
  }) async {
    try {
      final Options requestOptions = options ?? Options();
      if (responseType != null) {
        requestOptions.responseType = responseType;
      }
      final response = await _dio.get(
        '$baseUrl$path',
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      if (responseType == ResponseType.bytes) {
        return response.data as T;
      }

      log("--------------HTTP Request/Response---------------");
      log("Http Status : ${response.statusCode}");
      log("Http Response : ${response.data}");

      return _handleResponse(response);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<T> post<T>(
    String baseUrl,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    ResponseType? responseType,
  }) async {
    try {
      final Options requestOptions = options ?? Options();
      if (responseType != null) {
        requestOptions.responseType = responseType;
      }

      final response = await _dio.post(
        '$baseUrl$path',
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: requestOptions,
        onSendProgress: onSendProgress,
      );

      if (responseType == ResponseType.bytes) {
        return response.data as T;
      }

      log("--------------HTTP Request/Response---------------");
      log("Http Status : ${response.statusCode}");
      log("Http Response : ${response.data}");

      return _handleResponse(response);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<T> put<T>(
    String baseUrl,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        '$baseUrl$path',
        data: data,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );

      log("--------------HTTP Request/Response---------------");
      log("Http Status : ${response.statusCode}");
      log("Http Response : ${response.data}");

      return _handleResponse(response);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<T> putUrlLink<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );

      log("--------------HTTP Request/Response---------------");
      log("Http Status : ${response.statusCode}");
      log("Http Response : ${response.data}");

      return _handleResponse(response);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<T> patch<T>(
    String baseUrl,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch(
        '$baseUrl$path',
        data: data,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );

      log("--------------HTTP Request/Response---------------");
      log("Http Status : ${response.statusCode}");
      log("Http Response : ${response.data}");

      return _handleResponse(response);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<T> delete<T>(
    String baseUrl,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        '$baseUrl$path',
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );

      log("--------------HTTP Request/Response---------------");
      log("Http Status : ${response.statusCode}");
      log("Http Response : ${response.data}");

      return _handleResponse(response);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200 || 201:
        return response.data;
      case 400 || 422:
        throw BadRequestException(response.data);

      case 401:
        // Perform Refresh Token logic in 401
        return UnauthorisedException((response.data));
      case 403:
        throw UnauthorisedException(response.data);
      case 404:
        throw NotFoundException(response.data);
      default:
        throw FetchDataException(
          'Error occurred with status code : ${response.statusCode}',
        );
    }
  }

  ApiException _handleError(DioException error) {
    log("--------------Error Handler---------------");
    log("The Error Handler : ${error.runtimeType}");
    log("The Error Handler : $error");

    switch (error.type) {
      case DioExceptionType.cancel:
        return ApiException(
          error.toString(),
          "Request to API server was cancelled",
        );
      case DioExceptionType.connectionTimeout:
        return ApiException(
          error.toString(),
          "Connection timeout with API server",
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          error.toString(),
          "Receive timeout in connection with API server",
        );
      case DioExceptionType.badResponse:
        return _handleResponse(error.response!);
      case DioExceptionType.sendTimeout:
        return ApiException(
          error.toString(),
          "Send timeout in connection with API server",
        );
      case DioExceptionType.unknown:
        return ApiException(error.toString(), "Unexpected error occurred");
      case DioExceptionType.badCertificate:
        return ApiException(error.toString(), "Bad Certificate Error");
      case DioExceptionType.connectionError:
        return ApiException(error.toString(), "Connection Error");
      // default:
      //   return ApiException(error.toString(), "Unexpected error occurred");
    }
  }
}
