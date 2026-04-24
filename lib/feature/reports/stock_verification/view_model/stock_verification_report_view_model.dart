import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/save_stock_verification_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/stock_verification_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/stock_verification_report_response.dart'
    hide EmployeeDetails;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view_model/stock_verification_upload_image_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/widget/detail_view_widgets/tagged_item_details_bottom_sheet_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/stock_and_value_statement_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class StockVerificationReportViewModel extends GetxController {
  final invoiceCreatedController = TextEditingController();
  final StockAndValueReportRepository stockAndValueReportRepository =
      StockAndValueReportRepository();
  final InventoryRepository inventoryRepository = InventoryRepository();
  final StockVerificationImageUploadController imageUploadController =
      Get.put<StockVerificationImageUploadController>(
        StockVerificationImageUploadController(),
      );
  final taggingDetailsResponse = Rx<ApiResponse<GetTaggingLineItemResponse>>(
    ApiResponse.initial("Initial"),
  );

  final BaseFilterController filterController = Get.put(BaseFilterController());

  final List<String> filterStatusOptions = ['All', 'Pending', 'Scanned'].obs;
  final selectedFilterStatus = 'All'.obs;

  void setFilterStatus(String status) {
    selectedFilterStatus.value = status;

    final currentData = stockVerificationList.value.data;
    if (currentData != null) {
      stockVerificationList.value = ApiResponse.completed(currentData);
    }
  }

  final headers =
      [
        "Status",
        "Tag No.",
        "Barcode No.",
        "Item Group",
        "Pcs",
        "G.Wt (gm)",
        "N.Wt (gm)",
        "Tagged By",
        "Tagged Date",
        "",
      ].obs;

  final columnWidths = [
    0.2, // Status
    0.2, // Tag No
    0.2, // Barcode
    0.8, // Item Group
    0.25, // Pcs
    0.35, // G.Wt
    0.35, // N.Wt
    0.35, // Tagged By
    0.25, // Tagged Date
    0.1, // Actions
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final stockVerificationList =
      Rx<ApiResponse<List<GetStockVerificationReportResponse>>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  final selectedItemIndex = (-1).obs;
  final isSaving = false.obs;

  List<String> popUpValues = ["View Item"];
  final barcodeTextController = TextEditingController();
  final barcodeFocusNode = FocusNode();
  final _barcodeScanDebouncer = CustomDebouncer(milliseconds: 800);

  final barcodeInput = ''.obs;
  @override
  void onInit() {
    super.onInit();
    filterController.resetAllFilters();

    // Initialize filter controller with required filters
    filterController.fetchAllDropdownData(
      filterTypes: [
        'metalType',
        'ornament',
        'weightGroup',
        'stockHead',
        'counter',
        'purity',
        'design',
        'vendor',
        'taggedBy',
        'grossWeight',
        'netWeight',
      ],
    );
  }

  @override
  void onClose() {
    barcodeTextController.dispose();
    super.onClose();
  }

  void onBarcodeInputChanged(String value) {
    barcodeInput.value = value;

    if (value.isNotEmpty) {
      _barcodeScanDebouncer.run(() {
        scanBarcode(value);
      });
    }
  }

  void scanBarcode(String barcode) {
    if (barcode.isEmpty) return;

    final data = stockVerificationList.value.data;
    if (data == null || data.isEmpty) return;

    final index = data.indexWhere((item) => item.tagBarcode == barcode);

    if (index != -1) {
      if (data[index].isScanned != true) {
        final updatedItem = data[index];
        updatedItem.isScanned = true;

        final updatedList = List<GetStockVerificationReportResponse>.from(data);
        updatedList[index] = updatedItem;

        stockVerificationList.value = ApiResponse.completed(updatedList);

        showItemDetails(index: index);

        barcodeTextController.clear();
        barcodeInput.value = '';
        barcodeFocusNode.requestFocus();
      } else {
        showErrorToast(message: "This item has already been scanned");
      }
    } else {
      showErrorToast(message: "No item found with this barcode");
    }
  }
  // Add these methods to StockVerificationReportViewModel

  // Get count of all items
  int getTotalItemsCount() {
    final data = stockVerificationList.value.data;
    return data?.length ?? 0;
  }

  // Get count of scanned items (we already have this method, just referencing it)
  int getScannedItemsCount() {
    final data = stockVerificationList.value.data;
    if (data == null) return 0;
    return data.where((item) => item.isScanned == true).length;
  }

  // Get count of pending items
  int getPendingItemsCount() {
    final data = stockVerificationList.value.data;
    if (data == null) return 0;
    return data.where((item) => item.isScanned != true).length;
  }

  // Helper method to get count text for dropdown items
  String getStatusCountText(String status) {
    switch (status) {
      case 'All':
        return 'All (${getTotalItemsCount()})';
      case 'Pending':
        return 'Pending (${getPendingItemsCount()})';
      case 'Scanned':
        return 'Scanned (${getScannedItemsCount()})';
      default:
        return status;
    }
  }

  void resetScannedItems() {
    final data = stockVerificationList.value.data;
    if (data == null || data.isEmpty) return;

    final updatedList =
        data.map((item) {
          item.isScanned = false;
          return item;
        }).toList();

    stockVerificationList.value = ApiResponse.completed(updatedList);
    barcodeTextController.clear();
    showSuccessToast(message: "All scanned items have been reset");
  }

  Future<void> saveStockVerification() async {
    try {
      isSaving.value = true;

      final data = stockVerificationList.value.data;
      if (data == null || data.isEmpty) {
        showErrorToast(message: "No items to save");
        return;
      }

      // Check if any items are scanned
      final hasScannedItems = data.any((item) => item.isScanned == true);

      if (!hasScannedItems) {
        showErrorToast(message: "No items have been scanned");
        return;
      }

      // Prepare request data with ALL items (both scanned and unscanned)
      final values =
          data
              .map(
                (item) => SaveStockVerificationValue(
                  taggingId: item.id,
                  isScanned: item.isScanned ?? false,
                ),
              )
              .toList();

      final request = SaveStockVerificationRequest(values: values);

      log("Saving stock verification with request: ${request.toRawJson()}");

      // Make API call
      final response = await inventoryRepository.saveStockVerification(request);

      // Handle success
      log("Stock verification saved successfully: $response");
      showSuccessToast(message: "Stock verification saved successfully");

      // Refresh the list to show updated status from server
      await getStockVerificationList(resetList: true);
    } catch (e, s) {
      log("Error saving stock verification: $e, $s");
      showErrorToast(message: "Failed to save: ${e.toString()}");
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> getStockVerificationList({
    bool resetList = false,
    bool isSearch = false,
    StockVerificationReportRequest? request,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      stockVerificationList.value = ApiResponse.loading("LOADING");
    }

    try {
      final requestToUse =
          request ??
          StockVerificationReportRequest(
            stockType: StockType(live: true, order: true, approval: true),
          );

      final responseList = await stockAndValueReportRepository
          .getStockVerificationList(requestBody: requestToUse.toJson());
      stockVerificationList.value = ApiResponse.completed(responseList);
      if (resetList) {
        selectedItemIndex.value = -1;
      }
    } catch (e, s) {
      log("Error $e : $s");
      final handledResponse = handleDTOResponseErrors(e);
      log("Handled error $handledResponse");
      stockVerificationList.value = ApiResponse.error(handledResponse.message);
    }
  }

  Future<void> fetchTaggingDetails(String taggingId) async {
    taggingDetailsResponse.value = ApiResponse.loading("Loading");
    try {
      final response = await inventoryRepository.getTaggingLineItem(taggingId);
      taggingDetailsResponse.value = ApiResponse.completed(response);

      // Populate images after fetching details
      imageUploadController.populateWithDetailedData(response);
    } catch (e) {
      taggingDetailsResponse.value = ApiResponse.error(e.toString());
      log("Error fetching tagging details: $e");
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getStockVerificationList(isSearch: true, resetList: true);
    });
  }

  void setInitialConditions({required bool isSearch}) {
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  void showPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: getDeviceWidth(context),
        minWidth: getDeviceWidth(context),
      ),
      builder: (BuildContext context) {
        return const TaggedItemDetailsBottomSheetWidget();
      },
    );
  }

  final RxBool isItemDetailsVisible = false.obs;

  void showItemDetails({required int index}) {
    selectedItemIndex.value = index;

    final stockItems = stockVerificationList.value.data;
    if (stockItems != null &&
        stockItems.isNotEmpty &&
        index >= 0 &&
        index < stockItems.length) {
      final item = stockItems[index];

      // Fetch additional details for this item
      if (item.id != null) {
        fetchTaggingDetails(item.id!);
      }
    }

    isItemDetailsVisible.value = true;
  }

  void hideItemDetails() {
    isItemDetailsVisible.value = false;
  }

  void toggleItemDetails({required int index}) {
    showItemDetails(index: index);
  }

  String getFormattedDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}-${date.month}-${date.year}';
  }

  String getEmployeeDisplayName(EmployeeDetails? details) {
    if (details == null) {
      return '-';
    }

    final firstName = details.firstName ?? '';
    final lastName = details.lastName ?? '';

    if (firstName.isEmpty && lastName.isEmpty) {
      return '-';
    } else if (firstName.isEmpty) {
      return lastName;
    } else if (lastName.isEmpty) {
      return firstName;
    } else {
      return '$firstName $lastName';
    }
  }

  List<GetStockVerificationReportResponse> getFilteredList() {
    final list = stockVerificationList.value.data ?? [];

    // Apply search and status filters
    return list.where((item) {
      // First, check if it matches the status filter
      if (selectedFilterStatus.value != 'All') {
        final isScanned = item.isScanned ?? false;
        if (selectedFilterStatus.value == 'Scanned' && !isScanned) return false;
        if (selectedFilterStatus.value == 'Pending' && isScanned) return false;
      }

      // Then check if it matches the search query
      if (searchQuery.value.isEmpty) return true;

      final query = searchQuery.value.toLowerCase();
      return (item.tagNumber?.toString().toLowerCase().contains(query) ??
              false) ||
          (item.tagBarcode?.toLowerCase().contains(query) ?? false) ||
          (item.code?.toLowerCase().contains(query) ?? false) ||
          (item.design?.name?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void applyFilters() {
    // log values before creating the request for debugging
    log(
      "GrossWeight min: ${filterController.minGrossWeight.value}, max: ${filterController.maxGrossWeight.value}",
    );
    log(
      "NetWeight min: ${filterController.minNetWeight.value}, max: ${filterController.maxNetWeight.value}",
    );
    log(
      "DateRange from: ${filterController.dateFrom.value}, to: ${filterController.dateTo.value}",
    );

    // Create a StockVerificationReportRequest with filter values
    final request = StockVerificationReportRequest(
      metalType:
          filterController.selectedMetalType.value?.id != null
              ? [filterController.selectedMetalType.value!.id!]
              : null,
      ornamentIds:
          filterController.selectedOrnament.value?.id != null
              ? [filterController.selectedOrnament.value!.id!]
              : null,
      stockHeadIds:
          filterController.selectedStockHead.value?.id != null
              ? [filterController.selectedStockHead.value!.id!]
              : null,
      weightGroupIds:
          filterController.selectedWeightGroup.value?.id != null
              ? [filterController.selectedWeightGroup.value!.id!]
              : null,
      designIds:
          filterController.selectedDesign.value?.id != null
              ? [filterController.selectedDesign.value!.id!]
              : null,
      purity:
          filterController.selectedPurity.value?.id != null
              ? [filterController.selectedPurity.value!.id!]
              : null,
      counterIds:
          filterController.selectedCounter.value?.id != null
              ? [filterController.selectedCounter.value!.id!]
              : null,
      vendorIds:
          filterController.selectedVendor.value?.id != null
              ? [filterController.selectedVendor.value!.id!]
              : null,
      taggedByIds:
          filterController.selectedTaggedBy.value?.id != null
              ? [filterController.selectedTaggedBy.value!.id!]
              : null,
      // Explicitly pass null for weight ranges when they're null in the controller
      minGrossWeight: filterController.minGrossWeight.value,
      maxGrossWeight: filterController.maxGrossWeight.value,
      minNetWeight: filterController.minNetWeight.value,
      maxNetWeight: filterController.maxNetWeight.value,
      dateFrom: filterController.dateFrom.value,
      dateTo: filterController.dateTo.value,

      minRecordNumber: filterController.minRecordNumber.value,
      maxRecordNumber: filterController.maxRecordNumber.value,
      stockType: StockType(live: true, order: true, approval: true),
    );

    // Log the request for debugging
    log("Filter request: ${request.toRawJson()}");

    // Call API with the filter request
    getStockVerificationList(resetList: true, request: request);
  }
}
