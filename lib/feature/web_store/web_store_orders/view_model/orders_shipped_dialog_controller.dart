import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/image_cropper_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view_model/webstore_orders_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';

import '../../catalogue/add_new_catalogue/model/catalog_images_presigned_url_request.dart';
import '../../catalogue/add_new_catalogue/model/image_data.dart';

class OrdersShippedDialogController extends GetxController {
  final WebstoreRepository _webstoreRepository = WebstoreRepository();

  final RxList<ImageData> images = <ImageData>[].obs;
  final TextEditingController companyController = TextEditingController();
  final TextEditingController trackingNumberController =
      TextEditingController();
  final RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    companyController.dispose();
    trackingNumberController.dispose();
    super.onClose();
  }

  Future<void> showCropDialog(String imagePath) async {
    final croppedPath = await Get.dialog<String>(
      ImageCropDialog(
        imagePath: imagePath,
        onCropped: (path) => Get.back(result: path),
      ),
      barrierDismissible: false,
    );

    if (croppedPath != null) {
      images.add(ImageData(path: croppedPath, isFile: true));
    }
  }

  Future<void> pickImage() async {
    try {
      isLoading.value = true;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        for (String? path in result.paths) {
          if (path != null) {
            await showCropDialog(path);
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void removeImage(int index) {
    if (index < images.length) {
      images.removeAt(index);
    }
  }

  Future<void> saveShippingDetails(String? selectedOrderId) async {
    final WebStoreOrdersViewModel webStoreOrdersViewModel =
        Get.put<WebStoreOrdersViewModel>(WebStoreOrdersViewModel());

    // Validate inputs
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        // Step 1: Prepare image metadata for presigned URL request
        final newImages =
            images.where((img) => img.isFile && !img.isDeleted).map((
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

        // Step 2: Get presigned URLs from backend
        final presignedRequest = CatalogImagesPresignedUrlRequest(
          groupId: webStoreOrdersViewModel.selectedOrder?.orderId,
          images: newImages,
        );

        final presignedResponse = await _webstoreRepository
            .shippingStatusImagePresignedUrl(presignedRequest);

        // Step 3: Upload actual image files to presigned URLs
        int index = 0;
        for (var imageResponse in presignedResponse.images ?? []) {
          try {
            final imageData =
                images
                    .where((img) => img.isFile && !img.isDeleted)
                    .toList()[index];

            // Upload image to S3 using presigned URL
            await _webstoreRepository.putShippingImages(
              putUrl: imageResponse.presignedUrl ?? "",
              imagePath: imageData.path,
            );

            index++;
            debugPrint("Image uploaded successfully: ${imageData.path}");
          } catch (e) {
            debugPrint("Error uploading image: $e");
            rethrow;
          }
        }

        // Step 4: Prepare image metadata for status change API
        List<ImageRequestModel> imageRequests =
            presignedResponse.images!.map((imageData) {
              return ImageRequestModel(
                fileName: imageData.fileName,
                fileType: imageData.fileType,
                s3_key: imageData.s3Key,
              );
            }).toList();

        // Step 5: Call status change API with uploaded image metadata
        final result = await webStoreOrdersViewModel.onWebStoreStatusChange(
          selectedOrderId: selectedOrderId,
          status: "2",
          shippedData: {
            "images": imageRequests.map((v) => v.toJson()).toList(),
            "company": companyController.text,
            "tracking_number": trackingNumberController.text,
          },
        );

        // Success handling
        if (result != null && result) {
          Get.back();
          Get.snackbar(
            'Success',
            'Order has been marked as shipped',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.7),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        debugPrint('Error in saveShippingDetails: $e');
        Get.snackbar(
          'Error',
          'Failed to upload shipping images: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Form validation methods
  String? validateCompany(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter shipping company name';
    }
    return null;
  }

  String? validateTrackingNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter tracking number';
    }
    return null;
  }
}
