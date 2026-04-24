import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/issues_stock_listing/model/get_stock_issue_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/view/view_stock_issue_page.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class StockIssueController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Issue No",
        "Issue Date",
        "Tag No",
        "Barcode No",
        "Item Description",
        "Gross Weight",
        "Nett Weight",
        "Issued By",
        "Reason",
        // ""
      ].obs;
  final columnWidths = [
    0.4,
    0.4,
    0.3,
    0.4,
    0.6,
    0.3,
    0.3,
    0.4,
    0.4,
    // 0.1,
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getApprovalListingResponse =
      Rx<ApiResponse<GetStockIssueListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  SidebarController sidebarController = Get.find();

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  @override
  void onInit() {
    log("Approval Listing");
    // getMetalTypes();
    super.onInit();
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      // String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            // if (header != "Sn")
            //   const SizedBox(
            //     width: 4,
            //   ),
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
      getApprovalListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["View", "Cancel"];
  String formatDate(dynamic dateInput) {
    if (dateInput == null) return "-";

    DateTime? date;
    if (dateInput is DateTime) {
      date = dateInput;
    } else if (dateInput is String) {
      try {
        date = DateTime.parse(dateInput);
      } catch (e) {
        log('Error parsing date string: $e');
        return dateInput;
      }
    }

    if (date != null) {
      return DateFormat('yyyy-MM-dd').format(date);
    } else {
      return "-";
    }
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final approvalDetails = getApprovalListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${approvalDetails?.toJson()}");
    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      Color textColor = Colors.black;
      TextDecoration? textDecoration;
      VoidCallback? onTapFunction;
      switch (i) {
        case 0:
          cellContent = approvalDetails?.issueNo ?? "-";

          textColor = Colors.blue;
          textDecoration = TextDecoration.underline;
          onTapFunction = () {
            log("View material details");
            PermissionGuardUtil.withActionPermission(
              5151, // items > item_issue > view_issue
              () {
                sidebarController.navigateToWidget(
                  newChild: ViewStockIssuePage(
                    id: approvalDetails?.stockIssueRecordId ?? "",
                  ),
                );
              },
            );
          };
          break;
        case 1:
          cellContent = formatDate(approvalDetails?.issueDate);

          break;
        case 2:
          cellContent =
              "${approvalDetails?.tagCode} - ${approvalDetails?.tagNo}";
          break;
        case 3:
          cellContent = approvalDetails?.tagBarcode ?? "-";
          break;
        case 4:
          cellContent = approvalDetails?.itemDescription ?? "-";
          break;
        case 5:
          cellContent = approvalDetails?.grossWeight.toString() ?? "-";
          break;
        case 6:
          cellContent = approvalDetails?.netWeight.toString() ?? "-";
          break;
        case 7:
          cellContent = approvalDetails?.issuedByName ?? "-";
          break;
        case 8:
          cellContent = approvalDetails?.reason ?? "-";
          break;
      }
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
                    sidebarController.navigateToWidget(
                      newChild: ViewStockIssuePage(
                        id: approvalDetails?.stockIssueRecordId ?? "",
                      ),
                    );
                    break;
                  case 'Cancel':
                    Get.dialog(
                      CancelPaymentDialog(
                        subtitle:
                            'Are you sure you want to cancel this stock issue record?',
                        onYesPressed: () async {
                          await cancelStockIssueRecord(
                            approvalDetails!.id ?? "",
                          );
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
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> cancelStockIssueRecord(String recordId) async {
    try {
      await inventoryRepository.cancelStockIssueRecord(recordId);
      // Refresh the list after successful cancellation
      await getApprovalListingDetails(resetList: true);
    } catch (e) {
      log("Error cancelling stock issue record: $e");
      showErrorToast(
        message: 'Failed to cancel stock issue record: ${e.toString()}',
      );
    }
  }

  Future<void> getApprovalListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getApprovalListingResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      final response = await inventoryRepository.getStockIssueListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );
      if (resetList) {
        getApprovalListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getApprovalListingResponse.value.data?.values ?? [];
        List<StockIssueListingValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getApprovalListingResponse.value = ApiResponse.completed(response);
      }
      // hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      getApprovalListingResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getApprovalListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getApprovalListingDetails();
    }
  }

  void resetFields() {}
}
