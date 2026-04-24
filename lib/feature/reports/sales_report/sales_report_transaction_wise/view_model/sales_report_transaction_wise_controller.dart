import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_transaction_wise/model/get_sales_report_transaction_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class SalesReportTransactionWiseController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Date",
        "Invoice No.",
        "Tag No.",
        "Ornamnet Type",
        "Item Description",
        "Pcs",
        "Gr.wt",
        "Nt.wt",
        "CGST",
        "SGST",
        "IGST",
        "Amount",
        "St.wt(cts)",
        "Stone Amount",
        "Total",
        "Old wt",
        "Old Amount",
        "Rcvd",
        "Cash",
        "Card",
        "UPI/IMPS",
        "NEFT/RTGS",
        "Cheque ",
        "Advance",
        "Credit Note",
        "Benefit/Discount",
        "Balance",
        "",
      ].obs;

  final columnWidths = [
    0.35,
    0.45,
    0.35,
    0.35,
    0.5,
    0.2,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
    0.35,
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Updated response type
  final getSalesReportTransactionWiseResponse =
      Rx<ApiResponse<GetSalesReportTransactionWiseReponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  @override
  void onInit() {
    log("Sales Report - Transaction Wise Listing");
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
      getSalesReportTransactionWiseResponse.value.data?.values?.length ?? 0,
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
    final salesReport = getSalesReportTransactionWiseResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${salesReport?.toJson()}");

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = convertDateTimeToString(salesReport?.createdAt);

          break;
        case 1:
          cellContent = salesReport?.invoinceNumber ?? "-";
          break;
        case 2:
          cellContent = "${salesReport?.code}-${salesReport?.tagNumber}";
          break;
        case 3:
          cellContent = salesReport?.ornamentName ?? "-";
          break;
        case 4:
          cellContent = salesReport?.description ?? "-";
          break;
        case 5:
          cellContent = salesReport?.pieces.toString() ?? "-";
          break;
        case 6:
          cellContent = salesReport?.grossWeight ?? "-";
          break;
        case 7:
          cellContent = salesReport?.netWeight ?? "-";
          break;
        case 8:
          cellContent = salesReport?.cgst ?? "-";
          break;
        case 9:
          cellContent = salesReport?.sgst ?? "-";
          break;
        case 10:
          cellContent = salesReport?.igst ?? "-";
          break;
        case 11:
          cellContent = salesReport?.amount ?? "-";
          break;
        case 12:
          cellContent = salesReport?.oldGoldWeight ?? "-";
          break;
        case 13:
          cellContent = salesReport?.stoneAmount ?? "-";
          break;
        case 14:
          cellContent = salesReport?.total ?? "-";
          break;
        case 15:
          cellContent = salesReport?.oldGoldWeight ?? "-";
          break;
        case 16:
          cellContent = salesReport?.oldGoldAmount ?? "-";
          break;

        case 17:
          cellContent = salesReport?.received ?? "-";
          break;
        case 18:
          cellContent = salesReport?.cash ?? "-";
          break;
        case 19:
          cellContent = salesReport?.cash ?? "-";
          break;
        case 20:
          cellContent = salesReport?.upiImps ?? "-";
          break;
        case 21:
          cellContent = salesReport?.neftRtgs ?? "-";
          break;
        case 22:
          cellContent = salesReport?.cheque ?? "-";
          break;
        case 23:
          cellContent = salesReport?.advance ?? "-";
          break;
        case 24:
          cellContent = salesReport?.creditNote ?? "-";
          break;
        case 25:
          cellContent = salesReport?.benefit ?? "-";
          break;
        case 26:
          cellContent = salesReport?.balance ?? "-";
          break;

        case 27:
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

  Future<void> getSalesReportTransactionWiseListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getSalesReportTransactionWiseResponse.value = ApiResponse.loading(
        "Loading",
      );
    } else {
      isLoadingMore.value = true;
    }
    try {
      // Create request object if needed
      // final filterRequest = GetCancelReportRequest(
      //   query: searchQuery.value,
      // );

      final response = await estimationRepository
          .getSalesReportTransactionWiseListing(
            offsetId: lastOffsetId,
            limit: itemsPerPage,
            query: searchQuery.value,
            // filterRequest: filterRequest,
          );

      if (resetList) {
        getSalesReportTransactionWiseResponse.value = ApiResponse.completed(
          response,
        );
      } else {
        final currentData =
            getSalesReportTransactionWiseResponse.value.data?.values ?? [];
        List<GetSalesReportTransactionWiseValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getSalesReportTransactionWiseResponse.value = ApiResponse.completed(
          response,
        );
      }

      // Update pagination logic based on your API response
      // Since GetSalesReportTransactionWiseReponse doesn't have pagination property,
      // you might need to adjust this based on your actual API response
      hasMorePages.value = (response.values?.length ?? 0) >= itemsPerPage;

      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        // Update this based on how your API handles pagination
        lastOffsetId =
            ((int.tryParse(lastOffsetId ?? '0') ?? 0) + 1).toString();
      }
    } catch (e) {
      getSalesReportTransactionWiseResponse.value = ApiResponse.error(
        e.toString(),
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getSalesReportTransactionWiseListingDetails(
        resetList: true,
        isSearch: true,
      );
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getSalesReportTransactionWiseListingDetails();
    }
  }

  void resetFields() {
    searchQuery.value = '';
    lastOffsetId = null;
    hasMorePages.value = true;
  }

  // Renamed method to match the new API
  void getApprovalListingDetails({bool resetList = false}) {
    getSalesReportTransactionWiseListingDetails(resetList: resetList);
  }
}
