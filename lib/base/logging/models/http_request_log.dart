import 'package:talker_flutter/talker_flutter.dart';
import 'dart:convert';

class HttpRequestLog extends TalkerLog {
  final String method;
  final String url;
  final Map<String, dynamic> headers;
  final dynamic body;
  final String? curlCommand;

  HttpRequestLog({
    required this.method,
    required this.url,
    required this.headers,
    this.body,
    this.curlCommand,
  }) : super('HTTP Request');

  @override
  String get title => '$method $url';

  @override
  String generateTextMessage(
      {TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer
        .writeln('╔══════════════════════════════════════════════════════════');
    buffer.writeln('║ 📤 HTTP REQUEST');
    buffer
        .writeln('╠══════════════════════════════════════════════════════════');
    buffer.writeln('║ $method $url');
    if (curlCommand != null) {
      buffer.writeln(
          '╠══════════════════════════════════════════════════════════');
      buffer.writeln('║ 🔧 cURL Command:');
      buffer.writeln(
          '╠──────────────────────────────────────────────────────────');
      curlCommand!.split('\n').forEach((line) {
        buffer.writeln('║   $line');
      });
    }
    buffer
        .writeln('╠══════════════════════════════════════════════════════════');
    buffer.writeln('║ 📋 Request Headers:');
    buffer
        .writeln('╠──────────────────────────────────────────────────────────');

    if (headers.isNotEmpty) {
      final formattedHeaders =
          const JsonEncoder.withIndent('  ').convert(headers);
      formattedHeaders.split('\n').forEach((line) {
        buffer.writeln('║   $line');
      });
    } else {
      buffer.writeln('║   (empty)');
    }

    if (body != null) {
      buffer.writeln(
          '╠══════════════════════════════════════════════════════════');
      buffer.writeln('║ 📦 Request Body:');
      buffer.writeln(
          '╠──────────────────────────────────────────────────────────');
      final formattedBody = _formatBody(body);
      formattedBody.split('\n').forEach((line) {
        buffer.writeln('║   $line');
      });
    }

    buffer
        .writeln('╚══════════════════════════════════════════════════════════');
    return buffer.toString();
  }

  String _formatBody(dynamic body) {
    try {
      if (body is String) {
        try {
          final decoded = jsonDecode(body);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (e) {
          return body;
        }
      }
      return const JsonEncoder.withIndent('  ').convert(body);
    } catch (e) {
      return body.toString();
    }
  }

  @override
  AnsiPen get pen => AnsiPen()..blue();

  Map<String, dynamic> toJson() {
    return {
      'type': 'request',
      'method': method,
      'url': url,
      'headers': headers,
      'body': body,
      'curlCommand': curlCommand,
    };
  }
}

class HttpResponseLog extends TalkerLog {
  final int statusCode;
  final String method;
  final String url;
  final Map<String, dynamic> headers;
  final dynamic body;
  final Duration? duration;

  HttpResponseLog({
    required this.statusCode,
    required this.method,
    required this.url,
    required this.headers,
    this.body,
    this.duration,
  }) : super('HTTP Response');

  @override
  String get title => '$statusCode $method $url';

  @override
  String generateTextMessage(
      {TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    final isSuccess = statusCode >= 200 && statusCode < 300;
    final emoji = isSuccess ? '✅' : '❌';

    buffer
        .writeln('╔══════════════════════════════════════════════════════════');
    buffer.writeln('║ $emoji HTTP RESPONSE');
    buffer
        .writeln('╠══════════════════════════════════════════════════════════');
    buffer.writeln('║ $statusCode $method $url');
    if (duration != null) {
      buffer.writeln('║ ⏱️  Duration: ${duration!.inMilliseconds}ms');
    }
    buffer
        .writeln('╠══════════════════════════════════════════════════════════');
    buffer.writeln('║ 📋 Response Headers:');
    buffer
        .writeln('╠──────────────────────────────────────────────────────────');

    if (headers.isNotEmpty) {
      final formattedHeaders =
          const JsonEncoder.withIndent('  ').convert(headers);
      formattedHeaders.split('\n').forEach((line) {
        buffer.writeln('║   $line');
      });
    } else {
      buffer.writeln('║   (empty)');
    }

    if (body != null) {
      buffer.writeln(
          '╠══════════════════════════════════════════════════════════');
      buffer.writeln('║ 📦 Response Body:');
      buffer.writeln(
          '╠──────────────────────────────────────────────────────════');
      final formattedBody = _formatBody(body);
      formattedBody.split('\n').forEach((line) {
        buffer.writeln('║   $line');
      });
    }

    buffer
        .writeln('╚══════════════════════════════════════════════════════════');
    return buffer.toString();
  }

  String _formatBody(dynamic body) {
    try {
      if (body is String) {
        try {
          final decoded = jsonDecode(body);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (e) {
          return body;
        }
      }
      return const JsonEncoder.withIndent('  ').convert(body);
    } catch (e) {
      return body.toString();
    }
  }

  @override
  AnsiPen get pen {
    if (statusCode >= 200 && statusCode < 300) {
      return AnsiPen()..green();
    } else if (statusCode >= 400 && statusCode < 500) {
      return AnsiPen()..yellow();
    } else if (statusCode >= 500) {
      return AnsiPen()..red();
    }
    return AnsiPen()..white();
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'response',
      'statusCode': statusCode,
      'method': method,
      'url': url,
      'headers': headers,
      'body': body,
      'duration': duration?.inMilliseconds,
    };
  }
}

class HttpErrorLog extends TalkerLog {
  final String method;
  final String url;
  final int? statusCode;
  final String errorType;
  final String errorMessage;
  final dynamic responseBody;

  HttpErrorLog({
    required this.method,
    required this.url,
    this.statusCode,
    required this.errorType,
    required this.errorMessage,
    this.responseBody,
  }) : super('HTTP Error');

  @override
  String get title => '${statusCode ?? 'ERROR'} $method $url';

  @override
  String generateTextMessage(
      {TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer
        .writeln('╔══════════════════════════════════════════════════════════');
    buffer.writeln('║ ⛔ HTTP ERROR');
    buffer
        .writeln('╠══════════════════════════════════════════════════════════');
    buffer.writeln('║ ${statusCode ?? 'N/A'} $method $url');
    buffer.writeln('║ Error Type: $errorType');
    buffer.writeln('║ Message: $errorMessage');

    if (responseBody != null) {
      buffer.writeln(
          '╠══════════════════════════════════════════════════════════');
      buffer.writeln('║ 📦 Error Response:');
      buffer.writeln(
          '╠──────────────────────────────────────────────────────────');
      final formatted = _formatBody(responseBody);
      formatted.split('\n').forEach((line) {
        buffer.writeln('║   $line');
      });
    }

    buffer
        .writeln('╚══════════════════════════════════════════════════════════');
    return buffer.toString();
  }

  String _formatBody(dynamic body) {
    try {
      if (body is String) {
        try {
          final decoded = jsonDecode(body);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (e) {
          return body;
        }
      }
      return const JsonEncoder.withIndent('  ').convert(body);
    } catch (e) {
      return body.toString();
    }
  }

  @override
  AnsiPen get pen => AnsiPen()..red();

  Map<String, dynamic> toJson() {
    return {
      'type': 'error',
      'method': method,
      'url': url,
      'statusCode': statusCode,
      'errorType': errorType,
      'errorMessage': errorMessage,
      'responseBody': responseBody,
    };
  }
}
