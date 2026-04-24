import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/image_cropper_widget.dart';

class DesignImageGalleryController extends GetxController {
  final RxBool isSameImage = false.obs;
  final RxList<ImageData> imagePaths = <ImageData>[].obs;
  final RxBool isLoading = false.obs;

  void clearControllers() {
    isSameImage.value = false;
    imagePaths.value = [];
  }

  void toggleSameImage() => isSameImage.toggle();

  Future<void> showCropDialog(String imagePath) async {
    final croppedPath = await Get.dialog<String>(
      ImageCropDialog(
        imagePath: imagePath,
        onCropped: (path) => Get.back(result: path),
      ),
      barrierDismissible: false,
    );

    if (croppedPath != null) {
      imagePaths.add(ImageData(path: croppedPath, isFile: true));
    }
  }

  Future<void> pickImage() async {
    try {
      isLoading.value = true;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        for (String? path in result.paths) {
          if (path != null) {
            await showCropDialog(path);
          }
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void removeImage(int index) {
    imagePaths.removeAt(index);
  }

  void populateWithFetchedData(GetDesignResponseModel data) {
    log("populating images : ${data.images}");
    isSameImage.value = data.hasSameImage ?? true;

    // Clear existing image paths
    imagePaths.clear();

    // Add fetched image paths
    if (data.images != null && data.images!.isNotEmpty) {
      // Assuming images is a list of strings representing image URLs or paths
      imagePaths.addAll(
        data.images!.map(
          (img) => ImageData(
            id: img.id,
            path: img.presignedUrl ?? "",
            isFile: false,
            fileName: img.fileName,
            fileType: img.fileType,
            isDeleted: false,
            s3Key: img.s3Key,
          ),
        ),
      );
    }
    log("The images are $imagePaths");
  }
}

class ImageData {
  final String? id;
  final String path;
  final bool isFile;
  final bool isDeleted;
  final String? fileName;
  final String? fileType;
  final String? s3Key;

  ImageData({
    this.id,
    required this.path,
    required this.isFile,
    this.isDeleted = false,
    this.fileName,
    this.fileType,
    this.s3Key,
  });

  ImageData copyWith({bool? isDeleted}) {
    return ImageData(
      id: id,
      path: path,
      isFile: isFile,
      isDeleted: isDeleted ?? this.isDeleted,
      fileName: fileName,
      fileType: fileType,
      s3Key: s3Key,
    );
  }
}
