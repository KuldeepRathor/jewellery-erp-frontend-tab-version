import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_metal_color_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/get_catalogue_metal_color_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class MetalColorViewModel extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  // Metal color state variables
  final getCatalogMetalColorResponse =
      Rx<ApiResponse<List<GetCatalogMetalColorResponse>>>(
        ApiResponse.initial("Initial"),
      );
  final RxList<GetCatalogMetalColorResponse> metalColorOptions =
      <GetCatalogMetalColorResponse>[].obs;
  final RxList<GetCatalogMetalColorResponse> selectedMetalColors =
      <GetCatalogMetalColorResponse>[].obs;
  final RxList<GetCatalogMetalColorResponse> filteredMetalColors =
      <GetCatalogMetalColorResponse>[].obs;

  // For backward compatibility
  final selectedMetalColor = Rx<GetCatalogMetalColorResponse?>(null);

  // UI control variables
  final metalColorSearchController = TextEditingController().obs;
  final metalColorFocusNode = FocusNode();
  final RxBool isMetalColorDropdownOpen = false.obs;

  // Per-item selected color map: itemId -> colourName
  final RxMap<String, String> itemMetalColorMap = <String, String>{}.obs;

  void setItemMetalColor(String itemId, String colourName) {
    itemMetalColorMap[itemId] = colourName;
  }

  String? getItemMetalColor(String itemId) {
    return itemMetalColorMap[itemId];
  }

  // Form value
  final RxString metalColor = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMetalColors();
  }

  @override
  void onClose() {
    metalColorSearchController.value.dispose();
    metalColorFocusNode.dispose();
    super.onClose();
  }

  void toggleDropdown() {
    isMetalColorDropdownOpen.value = !isMetalColorDropdownOpen.value;

    // If opening dropdown, initialize filtered list
    if (isMetalColorDropdownOpen.value) {
      filteredMetalColors.value = metalColorOptions;
    }
  }

  Future<void> searchMetalColors(String query) async {
    if (query.isEmpty) {
      filteredMetalColors.value = metalColorOptions;
    } else {
      filteredMetalColors.value =
          metalColorOptions
              .where(
                (color) =>
                    color.colourName?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false,
              )
              .toList();
    }
  }

  void toggleSelection(GetCatalogMetalColorResponse color) {
    final isAlreadySelected = selectedMetalColors.any(
      (selected) => selected.id == color.id,
    );

    if (isAlreadySelected) {
      selectedMetalColors.removeWhere((selected) => selected.id == color.id);
    } else {
      selectedMetalColors.add(color);
    }

    // Update the metalColor value for form submission
    updateMetalColorValue();

    // Ensure UI updates
    selectedMetalColors.refresh();
  }

  void removeMetalColor(GetCatalogMetalColorResponse color) {
    selectedMetalColors.removeWhere((selected) => selected.id == color.id);

    // Update the metalColor value
    updateMetalColorValue();
  }

  void updateMetalColorValue() {
    metalColor.value = selectedMetalColors
        .map((color) => color.colourName)
        .where((name) => name != null && name.isNotEmpty)
        .join(', ');
  }

  Future<void> fetchMetalColors() async {
    try {
      getCatalogMetalColorResponse.value = ApiResponse.loading(
        "Loading metal colors",
      );
      final List<GetCatalogMetalColorResponse> response =
          await _inventoryRepository.getCatlogMetaColor();
      metalColorOptions.value = response;
      filteredMetalColors.value = response; // Initialize filtered list
      getCatalogMetalColorResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getCatalogMetalColorResponse.value = ApiResponse.error(e.toString());
      log('Error fetching metal colors: $e');
    }
  }

  void setSelectedMetalColor(GetCatalogMetalColorResponse color) {
    // For backward compatibility with single selection
    selectedMetalColor.value = color;
    if (!selectedMetalColors.any((selected) => selected.id == color.id)) {
      selectedMetalColors.add(color);
      updateMetalColorValue();
      metalColorSearchController.value.text = color.colourName ?? '';
    }
  }

  Future<void> updateMetalColorApi({
    required String itemId,
    required String colorId,
  }) async {
    try {
      await _inventoryRepository.updateMetalColor(
        request: UpdateMetalColorRequest(
          taggingLineItemId: itemId,
          metalColorId: colorId,
        ),
      );
    } catch (e) {
      log("Error updating metal color: $e");
    }
  }
}
