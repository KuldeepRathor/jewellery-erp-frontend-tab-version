// import 'dart:developer';

// import 'package:dio/dio.dart';

// class LoggingInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     log('┌------------------------------------------------------------------------------');
//     log('| REQUEST: ${options.method} ${options.uri}');
//     log('| Headers:');
//     options.headers.forEach((key, value) {
//       log('|\t$key: $value');
//     });
//     if (options.data != null) {
//       log('| Body: ${options.data}');
//     }
//     log('└------------------------------------------------------------------------------');
//     super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     log('┌------------------------------------------------------------------------------');
//     log('| RESPONSE: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}');
//     log('| Headers:');
//     response.headers.forEach((key, value) {
//       log('|\t$key: $value');
//     });
//     log('| Body: ${response.data}');
//     log('└------------------------------------------------------------------------------');
//     super.onResponse(response, handler);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     log('┌------------------------------------------------------------------------------');
//     log('| ERROR: ${err.type}');
//     log('| ${err.message}');
//     log('| ${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.uri}');
//     if (err.response != null) {
//       log('| Response:');
//       log('|\tHeaders:');
//       err.response!.headers.forEach((key, value) {
//         log('|\t\t$key: $value');
//       });
//       log('|\tBody: ${err.response!.data}');
//     }
//     log('└------------------------------------------------------------------------------');
//     super.onError(err, handler);
//   }
// }import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/curl_genrator.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/talker_controller.dart';

class LoggingInterceptor extends dio.Interceptor {
  TalkerController get _talkerController => Get.find<TalkerController>();

  final Map<String, DateTime> _requestTimes = {};

  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) {
    // Track request time
    _requestTimes[options.uri.toString()] = DateTime.now();

    // Extract headers
    final headers = Map<String, dynamic>.from(options.headers);

    final curlCommand = CurlGenerator.generateCurl(options);

    // Log the request
    _talkerController.logHttpRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: headers,
      body: options.data,
      curlCommand: curlCommand,
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    dio.Response response,
    dio.ResponseInterceptorHandler handler,
  ) {
    // Calculate duration
    final requestTime = _requestTimes[response.requestOptions.uri.toString()];
    Duration? duration;
    if (requestTime != null) {
      duration = DateTime.now().difference(requestTime);
      _requestTimes.remove(response.requestOptions.uri.toString());
    }

    // Extract headers
    final headers = <String, dynamic>{};
    response.headers.map.forEach((key, value) {
      headers[key] = value.join(', ');
    });

    // Log the response
    _talkerController.logHttpResponse(
      statusCode: response.statusCode ?? 0,
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      headers: headers,
      body: response.data,
      duration: duration,
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    // Extract headers if available
    final headers = <String, dynamic>{};
    err.response?.headers.map.forEach((key, value) {
      headers[key] = value.join(', ');
    });

    // Log the error
    _talkerController.logHttpError(
      method: err.requestOptions.method,
      url: err.requestOptions.uri.toString(),
      statusCode: err.response?.statusCode,
      errorType: err.type.toString(),
      errorMessage: err.message ?? 'Unknown error',
      responseBody: err.response?.data,
    );

    super.onError(err, handler);
  }
}
