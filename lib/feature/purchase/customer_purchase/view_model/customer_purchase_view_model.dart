import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/get_purchase_invoice_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/invoice_details.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/line_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_paginated_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/model/purchase_invoice_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view_model/customer_invoice_print.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:printing/printing.dart';

class CustomerPurchaseViewModel extends GetxController {
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final BaseFilterController filterController = Get.put(BaseFilterController());
  RxInt selectedTabIndex = 0.obs;
  PurchaseInvoiceListingRequest? currentRequest;
  int? _currentTabMetalType;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Common variables
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  List<String> popUpValues = ["Print", "Return", "Cancel"];

  // Customer-specific variables
  final customer_headers =
      [
        "Sn",
        "Date",
        "Invoice No.",
        "Customer Name",
        "Item Description",
        "Status",
        "Weight(gm)",
        "Amount",
        "Total(₹)",
        "",
      ].obs;

  // Update column widths to include Status
  final customer_column_widths =
      [
        0.1, // Sn
        0.4, // Date
        0.4, // Invoice No.
        0.5, // Customer Name
        0.9, // Item Description
        0.3, // Status
        0.3, // Weight
        0.3, // Amount
        0.275, // Total
        0.1, // Actions
      ].obs;
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return const Color(0xFF27AE60); // Green color for complete
      case "pending":
        return const Color(0xFFF2994A); // Orange color for pending
      case "cancelled":
        return const Color(0xFFEB5757); // Red color for cancelled
      case "in progress":
        return const Color(0xFF2F80ED); // Blue color for in progress
      case "draft":
        return const Color(0xFF828282); // Grey color for draft
      default:
        return Colors.black; // Default color
    }
  }

  final getCustomerInvoiceResponse =
      Rx<ApiResponse<PaginatedGetPurchaseListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  final getPurchaseInvoiceByIdResponse =
      Rx<ApiResponse<GetPurchaseInvoiceById>>(ApiResponse.initial("Initial"));

  @override
  void onInit() {
    super.onInit();
    log("Invoice viewmodel initiated");
    // getCustomerPurchaseInvoice(resetList: true, isSearch: false);
    // getCustomerPurchaseInvoice(
    //   resetList: true,
    // );
    filterController.resetAllFilters();

    filterController.fetchAllDropdownData(
      filterTypes: [
        // 'metalType',
        'dateRange',
        'transactionTypes',
        'paymentStatus',
        'invoiceStatus',
        'ornament',
      ],
    );
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
      sidebarController.navigateToWidget(newChild: InvoiceDetailsPage(id: id));
    }
  }

  void applyMetalTypeFilter(int metalType) {
    _currentTabMetalType = metalType; // store it
    final request = createRequestFormFilters(); // preserve other filters
    request.metalType = [metalType.toString()];
    currentRequest = request;
    getCustomerPurchaseInvoice(resetList: true, requestBody: request);
  }

  PurchaseInvoiceListingRequest createRequestFormFilters() {
    return PurchaseInvoiceListingRequest(
      // metalType: filterController.selectedMetalTypes.isNotEmpty
      //     ? filterController.selectedMetalTypes
      //         .where((item) => item.id != null)
      //         .map((item) => item.id!)
      //         .toList()
      //     : null,
      dateFrom: filterController.dateFrom.value,
      dateTo: filterController.dateTo.value,
      ornamentType:
          filterController.selectedOrnaments.isNotEmpty
              ? filterController.selectedOrnaments
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      paymentStatus: filterController.selectedPaymentStatus.value?.value,
      invoiceStatus: filterController.selectedInvoiceStatus.value?.value,
      transactionType: filterController.selectedTransactionTypes.value?.value,
    );
  }

  void applyFilters() {
    final requestBody = createRequestFormFilters();

    // Always override metalType with the active tab's metal type
    if (_currentTabMetalType != null) {
      requestBody.metalType = [_currentTabMetalType.toString()];
    }

    currentRequest = requestBody;
    getCustomerPurchaseInvoice(
      isSearch: false,
      resetList: true,
      requestBody: requestBody,
    );
  }

  // Vendor-specific methods
  // Common methods
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
                case 'Print':
                  if (vendorInvoice != null) {
                    printInvoice(vendorInvoice);
                  }

                  break;

                case 'Return':
                  // Handle Return
                  break;
                case 'Cancel':
                  // Handle Cancel
                  PermissionGuardUtil.withActionPermission(6054, () {
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

  Future<void> getPurchaseInvoiceById({required String id}) async {
    try {
      getPurchaseInvoiceByIdResponse.value = ApiResponse.loading("Loading");
      final response = await _aggregateRepository.getPurchaseInvoiceById(
        id: id,
      );
      getPurchaseInvoiceByIdResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getPurchaseInvoiceByIdResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }

  Future<void> printInvoice(PurchaseInvoiceModel invoice) async {
    try {
      // First fetch the detailed purchase invoice record
      await getPurchaseInvoiceById(id: invoice.id ?? "");

      if (getPurchaseInvoiceByIdResponse.value.status == Status.COMPLETED &&
          getPurchaseInvoiceByIdResponse.value.data != null) {
        // Use the detailed invoice data to generate the PDF
        final pdfBytes = await PurchaseInvoicePdfGenerator.generateInvoice(
          getPurchaseInvoiceByIdResponse.value.data!,
        );

        var availablePrinters = await Printing.listPrinters();
        for (var element in availablePrinters) {
          log("The available printers are ${element.url}");
        }

        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfBytes,
          name: 'invoice_${invoice.invoiceNumber}.pdf',
        );
      } else {
        showErrorToast(message: 'Failed to fetch purchase invoice details');
      }
    } catch (e) {
      log('Error generating PDF: $e');
      showErrorToast(message: 'Failed to generate invoice: ${e.toString()}');
    }
  }

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
              message: customerInvoice.invoiceNumber?.toString() ?? "-",
              child: Text(
                customerInvoice.invoiceNumber?.toString() ?? "-",
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
        case 5: // Status cell
          String cellValue = customerInvoice.status ?? "-";
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
          String cellValue = getCustomerCellValue(i, customerInvoice);
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

    customer_cells.add(_buildActionColumn(vendorInvoice: customerInvoice));

    return TableRow(children: customer_cells);
  }

  String getCustomerCellValue(int index, PurchaseInvoiceModel invoice) {
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
        return invoice.paymentDetails?.first.total ?? "-";
      default:
        return "-";
    }
  }
  // In your CustomerPurchaseListingViewModel

  Future<void> getCustomerPurchaseInvoice({
    bool resetList = false,
    bool isSearch = false,
    PurchaseInvoiceListingRequest? requestBody,
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
      final customerPurchaseController =
          requestBody ?? currentRequest ?? PurchaseInvoiceListingRequest();

      if (requestBody != null) {
        currentRequest = requestBody;
      }
      log("req: api call with offsetId: $lastOffsetId");
      final response = await _purchaseInvoiceRepository.getPurchaseInvoiceTwo(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId, // This should be null for first page
        partyType: PartyType.customer,
        requestBody: customerPurchaseController,
      );
      log("req: api call success ");

      if (resetList) {
        log("req: api call success reset ");
        getCustomerInvoiceResponse.value = ApiResponse.completed(response);
      } else {
        log("req: api call success add ");
        // Add to the end of the list
        final currentData = getCustomerInvoiceResponse.value.data?.values ?? [];
        List<PurchaseInvoiceModel> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getCustomerInvoiceResponse.value = ApiResponse.completed(response);
        log("req: api call success add success ");
      }

      // Update pagination state
      hasMorePages.value =
          response.pagination?.next != null &&
          response.pagination?.next?.isNotEmpty == true;
      log("req: hasMore: ${hasMorePages.value}");

      // Set the offset for next page
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.pagination?.next;
        log("req: next offsetId will be: $lastOffsetId");
      } else {
        lastOffsetId = null; // No more pages
      }

      log("req:completed}");
    } catch (e) {
      if (resetList) {
        getCustomerInvoiceResponse.value = ApiResponse.error(e.toString());
      }
      log("Error in getCustomerPurchaseInvoice: $e");
    } finally {
      log("req:completed finally");
      isLoadingMore.value = false;
    }
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null; // Make sure this is explicitly null
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
    log("Initial conditions set - lastOffsetId: $lastOffsetId");
  }

  // // Add this debug method to your CustomerPurchaseListingViewModel
  //   void debugPaginationState() {
  //     log("=== PAGINATION DEBUG INFO ===");
  //     log("lastOffsetId: $lastOffsetId");
  //     log("hasMorePages: ${hasMorePages.value}");
  //     log("isLoadingMore: ${isLoadingMore.value}");
  //     log("searchQuery: '${searchQuery.value}'");
  //     log("Current data length: ${getCustomerInvoiceResponse.value.data?.values?.length ?? 0}");
  //     log("API Response Status: ${getCustomerInvoiceResponse.value.status}");
  //     if (getCustomerInvoiceResponse.value.data?.pagination != null) {
  //       log("Pagination next: ${getCustomerInvoiceResponse.value.data?.pagination?.next}");
  //       log("Pagination totalCount: ${getCustomerInvoiceResponse.value.data?.pagination?.totalCount}");
  //     }
  //     log("==============================");
  //   }

  // // Call this method in your customerLoadMoreItems to debug
  Future<void> customerLoadMoreItems() async {
    // debugPaginationState(); // Add this line

    log("customerLoadMoreItems called");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Conditions met, calling getCustomerPurchaseInvoice");
      await getCustomerPurchaseInvoice(resetList: false);
    } else {
      log(
        "Conditions not met - isLoadingMore: ${isLoadingMore.value}, hasMorePages: ${hasMorePages.value}",
      );
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getCustomerPurchaseInvoice(resetList: true, isSearch: true);
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
      await getCustomerPurchaseInvoice(resetList: true);
    } catch (e) {
      log("Error cancelling purchase invoice: $e");
      showErrorToast(
        message: 'Failed to cancel purchase invoice: ${e.toString()}',
      );
    }
  }
}
