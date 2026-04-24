import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_gender_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/widget/detail_view_widgets/tagged_item_details_bottom_sheet_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_limited_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/enhance_media_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/file_download_util.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class ItemListViewModel extends GetxController {
  final invoiceCreatedController = TextEditingController();

  final InventoryRepository inventoryRepository = InventoryRepository();

  final BaseFilterController filterController = Get.put(BaseFilterController());

  GetTaggedItemsReportRequest? _currentFilterRequest;

  final headers =
      [
        "Sn",
        "Code",
        "Tag No.",
        "Barcode No.",
        "Purity",
        "Item",
        "Pcs",
        "N.Wt (gm)",
        "G.Wt (gm)",
        // "Counter",
        "Stone Value",
        "Metal color",
        "Gender",
        "Collection",
        "Images",
        "List on Webstore",
        "",
      ].obs;
  final columnWidths = [
    0.1,
    0.2,
    0.2,
    0.2,
    0.2,
    0.8,
    0.25,
    0.35,
    0.35,
    // 0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.25,
    0.25,
    0.1,
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);
  final getTaggedItemListingResponse =
      Rx<ApiResponse<GetTaggedItemsReportLimitedResponse>>(
        ApiResponse.initial("Loading..."),
      );
  final taggedItemDetailsResponse = Rx<ApiResponse<GetTaggingLineItemResponse>>(
    ApiResponse.initial("Initial"),
  );

  final isLoadingDetails = false.obs;

  final RxMap<String, bool> webstoreListingStatus = <String, bool>{}.obs;

  final RxMap<String, bool> isUpdatingWebstoreStatus = <String, bool>{}.obs;

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 100;
  String? lastOffsetId;

  final selectedItemIndex = (-1).obs;

  final RxMap<String, String> itemGenders = <String, String>{}.obs;

  String? getItemGender(String itemId) {
    return itemGenders[itemId];
  }

  void setItemGender(String itemId, String gender) {
    itemGenders[itemId] = gender;
  }

  @override
  void onInit() {
    super.onInit();
    filterController.resetAllFilters();

    // Initialize filter controller with required filter types
    filterController
        .fetchAllDropdownData(
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
        )
        .then((_) {
          // After all dropdowns are loaded, set default status to "1" (Available)
          _setDefaultStatusFilter();

          // Apply filters with the default status
          applyFilters();
        });
  }

  void _setDefaultStatusFilter() {
    // Find the status item with id "1" from the loaded status dropdown
    final statusItems = filterController.statusResponse.value.data ?? [];
    final activeStatus = statusItems.firstWhereOrNull((item) => item.id == "1");

    if (activeStatus != null) {
      // Add the active status to selected statuses
      filterController.selectedStatuses
          .clear(); // Clear any existing selections
      filterController.selectedStatuses.add(activeStatus);

      // Also update the single value for backward compatibility
      filterController.selectedStatus.value = activeStatus;
    }
  }

  void applyFilters() {
    // Create request from filters
    final requestBody = createRequestFromFilters();

    _currentFilterRequest = requestBody;

    // Call API with the filter request
    getTaggedItemsReportDetails(
      isSearch: false,
      resetList: true,
      requestBody: requestBody,
    );
  }

  GetTaggedItemsReportRequest createRequestFromFilters() {
    List<String>? statusList;
    if (filterController.selectedStatuses.isNotEmpty) {
      statusList =
          filterController.selectedStatuses
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
    } else {
      // Default to status "1" (Available) if no status is selected
      statusList = ["1"];
    }
    return GetTaggedItemsReportRequest(
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
      status: statusList,

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

  Future<void> toggleWebstoreListing(String itemId, bool value) async {
    // Update local state immediately for better UX
    webstoreListingStatus[itemId] = value;

    // Set loading state
    isUpdatingWebstoreStatus[itemId] = true;

    try {
      // Call the API
      await inventoryRepository.updateTaggedItemWebstoreStatus(itemId, value);

      // Update the item in the list if successful
      final items = getTaggedItemListingResponse.value.data?.values ?? [];
      final itemIndex = items.indexWhere((item) => item.id == itemId);

      if (itemIndex != -1) {
        items[itemIndex].isWebstore = value;
        // Trigger UI update
        getTaggedItemListingResponse.refresh();
      }

      // Show success message (optional)
      showSuccessToast(
        message:
            value
                ? "Item listed on webstore successfully"
                : "Item removed from webstore",
      );
    } catch (e) {
      // Revert the local state on error
      webstoreListingStatus[itemId] = !value;

      // Show error message
      showErrorToast(
        message: "Failed to update webstore status. Please try again.",
      );

      log('Error updating webstore status: $e');
    } finally {
      // Clear loading state
      isUpdatingWebstoreStatus[itemId] = false;
    }
  }

  bool getWebstoreListingStatus(String itemId) {
    // First check if we have a tracked status (user has toggled)
    if (webstoreListingStatus.containsKey(itemId)) {
      return webstoreListingStatus[itemId]!;
    }

    final items = getTaggedItemListingResponse.value.data?.values ?? [];
    final item = items.firstWhereOrNull((item) => item.id == itemId);

    return item?.isWebstore ?? false;
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      // String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            // if (header != "Sn")
            //   const SizedBox(
            //     width: 4,
            //   ),
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return TableRow(children: cells);
  }

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(
      getTaggedItemListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index, context),
    );
  }

  List<String> popUpValues = ["View Item", "Edit"];
  TableRow buildTableRow(int index, BuildContext context) {
    List<Widget> cells = [];
    final ornamentDetail = getTaggedItemListingResponse.value.data?.values
        ?.elementAt(index);

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = (index + 1).toString();
          break;
        case 1:
          cellContent = ornamentDetail?.code ?? "-";
          break;
        case 2:
          cellContent = ornamentDetail?.tagNumber?.toString() ?? "-";
          break;
        case 3:
          cellContent = ornamentDetail?.tagBarcode ?? "-";
          break;
        case 4:
          cellContent = ornamentDetail?.purity ?? "-";
          break;
        case 5:
          cellContent = ornamentDetail?.itemDescription ?? "-";
          break;
        case 6:
          cellContent = ornamentDetail?.pieces?.toString() ?? "-";
          break;
        case 7:
          cellContent = ornamentDetail?.netWeight ?? "-";
          break;
        case 8:
          cellContent = ornamentDetail?.grossWeight ?? "-";
          break;
        case 9:
          cellContent = ornamentDetail?.counterName ?? "-";
          break;
        case 10:
          cellContent = ornamentDetail?.totalLineStone ?? "-";
          break;

        default:
          cellContent = "-";
          break;
      }
      log("index $i");

      if (i != headers.length - 1 && i != 10) {
        cells.add(
          Column(
            children: [
              Row(
                children: [
                  if (i != 0) const SizedBox(width: 4),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: cellContent,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              CustomDashedLineWidget(width: Get.width),
            ],
          ),
        );
      } else {
        if (i == 10) {
          // Changed from 9 to 10 for images column
          cells.add(
            Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      if (i != 0) const SizedBox(width: 4),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: InkWell(
                            onTap: () {
                              toggleItemDetails(index: index);
                            },
                            child:
                                ornamentDetail?.imagesCount == null ||
                                        ornamentDetail!.imagesCount == 0
                                    ? const Icon(
                                      Icons.file_upload_outlined,
                                      color: secondaryColor,
                                    )
                                    : CustomText(
                                      text:
                                          "${ornamentDetail.imagesCount} Image",
                                      fontSize: 16,
                                      color: secondaryColor,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomDashedLineWidget(width: Get.width),
              ],
            ),
          );
        } else {
          cells.add(
            Column(
              children: [
                const SizedBox(height: 8),
                Theme(
                  data: ThemeData(
                    focusColor: greyTextColor,
                    tooltipTheme: const TooltipThemeData(
                      decoration: BoxDecoration(color: Colors.transparent),
                    ),
                  ),
                  child: CustomPopupMenuButtonWidget<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder:
                        (BuildContext context) => <PopupMenuEntry<String>>[
                          ...popUpValues.map((element) {
                            return PopupMenuItem<String>(
                              value: element,
                              height: 0,
                              child: SizedBox(
                                width: 88,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      element,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (element != "Edit")
                                      CustomDashedLineWidget(width: Get.width),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                    onSelected: (String value) {
                      switch (value) {
                        case 'View Item':
                          showItemDetails(index: index);
                          break;

                        case 'Edit':
                          showSuccessToast(message: "edit feature coming soon");
                          break;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 7),
                CustomDashedLineWidget(width: Get.width),
              ],
            ),
          );
        }
      }
    }

    return TableRow(children: cells);
  }

  Future<void> downloadReport() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Create request with all filters
      final request = createRequestFromFilters();

      // Convert to the format expected by the download API
      final requestBody = {
        "metal_type": request.metalType,
        // "stock_category": request.stockCategory,
        "stock_head": request.stockHead,
        "design": request.design,
        "counter_id": request.counterId,
        "purity": request.purity,
        "weight_group": request.weightGroup,
        "ornament_type": request.ornamentType,
        "branch": request.branch,
        "size_groups": request.sizeGroups,
        "party_id": request.partyId,
        "status": request.status,
        "tagged_by": request.taggedBy,
        "date_from": request.dateFrom?.toIso8601String(),
        "date_to": request.dateTo?.toIso8601String(),
        "min_gross_weight": request.minGrossWeight,
        "max_gross_weight": request.maxGrossWeight,
        "min_net_weight": request.minNetWeight,
        "max_net_weight": request.maxNetWeight,
      };

      requestBody.removeWhere(
        (key, value) => value == null || (value is List && value.isEmpty),
      );

      final result = await inventoryRepository.downloadTaggedItemsReport(
        requestBody: requestBody,
        limit: 10000,
      );

      Get.back();

      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'tagged_items_report',
        fileExtension: 'csv',
      );

      if (success) {
        showSuccessToast(message: "Report downloaded successfully");
      } else {
        showErrorToast(message: "Download cancelled or failed");
      }
    } catch (e) {
      Get.back(); // Close loading dialog if error occurs
      log('Error downloading report: $e');
      showErrorToast(message: "Failed to download report: ${e.toString()}");
    }
  }

  Future<void> getTaggedItemsReportDetails({
    bool resetList = false,
    bool isSearch = false,
    GetTaggedItemsReportRequest? requestBody,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getTaggedItemListingResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final effectiveRequestBody =
          requestBody ?? _currentFilterRequest ?? GetTaggedItemsReportRequest();

      // Use the limited API instead
      final response = await inventoryRepository
          .getPaginatedTaggedItemsReportLimited(
            requestBody: effectiveRequestBody,
            query: searchQuery.value,
            limit: itemsPerPage,
            offsetId: lastOffsetId,
          );

      if (resetList) {
        getTaggedItemListingResponse.value = ApiResponse.completed(response);
        selectedItemIndex.value = -1;
        // Clear details when resetting list
        taggedItemDetailsResponse.value = ApiResponse.initial("Initial");
      } else {
        final currentData =
            getTaggedItemListingResponse.value.data?.values ?? [];
        List<GetTaggedItemsReportLimitedValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getTaggedItemListingResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next;
        }
      }
    } catch (e, s) {
      log("Error $e : $s");
      final handledReponse = handleDTOResponseErrors(e);
      log("Handled error $handledReponse");
      if (resetList) {
        getTaggedItemListingResponse.value = ApiResponse.error(
          handledReponse.message,
        );
      }
      getTaggedItemListingResponse.value = ApiResponse.error(
        handledReponse.message,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchTaggedItemDetails(String itemId) async {
    isLoadingDetails.value = true;
    taggedItemDetailsResponse.value = ApiResponse.loading("Loading details");

    try {
      final response = await inventoryRepository.getTaggingLineItem(itemId);
      taggedItemDetailsResponse.value = ApiResponse.completed(response);

      // Update the media controller with fetched data
      final mediaController =
          Get.find<EnhancedTaggedItemMediaUploadController>();
      // Convert GetTaggingLineItemResponse to appropriate format
      _populateMediaFromDetailResponse(response, mediaController);
    } catch (e) {
      taggedItemDetailsResponse.value = ApiResponse.error(e.toString());
      log("Error fetching item details: $e");
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void _populateMediaFromDetailResponse(
    GetTaggingLineItemResponse response,
    EnhancedTaggedItemMediaUploadController controller,
  ) {
    // Map the detailed response to media controller format
    final mediaList = <MediaData>[];

    if (response.images != null && response.images!.isNotEmpty) {
      mediaList.addAll(
        response.images!.map(
          (image) => MediaData(
            path: image.presignedUrl ?? "",
            isFile: false,
            isVideo: false, // Determine based on file extension
            fileName: image.fileName,
            fileType: image.fileType,
            s3Key: image.s3Key,
            id: image.id,
          ),
        ),
      );
    }

    controller.mediaPaths.value = mediaList;
    controller.isInitialized.value = true;
  }
  // Future<void> getTaggedItemsById({required String id}) async {
  //   getTaggedItemListingResponse.value = ApiResponse.loading("LOADING");

  //   try {
  //     // await Future.delayed(Durations.extralong4);
  //     final requestBody = GetTaggedItemsReportRequest();
  //     final response = await inventoryRepository.getPaginatedTaggedItemsReport(
  //         requestBody: requestBody, limit: 10, query: "");

  //     getTaggedItemListingResponse.value = ApiResponse.completed(response);
  //   } catch (e) {
  //     getTaggedItemListingResponse.value = ApiResponse.error(e.toString());

  //     getTaggedItemListingResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      // When searching, maintain the current filters
      await getTaggedItemsReportDetails(
        isSearch: true,
        resetList: true,
        requestBody: _currentFilterRequest,
      );
    });
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
      // Don't clear the filter request here
    }
  }

  Future<void> loadMoreItems() async {
    log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more called");
      await getTaggedItemsReportDetails();
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

    final itemData = getTaggedItemListingResponse.value.data?.values?.elementAt(
      index,
    );

    if (itemData?.id != null) {
      // Fetch detailed data for this item
      fetchTaggedItemDetails(itemData!.id!);
    }

    isItemDetailsVisible.value = true;
  }

  void hideItemDetails() {
    isItemDetailsVisible.value = false;
  }

  void toggleItemDetails({required int index}) {
    showItemDetails(index: index);
  }

  void clearFilters() {
    _currentFilterRequest = null;
    filterController.resetAllFilters();
    getTaggedItemsReportDetails(resetList: true);
  }

  Future<void> updateGenderApi({
    required String itemId,
    required String gender,
  }) async {
    try {
      await inventoryRepository.updateGender(
        request: UpdateGenderRequest(taggingLineItemId: itemId, gender: gender),
      );
    } catch (e) {
      log("Error updating gender: $e");
    }
  }
}
