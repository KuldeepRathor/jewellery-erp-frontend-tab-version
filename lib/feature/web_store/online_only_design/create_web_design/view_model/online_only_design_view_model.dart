import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart'
    hide Category, MetalType;
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_images_upload_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_post_response_models.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart'
    hide MetalType;
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/edit_webstore_stock_by_id_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/get_stock_head_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/get_webstore_stock_by_id_response.dart'
    hide Category;
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/webstore_stock_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view_model/online_only_design_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view_model/online_only_design_table_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class OnlineOnlyDesignViewModel extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final SidebarController sidebarController = Get.find<SidebarController>();
  OnlineOnlyDesignDetailsController designDetailsController = Get.put(
    OnlineOnlyDesignDetailsController(),
  );

  final postDesignResponse = Rx<ApiResponse<PostDesignResponseModel>>(
    ApiResponse.initial("Initial"),
  );
  final postDesignImagesResponse = Rx<ApiResponse<ImagesUploadResponse>>(
    ApiResponse.initial("Initial"),
  );
  final updateDesignResponse = Rx<ApiResponse<PostDesignResponseModel>>(
    ApiResponse.initial("Initial"),
  );
  final getDesignByIdResponse = Rx<ApiResponse<GetDesignResponseModel>>(
    ApiResponse.initial("Initial"),
  );

  // Add response for webstore stock creation
  final createWebstoreStockResponse = Rx<ApiResponse<dynamic>>(
    ApiResponse.initial("Initial"),
  );

  // Add response for webstore stock fetch and edit
  final getWebstoreStockByIdResponse =
      Rx<ApiResponse<GetWebstoreStockByIdResponse>>(
        ApiResponse.initial("Initial"),
      );
  final editWebstoreStockResponse = Rx<ApiResponse<dynamic>>(
    ApiResponse.initial("Initial"),
  );

  bool isDesignDetailsValid({
    required OnlineOnlyDesignDetailsController designDetailsController,
  }) {
    if (designDetailsController.selectedOrnament.value == null ||
        designDetailsController.selectedStockHead.value == null) {
      showErrorToast(message: "Please select Ornament Type and Stock Head");
      return false;
    }
    return true;
  }

  // Add method to fetch webstore stock by ID
  Future<void> getWebstoreStockById({
    required String id,
    required OnlineOnlyTableController tableMakingChargesController,
    required OnlineOnlyDesignDetailsController designDetailsController,
    required DesignImageGalleryController designImageGalleryController,
  }) async {
    try {
      getWebstoreStockByIdResponse.value = ApiResponse.loading(
        "Loading webstore stock...",
      );

      final response = await _inventoryRepository.getWebstoreStockById(id);
      getWebstoreStockByIdResponse.value = ApiResponse.completed(response);

      // Populate controllers with fetched data
      _populateControllersWithWebstoreStock(
        data: response,
        tableMakingChargesController: tableMakingChargesController,
        designDetailsController: designDetailsController,
        designImageGalleryController: designImageGalleryController,
      );
    } catch (e, s) {
      log("Error fetching webstore stock: ${e.toString()}\nStack: $s");

      final handledError = handleDTOResponseErrors(e);
      getWebstoreStockByIdResponse.value = ApiResponse.error(
        handledError.message,
      );

      showErrorToast(
        message:
            getWebstoreStockByIdResponse.value.message ??
            "Failed to fetch webstore stock",
      );
    }
  }

  void _populateControllersWithWebstoreStock({
    required GetWebstoreStockByIdResponse data,
    required OnlineOnlyTableController tableMakingChargesController,
    required OnlineOnlyDesignDetailsController designDetailsController,
    required DesignImageGalleryController designImageGalleryController,
  }) {
    // Populate design details
    designDetailsController.titleNameController.text = data.title ?? '';
    designDetailsController.descriptionController.text = data.description ?? '';

    // Set selected ornament
    if (data.ornament != null) {
      designDetailsController
          .selectedOrnament
          .value = GetAllOrnamentsResponseValue(
        id: data.ornament!.id,
        name: data.ornament!.name,
        code: data.ornament!.code,
      );
    }

    // if (data.description != null && data.description!.isNotEmpty) {
    //   designDetailsController.setDescriptionFromJson(data.description!);
    // }
    // Set selected stock head
    if (data.stockHead != null) {
      // Create a GetStockHeadDropdownValue from the webstore data
      designDetailsController
          .selectedStockHead
          .value = GetStockHeadDropdownValue(
        id: data.stockHead!.id,
        name: data.stockHead!.name,
        code: data.stockHead!.code,
        category:
            data.stockHead!.category != null
                ? Category(
                  id: data.stockHead!.category!.id,
                  categoryName: data.stockHead!.category!.categoryName,
                )
                : null,
        metalType:
            data.stockHead!.metalType != null
                ? MetalType(
                  id: data.stockHead!.metalType!.id,
                  typeName: data.stockHead!.metalType!.typeName,
                )
                : null,
      );

      designDetailsController.stockHeadController.text =
          data.stockHead!.name ?? "";
      designDetailsController.categoryController.text =
          data.stockHead!.category?.categoryName ?? "";
    }
    // Populate images
    if (data.images != null && data.images!.isNotEmpty) {
      designImageGalleryController.imagePaths.clear();
      designImageGalleryController.imagePaths.addAll(
        data.images!.map(
          (img) => ImageData(
            id: img.id,
            path: img.presignedUrl ?? "",
            isFile: false,
            fileName: img.fileName,
            fileType: img.fileType,
            s3Key: img.s3Key,
          ),
        ),
      );
    }

    // Populate table data
    tableMakingChargesController.clearControllers(shouldAddRow: false);
    if (data.lineItems != null && data.lineItems!.isNotEmpty) {
      for (var lineItem in data.lineItems!) {
        final row = OnlineOnlyTableData(
          id: lineItem.id ?? "",
          pcs: TextEditingController(
            text: lineItem.currentPieces?.toString() ?? '',
          ),
          weightPc: TextEditingController(
            text: lineItem.weight?.toString() ?? '',
          ),
          size: TextEditingController(text: lineItem.size?.toString() ?? ''),
          amountPc: TextEditingController(
            text: lineItem.amount?.toString() ?? '',
          ),
          undiscountedAmount: TextEditingController(
            text: lineItem.undiscountedAmount?.toString() ?? '',
          ),
        );
        tableMakingChargesController.controllers.add(row);
      }
      tableMakingChargesController.updateTotals();
    } else {
      tableMakingChargesController.addRow();
    }
  }

  // Add method to edit webstore stock
  Future<void> editWebstoreStock({
    required String id,
    required OnlineOnlyTableController tableMakingChargesController,
    required OnlineOnlyDesignDetailsController designDetailsController,
    required DesignImageGalleryController designImageGalleryController,
  }) async {
    try {
      // final plainText =
      //     designDetailsController.descriptionQuillController.document
      //         .toPlainText()
      //         .trim();

      // if (plainText.isEmpty) {
      //   showErrorToast(message: 'Description is required');
      //   return;
      // }

      // Get rich text as JSON
      // final descriptionJson = designDetailsController.getDescriptionAsJson();

      // Validate design details form
      bool? designDetailsValidation =
          designDetailsController.formKey.currentState?.validate();
      if (designDetailsValidation == false || designDetailsValidation == null) {
        return;
      }

      // Validate ornament and stock head selection
      bool isValid = isDesignDetailsValid(
        designDetailsController: designDetailsController,
      );
      if (!isValid) {
        return;
      }

      // Validate table
      if (!_validateTable(tableMakingChargesController)) {
        return;
      }

      // Show loading state
      editWebstoreStockResponse.value = ApiResponse.loading(
        "Updating webstore stock...",
      );

      // Upload new images
      final newImageList = await uploadImages(
        designImageGalleryController: designImageGalleryController,
      );

      // Combine new and existing images
      final existingImages =
          designImageGalleryController.imagePaths
              .where((img) => !img.isFile)
              .map(
                (img) => WebstoreStockImage(
                  id: img.id,
                  fileName: img.fileName,
                  fileType: img.fileType,
                  s3Key: img.s3Key,
                ),
              )
              .toList();

      final allImages = [
        ...newImageList.map(
          (img) => WebstoreStockImage(
            fileName: img.fileName,
            fileType: img.fileType,
            s3Key: img.s3_key,
          ),
        ),
        ...existingImages,
      ];

      // Convert table data to line items
      final lineItems =
          tableMakingChargesController.controllers.asMap().entries.map((entry) {
            final row = entry.value;
            return WebstoreStockLineItem(
              purity: null,
              currentPieces: int.tryParse(row.pcs.text),
              weight: double.tryParse(row.weightPc.text)?.toInt(),
              size: (row.size.text),
              amount: double.tryParse(row.amountPc.text)?.toInt(),
              undiscountedAmount:
                  double.tryParse(row.undiscountedAmount.text)?.toInt(),
            );
          }).toList();

      // Create request using WebstoreStockRequest (as per your requirement)
      final request = WebstoreStockRequest(
        title: designDetailsController.titleNameController.text.trim(),
        // description: descriptionJson,
        stockHeadId: designDetailsController.selectedStockHead.value?.id,
        ornamentId: designDetailsController.selectedOrnament.value?.id,
        images: allImages,
        lineItems: lineItems,
      );

      log("Editing webstore stock with request: ${request.toRawJson()}");

      // Make API call using the edit endpoint
      final response = await _inventoryRepository.editWebstoreStockById(
        EditWebstoreStockByIdRequest(
          title: request.title,
          description: request.description,
          stockHeadId: request.stockHeadId,
          ornamentId: request.ornamentId,
          images:
              request.images
                  ?.map(
                    (img) => EditWebstoreStockByIdImage(
                      id: img.id,
                      fileName: img.fileName,
                      fileType: img.fileType,
                      s3Key: img.s3Key,
                    ),
                  )
                  .toList(),
          lineItems:
              request.lineItems
                  ?.asMap()
                  .entries
                  .map(
                    (entry) => EditWebstoreStockByIdLineItem(
                      key: entry.key.toString(),
                      purity: entry.value.purity,
                      currentPieces: entry.value.currentPieces,
                      weight: entry.value.weight,
                      size: entry.value.size,
                      amount: entry.value.amount,
                      undiscountedAmount: entry.value.undiscountedAmount,
                    ),
                  )
                  .toList(),
        ),
        id,
      );

      // Handle success
      editWebstoreStockResponse.value = ApiResponse.completed(response);

      // Clear all controllers
      _clearAllControllers(
        tableMakingChargesController: tableMakingChargesController,
        designDetailsController: designDetailsController,
        designImageGalleryController: designImageGalleryController,
      );

      showSuccessToast(message: "Webstore stock updated successfully!");
      sidebarController.popBackSelectedWidget();
    } catch (e, s) {
      log("Error editing webstore stock: ${e.toString()}\nStack: $s");

      final handledError = handleDTOResponseErrors(e);
      editWebstoreStockResponse.value = ApiResponse.error(handledError.message);

      showErrorToast(
        message:
            editWebstoreStockResponse.value.message ??
            "Failed to update webstore stock",
      );
    }
  }

  // Helper method to validate table
  bool _validateTable(OnlineOnlyTableController tableMakingChargesController) {
    // Reset current indices to safe values for table validation
    tableMakingChargesController.currentRowIndex.value =
        tableMakingChargesController.controllers.isEmpty
            ? 0
            : tableMakingChargesController.controllers.length - 1;
    tableMakingChargesController.currentColIndex.value = 0;

    if (tableMakingChargesController.controllers.isNotEmpty) {
      tableMakingChargesController
          .controllers[tableMakingChargesController.currentRowIndex.value]
          .tableFocusNodes[tableMakingChargesController.currentColIndex.value]
          .requestFocus();
    }

    // Validate table has at least one row
    if (tableMakingChargesController.controllers.isEmpty) {
      showErrorToast(message: "At least one stock entry is required");
      tableMakingChargesController.addRow();
      return false;
    }

    // Validate table form
    if (!tableMakingChargesController.formKey.currentState!.validate()) {
      showErrorToast(message: "Please fill all required fields in the table");
      return false;
    }

    return true;
  }

  // Existing createWebstoreStock method remains the same...
  Future<void> createWebstoreStock({
    required OnlineOnlyTableController tableMakingChargesController,
    required OnlineOnlyDesignDetailsController designDetailsController,
    required DesignImageGalleryController designImageGalleryController,
  }) async {
    try {
      // final plainText =
      //     designDetailsController.descriptionQuillController.document
      //         .toPlainText()
      //         .trim();

      // if (plainText.isEmpty) {
      //   showErrorToast(message: 'Description is required');
      //   return;
      // }

      // Get rich text as JSON
      // final descriptionJson = designDetailsController.getDescriptionAsJson();

      // Validate design details form
      bool? designDetailsValidation =
          designDetailsController.formKey.currentState?.validate();
      if (designDetailsValidation == false || designDetailsValidation == null) {
        return;
      }

      // Validate ornament and stock head selection
      bool isValid = isDesignDetailsValid(
        designDetailsController: designDetailsController,
      );
      if (!isValid) {
        return;
      }

      // Validate table
      if (!_validateTable(tableMakingChargesController)) {
        return;
      }

      // Wait for widget rebuild
      await Future.delayed(const Duration(milliseconds: 100));

      // Show loading state
      createWebstoreStockResponse.value = ApiResponse.loading(
        "Creating webstore stock...",
      );

      // Upload images first
      final imageList = await uploadImages(
        designImageGalleryController: designImageGalleryController,
      );

      // Convert image list to WebstoreStockImage format
      final webstoreImages =
          imageList
              .map(
                (img) => WebstoreStockImage(
                  fileName: img.fileName,
                  fileType: img.fileType,
                  s3Key: img.s3_key,
                ),
              )
              .toList();

      // Convert table data to WebstoreStockLineItem format
      final lineItems =
          tableMakingChargesController.controllers
              .map(
                (row) => WebstoreStockLineItem(
                  purity: null,
                  currentPieces: int.tryParse(row.pcs.text),
                  weight: double.tryParse(row.weightPc.text)?.toInt(),
                  size: row.size.text,
                  amount: double.tryParse(row.amountPc.text)?.toInt(),
                  undiscountedAmount:
                      double.tryParse(row.undiscountedAmount.text)?.toInt(),
                ),
              )
              .toList();

      // Create request model
      final request = WebstoreStockRequest(
        title: designDetailsController.titleNameController.text.trim(),
        // description: descriptionJson,
        stockHeadId: designDetailsController.selectedStockHead.value?.id,
        ornamentId: designDetailsController.selectedOrnament.value?.id,
        images: webstoreImages,
        lineItems: lineItems,
      );

      log("Creating webstore stock with request: ${request.toRawJson()}");

      // Make API call
      final response = await _inventoryRepository.createWebstoreStock(request);

      // Handle success
      createWebstoreStockResponse.value = ApiResponse.completed(response);

      // Clear all controllers
      _clearAllControllers(
        tableMakingChargesController: tableMakingChargesController,
        designDetailsController: designDetailsController,
        designImageGalleryController: designImageGalleryController,
      );

      showSuccessToast(message: "Webstore stock created successfully!");
      sidebarController.popBackSelectedWidget();
    } catch (e, s) {
      log("Error creating webstore stock: ${e.toString()}\nStack: $s");

      final handledError = handleDTOResponseErrors(e);
      createWebstoreStockResponse.value = ApiResponse.error(
        handledError.message,
      );

      showErrorToast(
        message:
            createWebstoreStockResponse.value.message ??
            "Failed to create webstore stock",
      );
    }
  }

  // Helper method to clear controllers
  void _clearAllControllers({
    required OnlineOnlyTableController tableMakingChargesController,
    required OnlineOnlyDesignDetailsController designDetailsController,
    required DesignImageGalleryController designImageGalleryController,
  }) {
    tableMakingChargesController.clearControllers(shouldAddRow: false);
    designDetailsController.clearControllers();
    designImageGalleryController.clearControllers();

    final remarksController = Get.find<RemarksController>();
    remarksController.designRemarks.value = "";
  }

  Future<List<ImageRequestModel>> uploadImages({
    required DesignImageGalleryController designImageGalleryController,
  }) async {
    postDesignImagesResponse.value = ApiResponse.loading("uploading images");
    try {
      List<ImageRequestModel> images =
          designImageGalleryController.imagePaths
              .toList()
              .where((imageData) => imageData.isFile)
              .map((imageData) {
                final filePath = imageData.path;
                final extension = path.extension(filePath).replaceAll(".", "");
                final fileName = path
                    .basenameWithoutExtension(filePath)
                    .replaceAll(" ", "_");

                return ImageRequestModel(
                  fileName: fileName,
                  fileType: extension,
                  s3_key: "",
                );
              })
              .toList();

      final response = await _inventoryRepository.addDesignImages(
        images: images,
      );

      int index = 0;
      for (var element in response.images ?? <ImageResponseModel>[]) {
        try {
          final image =
              designImageGalleryController.imagePaths
                  .toList()
                  .where((element) => element.isFile)
                  .toList()[index];
          final res = await _inventoryRepository.putDesignImages(
            putUrl: element.presignedUrl ?? "",
            imagePath: image.path,
          );
          index++;
          log("Put response: $res");
        } catch (e) {
          log("Error in uploading put images : $e");
          rethrow;
        }
      }
      final list = response.images ?? [];

      postDesignImagesResponse.value = ApiResponse.completed(response);
      return list
          .map(
            (e) => ImageRequestModel(
              fileName: e.fileName,
              fileType: e.fileType,
              s3_key: e.s3Key,
            ),
          )
          .toList();
    } catch (e, s) {
      log("Error in uploading images : $e, \n $s");
      postDesignImagesResponse.value = ApiResponse.error(e.toString());
      rethrow;
    }
  }
}
