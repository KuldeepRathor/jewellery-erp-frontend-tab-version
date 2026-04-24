import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/accounts_payments_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/view/accounts_receipts_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_by_id_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_dashboard/view/customer_dashboard_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_listing/model/customer_pagination_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_listing/repository/customer_listing_respository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class CustomerListingViewmodel extends GetxController {
  final CustomerListingRepository _customerListingRepository =
      CustomerListingRepository();
  final headers =
      [
        'Sr',
        "Customer ID",
        'Name',
        'Mobile',
        'Area',
        'KYC Status',
        "Tags",
        '',
      ].obs;
  final columnWidths = [0.1, 0.8, 0.48, 0.48, 0.48, 0.48, 0.2, 0.1].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final customerListingResponse =
      Rx<ApiResponse<PaginatedGetCustomerListingDetailsResponse>>(
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
    getCustomerListingDetails(resetList: true);
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

  List<String> popUpValues = ["Payment", "Return", "Edit", "Delete"];
  void editCustomer(String customerId) {
    Get.dialog(AddCustomerDialog(customerId: customerId)).then((_) {
      // Reload the customer listing after the dialog is closed
      getCustomerListingDetails(resetList: true);
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

  String getKycStatus(GetCustomerByIdResponse? customer) {
    if (customer == null) return "-";

    final isAadhaarVerified = customer.isAadhaarVerified ?? false;
    final isPanVerified = customer.isPanVerified ?? false;
    final isAadhaarOnlineVerified = customer.isAadhaarOnlineVerified ?? false;
    final isPanOnlineVerified = customer.isPanOnlineVerified ?? false;

    // Check Online verification first (higher priority)
    final hasOnlineAadhaar = isAadhaarOnlineVerified;
    final hasOnlinePan = isPanOnlineVerified;

    if (hasOnlineAadhaar && hasOnlinePan) {
      return "Online - Full";
    } else if (hasOnlineAadhaar || hasOnlinePan) {
      return "Online - Partial";
    }

    // Check Manual verification
    final hasManualAadhaar = isAadhaarVerified;
    final hasManualPan = isPanVerified;

    if (hasManualAadhaar && hasManualPan) {
      return "Manual - Full";
    } else if (hasManualAadhaar || hasManualPan) {
      return "Manual - Partial";
    }

    return "Pending";
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final customerDetail = customerListingResponse.value.data?.values
        ?.elementAt(index);
    Color textColor = Colors.black; // Default text color
    // log("The value is : ${customerDetail?.toJson()}");
    for (int i = 0; i < headers.length - 1; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = "${index + 1}";
          break;
        case 1:
          cellContent = customerDetail?.readableId ?? "-";
          break;
        case 2:
          cellContent = customerDetail?.name ?? "-";
          break;
        case 3:
          cellContent = customerDetail?.phoneNumber ?? "-";
          break;
        case 4:
          cellContent = customerDetail?.address?.firstOrNull?.state ?? "-";
          break;
        case 5:
          cellContent = getKycStatus(customerDetail);
          // Set color based on status
          if (cellContent.contains("Full")) {
            textColor = Colors.green;
          } else if (cellContent.contains("Partial")) {
            textColor = Colors.orange;
          } else {
            textColor = Colors.red; // Pending
          }
          break;
        case 6:
          cellContent =
              "-"; // You might want to update this if you have tags information
          break;
      }
      cells.add(
        InkWell(
          onTap: () {
            Get.to(
              () => CustomerDashboardView(customerId: customerDetail?.id ?? ""),
            );
          },
          child: Column(
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
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustomDashedLineWidget(width: Get.width),
            ],
          ),
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
                  case 'Payment':
                    AccountMapping ledgerDetails = customerDetail!.ledger!;
                    onPaymentTapped(ledgerDetails);
                    break;
                  case 'Return':
                    AccountMapping ledgerDetails = customerDetail!.ledger!;
                    onReturnTapped(ledgerDetails);
                    break;

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
      final response = await _customerListingRepository
          .getCustomerListingDetails(
            query: searchQuery.value,
            limit: itemsPerPage,
            offsetId: lastOffsetId,
          );

      if (resetList) {
        customerListingResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = customerListingResponse.value.data?.values ?? [];
        List<GetCustomerByIdResponse> newData = [
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
}
