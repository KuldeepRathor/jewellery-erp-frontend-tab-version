import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_details_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/stock_and_value_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/file_download_util.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class OutwardReportViewmodel extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final StockAndValueReportRepository _stockAndValueReportRepository =
      StockAndValueReportRepository();
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final taggingDetailsResponse = Rx<ApiResponse<GetTaggingLineItemResponse>>(
    ApiResponse.initial("Initial"),
  );
  // Add BaseFilterController
  final BaseFilterController filterController = Get.put(BaseFilterController());

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  final headers =
      [
        'Sr',
        "Code",
        'Item Description',
        'Pcs',
        'Gross weight',
        'Net weight',
        "Dia-CT",
        "Amount",
        "Final Va",
        "Tagging Va",
        "Final Mc",
        "Tagging Mc",
        '',
      ].obs;

  final columnWidths =
      [0.1, 0.28, 0.5, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.1].obs;

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final outwardReportListingResponse =
      Rx<ApiResponse<GetOutwardReportResponse>>(ApiResponse.initial("INITIAL"));

  final searchQuery = ''.obs;
  final searchQueryDetails = ''.obs; // Separate search for details page
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;
  final isWeightGroupView = false.obs;

  // Date range - Changed to yesterday to today
  DateTimeRange? pickedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 1)),
    end: DateTime.now(),
  );

  // Store the current filters for details page
  // ignore: unused_field
  GetOutwardReportDetailRequest? _currentDetailFilters;

  @override
  void onInit() {
    super.onInit();

    // Set initial date range in filter controller (yesterday to today)
    filterController.dateFrom.value = DateTime.now().subtract(
      const Duration(days: 1),
    );
    filterController.dateTo.value = DateTime.now();
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

    getOutwardReportListing();
  }

  // Apply filters method
  void applyFilters() {
    // Update date range from filter controller
    if (filterController.dateFrom.value != null &&
        filterController.dateTo.value != null) {
      pickedDateRange = DateTimeRange(
        start: filterController.dateFrom.value!,
        end: filterController.dateTo.value!,
      );
    }

    // Call API with the filter request
    getOutwardReportListing();
  }

  // Apply filters for details page
  void applyFiltersForDetails() {
    // Update the detail filters with current filter state
    _currentDetailFilters = createDetailRequestFromFilters();

    // Get the current code from details response
    final code =
        getOutwardDetailsResponse.value.data?.values?.firstOrNull?.code;
    if (code != null) {
      getOutwardReportDetails();
    }
  }

  Future<void> fetchTaggingDetails(String taggingId) async {
    taggingDetailsResponse.value = ApiResponse.loading("Loading");
    try {
      // Call the new API without request body
      final response = await _inventoryRepository.getTaggingLineItem(taggingId);
      taggingDetailsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      taggingDetailsResponse.value = ApiResponse.error(e.toString());
      log("Error fetching tagging details: $e");
    }
  }

  void showItemDetails(GetOutwardReportDetailsResponseValue data) {
    selectedCode.value = data;
    isDetailsVisible.value = true;

    // Fetch tagging details using the item's ID (assuming it's the tagging ID)
    if (data.taggingId != null) {
      fetchTaggingDetails(data.taggingId ?? "");
    }
  }

  // Update hideItemDetails to clear tagging details
  void hideItemDetails() {
    isDetailsVisible.value = false;
    taggingDetailsResponse.value = ApiResponse.initial("Initial");
  }

  // Create request from filters
  GetOutwardReportRequest createRequestFromFilters() {
    return GetOutwardReportRequest(
      type: isWeightGroupView.value ? "Weight Group" : "Stock Head",
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
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
      weightGroup:
          filterController.selectedWeightGroups.isNotEmpty
              ? filterController.selectedWeightGroups
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
      design:
          filterController.selectedDesigns.isNotEmpty
              ? filterController.selectedDesigns
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
      branch:
          filterController.selectedBranches.isNotEmpty
              ? filterController.selectedBranches
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
      sizeGroups:
          filterController.selectedSizes.isNotEmpty
              ? filterController.selectedSizes
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
      status:
          filterController.selectedStatuses.isNotEmpty
              ? filterController.selectedStatuses
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      dateFrom: filterController.dateFrom.value ?? pickedDateRange?.start,
      dateTo: filterController.dateTo.value ?? pickedDateRange?.end,
      taggedBy:
          filterController.selectedTaggedBys.isNotEmpty
              ? filterController.selectedTaggedBys
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      minGrossWeight: filterController.minGrossWeight.value?.toDouble(),
      maxGrossWeight: filterController.maxGrossWeight.value?.toDouble(),
      minNetWeight: filterController.minNetWeight.value?.toDouble(),
      maxNetWeight: filterController.maxNetWeight.value?.toDouble(),
    );
  }

  // Create detail request from filters
  GetOutwardReportDetailRequest createDetailRequestFromFilters() {
    return GetOutwardReportDetailRequest(
      type: isWeightGroupView.value ? "Weight Group" : "Stock Head",
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
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
      weightGroup:
          filterController.selectedWeightGroups.isNotEmpty
              ? filterController.selectedWeightGroups
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
      design:
          filterController.selectedDesigns.isNotEmpty
              ? filterController.selectedDesigns
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
      branch:
          filterController.selectedBranches.isNotEmpty
              ? filterController.selectedBranches
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
      sizeGroups:
          filterController.selectedSizes.isNotEmpty
              ? filterController.selectedSizes
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
      status:
          filterController.selectedStatuses.isNotEmpty
              ? filterController.selectedStatuses
                  .where((item) => item.id != null)
                  .map((item) => item.id as int)
                  .toList()
              : null,
      dateFrom: filterController.dateFrom.value ?? pickedDateRange?.start,
      dateTo: filterController.dateTo.value ?? pickedDateRange?.end,
      taggedBy:
          filterController.selectedTaggedBys.isNotEmpty
              ? filterController.selectedTaggedBys
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      minGrossWeight: filterController.minGrossWeight.value,
      maxGrossWeight: filterController.maxGrossWeight.value,
      minNetWeight: filterController.minNetWeight.value,
      maxNetWeight: filterController.maxNetWeight.value,
    );
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getOutwardReportListing({bool isSearch = false}) async {
    setInitialConditions(isSearch: isSearch);
    outwardReportListingResponse.value = ApiResponse.loading("LOADING");

    try {
      // Create request with all filters
      final request = createRequestFromFilters();

      final response = await _aggregateRepository.getOutwardReport(
        requestBody: request,
      );

      outwardReportListingResponse.value = ApiResponse.completed(response);

      hasMorePages.value = false;
      lastOffsetId = null;
    } catch (e) {
      outwardReportListingResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more called");
      await getOutwardReportListing();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getOutwardReportListing(isSearch: true);
    });
  }

  void setSearchQueryDetails(String query) {
    searchQueryDetails.value = query;
    // Implement search logic for details if needed
  }

  List<String> displayBy = ["Stock Head", "Weight Group"];

  void onDisplayByChanged(String value) {
    isWeightGroupView.value = value == "Weight Group";
    getOutwardReportListing();
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
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400.0,
              maxHeight: 500.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        );
      },
    );

    if (pickedDate != null) {
      pickedDateRange = pickedDate;
      filterController.dateFrom.value = pickedDate.start;
      filterController.dateTo.value = pickedDate.end;
      getOutwardReportListing();
      update();
    }
  }

  final getOutwardDetailsResponse =
      Rx<ApiResponse<GetOutwardReportDetailsResponse>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getOutwardReportDetails({
    TaggingCode? taggingCode,
    String? stockHead,
  }) async {
    try {
      getOutwardDetailsResponse.value = ApiResponse.loading('Loading..');

      // Create the request based on current filters
      GetOutwardReportDetailRequest requestBody =
          createDetailRequestFromFilters();

      // If stockHead is provided directly, use it
      if (stockHead != null) {
        // Clear any existing stock head selections and set the new one
        requestBody.stockHead = [stockHead];
        // Clear weight group selection
        requestBody.weightGroup = null;
      }
      // If taggingCode is provided, update the request based on codeType
      else if (taggingCode != null && taggingCode.codeId != null) {
        if (taggingCode.codeType == "weight_group") {
          // Clear any existing weight group selections and set the new one
          requestBody.weightGroup = [taggingCode.codeId!];
          // Clear stock head selection
          requestBody.stockHead = null;
        } else if (taggingCode.codeType == "stock_head") {
          // Clear any existing stock head selections and set the new one
          requestBody.stockHead = [taggingCode.codeId!];
          // Clear weight group selection
          requestBody.weightGroup = null;
        }
      }

      final items = await _aggregateRepository.getOutwardReportDetails(
        requestBody: requestBody,
      );

      getOutwardDetailsResponse.value = ApiResponse.completed(items);
      showSuccessToast(message: "Fetched successfully");
    } catch (e, stack) {
      log('Error posting payment: $e $stack');
      getOutwardDetailsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed load details: $e");
    }
  }

  final isDetailsVisible = false.obs;
  final selectedCode = Rx<GetOutwardReportDetailsResponseValue?>(null);

  Future<void> downloadReport() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Create request with all filters
      final request = createRequestFromFilters();

      final requestBody = {
        "type":
            request.type ??
            (isWeightGroupView.value ? "Weight Group" : "Stock Head"),
        "metal_type": request.metalType ?? [],
        "stock_head": request.stockHead ?? [],
        "design": request.design ?? [],
        "counter_id": request.counterId ?? [],
      };

      final result = await _stockAndValueReportRepository.downloadOutwardReport(
        startDate: request.dateFrom ?? pickedDateRange!.start,
        endDate: request.dateTo ?? pickedDateRange!.end,
        requestBody: requestBody,
        limit: 10000,
      );

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'outward_report',
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

  Future<void> downloadReportDetails() async {
    try {
      // Get the code from the current details response
      final code =
          getOutwardDetailsResponse.value.data?.values?.firstOrNull?.code;
      if (code == null) {
        showErrorToast(message: "No item details available for download");
        return;
      }

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await _stockAndValueReportRepository
          .downloadOutwardReportDetails(code: code);

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'outward_report_details',
        fileExtension: 'csv',
      );

      if (success) {
        showSuccessToast(message: "Report details downloaded successfully");
      } else {
        showErrorToast(message: "Download cancelled or failed");
      }
    } catch (e) {
      Get.back(); // Close loading dialog if error occurs
      showErrorToast(
        message: "Failed to download report details: ${e.toString()}",
      );
    }
  }

  // Clear all filters
  void clearAllFilters() {
    // Reset to default date range (yesterday to today)
    pickedDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 1)),
      end: DateTime.now(),
    );
    filterController.dateFrom.value = DateTime.now().subtract(
      const Duration(days: 1),
    );
    filterController.dateTo.value = DateTime.now();
    getOutwardReportListing();
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
    if (filterController.minGrossWeight.value != null) count++;
    if (filterController.maxGrossWeight.value != null) count++;
    if (filterController.minNetWeight.value != null) count++;
    if (filterController.maxNetWeight.value != null) count++;
    return count > 0 ? ' ($count)' : '';
  }
}
