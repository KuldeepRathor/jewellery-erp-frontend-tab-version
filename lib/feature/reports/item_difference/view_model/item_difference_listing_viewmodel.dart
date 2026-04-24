import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/models/item_difference_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/models/item_difference_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/stock_and_value_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/file_download_util.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ItemDifferenceListingViewmodel extends GetxController {
  final StockAndValueReportRepository _stockAndValueReportRepository =
      StockAndValueReportRepository();
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final BaseFilterController filterController = Get.put(BaseFilterController());

  // Updated headers to match the image
  final headers =
      [
        'Date',
        'Code',
        'Description',
        'Pc',
        'Act. Net Wt',
        'Sales Wt',
        'Difference',
        'Amount',
      ].obs;

  // Updated column widths to match new headers
  final columnWidths =
      [
        0.4, // Date
        0.4, // Code
        1.2, // Description
        0.3, // Pc
        0.4, // Act. Net Wt
        0.4, // Sales Wt
        0.4, // Difference
        0.4, // Amount
      ].obs;

  final itemDifferenceReportResponse =
      Rx<ApiResponse<ItemDifferenceReportResponse>>(
        ApiResponse.initial("INITIAL"),
      );

  final totalDifference = "0.00".obs;
  final totalAmount = "0.00".obs;
  final totalPieces = "0".obs;
  final totalSalesWeight = "0.00".obs;
  final totalActualWeight = "0.00".obs;

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  // Track selected row index
  final RxInt selectedRowIndex = (-1).obs;

  // Additional details for the selected item (bottom panel)
  final RxString selectedCustomer = ''.obs;
  final RxString selectedTime = ''.obs;
  final RxString selectedInvoiceNo = ''.obs;
  final RxString selectedTxnType = ''.obs;
  final RxString selectedUser = ''.obs;

  final RxString selectedHead = ''.obs;
  final RxString selectedGrossWt = ''.obs;
  final RxString selectedOrnamentType = ''.obs;
  final RxString selectedStoneCost = ''.obs;
  final RxString selectedItemGroup = ''.obs;
  final RxString selectedCounter = ''.obs;
  final RxString selectedBarcodeNo = ''.obs;

  @override
  void onInit() {
    super.onInit();
    log("Item Difference Listing viewmodel initiated");
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
        'vendor',
        'status',
        'taggedBy',
      ],
    );

    getItemDifferenceReportDetails(resetList: true);
  }

  @override
  void onClose() {
    log("Item Difference Listing viewmodel Deleted");
    super.onClose();
  }

  void updateSelectedRow(int index, ItemDifferenceReportValue? rowData) {
    selectedRowIndex.value = index;

    if (rowData != null) {
      // Customer details
      selectedCustomer.value = rowData.partyName ?? 'N/A';
      selectedTime.value =
          rowData.createdAt != null
              ? '${rowData.createdAt!.hour.toString().padLeft(2, '0')}:${rowData.createdAt!.minute.toString().padLeft(2, '0')} ${rowData.createdAt!.hour >= 12 ? 'PM' : 'AM'}'
              : 'N/A';
      selectedInvoiceNo.value = rowData.saleNumber ?? 'N/A';
      selectedTxnType.value = '-'; // Default or you may set from some property
      selectedUser.value = '-'; // Default or you may set from some property

      // Item details
      selectedHead.value = rowData.stockHead ?? 'N/A';
      selectedGrossWt.value = rowData.grossWeight ?? 'N/A';
      selectedOrnamentType.value = rowData.ornament ?? 'N/A';
      selectedStoneCost.value = rowData.stoneCost ?? 'N/A';
      selectedItemGroup.value =
          '-'; // Default or you may set from some property
      selectedCounter.value = rowData.counterName ?? 'N/A';
      selectedBarcodeNo.value = rowData.tagBarcode ?? 'N/A';
    } else {
      resetSelectedDetails();
    }
  }

  void resetSelectedDetails() {
    selectedCustomer.value = 'N/A';
    selectedTime.value = 'N/A';
    selectedInvoiceNo.value = 'N/A';
    selectedTxnType.value = 'N/A';
    selectedUser.value = 'N/A';

    selectedHead.value = 'N/A';
    selectedGrossWt.value = 'N/A';
    selectedOrnamentType.value = 'N/A';
    selectedStoneCost.value = 'N/A';
    selectedItemGroup.value = 'N/A';
    selectedCounter.value = 'N/A';
    selectedBarcodeNo.value = 'N/A';
  }

  void selectPreviousRow() {
    if (selectedRowIndex.value > 0) {
      final previousIndex = selectedRowIndex.value - 1;
      final previousRow = itemDifferenceReportResponse.value.data?.values
          ?.elementAt(previousIndex);
      updateSelectedRow(previousIndex, previousRow);
    }
  }

  void selectNextRow() {
    final maxIndex =
        (itemDifferenceReportResponse.value.data?.values?.length ?? 0) - 1;
    if (selectedRowIndex.value < maxIndex) {
      final nextIndex = selectedRowIndex.value + 1;
      final nextRow = itemDifferenceReportResponse.value.data?.values
          ?.elementAt(nextIndex);
      updateSelectedRow(nextIndex, nextRow);
    }
  }

  void updateTotals() {
    final data = itemDifferenceReportResponse.value.data;
    if (data != null) {
      totalDifference.value = data.totalDifference ?? "0.00";
      totalAmount.value = data.totalAmount ?? "0.00";
      totalPieces.value = data.totalPieces?.toString() ?? "0";
      totalSalesWeight.value = data.totalSalesWeight ?? "0.00";
      totalActualWeight.value = data.totalActualWeight ?? "0.00";
    } else {
      totalDifference.value = "0.00";
      totalAmount.value = "0.00";
      totalPieces.value = "0";
      totalSalesWeight.value = "0.00";
      totalActualWeight.value = "0.00";
    }
  }

  TableRow buildTableHeaders() {
    log("The controllers length : ${headers.length} ");
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sr") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  void setInitialConditions({required bool isSearch}) {
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  // Create request from filters
  ItemDifferenceReportRequest createRequestFromFilters() {
    return ItemDifferenceReportRequest(
      organizationId: null, // You might need to get this from somewhere
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

      // Status
      status:
          filterController.selectedStatuses.isNotEmpty
              ? filterController.selectedStatuses
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

      // Min/Max record numbers
      // minRecordNumber: filterController.minRecordNumber.value,
      // maxRecordNumber: filterController.maxRecordNumber.value,

      // // Min/Max lot numbers
      // minLotNumber: filterController.minLotNumber.value,
      // maxLotNumber: filterController.maxLotNumber.value,
    );
  }

  // Apply filters method
  void applyFilters() {
    getItemDifferenceReportDetails(resetList: true);
  }

  Future<void> getItemDifferenceReportDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      itemDifferenceReportResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      // Create request with all filters
      final request = createRequestFromFilters();

      final response = await _stockAndValueReportRepository
          .getItemDifferenceReport(requestBody: request);

      itemDifferenceReportResponse.value = ApiResponse.completed(response);

      if (response.values != null && response.values!.isNotEmpty) {
        selectedRowIndex.value = 0;
        updateSelectedRow(0, response.values!.first);
      } else {
        selectedRowIndex.value = -1;
        resetSelectedDetails();
      }

      updateTotals();

      // Since this appears to be a report endpoint, we'll assume it returns all data at once
      hasMorePages.value = false;
    } catch (e) {
      if (resetList) {
        itemDifferenceReportResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> downloadReportDetails() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Create request with all filters
      // final request = createRequestFromFilters();

      List<int> bytes;
      try {
        final result = await _stockAndValueReportRepository
            .downloadItemDifferenceReport(
              requestBody: createRequestFromFilters(),
            );

        if (result is String) {
          // If somehow still getting string, convert
          bytes = utf8.encode(result as String);
        } else {
          bytes = result;
        }
      } catch (e) {
        // Close loading dialog if error occurs
        Get.back();
        showErrorToast(message: "Failed to download report: ${e.toString()}");
        return;
      }

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      try {
        final success = await FileDownloadUtil.downloadFile(
          fileData: bytes,
          fileNamePrefix: 'item_difference_report',
          fileExtension: 'csv',
        );

        if (success) {
          showSuccessToast(message: "Report downloaded successfully");
        } else {
          showErrorToast(message: "Download cancelled or failed");
        }
      } catch (e) {
        showErrorToast(message: "Error saving file: ${e.toString()}");
      }
    } catch (e) {
      // Final fallback error handling
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      showErrorToast(message: "Failed to download report: ${e.toString()}");
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getItemDifferenceReportDetails(resetList: true, isSearch: true);
    });
  }

  String getFormattedDateRange() {
    // Get dates from filterController
    final DateTime? fromDate = filterController.dateFrom.value;
    final DateTime? toDate = filterController.dateTo.value;

    // Format dates as DD-MM-YYYY
    final String formattedFromDate =
        fromDate != null ? DateFormat('dd-MM-yyyy').format(fromDate) : '';
    final String formattedToDate =
        toDate != null ? DateFormat('dd-MM-yyyy').format(toDate) : 'DD-MM-YYYY';

    return "($formattedFromDate to $formattedToDate)";
  }

  // Get active filters count
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
    if (filterController.selectedStatuses.isNotEmpty) count++;
    if (filterController.selectedTaggedBys.isNotEmpty) count++;
    if (filterController.minRecordNumber.value != null) count++;
    if (filterController.maxRecordNumber.value != null) count++;
    if (filterController.minLotNumber.value != null) count++;
    if (filterController.maxLotNumber.value != null) count++;
    if (filterController.dateFrom.value != null ||
        filterController.dateTo.value != null) {
      count++;
    }
    return count > 0 ? ' ($count)' : '';
  }
}
