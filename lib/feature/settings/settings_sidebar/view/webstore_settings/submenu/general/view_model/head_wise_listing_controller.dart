// feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/head_wise_listing_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/get_stock_heads_web_view_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class HeadWiseListingController extends GetxController {
  final WebstoreRepository webstoreRepository = WebstoreRepository();
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // API response state
  final getStockHeadsResponse =
      Rx<ApiResponse<GetStockHeadsWebViewListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  // List to store stock heads with their toggle states
  final RxList<StockHeadToggleState> stockHeads = <StockHeadToggleState>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStockHeads();
  }

  List<StockHeadToggleState> allStockHeads = [];

  final RxList<StockHeadToggleState> filteredStockHeads =
      <StockHeadToggleState>[].obs;

  // Fetch stock heads from API
  Future<void> fetchStockHeads() async {
    try {
      isLoading.value = true;
      getStockHeadsResponse.value = ApiResponse.loading("Loading");

      final response = await webstoreRepository.getStockHeadsWebViewListing();
      getStockHeadsResponse.value = ApiResponse.completed(response);

      // Convert API response to toggle state list
      // if (response.values != null && response.values!.isNotEmpty) {
      //   stockHeads.value = response.values!
      //       .map((head) => StockHeadToggleState(
      //             id: head.id ?? '',
      //             name: head.name ?? '',
      //             code: head.code ?? '',
      //             isWebstore: RxBool(head.isWebstore ?? false),
      //           ))
      //       .toList();
      if (response.values != null && response.values!.isNotEmpty) {
        final data =
            response.values!
                .map(
                  (head) => StockHeadToggleState(
                    id: head.id ?? '',
                    name: head.name ?? '',
                    code: head.code ?? '',
                    isWebstore: RxBool(head.isWebstore ?? false),
                  ),
                )
                .toList();

        allStockHeads = List.from(data);
        filteredStockHeads.assignAll(data);
        stockHeads.assignAll(data);

        log('Loaded ${stockHeads.length} stock heads');
      } else {
        stockHeads.clear();
        log('No stock heads found');
      }
    } catch (e) {
      log('Error fetching stock heads: $e');
      getStockHeadsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load stock heads");
      stockHeads.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void searchStockHeads(String query) {
    if (query.isEmpty) {
      filteredStockHeads.assignAll(allStockHeads);
    } else {
      filteredStockHeads.assignAll(
        allStockHeads.where(
          (head) =>
              head.name.toLowerCase().contains(query.toLowerCase()) ||
              head.code.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  // Toggle a specific stock head's webstore status
  void toggleStockHead(int index) {
    if (index >= 0 && index < stockHeads.length) {
      stockHeads[index].isWebstore.value = !stockHeads[index].isWebstore.value;
      log(
        'Toggled ${stockHeads[index].name} to ${stockHeads[index].isWebstore.value}',
      );
    }
  }

  // Update the saveChanges method to also notify parent controller
  Future<void> saveChanges() async {
    try {
      isUpdating.value = true;

      // Create the update request with all stock heads and their states
      final updateData =
          stockHeads
              .map(
                (head) => {
                  'id': head.id,
                  'name': head.name,
                  'code': head.code,
                  'is_webstore': head.isWebstore.value,
                },
              )
              .toList();

      log('Saving stock heads configuration: ${updateData.length} items');

      // Note: The actual API call will be made by GeneralSettingsController
      // This controller just manages the local state

      showSuccessToast(message: "Stock heads configuration updated");
      log('Stock heads configuration saved successfully');

      // Refresh the data to ensure consistency
      // await fetchStockHeads();
    } catch (e) {
      log('Error saving stock heads: $e');
      showErrorToast(message: "Failed to save stock heads");
    } finally {
      isUpdating.value = false;
    }
  }

  // Discard changes by reloading the data
  Future<void> discardChanges() async {
    await fetchStockHeads();
    showSuccessToast(message: "Changes discarded");
    log('Changes discarded, data reloaded');
  }

  // Enable all stock heads
  void enableAll() {
    for (var head in stockHeads) {
      head.isWebstore.value = true;
    }
    log('Enabled all stock heads');
  }

  // Disable all stock heads
  void disableAll() {
    for (var head in stockHeads) {
      head.isWebstore.value = false;
    }
    log('Disabled all stock heads');
  }
}

// Helper class to manage individual stock head state
class StockHeadToggleState {
  final String id;
  final String name;
  final String code;
  final RxBool isWebstore;

  StockHeadToggleState({
    required this.id,
    required this.name,
    required this.code,
    required this.isWebstore,
  });
}
