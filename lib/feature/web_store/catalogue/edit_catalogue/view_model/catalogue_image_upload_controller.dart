import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/image_cropper_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/catalog_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/create_catalogue_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/image_data.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class ImageUploadController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final RxList<ImageData> imagePaths = <ImageData>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxBool isUploading = false.obs;

  // Image handling methods
  void selectImage(int index) {
    if (index >= 0 && index < imagePaths.length) {
      selectedImageIndex.value = index;
    }
  }

  // Modify ImageUploadController to include cropping functionality
  Future<void> pickImage() async {
    log("Picking image for catalogue");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'mp4'],
      allowMultiple: true,
    );
    log("Picking image result: $result");

    if (result != null) {
      List<String> paths = result.paths.whereType<String>().toList();

      for (String filePath in paths) {
        // Check if it's an image file (not video)
        String extension = path.extension(filePath).toLowerCase();
        if (['.jpg', '.jpeg', '.png'].contains(extension)) {
          // Show crop dialog for each image
          final croppedPath = await Get.dialog(
            ImageCropDialog(
              imagePath: filePath,
              onCropped: (path) => Get.back(result: path),
            ),
            barrierDismissible: false,
          );

          if (croppedPath != null) {
            // Add cropped image to list
            imagePaths.add(
              ImageData(
                path: croppedPath,
                isFile: true,
                fileName: path.basenameWithoutExtension(croppedPath),
                fileType: extension.replaceAll('.', ''),
              ),
            );
          }
        } else {
          // For non-image files (SVG, MP4), add directly without cropping
          File file = File(filePath);
          int fileSize = await file.length();
          double maxSizeInBytes = 5 * 1024 * 1024;

          if (fileSize <= maxSizeInBytes) {
            imagePaths.add(
              ImageData(
                path: filePath,
                isFile: true,
                fileName: path.basenameWithoutExtension(filePath),
                fileType: extension.replaceAll('.', ''),
              ),
            );
          }
        }
      }
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < imagePaths.length) {
      imagePaths.removeAt(index);
      if (imagePaths.isEmpty) {
        selectedImageIndex.value = 0;
      } else if (selectedImageIndex.value >= imagePaths.length) {
        selectedImageIndex.value = imagePaths.length - 1;
      }
    }
  }

  void clearImages() {
    imagePaths.clear();
    selectedImageIndex.value = 0;
  }

  void populateWithFetchedData(List<String> imageUrls) {
    imagePaths.clear();
    if (imageUrls.isNotEmpty) {
      imagePaths.addAll(
        imageUrls.map((url) => ImageData(path: url, isFile: false)),
      );
      selectedImageIndex.value = 0;
    }
  }

  Future<List<CreateCatalogueImage>> uploadImages({
    required String catalogId,
  }) async {
    try {
      isUploading.value = true;

      final newImages =
          imagePaths.where((img) => img.isFile && !img.isDeleted).map((
            imageData,
          ) {
            final filePath = imageData.path;
            final extension = path.extension(filePath).replaceAll(".", "");
            final fileName = path
                .basenameWithoutExtension(filePath)
                .replaceAll(" ", "_");

            return CatalogImagePresigned(
              fileName: fileName,
              fileType: extension,
            );
          }).toList();

      if (newImages.isEmpty) {
        return [];
      }

      // Get presigned URLs for new images
      final presignedRequest = CatalogImagesPresignedUrlRequest(
        groupId: catalogId,
        images: newImages,
      );

      final presignedResponse = await _inventoryRepository
          .catalogImagePresignedUrl(presignedRequest);

      // Upload images to S3 using presigned URLs
      int index = 0;
      for (var element
          in presignedResponse.images ?? <CatalogImagePresigned>[]) {
        try {
          final image =
              imagePaths
                  .where((img) => img.isFile && !img.isDeleted)
                  .toList()[index];

          await _inventoryRepository.putCatalogImages(
            putUrl: element.presignedUrl ?? "",
            imagePath: image.path,
          );
          index++;
        } catch (e) {
          log("Error uploading image to S3: $e");
          rethrow;
        }
      }

      // Convert to final Image objects for create catalog request
      return presignedResponse.images
              ?.map(
                (img) => CreateCatalogueImage(
                  id: img.id,
                  fileName: img.fileName,
                  fileType: img.fileType,
                  s3Key: img.s3Key,
                  presignedUrl: img.presignedUrl,
                ),
              )
              .toList() ??
          [];
    } catch (e) {
      log("Error in uploadImages: $e");
      rethrow;
    } finally {
      isUploading.value = false;
    }
  }
}
