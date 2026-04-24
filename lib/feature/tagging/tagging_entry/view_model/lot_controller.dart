import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_lot_entries_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class LotController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final RxString selectedLotNumber = RxString('');
  final getLotEntriesResponse = Rx<ApiResponse<GetLotEntriesDropdownResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxList<GetLotEntriesDropdownValue> lotEntries =
      <GetLotEntriesDropdownValue>[].obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;
  final itemsPerPage = 10;

  void setSelectedLot(String lotNo) {
    selectedLotNumber.value = lotNo;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    getLotEntries(resetList: true, isSearch: true);
  }

  Future<void> getLotEntries({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getLotEntriesResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      // Call the repository with page-based pagination
      final response = await _inventoryRepository.fetchLotEntriesDropdown(
        page: resetList ? 1 : currentPage.value + 1,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      final List<GetLotEntriesDropdownValue> entries = response.values ?? [];
      currentPage.value = response.pagination?.currentPage ?? 1;
      hasMorePages.value = response.pagination?.nextPage != null;

      if (resetList) {
        lotEntries.assignAll(entries);
        getLotEntriesResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = lotEntries;
        List<GetLotEntriesDropdownValue> newData = [...currentData, ...entries];
        lotEntries.assignAll(newData);
        GetLotEntriesDropdownResponse newValue = GetLotEntriesDropdownResponse(
          pagination: response.pagination,
          values: newData,
        );
        getLotEntriesResponse.value = ApiResponse.completed(newValue);
      }
    } catch (e) {
      if (resetList) {
        getLotEntriesResponse.value = ApiResponse.error(e.toString());
      }
      log('Error fetching lot entries: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setInitialConditions({required bool isSearch}) {
    currentPage.value = 1;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> loadMoreItems() async {
    log("loading more ${isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      await getLotEntries(resetList: false);
    }
  }
}
