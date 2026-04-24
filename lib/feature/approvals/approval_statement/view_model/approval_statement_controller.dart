import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/approval_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_approval_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class ApprovalStatementsController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final BaseFilterController filterController = Get.put(BaseFilterController());

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final selectedStatusFilter = "All".obs;
  final statusFilterOptions = ["All", "Pending", "Received"].obs;

  final headers =
      [
        "Issue Number",
        "Issue Date",
        "Party",
        "Barcode",
        "Tag Number",
        "Pieces",
        "Gross Weight",
        "Nett Weight",
        "Receipt Date",
        "Receipt Number",
        "Status",
      ].obs;

  final columnWidths = [
    0.3, // Issue Number
    0.3, // Issue Date
    0.5, // Party
    0.3, // Barcode
    0.3, // Tag Number
    0.3, // Pieces
    0.4, // Gross Weight
    0.4, // Nett Weight
    0.4, // Receipt Date
    0.4, // Receipt Number
    0.3, // Status
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getApprovalListingResponse =
      Rx<ApiResponse<GetApprovalListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  final taggingDetailsResponse = Rx<ApiResponse<GetTaggingLineItemResponse>>(
    ApiResponse.initial("Initial"),
  );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  // Track selected row index
  final RxInt selectedRowIndex = (-1).obs;

  // Selected approval details
  final Rx<GetApprovalListingValue?> selectedApproval = Rx(null);

  @override
  void onInit() {
    log("Approval Listing");
    super.onInit();
    filterController.resetAllFilters();

    // Initialize filter controller with required filter types
    filterController.fetchAllDropdownData(
      filterTypes: [
        'metalType',
        'ornament',
        'stockHead',
        'weightGroup',
        'design',
        'purity',
        'branch',
        'counter',
        'size',
        'vendor', // For party filter
        'taggedBy',
      ],
    );

    getApprovalListingDetails(resetList: true);
  }

  void applyStatusFilter(String status) {
    selectedStatusFilter.value = status;
    // Reset and reload with new status filter
    getApprovalListingDetails(resetList: true);
  }

  String formatDate(dynamic dateInput) {
    if (dateInput == null) return "-";

    DateTime? date;
    if (dateInput is DateTime) {
      date = dateInput;
    } else if (dateInput is String) {
      try {
        date = DateTime.parse(dateInput);
      } catch (e) {
        log('Error parsing date string: $e');
        return dateInput;
      }
    }

    if (date != null) {
      return DateFormat('dd-MM-yyyy').format(date);
    } else {
      return "-";
    }
  }

  void updateSelectedRow(int index, GetApprovalListingValue? rowData) {
    selectedRowIndex.value = index;
    selectedApproval.value = rowData;

    if (rowData != null && rowData.taggingId != null) {
      // Fetch tagging details when row is selected
      fetchTaggingDetails(rowData.taggingId!);
    } else {
      // Clear tagging details if no valid tagging ID
      taggingDetailsResponse.value = ApiResponse.initial("Initial");
    }
  }

  void selectPreviousRow() {
    if (selectedRowIndex.value > 0) {
      final previousIndex = selectedRowIndex.value - 1;
      final previousRow = getApprovalListingResponse.value.data?.values
          ?.elementAt(previousIndex);
      updateSelectedRow(previousIndex, previousRow);
    }
  }

  void selectNextRow() {
    final maxIndex =
        (getApprovalListingResponse.value.data?.values?.length ?? 0) - 1;
    if (selectedRowIndex.value < maxIndex) {
      final nextIndex = selectedRowIndex.value + 1;
      final nextRow = getApprovalListingResponse.value.data?.values?.elementAt(
        nextIndex,
      );
      updateSelectedRow(nextIndex, nextRow);
    }
  }

  Future<void> fetchTaggingDetails(String taggingId) async {
    taggingDetailsResponse.value = ApiResponse.loading("Loading");
    try {
      final response = await inventoryRepository.getTaggingLineItem(taggingId);
      taggingDetailsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      taggingDetailsResponse.value = ApiResponse.error(e.toString());
      log("Error fetching tagging details: $e");
    }
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
    selectedRowIndex.value = -1;
    selectedApproval.value = null;
    taggingDetailsResponse.value = ApiResponse.initial("Initial");
  }

  // Create request from filters
  ApprovalListingRequest createRequestFromFilters() {
    List<String>? statusList;
    if (selectedStatusFilter.value != "All") {
      statusList = [selectedStatusFilter.value];
    }
    return ApprovalListingRequest(
      status: statusList,

      // Metal types
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Ornament types
      ornamentType:
          filterController.selectedOrnaments.isNotEmpty
              ? filterController.selectedOrnaments
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Weight groups
      weightGroup:
          filterController.selectedWeightGroups.isNotEmpty
              ? filterController.selectedWeightGroups
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Stock heads
      stockHead:
          filterController.selectedStockHeads.isNotEmpty
              ? filterController.selectedStockHeads
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Designs
      design:
          filterController.selectedDesigns.isNotEmpty
              ? filterController.selectedDesigns
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Purities
      purity:
          filterController.selectedPurities.isNotEmpty
              ? filterController.selectedPurities
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Branches
      branch:
          filterController.selectedBranches.isNotEmpty
              ? filterController.selectedBranches
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Counters
      counterId:
          filterController.selectedCounters.isNotEmpty
              ? filterController.selectedCounters
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Size groups
      sizeGroups:
          filterController.selectedSizes.isNotEmpty
              ? filterController.selectedSizes
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Party/Vendor IDs
      partyId:
          filterController.selectedVendors.isNotEmpty
              ? filterController.selectedVendors
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Date range
      dateFrom: filterController.dateFrom.value,
      dateTo: filterController.dateTo.value,

      // Tagged by
      taggedBy:
          filterController.selectedTaggedBys.isNotEmpty
              ? filterController.selectedTaggedBys
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Weight ranges
      minGrossWeight: filterController.minGrossWeight.value,
      maxGrossWeight: filterController.maxGrossWeight.value,
      minNetWeight: filterController.minNetWeight.value,
      maxNetWeight: filterController.maxNetWeight.value,
    );
  }

  // Apply filters method
  void applyFilters() {
    getApprovalListingDetails(resetList: true);
  }

  Future<void> getApprovalListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getApprovalListingResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      // Create request with all filters
      final filterRequest = createRequestFromFilters();

      final response = await inventoryRepository.getApprovalListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
        filterRequest: filterRequest,
      );

      if (resetList) {
        getApprovalListingResponse.value = ApiResponse.completed(response);
        // Auto-select first row if available
        if (response.values?.isNotEmpty ?? false) {
          updateSelectedRow(0, response.values!.first);
        }
      } else {
        final currentData = getApprovalListingResponse.value.data?.values ?? [];
        List<GetApprovalListingValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getApprovalListingResponse.value = ApiResponse.completed(response);
      }
      hasMorePages.value = response.pagination?.nextPage != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.nextPage != null) {
          lastOffsetId = response.pagination?.nextPage.toString();
        }
      }
    } catch (e) {
      getApprovalListingResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getApprovalListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getApprovalListingDetails();
    }
  }

  void resetFields() {
    selectedRowIndex.value = -1;
    selectedApproval.value = null;
    taggingDetailsResponse.value = ApiResponse.initial("Initial");
  }

  // Get active filters count for display
  String getActiveFiltersCount() {
    int count = 0;
    if (filterController.selectedMetalTypes.isNotEmpty) count++;
    if (filterController.selectedOrnaments.isNotEmpty) count++;
    if (filterController.selectedWeightGroups.isNotEmpty) count++;
    if (filterController.selectedStockHeads.isNotEmpty) count++;
    if (filterController.selectedDesigns.isNotEmpty) count++;
    if (filterController.selectedPurities.isNotEmpty) count++;
    if (filterController.selectedBranches.isNotEmpty) count++;
    if (filterController.selectedCounters.isNotEmpty) count++;
    if (filterController.selectedSizes.isNotEmpty) count++;
    if (filterController.selectedVendors.isNotEmpty) count++;
    if (filterController.selectedTaggedBys.isNotEmpty) count++;
    if (filterController.minGrossWeight.value != null) count++;
    if (filterController.maxGrossWeight.value != null) count++;
    if (filterController.minNetWeight.value != null) count++;
    if (filterController.maxNetWeight.value != null) count++;
    if (filterController.dateFrom.value != null ||
        filterController.dateTo.value != null) {
      count++;
    }
    return count > 0 ? ' ($count)' : '';
  }
}
