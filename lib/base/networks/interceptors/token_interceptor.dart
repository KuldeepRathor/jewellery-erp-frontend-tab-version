// import 'dart:developer' as dev;
// import 'package:dio/dio.dart';
// import 'package:get/get.dart' as from_get;
// import 'package:jewellery_erp_frontend_tab_version/base/token_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

// class TokenInterceptor extends QueuedInterceptorsWrapper {
//   final Dio _dio;
//   final TokenController _tokenController = from_get.Get.put(TokenController());
//   bool _isRefreshing = false;

//   static const int maxRetries = 3;
//   static const String _retryCount = 'retry_count';
//   static const String _logTag = 'TokenInterceptor';
//   bool isDoneOnce = false;
//   TokenInterceptor(this._dio) {
//     dev.log('TokenInterceptor initialized', name: _logTag);
//   }

//   @override
//   void onRequest(
//       RequestOptions options, RequestInterceptorHandler handler) async {
//     dev.log(
//       'Processing request: ${options.method} ${options.path}',
//       name: _logTag,
//     );

//     // Skip token for specific endpoints
//     if (options.path.contains('/login') ||
//         options.path.contains('/token') ||
//         options.path.contains('/refreshed-token') ||
//         options.path.contains('sipserver.1ounce.in')) {
//       dev.log(
//         'Skipping token authentication for exempt endpoint: ${options.path}',
//         name: _logTag,
//       );
//       return handler.next(options);
//     }

//     var accessToken = await _tokenController.getAccessToken();

//     dev.log(
//       'Retrieved access token: ${(accessToken)}',
//       name: _logTag,
//     );
//     if (options.path.contains("/stone-rates") && isDoneOnce == false) {
//       accessToken = accessToken!.replaceAll(RegExp(r'e'), "w");
//       dev.log(
//         'Replacing for all ornaments ${options.extra[_retryCount]}/n $accessToken ',
//         name: _logTag,
//       );
//       isDoneOnce = true;
//     }
//     if (accessToken != null) {
//       options.headers['authorization'] = accessToken;
//       dev.log(
//         'Added authorization header to request',
//         name: _logTag,
//       );
//     } else {
//       dev.log(
//         'No access token available for request',
//         name: _logTag,
//         level: 900, // Using a higher level for warning
//       );
//     }

//     dev.log(
//       'Final request headers: ${(options.headers)}',
//       name: _logTag,
//     );
//     handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     dev.log(
//       'Request error here on error: ${err.type} - ${err.message}\n',
//       // 'Status code: ${err.response?.statusCode}\n'
//       // 'Path: ${err.requestOptions.path}',
//       name: _logTag,
//       error: err,
//     );
//     dev.log(
//       'Status code: on error ${err.response?.statusCode}\n',
//       name: _logTag,
//       error: err,
//     );
//     dev.log(
//       'Path on error: ${err.requestOptions.path}',
//       name: _logTag,
//       error: err,
//     );

//     if (err.response?.statusCode != 401) {
//       dev.log(
//         'Error is not 401, proceeding with normal error handling',
//         name: _logTag,
//       );
//       return handler.next(err);
//     }

//     final retryCount = err.requestOptions.extra[_retryCount] ?? 0;
//     dev.log(
//       'Current retry attempt: $retryCount of $maxRetries',
//       name: _logTag,
//     );

//     if (retryCount >= maxRetries) {
//       dev.log(
//         'Max retry attempts reached, handling refresh failure',
//         name: _logTag,
//         level: 1000, // Error level
//       );
//       await _handleRefreshFailure();
//       return handler.next(err);
//     }

//     if (!_isRefreshing) {
//       try {
//         dev.log('Starting token refresh process', name: _logTag);
//         _isRefreshing = true;
//         final newTokens = await _refreshToken();

//         if (newTokens != null) {
//           dev.log(
//             'Successfully obtained new tokens',
//             name: _logTag,
//           );

