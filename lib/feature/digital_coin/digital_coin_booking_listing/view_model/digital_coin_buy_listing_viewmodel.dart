import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/digital_coin_booking_listing/model/digital_coin_buy_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_invoice_details_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class DigitalCoinBuyListingViewModel extends GetxController {
  final JewelleryPlanRepository _jewelleryPlanRepository =
      JewelleryPlanRepository();
  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Common variables
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  List<String> popUpValues = ["Edit Plan", "Cancel Order"];
  final buy_headers =
      [
        "Date",
        "Purchase ID",
        "Customer Name",
        "Phone",
        "Invoice No.",
        "Commodity",
        "Rate/gm",
        "Weight (gms)",
        "Amount",
        "Booking At",
        "",
      ].obs;

  final buy_column_widths =
      [0.3, 0.3, 0.6, 0.4, 0.5, 0.3, 0.3, 0.3, 0.3, 0.3, 0.1].obs;

  final getDigitalCoinListingResponse =
      Rx<ApiResponse<DigitalCoinBuyListingResponse>>(
        ApiResponse.initial('Empty data'),
      );

  @override
  void onInit() {
    super.onInit();
    getDigitalCoinBuyListing(resetList: true, isSearch: false);
  }

  @override
  void onClose() {
    // log("Invoice viewmodel deleted");
    super.onClose();
  }

  void onInvoiceNoTapped(String? id) {
    if (id != null) {
      log('Invoice No. $id tapped');
      // Get.to(() => SidebarLayoutWidget(
      //       child: InvoiceDetailsPage(
      //         id: id,
      //       ),
      //     ));
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: PurchaseReturnInvoiceDetailsScreen(id: id),
      );
    }
  }

  Widget _buildActionColumn() {
    return Column(
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
            icon: const Icon(Icons.more_vert_outlined, size: 20),
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
                              element,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (element != "Cancel")
                              CustomDashedLineWidget(width: Get.width),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
            onSelected: (String value) {
              // Handle the selected option
              switch (value) {
                case 'Edit Plan':
                  // Handle View Ledger
                  break;

                case 'Cancel Order':
                  // Handle Cancel
                  break;
              }
            },
          ),
        ),
        const SizedBox(height: 7),
        CustomDashedLineWidget(width: Get.width),
      ],
    );
  }

  TableRow buildVendorInvoiceTableHeaders() {
    List<Widget> vendor_cells = [];

    for (int i = 0; i < buy_headers.length; i++) {
      String vendor_header = buy_headers.elementAt(i);
      vendor_cells.add(
        Row(
          children: [
            if (vendor_header != "Sr") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: buy_headers.elementAt(i),
                color: Colors.white,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return TableRow(children: vendor_cells);
  }

  List<TableRow> build_vendor_invoice_rows(BuildContext context) {
    final data = getDigitalCoinListingResponse.value.data?.results;
    if (data == null || data.isEmpty) {
      return [];
    }
    return List.generate(data.length, (index) => buildVendorTableRow(index));
  }

  TableRow buildVendorTableRow(int index) {
    List<Widget> vendor_cells = [];
    final vendorInvoice =
        getDigitalCoinListingResponse.value.data?.results?[index];

    // if (vendorInvoice == null) {
    //   return TableRow(
    //     children: List.generate(
    //       buy_headers.length,
    //       (index) => const SizedBox.shrink(),
    //     ),
    //   );
    // }

    for (var i = 0; i < buy_headers.length - 1; i++) {
      String cellContent = "-";
      switch (i) {
        case 0: // Serial number cell
          cellContent = vendorInvoice?.completedDate ?? "-";
        case 1:
          cellContent = vendorInvoice?.purchaseId.toString() ?? "-";
          break;

        case 2:
          cellContent = vendorInvoice!.user?.firstName.toString() ?? "-";
          break;
        case 3:
          cellContent = vendorInvoice!.user?.phone.toString() ?? "-";
          break;
        case 4:
          cellContent = vendorInvoice?.invoiceNo ?? "-";
          break;
        case 5:
          cellContent = vendorInvoice?.commodity ?? "-";
          break;
        case 6:
          cellContent = vendorInvoice?.rate.toString() ?? "-";
          break;
        case 7:
          cellContent = vendorInvoice?.quantity.toString() ?? "-";
          break;
        case 8:
          cellContent = vendorInvoice?.amount.toString() ?? "-";
          break;
        case 9:
          cellContent = vendorInvoice?.source ?? "-";
          break;
      }
      vendor_cells.add(
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
    }

    vendor_cells.add(_buildActionColumn());

    return TableRow(children: vendor_cells);
  }

  // String getInvoiceNumber(String? invoiceNumber) {
  //   if (invoiceNumber != null) {
  //     if (invoiceNumber.isEmpty) {
  //       return "-";
  //     }
  //     return invoiceNumber;
  //   }
  //   return "-";
  // }

  Future<void> getDigitalCoinBuyListing({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getDigitalCoinListingResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _jewelleryPlanRepository.getDigitalCoinBuyListing(
        category: "BUY",
        page: currentPage.value,
        limit: itemsPerPage.toString(),
      );

      if (resetList) {
        getDigitalCoinListingResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the existing list with proper type casting
        final currentData =
            getDigitalCoinListingResponse.value.data?.results ?? [];
        final List<Result> combinedResults = [
          ...currentData,
          ...(response.results ?? []),
        ];

        // Create a new response object with the combined results
        final updatedResponse = DigitalCoinBuyListingResponse(
          page: response.page,
          limit: response.limit,
          totalResults: response.totalResults,
          results: combinedResults,
        );

        getDigitalCoinListingResponse.value = ApiResponse.completed(
          updatedResponse,
        );
      }

      // Check if there are more pages
      if (response.totalResults != null && response.results != null) {
        hasMorePages.value =
            (currentPage.value * itemsPerPage) < response.totalResults!;
      }

      if (hasMorePages.value) {
        currentPage.value++;
      }
    } catch (e) {
      if (resetList) {
        getDigitalCoinListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> vendorLoadMoreItems() async {
    log("The query loadMore ${isLoadingMore.value} ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("The query calling more");
      await getDigitalCoinBuyListing();
    }
  }

  void setInitialConditions({required bool isSearch}) {
    currentPage.value = 1;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      await getDigitalCoinBuyListing(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getDigitalCoinBuyListing();
    }
  }
}
