import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/kyc_settings/model/get_org_kyc_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/kyc_settings/model/update_org_kyc_settings_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class KycSettingsController extends GetxController {
  final OrganizationRepository organizationRepository =
      OrganizationRepository();
  final isUpdating = false.obs;
  final isLoading = false.obs;

  // API response state
  final getOrgKycSettingsResponse = Rx<ApiResponse<GetOrgKycSettingsResponse>>(
    ApiResponse.initial("Initial"),
  );

  GetOrgKycSettingsResponse? _originalData;

  // Text editing controllers for editable fields
  final TextEditingController transactionLimitController =
      TextEditingController();
  final TextEditingController dailyLimitController = TextEditingController();
  final TextEditingController monthlyLimitController = TextEditingController();
  final TextEditingController yearlyLimitController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getKycSettingsData();
  }

  @override
  void onClose() {
    transactionLimitController.dispose();
    dailyLimitController.dispose();
    monthlyLimitController.dispose();
    yearlyLimitController.dispose();
    super.onClose();
  }

  // Fetch KYC settings data
  Future<void> getKycSettingsData() async {
    try {
      isLoading.value = true;
      getOrgKycSettingsResponse.value = ApiResponse.loading("Loading");

      final response = await organizationRepository.getOrgKycSettings();
      getOrgKycSettingsResponse.value = ApiResponse.completed(response);

      // Store original data for reset
      _originalData = response;

      // Update the UI with the fetched data
      updateUIWithSettingsData(response);

      log('KYC settings data loaded successfully');
    } catch (e) {
      log('Error fetching KYC settings: $e');
      getOrgKycSettingsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load KYC settings");

      // Set default values on error
      setDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  // Update UI with the data from the API
  void updateUIWithSettingsData(GetOrgKycSettingsResponse data) {
    // Update editable text controllers
    transactionLimitController.text = data.transactionLimit ?? '';
    dailyLimitController.text = data.dailyLimit ?? '';
    monthlyLimitController.text = data.monthlyLimit ?? '';
    yearlyLimitController.text = data.yearlyLimit ?? '';

    log('UI updated with KYC settings');
  }

  // Set default values in case of error
  void setDefaultValues() {
    transactionLimitController.clear();
    dailyLimitController.clear();
    monthlyLimitController.clear();
    yearlyLimitController.clear();
    _originalData = null;
  }

  // Create request object for API update
  UpdateOrgKycSettingsRequest createUpdateRequest() {
    return UpdateOrgKycSettingsRequest(
      transactionLimit:
          transactionLimitController.text.isEmpty
              ? null
              : double.tryParse(transactionLimitController.text),
      dailyLimit:
          dailyLimitController.text.isEmpty
              ? null
              : double.tryParse(dailyLimitController.text),
      monthlyLimit:
          monthlyLimitController.text.isEmpty
              ? null
              : double.tryParse(monthlyLimitController.text),
      yearlyLimit:
          yearlyLimitController.text.isEmpty
              ? null
              : double.tryParse(yearlyLimitController.text),
    );
  }

  // Update the KYC settings with new values
  Future<void> updateKycSettings() async {
    try {
      isUpdating.value = true;

      // Create and send update request
      final request = createUpdateRequest();
      log('Updating KYC settings with: ${request.toJson()}');
      await organizationRepository.updateOrgKycSettings(request);

      showSuccessToast(message: "KYC settings updated successfully");
      log('KYC settings updated successfully');

      // Refresh the data to get the latest from backend
      await getKycSettingsData();
    } catch (e) {
      log('Error updating KYC settings: $e');
      showErrorToast(message: "Failed to update KYC settings");
    } finally {
      isUpdating.value = false;
    }
  }

  // Reset all fields to their original fetched values
  void resetAllFields() {
    if (_originalData != null) {
      updateUIWithSettingsData(_originalData!);
      log('All fields reset to fetched values');
    } else {
      // If no original data, reload from API
      getKycSettingsData();
      log('Reloading data from API');
    }
  }

  // // Helper method to format currency
  // String formatCurrency(String? value) {
  //   if (value == null || value.isEmpty) return '₹0';
  //   return '₹$value';
  // }

  // // Helper method to format count
  // String formatCount(int? value) {
  //   if (value == null) return '0';
  //   return value.toString();
  // }
}
