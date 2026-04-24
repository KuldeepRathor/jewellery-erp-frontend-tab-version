// ignore_for_file: unused_field

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/get_tagging_item_report_response.dart'
    as tag_report;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/tagging_item_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/weight_group_detail_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/weight_group_detail_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view/stock_head_details_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view/weight_group_detail_page.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/stock_and_value_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/file_download_util.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class TaggedItemReportViewModel extends GetxController {
  final isWeightGroupView = false.obs;

  RxString searchQuery = ''.obs;
  final StockAndValueReportRepository _stockAndValueReportRepository =
      StockAndValueReportRepository();

  List<String> popUpValues = ["Edit"];
  final taggingItemReportResponse =
      Rx<ApiResponse<tag_report.GetTaggingItemReportResponse>>(
        ApiResponse.initial("INITIAL"),
      );

  final weightGroupDetailsResponse = Rx<ApiResponse<WeightGroupDetailResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  WeightGroupDetailRequest? _currentDetailFilters;
  final isDetailsFilterApplied = false.obs;

  final BaseFilterController filterController = Get.put(BaseFilterController());

  final Set<String> _expandedRows = {};

  final isLoadingWeightGroupDetails = false.obs;

  String? _currentWeightGroupId;
  String? _currentStockHeadId;
  tag_report.GetTaggingItemReportValue? _currentStockHead;
  tag_report.WeightGroup? _currentWeightGroup;

  @override
  void onClose() {
    clearDetailContext();
    super.onClose();
  }

  bool isExpanded(String stockHeadId) => _expandedRows.contains(stockHeadId);

  void toggleExpanded(String stockHeadId) {
    if (_expandedRows.contains(stockHeadId)) {
      _expandedRows.remove(stockHeadId);
    } else {
      _expandedRows.add(stockHeadId);
    }
    update();
  }

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
    filterController.resetAllFilters();

    // Initialize filter controller first
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
        'taggedBy',
      ],
    );

    // Set the initial date range in filter controller
    filterController.setDateRange(pickedDateRange!.start, pickedDateRange!.end);

    // Then fetch data
    fetchAllInitialData();
  }

  void fetchAllInitialData() {
    getTaggedItemReport();
    update();
  }

  Future<void> getTaggedItemReport() async {
    isLoading.value = true;
    taggingItemReportResponse.value = ApiResponse.loading("LOADING");

    try {
      // Create request body with all filters
      final requestBody = createRequestBodyFromFilters();

      final response = await _stockAndValueReportRepository.getTaggedItemReport(
        query: searchQuery.value,
        // startDate: dateFormat.format(pickedDateRange!.start),
        // endDate: dateFormat.format(pickedDateRange!.end),
        requestBody: requestBody,
      );
      taggingItemReportResponse.value = ApiResponse.completed(response);
    } catch (e) {
      taggingItemReportResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  List<String> get headers => [
    "Stock Head",
    "Weight Group",
    "Pieces",
    "Gross Weight",
    "Net Weight",
    "Stone Cts",
    "VA",
    "Stone Amount",
  ];

  List<double> get columnWidths => [1.0, 1.0, 0.5, 0.8, 0.8, 0.8, 0.8, 0.8];
  final _debouncer = CustomDebouncer(milliseconds: 500);
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getTaggedItemReport();
    });
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
      // Update the filter controller with the new date range
      filterController.setDateRange(pickedDate.start, pickedDate.end);
      getTaggedItemReport();
      update();
    }
  }

  WeightGroupDetailRequest createDetailRequestFromFilters() {
    DateTime? dateFromValue;
    DateTime? dateToValue;

    if (filterController.dateFrom.value != null) {
      // Set dateFrom to start of the day (00:00:00)
      final date = filterController.dateFrom.value!;
      dateFromValue = DateTime(date.year, date.month, date.day, 0, 0, 0);
    }

    if (filterController.dateTo.value != null) {
      // Keep dateTo as-is (current time)
      dateToValue = filterController.dateTo.value!;
    }
    return WeightGroupDetailRequest(
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      stockHead:
          filterController.selectedStockHeads.isNotEmpty
              ? filterController.selectedStockHeads
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      weightGroup:
          filterController.selectedWeightGroups.isNotEmpty
              ? filterController.selectedWeightGroups
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      design:
          filterController.selectedDesigns.isNotEmpty
              ? filterController.selectedDesigns
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      counterId:
          filterController.selectedCounters.isNotEmpty
              ? filterController.selectedCounters
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      purity:
          filterController.selectedPurities.isNotEmpty
              ? filterController.selectedPurities
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      partyId:
          filterController.selectedVendors.isNotEmpty
              ? filterController.selectedVendors
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      ornamentType:
          filterController.selectedOrnaments.isNotEmpty
              ? filterController.selectedOrnaments
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      branch:
          filterController.selectedBranches.isNotEmpty
              ? filterController.selectedBranches
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      sizeGroups:
          filterController.selectedSizes.isNotEmpty
              ? filterController.selectedSizes
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      status:
          filterController.selectedStatuses.isNotEmpty
              ? filterController.selectedStatuses
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      taggedBy:
          filterController.selectedTaggedBys.isNotEmpty
              ? filterController.selectedTaggedBys
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      dateFrom: dateFromValue,
      dateTo: dateToValue,
      minGrossWeight: filterController.minGrossWeight.value?.toInt(),
      maxGrossWeight: filterController.maxGrossWeight.value?.toInt(),
      minNetWeight: filterController.minNetWeight.value?.toInt(),
      maxNetWeight: filterController.maxNetWeight.value?.toInt(),
      // minRecordNumber: filterController.minRecordNumber.value?.toInt(),
      // maxRecordNumber: filterController.maxRecordNumber.value?.toInt(),
      // minLotNumber: filterController.minLotNumber.value?.toInt(),
      // maxLotNumber: filterController.maxLotNumber.value?.toInt(),
    );
  }

  void applyFiltersForDetails() {
    _currentDetailFilters = createDetailRequestFromFilters();
    isDetailsFilterApplied.value = true;

    // Re-fetch current details with filters based on what's currently displayed
    if (_currentWeightGroupId != null) {
      _fetchWeightGroupDetailsWithFilters([_currentWeightGroupId!]);
    } else if (_currentStockHeadId != null) {
      _fetchStockHeadDetailsWithFilters([_currentStockHeadId!]);
    }
  }

  void applyFilters() {
    // Update date range from filter controller
    if (filterController.dateFrom.value != null &&
        filterController.dateTo.value != null) {
      pickedDateRange = DateTimeRange(
        start: filterController.dateFrom.value!,
        end: filterController.dateTo.value!,
      );
    }

    // Refresh the main report with new filters
    getTaggedItemReport();
  }

  void viewWeightGroupDetails({
    required tag_report.GetTaggingItemReportValue stockHead,
    required tag_report.WeightGroup group,
  }) async {
    isLoadingWeightGroupDetails.value = true;
    _currentDetailFilters = createDetailRequestFromFilters();

    // Store current context
    _currentWeightGroupId = group.weightGroupId;
    _currentStockHeadId = null;
    _currentStockHead = stockHead;
    _currentWeightGroup = group;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await _stockAndValueReportRepository
          .getWeightGroupDetailsWithFilters(
            weightGroupIds: [group.weightGroupId!],
            requestBody: _currentDetailFilters,
          );

      Get.back();
      weightGroupDetailsResponse.value = ApiResponse.completed(response);

      if (response.values != null && response.values!.isNotEmpty) {
        Get.to(
          () => WeightGroupDetailsPage(
            stockHead: stockHead,
            weightGroup: group,
            detailsData: response,
          ),
        );

        showSuccessToast(message: "Fetched details successfully");
      } else {
        showErrorToast(message: "No details found for this weight group");
      }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      weightGroupDetailsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(
        message: "Failed to load weight group details: ${e.toString()}",
      );
    } finally {
      isLoadingWeightGroupDetails.value = false;
      update();
    }
  }

  // Update viewStockHeadDetails similarly
  void viewStockHeadDetails({
    required tag_report.GetTaggingItemReportValue stockHead,
  }) async {
    isLoadingWeightGroupDetails.value = true;
    _currentDetailFilters = createDetailRequestFromFilters();

    // Store current context
    _currentStockHeadId = stockHead.stockHeadId;
    _currentWeightGroupId = null;
    _currentStockHead = stockHead;
    _currentWeightGroup = null;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await _stockAndValueReportRepository
          .getStockHeadDetailsWithFilters(
            stockHeadIds: [stockHead.stockHeadId!],
            requestBody: _currentDetailFilters,
          );

      Get.back();
      weightGroupDetailsResponse.value = ApiResponse.completed(response);

      if (response.values != null && response.values!.isNotEmpty) {
        Get.to(
          () =>
              StockHeadDetailsPage(stockHead: stockHead, detailsData: response),
        );

        showSuccessToast(message: "Fetched stock head details successfully");
      } else {
        showErrorToast(message: "No details found for this stock head");
      }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      weightGroupDetailsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(
        message: "Failed to load stock head details: ${e.toString()}",
      );
    } finally {
      isLoadingWeightGroupDetails.value = false;
      update();
    }
  }

  void _fetchWeightGroupDetailsWithFilters(List<String> weightGroupIds) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await _stockAndValueReportRepository
          .getWeightGroupDetailsWithFilters(
            weightGroupIds: weightGroupIds,
            requestBody: _currentDetailFilters,
          );

      Get.back();
      weightGroupDetailsResponse.value = ApiResponse.completed(response);
      update();

      showSuccessToast(message: "Filters applied successfully");
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      showErrorToast(message: "Failed to apply filters: ${e.toString()}");
    }
  }

  void _fetchStockHeadDetailsWithFilters(List<String> stockHeadIds) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await _stockAndValueReportRepository
          .getStockHeadDetailsWithFilters(
            stockHeadIds: stockHeadIds,
            requestBody: _currentDetailFilters,
          );

      Get.back();
      weightGroupDetailsResponse.value = ApiResponse.completed(response);
      update();

      showSuccessToast(message: "Filters applied successfully");
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      showErrorToast(message: "Failed to apply filters: ${e.toString()}");
    }
  }

  // Clear context when navigating away from details
  void clearDetailContext() {
    _currentWeightGroupId = null;
    _currentStockHeadId = null;
    _currentStockHead = null;
    _currentWeightGroup = null;
    _currentDetailFilters = null;
    isDetailsFilterApplied.value = false;
  }

  Map<String, dynamic> createRequestBodyFromFilters() {
    Map<String, dynamic> requestBody = {};

    // Add metal types filter - now handling multiple selections
    if (filterController.selectedMetalTypes.isNotEmpty) {
      requestBody["metal_type"] =
          filterController.selectedMetalTypes
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add stock heads filter - now handling multiple selections
    if (filterController.selectedStockHeads.isNotEmpty) {
      requestBody["stock_head"] =
          filterController.selectedStockHeads
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add weight groups filter - now handling multiple selections
    if (filterController.selectedWeightGroups.isNotEmpty) {
      requestBody["weight_group"] =
          filterController.selectedWeightGroups
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add designs filter - now handling multiple selections
    if (filterController.selectedDesigns.isNotEmpty) {
      requestBody["design"] =
          filterController.selectedDesigns
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add counters filter - now handling multiple selections
    if (filterController.selectedCounters.isNotEmpty) {
      requestBody["counter_id"] =
          filterController.selectedCounters
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add purities filter - now handling multiple selections
    if (filterController.selectedPurities.isNotEmpty) {
      requestBody["purity"] =
          filterController.selectedPurities
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add vendors/party filter - now handling multiple selections
    if (filterController.selectedVendors.isNotEmpty) {
      requestBody["party_id"] =
          filterController.selectedVendors
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }

    // Add ornament types filter - now handling multiple selections
    if (filterController.selectedOrnaments.isNotEmpty) {
      requestBody["ornament_type"] =
          filterController.selectedOrnaments
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    }
    // Add date range filter
    if (filterController.dateFrom.value != null) {
      requestBody["date_from"] = dateFormat.format(
        filterController.dateFrom.value!,
      );
    }

    if (filterController.dateTo.value != null) {
      requestBody["date_to"] = dateFormat.format(
        filterController.dateTo.value!,
      );
    }
    // Add any existing selected ornaments/metals from the old implementation
    // Only add if the list is not empty and contains valid (non-null) values
    if (selectedOrnamnetsMetalsId.isNotEmpty) {
      // Filter out any null values from the existing implementation
      final validMetalTypes =
          selectedOrnamnetsMetalsId
              .where((item) => item['id'] != null)
              .map((item) => item['id'].toString())
              .toList();

      if (validMetalTypes.isNotEmpty) {
        // Only override if we don't already have metal_type from the new implementation
        if (!requestBody.containsKey("metal_type")) {
          requestBody["metal_type"] = validMetalTypes;
        }
      }
    }

    log("Created request body: $requestBody");
    return requestBody;
  }

  TaggingItemReportRequest createRequestFromFilters() {
    return TaggingItemReportRequest(
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      stockHead:
          filterController.selectedStockHeads.isNotEmpty
              ? filterController.selectedStockHeads
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      weightGroup:
          filterController.selectedWeightGroups.isNotEmpty
              ? filterController.selectedWeightGroups
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      design:
          filterController.selectedDesigns.isNotEmpty
              ? filterController.selectedDesigns
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      counterId:
          filterController.selectedCounters.isNotEmpty
              ? filterController.selectedCounters
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      purity:
          filterController.selectedPurities.isNotEmpty
              ? filterController.selectedPurities
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      partyId:
          filterController.selectedVendors.isNotEmpty
              ? filterController.selectedVendors
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      ornamentType:
          filterController.selectedOrnaments.isNotEmpty
              ? filterController.selectedOrnaments
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
    );
  }

  Future<void> downloadTaggedItemReport() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result =
          await _stockAndValueReportRepository.downloadTaggedItemReport();

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'tagged_item_report',
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

  Future<void> downloadDetailTaggedItemReport({
    List<String>? weightGroupIds,
  }) async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // If no weight group IDs provided, try to get them from current data
      List<String> idsToUse = weightGroupIds ?? [];

      if (idsToUse.isEmpty) {
        // Try to get weight group IDs from current response data
        final currentData = taggingItemReportResponse.value.data;
        if (currentData?.values != null) {
          for (var stockHead in currentData!.values!) {
            if (stockHead.weightGroups != null) {
              for (var weightGroup in stockHead.weightGroups!) {
                if (weightGroup.weightGroupId != null) {
                  idsToUse.add(weightGroup.weightGroupId!);
                }
              }
            }
          }
        }
      }

      if (idsToUse.isEmpty) {
        Get.back(); // Close loading dialog
        showErrorToast(message: "No weight groups found to download");
        return;
      }

      final result = await _stockAndValueReportRepository
          .downloadDetailTaggedItemReport(weightGroupIds: idsToUse);

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'detailed_tagged_item_report',
        fileExtension: 'csv',
      );

      if (success) {
        showSuccessToast(message: "Detailed report downloaded successfully");
      } else {
        showErrorToast(message: "Download cancelled or failed");
      }
    } catch (e) {
      Get.back(); // Close loading dialog if error occurs
      showErrorToast(
        message: "Failed to download detailed report: ${e.toString()}",
      );
    }
  }
}
