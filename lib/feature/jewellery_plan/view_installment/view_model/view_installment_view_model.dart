import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/view_installment/model/get_view_installment_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class ViewInstallmentViewModel extends GetxController {
  // final CustomerListingRepository _customerListingRepository =
  //     CustomerListingRepository();
  final JewelleryPlanRepository _inventoryRepository =
      JewelleryPlanRepository();

  final String? id;
  ViewInstallmentViewModel({this.id});
  final headers =
      [
        'SN',
        "Installment Date",
        'Amount (₹)',
        'Rate/ (gm)',
        'N.Wt. (gm)',
        'Payment Mode',
        'Payment ID',
        "Transfer ID",
        'Settlement Date',
        // "Installments",
        "",
      ].obs;
  final columnWidths = [0.2, 0.6, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.1].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final jewelleryPlanResponse = Rx<ApiResponse<GetViewInstallmentResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final currentPage = 1.obs;
  final hasMorePages = true.obs;

  @override
  void onInit() {
    super.onInit();
    log("Customer Listing viewmodel initiated");
    getJewelleryPlanDetails(resetList: true);
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
      jewelleryPlanResponse.value.data?.emi?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = [
    'Add Installment',
    'View Installment',
    'Cancel Plan',
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
    final customerDetail = jewelleryPlanResponse.value.data?.emi?.elementAt(
      index,
    );

    log("The value is : ${customerDetail?.toJson()}");
    for (int i = 0; i < headers.length - 1; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          // cellContent = customerDetail?.id ?? "-";
          cellContent = customerDetail?.planId ?? "-";
          break;
        case 1:
          cellContent = customerDetail?.planDate ?? "-";
          break;
        case 2:
          cellContent = customerDetail?.amount ?? "-";
          break;
        case 3:
          cellContent = customerDetail?.rate.toString() ?? "-";
          break;
        case 4:
          cellContent = customerDetail?.accumulatedWeight ?? "-";
          break;
        case 5:
          cellContent = customerDetail?.paymentMode.toString() ?? "-";
          break;
        case 6:
          cellContent = customerDetail?.paymentId ?? "-";
          break;
        case 7:
          cellContent = customerDetail?.orderId.toString() ?? "-";
          break;
        case 8:
          cellContent = customerDetail?.settlementDate ?? "-";
          break;
        // case 9:
        //   cellContent = customerDetail?.installments ?? "-";
        //   break;
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
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                element,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (element != "Cancel Plan")
                                CustomDashedLineWidget(width: Get.width),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
              onSelected: (String value) {
                switch (value) {
                  case 'View Installment':
                    // SidebarController sidebarController = Get.find();
                    // sidebarController.navigateToWidget(
                    //     newChild: const ViewInstallment());
                    break;
                  case 'Add Installment':
                    break;

                  case 'Cancel Plan':
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
    currentPage.value = 1;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> getJewelleryPlanDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    try {
      if (resetList) {
        setInitialConditions(isSearch: isSearch);
        jewelleryPlanResponse.value = ApiResponse.loading("LOADING");
      } else {
        if (!hasMorePages.value) return;
        isLoadingMore.value = true;
      }

      if (id == null) {
        throw Exception("Plan ID is required");
      }

      final response = await _inventoryRepository.getViewInstallment(id!);
      jewelleryPlanResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log("Error fetching installment details: $e");
      if (resetList) {
        jewelleryPlanResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      await getJewelleryPlanDetails(resetList: true, isSearch: true);
    });
  }
}
