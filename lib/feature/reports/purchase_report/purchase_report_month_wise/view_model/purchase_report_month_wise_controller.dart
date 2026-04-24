// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_month_wise/model/get_purchase_report_month_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class PurchaseReportMonthWiseController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Month/Year",
        "Ornament Type",
        "Nt.wt",
        "Gr.wt",
        "Gold Amount",
        "GST",
        "TDS/TCS",
        "Round Off",
        "Total",
        "Avg. Rate/Gm",
      ].obs;

  final columnWidths = [
    0.4, // Month/Year
    0.45, // Ornament Type
    0.35, // Nt.wt
    0.35, // Gr.wt
    0.4, // Gold Amount
    0.35, // GST
    0.35, // TDS/TCS
    0.35, // Round Off
    0.4, // Total
    0.4, // Avg. Rate/Gm
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getSalesReportMonthWiseResponse =
      Rx<ApiResponse<GetPurchaseReportMonthWiseReponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  // Flattened list for easier table rendering
  final RxList<_FlattenedMonthWiseData> flattenedData =
      <_FlattenedMonthWiseData>[].obs;

  @override
  void onInit() {
    log("Purchase Report - Month Wise Listing");
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

  String formatMonthYear(String? monthName, int? year) {
    if (monthName == null || year == null) return "-";
    return "$monthName $year";
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final purchaseData = flattenedData.elementAt(index);

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0: // Month/Year
          cellContent = formatMonthYear(
            purchaseData.value.monthName,
            purchaseData.value.year,
          );
          break;
        case 1: // Ornament Type
          cellContent = purchaseData.ornamentName ?? "-";
          break;
        case 2: // Nt.wt
          cellContent = purchaseData.value.netWeight ?? "-";
          break;
        case 3: // Gr.wt
          cellContent = purchaseData.value.grossWeight ?? "-";
          break;
        case 4: // Gold Amount
          cellContent = purchaseData.value.goldAmount ?? "-";
          break;
        case 5: // GST
          cellContent = purchaseData.value.gst ?? "-";
          break;
        case 6: // TDS/TCS
          cellContent = purchaseData.value.tdsTcs ?? "-";
          break;
        case 7: // Round Off
          cellContent = purchaseData.value.roundOff ?? "-";
          break;
        case 8: // Total
          cellContent = purchaseData.value.total ?? "-";
          break;
        case 9: // Avg. Rate/Gm
          cellContent = purchaseData.value.averageRate ?? "-";
          break;
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
    GetPurchaseReportMonthWiseReponse response, {
    bool append = false,
  }) {
    List<_FlattenedMonthWiseData> newFlattenedData = [];

    if (response.values != null) {
      for (var monthWiseValue in response.values!) {
        if (monthWiseValue.ornaments != null) {
          for (var ornament in monthWiseValue.ornaments!) {
            if (ornament.values != null) {
              for (var value in ornament.values!) {
                newFlattenedData.add(
                  _FlattenedMonthWiseData(
                    groupMonth: monthWiseValue.month,
                    groupYear: monthWiseValue.year,
                    groupMonthName: monthWiseValue.monthName,
                    ornamentId: ornament.ornamentId,
                    ornamentName: ornament.ornamentName,
                    value: value,
                  ),
                );
              }
            }
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

  Future<void> getPurchaseReportMonthWiseListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getSalesReportMonthWiseResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      final response = await estimationRepository
          .getPurchaseReportMonthWiseListing(
            offsetId: lastOffsetId,
            limit: itemsPerPage,
            query: searchQuery.value,
          );

      if (resetList) {
        getSalesReportMonthWiseResponse.value = ApiResponse.completed(response);
        _flattenData(response, append: false);
      } else {
        final currentValues =
            getSalesReportMonthWiseResponse.value.data?.values ?? [];
        List<GetPurchaseReportMonthWiseReponseValue> newValues = [
          ...currentValues,
          ...response.values ?? [],
        ];
        response.values = newValues;
        getSalesReportMonthWiseResponse.value = ApiResponse.completed(response);
        _flattenData(response, append: false);
      }

      // Update pagination logic - count total flattened records
      int totalRecordsCount = 0;
      if (response.values != null) {
        for (var monthValue in response.values!) {
          if (monthValue.ornaments != null) {
            for (var ornament in monthValue.ornaments!) {
              totalRecordsCount += ornament.values?.length ?? 0;
            }
          }
        }
      }

      hasMorePages.value = totalRecordsCount >= itemsPerPage;

      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId =
            ((int.tryParse(lastOffsetId ?? '0') ?? 0) + 1).toString();
      }
    } catch (e) {
      getSalesReportMonthWiseResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getPurchaseReportMonthWiseListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getPurchaseReportMonthWiseListingDetails();
    }
  }

  void resetFields() {
    searchQuery.value = '';
    lastOffsetId = null;
    hasMorePages.value = true;
    flattenedData.clear();
  }

  void getApprovalListingDetails({bool resetList = false}) {
    getPurchaseReportMonthWiseListingDetails(resetList: resetList);
  }
}

// Helper class to flatten the nested month-wise structure
class _FlattenedMonthWiseData {
  final int?
  groupMonth; // The month from GetPurchaseReportMonthWiseReponseValue
  final int? groupYear; // The year from GetPurchaseReportMonthWiseReponseValue
  final String?
  groupMonthName; // The month name from GetPurchaseReportMonthWiseReponseValue
  final String? ornamentId;
  final String? ornamentName;
  final OrnamentValue value;

  _FlattenedMonthWiseData({
    this.groupMonth,
    this.groupYear,
    this.groupMonthName,
    this.ornamentId,
    this.ornamentName,
    required this.value,
  });
}
