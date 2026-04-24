// feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/general_settings_controller.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/get_webstore_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/update_webstore_settings_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/update_webstore_view_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/design_wise_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/head_wise_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

enum LiveStockListingOption { listAll, listHeadWise, listDesignWise }
// feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/general_settings_controller.dart

class GeneralSettingsController extends GetxController {
  final WebstoreRepository webstoreRepository = WebstoreRepository();
  final isUpdating = false.obs;
  final isLoading = false.obs;

  // API response state
  final getWebstoreSettingsResponse =
      Rx<ApiResponse<GetWebstoreSettingsResponse>>(
        ApiResponse.initial("Initial"),
      );

  GetWebstoreSettingsResponse? _originalData;

  // UI State variables
  final levyPGCharges = true.obs;
  final levyShippingCharges = true.obs;

  String? _originalViewType;
  List<String>? _originalViewIds; // Store original IDs from API

  // Text editing controllers
  final TextEditingController shippingAmountController =
      TextEditingController();
  final TextEditingController advancePaymentController =
      TextEditingController();
  final TextEditingController additionalVAController = TextEditingController();
  final TextEditingController additionalMCController = TextEditingController();

  // Radio button state
  final selectedListingOption = LiveStockListingOption.listHeadWise.obs;

  // Method to change listing option
  void setListingOption(LiveStockListingOption option) {
    selectedListingOption.value = option;
    log('Live stock listing option changed to: $option');
  }

  @override
  void onInit() {
    super.onInit();
    getGeneralSettingsData();
  }

  @override
  void onClose() {
    shippingAmountController.dispose();
    advancePaymentController.dispose();
    additionalVAController.dispose();
    additionalMCController.dispose();
    super.onClose();
  }

