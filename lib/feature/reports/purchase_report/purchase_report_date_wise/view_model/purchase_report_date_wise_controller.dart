// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_date_wise/model/get_purchase_report_date_wise_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_date_wise/model/get_purchase_report_date_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class PurchaseReportDateWiseController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Date",
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
    0.35, // Date
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

  final getPurchaseReportDayWiseResponse =
      Rx<ApiResponse<GetPurchaseReportDateWiseReponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  // Flattened list for easier table rendering
  final RxList<_FlattenedDateWiseData> flattenedData =
      <_FlattenedDateWiseData>[].obs;

  final BaseFilterController filterController = Get.put(BaseFilterController());
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTimeRange? pickedDateRange;

  @override
  void onInit() {
    log("Purchase Report - Date Wise Listing");

    super.onInit();

    pickedDateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

    filterController.resetAllFilters();
    filterController.setDateRange(pickedDateRange!.start, pickedDateRange!.end);
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

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final purchaseData = flattenedData.elementAt(index);

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0: // Date
          cellContent = convertDateTimeToString(purchaseData.value.date);
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

  GetPurchaseReportDateWiseRequest createFilterRequest() {
    return GetPurchaseReportDateWiseRequest(
      dateFrom: filterController.dateFrom.value,
      dateTo: filterController.dateTo.value,
    );
  }

  // Helper method to flatten the nested structure
  void _flattenData(
    GetPurchaseReportDateWiseReponse response, {
    bool append = false,
  }) {
    List<_FlattenedDateWiseData> newFlattenedData = [];

    if (response.values != null) {
      for (var dateWiseValue in response.values!) {
        if (dateWiseValue.ornaments != null) {
          for (var ornament in dateWiseValue.ornaments!) {
            if (ornament.values != null) {
              for (var value in ornament.values!) {
                newFlattenedData.add(
                  _FlattenedDateWiseData(
                    groupDate: dateWiseValue.date,
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

  Future<void> getPurchaseReportDayWiseListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getPurchaseReportDayWiseResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      final filterRequest = createFilterRequest();

      final response = await estimationRepository
          .getPurchaseReportDateWiseListing(
            offsetId: lastOffsetId,
            limit: itemsPerPage,
            query: searchQuery.value,
            filterRequest: filterRequest,
          );

      if (resetList) {
        getPurchaseReportDayWiseResponse.value = ApiResponse.completed(
          response,
        );
        _flattenData(response, append: false);
      } else {
        final currentValues =
            getPurchaseReportDayWiseResponse.value.data?.values ?? [];
        List<GetPurchaseReportDateWiseReponseValue> newValues = [
          ...currentValues,
          ...response.values ?? [],
        ];
        response.values = newValues;
        getPurchaseReportDayWiseResponse.value = ApiResponse.completed(
          response,
        );
        _flattenData(response, append: false);
      }

      // Update pagination logic - count total flattened records
      int totalRecordsCount = 0;
      if (response.values != null) {
        for (var dateValue in response.values!) {
          if (dateValue.ornaments != null) {
            for (var ornament in dateValue.ornaments!) {
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
      getPurchaseReportDayWiseResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void applyFilters() {
    if (filterController.dateFrom.value != null &&
        filterController.dateTo.value != null) {
      pickedDateRange = DateTimeRange(
        start: filterController.dateFrom.value!,
        end: filterController.dateTo.value!,
      );
    }

    getPurchaseReportDayWiseListingDetails(resetList: true);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getPurchaseReportDayWiseListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getPurchaseReportDayWiseListingDetails();
    }
  }

  void resetFields() {
    searchQuery.value = '';
    lastOffsetId = null;
    hasMorePages.value = true;
    flattenedData.clear();
  }

  void getApprovalListingDetails({bool resetList = false}) {
    getPurchaseReportDayWiseListingDetails(resetList: resetList);
  }
}

// Helper class to flatten the nested date-wise structure
class _FlattenedDateWiseData {
  final DateTime?
  groupDate; // The date from GetPurchaseReportDateWiseReponseValue
  final String? ornamentId;
  final String? ornamentName;
  final OrnamentValue value;

  _FlattenedDateWiseData({
    this.groupDate,
    this.ornamentId,
    this.ornamentName,
    required this.value,
  });
}
