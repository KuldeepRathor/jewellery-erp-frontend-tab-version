// enhanced_tagged_item_media_upload_controller.dart

import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path_lib;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/services/video_upload_service.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EnhancedTaggedItemMediaUploadController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final VideoUploadService videoUploadService = VideoUploadService();

  final RxList<MediaData> mediaPaths = <MediaData>[].obs;
  final RxBool isInitialized = false.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString currentUploadingFile = ''.obs;
  final RxInt currentUploadingIndex = 0.obs;
  final RxInt totalFilesToUpload = 0.obs;

  void clearControllers() {
    mediaPaths.value = [];
    uploadProgress.value = 0.0;
    currentUploadingFile.value = '';
    currentUploadingIndex.value = 0;
    totalFilesToUpload.value = 0;
  }

  /// Reorders media by dragging from [oldIndex] to [newIndex].
  /// Call this from the drag-and-drop callback.
  void reorderMedia(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    final list = List<MediaData>.from(mediaPaths);
    final item = list.removeAt(oldIndex);
    // ReorderableListView passes newIndex AFTER removal, so adjust
    final insertAt = newIndex > oldIndex ? newIndex - 1 : newIndex;
    list.insert(insertAt, item);
    // Re-assign sortOrder based on new positions
    mediaPaths.value =
        list
            .asMap()
            .entries
            .map((e) => e.value.copyWith(sortOrder: e.key))
            .toList();
  }

  Future<void> pickMedia() async {
    if (mediaPaths.length >= 5) {
      showErrorToast(message: 'Maximum 5 media files allowed');
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'mp4',
        'avi',
        'mov',
        'wmv',
        'mkv',
      ],
      allowMultiple: true,
    );

    if (result != null) {
      List<String> paths = result.paths.whereType<String>().toList();
      final remainingSlots = 5 - mediaPaths.length;

      for (int i = 0; i < paths.length && i < remainingSlots; i++) {
        final filePath = paths[i];
        final file = File(filePath);
        final fileSize = await file.length();
        final isVideo = _isVideoFile(filePath);

        if (isVideo && fileSize > 150 * 1024 * 1024) {
          showErrorToast(
            message:
                'Video file must be less than 150MB: ${path_lib.basename(filePath)}',
          );
          continue;
        } else if (!isVideo && fileSize > 100 * 1024 * 1024) {
          showErrorToast(
            message:
                'Image file must be less than 100MB: ${path_lib.basename(filePath)}',
          );
          continue;
        }

        mediaPaths.add(
          MediaData(
            path: filePath,
            isFile: true,
            isVideo: isVideo,
            fileSize: fileSize,
            fileName: path_lib.basename(filePath),
            sortOrder: mediaPaths.length, // append at end
          ),
        );
      }
    }
  }

  void removeMedia(int index) {
    if (index >= 0 && index < mediaPaths.length) {
      final list = List<MediaData>.from(mediaPaths);
      list.removeAt(index);
      // Re-assign sortOrder after removal
      mediaPaths.value =
          list
              .asMap()
              .entries
              .map((e) => e.value.copyWith(sortOrder: e.key))
              .toList();
    }
  }

  void populateWithFetchedData(TaggedItemReportValueResponse? data) {
    log("Populating media: ${data?.images}");

    final List<MediaData> newMediaPaths = [];

    final listOfMedia = data?.images ?? [];
    if (listOfMedia.isNotEmpty) {
      newMediaPaths.addAll(
        listOfMedia.asMap().entries.map(
          (e) => MediaData(
            path: e.value.presignedUrl ?? "",
            isFile: false,
            isVideo: _isVideoFile(e.value.fileName ?? ""),
            fileName: e.value.fileName,
            fileType: e.value.fileType,
            isDeleted: false,
            s3Key: e.value.s3Key,
            id: e.value.id,
            sortOrder: e.key,
          ),
        ),
      );
    }

    final designImages = data?.design?.images ?? [];
    if (designImages.isNotEmpty) {
      newMediaPaths.addAll(
        designImages.asMap().entries.map(
          (e) => MediaData(
            path: e.value.presignedUrl ?? "",
            isFile: false,
            isVideo: _isVideoFile(e.value.fileName ?? ""),
            fileName: e.value.fileName,
            fileType: e.value.fileType,
            isDeleted: false,
            s3Key: e.value.s3Key,
            id: e.value.id,
            sortOrder: newMediaPaths.length + e.key,
          ),
        ),
      );
    }

    mediaPaths.value = newMediaPaths;
    isInitialized.value = true;

    log("Total media items: ${mediaPaths.length}");
  }

  Future<bool> saveMedia(String taggingLineItemId) async {
    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      // Sort by sortOrder before uploading so server receives in correct sequence
      final sortedMedia = List<MediaData>.from(mediaPaths)
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      final newMedia = sortedMedia.where((m) => m.isFile).toList();
      final existingMedia =
          sortedMedia.where((m) => !m.isFile && !m.isDeleted).toList();

      List<Map<String, dynamic>> allMediaData = [];

      // Existing media — preserve their new order
      for (int i = 0; i < existingMedia.length; i++) {
        final existing = existingMedia[i];
        allMediaData.add({
          "id": existing.id,
          "file_name": existing.fileName,
          "file_type": existing.fileType,
          "s3_key": existing.s3Key,
          "presigned_url": existing.path,
          "is_video": existing.isVideo,
          "sort_order": existing.sortOrder, // send order to backend
        });
      }

      if (newMedia.isNotEmpty) {
        final images = newMedia.where((m) => !m.isVideo).toList();
        final videos = newMedia.where((m) => m.isVideo).toList();

        totalFilesToUpload.value = newMedia.length;
        currentUploadingIndex.value = 0;

        if (images.isNotEmpty) {
          await _uploadImages(images, allMediaData, taggingLineItemId);
        }

        if (videos.isNotEmpty) {
          await _uploadVideos(videos, allMediaData, taggingLineItemId);
        }
      }

      await inventoryRepository.updateTaggedItemImages(
        taggingLineItemId: taggingLineItemId,
        images: allMediaData,
      );

      showSuccessToast(message: "Media uploaded successfully");
      return true;
    } catch (e) {
      log("Error saving media: $e");
      showErrorToast(message: "Failed to upload media: ${e.toString()}");
      return false;
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
      currentUploadingFile.value = '';
      currentUploadingIndex.value = 0;
      totalFilesToUpload.value = 0;
    }
  }

  Future<void> _uploadImages(
    List<MediaData> images,
    List<Map<String, dynamic>> allMediaData,
    String taggingLineItemId,
  ) async {
    List<ImageRequestModel> imageRequests = [];
    for (var img in images) {
      imageRequests.add(
        ImageRequestModel(
          fileName: img.fileName!,
          fileType: _getFileType(img.fileName!),
        ),
      );
    }

    final presignedResponse = await inventoryRepository
        .getTaggedItemImagesPresignedUrl(
          images: imageRequests,
          groupId: taggingLineItemId,
        );

    if (presignedResponse.images != null) {
      for (int i = 0; i < images.length; i++) {
        if (i < presignedResponse.images!.length) {
          final imageData = presignedResponse.images![i];
          final presignedUrl = imageData.presignedUrl;

          if (presignedUrl != null) {
            currentUploadingFile.value = images[i].fileName ?? '';
            currentUploadingIndex.value++;

            uploadProgress.value =
                currentUploadingIndex.value / totalFilesToUpload.value;

            await inventoryRepository.putDesignImages(
              putUrl: presignedUrl,
              imagePath: images[i].path,
            );

            allMediaData.add({
              "id": imageData.id,
              "file_name": imageData.fileName,
              "file_type": imageData.fileType,
              "s3_key": imageData.s3Key,
              "presigned_url": presignedUrl,
              "is_video": false,
              "sort_order": images[i].sortOrder,
            });
          }
        }
      }
    }
  }

  Future<void> _uploadVideos(
    List<MediaData> videos,
    List<Map<String, dynamic>> allMediaData,
    String taggingLineItemId,
  ) async {
    for (var video in videos) {
      currentUploadingFile.value = video.fileName ?? '';
      currentUploadingIndex.value++;

      final uploadResult = await videoUploadService.uploadVideo(
        filePath: video.path,
        onProgress: (videoProgress) {
          final baseProgress =
              (currentUploadingIndex.value - 1) / totalFilesToUpload.value;
          final videoContribution = videoProgress / totalFilesToUpload.value;
          uploadProgress.value = baseProgress + videoContribution;
        },
      );

      if (uploadResult != null) {
        allMediaData.add({
          "file_name": video.fileName,
          "file_type": _getFileType(video.fileName!),
          "s3_key": uploadResult.s3Key,
          "presigned_url": uploadResult.location,
          "is_video": true,
          "sort_order": video.sortOrder,
        });
      }
    }
  }

  String _getFileType(String fileName) {
    final extension = path_lib.extension(fileName).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.mp4':
        return 'video/mp4';
      case '.avi':
        return 'video/x-msvideo';
      case '.mov':
        return 'video/quicktime';
      case '.wmv':
        return 'video/x-ms-wmv';
      case '.mkv':
        return 'video/x-matroska';
      default:
        return 'application/octet-stream';
    }
  }

  bool _isVideoFile(String fileName) {
    final extension = path_lib.extension(fileName).toLowerCase();
    return ['.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv'].contains(extension);
  }
}

// Enhanced MediaData class with sortOrder support
class MediaData extends ImageData {
  final bool isVideo;
  final int? fileSize;
  final int sortOrder; // NEW: tracks display/upload order

  MediaData({
    required super.path,
    required super.isFile,
    this.isVideo = false,
    this.fileSize,
    super.fileName,
    super.fileType,
    super.isDeleted,
    super.s3Key,
    super.id,
    this.sortOrder = 0, // NEW
  });

  /// Creates a copy with an updated sortOrder (or other fields)
  @override
  MediaData copyWith({
    String? path,
    bool? isFile,
    bool? isVideo,
    int? fileSize,
    String? fileName,
    String? fileType,
    bool? isDeleted,
    String? s3Key,
    String? id,
    int? sortOrder,
  }) {
    return MediaData(
      path: path ?? this.path,
      isFile: isFile ?? this.isFile,
      isVideo: isVideo ?? this.isVideo,
      fileSize: fileSize ?? this.fileSize,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      isDeleted: isDeleted ?? this.isDeleted,
      s3Key: s3Key ?? this.s3Key,
      id: id ?? this.id,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
