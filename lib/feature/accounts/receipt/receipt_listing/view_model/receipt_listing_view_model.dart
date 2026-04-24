import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/receipt_listing/models/get_receipts_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/view_receipt/view/view_receipts_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class ReceiptListingViewModel extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final rbacController = Get.find<RBACController>();
  final headers =
      [
        'Sr',
        "Receipt No.",
        'Payment Date',
        'Customer',
        'Phone',
        'Invoice No.',
        'Amount',
        'Cash',
        'Card',
        'UPI/IMPS',
        'NEFT/RTGS',
        'Cheque',
        'Status',
        '',
      ].obs;
  final columnWidths =
      [
        0.2, //Sr
        0.6, // Payment no
        0.4, // date
        0.5, // Name
        0.4, // amount
        0.4, // amount
        0.4, // Remarks
        0.4,
        0.4,
        0.4,
        0.4,
        0.2,
        0.4,
        0.2, // Action
      ].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  SidebarController sidebarController = Get.find();
  final receiptListingResponse = Rx<ApiResponse<GetReceiptsPaginated>>(
    ApiResponse.initial("INITIAL"),
  );

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  @override
  void onInit() {
    super.onInit();
    log("Receipt Listing viewmodel initiated");
    getReceiptListingDetails(resetList: true);
  }

  @override
  void onClose() {
    log("Receipt Listing viewmodel Deleted");
    super.onClose();
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
      receiptListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["View", "Cancel", "Edit"];
  void editCustomer(String customerId) {
    Get.dialog(AddCustomerDialog(customerId: customerId)).then((_) {
      // Reload the customer listing after the dialog is closed
      getReceiptListingDetails(resetList: true);
    });
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final receiptDetail = receiptListingResponse.value.data?.values?.elementAt(
      index,
    );

    log("The value is : ${receiptDetail?.toJson()}");
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
          cellContent = receiptDetail?.paymentNumber ?? "-";
          textColor = Colors.blue;
          textDecoration = TextDecoration.underline;
          onTapFunction = () {
            log("View Payment details");
            sidebarController.navigateToWidget(
              newChild: ViewReceiptPage(
                id: receiptDetail?.paymentReceiptId ?? "",
              ),
            );
          };
          break;
        case 2:
          cellContent = convertDateTimeToString(receiptDetail?.date);
          break;
        case 3:
          cellContent = receiptDetail?.partyName ?? "-";
          break;
        case 4:
          cellContent = receiptDetail?.phoneNumber ?? "-";
        case 5:
          cellContent = receiptDetail?.againstInvoice ?? "-";
          break;
        case 6:
          cellContent = receiptDetail?.total ?? "-";
          break;
        case 7:
          cellContent = receiptDetail?.cash ?? "-";
          break;
        case 8:
          cellContent = receiptDetail?.card ?? "-";
          break;
        case 9:
          cellContent = receiptDetail?.upiImps ?? "-";
          break;
        case 10:
          cellContent = receiptDetail?.neftRtgs ?? "-";
          break;
        case 11:
          cellContent = receiptDetail?.cheque ?? "-";
          break;
        case 12:
          cellContent =
              receiptDetail?.isCancelled == true ? "Cancelled" : "Completed";
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
                    SidebarController sidebarController = Get.find();
                    sidebarController.navigateToWidget(
                      newChild: ViewReceiptPage(
                        id: receiptDetail?.paymentReceiptId ?? "",
                      ),
                    );
                    break;
                  case 'Cancel':
                    bool hasCancelPermssion = rbacController.hasAction(6054);
                    if (hasCancelPermssion) {
                      Get.dialog(
                        CancelPaymentDialog(
                          subtitle:
                              'Are you sure you want to cancel this payment receipt?',
                          onYesPressed: () async {
                            await cancelPaymentReceipt(receiptDetail!.id!);
                          },
                        ),
                      );
                    } else {
                      showErrorToast(
                        message:
                            "You do not have permission to cancel this payment receipt.",
                      );
                    }
                    break;
                  case 'Payment':
                    break;
                  case 'Return':
                    break;

                  case 'Edit':
                    // editCustomer(customerDetail?.id ?? "");
                    break;
                  case 'Delete':
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

  Future<void> getReceiptListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      receiptListingResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _aggregateRepository.getReceiptsPaginated(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId,
      );

      if (resetList) {
        receiptListingResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = receiptListingResponse.value.data?.values ?? [];
        List<GetReceiptsPaginatedValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        receiptListingResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next;
        }
      }
    } catch (e) {
      if (resetList) {
        receiptListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more called");
      await getReceiptListingDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getReceiptListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> cancelPaymentReceipt(String receiptId) async {
    try {
      await _aggregateRepository.cancelPaymentReceipt(receiptId);
      // Refresh the list after successful cancellation
      await getReceiptListingDetails(resetList: true);
    } catch (e) {
      log("Error cancelling payment receipt: $e");
      showErrorToast(
        message: 'Failed to cancel payment receipt: ${e.toString()}',
      );
    }
  }
}
