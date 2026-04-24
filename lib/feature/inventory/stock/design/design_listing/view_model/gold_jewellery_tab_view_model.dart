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
import 'package:jewellery_erp_frontend_tab_version/utils/file_download_util.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class GoldJewelleryTabViewModel extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Common variables
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  int? nextPage;
  List<String> popUpValues = [
    // "Add Estimate",
    // "View Ledger",
    // "Print",
    "Edit",
    "Deactivate",
    // "Return",
    // "Cancel"
  ];
  final gold_jewellery_headers =
      [
        "Sr",
        "Code",
        "Design Name",
        'Metal/Services Type',
        "Stock Head",
        "22k-VA",
        "Plain-VA",
        "20k-VA",
        "18k-VA",
        "14k-VA",
        "Stone",
        "",
      ].obs;

  final gold_jewellery_column_widths =
      [0.1, 0.3, 0.825, 0.4, 0.4, 0.26, 0.26, 0.26, 0.26, 0.26, 0.26, 0.1].obs;
  @override
  void onInit() {
    super.onInit();
    log("Invoice viewmodel initiated");
    getGoldJewellery(resetList: true, isSearch: false);
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
        newChild: DesignView(id: id, designType: "Gold"),
      );
    }
  }

  Widget _buildActionColumn({String? id}) {
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
                          await cancelOrnament(id ?? "");
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
      await inventoryRepository.deleteDesign(invoiceId);
      // Refresh the list after successful cancellation
      await getGoldJewellery();
    } catch (e) {
      log("Error deleting ornament: $e");
      showErrorToast(message: 'Failed to delete ornament: ${e.toString()}');
    }
  }

  TableRow buildVendorInvoiceTableHeaders() {
    List<Widget> vendor_cells = [];

    for (int i = 0; i < gold_jewellery_headers.length; i++) {
      String vendor_header = gold_jewellery_headers.elementAt(i);
      vendor_cells.add(
        Row(
          children: [
            if (vendor_header != "Sr") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: gold_jewellery_headers.elementAt(i),
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
          gold_jewellery_headers.length,
          (index) => const SizedBox.shrink(),
        ),
      );
    }

    for (var i = 0; i < gold_jewellery_headers.length - 1; i++) {
      Widget cellWidget;
      switch (i) {
        case 0: // Serial number cell
          cellWidget = CustomText(
            text: (index + 1).toString(),
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            maxLines: 1,
          );
          break;
        case 2: // Invoice No. cell
          cellWidget = GestureDetector(
            onTap: () => onInvoiceNoTapped(vendorInvoice.id ?? "-"),
            child: Tooltip(
              message: vendorInvoice.name ?? "-",
              child: Text(
                (vendorInvoice.name ?? '-'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: secondaryColor,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
          break;
        case 9 || 8 || 7 || 6 || 5:
          String cellValue = getVendorCellValue(i, vendorInvoice);
          cellWidget = GestureDetector(
            onTap:
                () =>
                    cellValue == "View"
                        ? onInvoiceNoTapped(vendorInvoice.id)
                        : null,
            child: Tooltip(
              message: cellValue,
              child: CustomText(
                text: cellValue,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: cellValue == "View" ? secondaryColor : null,
                decoration:
                    cellValue == "View" ? TextDecoration.underline : null,
              ),
            ),
          );
          break;

        case 10:
          cellWidget = Tooltip(
            message: getStoneString(invoice: vendorInvoice),
            child: CustomText(
              text: getStoneString(invoice: vendorInvoice),
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              color:
                  vendorInvoice.stoneRequired ?? false
                      ? totalGreenColor
                      : redTextColor,
            ),
          );
          break;

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

    vendor_cells.add(_buildActionColumn(id: vendorInvoice.id ?? "-"));

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

  String getVendorCellValue(int index, GetDesignResponseModel invoice) {
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
        return getWastageForPurity(design: invoice, purity: "22k");
      case 6:
        return getWastageForPurity(design: invoice, purity: "plain");

      case 7:
        return getWastageForPurity(design: invoice, purity: "20k");

      case 8:
        return getWastageForPurity(design: invoice, purity: "18k");

      case 9:
        return getWastageForPurity(design: invoice, purity: "14k");

      case 10:
        return getStoneString(invoice: invoice);

      default:
        return "-";
    }
  }

  final getPurchaseInvoiceResponse =
      Rx<ApiResponse<PaginatedDesignListingResponse>>(
        ApiResponse.initial('Empty data'),
      );
  Future<void> getGoldJewellery({
    bool resetList = false,
    bool isSearch = false,
    String? comingFrom,
  }) async {
    log("Coming from jewe $comingFrom");
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
      final response = await inventoryRepository.getPaginatedDesign(
        query: searchQuery.value,
        limit: itemsPerPage,
        nextPage: nextPage,
        metalType: "1",
      );
      log("req: api call success ");

      if (resetList) {
        log("req: api call success reset ");
        getPurchaseInvoiceResponse.value = ApiResponse.completed(response);
      } else {
        log("req: api call success add ");
        // Add to the end of the list
        final currentData = getPurchaseInvoiceResponse.value.data?.values ?? [];
        List<GetDesignResponseModel> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getPurchaseInvoiceResponse.value = ApiResponse.completed(response);
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
        getPurchaseInvoiceResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      log("req:completed finally");
      isLoadingMore.value = false;
    }
  }

  Future<void> goldLoadMoreItems() async {
    log("The query loadMore ${isLoadingMore.value} ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("The query calling more");
      await getGoldJewellery();
    }
  }

  void setInitialConditions({required bool isSearch}) {
    nextPage = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getGoldJewellery(resetList: true, isSearch: true);
    });
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

  Future<void> downloadownloadAllDesignsCSVdReport() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await inventoryRepository.downloadAllDesignsCSV();

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'all_designs',
        fileExtension: 'csv',
      );

      if (success) {
        showSuccessToast(message: "Report downloaded successfully");
      } else {
        showErrorToast(message: "Download cancelled or failed");
      }
    } catch (e) {
      Get.back(); // Close loading dialog if error occurs
      showErrorToast(message: "Failed to download report: ${e.toString()}");
    }
  }
}