  // Method to fetch general settings data
  Future<void> getGeneralSettingsData() async {
    try {
      isLoading.value = true;
      getWebstoreSettingsResponse.value = ApiResponse.loading("Loading");

      final response = await webstoreRepository.getWebstoreSettings();
      getWebstoreSettingsResponse.value = ApiResponse.completed(response);

      // Store original data for reset
      _originalData = response;

      // Update the UI with the fetched data
      updateUIWithSettingsData(response);

      log('General settings data loaded successfully');
    } catch (e) {
      log('Error fetching general settings: $e');
      getWebstoreSettingsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load general settings");

      // Set default values on error
      setDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  // Update UI with the data from the API
  void updateUIWithSettingsData(GetWebstoreSettingsResponse data) {
    // Update levy charges
    levyPGCharges.value = data.isPgChargeFromCustomer ?? false;
    levyShippingCharges.value = data.isShippingChargeFromCustomer ?? false;

    // Update text controllers
    shippingAmountController.text = data.shippingCharges ?? '';
    advancePaymentController.text = data.advanceBookingPercentage ?? '';

    // Handle additionalWebstoreVa
    if (data.additionalWebstoreVa != null) {
      additionalVAController.text = data.additionalWebstoreVa.toString();
    } else {
      additionalVAController.clear();
    }

    // Handle additionalWebstoreMc
    if (data.additionalWebstoreMc != null) {
      additionalMCController.text = data.additionalWebstoreMc.toString();
    } else {
      additionalMCController.clear();
    }

    // Map webstoreViewType to LiveStockListingOption
    selectedListingOption.value = _mapViewTypeToOption(data.webstoreViewType);

    // Store original view type
    _originalViewType = data.webstoreViewType;

    // **IMPORTANT: Fetch and store the original IDs based on view type**
    _fetchAndStoreOriginalIds();

    log(
      'UI updated with: levyPGCharges=${levyPGCharges.value}, levyShippingCharges=${levyShippingCharges.value}',
    );
    log('View Type: ${data.webstoreViewType} → ${selectedListingOption.value}');
  }

  // Fetch original IDs based on current view type
  Future<void> _fetchAndStoreOriginalIds() async {
    if (_originalViewType == 'Stock Head') {
      // Fetch stock heads and store enabled IDs
      try {
        final response = await webstoreRepository.getStockHeadsWebViewListing();
        _originalViewIds =
            response.values
                ?.where((head) => head.isWebstore == true)
                .map((head) => head.id ?? '')
                .where((id) => id.isNotEmpty)
                .toList();
        log('Stored original Stock Head IDs: $_originalViewIds');
      } catch (e) {
        log('Error fetching original stock head IDs: $e');
        _originalViewIds = [];
      }
    } else if (_originalViewType == 'Design') {
      // Fetch designs and store enabled IDs
      try {
        final response = await webstoreRepository.getDesignWebViewListing();
        _originalViewIds =
            response.values
                ?.where((design) => design.isWebstore == true)
                .map((design) => design.id ?? '')
                .where((id) => id.isNotEmpty)
                .toList();
        log('Stored original Design IDs: $_originalViewIds');
      } catch (e) {
        log('Error fetching original design IDs: $e');
        _originalViewIds = [];
      }
    } else {
      // For "All Items", no IDs needed
      _originalViewIds = null;
      log('View type is All Items, no IDs needed');
    }
  }

  // Map API view type to enum
  LiveStockListingOption _mapViewTypeToOption(String? viewType) {
    switch (viewType) {
      case 'All Items':
        return LiveStockListingOption.listAll;
      case 'Stock Head':
        return LiveStockListingOption.listHeadWise;
      case 'Design':
        return LiveStockListingOption.listDesignWise;
      default:
        log('Unknown view type: $viewType, defaulting to All Items');
        return LiveStockListingOption.listAll;
    }
  }

  // Map enum to API view type string
  String _mapOptionToViewType(LiveStockListingOption option) {
    switch (option) {
      case LiveStockListingOption.listAll:
        return 'All Items';
      case LiveStockListingOption.listHeadWise:
        return 'Stock Head';
      case LiveStockListingOption.listDesignWise:
        return 'Design';
    }
  }

  // Set default values in case of error
  void setDefaultValues() {
    levyPGCharges.value = false;
    levyShippingCharges.value = false;
    shippingAmountController.clear();
    advancePaymentController.clear();
    additionalVAController.clear();
    additionalMCController.clear();
    selectedListingOption.value = LiveStockListingOption.listAll;
    _originalData = null;
    _originalViewType = null;
    _originalViewIds = null;
  }

  // Create request object for API update
  UpdateWebstoreSettingsRequest createUpdateRequest() {
    return UpdateWebstoreSettingsRequest(
      id: _originalData?.id,
      isPgChargeFromCustomer: levyPGCharges.value,
      paymentGatewayCharges: 0.0,
      isShippingChargeFromCustomer: levyShippingCharges.value,
      shippingCharges:
          shippingAmountController.text.isEmpty
              ? null
              : double.tryParse(shippingAmountController.text),
      advanceBookingPercentage:
          advancePaymentController.text.isEmpty
              ? null
              : double.tryParse(advancePaymentController.text),
      additionalWebstoreVa:
          additionalVAController.text.isEmpty
              ? null
              : double.tryParse(additionalVAController.text),
      additionalWebstoreMc:
          additionalMCController.text.isEmpty
              ? null
              : double.tryParse(additionalMCController.text),
    );
  }

  // Validate percentage fields (0-100)
  bool validatePercentage(String value) {
    if (value.isEmpty) return true;
    final percentage = double.tryParse(value);
    return percentage != null && percentage >= 0 && percentage <= 100;
  }

  // Validate numeric fields
  bool validateNumericField(String value) {
    if (value.isEmpty) return true;
    final number = double.tryParse(value);
    return number != null && number >= 0;
  }

  // Update the settings with new values
  Future<void> updateGeneralSettings() async {
    try {
      isUpdating.value = true;

      // Validate shipping amount if shipping charges are enabled
      if (levyShippingCharges.value) {
        if (shippingAmountController.text.isEmpty) {
          showErrorToast(message: "Please enter shipping charges amount");
          isUpdating.value = false;
          return;
        }
        if (!validateNumericField(shippingAmountController.text)) {
          showErrorToast(message: "Please enter a valid shipping amount");
          isUpdating.value = false;
          return;
        }
      }

      // Validate advance payment percentage
      if (advancePaymentController.text.isNotEmpty) {
        if (!validatePercentage(advancePaymentController.text)) {
          showErrorToast(
            message: "Advance payment percentage must be between 0 and 100",
          );
          isUpdating.value = false;
          return;
        }
      }

      // Validate additional VA percentage
      if (additionalVAController.text.isNotEmpty) {
        if (!validatePercentage(additionalVAController.text)) {
          showErrorToast(
            message: "Additional VA percentage must be between 0 and 100",
          );
          isUpdating.value = false;
          return;
        }
      }

      // Validate additional MC amount
      if (additionalMCController.text.isNotEmpty) {
        if (!validateNumericField(additionalMCController.text)) {
          showErrorToast(
            message: "Please enter a valid amount for additional MC",
          );
          isUpdating.value = false;
          return;
        }
      }

      // First update general settings
      final request = createUpdateRequest();
      log('Updating general settings with: ${request.toJson()}');
      await webstoreRepository.updateWebstoreSettings(request);

      // Then update view settings if changed
      await _updateViewSettingsIfChanged();

      showSuccessToast(message: "Settings updated successfully");
      log('All settings updated successfully');

      // Refresh the data to get the latest from backend
      await getGeneralSettingsData();
    } catch (e) {
      log('Error updating settings: $e');
      showErrorToast(message: "Failed to update settings");
    } finally {
      isUpdating.value = false;
    }
  }

  // New method to handle view settings update
  Future<void> _updateViewSettingsIfChanged() async {
    final currentViewType = _mapOptionToViewType(selectedListingOption.value);
    List<String>? currentIds;

    // Get current IDs based on selected option
    if (selectedListingOption.value == LiveStockListingOption.listHeadWise) {
      currentIds = _getEnabledStockHeadIds();
    } else if (selectedListingOption.value ==
        LiveStockListingOption.listDesignWise) {
      currentIds = _getEnabledDesignIds();
    }

    // Check if there are changes
    final hasTypeChanged = currentViewType != _originalViewType;
    final hasIdsChanged = !_areIdsEqual(currentIds, _originalViewIds);

    if (!hasTypeChanged && !hasIdsChanged) {
      log('No changes in view settings, skipping update');
      return;
    }

    log('View settings changed - Type: $hasTypeChanged, IDs: $hasIdsChanged');
    log('Original IDs: $_originalViewIds');
    log('Current IDs: $currentIds');

    // Create update request
    final updateRequest = UpdateWebstoreViewSettingsRequest(
      type: currentViewType,
      ids: currentIds,
    );

    log('Updating view settings with: ${updateRequest.toJson()}');
    await webstoreRepository.updateWebstoreViewSettings(updateRequest);
    log('View settings updated successfully');
  }

  // Helper method to get enabled stock head IDs
  List<String> _getEnabledStockHeadIds() {
    try {
      final controller = Get.find<HeadWiseListingController>(
        tag: 'headWiseListing',
      );
      final enabledIds =
          controller.stockHeads
              .where((head) => head.isWebstore.value)
              .map((head) => head.id)
              .toList();
      log('Found ${enabledIds.length} enabled stock heads');
      return enabledIds;
    } catch (e) {
      log(
        'HeadWiseListingController not found, returning empty list. Error: $e',
      );
      return [];
    }
  }

  // Helper method to get enabled design IDs
  List<String> _getEnabledDesignIds() {
    try {
      final controller = Get.find<DesignWiseListingController>(
        tag: 'designWiseListing',
      );
      final enabledIds =
          controller.design
              .where((design) => design.isWebstore.value)
              .map((design) => design.id)
              .toList();
      log('Found ${enabledIds.length} enabled designs');
      return enabledIds;
    } catch (e) {
      log(
        'DesignWiseListingController not found, returning empty list. Error: $e',
      );
      return [];
    }
  }

  // Helper method to compare two lists of IDs
  bool _areIdsEqual(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;

    final set1 = Set<String>.from(list1);
    final set2 = Set<String>.from(list2);
    return set1.difference(set2).isEmpty && set2.difference(set1).isEmpty;
  }

  // Reset all fields to their original fetched values
  void resetAllFields() {
    if (_originalData != null) {
      updateUIWithSettingsData(_originalData!);
      log('All fields reset to fetched values');
    } else {
      // If no original data, reload from API
      getGeneralSettingsData();
      log('Reloading data from API');
    }
  }

  // Toggle boolean values
  void toggleBoolValue(RxBool option) {
    option.value = !option.value;
    log('Toggled value to: ${option.value}');

    // If toggling shipping charges off, clear the amount
    if (option == levyShippingCharges && !option.value) {
      shippingAmountController.text = "0.0";
    }
  }
}
