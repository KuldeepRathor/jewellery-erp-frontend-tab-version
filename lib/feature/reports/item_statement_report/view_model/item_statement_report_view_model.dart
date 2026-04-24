import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/model/item_statement_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/model/item_statement_report_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/item_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/stock_and_value_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/file_download_util.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ItemStatementReportViewModel extends GetxController {
  RxString searchQuery = ''.obs;
  final ItemStatementReportRepository itemStatementReportRepository =
      ItemStatementReportRepository();

  final StockAndValueReportRepository stockAndValueReportRepository =
      StockAndValueReportRepository();

  final itemStatementReportResponseModel =
      Rx<ApiResponse<ItemStatementReportResponseModel>>(
        ApiResponse.initial("INITIAL"),
      );

  final BaseFilterController filterController = Get.put(BaseFilterController());

  final isLoading = true.obs;
  DateTimeRange? pickedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  List<String> selectedOrnamnetsMetalsId = [];
  bool inclusiveGrossWeight = false;
  bool inclusiveAmount = false;

  final isWeightGroupView = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllInitialData();
    filterController.resetAllFilters();

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
      ],
    );

    // Initialize the inclusive values from filter controller
    inclusiveGrossWeight = filterController.inclusiveGrossWeight.value;
    inclusiveAmount = filterController.inclusiveAmount.value;
  }

  void fetchAllInitialData() {
    itemStatementValueReport();
    update();
  }

  Future<void> downloadReport() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await stockAndValueReportRepository
          .downloadItemStatementReport(
            dateFrom: dateFormat.format(
              filterController.dateFrom.value ?? pickedDateRange!.start,
            ),
            dateTo: dateFormat.format(
              filterController.dateTo.value ?? pickedDateRange!.end,
            ),
            type: isWeightGroupView.value ? "Weight Group" : "Stock Head",
          );

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'item_statement_report',
        fileExtension: 'csv',
      );

      if (success) {
        showSuccessToast(message: "Report downloaded successfully");
      } else {
        showErrorToast(message: "Download cancelled or failed");
      }
    } catch (e) {
      Get.back(); // Close loading dialog if error occurs
      showErrorToast(message: "Failed to download report: ${e.toString()}");
    }
  }

  Future<void> itemStatementValueReport() async {
    isLoading.value = true;
    itemStatementReportResponseModel.value = ApiResponse.loading("LOADING");

    try {
      // Create request model using the current filter state
      ItemStatementReportRequest request = createRequestFromFilters();

      final response = await itemStatementReportRepository
          .getItemStatementReport(requestBody: request.toJson());
      itemStatementReportResponseModel.value = ApiResponse.completed(response);
    } catch (e) {
      itemStatementReportResponseModel.value = ApiResponse.error(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void applyFilters() {
    // Update inclusive values from filter controller
    inclusiveGrossWeight = filterController.inclusiveGrossWeight.value;
    inclusiveAmount = filterController.inclusiveAmount.value;

    // Update date range from filter controller
    if (filterController.dateFrom.value != null &&
        filterController.dateTo.value != null) {
      pickedDateRange = DateTimeRange(
        start: filterController.dateFrom.value!,
        end: filterController.dateTo.value!,
      );
    }

    // Create the request model with filters
    final request = createRequestFromFilters();

    // Log the request for debugging purposes
    log("Filter request: ${request.toRawJson()}");

    // Call API with the filter request
    itemStatementValueReport();
  }

  ItemStatementReportRequest createRequestFromFilters() {
    return ItemStatementReportRequest(
      type: isWeightGroupView.value ? "Weight Group" : "Stock Head",
      // Metal types - using multi-select list
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : selectedOrnamnetsMetalsId.isNotEmpty
              ? selectedOrnamnetsMetalsId
              : null,
      // Stock heads - using multi-select list
      stockHead:
          filterController.selectedStockHeads.isNotEmpty
              ? filterController.selectedStockHeads
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      // Weight groups - using multi-select list
      weightGroup:
          filterController.selectedWeightGroups.isNotEmpty
              ? filterController.selectedWeightGroups
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      // Designs - using multi-select list
      design:
          filterController.selectedDesigns.isNotEmpty
              ? filterController.selectedDesigns
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      // Counters - using multi-select list
      counterId:
          filterController.selectedCounters.isNotEmpty
              ? filterController.selectedCounters
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      dateFrom: filterController.dateFrom.value ?? pickedDateRange?.start,
      dateTo: filterController.dateTo.value ?? pickedDateRange?.end,
      // Ornaments - using multi-select list
      ornamentIds:
          filterController.selectedOrnaments.isNotEmpty
              ? filterController.selectedOrnaments
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : selectedOrnamnetsMetalsId.isNotEmpty
              ? selectedOrnamnetsMetalsId
              : null,
      // Vendors - using multi-select list
      vendorIds:
          filterController.selectedVendors.isNotEmpty
              ? filterController.selectedVendors
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      // Purities - using multi-select list
      purity:
          filterController.selectedPurities.isNotEmpty
              ? filterController.selectedPurities
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      // Branches - using multi-select list (if needed in the request model)
      branchIds:
          filterController.selectedBranches.isNotEmpty
              ? filterController.selectedBranches
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      // Sizes - using multi-select list (if needed in the request model)
      // sizeIds: filterController.selectedSizes.isNotEmpty
      //     ? filterController.selectedSizes
      //         .where((item) => item.id != null)
      //         .map((item) => item.id!)
      //         .toList()
      //     : null,
    );
  }

  String getFormattedDateRange() {
    // Get dates from filterController or fall back to pickedDateRange
    final DateTime? fromDate =
        filterController.dateFrom.value ?? pickedDateRange?.start;
    final DateTime? toDate =
        filterController.dateTo.value ?? pickedDateRange?.end;

    // Format dates as DD-MM-YYYY
    final String formattedFromDate =
        fromDate != null
            ? DateFormat('dd-MM-yyyy').format(fromDate)
            : 'DD-MM-YYYY';
    final String formattedToDate =
        toDate != null ? DateFormat('dd-MM-yyyy').format(toDate) : 'DD-MM-YYYY';

    return "($formattedFromDate to $formattedToDate)";
  }

  List<String> get headers => [
    "Code",
    "Item",
    "Opening",
    "Inward",
    "Outward",
    "Issue ",
    "Difference ",
    "Closing ",
    "Stock Closing ",
  ];

  List<String> get subHeader => [
    "",
    "",
    "Pcs",
    "Nt. Wt (gm)",
    if (inclusiveGrossWeight) "Gr. Wt (gm)",
    if (inclusiveAmount) "Amount",
    "Pcs",
    "Nt. Wt (gm)",
    if (inclusiveGrossWeight) "Gr. Wt (gm)",
    if (inclusiveAmount) "Amount",
    "Pcs",
    "Nt. Wt (gm)",
    if (inclusiveGrossWeight) "Gr. Wt (gm)",
    if (inclusiveAmount) "Amount",
    "Pcs",
    "Nt. Wt (gm)",
    if (inclusiveGrossWeight) "Gr. Wt (gm)",
    if (inclusiveAmount) "Amount",
    "Pcs",
    "Nt. Wt (gm)",
    if (inclusiveGrossWeight) "Gr. Wt (gm)",
    if (inclusiveAmount) "Amount",
    "Pcs",
    "Nt. Wt (gm)",
    if (inclusiveGrossWeight) "Gr. Wt (gm)",
    if (inclusiveAmount) "Amount",
    "Pcs",
    "Nt. Wt (gm)",
    if (inclusiveGrossWeight) "Gr. Wt (gm)",
    if (inclusiveAmount) "Amount",
  ];

  List<double> get columnWidths => [
    0.2, // Code
    0.55, // Item
    0.2, // Opening Pcs
    0.35, // Opening Nt. Wt (gm)
    if (inclusiveGrossWeight) 0.35, // Opening Gross Weight
    if (inclusiveAmount) 0.35, // Opening Amount
    0.2, // Inward Pcs
    0.35, // Inward Nt. Wt (gm)
    if (inclusiveGrossWeight) 0.35, // Inward Gross Weight
    if (inclusiveAmount) 0.35, // Inward Amount
    0.2, // Outward Pcs
    0.35, // Outward Nt. Wt (gm)
    if (inclusiveGrossWeight) 0.35, // Outward Gross Weight
    if (inclusiveAmount) 0.35, // Outward Amount
    0.2, // Issue Pcs
    0.35, // Issue Nt. Wt (gm)
    if (inclusiveGrossWeight) 0.35, // Issue Gross Weight
    if (inclusiveAmount) 0.35, // Issue Amount
    0.2, // Difference Pcs
    0.35, // Difference Nt. Wt (gm)
    if (inclusiveGrossWeight) 0.35, // Difference Gross Weight
    if (inclusiveAmount) 0.35, // Difference Amount
    0.2, // Closing Pcs
    0.35, // Closing Nt. Wt (gm)
    if (inclusiveGrossWeight) 0.35, // Closing Gross Weight
    if (inclusiveAmount) 0.35, // Closing Amount
    0.2, // Stock Closing Pcs
    0.35, // Stock Closing Nt. Wt (gm)
    if (inclusiveGrossWeight) 0.35, // Stock Closing Gross Weight
    if (inclusiveAmount) 0.35, // Stock Closing Amount
  ];

  List<double> get columnWidthsHeader => [
    0.2 + 0.55, // Code + Item (combined width)
    0, // Item
    (0.2 +
        0.35 +
        (inclusiveGrossWeight ? 0.35 : 0) +
        (inclusiveAmount ? 0.35 : 0)), // Opening
    (0.2 +
        0.35 +
        (inclusiveGrossWeight ? 0.35 : 0) +
        (inclusiveAmount ? 0.35 : 0)), // Inward
    (0.2 +
        0.35 +
        (inclusiveGrossWeight ? 0.35 : 0) +
        (inclusiveAmount ? 0.35 : 0)), // Outward
    (0.2 +
        0.35 +
        (inclusiveGrossWeight ? 0.35 : 0) +
        (inclusiveAmount ? 0.35 : 0)), // Issue
    (0.2 +
        0.35 +
        (inclusiveGrossWeight ? 0.35 : 0) +
        (inclusiveAmount ? 0.35 : 0)), // Difference
    (0.2 +
        0.35 +
        (inclusiveGrossWeight ? 0.35 : 0) +
        (inclusiveAmount ? 0.35 : 0)), // Closing
    (0.2 +
        0.35 +
        (inclusiveGrossWeight ? 0.35 : 0) +
        (inclusiveAmount ? 0.35 : 0)), // Stock Closing
  ];
}
