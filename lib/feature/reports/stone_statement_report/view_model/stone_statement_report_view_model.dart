import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stone_statement_report/model/stone_statement_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stone_statement_report/model/stone_statement_report_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/item_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/stock_and_value_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class StoneStatementReportViewModel extends GetxController {
  RxString searchQuery = ''.obs;

  final StockAndValueReportRepository stockAndValueReportRepository =
      StockAndValueReportRepository();

  ItemStatementReportRepository stoneStatementReportRepository =
      ItemStatementReportRepository();

  final stoneStatementReportResponseModel =
      Rx<ApiResponse<StoneStatementReportResponse>>(
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
    inclusiveAmount = filterController.inclusiveAmount.value;
  }

  void fetchAllInitialData() {
    stoneStatementValueReport();
    update();
  }

  Future<void> downloadReport() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // TODO: Implement the download report endpoint for stone statement

      // Close loading dialog
      Get.back();

      // For now, show a message that this feature is not yet implemented
      showErrorToast(
        message:
            "Download feature for Stone Statement Report is not yet implemented",
      );
    } catch (e) {
      Get.back(); // Close loading dialog if error occurs
      showErrorToast(message: "Failed to download report: ${e.toString()}");
    }
  }

  Future<void> stoneStatementValueReport() async {
    isLoading.value = true;
    stoneStatementReportResponseModel.value = ApiResponse.loading("LOADING");

    try {
      // Create request model using the current filter state
      StoneStatementReportRequest request = createRequestFromFilters();

      final response = await stoneStatementReportRepository
          .getStoneStatementReport(requestBody: request.toJson());
      stoneStatementReportResponseModel.value = ApiResponse.completed(response);
    } catch (e) {
      stoneStatementReportResponseModel.value = ApiResponse.error(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void applyFilters() {
    // Update inclusive values from filter controller
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
    stoneStatementValueReport();
  }

  StoneStatementReportRequest createRequestFromFilters() {
    return StoneStatementReportRequest(
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
    );
  }

  List<String> get headers => [
    "Code",
    "Stone",
    "Opening",
    "Inward",
    "Outward",
    "Issue",
    "Closing",
  ];

  List<String> get subHeader => [
    "", // Code
    "", // Stone
    "Pcs", // Opening Pcs
    "Wt(cts)", // Opening Weight (shortened)
    if (inclusiveAmount) "Amount", // Opening Amount
    "Pcs", // Inward Pcs
    "Wt(cts)", // Inward Weight (shortened)
    if (inclusiveAmount) "Amount", // Inward Amount
    "Pcs", // Outward Pcs
    "Wt(cts)", // Outward Weight (shortened)
    if (inclusiveAmount) "Amount", // Outward Amount
    "Pcs", // Issue Pcs
    "Wt(cts)", // Issue Weight (shortened)
    if (inclusiveAmount) "Amount", // Issue Amount
    "Pcs", // Closing Pcs
    "Wt(cts)", // Closing Weight (shortened)
    if (inclusiveAmount) "Amount", // Closing Amount
  ];

  List<double> get columnWidths => [
    0.3, // Code (reduced)
    0.55, // Stone (reduced)
    0.2, // Opening Pcs (reduced)
    0.4, // Opening Weight (reduced)
    if (inclusiveAmount) 0.4, // Opening Amount (reduced)
    0.2, // Inward Pcs (reduced)
    0.4, // Inward Weight (reduced)
    if (inclusiveAmount) 0.4, // Inward Amount (reduced)
    0.2, // Outward Pcs (reduced)
    0.4, // Outward Weight (reduced)
    if (inclusiveAmount) 0.4, // Outward Amount (reduced)
    0.2, // Issue Pcs (reduced)
    0.4, // Issue Weight (reduced)
    if (inclusiveAmount) 0.4, // Issue Amount (reduced)
    0.2, // Closing Pcs (reduced)
    0.4, // Closing Weight (reduced)
    if (inclusiveAmount) 0.4, // Closing Amount (reduced)
  ];

  List<double> get columnWidthsHeader => [
    0.3 + 0.55, // Code + Stone (combined width)
    0, // Stone (0 width as it's merged with Code)
    (0.2 + 0.4 + (inclusiveAmount ? 0.4 : 0)), // Opening
    (0.2 + 0.4 + (inclusiveAmount ? 0.4 : 0)), // Inward
    (0.2 + 0.4 + (inclusiveAmount ? 0.4 : 0)), // Outward
    (0.2 + 0.4 + (inclusiveAmount ? 0.4 : 0)), // Issue
    (0.2 + 0.4 + (inclusiveAmount ? 0.4 : 0)), // Closing
  ];

  String formatQuantity(int? value) {
    if (value == null) return '0';
    return value.toString();
  }

  String formatWeight(String? value) {
    if (value == null || value.isEmpty) return '0.00';
    double? numValue = double.tryParse(value);
    if (numValue != null) {
      return numValue.toStringAsFixed(2);
    }
    return '0.00';
  }

  String formatAmount(String? value) {
    if (value == null || value.isEmpty) return '0.00';
    double? numValue = double.tryParse(value);
    if (numValue != null) {
      return numValue.toStringAsFixed(2);
    }
    return '0.00';
  }
}
