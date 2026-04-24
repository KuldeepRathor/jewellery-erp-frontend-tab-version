import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_listing/model/get_reorder_level_list_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_listing/model/get_wanted_list_response.dart';

import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class ReorderLevelViewModel extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final InventoryRepository inventoryRepository = InventoryRepository();
  // final VendorRepository _vendorRepository = VendorRepository();

  final isLoading = false.obs;

  final Rx<List<StockHeadMetalTypesResponse>?> metalResponseValues =
      Rx<List<StockHeadMetalTypesResponse>?>(null);

  // // Response variables for dropdowns
  // final Rx<ApiResponse<List<DropdownItem>>> stockHeadResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final Rx<ApiResponse<List<DropdownItem>>> designResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final Rx<ApiResponse<List<DropdownItem>>> purityResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final Rx<ApiResponse<List<DropdownItem>>> vendorResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));

  // // Selected values
  // final Rx<DropdownItem?> selectedStockHead = Rx<DropdownItem?>(null);
  // final Rx<DropdownItem?> selectedMetal = Rx<DropdownItem?>(null);
  // final Rx<DropdownItem?> selectedPurity = Rx<DropdownItem?>(null);
  // final Rx<DropdownItem?> selectedVendor = Rx<DropdownItem?>(null);

  // List<DropdownItem> selectedMetalTypes = [];

  // List<DropdownItem> metalTypes = [];

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchAllDropdownData();
  // }

  // void fetchAllDropdownData() {
  //   getStockHeads();
  //   getMetal();
  //   getPurity();
  //   getVendors();
  // }

  // void getStockHeads() async {
  //   try {
  //     stockHeadResponse.value = ApiResponse.loading("Loading");
  //     selectedStockHead.value = null;
  //     final response = await inventoryRepository.getStockHeads();
  //     final listOfResponse = response.values ?? [];
  //     final dropdownItems = listOfResponse
  //         .map((item) => DropdownItem(id: item.id, name: item.name))
  //         .toList();
  //     dropdownItems.insert(
  //         0,
  //         DropdownItem(
  //           id: null,
  //           name: "Null",
  //         ));
  //     if (dropdownItems.isNotEmpty) {
  //       selectedStockHead.value = dropdownItems.first;
  //     }
  //     stockHeadResponse.value = ApiResponse.completed(dropdownItems);
  //   } catch (e) {
  //     stockHeadResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // void getMetal() async {
  //   try {
  //     designResponse.value = ApiResponse.loading("Loading");
  //     selectedMetal.value = null;
  //     final response = await inventoryRepository.getStockHeadMetalTypes();
  //     final listOfResponse = response;
  //     final dropdownItems = listOfResponse
  //         .map((item) => DropdownItem(id: item.id, name: item.typeName))
  //         .toList();
  //     dropdownItems.insert(
  //         0,
  //         DropdownItem(
  //           id: null,
  //           name: "Null",
  //         ));
  //     if (dropdownItems.isNotEmpty) {
  //       selectedMetal.value = dropdownItems.first;
  //     }
  //     metalResponseValues.value = response;
  //     designResponse.value = ApiResponse.completed(dropdownItems);
  //   } catch (e, s) {
  //     log("Error in get design $e $s");
  //     designResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // void getPurity() async {
  //   try {
  //     purityResponse.value = ApiResponse.loading("Loading");
  //     final response = await inventoryRepository.getAllPurityTypes();
  //     final dropdownItems = response.values
  //             ?.map((item) => DropdownItem(id: item, name: item))
  //             .toList() ??
  //         [];
  //     dropdownItems.insert(
  //         0,
  //         DropdownItem(
  //           id: null,
  //           name: "Null",
  //         ));
  //     if (dropdownItems.isNotEmpty) {
  //       selectedPurity.value = dropdownItems.first;
  //     }
  //     purityResponse.value = ApiResponse.completed(dropdownItems);
  //   } catch (e) {
  //     purityResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // void getVendors() async {
  //   try {
  //     vendorResponse.value = ApiResponse.loading("Loading");
  //     final response =
  //         await _vendorRepository.getVendorListingDetails(limit: 1000);
  //     final dropdownItems = response.values
  //             ?.map((item) => DropdownItem(id: item.id, name: item.name))
  //             .toList() ??
  //         [];
  //     dropdownItems.insert(
  //         0,
  //         DropdownItem(
  //           id: null,
  //           name: "Null",
  //         ));
  //     if (dropdownItems.isNotEmpty) {
  //       selectedVendor.value = dropdownItems.first;
  //     }
  //     vendorResponse.value = ApiResponse.completed(dropdownItems);
  //   } catch (e) {
  //     vendorResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // // Setter methods for dropdown values
  // void setStockHead(DropdownItem value) {
  //   selectedStockHead.value = value;
  // }

  // void setMetal(DropdownItem value) {
  //   log("Metal set $value");
  //   selectedMetal.value = value;
  // }

  // void setPurity(DropdownItem value) {
  //   selectedPurity.value = value;
  // }

  // void setVendor(DropdownItem value) {
  //   selectedVendor.value = value;
  // }

  // void applyFilters() {
  //   // Implement your filter logic here
  //   // isLoading.value = true;
  //   // Future.delayed(
  //   //   const Duration(seconds: 1),
  //   //   () => isLoading.value = false,
  //   // );
  //   final requestBody = GetReorderLevelRequest(
  //     purity:
  //         selectedPurity.value?.id == null ? [] : [selectedPurity.value!.id!],
  //     stockHead: selectedStockHead.value?.id == null
  //         ? []
  //         : [selectedStockHead.value!.id!],
  //     vendor:
  //         selectedVendor.value?.id == null ? [] : [selectedVendor.value!.id!],
  //     metalType:
  //         selectedMetal.value?.id == null ? [] : [selectedMetal.value!.id!],
  //   );

  //   // log("The filter will be ${requestBody.toJson()} ${selectedDesign.value?.id} ${selectedSizeDetails.value?.id}");

  //   getWantedListings(
  //     isSearch: false,
  //     resetList: true,
  //     requestBody: requestBody,
  //   );
  //   // Add your API call or filtering logic
  //   // Then set isLoading.value = false when done
  // }

  final headers =
      [
        "Sn",
        "Design Name",
        "Head",
        "Weight Group",
        "Size",
        "Supplier",
        "Purity",
        "Min",
        "Max",
      ].obs;

  final columnWidths = [
    0.1, // Sn
    0.5, // Design Name
    0.437, // Weight
    0.437, // Size
    0.437, // Purity
    0.437, // Supplier
    0.437, // Min
    0.437, // In Stock
    0.437, // Wanted
    0.1, // Action
  ];
  final getWantedListResponse = Rx<ApiResponse<GetReorderLevelResponse>>(
    ApiResponse.initial("Initial"),
  );
  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var header in headers) {
      cells.add(
        Row(
          children: [
            Flexible(
              child: CustomText(
                text: header,
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
      getWantedListResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index, context),
    );
  }

  TableRow buildTableRow(int index, BuildContext context) {
    List<Widget> cells = [];
    // ignore: unused_local_variable
    final item = getWantedListResponse.value.data?.values?.elementAt(index);

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = (index + 1).toString();
          break;
        case 1:
          cellContent = item?.designName ?? "-";

          break;
        case 2:
          cellContent = item?.stockHeadName ?? "-";
          break;
        case 3:
          cellContent = item?.weightGroup?.name ?? "-";
          // cellContent = "-";
          break;
        case 4:
          cellContent = item?.sizeGroup?.code ?? "-";
          // cellContent = "-";
          break;
        case 5:
          cellContent = item?.vendorDetails?.name ?? "-";
          // cellContent = "-";
          break;
        case 6:
          cellContent = item?.purity?.toString() ?? "-";
          // cellContent = "-";
          break;
        case 7:
          cellContent = item?.min?.toString() ?? "-";
          // cellContent = "-";
          break;
        case 8:
          cellContent = item?.max?.toString() ?? "-";
          // cellContent = "-";
          break;
      }

      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (i != 0) const SizedBox(width: 4),
                Flexible(
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
    }

    return TableRow(children: cells);
  }

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  Future<void> getWantedListings({
    bool resetList = false,
    bool isSearch = false,
    GetReorderLevelRequest? requestBody,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getWantedListResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }
    try {
      // await Future.delayed(Durations.extralong4);

      final response = await _aggregateRepository.getPaginatedWReorderList(
        requestBody: requestBody ?? GetReorderLevelRequest(),
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId,
      );

      if (resetList) {
        getWantedListResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = getWantedListResponse.value.data?.values ?? [];
        List<GetReorderLevelResponseValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getWantedListResponse.value = ApiResponse.completed(response);
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
        getWantedListResponse.value = ApiResponse.error(handledReponse.message);
      }
      getWantedListResponse.value = ApiResponse.error(handledReponse.message);
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getWantedListings(isSearch: true, resetList: true);
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
      await getWantedListings();
    }
  }
}
