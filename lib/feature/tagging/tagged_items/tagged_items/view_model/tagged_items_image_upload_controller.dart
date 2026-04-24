import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/image_cropper_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_tagged_item_by_id_response.dart';

class TaggedItemDetailsImageUploadController extends GetxController {
  // Maps line item ID to its images
  final RxMap<String, RxList<ImageData>> lineItemImages =
      <String, RxList<ImageData>>{}.obs;

  // Currently selected line item ID
  final RxString currentLineItemId = "".obs;

  // Get images for current line item
  RxList<ImageData> get imagePaths =>
      lineItemImages[currentLineItemId.value] ?? <ImageData>[].obs;
  final RxBool isLoading = false.obs;

  void clearControllers() {
    lineItemImages.clear();
    currentLineItemId.value = "";
  }

  // void toggleSameImage() => isSameImage.toggle();

  Future<void> showCropDialog(String imagePath) async {
    final croppedPath = await Get.dialog<String>(
      ImageCropDialog(
        imagePath: imagePath,
        onCropped: (path) => Get.back(result: path),
      ),
      barrierDismissible: false,
    );

    if (croppedPath != null) {
      lineItemImages[currentLineItemId.value]?.add(
        ImageData(path: croppedPath, isFile: true),
      );
    }
  }

  Future<void> pickImage() async {
    try {
      if (currentLineItemId.value.isEmpty) return;
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
    // Remove from specific line item
    if (currentLineItemId.value.isNotEmpty &&
        lineItemImages[currentLineItemId.value] != null &&
        index < lineItemImages[currentLineItemId.value]!.length) {
      lineItemImages[currentLineItemId.value]!.removeAt(index);
    }
  }

  void populateWithFetchedData(GetTaggedItemsByIdResponseLineItem? itemData) {
    if (itemData == null || itemData.id == null) return;

    // Set current line item ID
    currentLineItemId.value = itemData.id!;

    // Initialize if not exists
    if (!lineItemImages.containsKey(itemData.id)) {
      lineItemImages[itemData.id!] = <ImageData>[].obs;
    }

    // Clear existing images for this line item
    lineItemImages[itemData.id!]?.clear();

    // Add existing images from API
    if (itemData.images != null) {
      for (var image in itemData.images!) {
        lineItemImages[itemData.id!]?.add(
          ImageData(
            path: image.presignedUrl ?? "",
            isFile: false,
            fileName: image.fileName ?? "",
            fileType: image.fileType ?? "",
            s3Key: image.s3Key ?? "",
          ),
        );
      }
    }
  }

  // Get image paths for a specific line item
  List<ImageData> getImagesForLineItem(String lineItemId) {
    return lineItemImages[lineItemId]?.toList() ?? [];
  }
}
