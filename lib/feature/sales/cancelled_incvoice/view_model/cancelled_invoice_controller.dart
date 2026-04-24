import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/cancelled_incvoice/model/get_cancelled_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/cancelled_incvoice/model/get_cancelled_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class CancelledInvoiceController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Voucher Number",
        "Record Type",
        "Customer Name",
        "Customer Phone",
        "Cancelled Date",
        "Created Date",
        "Cancellation Number",
        "Refund Amount",
        "Refund Mode",
        "Refund Account",
        "",
      ].obs;

  final columnWidths = [
    0.35,
    0.30,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.30,
    0.30,
    0.35,
    0.1,
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Updated response type
  final getCancelReportResponse = Rx<ApiResponse<GetCancelReportResponse>>(
    ApiResponse.initial("Initial"),
  );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  @override
  void onInit() {
    log("Cancelled Invoice Listing");
    super.onInit();
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      cells.add(
        Row(
          children: [
            Flexible(
              child: Tooltip(
                message: headers.elementAt(i),
                child: CustomText(
                  text: headers.elementAt(i),
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
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
      getCancelReportResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["View Details", "Print", "Refund Status"];

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
      return DateFormat('dd-MM-yyyy').format(date);
    } else {
      return "-";
    }
  }

  String formatCurrency(dynamic amount) {
    if (amount == null) return "-";

    try {
      double value =
          amount is String ? double.parse(amount) : amount.toDouble();
      return NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(value);
    } catch (e) {
      return amount.toString();
    }
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final cancelledInvoice = getCancelReportResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${cancelledInvoice?.toJson()}");

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = cancelledInvoice?.voucherNumber ?? "-";
          break;
        case 1:
          cellContent = cancelledInvoice?.recordType ?? "-";
          break;
        case 2:
          cellContent = cancelledInvoice?.partyName?.toString() ?? "-";
          break;
        case 3:
          cellContent = cancelledInvoice?.partyPhone?.toString() ?? "-";
          break;
        case 4:
          cellContent = formatDate(cancelledInvoice?.cancelledAt);
          break;
        case 5:
          cellContent = formatDate(cancelledInvoice?.createdAt);
          break;
        case 6:
          cellContent = cancelledInvoice?.cancellationNumber?.toString() ?? "-";
          break;
        case 7:
          cellContent = formatCurrency(cancelledInvoice?.refundAmount);
          break;
        case 8:
          cellContent = cancelledInvoice?.refundMode?.toString() ?? "-";
          break;
        case 9:
          cellContent = cancelledInvoice?.refundAccount?.toString() ?? "-";
          break;
        case 10:
          return TableRow(
            children: [
              ...cells,
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
                                  width: 120,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        CustomDashedLineWidget(
                                          width: Get.width,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'View Details':
                            // Handle view details
                            break;
                          case 'Print':
                            // Handle print
                            break;
                          case 'Refund Status':
                            // Handle refund status
                            break;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 7),
                  CustomDashedLineWidget(width: Get.width),
                ],
              ),
            ],
          );
      }
      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (i != 0) const SizedBox(width: 4),
                Flexible(
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
                      ),
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

    return TableRow(children: cells);
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> getCancelledInvoiceListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getCancelReportResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      // Create request object if needed
      final filterRequest = GetCancelReportRequest(query: searchQuery.value);

      final response = await inventoryRepository.getCancelledInvoiceListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
        filterRequest: filterRequest,
      );

      if (resetList) {
        getCancelReportResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getCancelReportResponse.value.data?.values ?? [];
        List<GetCancelReportValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getCancelReportResponse.value = ApiResponse.completed(response);
      }

      // Update pagination logic based on your API response
      // Since GetCancelReportResponse doesn't have pagination property,
      // you might need to adjust this based on your actual API response
      hasMorePages.value = (response.values?.length ?? 0) >= itemsPerPage;

      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        // Update this based on how your API handles pagination
        lastOffsetId =
            ((int.tryParse(lastOffsetId ?? '0') ?? 0) + 1).toString();
      }
    } catch (e) {
      getCancelReportResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getCancelledInvoiceListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getCancelledInvoiceListingDetails();
    }
  }

  void resetFields() {
    searchQuery.value = '';
    lastOffsetId = null;
    hasMorePages.value = true;
  }

  // Renamed method to match the new API
  void getApprovalListingDetails({bool resetList = false}) {
    getCancelledInvoiceListingDetails(resetList: resetList);
  }
}
