import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_paginated_tagged_items_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_paginated_tagged_items_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/tagged_items_details_view.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class TaggedItemsListingViewModel extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  final BaseFilterController filterController = Get.put(BaseFilterController());
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  final headers =
      [
        "Sn",
        "Date",
        "Rec. No",
        "Tagged By",
        "Lot No",
        "Pcs",
        "Gross Wt (gm)",
        "Net Wt (gm)",
        "Stone Wt (gm)",
        "Stone Amount",
        "",
      ].obs;

  final columnWidths = [0.1, 0.4, 0.4, 0.85, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.1];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getOrnamentTypeListingResponse =
      Rx<ApiResponse<PaginatedGetTaggedItemsResponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  @override
  void onInit() {
    super.onInit();
    log("Tagged Items Listing");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterController.resetAllFilters();

      // Initialize filter controller with required filter types
      filterController.fetchAllDropdownData(
        filterTypes: ['taggedBy', 'branch'],
      );
    });
  }

  GetPaginatedTaggedItemsRequest? createRequestBodyFromFilters() {
    // Only create request body if there are filters applied
    bool hasFilters = false;
    final request = GetPaginatedTaggedItemsRequest();

    // Tagged By filter - using the multi-select list
    if (filterController.selectedTaggedBys.isNotEmpty) {
      request.taggedByIds =
          filterController.selectedTaggedBys
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Branch filter - using the multi-select list
    if (filterController.selectedBranches.isNotEmpty) {
      request.branchIds =
          filterController.selectedBranches
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Date range filter
    if (filterController.dateFrom.value != null &&
        filterController.dateTo.value != null) {
      request.dateRange = DateRange(
        rangeFrom: filterController.dateFrom.value!,
        rangeTo: filterController.dateTo.value!,
      );
      hasFilters = true;
    }

    // Gross weight range filter
    if (filterController.minGrossWeight.value != null ||
        filterController.maxGrossWeight.value != null) {
      request.grossWeightRange = Range(
        rangeFrom: filterController.minGrossWeight.value?.toString(),
        rangeTo: filterController.maxGrossWeight.value?.toString(),
      );
      hasFilters = true;
    }

    // Net weight range filter
    if (filterController.minNetWeight.value != null ||
        filterController.maxNetWeight.value != null) {
      request.nettWeightRange = Range(
        rangeFrom: filterController.minNetWeight.value?.toString(),
        rangeTo: filterController.maxNetWeight.value?.toString(),
      );
      hasFilters = true;
    }

    // Lot number range filter
    if (filterController.minLotNumber.value != null ||
        filterController.maxLotNumber.value != null) {
      request.lotNumberRange = Range(
        rangeFrom: filterController.minLotNumber.value,
        rangeTo: filterController.maxLotNumber.value,
      );
      hasFilters = true;
    }

    // Record number range filter
    if (filterController.minRecordNumber.value != null ||
        filterController.maxRecordNumber.value != null) {
      request.tagRecordNumberRange = Range(
        rangeFrom: filterController.minRecordNumber.value,
        rangeTo: filterController.maxRecordNumber.value,
      );
      hasFilters = true;
    }

    // Log the request for debugging
    if (hasFilters) {
      log("Filter request body: ${request.toJson()}");
    }

    return hasFilters ? request : null;
  }

  // Apply filters method
  void applyFilters() {
    // Call API with updated filters
    getOrnamentsTypeListingDetails(resetList: true, isSearch: false);
  }

  // Clear filters method
  void clearFilters() {
    filterController.resetAllFilters();
    getOrnamentsTypeListingDetails(resetList: true, isSearch: false);
  }

  Future<void> getOrnamentsTypeListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getOrnamentTypeListingResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      // Create request body from filters
      final requestBody = createRequestBodyFromFilters();

      final response = await inventoryRepository.getPaginatedTaggedItems(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId,
        requestBody: requestBody,
      );

      if (resetList) {
        getOrnamentTypeListingResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData =
            getOrnamentTypeListingResponse.value.data?.values ?? [];
        List<GetTaggedItemsResponseValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getOrnamentTypeListingResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        getOrnamentTypeListingResponse.value = ApiResponse.error(e.toString());
      }
      getOrnamentTypeListingResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getOrnamentsTypeListingDetails(resetList: true, isSearch: true);
    });
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> loadMoreItems() async {
    log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more called");
      await getOrnamentsTypeListingDetails();
    }
  }

  // Keep your existing table building methods unchanged...
  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      cells.add(
        Row(
          children: [
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
      getOrnamentTypeListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  void navigateToDetailsPage(String? id) {
    if (id != null) {
      log('Invoice No. $id tapped d');
      Get.to(() => TaggedItemsDetailsPage(id: id));

      // SidebarController sidebarController = Get.find<SidebarController>();
      // sidebarController.navigateToWidget(
      //     newChild: TaggedItemsDetailsPage(
      //   id: id,
      // ));
    }
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final ornamentDetail = getOrnamentTypeListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${ornamentDetail?.toJson()}");
    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = (index + 1).toString();
          break;
        case 1:
          cellContent = convertDateTimeToString(ornamentDetail?.date);
          break;
        case 2:
          cellContent = ornamentDetail?.recordNumber ?? "-";
          break;
        case 3:
          cellContent =
              "${ornamentDetail?.employeeDetails?.firstName ?? ""} ${ornamentDetail?.employeeDetails?.lastName ?? ""}";
          break;
        case 4:
          cellContent = ornamentDetail?.lotNumber ?? "-";
        case 5:
          cellContent = ornamentDetail?.totalPieces.toString() ?? "-";
          break;
        case 6:
          cellContent = ornamentDetail?.totalGrossWeight ?? "-";
          break;
        case 7:
          cellContent = ornamentDetail?.totalNetWeight ?? "-";
          break;
        case 8:
          cellContent = ornamentDetail?.totalStoneWeight ?? "-";
          break;
        case 9:
          cellContent = "₹ ${ornamentDetail?.totalStoneAmount ?? "-"}";
          break;

        default:
          cellContent = "-";
          break;
      }
      if (i != headers.length - 1) {
        cells.add(
          Column(
            children: [
              Row(
                children: [
                  if (i != 0) const SizedBox(width: 4),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        // only for Rec. no
                        if (i == 2) {
                          navigateToDetailsPage(ornamentDetail?.id);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Tooltip(
                          message: cellContent,
                          child: CustomText(
                            text: cellContent,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color: i == 2 ? secondaryColor : null,
                            decoration:
                                i == 2 ? TextDecoration.underline : null,
                          ),
                        ),
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
        cells.add(const SizedBox());
      }
    }

    return TableRow(children: cells);
  }
}
