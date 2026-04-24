import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:get/get.dart' as from_get;
import 'package:jewellery_erp_frontend_tab_version/base/controllers/token_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final Dio dio;
  static const String _logTag = 'AuthInterceptor';
  late final TokenController _tokenController;

  AuthInterceptor(this.dio) {
    _tokenController = from_get.Get.put(TokenController());
  }

  bool _isRefreshing = false;
  final _requestsNeedRetry =
      <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only exempt login, token refresh, and S3 image URLs
    if (options.path.contains('/login') ||
        options.path.contains('/token') ||
        options.path.contains('/refreshed-token') ||
        options.path.contains("jewellers-images.s3.amazonaws.com")) {
      dev.log(
        'Skipping token authentication for exempt endpoint: ${options.path}',
        name: _logTag,
      );
      return handler.next(options);
    }

    final accessToken = await _tokenController.getAccessToken();

    // Use uppercase 'Authorization' for sipserver.1ounce.in APIs
    // Use lowercase 'authorization' for zivoro-backend APIs
    if (options.path.contains('sipserver.1ounce.in')) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      dev.log(
        'Added Authorization (uppercase) for sipserver endpoint: ${options.path}',
        name: _logTag,
      );
    } else {
      options.headers['authorization'] = '$accessToken';
      dev.log(
        'Added authorization (lowercase) for endpoint: ${options.path}',
        name: _logTag,
      );
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;

    // Check if it's a 401 error and not the refresh token endpoint
    if (response != null &&
        response.statusCode == 401 &&
        !response.requestOptions.path.contains("/refresh_token")) {
      dev.log(
        '401 error detected for: ${response.requestOptions.path}',
        name: _logTag,
      );

      // TEMPORARY FIX: Skip refresh for sipserver - different auth system
      if (response.requestOptions.path.contains('sipserver.1ounce.in')) {
        dev.log(
          '401 on sipserver.1ounce.in - skipping token refresh (different auth system)',
          name: _logTag,
          level: 1000,
        );

        // Clear any queued requests for sipserver to prevent accumulation
        _requestsNeedRetry.removeWhere(
          (req) => req.options.path.contains('sipserver.1ounce.in'),
        );

        // Just pass through the error without retry
        return handler.next(err);
      }

      // Normal refresh logic for zivoro-backend endpoints
      if (!_isRefreshing) {
        _isRefreshing = true;
        _requestsNeedRetry.add((
          options: response.requestOptions,
          handler: handler,
        ));

        final isRefreshSuccess = await _refreshToken();

        if (isRefreshSuccess) {
          dev.log(
            'Token refresh successful, retrying ${_requestsNeedRetry.length} requests',
            name: _logTag,
          );

          for (var requestNeedRetry in _requestsNeedRetry) {
            // Re-add the proper authorization header before retry
            final accessToken = await _tokenController.getAccessToken();

            if (requestNeedRetry.options.path.contains('sipserver.1ounce.in')) {
              requestNeedRetry.options.headers['Authorization'] =
                  'Bearer $accessToken';
            } else {
              requestNeedRetry.options.headers['authorization'] =
                  '$accessToken';
            }

            dio
                .fetch(requestNeedRetry.options)
                .then((response) {
                  requestNeedRetry.handler.resolve(response);
                })
                .catchError((e) {
                  dev.log("Error in retry: $e", name: _logTag);
                  requestNeedRetry.handler.reject(e);
                });
          }

          _requestsNeedRetry.clear();
          _isRefreshing = false;
        } else {
          dev.log('Token refresh failed, logging out', name: _logTag);
          _requestsNeedRetry.clear();
          _isRefreshing = false;
          await _tokenController.logout();
          return handler.next(err);
        }
      } else {
        // Another refresh is in progress, queue this request (only for non-sipserver)
        if (!response.requestOptions.path.contains('sipserver.1ounce.in')) {
          dev.log(
            'Refresh already in progress, queuing request',
            name: _logTag,
          );
          _requestsNeedRetry.add((
            options: response.requestOptions,
            handler: handler,
          ));
        } else {
          dev.log(
            'Refresh in progress but skipping sipserver request',
            name: _logTag,
          );
          return handler.next(err);
        }
      }
    } else {
      return handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _tokenController.getRefreshToken();
      final res = await callApiRefreshToken(refreshToken);
      if (res?.statusCode == 200) {
        dev.log("refresh token success", name: _logTag);
        return true;
      } else {
        dev.log(
          "refresh token fail ${res?.statusMessage ?? res.toString()}",
          name: _logTag,
        );
        return false;
      }
    } catch (error) {
      dev.log("refresh token fail $error", name: _logTag);
      return false;
    }
  }

  Future<Response<dynamic>?> callApiRefreshToken(String? refreshToken) async {
    if (refreshToken == null) {
      dev.log('No refresh token available', name: _logTag, level: 1000);
      return null;
    }

    try {
      dev.log('Initiating refresh token request', name: _logTag);
      final client = Dio(dio.options);

      final response = await client.post(
        '${AppUrl.organizationBaseUrl}/refresh_token',
        options: Options(headers: {'refresh-token': refreshToken}),
      );

      dev.log('Refresh token request successful $response', name: _logTag);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newTokens = response.data as Map<String, dynamic>;
        await _tokenController.setTokens(
          newTokens['access_token'],
          newTokens['refresh_token'],
        );
        return response;
      } else {
        dev.log('Refresh token request unsuccessful $response', name: _logTag);
        return null;
      }
    } catch (e, stackTrace) {
      dev.log(
        'Refresh token request failed $e',
        error: e,
        stackTrace: stackTrace,
        name: _logTag,
        level: 1000,
      );
      return null; // Don't rethrow, return null instead
    }
  }
}
