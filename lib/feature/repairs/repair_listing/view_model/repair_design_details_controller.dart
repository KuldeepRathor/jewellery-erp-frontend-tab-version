import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view_model/repair_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_images_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:path/path.dart' as path;

class ImageData {
  final String path;
  final bool isFile;
  final bool isDeleted;
  final String? fileName;
  final String? fileType;
  final String? s3Key;

  ImageData({
    required this.path,
    required this.isFile,
    this.isDeleted = false,
    this.fileName,
    this.fileType,
    this.s3Key,
  });

  ImageData copyWith({bool? isDeleted}) {
    return ImageData(
      path: path,
      isFile: isFile,
      isDeleted: isDeleted ?? this.isDeleted,
      fileName: fileName,
      fileType: fileType,
      s3Key: s3Key,
    );
  }
}

class AddRepairDesignDetailsViewModel extends GetxController {
  final EstimationRepository _estimationRepository = EstimationRepository();
  final RxList<ImageData> imagePaths = <ImageData>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxString notes = ''.obs;
  final RxBool isUploading = false.obs;

  void setNotes(String value) {
    notes.value = value;
  }

  Future<List<RepairImage>> uploadImages() async {
    try {
      // Filter only new file images that need to be uploaded
      final newImages =
          imagePaths.where((img) => img.isFile && !img.isDeleted).map((
            imageData,
          ) {
            final filePath = imageData.path;
            final extension = path.extension(filePath).replaceAll(".", "");
            final fileName = path
                .basenameWithoutExtension(filePath)
                .replaceAll(" ", "_");

            return RepairPresignedImage(
              fileName: fileName,
              fileType: extension,
            );
          }).toList();

      if (newImages.isEmpty) {
        return [];
      }

      // Get presigned URLs for new images
      final presignedRequest = RepairImagesPresignedUrlRequest(
        service: 'repairs',
        group: 'design',
        images: newImages,
      );

      final presignedResponse = await _estimationRepository
          .repairImagePresignedUrl(presignedRequest);

      // Upload images to S3 using presigned URLs
      int index = 0;
      for (var element
          in presignedResponse.images ?? <RepairPresignedImage>[]) {
        try {
          final image =
              imagePaths
                  .where((img) => img.isFile && !img.isDeleted)
                  .toList()[index];

          // Add putUrl implementation in EstimationServices similar to orders
          await _estimationRepository.putOrderImages(
            putUrl: element.presignedUrl ?? "",
            imagePath: image.path,
          );
          index++;
        } catch (e) {
          log("Error uploading image to S3: $e");
          rethrow;
        }
      }

      // Convert to final Image objects
      return presignedResponse.images
              ?.map(
                (img) => RepairImage(
                  id: img.id,
                  fileName: img.fileName,
                  fileType: img.fileType,
                  s3Key: img.s3Key,
                ),
              )
              .toList() ??
          [];
    } catch (e) {
      log("Error in uploadImages: $e");
      rethrow;
    }
  }

  Future<void> saveDesignDetails(String repairLineItemId) async {
    try {
      isUploading.value = true;

      // Upload new images and get their metadata
      final uploadedImages = await uploadImages();

      // Create final repair images request
      final repairImagesRequest = RepairImagesRequest(
        repairLineItemId: repairLineItemId,
        notes: notes.value,
        images: uploadedImages,
      );

      // Save repair images
      await _estimationRepository.repairImage(repairImagesRequest);

      Get.back(result: true);
      RepairListingViewmodel repairListingViewModel = Get.find();
      repairListingViewModel.getRepairsListing(resetList: true);
      showSuccessToast(message: "Images Uploaded Successfully");
    } catch (e) {
      log('Error saving design details: $e');
      showErrorToast(message: "Failed to save design details");
    } finally {
      isUploading.value = false;
    }
  }

  void selectImage(int index) {
    if (index >= 0 && index < imagePaths.length) {
      selectedImageIndex.value = index;
    }
  }

  void clearImages() {
    imagePaths.clear();
  }

  Future<void> pickImage() async {
    log("picking image");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    log("picking image result: $result");

    if (result != null) {
      List<String> paths = result.paths.whereType<String>().toList();
      imagePaths.addAll(
        paths.map((path) => ImageData(path: path, isFile: true)),
      );
      if (imagePaths.length == paths.length) {
        // If these were the first images added
        selectedImageIndex.value = 0;
      }
    }
  }

  void removeImage(int index) {
    imagePaths.removeAt(index);
    if (imagePaths.isEmpty) {
      selectedImageIndex.value = 0;
    } else if (selectedImageIndex.value >= imagePaths.length) {
      selectedImageIndex.value = imagePaths.length - 1;
    }
  }

  void populateWithFetchedData(List<String> imageUrls) {
    imagePaths.clear();
    imagePaths.addAll(
      imageUrls.map((url) => ImageData(path: url, isFile: false)),
    );
  }
}
