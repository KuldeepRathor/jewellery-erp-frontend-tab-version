import 'dart:convert';

import 'package:dio/dio.dart';

class CurlGenerator {
  static String generateCurl(RequestOptions options) {
    final buffer = StringBuffer();

    // Start with curl command
    buffer.write('curl --request ${options.method}');

    // Add URL
    buffer.write(' \'${options.uri}\'');

    // Add headers
    options.headers.forEach((key, value) {
      buffer.write(' \\\n  --header \'$key: $value\'');
    });

    // Add data/body if present
    if (options.data != null) {
      String data;

      if (options.data is FormData) {
        // Handle FormData
        final formData = options.data as FormData;
        for (var field in formData.fields) {
          buffer.write(' \\\n  --form \'${field.key}=${field.value}\'');
        }
        for (var file in formData.files) {
          buffer.write(' \\\n  --form \'${file.key}=@${file.value.filename}\'');
        }
      } else if (options.data is Map) {
        // Handle Map data
        data = _formatData(options.data);
        buffer.write(' \\\n  --data \'$data\'');
      } else if (options.data is String) {
        // Handle String data
        buffer.write(' \\\n  --data \'${options.data}\'');
      } else {
        // Handle other types
        data = options.data.toString();
        buffer.write(' \\\n  --data \'$data\'');
      }
    }

    return buffer.toString();
  }

  static String _formatData(dynamic data) {
    if (data is Map) {
      // Convert map to JSON string
      try {
        return jsonEncode(data);
      } catch (e) {
        return data.toString();
      }
    }
    return data.toString();
  }

  // Generate a more compact curl (single line)
  static String generateCompactCurl(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.write('curl -X ${options.method} \'${options.uri}\'');

    options.headers.forEach((key, value) {
      buffer.write(' -H \'$key: $value\'');
    });

    if (options.data != null && options.data is! FormData) {
      String data = _formatData(options.data);
      buffer.write(' -d \'$data\'');
    }

    return buffer.toString();
  }
}
