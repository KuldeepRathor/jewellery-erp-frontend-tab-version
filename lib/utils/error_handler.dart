import 'dart:convert';
import 'dart:developer';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';

/// Centralized error handler for API exceptions
class ErrorHandler {
  /// Extracts user-friendly error message from any exception
  static String getErrorMessage(dynamic error) {
    if (error is BadRequestException) {
      return _extractFromBadRequest(error);
    }

    if (error is UnauthorisedException) {
      return _extractFromUnauthorised(error);
    }

    if (error is NotFoundException) {
      return _extractFromNotFound(error);
    }

    if (error is FetchDataException) {
      return _extractFromFetchData(error);
    }

    if (error is InvalidInputException) {
      return _extractFromInvalidInput(error);
    }

    if (error is ApiException) {
      return _extractFromApiException(error);
    }

    // Fallback for unknown errors
    return _extractGenericError(error);
  }

  /// Extract message from BadRequestException (400, 422)
  static String _extractFromBadRequest(BadRequestException error) {
    final message = error.message;

    // Handle Map response
    if (message is Map) {
      // Try common error field names in order of priority
      if (message.containsKey('detail')) {
        return _formatErrorValue(message['detail']);
      }
      if (message.containsKey('message')) {
        return _formatErrorValue(message['message']);
      }
      if (message.containsKey('error')) {
        return _formatErrorValue(message['error']);
      }
      if (message.containsKey('errors')) {
        return _formatErrors(message['errors']);
      }
      // Return first value if no known keys found
      if (message.isNotEmpty) {
        return _formatErrorValue(message.values.first);
      }
    }

    // Handle String response
    if (message is String) {
      return _tryParseStringMessage(message) ?? message;
    }

    return error.toStringMessage();
  }

  /// Extract message from UnauthorisedException (401, 403)
  static String _extractFromUnauthorised(UnauthorisedException error) {
    final message = error.message;

    if (message is Map) {
      if (message.containsKey('detail')) {
        return _formatErrorValue(message['detail']);
      }
      if (message.containsKey('message')) {
        return _formatErrorValue(message['message']);
      }
    }

    if (message is String && message.isNotEmpty) {
      return _tryParseStringMessage(message) ?? message;
    }

    return "Unauthorized access. Please login again.";
  }

  /// Extract message from NotFoundException (404)
  static String _extractFromNotFound(NotFoundException error) {
    final message = error.message;

    if (message is Map) {
      if (message.containsKey('detail')) {
        return _formatErrorValue(message['detail']);
      }
      if (message.containsKey('message')) {
        return _formatErrorValue(message['message']);
      }
    }

    if (message is String && message.isNotEmpty) {
      return _tryParseStringMessage(message) ?? message;
    }

    return "Resource not found.";
  }

  /// Extract message from FetchDataException
  static String _extractFromFetchData(FetchDataException error) {
    final message = error.message;

    if (message is String && message.isNotEmpty) {
      return _tryParseStringMessage(message) ?? message;
    }

    return "Failed to fetch data. Please try again.";
  }

  /// Extract message from InvalidInputException
  static String _extractFromInvalidInput(InvalidInputException error) {
    final message = error.message;

    if (message is Map) {
      if (message.containsKey('detail')) {
        return _formatErrorValue(message['detail']);
      }
      if (message.containsKey('errors')) {
        return _formatErrors(message['errors']);
      }
    }

    if (message is String && message.isNotEmpty) {
      return message;
    }

    return "Invalid input. Please check your data.";
  }

  /// Extract message from generic ApiException
  static String _extractFromApiException(ApiException error) {
    final message = error.message;

    if (message is Map) {
      if (message.containsKey('detail')) {
        return _formatErrorValue(message['detail']);
      }
      if (message.containsKey('message')) {
        return _formatErrorValue(message['message']);
      }
      if (message.containsKey('error')) {
        return _formatErrorValue(message['error']);
      }
    }

    if (message is String && message.isNotEmpty) {
      return _tryParseStringMessage(message) ?? message;
    }

    return error.toStringMessage();
  }

  /// Extract generic error message
  static String _extractGenericError(dynamic error) {
    if (error == null) {
      return "An unknown error occurred.";
    }

    final errorString = error.toString();

    // Try to parse if it looks like JSON
    if (errorString.startsWith('{') || errorString.startsWith('[')) {
      final parsed = _tryParseStringMessage(errorString);
      if (parsed != null) return parsed;
    }

    return errorString;
  }

  /// Try to parse string as JSON and extract error message
  static String? _tryParseStringMessage(String message) {
    try {
      final decoded = jsonDecode(message);

      if (decoded is Map) {
        if (decoded.containsKey('detail')) {
          return _formatErrorValue(decoded['detail']);
        }
        if (decoded.containsKey('message')) {
          return _formatErrorValue(decoded['message']);
        }
        if (decoded.containsKey('error')) {
          return _formatErrorValue(decoded['error']);
        }
        if (decoded.containsKey('errors')) {
          return _formatErrors(decoded['errors']);
        }
      }
    } catch (e) {
      // If parsing fails, return null to use original message
      log('Failed to parse error message as JSON: $e');
    }

    return null;
  }

  /// Format error value (handles String, List, Map)
  static String _formatErrorValue(dynamic value) {
    if (value is String) {
      return value;
    }

    if (value is List) {
      return value.join(', ');
    }

    if (value is Map) {
      // For validation errors like {"field": ["error1", "error2"]}
      return value.entries
          .map((e) => '${e.key}: ${_formatErrorValue(e.value)}')
          .join(', ');
    }

    return value.toString();
  }

  /// Format multiple errors (validation errors)
  static String _formatErrors(dynamic errors) {
    if (errors is List) {
      return errors.map((e) => _formatErrorValue(e)).join(', ');
    }

    if (errors is Map) {
      // For validation errors like {"field1": ["error1"], "field2": ["error2"]}
      return errors.entries
          .map((e) => '${e.key}: ${_formatErrorValue(e.value)}')
          .join('\n');
    }

    return _formatErrorValue(errors);
  }

  /// Log error with details (useful for debugging)
  static void logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) {
    final contextInfo = context != null ? '[$context] ' : '';
    log('${contextInfo}Error: ${error.toString()}');
    if (stackTrace != null) {
      log('StackTrace: ${stackTrace.toString()}');
    }
  }

  /// Check if error is due to network issues
  static bool isNetworkError(dynamic error) {
    if (error is ApiException) {
      final message = error.message?.toString().toLowerCase() ?? '';
      return message.contains('connection') ||
          message.contains('timeout') ||
          message.contains('network');
    }

    final errorString = error.toString().toLowerCase();
    return errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('network');
  }

  /// Check if error is authentication related
  static bool isAuthError(dynamic error) {
    return error is UnauthorisedException;
  }

  /// Get user-friendly network error message
  static String getNetworkErrorMessage() {
    return "Network error. Please check your internet connection and try again.";
  }
}
