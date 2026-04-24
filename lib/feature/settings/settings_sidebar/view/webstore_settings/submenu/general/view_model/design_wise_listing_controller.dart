// feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/head_wise_listing_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/model/get_design_web_view_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class DesignWiseListingController extends GetxController {
  final WebstoreRepository webstoreRepository = WebstoreRepository();
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // API response state
  final getDesignResponse = Rx<ApiResponse<GetDesignWebViewListingResponse>>(
    ApiResponse.initial("Initial"),
  );

  // List to store design with their toggle states
  final RxList<DesignToggleState> design = <DesignToggleState>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDesignListing();
  }

  List<DesignToggleState> allDesigns = [];

  final RxList<DesignToggleState> filteredDesigns = <DesignToggleState>[].obs;

  // Fetch design from API
  Future<void> fetchDesignListing() async {
    try {
      isLoading.value = true;
      getDesignResponse.value = ApiResponse.loading("Loading");

      final response = await webstoreRepository.getDesignWebViewListing();
      getDesignResponse.value = ApiResponse.completed(response);

      // Convert API response to toggle state list
      if (response.values != null && response.values!.isNotEmpty) {
        final data =
            response.values!
                .map(
                  (head) => DesignToggleState(
                    id: head.id ?? '',
                    name: head.name ?? '',
                    code: head.code ?? '',
                    isWebstore: RxBool(head.isWebstore ?? false),
                  ),
                )
                .toList();

        allDesigns = List.from(data);
        filteredDesigns.assignAll(data);
        design.assignAll(data);
        log('Loaded ${design.length} design');
      } else {
        design.clear();
        log('No design found');
      }
    } catch (e) {
      log('Error fetching design: $e');
      getDesignResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load design");
      design.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void searchDesigns(String query) {
    if (query.isEmpty) {
      filteredDesigns.assignAll(allDesigns);
    } else {
      filteredDesigns.assignAll(
        allDesigns.where(
          (head) =>
              head.name.toLowerCase().contains(query.toLowerCase()) ||
              head.code.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  // Toggle a specific design's webstore status
  void toggleDesign(int index) {
    if (index >= 0 && index < design.length) {
      design[index].isWebstore.value = !design[index].isWebstore.value;
      log('Toggled ${design[index].name} to ${design[index].isWebstore.value}');
    }
  }

  // Update the saveChanges method to also notify parent controller
  Future<void> saveChanges() async {
    try {
      isUpdating.value = true;

      // Create the update request with all designs and their states
      final updateData =
          design
              .map(
                (head) => {
                  'id': head.id,
                  'name': head.name,
                  'code': head.code,
                  'is_webstore': head.isWebstore.value,
                },
              )
              .toList();

      log('Saving design configuration: ${updateData.length} items');

      // Note: The actual API call will be made by GeneralSettingsController
      // This controller just manages the local state

      showSuccessToast(message: "Design configuration updated");
      log('Design configuration saved successfully');

      // Refresh the data to ensure consistency
      // await fetchDesignListing();
    } catch (e) {
      log('Error saving designs: $e');
      showErrorToast(message: "Failed to save designs");
    } finally {
      isUpdating.value = false;
    }
  }

  // Discard changes by reloading the data
  Future<void> discardChanges() async {
    await fetchDesignListing();
    showSuccessToast(message: "Changes discarded");
    log('Changes discarded, data reloaded');
  }

  // Enable all design
  void enableAll() {
    for (var head in design) {
      head.isWebstore.value = true;
    }
    log('Enabled all design');
  }

  // Disable all design
  void disableAll() {
    for (var head in design) {
      head.isWebstore.value = false;
    }
    log('Disabled all design');
  }
}

// Helper class to manage individual design state
class DesignToggleState {
  final String id;
  final String name;
  final String code;
  final RxBool isWebstore;

  DesignToggleState({
    required this.id,
    required this.name,
    required this.code,
    required this.isWebstore,
  });
}
