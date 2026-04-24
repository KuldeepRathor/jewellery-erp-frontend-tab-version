import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/get_daily_rate_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/post_daily_rates_request.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class DailyRatesListingViewModel extends GetxController {
  // final CustomerListingRepository _customerListingRepository =
  //     CustomerListingRepository();
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final headers =
      [
        'Sr',
        "Date",
        'Time',
        'Gold 24k',
        'Gold 23k',
        'Gold 22k',
        'Gold 20k',
        'Gold 18k',
        'Gold 14k',
        'Gold 9k',
        'Silver',
        "Silver 999",
        "Silver 925",
        "Platinum",
        "Plain",
        '',
      ].obs;
  final columnWidths =
      [
        0.1,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.45,
        0.1,
      ].obs;

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final customerListingResponse =
      Rx<ApiResponse<GetPaginatedDailyRatesResponse>>(
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
    log("Customer Listing viewmodel initiated");
    getDailyRatesListingDetails(resetList: true);
  }

  @override
  void onClose() {
    log("Customer Listing viewmodel Deleted");
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
      customerListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Edit", "Delete"];
  void editCustomer(String customerId) {
    // Get.dialog(
    //   AddCustomerDialog(customerId: customerId),
    // ).then((_) {
    //   // Reload the customer listing after the dialog is closed
    //   getCustomerListingDetails(resetList: true);
    // });
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final customerDetail = customerListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${customerDetail?.toJson()}");
    for (int i = 0; i < headers.length - 1; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = "${index + 1}";
          break;
        case 1:
          // cellContent = customerDetail?.id ?? "-";
          cellContent = convertDateTimeToString(customerDetail?.date);
          break;
        case 2:
          cellContent = convertDateTimeToTimeString(customerDetail!.time);
          break;
        case 3:
          cellContent = "₹ ${customerDetail?.price24k ?? "-"}";
          break;
        case 4:
          cellContent = "₹ ${customerDetail?.price23k ?? "-"}";
          break;
        case 5:
          cellContent = "₹ ${customerDetail?.price22k ?? "-"}";
          break;
        case 6:
          cellContent = "₹ ${customerDetail?.price20k ?? "-"}";
          break;
        case 7:
          cellContent = "₹ ${customerDetail?.price18k ?? "-"}";
          break;
        case 8:
          cellContent = "₹ ${customerDetail?.price14k ?? "-"}";
          break;
        case 9:
          cellContent = "₹ ${customerDetail?.price9k ?? "-"}";
          break;
        case 10:
          cellContent = "₹ ${customerDetail?.priceSilver ?? "-"}";
          break;
        case 11:
          cellContent = "₹ ${customerDetail?.priceSilver999 ?? "-"}";
          break;
        case 12:
          cellContent = "₹ ${customerDetail?.priceSilver925 ?? "-"}";
          break;
        case 13:
          cellContent = "₹ ${customerDetail?.pricePlatinum ?? "-"}";
          break;
        case 14:
          cellContent = "₹ ${customerDetail?.pricePlain ?? "-"}";
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
                  case 'Edit':
                    editCustomer(customerDetail?.id ?? "");
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

  Future<void> getDailyRatesListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      customerListingResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _inventoryRepository.getPaginatedDailyRates(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId,
        startDate: dateFormat.format(pickedDateRange!.start),
        endDate: dateFormat.format(pickedDateRange!.end),
      );

      if (resetList) {
        customerListingResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = customerListingResponse.value.data?.values ?? [];
        List<DailyRateResponse> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        customerListingResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next;
        }
      }
    } catch (e) {
      if (resetList) {
        customerListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more called");
      await getDailyRatesListingDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getDailyRatesListingDetails(resetList: true, isSearch: true);
    });
  }

  final postDailyRatesResponse = Rx<ApiResponse<DailyRateResponse>>(
    ApiResponse.initial("INITIAL"),
  );
  Future<void> postDailyRates({required PostDailyRatesRequest request}) async {
    postDailyRatesResponse.value = ApiResponse.loading("LOADING");

    try {
      final response = await _inventoryRepository.addDailyRates(request);
      postDailyRatesResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Daily Rate updated Successfully !");
      GoldRateController goldRateController = Get.find<GoldRateController>();
      goldRateController.fetchGoldRates();
      getDailyRatesListingDetails(resetList: true);
      Get.back();
    } catch (e) {
      final handledResponse = handleDTOResponseErrors(e);
      postDailyRatesResponse.value = ApiResponse.error(handledResponse.message);
      showErrorToast(
        message: handledResponse.message ?? "Something went wrong ",
      );
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: pickedDateRange,
      builder: (context, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 5,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400.0,
              maxHeight: 500.0,
            ),
            child: child,
          ),
        );
      },
    );

    if (pickedDate != null) {
      pickedDateRange = pickedDate;
      // Fetch reports with new date range
      getDailyRatesListingDetails(resetList: true);
      update();
    }
  }

  DateTimeRange? pickedDateRange = DateTimeRange(
    start: DateTime.now().subtract(
      const Duration(days: 7),
    ), // Default to last 7 days
    end: DateTime.now(),
  );
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
}
