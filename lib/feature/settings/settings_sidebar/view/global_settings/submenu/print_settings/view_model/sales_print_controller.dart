import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/sales_print/get_sales_print_template_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesInvoicePrintController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final isUpdating = false.obs;
  final selectedTemplate = RxInt(1);
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = RxString('');

  // Store all templates from API
  final allTemplates = RxList<GetSalesPrintTemplateResponse>([]);

  // API response state
  final getSalesInvoicePrintTemplateResponse =
      Rx<ApiResponse<List<GetSalesPrintTemplateResponse>>>(
        ApiResponse.initial("Initial"),
      );

  // State variables for Sales Invoice Print settings
  final showVAPercentage = RxString(
    'percentage',
  ); // percentage, grams, both, amount, none
  final showVAGrams = RxString(
    'percentage',
  ); // percentage, grams, both, amount, none

  final showMCTotalSum = RxBool(true);

  // Number of copies
  final panCopies = RxInt(1);
  final balanceCopies = RxInt(1);

  // Print options
  final printOldDetails = RxBool(true);
  final printItemDifference = RxBool(true);
  final printEstimateWithInvoice = RxBool(true);

  // Display name fields
  final schemeName = RxString('Scheme Disct');
  final rateDisplay = RxString('Rate Disct');
  final discountDisplay = RxString('Discount');
  final additionalDisplay = RxString('Additional Less');

  final schemeNameController = TextEditingController();
  final rateDisplayController = TextEditingController();
  final discountDisplayController = TextEditingController();
  final additionalDisplayController = TextEditingController();

  final showAdditionalMessage = RxBool(false);
  final additionalMessageController = TextEditingController();

  // Focus nodes
  final additionalMessageFocusNode = FocusNode();
  final schemeNameFocusNode = FocusNode();
  final rateDisplayFocusNode = FocusNode();
  final discountDisplayFocusNode = FocusNode();
  final additionalDisplayFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

    // Initialize text controllers from rx variables
    schemeNameController.text = schemeName.value;
    rateDisplayController.text = rateDisplay.value;
    discountDisplayController.text = discountDisplay.value;
    additionalDisplayController.text = additionalDisplay.value;

    // Set up listeners for text changes
    schemeNameController.addListener(() {
      schemeName.value = schemeNameController.text;
    });

    rateDisplayController.addListener(() {
      rateDisplay.value = rateDisplayController.text;
    });

    discountDisplayController.addListener(() {
      discountDisplay.value = discountDisplayController.text;
    });

    additionalDisplayController.addListener(() {
      additionalDisplay.value = additionalDisplayController.text;
    });

    // Listen for template changes
    ever(selectedTemplate, (int templateId) {
      updateUIForSelectedTemplate(templateId);
    });

    getSalesInvoicePrintTemplateData();
  }

  @override
  void onClose() {
    additionalMessageController.dispose();
    additionalMessageFocusNode.dispose();
    schemeNameController.dispose();
    rateDisplayController.dispose();
    discountDisplayController.dispose();
    additionalDisplayController.dispose();
    schemeNameFocusNode.dispose();
    rateDisplayFocusNode.dispose();
    discountDisplayFocusNode.dispose();
    additionalDisplayFocusNode.dispose();
    super.onClose();
  }

  // Method to fetch sales invoice print template data
  Future<void> getSalesInvoicePrintTemplateData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      getSalesInvoicePrintTemplateResponse.value = ApiResponse.loading(
        "Loading",
      );

      final response = await inventoryRepository.getAllSalesPrintTemplates();
      getSalesInvoicePrintTemplateResponse.value = ApiResponse.completed(
        response,
      );

      // Store all templates
      allTemplates.value = response;

      // Set UI for selected template
      if (allTemplates.isNotEmpty) {
        // Find template with matching ID, or use first template if none match
        final matchingTemplateIndex = response.indexWhere(
          (template) => template.templateNumber == selectedTemplate.value,
        );

        if (matchingTemplateIndex >= 0) {
          // Found a matching template
          updateUIWithTemplateData(response[matchingTemplateIndex]);
        } else {
          // No matching template found, use the first one
          selectedTemplate.value = response[0].templateNumber ?? 1;
          updateUIWithTemplateData(response[0]);
        }
      }
    } catch (e) {
      log('Error fetching sales invoice print template: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      getSalesInvoicePrintTemplateResponse.value = ApiResponse.error(
        e.toString(),
      );
      showErrorToast(
        message: "Failed to load sales invoice print template: ${e.toString()}",
      );

      // Set default values on error
      setDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  // Set default values in case of error
  void setDefaultValues() {
    selectedTemplate.value = 1;
    showVAPercentage.value = 'percentage';
    showVAGrams.value = 'percentage';
    showMCTotalSum.value = true;

    panCopies.value = 1;
    balanceCopies.value = 1;

    printOldDetails.value = true;
    printItemDifference.value = true;
    printEstimateWithInvoice.value = true;

    schemeName.value = 'Scheme Disct';
    rateDisplay.value = 'Rate Disct';
    discountDisplay.value = 'Discount';
    additionalDisplay.value = 'Additional Less';

    schemeNameController.text = schemeName.value;
    rateDisplayController.text = rateDisplay.value;
    discountDisplayController.text = discountDisplay.value;
    additionalDisplayController.text = additionalDisplay.value;

    showAdditionalMessage.value = false;
    additionalMessageController.text = '';
  }

  // Update UI with the data from the API for selected template
  void updateUIForSelectedTemplate(int templateId) {
    if (allTemplates.isEmpty) return;

    // Find the template with the matching ID
    final matchingTemplate = allTemplates.firstWhereOrNull(
      (template) => template.templateNumber == templateId,
    );

    if (matchingTemplate != null) {
      // Apply the template data to the UI
      updateUIWithTemplateData(matchingTemplate);
    } else {
      log('Template with ID $templateId not found');
    }
  }

  // Update UI with the data from the API
  void updateUIWithTemplateData(GetSalesPrintTemplateResponse data) {
    log('Updating UI with template data: ${data.templateNumber}');

    // Do not update selectedTemplate.value here to avoid infinite loop with ever listener
    showVAPercentage.value = data.percentVa ?? 'percentage';
    showVAGrams.value = data.gramsVa ?? 'percentage';
    showMCTotalSum.value = data.mcTotal ?? false;

    // Number of copies
    panCopies.value = data.panInvoiceCopy ?? 1;
    balanceCopies.value = data.balanceInvoiceCopy ?? 1;

    // Print options
    printOldDetails.value = data.oldDetailsSlip ?? false;
    printItemDifference.value = data.itemDifferenceSlip ?? false;
    printEstimateWithInvoice.value = data.printEstimate ?? false;

    // Display names (update both rx variable and controller)
    schemeName.value = data.schemeDiscount ?? 'Scheme Disct';
    rateDisplay.value = data.rateDiscount ?? 'Rate Disct';
    discountDisplay.value = data.discount ?? 'Discount';
    additionalDisplay.value = data.additionalLess ?? 'Additional Less';

    schemeNameController.text = schemeName.value;
    rateDisplayController.text = rateDisplay.value;
    discountDisplayController.text = discountDisplay.value;
    additionalDisplayController.text = additionalDisplay.value;

    // Additional message
    showAdditionalMessage.value = data.showAdditionalMessage ?? false;
    additionalMessageController.text = data.additionalMessage ?? '';
  }

  // Create request object for API update
  GetSalesPrintTemplateResponse createUpdateRequest() {
    return GetSalesPrintTemplateResponse(
      templateNumber: selectedTemplate.value,
      percentVa: showVAPercentage.value,
      gramsVa: showVAGrams.value,
      mcTotal: showMCTotalSum.value,
      panInvoiceCopy: panCopies.value,
      balanceInvoiceCopy: balanceCopies.value,
      oldDetailsSlip: printOldDetails.value,
      itemDifferenceSlip: printItemDifference.value,
      printEstimate: printEstimateWithInvoice.value,
      schemeDiscount: schemeName.value,
      rateDiscount: rateDisplay.value,
      discount: discountDisplay.value,
      additionalLess: additionalDisplay.value,
      showAdditionalMessage: showAdditionalMessage.value,
      additionalMessage:
          showAdditionalMessage.value ? additionalMessageController.text : '',
    );
  }

  // Update the template with new values
  Future<void> updateSalesInvoicePrintTemplate() async {
    try {
      isUpdating.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final request = createUpdateRequest();
      await inventoryRepository.updateSalesPrintTemplate(request);

      // Find and update the current template in allTemplates list
      final index = allTemplates.indexWhere(
        (template) => template.templateNumber == selectedTemplate.value,
      );

      if (index >= 0) {
        allTemplates[index] = request;
      }

      showSuccessToast(
        message: "Sales invoice print template updated successfully",
      );
    } catch (e) {
      log('Error updating sales invoice print template: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      showErrorToast(
        message:
            "Failed to update sales invoice print template: ${e.toString()}",
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Reset all fields to default values
  void resetAllFields() {
    showVAPercentage.value = 'percentage';
    showVAGrams.value = 'percentage';
    showMCTotalSum.value = false;

    panCopies.value = 1;
    balanceCopies.value = 1;

    printOldDetails.value = false;
    printItemDifference.value = false;
    printEstimateWithInvoice.value = false;

    schemeName.value = 'Scheme Disct';
    rateDisplay.value = 'Rate Disct';
    discountDisplay.value = 'Discount';
    additionalDisplay.value = 'Additional Less';

    schemeNameController.text = schemeName.value;
    rateDisplayController.text = rateDisplay.value;
    discountDisplayController.text = discountDisplay.value;
    additionalDisplayController.text = additionalDisplay.value;

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

  // Set template
  void setSelectedTemplate(int templateId) {
    selectedTemplate.value = templateId;
  }

  // Update number of copies
  void updatePanCopies(String value) {
    int? copies = int.tryParse(value);
    if (copies != null && copies > 0) {
      panCopies.value = copies;
    }
  }

  void updateBalanceCopies(String value) {
    int? copies = int.tryParse(value);
    if (copies != null && copies > 0) {
      balanceCopies.value = copies;
    }
  }

  // Set scheme name
  void updateSchemeName(String value) {
    schemeName.value = value;
    schemeNameController.text = value;
  }

  // Set rate display
  void updateRateDisplay(String value) {
    rateDisplay.value = value;
    rateDisplayController.text = value;
  }

  // Set discount display
  void updateDiscountDisplay(String value) {
    discountDisplay.value = value;
    discountDisplayController.text = value;
  }

  // Set additional display
  void updateAdditionalDisplay(String value) {
    additionalDisplay.value = value;
    additionalDisplayController.text = value;
  }
}
