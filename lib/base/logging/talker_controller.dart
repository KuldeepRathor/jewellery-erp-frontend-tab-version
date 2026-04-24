import 'dart:convert';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/ui/custom_talker_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/debug_server.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/models/http_request_log.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerController extends GetxController {
  final Talker talker;
  final DebugServer _debugServer = DebugServer();

  TalkerController(this.talker);

  void handleError(String msg, Object exception, StackTrace? stacktrace) {
    talker.critical(msg);
    talker.handle(exception, stacktrace);
  }

  void logInfo(info) {
    talker.info(info);
  }

  void navigateToTalkerScreen() {
    Get.to(() => const CustomTalkerScreen());
  }

  void good(String message) {
    talker.log(message, logLevel: LogLevel.info);
  }

  Future<void> openDebugInBrowser() async {
    await _debugServer.start();
  }

  Future<void> stopDebugServer() async {
    await _debugServer.stop();
  }

  @override
  void onClose() {
    _debugServer.stop();
    super.onClose();
  }

  // HTTP Logging methods
  void logHttpRequest({
    required String method,
    required String url,
    required Map<String, dynamic> headers,
    dynamic body,
    String? curlCommand,
  }) {
    talker.logTyped(
      HttpRequestLog(
        method: method,
        url: url,
        headers: headers,
        body: body,
        curlCommand: curlCommand,
      ),
    );
  }

  void logHttpResponse({
    required int statusCode,
    required String method,
    required String url,
    required Map<String, dynamic> headers,
    dynamic body,
    Duration? duration,
  }) {
    talker.logTyped(
      HttpResponseLog(
        statusCode: statusCode,
        method: method,
        url: url,
        headers: headers,
        body: body,
        duration: duration,
      ),
    );
  }

  void logHttpError({
    required String method,
    required String url,
    int? statusCode,
    required String errorType,
    required String errorMessage,
    dynamic responseBody,
  }) {
    talker.logTyped(
      HttpErrorLog(
        method: method,
        url: url,
        statusCode: statusCode,
        errorType: errorType,
        errorMessage: errorMessage,
        responseBody: responseBody,
      ),
    );
  }

  // Export logs in custom format
  Future<String> exportLogsAsJson() async {
    final logs = talker.history;
    final exportData = <Map<String, dynamic>>[];

    for (var log in logs) {
      if (log is HttpRequestLog) {
        exportData.add(log.toJson());
      } else if (log is HttpResponseLog) {
        exportData.add(log.toJson());
      } else if (log is HttpErrorLog) {
        exportData.add(log.toJson());
      } else {
        // For other logs
        exportData.add({
          'type': 'log',
          'level': log.logLevel.toString(),
          'message': log.message,
          'time': log.time.toIso8601String(),
        });
      }
    }

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }
}
