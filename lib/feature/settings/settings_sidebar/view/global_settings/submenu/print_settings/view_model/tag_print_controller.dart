import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/tag_print/get_tag_print_template_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/tag_print/update_tag_print_template_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class TagPrintController extends GetxController {
  final leftSideSelectedCount = 0.obs;
  final rightSideSelectedCount = 0.obs;

  final InventoryRepository inventoryRepository = InventoryRepository();
  final getTagPrintTemplateResponse =
      Rx<ApiResponse<GetTagPrintTemplateResponse>>(
        ApiResponse.initial("Initial"),
      );
  final isUpdating = false.obs;

  final leftDesignName = false.obs;
  final leftVender = false.obs;
  final leftTagNo = false.obs;
  final leftStoneWeight = false.obs;
  final leftGrossWeight = true.obs;
  final leftNetWeight = true.obs;
  final leftPurity = false.obs;
  final leftVAInPercent = false.obs;
  final leftDesignNo = false.obs;
  final leftSize = false.obs;
  final leftHUID = false.obs;
  final leftBarcodeNumber = true.obs;

  final rightDesignName = false.obs;
  final rightVender = false.obs;
  final rightTagNo = false.obs;
  final rightStoneWeight = false.obs;
  final rightGrossWeight = false.obs;
  final rightNetWeight = false.obs;
  final rightPurity = true.obs;
  final rightVAInPercent = false.obs;
  final rightDesignNo = false.obs;
  final rightSize = false.obs;
  final rightHUID = false.obs;
  final rightBarcodeNumber = true.obs;

  // Focus nodes for each toggle option
  // Left side
  final leftDesignNameFocusNode = FocusNode();
  final leftVenderFocusNode = FocusNode();
  final leftTagNoFocusNode = FocusNode();
  final leftStoneWeightFocusNode = FocusNode();
  final leftGrossWeightFocusNode = FocusNode();
  final leftNetWeightFocusNode = FocusNode();
  final leftPurityFocusNode = FocusNode();
  final leftVAFocusNode = FocusNode();
  final leftDesignNoFocusNode = FocusNode();
  final leftSizeFocusNode = FocusNode();
  final leftHUIDFocusNode = FocusNode();
  final leftBarcodeNumberFocusNode = FocusNode();

  // Right side
  final rightDesignNameFocusNode = FocusNode();
  final rightVenderFocusNode = FocusNode();
  final rightTagNoFocusNode = FocusNode();
  final rightStoneWeightFocusNode = FocusNode();
  final rightGrossWeightFocusNode = FocusNode();
  final rightNetWeightFocusNode = FocusNode();
  final rightPurityFocusNode = FocusNode();
  final rightVAFocusNode = FocusNode();
  final rightDesignNoFocusNode = FocusNode();
  final rightSizeFocusNode = FocusNode();
  final rightHUIDFocusNode = FocusNode();
  final rightBarcodeNumberFocusNode = FocusNode();

  // FIXED: Helper method with correct label mapping
  FocusNode getFocusNodeForOption(String label, {required bool isLeft}) {
    if (isLeft) {
      switch (label) {
        case 'Design Name':
          return leftDesignNameFocusNode;
        case 'Vender':
          return leftVenderFocusNode;
        case 'Tag No':
          return leftTagNoFocusNode;
        case 'Stone Weight':
          return leftStoneWeightFocusNode;
        case 'Gross Weight':
          return leftGrossWeightFocusNode;
        case 'Net Weight':
          return leftNetWeightFocusNode;
        case 'Purity':
          return leftPurityFocusNode;
        case 'VA':
          return leftVAFocusNode;
        case 'Size':
          return leftSizeFocusNode;
        case 'HUID':
          return leftHUIDFocusNode;
        case 'Barcode Number':
          return leftBarcodeNumberFocusNode;
        default:
          return leftDesignNoFocusNode;
      }
    } else {
      switch (label) {
        case 'Design Name':
          return rightDesignNameFocusNode;
        case 'Vender':
          return rightVenderFocusNode;
        case 'Tag No':
          return rightTagNoFocusNode;
        case 'Stone Weight':
          return rightStoneWeightFocusNode;
        case 'Gross Weight':
          return rightGrossWeightFocusNode;
        case 'Net Weight':
          return rightNetWeightFocusNode;
        case 'Purity':
          return rightPurityFocusNode;
        case 'VA':
          return rightVAFocusNode;
        case 'Size':
          return rightSizeFocusNode;
        case 'HUID':
          return rightHUIDFocusNode;
        case 'Barcode Number':
          return rightBarcodeNumberFocusNode;
        default:
          return rightDesignNoFocusNode;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getTagPrintTemplateData().then((_) {
      if (getTagPrintTemplateResponse.value.status == Status.COMPLETED) {
        updateLeftSideCount();
        updateRightSideCount();
      }
    });
  }

  @override
  void onClose() {
    // Dispose all focus nodes
    leftDesignNameFocusNode.dispose();
    leftVenderFocusNode.dispose();
    leftTagNoFocusNode.dispose();
    leftGrossWeightFocusNode.dispose();
    leftNetWeightFocusNode.dispose();
    leftPurityFocusNode.dispose();
    leftVAFocusNode.dispose();
    leftDesignNoFocusNode.dispose();
    leftSizeFocusNode.dispose();
    leftStoneWeightFocusNode.dispose();
    leftHUIDFocusNode.dispose();
    leftBarcodeNumberFocusNode.dispose();

    rightDesignNameFocusNode.dispose();
    rightVenderFocusNode.dispose();
    rightTagNoFocusNode.dispose();
    rightStoneWeightFocusNode.dispose();
    rightGrossWeightFocusNode.dispose();
    rightNetWeightFocusNode.dispose();
    rightPurityFocusNode.dispose();
    rightVAFocusNode.dispose();
    rightDesignNoFocusNode.dispose();
    rightSizeFocusNode.dispose();
    rightStoneWeightFocusNode.dispose();
    rightHUIDFocusNode.dispose();
    rightBarcodeNumberFocusNode.dispose();

    super.onClose();
  }

  // Method to fetch tag print template data
  Future<void> getTagPrintTemplateData() async {
    try {
      getTagPrintTemplateResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getTagPrintTemplate();
      getTagPrintTemplateResponse.value = ApiResponse.completed(response);

      // Update the UI with the fetched data
      updateUIWithTemplateData(response);
    } catch (e) {
      log('Error fetching tag print template: $e');
      getTagPrintTemplateResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load tag print template");
    }
  }

  // Update UI with the data from the API
  void updateUIWithTemplateData(GetTagPrintTemplateResponse data) {
    // Map API response fields to controller fields
    leftDesignName.value = data.leftDesignName ?? false;
    leftVender.value = data.leftVendor ?? false;
    leftTagNo.value = data.leftTagNumber ?? false;
    leftStoneWeight.value = data.leftStoneWeight ?? false;
    leftGrossWeight.value = data.leftGrossWeight ?? false;
    leftNetWeight.value = data.leftNetWeight ?? false;
    leftPurity.value = data.leftPurity ?? false;
    leftVAInPercent.value = data.leftVaTypeGms ?? false;
    leftSize.value = data.leftSize ?? false;
    leftDesignNo.value = data.leftDesignName ?? false;
    leftHUID.value = data.leftHuid ?? false;
    leftBarcodeNumber.value = data.leftBarcodeNumber ?? false;

    // Update right side options
    rightDesignName.value = data.rightDesignName ?? false;
    rightVender.value = data.rightVendor ?? false;
    rightTagNo.value = data.rightTagNumber ?? false;
    rightStoneWeight.value = data.rightStoneWeight ?? false;
    rightGrossWeight.value = data.rightGrossWeight ?? false;
    rightNetWeight.value = data.rightNetWeight ?? false;
    rightPurity.value = data.rightPurity ?? false;
    rightVAInPercent.value = data.rightVaTypeGms ?? false;
    rightSize.value = data.rightSize ?? false;
    rightDesignNo.value = data.rightDesignName ?? false;
    rightHUID.value = data.rightHuid ?? false;
    rightBarcodeNumber.value = data.rightBarcodeNumber ?? false;

    // Update counts after setting values
    updateLeftSideCount();
    updateRightSideCount();
  }

  UpdateTagPrintTemplateRequest createUpdateRequest() {
    return UpdateTagPrintTemplateRequest(
      leftDesignName: leftDesignName.value,
      leftVendor: leftVender.value,
      leftTagNumber: leftTagNo.value,
      leftStoneWeight: leftStoneWeight.value,
      leftGrossWeight: leftGrossWeight.value,
      leftNetWeight: leftNetWeight.value,
      leftPurity: leftPurity.value,
      leftVaTypeGms: leftVAInPercent.value,
      leftSize: leftSize.value,
      leftHuid: leftHUID.value,
      leftBarcodeNumber: leftBarcodeNumber.value,
      rightDesignName: rightDesignName.value,
      rightVendor: rightVender.value,
      rightTagNumber: rightTagNo.value,
      rightStoneWeight: rightStoneWeight.value,
      rightGrossWeight: rightGrossWeight.value,
      rightNetWeight: rightNetWeight.value,
      rightPurity: rightPurity.value,
      rightVaTypeGms: rightVAInPercent.value,
      rightSize: rightSize.value,
      rightHuid: rightHUID.value,
      rightBarcodeNumber: rightBarcodeNumber.value,
    );
  }

  Future<void> updateTagPrintTemplate() async {
    try {
      isUpdating.value = true;

      final request = createUpdateRequest();
      await inventoryRepository.updateTagPrintTemplate(request);

      showSuccessToast(message: "Tag print template updated successfully");
    } catch (e) {
      log('Error updating tag print template: $e');
      showErrorToast(message: "Failed to update tag print template");
    } finally {
      isUpdating.value = false;
    }
  }

  // Method to count active left side options
  void updateLeftSideCount() {
    leftSideSelectedCount.value = 0;
    if (leftDesignName.value) leftSideSelectedCount.value++;
    if (leftVender.value) leftSideSelectedCount.value++;
    if (leftTagNo.value) leftSideSelectedCount.value++;
    if (leftStoneWeight.value) leftSideSelectedCount.value++;
    if (leftGrossWeight.value) leftSideSelectedCount.value++;
    if (leftNetWeight.value) leftSideSelectedCount.value++;
    if (leftPurity.value) leftSideSelectedCount.value++;
    if (leftVAInPercent.value) leftSideSelectedCount.value++;
    if (leftDesignNo.value) leftSideSelectedCount.value++;
    if (leftSize.value) leftSideSelectedCount.value++;
    if (leftStoneWeight.value) leftSideSelectedCount.value++;
    if (leftHUID.value) leftSideSelectedCount.value++;
    if (leftBarcodeNumber.value) leftSideSelectedCount.value++;
  }

  // Method to count active right side options
  void updateRightSideCount() {
    rightSideSelectedCount.value = 0;
    if (rightDesignName.value) rightSideSelectedCount.value++;
    if (rightVender.value) rightSideSelectedCount.value++;
    if (rightTagNo.value) rightSideSelectedCount.value++;
    if (rightStoneWeight.value) rightSideSelectedCount.value++;
    if (rightGrossWeight.value) rightSideSelectedCount.value++;
    if (rightNetWeight.value) rightSideSelectedCount.value++;
    if (rightPurity.value) rightSideSelectedCount.value++;
    if (rightVAInPercent.value) rightSideSelectedCount.value++;
    if (rightDesignNo.value) rightSideSelectedCount.value++;
    if (rightSize.value) rightSideSelectedCount.value++;
    if (rightStoneWeight.value) rightSideSelectedCount.value++;
    if (rightHUID.value) rightSideSelectedCount.value++;
    if (rightBarcodeNumber.value) rightSideSelectedCount.value++;
  }

  void resetAllFields() {
    // Reset left side options
    leftDesignName.value = false;
    leftVender.value = false;
    leftTagNo.value = false;
    leftStoneWeight.value = false;
    leftGrossWeight.value = false;
    leftNetWeight.value = false;
    leftPurity.value = false;
    leftVAInPercent.value = false;
    leftDesignNo.value = false;
    leftSize.value = false;
    leftStoneWeight.value = false;
    leftHUID.value = false;
    leftBarcodeNumber.value = false;

    // Reset right side options
    rightDesignName.value = false;
    rightVender.value = false;
    rightTagNo.value = false;
    rightStoneWeight.value = false;
    rightGrossWeight.value = false;
    rightNetWeight.value = false;
    rightPurity.value = false;
    rightVAInPercent.value = false;
    rightDesignNo.value = false;
    rightSize.value = false;
    rightStoneWeight.value = false;
    rightHUID.value = false;
    rightBarcodeNumber.value = false;

    // Update counters
    updateLeftSideCount();
    updateRightSideCount();
  }

  // Toggle left side option with limit check
  void toggleLeftOption(RxBool option, bool value) {
    // If turning on and already at limit, prevent toggle
    if (value && leftSideSelectedCount.value >= 3 && !option.value) {
      showErrorToast(
        message:
            "You can choose up to 3 details per side to be printed on the tag",
      );
      return;
    }

    option.value = value;
    updateLeftSideCount();
  }

  void toggleRightOption(RxBool option, bool value) {
    if (value && rightSideSelectedCount.value >= 3 && !option.value) {
      showErrorToast(
        message:
            "You can choose up to 3 details per side to be printed on the tag",
      );
      return;
    }

    option.value = value;
    updateRightSideCount();
  }
}
