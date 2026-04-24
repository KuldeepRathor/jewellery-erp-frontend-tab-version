import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class GemstonesController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  // Gemstones state variables
  final getStoneRatesResponse = Rx<ApiResponse<GetStoneRatesResponse>>(
    ApiResponse.initial("Initial"),
  );
  final RxList<GetStoneRatesValue> gemstoneOptions = <GetStoneRatesValue>[].obs;
  final RxList<GetStoneRatesValue> selectedGemstones =
      <GetStoneRatesValue>[].obs;
  final RxList<GetStoneRatesValue> filteredGemstones =
      <GetStoneRatesValue>[].obs;

  // UI control variables
  final gemstoneSearchController = TextEditingController().obs;
  final gemstoneFocusNode = FocusNode();
  final RxBool isGemstoneDropdownOpen = false.obs;
  final RxBool isLoadingGemstones = false.obs;

  // Form value
  final RxString gemstones = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGemstones();
  }

  @override
  void onClose() {
    gemstoneSearchController.value.dispose();
    gemstoneFocusNode.dispose();
    super.onClose();
  }

  void toggleDropdown() {
    isGemstoneDropdownOpen.value = !isGemstoneDropdownOpen.value;

    // If opening dropdown, initialize filtered list
    if (isGemstoneDropdownOpen.value) {
      filteredGemstones.value = gemstoneOptions;
    }
  }

  Future<void> searchGemstonesList(String query) async {
    isLoadingGemstones.value = true;

    try {
      if (query.isEmpty) {
        filteredGemstones.value = gemstoneOptions;
      } else if (query.length > 2) {
        // Search from API if query is substantial
        final results = await searchGemstones(query);
        filteredGemstones.value = results;
      } else {
        // Local filtering for short queries
        filteredGemstones.value =
            gemstoneOptions
                .where(
                  (stone) =>
                      stone.name?.toLowerCase().contains(query.toLowerCase()) ??
                      false,
                )
                .toList();
      }
    } catch (e) {
      log('Error searching gemstones: $e');
    } finally {
      isLoadingGemstones.value = false;
    }
  }

  void toggleSelection(GetStoneRatesValue stone) {
    final isAlreadySelected = selectedGemstones.any(
      (selected) => selected.id == stone.id,
    );

    if (isAlreadySelected) {
      selectedGemstones.removeWhere((selected) => selected.id == stone.id);
    } else {
      selectedGemstones.add(stone);
    }

    // Update the gemstones value for form submission
    updateGemstonesValue();

    // Ensure UI updates
    selectedGemstones.refresh();
  }

  void removeGemstone(GetStoneRatesValue stone) {
    selectedGemstones.removeWhere((selected) => selected.id == stone.id);

    // Update the gemstones value
    updateGemstonesValue();

    // Ensure UI updates
    selectedGemstones.refresh();
  }

  void updateGemstonesValue() {
    gemstones.value = selectedGemstones
        .map((stone) => stone.name)
        .where((name) => name != null && name.isNotEmpty)
        .join(', ');
  }

  Future<void> fetchGemstones({String query = ''}) async {
    try {
      isLoadingGemstones.value = true;
      getStoneRatesResponse.value = ApiResponse.loading("Loading gemstones");
      final response = await _inventoryRepository.getStoneRates(
        limit: 1000, // Large limit to get most results
        query: query,
      );
      gemstoneOptions.value = response.values ?? [];
      filteredGemstones.value = gemstoneOptions; // Initialize filtered list
      getStoneRatesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getStoneRatesResponse.value = ApiResponse.error(e.toString());
      log('Error fetching gemstones: $e');
    } finally {
      isLoadingGemstones.value = false;
    }
  }

  Future<List<GetStoneRatesValue>> searchGemstones(String query) async {
    if (query.isEmpty) {
      return gemstoneOptions;
    }

    if (gemstoneOptions.isEmpty || query.length > 2) {
      await fetchGemstones(query: query);
    }

    return gemstoneOptions
        .where(
          (stone) =>
              stone.name?.toLowerCase().contains(query.toLowerCase()) ?? false,
        )
        .toList();
  }

  void setSelectedGemstone(GetStoneRatesValue stone) {
    if (!selectedGemstones.any((selected) => selected.id == stone.id)) {
      selectedGemstones.add(stone);
      updateGemstonesValue();
      gemstoneSearchController.value.text = stone.name ?? '';
    }
  }
}
