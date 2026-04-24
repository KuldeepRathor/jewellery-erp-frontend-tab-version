class ApiException implements Exception {
  dynamic message;
  final String _prefix;

  ApiException([
    this.message,
    this._prefix = '',
  ]);

  @override
  String toString() {
    return "$_prefix : $message";
  }

  String toStringMessage() {
    return "$message";
  }

  String toStringPrefix() {
    return _prefix;
  }
}

class FetchDataException extends ApiException {
  FetchDataException([
    String? super.message,
    super._prefix = "Fetch Data Exception",
  ]);
}

class BadRequestException extends ApiException {
  BadRequestException([
    super.message,
    super._prefix = "Bad Request Exception",
  ]);
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([
    super.message,
    super._prefix = "Unauthorised Exception",
  ]);
}

class InvalidInputException extends ApiException {
  InvalidInputException([
    String? super.message,
    super._prefix = "Invalid Input Exception ",
  ]);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message, super._prefix = "Not Found Exception"]);
}
