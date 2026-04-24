import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/add_advance_booking/view/add_advance_paymnet_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/booking_listing/model/get_booking_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/cancel_booking/view/cancel_booking_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/complete_booking/view/complete_booking.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class BookingListingViewModel extends GetxController {
  // final CustomerListingRepository _customerListingRepository =
  //     CustomerListingRepository();
  final JewelleryPlanRepository jewelleryPlanRepository =
      JewelleryPlanRepository();
  final headers =
      [
        'Booking ID',
        "Customer Name",
        'Phone',
        'Date',
        'Booking Rate/gm',
        'Weight',
        'Advance Paid (₹)',
        "Booking at",
        'Status',
        "",
      ].obs;
  final columnWidths = [0.3, 0.6, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.3, 0.1].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final customerListingResponse = Rx<ApiResponse<GetBookingListingResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final selectedStatus = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;

  @override
  void onInit() {
    super.onInit();
    log("Customer Listing viewmodel initiated");
    getCustomerListingDetails(resetList: true);
  }

  void setInitialConditions({required bool isSearch}) {
    currentPage.value = 1;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  @override
  void onClose() {
    log("Customer Listing viewmodel Deleted");
    super.onClose();
  }

  String convertDateTimeToString(DateTime? dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (dateTime == null) {
      return "-";
    }
    return formatter.format(dateTime);
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
      customerListingResponse.value.data?.results?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = [
    "Edit",
    "Complete",
    "Add Advance",
    "Cancel Booking",
    "Print",
  ];
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
    final customerDetail = customerListingResponse.value.data?.results
        ?.elementAt(index);

    log("The value is : ${customerDetail?.toJson()}");
    for (int i = 0; i < headers.length - 1; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = customerDetail?.bookingId ?? "-";
          break;
        case 1:
          cellContent = customerDetail?.customerName ?? "-";
          break;
        case 2:
          cellContent = customerDetail?.phone ?? "-";
          break;
        case 3:
          cellContent = convertDateTimeToString(customerDetail?.completedDate);
          break;
        case 4:
          cellContent = "${customerDetail?.rateValue ?? 0}";
          break;
        case 5:
          cellContent = "${customerDetail?.quantity ?? 0}";
          break;
        case 6:
          cellContent = "₹${customerDetail?.cost ?? 0}";
          break;
        case 7:
          cellContent =
              customerDetail?.isOnlineMode ?? false ? "App/Website" : "Store";
          break;
        case 8:
          cellContent = customerDetail?.status ?? "-";
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
                    child: CustomText(
                      text: cellContent,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
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
          const SizedBox(height: 8, width: 150),
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
                    break;
                  case 'Complete':
                    Get.dialog(
                      CompleteBookingDialog(
                        bookingId: customerDetail?.id.toString() ?? "",
                      ),
                    );
                    break;
                  case 'Add Advance':
                    Get.dialog(
                      AddAdvancePaymentDetailsDialog(
                        bookingId: customerDetail?.id.toString() ?? "",
                        totalAmount: customerDetail?.cost.toString() ?? "",
                      ),
                    );
                    break;
                  case 'Cancel Booking':
                    SidebarController sidebarController = Get.find();
                    sidebarController.navigateToWidget(
                      newChild: CancelBookingPage(
                        bookingId: customerDetail?.id.toString() ?? "",
                      ),
                    );
                    break;
                  case 'Print':
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

  Future<void> getCustomerListingDetails({
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
      final response = await jewelleryPlanRepository.getBookingListing(
        search: searchQuery.value,
        page: currentPage.value,
        status: selectedStatus.value,
      );

      if (resetList) {
        customerListingResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = customerListingResponse.value.data?.results ?? [];
        List<GetBookingListingValue> newData = [
          ...currentData,
          ...response.results ?? [],
        ];

        final updatedResponse = GetBookingListingResponse(
          count: response.count,
          next: response.next,
          previous: response.previous,
          results: newData,
        );

        customerListingResponse.value = ApiResponse.completed(updatedResponse);
      }

      hasMorePages.value = response.next != null;
      if (hasMorePages.value) {
        currentPage.value++;
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
      await getCustomerListingDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getCustomerListingDetails(resetList: true, isSearch: true);
    });
  }

  void setStatus(String status) {
    selectedStatus.value = status;
    getCustomerListingDetails(resetList: true);
  }
}
