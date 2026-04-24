import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_estimate_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EstimatePreferenceController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final isUpdating = false.obs;
  final isLoading = false.obs;

  // API response state
  final getEstimatePreferenceResponse =
      Rx<ApiResponse<GetEstimatePreferenceResponse>>(
        ApiResponse.initial("Initial"),
      );

  // UI State variables - matching the UI labels
  final addSalesPerson = true.obs; // Maps to askSalesPersonDetails
  final reduceInVAMC = true.obs; // Maps to reduceInVaFirst

  @override
  void onInit() {
    super.onInit();
    getEstimatePreferenceData();
  }

  // Method to fetch estimate preference data
  Future<void> getEstimatePreferenceData() async {
    try {
      isLoading.value = true;
      getEstimatePreferenceResponse.value = ApiResponse.loading("Loading");

      final response = await inventoryRepository.getEstimatePreference();
      getEstimatePreferenceResponse.value = ApiResponse.completed(response);

      // Update the UI with the fetched data
      updateUIWithPreferenceData(response);

      log('Estimate preference data loaded successfully');
    } catch (e) {
      log('Error fetching estimate preference: $e');
      getEstimatePreferenceResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load estimate preferences");

      // Set default values on error
      setDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  // Update UI with the data from the API
  void updateUIWithPreferenceData(GetEstimatePreferenceResponse data) {
    addSalesPerson.value = data.askSalesPersonDetails ?? false;
    reduceInVAMC.value = data.reduceInVaFirst ?? false;

    log(
      'UI updated with: addSalesPerson=${addSalesPerson.value}, reduceInVAMC=${reduceInVAMC.value}',
    );
  }

  // Set default values in case of error
  void setDefaultValues() {
    addSalesPerson.value = false;
    reduceInVAMC.value = false;
  }

  // Create request object for API update
  GetEstimatePreferenceResponse createUpdateRequest() {
    return GetEstimatePreferenceResponse(
      askSalesPersonDetails: addSalesPerson.value,
      reduceInVaFirst: reduceInVAMC.value,
    );
  }

  // Update the preference with new values
  Future<void> updateEstimatePreference() async {
    try {
      isUpdating.value = true;

      final request = createUpdateRequest();
      log('Updating estimate preference with: ${request.toJson()}');

      await inventoryRepository.updateEstimatePreference(request);

      showSuccessToast(message: "Estimate preferences updated successfully");
      log('Estimate preference updated successfully');
    } catch (e) {
      log('Error updating estimate preference: $e');
      showErrorToast(message: "Failed to update estimate preferences");
    } finally {
      isUpdating.value = false;
    }
  }

  // Reset all fields to default values
  void resetAllFields() {
    addSalesPerson.value = false;
    reduceInVAMC.value = false;
    log('All fields reset to default values');
  }

  // Toggle boolean values
  void toggleBoolValue(RxBool option) {
    option.value = !option.value;
    log('Toggled value to: ${option.value}');
  }
}
