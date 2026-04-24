import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/wanted_list/model/get_wanted_list_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/wanted_list/model/get_wanted_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class WantedListViewModel extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  // final VendorRepository _vendorRepository = VendorRepository();
  // final OrganizationRepository _organizationRepository =
  //     OrganizationRepository();
  final isLoading = false.obs;

  final Rx<PaginatedDesignListingResponse?> designResponseValues =
      Rx<PaginatedDesignListingResponse?>(null);

  // // Response variables for dropdowns
  // final Rx<ApiResponse<List<DropdownItem>>> stockHeadResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final Rx<ApiResponse<List<DropdownItem>>> designResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final Rx<ApiResponse<List<DropdownItem>>> branchResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final Rx<ApiResponse<List<DropdownItem>>> vendorResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final Rx<ApiResponse<List<DropdownItem>>> sizeDetailsResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));

  // // Selected values
  // final Rx<DropdownItem?> selectedStockHead = Rx<DropdownItem?>(null);
  // final Rx<DropdownItem?> selectedDesign = Rx<DropdownItem?>(null);
  // final Rx<DropdownItem?> selectedBranch = Rx<DropdownItem?>(null);
  // final Rx<DropdownItem?> selectedVendor = Rx<DropdownItem?>(null);
  // final Rx<DropdownItem?> selectedSizeDetails = Rx<DropdownItem?>(null);

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchAllDropdownData();
  // }

  // void fetchAllDropdownData() {
  //   getStockHeads();
  //   getDesigns();
  //   getBranches();
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

  // void getDesigns() async {
  //   try {
  //     designResponse.value = ApiResponse.loading("Loading");
  //     sizeDetailsResponse.value = ApiResponse.loading("loading");
  //     selectedDesign.value = null;
  //     selectedSizeDetails.value = null;
  //     final response = await inventoryRepository.getAllDesign();
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
  //       selectedDesign.value = dropdownItems.first;
  //     }
  //     designResponseValues.value = response;
  //     designResponse.value = ApiResponse.completed(dropdownItems);
  //   } catch (e, s) {
  //     log("Error in get design $e $s");
  //     designResponse.value = ApiResponse.error(e.toString());
  //     sizeDetailsResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // void getBranches() async {
  //   try {
  //     branchResponse.value = ApiResponse.loading("Loading");
  //     final response = await _organizationRepository.getAllBranches();
  //     final dropdownItems = response.values
  //             ?.map((item) => DropdownItem(id: item.id, name: item.branchName))
  //             .toList() ??
  //         [];
  //     dropdownItems.insert(
  //         0,
  //         DropdownItem(
  //           id: null,
  //           name: "Null",
  //         ));
  //     if (dropdownItems.isNotEmpty) {
  //       selectedBranch.value = dropdownItems.first;
  //     }
  //     branchResponse.value = ApiResponse.completed(dropdownItems);
  //   } catch (e) {
  //     branchResponse.value = ApiResponse.error(e.toString());
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

  // void setDesign(DropdownItem value) {
  //   log("Design set $value");
  //   selectedDesign.value = value;
  //   // Update size details from design response
  //   GetDesignResponseModel? selectedDesignValue =
  //       designResponseValues.value?.values?.firstWhereOrNull(
  //     (element) => element.id == value.id,
  //   );
  //   sizeDetailsResponse.value = ApiResponse.loading("loading");
  //   final sizeDetailsList = selectedDesignValue?.stockHead?.sizeGroups
  //           ?.map((size) => DropdownItem(id: size.id, name: size.size))
  //           .toList() ??
  //       [];
  //   sizeDetailsList.insert(
  //       0,
  //       DropdownItem(
  //         id: null,
  //         name: "Null",
  //       ));
  //   if (sizeDetailsList.isNotEmpty) {
  //     selectedSizeDetails.value = sizeDetailsList.first;
  //   }
  //   sizeDetailsResponse.value = ApiResponse.completed(sizeDetailsList);
  // }

  // void setBranch(DropdownItem value) {
  //   selectedBranch.value = value;
  // }

  // void setVendor(DropdownItem value) {
  //   selectedVendor.value = value;
  // }

  // void setSizeDetails(DropdownItem value) {
  //   selectedSizeDetails.value = value;
  // }

  // void applyFilters() {
  //   // Implement your filter logic here
  //   // isLoading.value = true;
  //   // Future.delayed(
  //   //   const Duration(seconds: 1),
  //   //   () => isLoading.value = false,
  //   // );
  //   final requestBody = GetWantedListRequest(
  //       design:
  //           selectedDesign.value?.id == null ? [] : [selectedDesign.value!.id!],
  //       size: selectedSizeDetails.value?.id == null
  //           ? []
  //           : [selectedSizeDetails.value!.id!]);

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
        "Weight",
        "Size",
        "Purity",
        "Supplier",
        "Min",
        "In Stock",
        "Wanted Pcs",
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
  final getWantedListResponse = Rx<ApiResponse<GetWantedListResponse>>(
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
          cellContent = item?.weight?.toString() ?? "-";
          break;
        case 3:
          cellContent = item?.size ?? "-";
          // cellContent = "-";
          break;
        case 4:
          cellContent = item?.purity ?? "-";
          // cellContent = "-";
          break;
        case 5:
          // cellContent = item?.supplier ?? "-";
          cellContent = "-";
          break;
        case 6:
          cellContent = item?.min?.toString() ?? "-";
          // cellContent = "-";
          break;
        case 7:
          cellContent = item?.inStock?.toString() ?? "-";
          // cellContent = "-";
          break;
        case 8:
          cellContent = item?.wanted?.toString() ?? "-";
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
    GetWantedListRequest? requestBody,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getWantedListResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }
    try {
      final response = await inventoryRepository.getPaginatedWantedList(
        requestBody: requestBody ?? GetWantedListRequest(),
        query: searchQuery.value,
        // limit: itemsPerPage,
        limit: 300,
        offsetId: lastOffsetId,
      );

      if (resetList) {
        getWantedListResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = getWantedListResponse.value.data?.values ?? [];
        List<GetWantedListResponseValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getWantedListResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = false;
      lastOffsetId = null;
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
