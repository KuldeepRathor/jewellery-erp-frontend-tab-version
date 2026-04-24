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

class VendorPurchaseReturnInvoiceListingViewModel extends GetxController {
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
  final vendor_headers =
      [
        "Sr",
        "Date",
        "Invoice No.",
        "Vendor Name",
        "Item Description",
        "Weight",
        "Amount",
        "CGST(₹)",
        "SGST(₹)",
        "IGST(₹)",
        "TDS(₹)",
        "TCS(₹)",
        "Total(₹)",
        "",
      ].obs;

  final vendor_column_widths =
      [
        0.1,
        0.3,
        0.35,
        0.425,
        0.725,
        0.2,
        0.2,
        0.2,
        0.2,
        0.2,
        0.2,
        0.2,
        0.225,
        0.1,
      ].obs;
  @override
  void onInit() {
    super.onInit();
    log("Invoice viewmodel initiated");
    getPurchaseInvoice(resetList: true, isSearch: false);
  }

  @override
  void onClose() {
    log("Invoice viewmodel deleted");
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

  TableRow buildVendorInvoiceTableHeaders() {
    List<Widget> vendor_cells = [];

    for (int i = 0; i < vendor_headers.length; i++) {
      String vendor_header = vendor_headers.elementAt(i);
      vendor_cells.add(
        Row(
          children: [
            if (vendor_header != "Sr") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: vendor_headers.elementAt(i),
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
    final data = getPurchaseInvoiceResponse.value.data?.values;
    if (data == null || data.isEmpty) {
      return [];
    }
    return List.generate(data.length, (index) => buildVendorTableRow(index));
  }

  TableRow buildVendorTableRow(int index) {
    List<Widget> vendor_cells = [];
    final vendorInvoice = getPurchaseInvoiceResponse.value.data?.values?[index];

    if (vendorInvoice == null) {
      return TableRow(
        children: List.generate(
          vendor_headers.length,
          (index) => const SizedBox.shrink(),
        ),
      );
    }

    for (var i = 0; i < vendor_headers.length - 1; i++) {
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
              maxLines: 1,
            ),
          );
          break;
        case 2: // Invoice No. cell
          cellWidget = GestureDetector(
            onTap: () => onInvoiceNoTapped(vendorInvoice.id ?? "-"),
            child: Tooltip(
              message: getInvoiceNumber(vendorInvoice.returnInvoiceNumber),
              child: Text(
                getInvoiceNumber(vendorInvoice.returnInvoiceNumber),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
          String cellValue = getVendorCellValue(i, vendorInvoice);
          cellWidget = Tooltip(
            message: cellValue,
            child: CustomText(
              text: cellValue,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          );
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

    vendor_cells.add(_buildActionColumn(purchaseReturnDetails: vendorInvoice));

    return TableRow(children: vendor_cells);
  }

  String getInvoiceNumber(String? invoiceNumber) {
    if (invoiceNumber != null) {
      if (invoiceNumber.isEmpty) {
        return "-";
      }
      return invoiceNumber;
    }
    return "-";
  }

  String getVendorCellValue(int index, PurchaseReturnResponseModel invoice) {
    switch (index) {
      case 0:
        return (index + 1).toString();
      case 1:
        return convertDateTimeToString(invoice.returnCreateDate);
      case 3:
        return invoice.partyName ?? "-";
      case 4:
        return getLineItemNames(invoice.lineItems);
      case 5:
        return getLineItemsTotalWeight(invoice.lineItems);
      case 6:
        return getLineItemsTotalAmount(invoice.lineItems);
      // case 7:
      //   return invoice.paymentDetails?.first.cgst ?? "-";
      // case 8:
      //   return invoice.paymentDetails?.first.sgst ?? "-";
      // case 9:
      //   return invoice.paymentDetails?.first.igst ?? "-";
      // case 10:
      //   return invoice.paymentDetails?.first.tds ?? "-";
      // case 11:
      //   return invoice.paymentDetails?.first.tcs ?? "-";
      // case 12:
      //   return invoice.paymentDetails?.first.total ?? "-";
      default:
        return "-";
    }
  }

  final getPurchaseInvoiceResponse =
      Rx<ApiResponse<PaginatedGetPurchaseReturnListingResponse>>(
        ApiResponse.initial('Empty data'),
      );
  Future<void> getPurchaseInvoice({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getPurchaseInvoiceResponse.value = ApiResponse.loading("LOADING");
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
            partyType: PartyType.vendor,
          );
      log("req: api call success ");

      if (resetList) {
        log("req: api call success reset ");
        getPurchaseInvoiceResponse.value = ApiResponse.completed(response);
      } else {
        log("req: api call success add ");
        // Add to the end of the list
        final currentData = getPurchaseInvoiceResponse.value.data?.values ?? [];
        List<PurchaseReturnResponseModel> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getPurchaseInvoiceResponse.value = ApiResponse.completed(response);
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
        getPurchaseInvoiceResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      log("req:completed finally");
      isLoadingMore.value = false;
    }
  }

  Future<void> cancelPurchaseReturn(String returnId) async {
    try {
      await _purchaseInvoiceRepository.cancelPurchaseReturn(returnId);
      // Refresh the list after successful cancellation
      await getPurchaseInvoice(resetList: true);
    } catch (e) {
      log("Error cancelling purchase return: $e");
      showErrorToast(
        message: 'Failed to cancel purchase return: ${e.toString()}',
      );
    }
  }

  Future<void> vendorLoadMoreItems() async {
    log("The query loadMore ${isLoadingMore.value} ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("The query calling more");
      await getPurchaseInvoice();
    }
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getPurchaseInvoice(resetList: true, isSearch: true);
    });
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
