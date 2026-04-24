import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/invoice_details.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/line_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_paginated_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/model/purchase_invoice_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class VendorPurchaseListingViewmodel extends GetxController {
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();
  PurchaseInvoiceListingRequest? currentRequest;
  final _debouncer = CustomDebouncer(milliseconds: 500);
  final isTodayOnly = false.obs;

  // Common variables
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;
  List<String> popUpValues = ["Edit", "Return", "Cancel"];
  final vendor_headers =
      [
        "Sr",
        "Date",
        "Invoice No.",
        "Vendor Name",
        "Item Description",
        "Status",
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
        0.625,
        0.2,
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
    // getPurchaseInvoice(resetList: true, isSearch: false);
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
      sidebarController.navigateToWidget(newChild: InvoiceDetailsPage(id: id));
    }
  }

  Widget _buildActionColumn({required PurchaseInvoiceModel? vendorInvoice}) {
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
                            if (element != popUpValues.last)
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
                case 'Return':
                  // Handle Return
                  break;
                case 'Cancel':
                  // Handle Cancel
                  PermissionGuardUtil.withActionPermission(6105, () {
                    Get.dialog(
                      CancelPaymentDialog(
                        subtitle:
                            'Are you sure you want to cancel this purchase invoice?',
                        onYesPressed: () async {
                          await cancelPurchaseInvoice(vendorInvoice!.id!);
                        },
                      ),
                    );
                  });
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

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return greenColor; // Green color for complete
      case "pending":
        return tertiaryColor; // Orange color for pending
      case "cancelled":
        return redTextColor; // Red color for cancelled
      case "in progress":
        return const Color(0xFF2F80ED); // Blue color for in progress
      case "draft":
        return const Color(0xFF828282); // Grey color for draft
      default:
        return Colors.black; // Default color
    }
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
              message: getInvoiceNumber(vendorInvoice.invoiceNumber),
              child: Text(
                getInvoiceNumber(vendorInvoice.invoiceNumber),
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

        case 5:
          String cellValue = vendorInvoice.status ?? "-";
          cellWidget = Tooltip(
            message: cellValue,
            child: CustomText(
              text: cellValue,
              fontSize: 16,
              color: getStatusColor(cellValue),
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
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

    vendor_cells.add(_buildActionColumn(vendorInvoice: vendorInvoice));

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

  String getVendorCellValue(int index, PurchaseInvoiceModel invoice) {
    switch (index) {
      case 0:
        return (index + 1).toString();
      case 1:
        return convertDateTimeToString(invoice.invoiceCreateDate);
      case 3:
        return invoice.partyName ?? "-";
      case 4:
        return getLineItemNames(invoice.lineItems);
      case 5:
        return invoice.status ?? "-";
      case 6:
        return getLineItemsTotalWeight(invoice.lineItems);
      case 7:
        return getLineItemsTotalAmount(invoice.lineItems);
      case 8:
        return invoice.paymentDetails?.first.cgst ?? "-";
      case 9:
        return invoice.paymentDetails?.first.sgst ?? "-";
      case 10:
        return invoice.paymentDetails?.first.igst ?? "-";
      case 11:
        return invoice.paymentDetails?.first.tds ?? "-";
      case 12:
        return invoice.paymentDetails?.first.tcs ?? "-";
      case 13:
        return invoice.paymentDetails?.first.total ?? "-";
      case 14:
        return invoice.status ?? "-";
      default:
        return "-";
    }
  }

  final getPurchaseInvoiceResponse =
      Rx<ApiResponse<PaginatedGetPurchaseListingResponse>>(
        ApiResponse.initial('Empty data'),
      );

  Future<void> getPurchaseInvoice({
    bool resetList = false,
    bool isSearch = false,
    String? comingFrom,
    String? today_date,
    bool? isTodayOnly,
    PurchaseInvoiceListingRequest? requestBody,
  }) async {
    // If isTodayOnly is provided, use it to update the state
    if (isTodayOnly != null) {
      this.isTodayOnly.value = isTodayOnly;
    }

    log("Coming From $comingFrom, Today only: ${this.isTodayOnly.value}");

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
      // Generate today's date string if isTodayOnly is true
      final dateToUse =
          this.isTodayOnly.value
              ? DateTime.now().toIso8601String().split(
                'T',
              )[0] // Format as YYYY-MM-DD
              : today_date;

      final vendorPurchaseController =
          requestBody ?? currentRequest ?? PurchaseInvoiceListingRequest();

      if (requestBody != null) {
        currentRequest = requestBody;
      }

      final response = await _purchaseInvoiceRepository.getPurchaseInvoiceTwo(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId,
        partyType: PartyType.vendor,
        today_date: dateToUse,
        requestBody: vendorPurchaseController,
      );

      // Rest of the method remains the same...
      log("req: api call success ");

      if (resetList) {
        log("req: api call success reset ");
        getPurchaseInvoiceResponse.value = ApiResponse.completed(response);
      } else {
        log("req: api call success add ");
        // Add to the end of the list
        final currentData = getPurchaseInvoiceResponse.value.data?.values ?? [];
        List<PurchaseInvoiceModel> newData = [
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

  String getLineItemNames(List<LineItem>? lineItems) {
    if (lineItems == null || lineItems.isEmpty) {
      return '';
    }
    return lineItems
        .map((item) => item.itemDescription ?? '')
        .where((description) => description.isNotEmpty)
        .join(', ');
  }

  String getLineItemsTotalAmount(List<LineItem>? lineItems) {
    if (lineItems == null || lineItems.isEmpty) {
      return "-";
    }
    double total = lineItems
        .map((item) => double.tryParse(item.amount ?? '0') ?? 0)
        .fold(0, (sum, amount) => sum + amount);
    return total.toStringAsFixed(2);
  }

  String getLineItemsTotalWeight(List<LineItem>? lineItems) {
    if (lineItems == null || lineItems.isEmpty) {
      return "-";
    }
    double total = lineItems
        .map((item) => double.tryParse(item.netWeight ?? '0') ?? 0)
        .fold(0, (sum, amount) => sum + amount);
    return total.toStringAsFixed(2);
  }

  Future<void> cancelPurchaseInvoice(String invoiceId) async {
    try {
      await _purchaseInvoiceRepository.cancelPurchaseInvoice(invoiceId);
      // Refresh the list after successful cancellation
      await getPurchaseInvoice(resetList: true);
    } catch (e) {
      log("Error cancelling purchase invoice: $e");
      showErrorToast(
        message: 'Failed to cancel purchase invoice: ${e.toString()}',
      );
    }
  }
}
