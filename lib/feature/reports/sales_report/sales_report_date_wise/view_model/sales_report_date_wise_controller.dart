import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_date_wise/model/get_sales_report_date_wise_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_date_wise/model/get_sales_report_date_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class SalesReportDateWiseController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Date",
        "Nt.wt",
        "Gold Amount",
        "St.wt(cts)",
        "Stone Amount",
        "GST",
        "TDS/TCS",
        "Total",
        "Avg. Rate/Gm",
        "",
      ].obs;

  final columnWidths = [0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Updated response type
  final getSalesReportDayWiseResponse =
      Rx<ApiResponse<GetSalesReportDateWiseReponse>>(
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

    pickedDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    ); // Initialize filter controller
    filterController.resetAllFilters();

    // Set initial date range in filter controller
    filterController.setDateRange(pickedDateRange!.start, pickedDateRange!.end);
  }

  final BaseFilterController filterController = Get.put(BaseFilterController());
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTimeRange? pickedDateRange;

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
      getSalesReportDayWiseResponse.value.data?.values?.length ?? 0,
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
    final salesReport = getSalesReportDayWiseResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${salesReport?.toJson()}");

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = convertDateTimeToString(salesReport?.date);

          break;
        case 1:
          cellContent = salesReport?.netWeight ?? "-";
          break;
        case 2:
          cellContent = salesReport?.goldAmount ?? "-";
          break;
        case 3:
          cellContent = salesReport?.stoneWeightCarats ?? "-";
          break;
        case 4:
          cellContent = salesReport?.stoneAmount ?? "-";
          break;
        case 5:
          cellContent = salesReport?.gst ?? "-";
          break;
        case 6:
          cellContent = salesReport?.tdsTcs ?? "-";
          break;
        case 7:
          cellContent = salesReport?.total ?? "-";
          break;
        case 8:
          cellContent = salesReport?.averageRate ?? "-";
          break;

        //   case 9:
        //     return TableRow(
        //       children: [
        //         ...cells,
        //         Column(
        //           children: [
        //             const SizedBox(height: 8),
        //             Theme(
        //               data: ThemeData(
        //                 focusColor: greyTextColor,
        //                 tooltipTheme: const TooltipThemeData(
        //                   decoration: BoxDecoration(color: Colors.transparent),
        //                 ),
        //               ),
        //               child: CustomPopupMenuButtonWidget<String>(
        //                 icon: const Icon(Icons.more_vert),
        //                 itemBuilder: (BuildContext context) =>
        //                     <PopupMenuEntry<String>>[
        //                   ...popUpValues.map((element) {
        //                     return PopupMenuItem<String>(
        //                       value: element,
        //                       height: 0,
        //                       child: SizedBox(
        //                         width: 120,
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             const SizedBox(height: 8),
        //                             Text(
        //                               maxLines: 1,
        //                               overflow: TextOverflow.ellipsis,
        //                               element,
        //                               style: const TextStyle(
        //                                 fontSize: 16,
        //                                 fontWeight: FontWeight.w500,
        //                               ),
        //                             ),
        //                             const SizedBox(height: 8),
        //                             if (element != popUpValues.last)
        //                               CustomDashedLineWidget(width: Get.width)
        //                           ],
        //                         ),
        //                       ),
        //                     );
        //                   })
        //                 ],
        //                 onSelected: (String value) {
        //                   switch (value) {
        //                     case 'View Details':
        //                       // Handle view details
        //                       break;
        //                     case 'Print':
        //                       // Handle print
        //                       break;
        //                     case 'Refund Status':
        //                       // Handle refund status
        //                       break;
        //                   }
        //                 },
        //               ),
        //             ),
        //             const SizedBox(height: 7),
        //             CustomDashedLineWidget(width: Get.width)
        //           ],
        //         ),
        //       ],
        //     );
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

  GetSalesReportDateWiseRequest createFilterRequest() {
    return GetSalesReportDateWiseRequest(
      dateFrom: filterController.dateFrom.value,
      dateTo: filterController.dateTo.value,
    );
  }

  Future<void> getSalesReportDayWiseListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getSalesReportDayWiseResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      // Create request object if needed
      final filterRequest = createFilterRequest();

      final response = await estimationRepository.getSalesReportDateWiseListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
        filterRequest: filterRequest,
      );

      if (resetList) {
        getSalesReportDayWiseResponse.value = ApiResponse.completed(response);
      } else {
        final currentData =
            getSalesReportDayWiseResponse.value.data?.values ?? [];
        List<GetSalesReportDateWiseValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getSalesReportDayWiseResponse.value = ApiResponse.completed(response);
      }

      // Update pagination logic based on your API response
      // Since GetSalesReportDateWiseReponse doesn't have pagination property,
      // you might need to adjust this based on your actual API response
      hasMorePages.value = (response.values?.length ?? 0) >= itemsPerPage;

      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        // Update this based on how your API handles pagination
        lastOffsetId =
            ((int.tryParse(lastOffsetId ?? '0') ?? 0) + 1).toString();
      }
    } catch (e) {
      getSalesReportDayWiseResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void applyFilters() {
    // Update date range from filter controller
    if (filterController.dateFrom.value != null &&
        filterController.dateTo.value != null) {
      pickedDateRange = DateTimeRange(
        start: filterController.dateFrom.value!,
        end: filterController.dateTo.value!,
      );
    }

    // Refresh the report with new filters
    getSalesReportDayWiseListingDetails(resetList: true);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getSalesReportDayWiseListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getSalesReportDayWiseListingDetails();
    }
  }

  void resetFields() {
    searchQuery.value = '';
    lastOffsetId = null;
    hasMorePages.value = true;
  }

  // Renamed method to match the new API
  void getApprovalListingDetails({bool resetList = false}) {
    getSalesReportDayWiseListingDetails(resetList: resetList);
  }
}
