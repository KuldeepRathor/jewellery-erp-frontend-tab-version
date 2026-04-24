// video_upload_service.dart

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/multipart_upload/multipart_uploads_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';

// Create a class to hold the upload result
class VideoUploadResult {
  final String location;
  final String s3Key;

  VideoUploadResult({required this.location, required this.s3Key});
}

// Class to hold part upload data
class PartUploadData {
  final int partNumber;
  final String presignedUrl;
  final Uint8List partData;
  final int index;

  PartUploadData({
    required this.partNumber,
    required this.presignedUrl,
    required this.partData,
    required this.index,
  });
}

class VideoUploadService {
  final AggregateRepository _aggregateRepository = AggregateRepository();
  static const int BATCH_SIZE = 5; // Maximum batch size

  // Create a separate Dio instance for S3 uploads to get full response
  final Dio _s3Dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 10),
      sendTimeout: const Duration(minutes: 10),
    ),
  );

  Future<VideoUploadResult?> uploadVideo({
    required String filePath,
    required Function(double) onProgress,
  }) async {
    try {
      final file = File(filePath);
      final fileSize = await file.length();
      final fileName = filePath.split('/').last;

      // Step 1: Initiate multipart upload
      log('Step 1: Initiating multipart upload...');
      final multipartRequest = MultipartUploadsRequest(
        filename: fileName,
        fileSize: fileSize,
        contentType: _getContentType(fileName),
        partSize: 5242880, // 5MB part size
      );

      final initResponse = await _aggregateRepository.multipartUploads(
        multipartUploadsRequest: multipartRequest,
      );

      if (initResponse.uploadId == null || initResponse.totalParts == null) {
        throw Exception('Failed to initiate multipart upload');
      }

      log('Upload ID: ${initResponse.uploadId}');
      log('Total parts: ${initResponse.totalParts}');

      // Step 2: Get presigned URLs for all parts
      log('Step 2: Getting presigned URLs...');
      final partNumbers = List.generate(
        initResponse.totalParts!,
        (index) => index + 1,
      );

      final presignedUrlsResponse = await _aggregateRepository
          .getMultipartPresignedUrls(
            uploadId: initResponse.uploadId!,
            partNumbers: partNumbers,
          );

      if (presignedUrlsResponse.items == null ||
          presignedUrlsResponse.items!.isEmpty) {
        throw Exception('Failed to get presigned URLs');
      }

      // Step 3: Upload parts in batches
      log(
        'Step 3: Uploading ${presignedUrlsResponse.items!.length} parts in batches of $BATCH_SIZE...',
      );
      final fileBytes = await file.readAsBytes();
      final partSize = initResponse.partSize!;

      // Prepare all part data
      final List<PartUploadData> allParts = [];
      for (int i = 0; i < presignedUrlsResponse.items!.length; i++) {
        final presignedItem = presignedUrlsResponse.items![i];

        // Calculate byte range for this part
        final start = i * partSize;
        final end =
            ((i + 1) * partSize > fileSize) ? fileSize : (i + 1) * partSize;
        final partBytes = fileBytes.sublist(start, end);

        allParts.add(
          PartUploadData(
            partNumber: presignedItem.partNumber!,
            presignedUrl: presignedItem.presignedUrl!,
            partData: partBytes,
            index: i,
          ),
        );
      }

      // Upload parts in batches
      await _uploadPartsInBatches(
        allParts: allParts,
        uploadId: initResponse.uploadId!,
        contentType: _getContentType(fileName),
        onProgress: onProgress,
      );

      // Step 5: Complete multipart upload
      log('Step 5: Completing multipart upload...');
      final completeResponse = await _aggregateRepository
          .completeMultipartUpload(uploadId: initResponse.uploadId!);

      log('Upload completed! Location: ${completeResponse.location}');
      log('S3 Key: ${completeResponse.s3Key}');

      // Return both location and s3Key
      return VideoUploadResult(
        location: completeResponse.location ?? '',
        s3Key: completeResponse.s3Key ?? '',
      );
    } catch (e) {
      log('Error uploading video: $e');
      rethrow;
    }
  }

  Future<void> _uploadPartsInBatches({
    required List<PartUploadData> allParts,
    required String uploadId,
    required String contentType,
    required Function(double) onProgress,
  }) async {
    final totalParts = allParts.length;
    int completedParts = 0;

    // Calculate number of batches
    final numberOfBatches = (totalParts / BATCH_SIZE).ceil();

    for (int batchIndex = 0; batchIndex < numberOfBatches; batchIndex++) {
      // Calculate batch boundaries
      final batchStart = batchIndex * BATCH_SIZE;
      final batchEnd =
          ((batchIndex + 1) * BATCH_SIZE > totalParts)
              ? totalParts
              : (batchIndex + 1) * BATCH_SIZE;

      final batchParts = allParts.sublist(batchStart, batchEnd);

      log(
        'Processing batch ${batchIndex + 1}/$numberOfBatches (parts ${batchStart + 1}-$batchEnd)...',
      );

      // Upload all parts in this batch concurrently
      final batchFutures = <Future<void>>[];

      for (final part in batchParts) {
        final future = _uploadPartWithConfirmation(
          part: part,
          uploadId: uploadId,
          contentType: contentType,
        );
        batchFutures.add(future);
      }

      // Wait for all uploads in this batch to complete
      await Future.wait(batchFutures);

      // Update progress after batch completion
      completedParts += batchParts.length;
      final progress = completedParts / totalParts;
      onProgress(progress);

      log(
        'Batch ${batchIndex + 1}/$numberOfBatches completed. Progress: ${(progress * 100).toStringAsFixed(1)}%',
      );
    }
  }

  Future<void> _uploadPartWithConfirmation({
    required PartUploadData part,
    required String uploadId,
    required String contentType,
  }) async {
    try {
      log(
        'Uploading part ${part.partNumber} (${part.partData.length} bytes)...',
      );

      // Upload part to S3 and get ETag
      final etag = await _uploadPartToS3(
        presignedUrl: part.presignedUrl,
        partData: part.partData,
        contentType: contentType,
      );

      // Step 4: Confirm part upload
      log('Confirming part ${part.partNumber} with ETag: $etag');
      await _aggregateRepository.confirmMultipartPart(
        uploadId: uploadId,
        partNumber: part.partNumber,
        etag: etag,
        size: part.partData.length,
      );

      log('Part ${part.partNumber} uploaded successfully');
    } catch (e) {
      log('Error uploading part ${part.partNumber}: $e');
      rethrow;
    }
  }

  Future<String> _uploadPartToS3({
    required String presignedUrl,
    required Uint8List partData,
    required String contentType,
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await _s3Dio.put(
          presignedUrl,
          data: partData,
          options: Options(
            headers: {
              'Content-Type': contentType,
              'Content-Length': partData.length.toString(),
            },
            responseType: ResponseType.plain,
            validateStatus: (status) => status != null && status < 500,
          ),
        );

        // Extract ETag from response headers
        final etag = response.headers.value('etag');
        if (etag == null) {
          log('Response headers (missing ETag):');
          response.headers.forEach((name, values) {
            log('$name: ${values.join(', ')}');
          });
          throw Exception('No ETag in response headers');
        }

        final cleanEtag = etag.replaceAll('"', '');
        log('✅ Uploaded part (attempt ${attempt + 1}), ETag: $cleanEtag');
        return cleanEtag;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          log('❌ Failed after $attempt attempts: $e');
          rethrow;
        } else {
          final delay = Duration(seconds: 2 * attempt); // exponential backoff
          log(
            '⚠️ Upload attempt $attempt failed, retrying in ${delay.inSeconds}s... Error: $e',
          );
          await Future.delayed(delay);
        }
      }
    }
  }

  String _getContentType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/x-msvideo';
      case 'mov':
        return 'video/quicktime';
      case 'wmv':
        return 'video/x-ms-wmv';
      case 'flv':
        return 'video/x-flv';
      case 'mkv':
        return 'video/x-matroska';
      default:
        return 'video/mp4';
    }
  }
}
