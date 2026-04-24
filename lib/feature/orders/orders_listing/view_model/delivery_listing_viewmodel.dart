import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/digital_coin_booking_listing/model/digital_coin_delivery_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_invoice_details_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class DeliveryListingViewModel extends GetxController {
  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Common variables
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  List<String> popUpValues = [
    "Add Estimate",
    "View Ledger",
    "Print",
    "Edit",
    "Return",
    "Cancel",
  ];

  // Customer-specific variables
  final delivery_headers =
      [
        "Date",
        "Delivery ID",
        "Customer Name",
        "Phone",
        "Commodity",
        "Weight(gm)",
        "",
      ].obs;

  final delivery_column_widths = [0.5, 0.5, 1.1, 0.5, 0.5, 0.5, 0.1].obs;

  final getDigitalCoinListingResponse =
      Rx<ApiResponse<DigitalCoinDeliveryListingResponse>>(
        ApiResponse.initial('Empty data'),
      );
  @override
  void onInit() {
    super.onInit();
    log("Invoice viewmodel initiated");
    // getDigitalCoinDeliveryListing();
  }

  @override
  void onClose() {
    log("Invoice viewmodel deleted");
    super.onClose();
  }

  void onInvoiceNoTapped(String? id) {
    if (id != null) {
      log('Invoice No. $id tapped d');
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

  // Vendor-specific methods
  // Common methods
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
                case 'Add Estimate':
                  // Handle Add Estimate
                  break;
                case 'View Ledger':
                  // Handle View Ledger
                  break;
                case 'Print':
                  // Handle Print
                  break;
                case 'Edit':
                  // Handle Edit
                  break;
                case 'Return':
                  // Handle Return
                  break;
                case 'Cancel':
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

  // Customer-specific methods
  TableRow buildCustomerInvoiceTableHeaders() {
    List<Widget> customer_cells = [];

    for (int i = 0; i < delivery_headers.length; i++) {
      String customer_header = delivery_headers.elementAt(i);
      customer_cells.add(
        Row(
          children: [
            if (customer_header != "Sn") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: delivery_headers.elementAt(i),
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
    return TableRow(children: customer_cells);
  }

  List<TableRow> build_customer_invoice_rows(BuildContext context) {
    final data = getDigitalCoinListingResponse.value.data?.results;
    if (data == null || data.isEmpty) {
      return [];
    }
    return List.generate(data.length, (index) => buildCustomerTableRow(index));
  }

  TableRow buildCustomerTableRow(int index) {
    List<Widget> customer_cells = [];
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

    for (var i = 0; i < delivery_headers.length - 1; i++) {
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
          cellContent = vendorInvoice?.commodity ?? "-";
          break;
        case 5:
          cellContent = vendorInvoice?.quantity.toString() ?? "-";
          break;
      }
      customer_cells.add(
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

    customer_cells.add(_buildActionColumn());

    return TableRow(children: customer_cells);
  }

  // Future<void> getDigitalCoinDeliveryListing({
  //   bool resetList = false,
  //   bool isSearch = false,
  // }) async {
  //   if (resetList) {
  //     setInitialConditions(isSearch: isSearch);
  //     getDigitalCoinListingResponse.value = ApiResponse.loading("LOADING");
  //   } else {
  //     isLoadingMore.value = true;
  //   }

  //   try {
  //     final response =
  //         await _jewelleryPlanRepository.getDigitalCoinDeliveryListing(
  //       category: "DELIVERY",
  //       page: currentPage.value,
  //       limit: itemsPerPage.toString(),
  //     );

  //     if (resetList) {
  //       getDigitalCoinListingResponse.value = ApiResponse.completed(response);
  //     } else {
  //       // Add to the existing list with proper type casting
  //       final currentData =
  //           getDigitalCoinListingResponse.value.data?.results ?? [];
  //       final List<Result> combinedResults = [
  //         ...currentData,
  //         ...(response.results ?? [])
  //       ];

  //       // Create a new response object with the combined results
  //       final updatedResponse = DigitalCoinDeliveryListingResponse(
  //         page: response.page,
  //         limit: response.limit,
  //         totalResults: response.totalResults,
  //         results: combinedResults,
  //       );

  //       getDigitalCoinListingResponse.value =
  //           ApiResponse.completed(updatedResponse);
  //     }

  //     // Check if there are more pages
  //     if (response.totalResults != null && response.results != null) {
  //       hasMorePages.value =
  //           (currentPage.value * itemsPerPage) < response.totalResults!;
  //     }

  //     if (hasMorePages.value) {
  //       currentPage.value++;
  //     }
  //   } catch (e) {
  //     if (resetList) {
  //       getDigitalCoinListingResponse.value = ApiResponse.error(e.toString());
  //     }
  //   } finally {
  //     isLoadingMore.value = false;
  //   }
  // }

  Future<void> customerLoadMoreItems() async {
    log("The query loadMore ${isLoadingMore.value} ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("The query calling more");
      // await getDigitalCoinDeliveryListing();
    }
  }

  // void setSearchQuery(String query) {
  //   searchQuery.value = query;
  //   log("Setting search query ${searchQuery.value}");
  //   _debouncer.run(() async {
  //     await getCustomerPurchaseInvoice(resetList: true, isSearch: true);
  //   });
  // }

  // Remaining common methods

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
      // await getDigitalCoinDeliveryListing(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      // await getDigitalCoinDeliveryListing();
    }
  }
}
