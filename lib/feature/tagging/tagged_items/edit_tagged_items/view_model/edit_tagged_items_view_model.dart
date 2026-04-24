import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart'
    hide SizeGroup, Design;
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/get_deisgn_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_vendor_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/model/get_tagging_line_item_editing_history_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/model/update_tagging_line_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response_v2.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'dart:developer';

class EditTaggedItemsViewModel extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final VendorRepository vendorRepository = VendorRepository();

  // ID of the item being edited
  String? taggingItemId;

  // Original fetched data
  final Rx<ApiResponse<GetTaggingLineItemResponse>> getTaggingItemResponse =
      Rx<ApiResponse<GetTaggingLineItemResponse>>(
        ApiResponse.initial("Initial"),
      );

  // Edit history data
  final Rx<ApiResponse<GetTaggingLineItemEditHistoryResponse>>
  getEditHistoryResponse =
      Rx<ApiResponse<GetTaggingLineItemEditHistoryResponse>>(
        ApiResponse.initial("Initial"),
      );

  // Selected values for editing
  final Rx<String?> selectedVendorId = Rx<String?>(null);
  final Rx<String?> selectedVendorCode = Rx<String?>(null);
  final Rx<String?> selectedSizeId = Rx<String?>(null);
  final Rx<String?> selectedSizeName = Rx<String?>(null);
  final Rxn<GetPurityValue?> selectedPurity = Rxn<GetPurityValue?>(null);
  final Rx<GetDesignResponseModel?> selectedDesign =
      Rx<GetDesignResponseModel?>(null);

  final grWtController = TextEditingController();
  final netWtController = TextEditingController();
  final rateController = TextEditingController();
  final huidController = TextEditingController();

  // Vendor dropdown
  final getVendorDropdownResponse = Rx<ApiResponse<GetVendorDropdownResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Design dropdown
  final getDesignDropdownResponse = Rx<ApiResponse<GetDesignDropdownResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Purity
  final getPurityResponse = Rx<ApiResponse<GetPurityResponseV2>>(
    ApiResponse.initial("Initial"),
  );

  // Focus nodes
  final FocusNode purityFocusNode = FocusNode();
  final FocusNode designFocusNode = FocusNode();
  final FocusNode vendorFocusNode = FocusNode();
  final FocusNode sizeFocusNode = FocusNode();

  // Search
  final searchQuery = ''.obs;
  final _searchDebouncer = CustomDebouncer(milliseconds: 500);

  // Available sizes and purities from selected design
  final RxList<SizeGroup> availableSizes = RxList<SizeGroup>([]);
  final RxList<String> purityList = RxList<String>();

  // Save state
  final Rx<ApiResponse<dynamic>> saveResponse = Rx<ApiResponse<dynamic>>(
    ApiResponse.initial("Initial"),
  );

  // Initialize with tagging item ID
  void init(String? id) {
    taggingItemId = id;
  }

  @override
  void onInit() {
    super.onInit();
    getSelectedPurity();
    getDesignListing();
    getVendorListing();

    // Fetch tagging item data if ID is provided
    if (taggingItemId != null && taggingItemId!.isNotEmpty) {
      fetchTaggingLineItem();
    }
  }

  // Fetch tagging line item by ID
  Future<void> fetchTaggingLineItem() async {
    if (taggingItemId == null || taggingItemId!.isEmpty) {
      log('No tagging item ID provided');
      return;
    }

    try {
      getTaggingItemResponse.value = ApiResponse.loading("Loading");

      final response = await inventoryRepository.getTaggingLineItem(
        taggingItemId!,
      );

      getTaggingItemResponse.value = ApiResponse.completed(response);

      // Populate form fields with fetched data
      await populateFormFields(response);

      // Fetch edit history
      fetchEditHistory();
    } catch (e) {
      getTaggingItemResponse.value = ApiResponse.error(e.toString());
      log('Error fetching tagging line item: $e');
    }
  }

  // Fetch edit history for the tagging line item
  Future<void> fetchEditHistory() async {
    if (taggingItemId == null || taggingItemId!.isEmpty) {
      log('No tagging item ID provided for edit history');
      return;
    }

    try {
      getEditHistoryResponse.value = ApiResponse.loading("Loading");

      final response = await inventoryRepository.getTaggingLineItemEditHistory(
        taggingItemId!,
      );

      getEditHistoryResponse.value = ApiResponse.completed(response);
      log('Edit history fetched successfully: ${response.totalCount} items');
    } catch (e) {
      getEditHistoryResponse.value = ApiResponse.error(e.toString());
      log('Error fetching edit history: $e');
    }
  }

  // Populate form fields from fetched data
  Future<void> populateFormFields(GetTaggingLineItemResponse data) async {
    try {
      // Set vendor
      if (data.vendorId != null && data.vendorCode != null) {
        selectedVendorId.value = data.vendorId;
        selectedVendorCode.value = data.vendorCode;
      }

      // Set design
      if (data.design?.id != null) {
        final fullDesign = await fetchDesignDetails(data.design!.id!);
        if (fullDesign != null) {
          setSelectedDesign(fullDesign);
        }
      }

      // Set size (after design is loaded so availableSizes is populated)
      if (data.sizeGroup?.id != null && data.sizeGroup?.size != null) {
        selectedSizeId.value = data.sizeGroup!.id;
        selectedSizeName.value = data.sizeGroup!.size;
      }

      // // Set purity
      // if (data.purity != null) {
      //   // Find matching purity from the purity response
      //   final purityValues = getPurityResponse.value.data?.values ?? [];
      //   final matchingPurity = purityValues.firstWhereOrNull(
      //     (p) => p.purityName == data.purity,
      //   );
      //   if (matchingPurity != null) {
      //     selectedPurity.value = matchingPurity;
      //   }
      // }

      // Set purity
      if (data.purity != null && data.purity!.isNotEmpty) {
        // ensure purity list loaded
        if (getPurityResponse.value.status != Status.COMPLETED) {
          await getSelectedPurity();
        }

        final purityValues = getPurityResponse.value.data?.values ?? [];

        final matchingPurity = purityValues.firstWhereOrNull(
          (p) =>
              (p.purityType?.toLowerCase().trim() ==
                  data.purity?.toLowerCase().trim()) ||
              (p.purityName?.toLowerCase().trim() ==
                  data.purity?.toLowerCase().trim()),
        );

        if (matchingPurity != null) {
          selectedPurity.value = matchingPurity;
          log("✅ Purity matched: ${matchingPurity.purityName}");
        } else {
          log("❌ Purity NOT matched for: ${data.purity}");
        }
      }

      // Set text field values
      if (data.grossWeight != null) {
        grWtController.text = data.grossWeight!;
      }

      if (data.netWeight != null) {
        netWtController.text = data.netWeight!;
      }

      if (data.rate != null) {
        rateController.text = data.rate!;
      }

      if (data.huid != null) {
        huidController.text = data.huid!;
      }

      log('Form fields populated successfully');
    } catch (e) {
      log('Error populating form fields: $e');
    }
  }

  // Fetch vendor listing (simplified without pagination)
  Future<void> getVendorListing() async {
    try {
      getVendorDropdownResponse.value = ApiResponse.loading("Loading");

      final response = await vendorRepository.getVendorDropdown(
        query: searchQuery.value,
        limit: 100,
      );

      getVendorDropdownResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getVendorDropdownResponse.value = ApiResponse.error(e.toString());
      log('Error fetching vendor dropdown: $e');
    }
  }

  // Fetch purity data
  Future<void> getSelectedPurity() async {
    try {
      getPurityResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getSelectedPurityv2();
      getPurityResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getPurityResponse.value = ApiResponse.error(e.toString());
      log('Error fetching purity types: $e');
    }
  }

  // Fetch design listing (simplified without pagination)
  Future<void> getDesignListing() async {
    try {
      getDesignDropdownResponse.value = ApiResponse.loading("Loading");

      final response = await inventoryRepository.getDesignDropdown(
        query: searchQuery.value,
        limit: 100,
        page: 1,
      );

      getDesignDropdownResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getDesignDropdownResponse.value = ApiResponse.error(e.toString());
      log('Error fetching design dropdown: $e');
    }
  }

  // Fetch full design details by ID
  Future<GetDesignResponseModel?> fetchDesignDetails(String designId) async {
    try {
      final response = await inventoryRepository.getDesignById(id: designId);
      return response;
    } catch (e) {
      log('Error fetching design details: $e');
      return null;
    }
  }

  // Set selected vendor
  void setSelectedVendor(String id, String code) {
    selectedVendorId.value = id;
    selectedVendorCode.value = code;
  }

  // Set selected design
  void setSelectedDesign(GetDesignResponseModel? design) {
    selectedDesign.value = design;
    if (design != null) {
      updateAvailableSizes();
      updateAvailablePurities();
    }
  }

  // Update available sizes based on selected design
  void updateAvailableSizes() {
    final selectedDesignData = selectedDesign.value;
    if (selectedDesignData?.stockHead?.sizeGroups != null) {
      availableSizes.value = selectedDesignData!.stockHead!.sizeGroups!;
    } else {
      availableSizes.clear();
      selectedSizeId.value = null;
      selectedSizeName.value = null;
    }
    log("Available sizes: ${availableSizes.length}");
  }

  // Update available purities based on selected design
  void updateAvailablePurities() {
    final selectedDesignData = selectedDesign.value;
    final lineItems = selectedDesignData?.lineItems ?? [];

    final Set<String> uniquePurities = {};

    for (final lineItem in lineItems) {
      if (lineItem.purity != null && lineItem.purity!.isNotEmpty) {
        uniquePurities.add(lineItem.purity!);
      }
    }

    purityList.clear();
    purityList.assignAll(uniquePurities.toList());
    log("Available purities: ${purityList.toList()}");
  }

  // Set search query with debouncing
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _searchDebouncer.run(() {
      getDesignListing();
      getVendorListing();
    });
  }

  void setSelectedSize(String? id, String? name) {
    selectedSizeId.value = id;
    selectedSizeName.value = name;
  }

  void setSelectedPurity({required GetPurityValue value}) {
    selectedPurity.value = value;
  }

  void resetSelections() {
    selectedVendorId.value = null;
    selectedVendorCode.value = null;
    selectedDesign.value = null;
    selectedSizeId.value = null;
    selectedSizeName.value = null;
    selectedPurity.value = null;
    availableSizes.clear();
    purityList.clear();
    searchQuery.value = '';
    grWtController.clear();
    netWtController.clear();
    rateController.clear();
    huidController.clear();
  }

  // Save tagging line item changes
  Future<void> saveTaggingLineItem() async {
    if (taggingItemId == null || taggingItemId!.isEmpty) {
      log('No tagging item ID provided for saving');
      Get.snackbar(
        'Error',
        'No item ID found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    try {
      // Validate required fields
      if (!_validateFields()) {
        return;
      }

      saveResponse.value = ApiResponse.loading("Saving");

      // Get original data for comparison
      final originalData = getTaggingItemResponse.value.data;

      // Prepare the update request
      final updateRequest = UpdateTaggingLineItemEditHistoryRequest(
        id: taggingItemId,
        design:
            selectedDesign.value?.id != null
                ? Design(id: selectedDesign.value!.id)
                : null,
        sizeGroup:
            selectedSizeId.value != null
                ? Design(id: selectedSizeId.value)
                : null,
        purity: selectedPurity.value?.purityType,
        grossWeight:
            grWtController.text.isNotEmpty
                ? double.tryParse(grWtController.text)
                : null,
        netWeight:
            netWtController.text.isNotEmpty
                ? double.tryParse(netWtController.text)
                : null,
        rate:
            rateController.text.isNotEmpty
                ? double.tryParse(rateController.text)
                : null,
        huid: huidController.text.isNotEmpty ? huidController.text : null,
        oldVendorId: originalData?.vendorId,
        oldVendorCode: originalData?.vendorCode,
        newVendorId: selectedVendorId.value,
        newVendorCode: selectedVendorCode.value,
        images: [], // Add images if needed
      );

      // Call the API
      final response = await inventoryRepository.editTaggingLineItem(
        updateRequest,
        taggingItemId!,
      );

      saveResponse.value = ApiResponse.completed(response);

      // Show success message
      Get.snackbar(
        'Success',
        'Item updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 2),
      );

      // Refresh the data
      await fetchTaggingLineItem();

      log('Tagging line item saved successfully');
    } catch (e) {
      saveResponse.value = ApiResponse.error(e.toString());
      log('Error saving tagging line item: $e');

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to save changes: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Validate required fields before saving
  bool _validateFields() {
    if (selectedDesign.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a design',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    if (selectedVendorId.value == null || selectedVendorCode.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a vendor',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    if (selectedPurity.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a purity',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    if (grWtController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter gross weight',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    if (netWtController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter net weight',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    if (rateController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter rate',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    // Validate numeric values
    if (double.tryParse(grWtController.text) == null) {
      Get.snackbar(
        'Validation Error',
        'Gross weight must be a valid number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    if (double.tryParse(netWtController.text) == null) {
      Get.snackbar(
        'Validation Error',
        'Net weight must be a valid number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    if (double.tryParse(rateController.text) == null) {
      Get.snackbar(
        'Validation Error',
        'Rate must be a valid number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    purityFocusNode.dispose();
    designFocusNode.dispose();
    vendorFocusNode.dispose();
    sizeFocusNode.dispose();
    grWtController.dispose();
    netWtController.dispose();
    rateController.dispose();
    huidController.dispose();
    super.onClose();
  }
}
