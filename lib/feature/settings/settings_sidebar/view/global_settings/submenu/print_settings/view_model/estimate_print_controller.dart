import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/estimate_print/get_estimate_print_template_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EstimatePrintController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final isUpdating = false.obs;

  // API response state
  final getEstimatePrintTemplateResponse =
      Rx<ApiResponse<GetEstimatePrintTemplateResponse>>(
        ApiResponse.initial("Initial"),
      );

  // State variables for Estimate Print settings
  final showVAPercentage = RxString(
    'percentage',
  ); // percentage, grams, both, amount, none
  final showVAGrams = RxString(
    'percentage',
  ); // percentage, grams, both, amount, none

  final showMCTotalSum = true.obs;
  final showVendorCode = true.obs;
  final showStockAge = true.obs;
  final showRateValidTill = true.obs;
  final showEmpCode = true.obs;

  final showAdditionalMessage = false.obs;
  final additionalMessageController = TextEditingController();

  // Focus nodes
  final additionalMessageFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    getEstimatePrintTemplateData();
  }

  @override
  void onClose() {
    additionalMessageController.dispose();
    additionalMessageFocusNode.dispose();
    super.onClose();
  }

  // Method to fetch estimate print template data
  Future<void> getEstimatePrintTemplateData() async {
    try {
      getEstimatePrintTemplateResponse.value = ApiResponse.loading("Loading");

      final response = await inventoryRepository.getEstimatePrintTemplate();
      getEstimatePrintTemplateResponse.value = ApiResponse.completed(response);

      // Update the UI with the fetched data
      updateUIWithTemplateData(response);
    } catch (e) {
      log('Error fetching estimate print template: $e');
      getEstimatePrintTemplateResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load estimate print template");
    }
  }

  // Update UI with the data from the API
  void updateUIWithTemplateData(GetEstimatePrintTemplateResponse data) {
    // Map API response fields to controller fields
    showVAPercentage.value = data.percentVa ?? 'percentage';
    showVAGrams.value = data.gramsVa ?? 'percentage';
    showMCTotalSum.value = data.mcTotal ?? false;
    showVendorCode.value = data.vendorCode ?? false;
    showStockAge.value = data.stockAge ?? false;
    showRateValidTill.value = data.rateValideTill ?? false;
    showEmpCode.value = data.empCode ?? false;
    showAdditionalMessage.value = data.showAdditionalMessage ?? false;
    additionalMessageController.text = data.additionalMessage ?? '';
  }

  // Create request object for API update
  GetEstimatePrintTemplateResponse createUpdateRequest() {
    return GetEstimatePrintTemplateResponse(
      percentVa: showVAPercentage.value,
      gramsVa: showVAGrams.value,
      mcTotal: showMCTotalSum.value,
      vendorCode: showVendorCode.value,
      stockAge: showStockAge.value,
      rateValideTill: showRateValidTill.value,
      empCode: showEmpCode.value,
      showAdditionalMessage: showAdditionalMessage.value,
      additionalMessage:
          showAdditionalMessage.value ? additionalMessageController.text : '',
    );
  }

  // Update the template with new values
  Future<void> updateEstimatePrintTemplate() async {
    try {
      isUpdating.value = true;

      final request = createUpdateRequest();
      await inventoryRepository.updateEstimatePrintTemplate(request);

      showSuccessToast(message: "Estimate print template updated successfully");
    } catch (e) {
      log('Error updating estimate print template: $e');
      showErrorToast(message: "Failed to update estimate print template");
    } finally {
      isUpdating.value = false;
    }
  }

  // Reset all fields to default values
  void resetAllFields() {
    showVAPercentage.value = 'percentage';
    showVAGrams.value = 'percentage';
    showMCTotalSum.value = false;
    showVendorCode.value = false;
    showStockAge.value = false;
    showEmpCode.value = false;
    showRateValidTill.value = false;
    showAdditionalMessage.value = false;
    additionalMessageController.text = '';
  }

  // Toggle boolean values
  void toggleBoolValue(RxBool option) {
    option.value = !option.value;
  }

  // Set VA percentage display type
  void setVAPercentageType(String type) {
    showVAPercentage.value = type;
  }

  // Set VA grams display type
  void setVAGramsType(String type) {
    showVAGrams.value = type;
  }
}
