import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_tag_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class TagPreferenceController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final isUpdating = false.obs;
  final isLoading = false.obs;

  // API response state
  final getTagPreferenceResponse = Rx<ApiResponse<GetTagPreferenceResponse>>(
    ApiResponse.initial("Initial"),
  );

  // UI State variables - matching the UI labels and API response
  final lotBasedTaggingOnly = true.obs; // Maps to lotBasedTaggingOnly
  final createPurchaseLotAuto = true.obs; // Maps to autoCreateLotPurchase
  final createMaterialInLotAuto = true.obs; // Maps to autoCreateLotMaterialIn
  final createSalesReturnInLotAuto =
      true.obs; // Maps to autoCreateLotSalesReturn
  final createStockDiffInLotAuto =
      true.obs; // Maps to autoCreateLotStockDifference

  @override
  void onInit() {
    super.onInit();
    getTagPreferenceData();
  }

  // Method to fetch tag preference data
  Future<void> getTagPreferenceData() async {
    try {
      isLoading.value = true;
      getTagPreferenceResponse.value = ApiResponse.loading("Loading");

      final response = await inventoryRepository.getTagPreference();
      getTagPreferenceResponse.value = ApiResponse.completed(response);

      // Update the UI with the fetched data
      updateUIWithPreferenceData(response);

      log('Tag preference data loaded successfully');
    } catch (e) {
      log('Error fetching tag preference: $e');
      getTagPreferenceResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load tag preferences");

      // Set default values on error
      setDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  // Update UI with the data from the API
  void updateUIWithPreferenceData(GetTagPreferenceResponse data) {
    lotBasedTaggingOnly.value = data.lotBasedTaggingOnly ?? false;
    createPurchaseLotAuto.value = data.autoCreateLotPurchase ?? false;
    createMaterialInLotAuto.value = data.autoCreateLotMaterialIn ?? false;
    createSalesReturnInLotAuto.value = data.autoCreateLotSalesReturn ?? false;
    createStockDiffInLotAuto.value = data.autoCreateLotStockDifference ?? false;

    log('UI updated with tag preference data:');
    log('  lotBasedTaggingOnly: ${lotBasedTaggingOnly.value}');
    log('  createPurchaseLotAuto: ${createPurchaseLotAuto.value}');
    log('  createMaterialInLotAuto: ${createMaterialInLotAuto.value}');
    log('  createSalesReturnInLotAuto: ${createSalesReturnInLotAuto.value}');
    log('  createStockDiffInLotAuto: ${createStockDiffInLotAuto.value}');
  }

  // Set default values in case of error
  void setDefaultValues() {
    lotBasedTaggingOnly.value = false;
    createPurchaseLotAuto.value = false;
    createMaterialInLotAuto.value = false;
    createSalesReturnInLotAuto.value = false;
    createStockDiffInLotAuto.value = false;
  }

  // Create request object for API update
  GetTagPreferenceResponse createUpdateRequest() {
    return GetTagPreferenceResponse(
      lotBasedTaggingOnly: lotBasedTaggingOnly.value,
      autoCreateLotPurchase: createPurchaseLotAuto.value,
      autoCreateLotMaterialIn: createMaterialInLotAuto.value,
      autoCreateLotSalesReturn: createSalesReturnInLotAuto.value,
      autoCreateLotStockDifference: createStockDiffInLotAuto.value,
    );
  }

  // Update the preference with new values
  Future<void> updateTagPreference() async {
    try {
      isUpdating.value = true;

      final request = createUpdateRequest();
      log('Updating tag preference with: ${request.toJson()}');

      await inventoryRepository.updateTagPreference(request);

      showSuccessToast(message: "Tag preferences updated successfully");
      log('Tag preference updated successfully');
    } catch (e) {
      log('Error updating tag preference: $e');
      showErrorToast(message: "Failed to update tag preferences");
    } finally {
      isUpdating.value = false;
    }
  }

  // Reset all fields to default values
  void resetAllFields() {
    lotBasedTaggingOnly.value = false;
    createPurchaseLotAuto.value = false;
    createMaterialInLotAuto.value = false;
    createSalesReturnInLotAuto.value = false;
    createStockDiffInLotAuto.value = false;
    log('All tag preference fields reset to default values');
  }

  // Toggle boolean values
  void toggleBoolValue(RxBool option) {
    option.value = !option.value;
    log('Toggled tag preference value to: ${option.value}');
  }
}
