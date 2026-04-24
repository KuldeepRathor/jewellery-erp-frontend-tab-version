import 'dart:developer';

import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/design_line_item_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/design_making_charge_type_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/post_design_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_images_upload_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_post_response_models.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/update_design_request_models/update_design_line_items_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/update_design_request_models/update_design_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_making_charges_table_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class DesignViewModel extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final SidebarController sidebarController = Get.find<SidebarController>();

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
  bool isDesignDetailsValid({
    required DesignDetailsController designDetailsController,
  }) {
    if (designDetailsController.selectedMetalType.value == null ||
        designDetailsController.selectedStockHead.value == null) {
      showErrorToast(
        message: "Please select Metal Type and Stock Head",
        // alignment: Alignment.center,
      );
      return false;
    }
    // if (!designDetailsController.isCodeAvailable.value) {
    //   showErrorToast(message: "Invalid Design code");
    //   return false;
    // }

    return true;
  }

  Future<void> addDesign({
    required TableMakingChargesController tableMakingChargesController,
    required DesignDetailsController designDetailsController,
    required DesignSettingsController designSettingsController,
    required DesignImageGalleryController designImageGalleryController,
  }) async {
    try {
      bool? designDetailsValidation =
          designDetailsController.formKey.currentState?.validate();
      if (designDetailsValidation == false || designDetailsValidation == null) {
        return;
      }
      bool isValid = isDesignDetailsValid(
        designDetailsController: designDetailsController,
      );
      if (isValid == false) {
        return;
      }

      if (designSettingsController.isTaggingEnabled.value == false) {
        bool? designSettingValidation =
            designSettingsController.formKey.currentState?.validate();
        if (designSettingValidation == false ||
            designSettingValidation == null) {
          showErrorToast(message: "Tag code not unique");
          return;
        }
      }
      // Remove invalid rows before validation
      tableMakingChargesController.controllers.removeWhere(
        (element) =>
            element.purity.text.isEmpty || element.ornamentType.text.isEmpty,
      );
      // Reset current indices to safe values
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

      // If no valid rows remain, show error
      if (tableMakingChargesController.controllers.isEmpty) {
        showErrorToast(
          message: "At least one row with Purity and Ornament is required",
        );
        tableMakingChargesController.addRow();
        return;
      }
      // Wait for the next frame to ensure widget has rebuilt
      await Future.delayed(const Duration(milliseconds: 100));
      if (tableMakingChargesController.formKey.currentState!.validate() ==
          false) {
        showErrorToast(message: "Purity and Ornament is required");
        return;
      }

      final RemarksController remarksController = Get.find<RemarksController>();

      postDesignResponse.value = ApiResponse.loading("Loading Purity");
      final imageList = await uploadImages(
        designImageGalleryController: designImageGalleryController,
      );

      List<DesignLineItemRequestModel> lineItems = [];

      lineItems =
          tableMakingChargesController.controllers
              .map(
                (element) => DesignLineItemRequestModel(
                  purity:
                      element.purityValue?.purityType ?? element.purity.text,
                  minWeight:
                      element.weightRangeMin.text.isEmpty
                          ? null
                          : element.weightRangeMin.text,
                  maxWeight:
                      element.weightRangeMax.text.isEmpty
                          ? null
                          : element.weightRangeMax.text,
                  wastageType: element.vaUnit,
                  wastage: double.tryParse(element.va.text),
                  makingCharges: double.tryParse(element.mc.text),
                  minVa: double.tryParse(element.minVa.text),
                  minMc: double.tryParse(element.minMc.text),
                  makingChargesType: element.mcUnit,
                  ornament: element.ornamentId,
                ),
              )
              .toList();

      PostDesignRequestModel postDesignRequestModel = PostDesignRequestModel(
        remarks: remarksController.designRemarks.value,
        // code: designDetailsController.designCodeController.text.trim(),
        name: designDetailsController.designNameController.text.trim(),
        stockHead: designDetailsController.selectedStockHead.value?.id,
        tagRequired: designSettingsController.isTaggingEnabled.value,
        tagCode:
            designSettingsController.tagCodeController.text.isEmpty
                ? null
                : designSettingsController.tagCodeController.text,
        stoneRequired: designSettingsController.isStoneCostEnabled.value,
        hasSameImage: designImageGalleryController.isSameImage.value,
        makingChargeType: DesignMakingChargeTypeRequestModel(
          id: tableMakingChargesController.selectedOption.value.id,
        ),
        images: imageList,
        lineItems: lineItems,
      );

      log("The post request will be ${postDesignRequestModel.toRawJson()} ");
      final response = await _inventoryRepository.addDesign(
        postDesignRequestModel: postDesignRequestModel,
      );
      log("The post request before completed ");

      postDesignResponse.value = ApiResponse.completed(response);
      log("The post request after completed ");
      tableMakingChargesController.clearControllers(shouldAddRow: false);
      designDetailsController.clearControllers();
      designSettingsController.clearControllers();
      designImageGalleryController.clearControllers();
      remarksController.designRemarks.value = "";
      log("The post request after completed clear controllers ");
      showSuccessToast(message: "Design added Successfully!");
      sidebarController.popBackSelectedWidget();
    } catch (e, s) {
      log("The post request error ${e.toString()} :$s ");
      final handledError = handleDTOResponseErrors(e);
      postDesignResponse.value = ApiResponse.error(handledError.message);
      showErrorToast(
        message: postDesignResponse.value.message ?? "Something went wrong",
      );
    }
  }

  Future<void> getDesignById({
    required String id,
    required TableMakingChargesController tableMakingChargesController,
    required DesignDetailsController designDetailsController,
    required DesignSettingsController designSettingsController,
    required DesignImageGalleryController designImageGalleryController,
  }) async {
    try {
      getDesignByIdResponse.value = ApiResponse.loading("Loading Purity");
      // await Future.delayed(const Duration(seconds: 2));
      final response = await _inventoryRepository.getDesignById(id: id);
      final designData = response;
      designDetailsController.populateWithFetchedData(designData);
      designSettingsController.populateWithFetchedData(designData);
      tableMakingChargesController.populateWithFetchedData(designData);
      designImageGalleryController.populateWithFetchedData(designData);
      getDesignByIdResponse.value = ApiResponse.completed(response);

      // showSuccessToast(message: "Design added Successfully!");
    } catch (e) {
      if (e is ApiException) {
        showErrorToast(message: e.toStringPrefix());
      }
      getDesignByIdResponse.value = ApiResponse.error(e.toString());
    }
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

  Future<void> updateDesign({
    required String id,
    required TableMakingChargesController tableMakingChargesController,
    required DesignDetailsController designDetailsController,
    required DesignSettingsController designSettingsController,
    required DesignImageGalleryController designImageGalleryController,
    required bool changeExistingTags,
  }) async {
    try {
      // bool? designSettingValidation =
      //     designSettingsController.formKey.currentState?.validate();
      // if (designSettingValidation == false || designSettingValidation == null) {
      //   showErrorToast(message: "Tag code not unique");
      //   return;
      // }

      // Remove invalid rows before validation
      tableMakingChargesController.controllers.removeWhere(
        (element) =>
            element.purity.text.isEmpty || element.ornamentType.text.isEmpty,
      );

      // Reset current indices to safe values
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

      // If no valid rows remain, show error
      if (tableMakingChargesController.controllers.isEmpty) {
        showErrorToast(
          message: "At least one row with Purity and Ornament is required",
        );
        tableMakingChargesController.addRow();
        return;
      }

      // Wait for the next frame to ensure widget has rebuilt
      await Future.delayed(const Duration(milliseconds: 100));
      if (tableMakingChargesController.formKey.currentState!.validate() ==
          false) {
        showErrorToast(message: "Purity and Ornament is required");
        return;
      }

      postDesignResponse.value = ApiResponse.loading("Loading Purity");
      final newUploadedImages = await uploadImages(
        designImageGalleryController: designImageGalleryController,
      );

      final oldUploadedImages =
          designImageGalleryController.imagePaths
              .where((img) => img.isFile == false)
              .map(
                (e) => ImageRequestModel(
                  id: e.id,
                  fileName: e.fileName,
                  fileType: e.fileType,
                  s3_key: e.s3Key,
                ),
              )
              .toList();
      final images = newUploadedImages + oldUploadedImages;

      final RemarksController remarksController = Get.find<RemarksController>();

      List<UpdateDesignLineItemRequestModel>? lineItems =
          tableMakingChargesController.controllers
              .where(
                (element) =>
                    element.purity.text.isNotEmpty &&
                    element.ornamentType.text.isNotEmpty,
              )
              .map(
                (element) => UpdateDesignLineItemRequestModel(
                  id: element.id,
                  purity:
                      element.purityValue?.purityType ?? element.purity.text,
                  minWeight:
                      element.weightRangeMin.text.isEmpty
                          ? null
                          : element.weightRangeMin.text,
                  maxWeight:
                      element.weightRangeMax.text.isEmpty
                          ? null
                          : element.weightRangeMax.text,
                  wastageType: element.vaUnit,
                  wastage: element.va.text.isEmpty ? null : element.va.text,
                  makingCharges:
                      element.mc.text.isEmpty ? null : element.mc.text,
                  minVa: element.minVa.text.isEmpty ? null : element.minVa.text,
                  minMc: element.minMc.text.isEmpty ? null : element.minMc.text,
                  makingChargesType: element.mcUnit,
                  ornamentId: element.ornamentId,
                ),
              )
              .toList();

      UpdateDesignRequestModel postDesignRequestModel =
          UpdateDesignRequestModel(
            // code: designDetailsController.designCodeController.text.trim(),
            name: designDetailsController.designNameController.text.trim(),
            stockHeadId: designDetailsController.selectedStockHead.value?.id,
            tagRequired: designSettingsController.isTaggingEnabled.value,
            // tagCode: designSettingsController.tagCodeController.text.isEmpty
            //     ? null
            //     : designSettingsController.tagCodeController.text,
            stoneRequired: designSettingsController.isStoneCostEnabled.value,
            hasSameImage: designImageGalleryController.isSameImage.value,
            remarks: remarksController.designRemarks.value,
            makingChargeType:
                tableMakingChargesController.selectedOption.value.id,
            images: images,
            lineItems: lineItems,
            changeExistingTags: changeExistingTags,
          );
      log("The update request will be ${postDesignRequestModel.toRawJson()} ");
      final response = await _inventoryRepository.updateDesign(
        postDesignRequestModel: postDesignRequestModel,
        id: id,
      );
      postDesignResponse.value = ApiResponse.completed(response);
      tableMakingChargesController.clearControllers(shouldAddRow: false);
      designDetailsController.clearControllers();
      designSettingsController.clearControllers();
      designImageGalleryController.clearControllers();
      if (changeExistingTags == false) {
        showSuccessToast(message: "Design updated successfully!");
      }
      SidebarController sidebarController = Get.find();
      sidebarController.popBackSelectedWidget();
    } catch (e) {
      log("Error update design $e");
      if (e is ApiException) {
        showErrorToast(message: e.toStringPrefix());
      }
      postDesignResponse.value = ApiResponse.error(e.toString());
    }
  }
}
