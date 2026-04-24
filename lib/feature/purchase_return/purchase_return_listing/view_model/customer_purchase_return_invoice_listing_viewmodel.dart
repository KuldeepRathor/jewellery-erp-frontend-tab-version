import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_resturn_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_invoice_details_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_listing/models/get_paginated_purchase_return_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class CustomerPurchaseReturnInvoiceListingViewModel extends GetxController {
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();
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
  final customer_headers =
      [
        "Sn",
        "Date",
        "Invoice No.",
        "Customer Name",
        "Item Description",
        // "Mobile No.",
        "Weight(gm)",
        "Amount",
        "Total(₹)",
        "",
      ].obs;

  final customer_column_widths =
      [
        0.1,
        0.4,
        0.8,
        0.5,
        1.05,
        // 0.3,
        0.3,
        0.3,
        0.275,
        0.1,
      ].obs;

  final getCustomerInvoiceResponse =
      Rx<ApiResponse<PaginatedGetPurchaseReturnListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  @override
  void onInit() {
    super.onInit();
    log("Invoice viewmodel initiated");
    // getCustomerPurchaseInvoice(resetList: true, isSearch: false);
    getCustomerPurchaseInvoice(resetList: true);
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
  Widget _buildActionColumn({
    required PurchaseReturnResponseModel? purchaseReturnDetails,
  }) {
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
                  Get.dialog(
                    CancelPaymentDialog(
                      subtitle:
                          'Are you sure you want to cancel this purchase return?',
                      onYesPressed: () async {
                        await cancelPurchaseReturn(purchaseReturnDetails!.id!);
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
    );
  }

  // Customer-specific methods
  TableRow buildCustomerInvoiceTableHeaders() {
    List<Widget> customer_cells = [];

    for (int i = 0; i < customer_headers.length; i++) {
      String customer_header = customer_headers.elementAt(i);
      customer_cells.add(
        Row(
          children: [
            if (customer_header != "Sn") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: customer_headers.elementAt(i),
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
    final data = getCustomerInvoiceResponse.value.data?.values;
    if (data == null || data.isEmpty) {
      return [];
    }
    return List.generate(data.length, (index) => buildCustomerTableRow(index));
  }

  TableRow buildCustomerTableRow(int index) {
    List<Widget> customer_cells = [];
    final customerInvoice =
        getCustomerInvoiceResponse.value.data?.values?[index];

    if (customerInvoice == null) {
      return TableRow(
        children: List.generate(
          customer_headers.length,
          (index) => Container(),
        ),
      );
    }

    for (int i = 0; i < customer_headers.length - 1; i++) {
      Widget cellWidget;
      switch (i) {
        case 0: // Serial number cell
          cellWidget = Tooltip(
            message: (index + 1).toString(),
            child: CustomText(
              text: (index + 1).toString(),
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          );
          break;
        case 2: // Invoice No. cell
          cellWidget = GestureDetector(
            onTap: () => onInvoiceNoTapped(customerInvoice.id),
            child: Tooltip(
              message: customerInvoice.returnInvoiceNumber?.toString() ?? "-",
              child: Text(
                customerInvoice.returnInvoiceNumber?.toString() ?? "-",
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
          break;
        // ... (other cases remain the same)
        default:
          String cellValue = getCustomerCellValue(i, customerInvoice);
          cellWidget = Tooltip(
            message: cellValue,
            child: CustomText(
              text: cellValue,
              maxLines: 1,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          );
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
                    child: cellWidget,
                  ),
                ),
              ],
            ),
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

    customer_cells.add(
      _buildActionColumn(purchaseReturnDetails: customerInvoice),
    );

    return TableRow(children: customer_cells);
  }

  String getCustomerCellValue(int index, PurchaseReturnResponseModel invoice) {
    switch (index) {
      case 0:
        return (index + 1).toString();
      case 1:
        return convertDateTimeToString(invoice.returnCreateDate);
      case 3:
        return invoice.partyName ?? "-";
      case 4:
        return getLineItemNames(invoice.lineItems);
      // case 5:
      //   // return invoice.  ?? "";
      //   return getLineItemNames(invoice.);
      case 5:
        return getLineItemsTotalWeight(invoice.lineItems);
      case 6:
        return getLineItemsTotalAmount(invoice.lineItems);
      case 7:
        return getLineItemsTotalAmount(invoice.lineItems);
      default:
        return "-";
    }
  }

  Future<void> cancelPurchaseReturn(String returnId) async {
    try {
      await _purchaseInvoiceRepository.cancelPurchaseReturn(returnId);
      // Refresh the list after successful cancellation
      await getCustomerPurchaseInvoice(resetList: true);
    } catch (e) {
      log("Error cancelling purchase return: $e");
      showErrorToast(
        message: 'Failed to cancel purchase return: ${e.toString()}',
      );
    }
  }

  Future<void> getCustomerPurchaseInvoice({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getCustomerInvoiceResponse.value = ApiResponse.loading("LOADING");
    } else {
      log("req: loading more ");
      isLoadingMore.value = true;
      log("req: loading more true ");
    }

    try {
      log("req: api call ");
      final response = await _purchaseInvoiceRepository
          .getPurchaseReturnInvoices(
            query: searchQuery.value,
            limit: itemsPerPage,
            offsetId: lastOffsetId,
            partyType: PartyType.customer,
          );
      log("req: api call success ");

      if (resetList) {
        log("req: api call success reset ");
        getCustomerInvoiceResponse.value = ApiResponse.completed(response);
      } else {
        log("req: api call success add ");
        // Add to the end of the list
        final currentData = getCustomerInvoiceResponse.value.data?.values ?? [];
        List<PurchaseReturnResponseModel> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getCustomerInvoiceResponse.value = ApiResponse.completed(response);
        log("req: api call success add success ");
      }

      hasMorePages.value = response.pagination?.next != null;
      log("req: hasMore: ${hasMorePages.value}");

      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
      log("req:completed}");
    } catch (e) {
      if (resetList) {
        getCustomerInvoiceResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      log("req:completed finally");
      isLoadingMore.value = false;
    }
  }

  Future<void> customerLoadMoreItems() async {
    log("The query loadMore ${isLoadingMore.value} ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("The query calling more");
      await getCustomerPurchaseInvoice();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getCustomerPurchaseInvoice(resetList: true, isSearch: true);
    });
  }

  // Remaining common methods

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  String getLineItemNames(List<PurchaseReturnResponseLineItem>? lineItems) {
    if (lineItems == null || lineItems.isEmpty) {
      return '';
    }
    return lineItems
        .map((item) => item.itemDescription ?? '')
        .where((description) => description.isNotEmpty)
        .join(', ');
  }

  String getLineItemsTotalAmount(
    List<PurchaseReturnResponseLineItem>? lineItems,
  ) {
    if (lineItems == null || lineItems.isEmpty) {
      return "-";
    }
    double total = lineItems
        .map((item) => double.tryParse(item.amount ?? '0') ?? 0)
        .fold(0, (sum, amount) => sum + amount);
    return total.toStringAsFixed(2);
  }

  String getLineItemsTotalWeight(
    List<PurchaseReturnResponseLineItem>? lineItems,
  ) {
    if (lineItems == null || lineItems.isEmpty) {
      return "-";
    }
    double total = lineItems
        .map((item) => double.tryParse(item.netWeight ?? '0') ?? 0)
        .fold(0, (sum, amount) => sum + amount);
    return total.toStringAsFixed(2);
  }
}
