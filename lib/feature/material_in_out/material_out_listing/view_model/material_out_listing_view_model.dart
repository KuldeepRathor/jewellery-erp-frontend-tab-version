import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/get_daily_rate_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/post_daily_rates_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_listing/model/get_material_out_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_view/view/material_out_view.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class MaterialOutListingViewModel extends GetxController {
  // final CustomerListingRepository _customerListingRepository =
  //     CustomerListingRepository();
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final headers =
      [
        'Sn',
        "Code",
        'Item Description',
        'Pcs',
        'G.Wt. (gm)',
        'N.Wt. (gm)',
        'VA',
        "MC",
        'Stone',
        "Rate",
        "Amount",
        "",
      ].obs;
  final columnWidths =
      [0.1, 0.3, 0.7, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.1].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final customerListingResponse =
      Rx<ApiResponse<GetMaterialOutListingResponse>>(
        ApiResponse.initial("INITIAL"),
      );

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  @override
  void onInit() {
    super.onInit();
    log("Customer Listing viewmodel initiated");
    getCustomerListingDetails(resetList: true);
  }

  @override
  void onClose() {
    log("Customer Listing viewmodel Deleted");
    super.onClose();
  }

  TableRow buildTableHeaders() {
    log("The controllers length : ${headers.length} ");
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sr") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
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
      customerListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["View", "Cancel"];
  void editCustomer(String customerId) {
    SidebarController sidebarController = Get.find();
    sidebarController.navigateToWidget(
      newChild: ViewMaterialOutPage(id: customerId),
    );
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final customerDetail = customerListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${customerDetail?.toJson()}");
    for (int i = 0; i < headers.length - 1; i++) {
      String cellContent = "-";
      Color textColor = Colors.black;
      TextDecoration? textDecoration;
      VoidCallback? onTapFunction;

      switch (i) {
        case 0:
          cellContent = "${index + 1}";
          break;
        case 1:
          // Code column
          cellContent = customerDetail?.partyCode ?? "-";
          // Make code blue and underlined
          textColor = Colors.blue;
          textDecoration = TextDecoration.underline;
          // Make it clickable to view material details
          onTapFunction = () {
            log("View material out details");
            editCustomer(customerDetail?.id ?? "");
          };
          break;
        case 2:
          cellContent = customerDetail!.lineItems?.first.itemDescription ?? "-";
          break;
        case 3:
          cellContent =
              customerDetail!.lineItems?.first.pieces.toString() ?? "-";
          break;
        case 4:
          cellContent =
              customerDetail!.lineItems?.first.grossWeight.toString() ?? "-";
          break;
        case 5:
          cellContent =
              customerDetail!.lineItems?.first.netWeight.toString() ?? "-";
          break;
        case 6:
          cellContent = customerDetail!.lineItems?.first.va.toString() ?? "-";
          break;
        case 7:
          cellContent = customerDetail!.lineItems?.first.mc.toString() ?? "-";
          break;
        case 8:
          cellContent =
              customerDetail!.lineItems?.first.stone.toString() ?? "-";
          break;
        case 9:
          cellContent = customerDetail!.lineItems?.first.rate.toString() ?? "-";
          break;
        case 10:
          cellContent =
              customerDetail!.lineItems?.first.amount.toString() ?? "-";
          break;
      }

      // Create the cell widget with proper structure
      Widget cellWidget;

      if (onTapFunction != null) {
        // For clickable cells (like code)
        cellWidget = GestureDetector(
          onTap: onTapFunction,
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
                color: textColor,
                decoration: textDecoration,
              ),
            ),
          ),
        );
      } else {
        // For non-clickable cells
        cellWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Tooltip(
            message: cellContent,
            child: CustomText(
              text: cellContent,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        );
      }

      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (i != 0) const SizedBox(width: 4),
                Flexible(child: cellWidget),
              ],
            ),
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

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
                              if (element != "Delete")
                                CustomDashedLineWidget(width: Get.width),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
              onSelected: (String value) {
                switch (value) {
                  case 'View':
                    editCustomer(customerDetail?.id ?? "");
                    break;
                  case 'Cancel':
                    Get.dialog(
                      CancelPaymentDialog(
                        subtitle:
                            'Are you sure you want to cancel this material out record?',
                        onYesPressed: () async {
                          await cancelMaterialOutRecord(customerDetail!.id!);
                        },
                      ),
                    );
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

    return TableRow(children: cells);
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> cancelMaterialOutRecord(String recordId) async {
    try {
      await _inventoryRepository.cancelMaterialOutRecord(recordId);
      // Refresh the list after successful cancellation
      await getCustomerListingDetails(resetList: true);
    } catch (e) {
      log("Error cancelling material out record: $e");
      showErrorToast(
        message: 'Failed to cancel material out record: ${e.toString()}',
      );
    }
  }

  Future<void> getCustomerListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      customerListingResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _inventoryRepository.getMaterialOutListing(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId,
      );

      if (resetList) {
        customerListingResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = customerListingResponse.value.data?.values ?? [];
        List<GetMaterialOutListingValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        customerListingResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next;
        }
      }
    } catch (e) {
      if (resetList) {
        customerListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more called");
      await getCustomerListingDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getCustomerListingDetails(resetList: true, isSearch: true);
    });
  }

  final postDailyRatesResponse = Rx<ApiResponse<DailyRateResponse>>(
    ApiResponse.initial("INITIAL"),
  );
  Future<void> postDailyRates({required PostDailyRatesRequest request}) async {
    postDailyRatesResponse.value = ApiResponse.loading("LOADING");

    try {
      final response = await _inventoryRepository.addDailyRates(request);
      postDailyRatesResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Daily Rate updated Successfully !");
      GoldRateController goldRateController = Get.find<GoldRateController>();
      goldRateController.fetchGoldRates();
      getCustomerListingDetails(resetList: true);
      Get.back();
    } catch (e) {
      final handledResponse = handleDTOResponseErrors(e);
      customerListingResponse.value = ApiResponse.error(
        handledResponse.message,
      );
      showErrorToast(
        message: handledResponse.message ?? "Something went wrong ",
      );
    }
  }
}
