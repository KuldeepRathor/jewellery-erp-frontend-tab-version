import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/view_paymnets/view/view_paymnets_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/invoice_details.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_invoice_details_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_dashboard/vendor_ledger/model/vendor_ledger_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_dashboard/vendor_ledger/view_model/enums_for_ledger_type.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class VendorLedgerDashboardController extends GetxController {
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  // final InventoryRepository _inventoryRepository = InventoryRepository();
  final headers =
      [
        'Sr',
        "Date",
        'Inv. No.',
        'Item Description',
        'Type',
        'Weight(gm)',
        "SGST",
        "CGST",
        "IGST",
        "TDS",
        "TCS",
        "Dr",
        "Cr",
        "Balance",
        "",
      ].obs;

  final columnWidths =
      [
        0.1, // Sr
        0.33, // Date
        0.33, // Inv. No.
        0.5, // Item Description
        0.25, // Type
        0.25, // Weight(gm)
        0.25, // SGST
        0.25, // CGST
        0.25, // IGST
        0.25, // TDS
        0.25, // TCS
        0.25, // Dr
        0.25, // Cr
        0.25, // Balance
        0.1, // Empty column for actions
      ].obs;

  // ignore: unused_field
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final customerListingResponse = Rx<ApiResponse<VendorLedgerResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  final RxDouble totalDr = 0.0.obs;
  final RxDouble totalCr = 0.0.obs;

  // Add this method to calculate totals
  void calculateTotals() {
    double dr = 0.0;
    double cr = 0.0;

    final values = customerListingResponse.value.data?.values ?? [];
    for (var item in values) {
      dr += double.tryParse(item.dr ?? '0') ?? 0;
      cr += double.tryParse(item.cr ?? '0') ?? 0;
    }

    totalDr.value = dr;
    totalCr.value = cr;
  }

  @override
  void onInit() {
    super.onInit();

    fetchAllFilters();
  }

  void navigateToViewByType(VendorLedgerResponseValue record) {
    log(
      "Navigating to view for invoice: ${record.invoiceNumber}, type: ${record.type}",
    );

    SidebarController sidebarController = Get.find<SidebarController>();

    TransactionType type = TransactionTypeHelper.fromString(record.type);

    switch (type) {
      case TransactionType.purchase:
        // Navigate to purchase view
        sidebarController.navigateToWidget(
          newChild: InvoiceDetailsPage(id: record.id ?? ""),
        );
        log("Navigate to Purchase View: ${record.id}");
        break;
      case TransactionType.purchaseReturn:
        // Navigate to purchase return view
        sidebarController.navigateToWidget(
          newChild: PurchaseReturnInvoiceDetailsScreen(id: record.id ?? ""),
        );
        log("Navigate to Purchase Return View: ${record.id}");
        break;
      case TransactionType.sales:
        // Navigate to sales view
        // sidebarController.navigateToWidget(
        //   newChild: ViewSalesInvoicePage(id: record.id ?? ""),
        // );
        log("Navigate to Sales View: ${record.id}");
        break;
      case TransactionType.salesReturn:
        // Navigate to sales return view
        // sidebarController.navigateToWidget(
        //   newChild: ViewSalesReturnPage(id: record.id ?? ""),
        // );
        log("Navigate to Sales Return View: ${record.id}");
        break;
      case TransactionType.payment:
        // Navigate to payment view
        sidebarController.navigateToWidget(
          newChild: ViewPaymentsPage(id: record.id ?? ""),
        );
        log("Navigate to Payment View: ${record.id}");
        break;
      case TransactionType.receipt:
        // Navigate to receipt view
        // sidebarController.navigateToWidget(
        //   newChild: ViewReceiptPage(id: record.id ?? ""),
        // );
        log("Navigate to Receipt View: ${record.id}");
        break;
      case TransactionType.unknown:
        // For unknown types or if no type is specified
        log("No specific view for type: ${record.type}");
        break;
    }
  }

  Future<void> fetchAllFilters() async {
    try {
      // Fetch all filters concurrently
      await Future.wait([
        // getOrnamentsMetalTypes(),
        // getStockHeadsList(),
        // getCountersList(),
        // getDesignsList(),
      ]);
    } catch (e) {
      log('Error fetching filters: $e');
    }
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

  List<String> popUpValues = ["View"];
  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final customerDetail = customerListingResponse.value.data?.values
        ?.elementAt(index);

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
          cellContent = convertDateTimeToString(customerDetail?.invoiceDate);
          break;
        case 2:
          // Invoice Number column
          cellContent = customerDetail?.invoiceNumber ?? "-";
          // Make invoice number blue and underlined
          textColor = Colors.blue;
          textDecoration = TextDecoration.underline;
          // Make it clickable to view invoice details
          onTapFunction = () {
            log("View invoice details for: ${customerDetail?.invoiceNumber}");
            if (customerDetail != null) {
              navigateToViewByType(customerDetail);
            }
          };
          break;
        case 3:
          cellContent = customerDetail?.description ?? "-";
          break;
        case 4:
          cellContent = customerDetail?.type ?? "-";
          break;
        case 5:
          cellContent = customerDetail?.weight ?? "-";
          break;
        case 6:
          cellContent = customerDetail?.sgst ?? "-";
          break;
        case 7:
          cellContent = customerDetail?.cgst ?? "-";
          break;
        case 8:
          cellContent = customerDetail?.igst ?? "-";
          break;
        case 9:
          cellContent = customerDetail?.tds ?? "-";
          break;
        case 10:
          cellContent = customerDetail?.tcs ?? "-";
          break;
        case 11:
          cellContent = customerDetail?.dr ?? "-";
          break;
        case 12:
          cellContent = customerDetail?.cr ?? "-";
          break;
        case 13:
          cellContent = customerDetail?.balanceAmount ?? "-";
          break;
      }

      // Create the cell widget with proper structure
      Widget cellWidget;

      if (onTapFunction != null) {
        // For clickable cells (like invoice number)
        cellWidget = GestureDetector(
          onTap: onTapFunction,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
        );
      } else {
        // For non-clickable cells
        cellWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CustomText(
            text: cellContent,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            color: textColor,
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

    // Add the actions column
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
                              if (element != popUpValues.last)
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
                    if (customerDetail != null) {
                      navigateToViewByType(customerDetail);
                    }
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

  Future<void> getCustomerListingDetails({
    bool isSearch = false,
    required String vendorId,
  }) async {
    setInitialConditions(isSearch: isSearch);
    customerListingResponse.value = ApiResponse.loading("LOADING");
    totalDr.value = 0;
    totalCr.value = 0;
    try {
      final response = await _purchaseRepository
          .getVendorPurchaseAndReturnReport(vendorId: vendorId);

      customerListingResponse.value = ApiResponse.completed(response);
      calculateTotals();
      hasMorePages.value = false;
      lastOffsetId = null;
    } catch (e) {
      customerListingResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Future<void> loadMoreItems() async {
  //   log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
  //   if (!isLoadingMore.value && hasMorePages.value) {
  //     log("Loading more called");
  //     await getCustomerListingDetails();
  //   }
  // }

  // void setSearchQuery(String query) {
  //   searchQuery.value = query;
  //   log("Setting search query ${searchQuery.value}");
  //   _debouncer.run(() async {
  //     await getCustomerListingDetails(
  //       isSearch: true,
  //     );
  //   });
  // }

  // // For Stock Head Filter
  // final Rx<ApiResponse<List<DropdownItem>>> stockHeadResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final RxList<DropdownItem> stockHeads = <DropdownItem>[].obs;
  // final RxList<DropdownItem> selectedStockHeads = <DropdownItem>[].obs;

  // // For Counter Filter
  // final Rx<ApiResponse<List<DropdownItem>>> counterResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final RxList<DropdownItem> counters = <DropdownItem>[].obs;
  // final RxList<DropdownItem> selectedCounters = <DropdownItem>[].obs;

  // // For Design Filter
  // final Rx<ApiResponse<List<DropdownItem>>> designResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final RxList<DropdownItem> designs = <DropdownItem>[].obs;
  // final RxList<DropdownItem> selectedDesigns = <DropdownItem>[].obs;

  // // For Metal Filter
  // final Rx<ApiResponse<List<DropdownItem>>> metalTypeResponse =
  //     Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  // final RxList<DropdownItem> metalTypes = <DropdownItem>[].obs;
  // final RxList<DropdownItem> selectedMetalTypes = <DropdownItem>[].obs;

  // // Stock Head methods
  // Future<void> getStockHeadsList() async {
  //   try {
  //     stockHeadResponse.value = ApiResponse.loading("Loading");
  //     final response = await _inventoryRepository.getStockHeads(
  //       limit: 500,
  //       query: '',
  //     );
  //     stockHeads.value = response.values
  //             ?.map((item) => DropdownItem(id: item.id, name: item.name))
  //             .toList() ??
  //         [];
  //     stockHeadResponse.value = ApiResponse.completed(stockHeads);
  //   } catch (e) {
  //     stockHeadResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // void selectStockHead(DropdownItem item) {
  //   if (selectedStockHeads.contains(item)) {
  //     selectedStockHeads.remove(item);
  //   } else {
  //     selectedStockHeads.add(item);
  //   }
  // }

  // // Counter methods
  // Future<void> getCountersList() async {
  //   try {
  //     counterResponse.value = ApiResponse.loading("Loading");
  //     final response = await _inventoryRepository.getCounterListing(
  //       limit: 500,
  //       query: '',
  //     );
  //     counters.value = response.values
  //             ?.map((item) => DropdownItem(id: item.id, name: item.counterName))
  //             .toList() ??
  //         [];
  //     counterResponse.value = ApiResponse.completed(counters);
  //   } catch (e) {
  //     counterResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // void selectCounter(DropdownItem item) {
  //   if (selectedCounters.contains(item)) {
  //     selectedCounters.remove(item);
  //   } else {
  //     selectedCounters.add(item);
  //   }
  // }

  // // Design methods
  // Future<void> getDesignsList() async {
  //   try {
  //     designResponse.value = ApiResponse.loading("Loading");
  //     final response = await _inventoryRepository.getAllDesign();
  //     designs.value = response.values
  //             ?.map((item) => DropdownItem(id: item.id, name: item.name))
  //             .toList() ??
  //         [];
  //     designResponse.value = ApiResponse.completed(designs);
  //   } catch (e) {
  //     designResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // void selectDesign(DropdownItem item) {
  //   if (selectedDesigns.contains(item)) {
  //     selectedDesigns.remove(item);
  //   } else {
  //     selectedDesigns.add(item);
  //   }
  // }

  // // Metal methods
  // Future<void> getOrnamentsMetalTypes() async {
  //   try {
  //     metalTypeResponse.value = ApiResponse.loading("Loading");
  //     final response = await _inventoryRepository.getMetalTypes();
  //     metalTypes.value = response
  //         .map((item) => DropdownItem(id: item.id, name: item.typeName))
  //         .toList();
  //     metalTypeResponse.value = ApiResponse.completed(metalTypes);
  //   } catch (e) {
  //     metalTypeResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  // void selectMetalType(DropdownItem type) {
  //   if (selectedMetalTypes.contains(type)) {
  //     selectedMetalTypes.remove(type);
  //   } else {
  //     selectedMetalTypes.add(type);
  //   }
  // }
}
