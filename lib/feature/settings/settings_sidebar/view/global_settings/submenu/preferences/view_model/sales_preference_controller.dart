import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_sales_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesInvoicePreferenceController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final isUpdating = false.obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = RxString('');

  // API response state
  final getSalesPreferenceResponse =
      Rx<ApiResponse<GetSalesPreferenceResponse>>(
        ApiResponse.initial("Initial"),
      );

  // UI State variables - matching the UI labels and API response
  final askCustomerDetails = RxBool(true); // Maps to askCustomerAbove10K
  final askPanAbove2L = RxBool(true); // Maps to askPanAbove2L

  @override
  void onInit() {
    super.onInit();
    getSalesPreferenceData();
  }

  // Method to fetch sales preference data
  Future<void> getSalesPreferenceData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      getSalesPreferenceResponse.value = ApiResponse.loading("Loading");

      final response = await inventoryRepository.getSalesPreference();
      getSalesPreferenceResponse.value = ApiResponse.completed(response);

      // Update the UI with the fetched data
      updateUIWithPreferenceData(response);

      log('Sales preference data loaded successfully');
    } catch (e) {
      log('Error fetching sales preference: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      getSalesPreferenceResponse.value = ApiResponse.error(e.toString());
      showErrorToast(
        message: "Failed to load sales preferences: ${e.toString()}",
      );

      // Set default values on error
      setDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  // Update UI with the data from the API
  void updateUIWithPreferenceData(GetSalesPreferenceResponse data) {
    askCustomerDetails.value = data.askCustomerAbove10K ?? false;
    askPanAbove2L.value = data.askPanAbove2L ?? false;

    log(
      'UI updated with: askCustomerDetails=${askCustomerDetails.value}, askPanAbove2L=${askPanAbove2L.value}',
    );
  }

  // Set default values in case of error
  void setDefaultValues() {
    askCustomerDetails.value = false;
    askPanAbove2L.value = false;
  }

  // Create request object for API update
  GetSalesPreferenceResponse createUpdateRequest() {
    return GetSalesPreferenceResponse(
      askCustomerAbove10K: askCustomerDetails.value,
      askPanAbove2L: askPanAbove2L.value,
    );
  }

  // Update the preference with new values
  Future<void> updateSalesPreference() async {
    try {
      isUpdating.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final request = createUpdateRequest();
      log('Updating sales preference with: ${request.toJson()}');

      await inventoryRepository.updateSalesPreference(request);

      showSuccessToast(message: "Sales preferences updated successfully");
      log('Sales preference updated successfully');
    } catch (e) {
      log('Error updating sales preference: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      showErrorToast(
        message: "Failed to update sales preferences: ${e.toString()}",
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Reset all fields to default values
  void resetAllFields() {
    askCustomerDetails.value = false;
    askPanAbove2L.value = false;
    log('All fields reset to default values');
  }

  // Toggle boolean values
  void toggleBoolValue(RxBool option) {
    option.value = !option.value;
    log('Toggled value to: ${option.value}');
  }
}
