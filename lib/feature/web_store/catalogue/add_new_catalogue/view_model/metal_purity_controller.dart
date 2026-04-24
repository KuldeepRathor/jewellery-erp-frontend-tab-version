import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/get_daily_rate_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class MetalPurityFilterController extends GetxController {
  final RxList<String> selectedMetals = <String>[].obs;
  final RxList<String> selectedPurities = <String>[].obs;
  final RxBool isDropdownOpen = false.obs;
  final InventoryRepository _inventoryRepository = InventoryRepository();

  // Updated metal types with purities from DailyRatesListingViewModel
  final Map<String, List<String>> metalPurities = {
    'Gold': ['24k', '23k', '22k', '20k', '18k', '14k', '9k'],
    'Silver': ['Silver', '999', '925'],
    'Platinum': ['Platinum'],
  };

  final dailyRatesResponse = Rx<ApiResponse<GetPaginatedDailyRatesResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  @override
  void onInit() {
    super.onInit();
    log("Metal Purity Filter controller initiated");
    getDailyRatesListingDetails(resetList: true);
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getDailyRatesListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      dailyRatesResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _inventoryRepository.getPaginatedDailyRates(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId,
      );

      if (resetList) {
        dailyRatesResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = dailyRatesResponse.value.data?.values ?? [];
        List<DailyRateResponse> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        dailyRatesResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        dailyRatesResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more called");
      await getDailyRatesListingDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    getDailyRatesListingDetails(resetList: true, isSearch: true);
  }

  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  void toggleMetal(String metal) {
    if (selectedMetals.contains(metal)) {
      selectedMetals.remove(metal);
      // Remove all purities of this metal
      selectedPurities.removeWhere((purity) => purity.startsWith(metal));
    } else {
      selectedMetals.add(metal);
    }
  }

  void togglePurity(String metal, String purity) {
    String fullPurity = '$metal $purity';
    if (selectedPurities.contains(fullPurity)) {
      selectedPurities.remove(fullPurity);
      // Check if we need to remove the metal
      if (!selectedPurities.any((p) => p.startsWith(metal))) {
        selectedMetals.remove(metal);
      }
    } else {
      selectedPurities.add(fullPurity);
      // Ensure parent metal is selected
      if (!selectedMetals.contains(metal)) {
        selectedMetals.add(metal);
      }
    }
  }

  void clearSelections() {
    selectedMetals.clear();
    selectedPurities.clear();
    isDropdownOpen.value = false;
  }
}
