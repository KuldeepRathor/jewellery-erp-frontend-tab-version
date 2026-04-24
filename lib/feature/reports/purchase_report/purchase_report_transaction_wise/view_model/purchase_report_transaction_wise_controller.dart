// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_transaction_wise/model/get_purchase_report_transaction_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class PurchaseReportTransactionWiseController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Date",
        "Ornament Type",
        "Invoice No.",
        "Item Description",
        "Pcs",
        "Gr.wt",
        "Nt.wt",
        "Amount",
        "GST",
        "TDS/TCS",
        "Round Off",
        "Total",
        "Cash",
        "Debit Note",
        "Bank",
        "",
      ].obs;

  final columnWidths = [
    0.35, // Date
    0.45, // Ornament Type
    0.45, // Invoice No.
    0.5, // Item Description
    0.2, // Pcs
    0.35, // Gr.wt
    0.35, // Nt.wt
    0.35, // Amount
    0.35, // GST
    0.35, // TDS/TCS
    0.35, // Round Off
    0.35, // Total
    0.35, // Cash
    0.35, // Debit Note
    0.35, // Bank
    0.3, // Actions
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getPurchaseReportTransactionWiseResponse =
      Rx<ApiResponse<GetPurchaseReportTransactionWiseReponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  // Flattened list for easier table rendering
  final RxList<_FlattenedPurchaseData> flattenedData =
      <_FlattenedPurchaseData>[].obs;

  @override
  void onInit() {
    log("Purchase Report - Transaction Wise Listing");
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
    return List.generate(flattenedData.length, (index) => buildTableRow(index));
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
    final purchaseData = flattenedData.elementAt(index);

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0: // Date
          cellContent = convertDateTimeToString(purchaseData.value.createdAt);
          break;
        case 1: // Ornament Type
          cellContent = purchaseData.ornamentName ?? "-";
          break;
        case 2: // Invoice No.
          cellContent = purchaseData.value.invoinceNumber ?? "-";
          break;
        case 3: // Item Description
          cellContent = purchaseData.value.itemDescription ?? "-";
          break;
        case 4: // Pcs
          cellContent = purchaseData.value.pieces?.toString() ?? "-";
          break;
        case 5: // Gr.wt
          cellContent = purchaseData.value.grossWeight ?? "-";
          break;
        case 6: // Nt.wt
          cellContent = purchaseData.value.netWeight ?? "-";
          break;
        case 7: // Amount
          cellContent = purchaseData.value.amount ?? "-";
          break;
        case 8: // GST
          cellContent = purchaseData.value.gst ?? "-";
          break;
        case 9: // TDS/TCS
          cellContent = purchaseData.value.tdsTcs ?? "-";
          break;
        case 10: // Round Off
          cellContent = purchaseData.value.roundOff ?? "-";
          break;
        case 11: // Total
          cellContent = purchaseData.value.total ?? "-";
          break;
        case 12: // Cash
          cellContent = purchaseData.value.cash ?? "-";
          break;
        case 13: // Debit Note
          cellContent = purchaseData.value.debitNote?.toString() ?? "-";
          break;
        case 14: // Bank
          cellContent = purchaseData.value.bank ?? "-";
          break;
        case 15: // Actions
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

  // Helper method to flatten the nested structure
  void _flattenData(
    GetPurchaseReportTransactionWiseReponse response, {
    bool append = false,
  }) {
    List<_FlattenedPurchaseData> newFlattenedData = [];

    if (response.ornaments != null) {
      for (var ornament in response.ornaments!) {
        if (ornament.values != null) {
          for (var value in ornament.values!) {
            newFlattenedData.add(
              _FlattenedPurchaseData(
                ornamentId: ornament.ornamentId,
                ornamentName: ornament.ornamentName,
                value: value,
              ),
            );
          }
        }
      }
    }

    if (append) {
      flattenedData.addAll(newFlattenedData);
    } else {
      flattenedData.value = newFlattenedData;
    }
  }

  Future<void> getPurchaseReportTransactionWiseListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getPurchaseReportTransactionWiseResponse.value = ApiResponse.loading(
        "Loading",
      );
    } else {
      isLoadingMore.value = true;
    }
    try {
      final response = await estimationRepository
          .getPurchaseReportTransactionWiseListing(
            offsetId: lastOffsetId,
            limit: itemsPerPage,
            query: searchQuery.value,
          );

      if (resetList) {
        getPurchaseReportTransactionWiseResponse.value = ApiResponse.completed(
          response,
        );
        _flattenData(response, append: false);
      } else {
        final currentOrnaments =
            getPurchaseReportTransactionWiseResponse.value.data?.ornaments ??
            [];
        List<Ornament> newOrnaments = [
          ...currentOrnaments,
          ...response.ornaments ?? [],
        ];
        response.ornaments = newOrnaments;
        getPurchaseReportTransactionWiseResponse.value = ApiResponse.completed(
          response,
        );
        _flattenData(response, append: false);
      }

      // Update pagination logic - check if we got full page of results
      int totalValuesCount = 0;
      if (response.ornaments != null) {
        for (var ornament in response.ornaments!) {
          totalValuesCount += ornament.values?.length ?? 0;
        }
      }

      hasMorePages.value = totalValuesCount >= itemsPerPage;

      if (hasMorePages.value && response.ornaments?.isNotEmpty == true) {
        lastOffsetId =
            ((int.tryParse(lastOffsetId ?? '0') ?? 0) + 1).toString();
      }
    } catch (e) {
      getPurchaseReportTransactionWiseResponse.value = ApiResponse.error(
        e.toString(),
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getPurchaseReportTransactionWiseListingDetails(
        resetList: true,
        isSearch: true,
      );
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getPurchaseReportTransactionWiseListingDetails();
    }
  }

  void resetFields() {
    searchQuery.value = '';
    lastOffsetId = null;
    hasMorePages.value = true;
    flattenedData.clear();
  }

  // void getApprovalListingDetails({bool resetList = false}) {
  //   getSalesReportTransactionWiseListingDetails(resetList: resetList);
  // }
}

// Helper class to flatten the nested structure
class _FlattenedPurchaseData {
  final String? ornamentId;
  final String? ornamentName;
  final OrnamentValue value;

  _FlattenedPurchaseData({
    this.ornamentId,
    this.ornamentName,
    required this.value,
  });
}
