import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/design_view.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class PlatinumJewelleryTabViewModel extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Common variables
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  int? nextPage;

  List<String> popUpValues = ["Edit", "Deactivate"];

  // Customer-specific variables
  final platinum_jewellery_headers =
      [
        "Sr",
        "Code",
        "Design Name",
        'Metal/Services Type',
        "Stock Head",
        "925",
        "999",
        "Stone",
        "",
      ].obs;

  final platinum_jewellery_column_widths =
      [
        0.1,
        0.3 + 0.111,
        0.825 + 0.111,
        0.4 + 0.111,
        0.4 + 0.111,
        0.26 + 0.111,
        0.26 + 0.111,
        0.26 + 0.111,
        0.1,
      ].obs;

  final getCustomerInvoiceResponse =
      Rx<ApiResponse<PaginatedDesignListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  @override
  void onInit() {
    super.onInit();
    log("Invoice viewmodel initiated");
    // getCustomerPurchaseInvoice(resetList: true, isSearch: false);
    getPlatinumJewellery(resetList: true);
  }

  @override
  void onClose() {
    log("Invoice viewmodel deleted");
    super.onClose();
  }

  void onInvoiceNoTapped(String? id) {
    if (id != null) {
      log('Invoice No. $id tapped');
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: DesignView(id: id, designType: "Platinum"),
      );
    }
  }

  // Vendor-specific methods
  // Common methods
  Widget _buildActionColumn(String id) {
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
                case 'Edit':
                  // Handle Edit
                  onInvoiceNoTapped(id);
                  break;
                case 'Deactivate':
                  PermissionGuardUtil.withActionPermission(4254, () {
                    Get.dialog(
                      CancelPaymentDialog(
                        subtitle: 'Are you sure you want to delete design?',
                        onYesPressed: () async {
                          await cancelOrnament(id);
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

  Future<void> cancelOrnament(String invoiceId) async {
    try {
      await _inventoryRepository.deleteDesign(invoiceId);
      // Refresh the list after successful cancellation
      await getPlatinumJewellery();
    } catch (e) {
      log("Error deleting ornament: $e");
      showErrorToast(message: 'Failed to delete ornament: ${e.toString()}');
    }
  }

  // Customer-specific methods
  TableRow buildCustomerInvoiceTableHeaders() {
    List<Widget> customer_cells = [];

    for (int i = 0; i < platinum_jewellery_headers.length; i++) {
      String customer_header = platinum_jewellery_headers.elementAt(i);
      customer_cells.add(
        Row(
          children: [
            if (customer_header != "Sn") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: platinum_jewellery_headers.elementAt(i),
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
          platinum_jewellery_headers.length,
          (index) => Container(),
        ),
      );
    }

    for (int i = 0; i < platinum_jewellery_headers.length - 1; i++) {
      Widget cellWidget;
      switch (i) {
        case 0: // Serial number cell
          cellWidget = CustomText(
            text: (index + 1).toString(),
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
          );
          break;
        case 2: // Invoice No. cell
          cellWidget = GestureDetector(
            onTap: () => onInvoiceNoTapped(customerInvoice.id),
            child: Text(
              (customerInvoice.name ?? '-'),
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
          );
          break;
        case 7:
          cellWidget = CustomText(
            text: getStoneString(invoice: customerInvoice),
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            color:
                customerInvoice.stoneRequired ?? false
                    ? totalGreenColor
                    : redTextColor,
          );
          break;
        default:
          String cellValue = getCustomerCellValue(i, customerInvoice);
          cellWidget = CustomText(
            text: cellValue,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
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

    customer_cells.add(_buildActionColumn(customerInvoice.id ?? ""));

    return TableRow(children: customer_cells);
  }

  String getCustomerCellValue(int index, GetDesignResponseModel invoice) {
    switch (index) {
      case 0:
        return (index + 1).toString();
      case 1:
        return (invoice.code ?? "-");
      case 2:
        return invoice.name ?? "-";
      case 3:
        return (invoice.stockHead?.metalType?.typeName ?? "-");

      case 4:
        return (invoice.stockHead?.name ?? "-");
      case 5:
        return getWastageForPurity(design: invoice, purity: "925");
      case 6:
        return getWastageForPurity(design: invoice, purity: "silver_999");
      case 7:
        return getStoneString(invoice: invoice);
      default:
        return "-";
    }
  }

  Future<void> getPlatinumJewellery({
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
      final response = await _inventoryRepository.getPaginatedDesign(
        query: searchQuery.value,
        limit: itemsPerPage,
        nextPage: nextPage,
        metalType: "2",
      );
      log("req: api call success ");

      if (resetList) {
        log("req: api call success reset ");
        getCustomerInvoiceResponse.value = ApiResponse.completed(response);
      } else {
        log("req: api call success add ");
        // Add to the end of the list
        final currentData = getCustomerInvoiceResponse.value.data?.values ?? [];
        List<GetDesignResponseModel> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getCustomerInvoiceResponse.value = ApiResponse.completed(response);
        log("req: api call success add success ");
      }

      hasMorePages.value = response.pagination?.nextPage != null;
      log("req: hasMore: ${hasMorePages.value}");

      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        nextPage = response.pagination?.nextPage;
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

  Future<void> platinumLoadMoreItems() async {
    log("The query loadMore ${isLoadingMore.value} ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("The query calling more");
      await getPlatinumJewellery();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getPlatinumJewellery(resetList: true, isSearch: true);
    });
  }

  // Remaining common methods

  void setInitialConditions({required bool isSearch}) {
    nextPage = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  String getStoneString({required GetDesignResponseModel invoice}) {
    if (invoice.stoneRequired == true) {
      return "Yes";
    } else if (invoice.stoneRequired == false) {
      return "No";
    } else {
      return "-";
    }
  }

  String getWastageForPurity({
    required GetDesignResponseModel design,
    required String purity,
  }) {
    if (design.lineItems == null || design.lineItems!.isEmpty) {
      return "-";
    }

    List<LineItem> matchingItems =
        design.lineItems!.where((item) => item.purity == purity).toList();

    if (matchingItems.isEmpty) {
      return "-";
    }

    if (matchingItems.length == 1) {
      return matchingItems.first.wastage ?? "-";
    }

    return "View";
  }
}
