// response_models.dart

// Response model for presigned URLs
class MultipartPresignedUrlsResponse {
  final List<PresignedUrlItem>? items;

  MultipartPresignedUrlsResponse({this.items});

  factory MultipartPresignedUrlsResponse.fromJson(List<dynamic> json) {
    return MultipartPresignedUrlsResponse(
      items: json.map((item) => PresignedUrlItem.fromJson(item)).toList(),
    );
  }
}

class PresignedUrlItem {
  final String? presignedUrl;
  final int? partNumber;
  final int? expiresIn;

  PresignedUrlItem({
    this.presignedUrl,
    this.partNumber,
    this.expiresIn,
  });

  factory PresignedUrlItem.fromJson(Map<String, dynamic> json) {
    return PresignedUrlItem(
      presignedUrl: json['presigned_url'],
      partNumber: json['part_number'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toJson() => {
        'presigned_url': presignedUrl,
        'part_number': partNumber,
        'expires_in': expiresIn,
      };
}

// Response model for confirm part
class MultipartConfirmResponse {
  final bool? success;
  final String? message;

  MultipartConfirmResponse({this.success, this.message});

  factory MultipartConfirmResponse.fromJson(Map<String, dynamic> json) {
    return MultipartConfirmResponse(
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}

// Response model for complete multipart upload
class MultipartCompleteResponse {
  final String? location;
  final String? bucket;
  final String? key;
  final String? etag;
  final String? s3Key; // Add this field if it's missing
  final String? status;
  MultipartCompleteResponse({
    this.location,
    this.bucket,
    this.key,
    this.etag,
    this.s3Key,
    this.status,
  });

  factory MultipartCompleteResponse.fromJson(Map<String, dynamic> json) {
    return MultipartCompleteResponse(
      location: json['location'],
      bucket: json['bucket'],
      key: json['key'],
      etag: json['etag'],
      s3Key: json['s3_key'], // Add this mapping
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'location': location,
        'bucket': bucket,
        'key': key,
        'etag': etag,
        's3_key': s3Key,
        'status': status,
      };
}

class CompleteMultipartUploadResponse {
  final String? location;
  final String? bucket;
  final String? key;
  final String? etag;
  final String? s3Key; // Add this field if it's missing
  final String? status;

  CompleteMultipartUploadResponse({
    this.location,
    this.bucket,
    this.key,
    this.etag,
    this.s3Key,
    this.status,
  });

  factory CompleteMultipartUploadResponse.fromJson(Map<String, dynamic> json) {
    return CompleteMultipartUploadResponse(
      location: json['location'],
      bucket: json['bucket'],
      key: json['key'],
      etag: json['etag'],
      s3Key: json['s3_key'], // Add this mapping
      status: json['status'],
    );
  }
}
