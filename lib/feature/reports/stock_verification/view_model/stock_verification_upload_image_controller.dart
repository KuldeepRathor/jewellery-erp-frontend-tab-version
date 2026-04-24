import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/stock_verification_report_response.dart'
    hide Image;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/image_data.dart';
// Add this import

class StockVerificationImageUploadController extends GetxController {
  final RxList<ImageData> imagePaths = <ImageData>[].obs;

  void clearControllers() {
    imagePaths.value = [];
  }

  // Update stock_verification_upload_image_controller.dart

  void populateWithStockVerificationData(
    GetStockVerificationReportResponse? data,
  ) {
    log("populating stock verification images from basic data");

    // Clear existing image paths
    imagePaths.clear();

    // Since images aren't in the basic response, we'll need to get them from detailed response
    // This will be called from the view model after fetching details
  }

  // Add new method to populate from detailed response
  void populateWithDetailedData(GetTaggingLineItemResponse? details) {
    log("populating stock verification images from detailed data");

    imagePaths.clear();

    if (details == null) {
      return;
    }

    // Add images from the line item directly (no lineItems array)
    final itemImages = details.images ?? [];
    if (itemImages.isNotEmpty) {
      imagePaths.addAll(
        itemImages.map(
          (img) => ImageData(
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

    // Add images from design
    final designImages = details.design?.images ?? [];
    if (designImages.isNotEmpty) {
      // Handle dynamic images array
      for (var img in designImages) {
        if (img is Image) {
          imagePaths.add(
            ImageData(
              path: img.presignedUrl ?? "",
              isFile: false,
              fileName: img.fileName,
              fileType: img.fileType,
              isDeleted: false,
              s3Key: img.s3Key,
            ),
          );
        } else if (img is String) {
          imagePaths.add(ImageData(path: img, isFile: false));
        }
      }
    }

    log("Stock verification images loaded: ${imagePaths.length} images");
  }

  Future<void> pickImage() async {
    log("picking image for stock verification");
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
    }
  }

  void removeImage(int index) {
    imagePaths.removeAt(index);
  }

  // Helper method to update images when an item is selected
  void updateImagesFromSelectedItem(
    int index,
    List<GetStockVerificationReportResponse>? items,
  ) {
    if (items == null || items.isEmpty || index < 0 || index >= items.length) {
      clearControllers();
      return;
    }

    populateWithStockVerificationData(items[index]);
  }
}