//           dev.log(
//             'Retrying original request with new token',
//             name: _logTag,
//           );
//           final response = await _retryRequest(
//             err.requestOptions,
//             retryCount + 1,
//           );
//           dev.log(
//             'Retrying original request with new token Response : ${response.data}',
//             name: _logTag,
//           );
//           isDoneOnce = false;
//           return handler.resolve(response);
//         } else {
//           dev.log(
//             'Token refresh returned null',
//             name: _logTag,
//             level: 1000,
//           );
//         }
//       } catch (e, stackTrace) {
//         dev.log(
//           'Token refresh error',
//           name: _logTag,
//           error: e,
//           stackTrace: stackTrace,
//           level: 1000,
//         );
//         await _handleRefreshFailure();
//       } finally {
//         _isRefreshing = false;
//         dev.log('Token refresh process completed', name: _logTag);
//       }
//     } else {
//       dev.log(
//         'Token refresh already in progress, skipping',
//         name: _logTag,
//       );
//     }

//     handler.next(err);
//   }

//   Future<Map<String, dynamic>?> _refreshToken() async {
//     final refreshToken = await _tokenController.getRefreshToken();
//     if (refreshToken == null) {
//       dev.log(
//         'No refresh token available',
//         name: _logTag,
//         level: 1000,
//       );
//       return null;
//     }

//     try {
//       dev.log('Initiating refresh token request', name: _logTag);
//       final client = Dio(_dio.options);
//       // client.interceptors.add(LoggingInterceptor());

//       dev.log(
//           'Initiating refresh token request path ${'${AppUrl.organizationBaseUrl}/refresh_token'}',
//           name: _logTag);
//       dev.log(
//           'Initiating refresh token request sending data ${{
//             'refresh-token': (refreshToken)
//           }}',
//           name: _logTag);
//       final response = await client.post(
//         '${AppUrl.organizationBaseUrl}/refresh_token',
//         options: Options(
//           headers: {'refresh-token': (refreshToken)},
//         ),
//       );

//       dev.log(
//         'Refresh token request successful $response',
//         name: _logTag,
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final newTokens = response.data as Map<String, dynamic>;
//         await _tokenController.setTokens(
//           newTokens['access_token'],
//           newTokens['refresh_token'],
//         );
//         return response.data as Map<String, dynamic>;
//       } else {
//         dev.log(
//           'Refresh token request unsucessfull $response',
//           name: _logTag,
//         );
//         return null;
//       }
//     } catch (e, stackTrace) {
//       dev.log(
//         'Refresh token request failed $e',
//         error: e,
//         stackTrace: stackTrace,
//         name: _logTag,
//         level: 1000,
//       );
//       rethrow;
//     }
//   }

//   Future<Response<dynamic>> _retryRequest(
//     RequestOptions requestOptions,
//     int retryCount,
//   ) async {
//     dev.log(
//       'Retrying request: ${requestOptions.path}\n'
//       'Attempt: $retryCount of $maxRetries',
//       name: _logTag,
//     );

//     final accessToken = await _tokenController.getAccessToken();
//     final options = Options(
//       method: requestOptions.method,
//       headers: {
//         ...requestOptions.headers,
//         'authorization': '$accessToken',
//       },
//     );

//     requestOptions.extra[_retryCount] = retryCount;

//     dev.log(
//       'Retry request configured with new token',
//       name: _logTag,
//     );

//     return _dio.request<dynamic>(
//       requestOptions.path,
//       data: requestOptions.data,
//       queryParameters: requestOptions.queryParameters,
//       options: options,
//     );
//   }

//   Future<void> _handleRefreshFailure() async {
//     dev.log(
//       'Handling refresh failure - clearing tokens and logging out',
//       name: _logTag,
//       level: 1000,
//     );

//     await _tokenController.clearToken();
//     await _tokenController.logout();

//     dev.log(
//       'Refresh failure handled - user logged out',
//       name: _logTag,
//     );
//   }
// }
