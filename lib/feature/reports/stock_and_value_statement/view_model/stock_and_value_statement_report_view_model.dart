import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/model/stock_and_value_statement_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/model/stock_and_value_statement_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/stock_and_value_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/file_download_util.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

// Local DropdownItem class for backward compatibility
class DropdownItem {
  final String? id;
  final String? name;

  DropdownItem({this.id, this.name});
}

class StockAndValueStatementReportViewModel extends GetxController {
  RxString searchQuery = ''.obs;
  final StockAndValueReportRepository _stockAndValueReportRepository =
      StockAndValueReportRepository();

  final stockAndStatmentValueReportResponseModel =
      Rx<ApiResponse<StockAndStatmentValueReportResponseModel>>(
        ApiResponse.initial("INITIAL"),
      );

  // Add BaseFilterController similar to ItemStatementReportViewModel
  final BaseFilterController filterController = Get.put(BaseFilterController());

  // Keep existing properties for backward compatibility
  final Rx<ApiResponse<List<DropdownItem>>> metalTypeResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> ornamentTypeResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));

  List<DropdownItem> selectedMetalTypes = [];
  List<DropdownItem> metalTypes = [];

  final isGroupView = false.obs;
  final isLoading = true.obs;

  DateTimeRange? pickedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  List<Map<String, dynamic>> selectedOrnamnetsMetalsId = [];
  bool inclusiveGrossWeight = false;
  bool inclusiveAmount = false;

  @override
  void onInit() {
    super.onInit();
    fetchAllInitialData();
    // Initialize filter controller with required filter types
    filterController.resetAllFilters();

    filterController.fetchAllDropdownData(
      filterTypes: [
        'metalType',
        'ornament',
        'stockHead',
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
    getStockAndStatementValueReport();
    getOrnamentsMetalTypes();
    update();
  }

  Future<void> getStockAndStatementValueReport() async {
    isLoading.value = true;
    stockAndStatmentValueReportResponseModel.value = ApiResponse.loading(
      "LOADING",
    );

    try {
      final response = await _stockAndValueReportRepository
          .getStockAndStatementValueReport(
            query: searchQuery.value,
            startDate: dateFormat.format(
              filterController.dateFrom.value ?? pickedDateRange!.start,
            ),
            endDate: dateFormat.format(
              filterController.dateTo.value ?? pickedDateRange!.end,
            ),
            limit: 10,
            requestBody: createRequestBodyFromFilters(),
          );
      stockAndStatmentValueReportResponseModel.value = ApiResponse.completed(
        response,
      );
    } catch (e) {
      stockAndStatmentValueReportResponseModel.value = ApiResponse.error(
        e.toString(),
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Map<String, dynamic> createRequestBodyFromFilters() {
    // Create request model instance
    final request = StockAndValueStatementReportRequest();

    // Add metal types - using multi-select list
    if (filterController.selectedMetalTypes.isNotEmpty) {
      request.metalType =
          filterController.selectedMetalTypes
              .where((item) => item.id != null)
              .map((item) => MetalType(id: item.id!))
              .toList();
    } else if (selectedOrnamnetsMetalsId.isNotEmpty) {
      // Fallback to legacy selection if needed
      request.metalType =
          selectedOrnamnetsMetalsId
              .map((item) => MetalType(id: item['id'].toString()))
              .toList();
    }

    // Add purities (as List<String>) - using multi-select list
    if (filterController.selectedPurities.isNotEmpty) {
      request.purities =
          filterController.selectedPurities
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add branch IDs (as List<String>) - using multi-select list
    if (filterController.selectedBranches.isNotEmpty) {
      request.branchIds =
          filterController.selectedBranches
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add dates
    request.dateFrom =
        filterController.dateFrom.value ?? pickedDateRange?.start;
    request.dateTo = filterController.dateTo.value ?? pickedDateRange?.end;

    // Get the base request body
    Map<String, dynamic> requestBody = request.toJson();

    // Add additional filters that aren't part of the request model
    // but the backend might still accept
    if (filterController.selectedOrnaments.isNotEmpty) {
      requestBody["ornament"] =
          filterController.selectedOrnaments
              .where((item) => item.id != null)
              .map((item) => {"id": item.id!})
              .toList();
    }

    if (filterController.selectedVendors.isNotEmpty) {
      requestBody["vendor"] =
          filterController.selectedVendors
              .where((item) => item.id != null)
              .map((item) => {"id": item.id!})
              .toList();
    }

    // Log the request for debugging
    log(
      "Stock and Value Statement filter request body: ${requestBody.toString()}",
    );

    return requestBody;
  }

  // Add applyFilters method similar to ItemStatementReportViewModel
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

    // Call API with updated filters
    getStockAndStatementValueReport();
  }

  Future<void> getOrnamentsMetalTypes() async {
    try {
      ornamentTypeResponse.value = ApiResponse.loading("Loading");
      final response =
          await _stockAndValueReportRepository.getOrnamentsMetalTypes();
      metalTypes =
          response
              .map((item) => DropdownItem(id: item.id, name: item.typeName))
              .toList();
      ornamentTypeResponse.value = ApiResponse.completed(metalTypes);
    } catch (e) {
      ornamentTypeResponse.value = ApiResponse.error(e.toString());
    }
  }

  void selectMetalType(DropdownItem type) {
    if (selectedMetalTypes.contains(type)) {
      selectedMetalTypes.remove(type);
    } else {
      selectedMetalTypes.add(type);
    }
    selectedOrnamnetsMetalsId =
        selectedMetalTypes.map((item) => {"id": item.id}).toList();
  }

  List<String> get headers => [
    "Code",
    "",
    "Opening ",
    "Inward ",
    "Outward ",
    "Closing ",
  ];

  List<String> get subHeader => [
    "",
    "",
    "Qty",
    "Net Weight",
    if (inclusiveGrossWeight) "Inc Gr.Wt",
    if (inclusiveAmount) "Inc Amount",
    "Qty",
    "Net Weight",
    if (inclusiveGrossWeight) "Inc Gr.Wt",
    if (inclusiveAmount) "Inc Amount",
    "Qty",
    "Net Weight",
    if (inclusiveGrossWeight) "Inc Gr.Wt",
    if (inclusiveAmount) "Inc Amount",
    "Qty",
    "Net Weight",
    if (inclusiveGrossWeight) "Inc Gr.Wt",
    if (inclusiveAmount) "Inc Amount",
  ];

  List<double> get columnWidths => [
    0.45, // Code
    0.55, // Item Description
    0.45, // Opening Qty
    0.45, // Opening Net Weight
    if (inclusiveGrossWeight) 0.45,
    if (inclusiveAmount) 0.45,
    0.45, // Inward Qty
    0.45, // Inward Net Weight
    if (inclusiveGrossWeight) 0.45,
    if (inclusiveAmount) 0.45,
    0.45, // Outward Qty
    0.45, // Outward Net Weight
    if (inclusiveGrossWeight) 0.45,
    if (inclusiveAmount) 0.45,
    0.45, // Closing Qty
    0.45, // Closing Net Weight
    if (inclusiveGrossWeight) 0.45,
    if (inclusiveAmount) 0.45,
  ];

  List<double> get columnWidthsHeaders => [
    1.0, // Combined width of Code + Item Description (0.45 + 0.55)
    (0.45 +
        0.45 +
        (inclusiveGrossWeight ? 0.45 : 0) +
        (inclusiveAmount ? 0.45 : 0)), // Opening
    (0.45 +
        0.45 +
        (inclusiveGrossWeight ? 0.45 : 0) +
        (inclusiveAmount ? 0.45 : 0)), // Inward
    (0.45 +
        0.45 +
        (inclusiveGrossWeight ? 0.45 : 0) +
        (inclusiveAmount ? 0.45 : 0)), // Outward
    (0.45 +
        0.45 +
        (inclusiveGrossWeight ? 0.45 : 0) +
        (inclusiveAmount ? 0.45 : 0)), // Closing
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getStockAndStatementValueReport();
    });
  }

  Future<void> downloadReport() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await _stockAndValueReportRepository
          .downloadStockAndValueReport(
            startDate: dateFormat.format(
              filterController.dateFrom.value ?? pickedDateRange!.start,
            ),
            endDate: dateFormat.format(
              filterController.dateTo.value ?? pickedDateRange!.end,
            ),
            requestBody: createRequestBodyFromFilters(),
            limit: 10000, // Increased limit for full export
          );

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'stock_and_value_report',
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

  Future<void> selectDate(BuildContext context) async {
    DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 5,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400.0,
              maxHeight: 500.0,
            ),
            child: child,
          ),
        );
      },
    );

    if (pickedDate != null) {
      pickedDateRange = pickedDate;
      // Also update the filter controller
      filterController.dateFrom.value = pickedDate.start;
      filterController.dateTo.value = pickedDate.end;
      getStockAndStatementValueReport();
      update();
    }
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
}
