import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_orders_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_images_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view_model/order_listing_viewmodel.dart';
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
  final String? id;
  final String? presignedUrl;

  ImageData({
    required this.path,
    required this.isFile,
    this.isDeleted = false,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.id,
    this.presignedUrl,
  });

  ImageData copyWith({bool? isDeleted}) {
    return ImageData(
      path: path,
      isFile: isFile,
      isDeleted: isDeleted ?? this.isDeleted,
      fileName: fileName,
      fileType: fileType,
      s3Key: s3Key,
      id: id,
      presignedUrl: presignedUrl,
    );
  }
}

class AddDesignDetailsViewModel extends GetxController {
  final EstimationRepository _estimationRepository = EstimationRepository();
  final RxList<ImageData> imagePaths = <ImageData>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxString notes = ''.obs;
  final RxBool isUploading = false.obs;

  final TextEditingController notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Sync the controller with the reactive notes value
    notesController.addListener(() {
      notes.value = notesController.text;
    });
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  void setNotes(String value) {
    notes.value = value;
  }

  Future<List<Image>> uploadImages() async {
    try {
      isUploading.value = true;

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

            return OrderImagePresigned(fileName: fileName, fileType: extension);
          }).toList();

      if (newImages.isEmpty) {
        return [];
      }

      // Get presigned URLs for new images
      final presignedRequest = OrderImagesPresignedUrlRequest(
        service: 'orders',
        group: 'design',
        images: newImages,
      );

      final presignedResponse = await _estimationRepository
          .orderImagePresignedUrl(presignedRequest);

      // Upload images to S3 using presigned URLs
      int index = 0;
      for (var element in presignedResponse.images ?? <OrderImagePresigned>[]) {
        try {
          final image =
              imagePaths
                  .where((img) => img.isFile && !img.isDeleted)
                  .toList()[index];

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
                (img) => Image(
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
    }
  }

  Future<void> saveDesignDetails(String orderLineItemId) async {
    try {
      isUploading.value = true;

      // Upload new images and get their metadata
      final uploadedImages = await uploadImages();

      // Get existing images (non-file images that haven't been deleted)
      final existingImages =
          imagePaths
              .where((img) => !img.isFile && !img.isDeleted && img.id != null)
              .map(
                (img) => Image(
                  id: img.id,
                  fileName: img.fileName,
                  fileType: img.fileType,
                  s3Key: img.s3Key,
                  presignedUrl: img.presignedUrl,
                ),
              )
              .toList();

      // Combine existing and newly uploaded images
      final allImages = [...existingImages, ...uploadedImages];

      // Create final order images request with all images
      final orderImagesRequest = OrderImagesRequest(
        orderLineItemId: orderLineItemId,
        notes: notes.value,
        images: allImages,
      );

      // Save order images
      await _estimationRepository.orderImage(orderImagesRequest);

      Get.back(result: true);
      OrderListingViewModel orderListingViewModel = Get.find();
      orderListingViewModel.getOrdersListing(resetList: true);
      showSuccessToast(message: "Images Updated Successfully");
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

  void populateWithFetchedData(List<String> imageUrls, String? existingNotes) {
    // Clear any references to design images first
    imagePaths.clear();

    if (existingNotes != null && existingNotes.isNotEmpty) {
      notes.value = existingNotes;
      notesController.text = existingNotes;
    }
  }

  void populateWithDesignImages(
    List<DesignImage> designImages,
    String? existingNotes,
  ) {
    imagePaths.clear();
    imagePaths.addAll(
      designImages.map(
        (img) => ImageData(
          path: img.presignedUrl ?? '',
          isFile: false,
          id: img.id,
          fileName: img.fileName,
          fileType: img.fileType,
          s3Key: img.s3Key,
          presignedUrl: img.presignedUrl,
        ),
      ),
    );

    if (existingNotes != null && existingNotes.isNotEmpty) {
      notes.value = existingNotes;
      notesController.text = existingNotes;
    }
  }
}
