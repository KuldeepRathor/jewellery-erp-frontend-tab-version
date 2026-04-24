import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/view/add_installment_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/cancel_plan/view/cancel_plan_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/customer_ledger_listing/model/get_jewellery_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/view_installment/view/view_installment.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class CustomerLedgerListingViewModel extends GetxController {
  // final CustomerListingRepository _customerListingRepository =
  //     CustomerListingRepository();
  final JewelleryPlanRepository _inventoryRepository =
      JewelleryPlanRepository();
  final headers =
      [
        'Plan ID',
        "Customer Name",
        'Phone',
        'Plan Type',
        'Plan Amount',
        'Duration',
        'Start Date',
        "Amount/Weight",
        'Status',
        "Installments",
        "",
      ].obs;
  final columnWidths =
      [0.3, 0.7, 0.3, 0.3, 0.3, 0.3, 0.3, 0.5, 0.3, 0.3, 0.1].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final jewelleryPlanResponse = Rx<ApiResponse<GetJewelleryPlanResponseModel>>(
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
      jewelleryPlanResponse.value.data?.results?.length ?? 0,
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
    final customerDetail = jewelleryPlanResponse.value.data?.results?.elementAt(
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
          cellContent = customerDetail?.customerName ?? "-";
          break;
        case 2:
          cellContent = customerDetail?.phone ?? "-";
          break;
        case 3:
          cellContent = customerDetail?.planType ?? "-";
          break;
        case 4:
          cellContent = customerDetail?.cost.toString() ?? "-";
          break;
        case 5:
          cellContent = customerDetail?.duration.toString() ?? "-";
          break;
        case 6:
          cellContent = customerDetail?.createdOn ?? "-";
          break;
        case 7:
          cellContent = customerDetail?.weightOrAmount ?? "-";
          break;
        case 8:
          cellContent = customerDetail?.status ?? "-";
          break;
        case 9:
          cellContent = customerDetail?.installments ?? "-";
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
                SidebarController sidebarController = Get.find();
                switch (value) {
                  case 'View Installment':
                    // SidebarController sidebarController = Get.find();
                    sidebarController.navigateToWidget(
                      newChild: ViewInstallment(
                        id: customerDetail?.id?.toString() ?? "",
                      ),
                    );
                    break;
                  case 'Add Installment':
                    sidebarController.navigateToWidget(
                      newChild: const AddInstallmentPage(),
                    );
                    break;

                  case 'Cancel Plan':
                    sidebarController.navigateToWidget(
                      newChild: const CancelPlanPage(),
                    );
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

      final response = await _inventoryRepository.getJewelleryPlans(
        page: currentPage.value,
        search: searchQuery.value,
        status: "",
        ordering: "-id",
      );

      if (resetList) {
        jewelleryPlanResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = jewelleryPlanResponse.value.data?.results ?? [];
        final newData = response.results ?? [];

        final combinedResponse = GetJewelleryPlanResponseModel(
          count: response.count,
          next: response.next,
          previous: response.previous,
          results: [...currentData, ...newData],
        );

        jewelleryPlanResponse.value = ApiResponse.completed(combinedResponse);
      }

      // Update pagination state
      hasMorePages.value = response.next != null;
      if (hasMorePages.value) {
        currentPage.value++;
      }
    } catch (e) {
      if (resetList) {
        jewelleryPlanResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more items - Page: ${currentPage.value}");
      await getJewelleryPlanDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      await getJewelleryPlanDetails(resetList: true, isSearch: true);
    });
  }
}
