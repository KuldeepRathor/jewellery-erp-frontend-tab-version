// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/accounts_payments_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/view/accounts_receipts_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class EmployeeListingController extends GetxController {
  final OrganizationRepository _vendorRepository = OrganizationRepository();
  final headers = ['Sn', 'Employee ID', 'Name', 'Email', 'Phone', ''].obs;

  final columnWidths =
      [
        0.1, // Sn
        0.8, // Employee ID
        1.1, // Name
        1.1, // Email
        0.8, // Phone
        0.1, // Actions
      ].obs;

  final getEmployeeListingResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );
  final _debouncer = CustomDebouncer(milliseconds: 500);
  @override
  void onInit() {
    super.onInit();
    print("Vendor Listing viewmodel initiated");
  }

  @override
  void onClose() {
    print("Vendor Listing viewmodel Deleted");
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
            if (header != "Sn") const SizedBox(width: 4),
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

    return TableRow(
      // decoration: BoxDecoration(
      //   color: index.isEven ? Colors.grey[100] : Colors.white,
      // ),
      children: cells,
    );
  }

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(
      getEmployeeListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Payment", "Return", "Edit", "Delete"];

  // void editVendor(String vendorId) {
  //   Get.dialog(
  //     AddVendorDialog(vendorId: vendorId),
  //   ).then((_) {
  //     // Reload the customer listing after the dialog is closed
  //    getEmployeeListingResponse(resetList: true);
  //   });
  // }

  void onPaymentTapped(AccountMapping? ledgerDetails) {
    if (ledgerDetails != null) {
      log('Invoice No. $ledgerDetails tapped');

      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: const AccountsPaymentsPage(
          // ledgerDetails: ledgerDetails,
        ),
      );
    }
  }

  void onReturnTapped(AccountMapping? ledgerDetails) {
    if (ledgerDetails != null) {
      log('Invoice No. $ledgerDetails tapped');
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: const AccountsReceiptPage(
          // ledgerDetails: ledgerDetails,
        ),
      );
    }
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final headerValue = getEmployeeListingResponse.value.data?.values
        ?.elementAt(index);
    print("The value is : ${headerValue?.toJson()}");
    for (int i = 0; i < headers.length - 1; i++) {
      String header = headers.elementAt(i);
      switch (i) {
        case 0:
          header = "Sn";
          break;
        case 1:
          header = headerValue?.employeeId ?? "-";
          break;
        case 2:
          header = "${headerValue?.firstName} ${headerValue?.lastName}";
          break;
        case 3:
          header = headerValue?.email ?? "";
          break;
        case 4:
          header = headerValue?.phoneNumber ?? "-";
          break;

        default:
          header = "-";
          break;
      }
      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (header != "Sn") const SizedBox(width: 4),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Tooltip(
                      message: header,
                      child: CustomText(
                        text: header != "Sn" ? header : "${index + 1}",
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        // color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Text("-"),
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

                        // padding: EdgeInsets.all(0),
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
                // Handle the selected option
                switch (value) {
                  case 'Payment':
                    // // Handle payment action
                    // AccountMapping ledgerDetails = headerValue!.ledger!;
                    // onPaymentTapped(ledgerDetails);
                    break;
                  case 'Return':
                    // Handle return action
                    // AccountMapping ledgerDetails = headerValue!.ledger!;
                    // onReturnTapped(ledgerDetails);
                    break;
                  case 'Edit':
                    // Handle edit action
                    // editVendor(
                    //   headerValue?.id ?? "",
                    // );

                    break;
                  case 'Delete':
                    // Handle delete action
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

    return TableRow(
      // decoration: BoxDecoration(
      //   color: index.isEven ? Colors.grey[100] : Colors.white,
      // ),
      children: cells,
    );
  }

  // final getVendorListingDetailsResponse =
  //     Rx<ApiResponse<PaginatedGetVendorListingDetailsResponse>>(
  //         ApiResponse.initial("Initial"));

  final searchQuery = ''.obs;

  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  // Future<void> getVendorListingDetails({int page = 1, int limit = 3}) async {
  //   getVendorListingDetailsResponse.value = ApiResponse.loading("loading");
  //   try {
  //     await Future.delayed(
  //       Durations.extralong4,
  //     );
  //     final response = await _vendorListingRepository.getVendorListingDetails(
  //       page: page,
  //       limit: limit,
  //       search: searchQuery.value,
  //     );
  //     getVendorListingDetailsResponse.value = ApiResponse.completed(response);
  //   } catch (e, s) {
  //     log("Error getVendorListingDetails: $e : $s");
  //     getVendorListingDetailsResponse.value = ApiResponse.error(e.toString());
  //   }
  // }
  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getEmployeeListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getEmployeeListingResponse.value = ApiResponse.loading("loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _vendorRepository.getEmployees(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getEmployeeListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getEmployeeListingResponse.value.data?.values ?? [];
        List<GetEmployeesValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getEmployeeListingResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next;
        }
      }
    } catch (e) {
      if (resetList) {
        getEmployeeListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getEmployeeListingDetails();
    }
  }

  void setSeachQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getEmployeeListingDetails(resetList: true, isSearch: true);
    });
  }
}
