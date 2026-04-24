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
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_listing/models/pagination_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class VendorListingViewmodel extends GetxController {
  final VendorRepository _vendorRepository = VendorRepository();
  final headers =
      [
        'Sn',
        'Name',
        'Code',
        "State",
        'GST',
        'Credit',
        'Debit',
        'Material In',
        'Material out',
        '',
      ].obs;
  final columnWidths =
      [0.1, 0.7, 0.38, 0.38, 0.42, 0.42, 0.42, 0.42, 0.42, 0.15].obs;
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
      getVendorListingDetailsResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Payment", "Return", "Edit", "Delete"];

  void editVendor(String vendorId) {
    Get.dialog(AddVendorDialog(vendorId: vendorId)).then((_) {
      // Reload the customer listing after the dialog is closed
      getVendorListingDetails(resetList: true);
    });
  }

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
    final headerValue = getVendorListingDetailsResponse.value.data?.values
        ?.elementAt(index);
    print("The value is : ${headerValue?.toJson()}");
    for (int i = 0; i < headers.length - 1; i++) {
      String header = headers.elementAt(i);
      switch (i) {
        case 0:
          header = "Sn";
          break;
        case 1:
          header = headerValue?.name ?? "-";
          break;
        case 2:
          header = headerValue?.code ?? "-";
          break;
        case 3:
          header =
              headerValue?.address?.isNotEmpty == true
                  ? (headerValue?.address?.first.state ?? "-")
                  : "-";
          break;
        case 4:
          header = headerValue?.gstNumber ?? "-";
          break;
        case 5:
          // header = headerValue?.credit.toString() ?? "-";
          header = "-";
          break;
        case 6:
          // header = headerValue?.debit.toString() ?? "-";
          header = "-";
          break;
        case 7:
          // header = headerValue?.materialIn.toString() ?? "-";
          header = "-";
          break;
        case 8:
          // header = headerValue?.materialOut.toString() ?? "-";
          header = "-";
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
                    // Handle payment action
                    AccountMapping ledgerDetails = headerValue!.ledger!;
                    onPaymentTapped(ledgerDetails);
                    break;
                  case 'Return':
                    // Handle return action
                    AccountMapping ledgerDetails = headerValue!.ledger!;
                    onReturnTapped(ledgerDetails);
                    break;
                  case 'Edit':
                    // Handle edit action
                    editVendor(headerValue?.id ?? "");

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

  final getVendorListingDetailsResponse =
      Rx<ApiResponse<PaginatedGetVendorListingDetailsResponse>>(
        ApiResponse.initial("Initial"),
      );

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

  Future<void> getVendorListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);

      getVendorListingDetailsResponse.value = ApiResponse.loading("loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      // await Future.delayed(
      // Durations.extralong4,
      // );
      final response = await _vendorRepository.getVendorListingDetails(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getVendorListingDetailsResponse.value = ApiResponse.completed(response);
      } else {
        final currentData =
            getVendorListingDetailsResponse.value.data?.values ?? [];

        List<GetVendorByIdResponse> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;

        getVendorListingDetailsResponse.value = ApiResponse.completed(response);
      }
      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        getVendorListingDetailsResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    print("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      print("Loading more called");
      await getVendorListingDetails();
    }
  }

  void setSeachQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      // Simulating API call

      getVendorListingDetails(resetList: true, isSearch: true);
    });
  }
}
