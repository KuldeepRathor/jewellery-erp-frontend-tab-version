import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer_listing/model/counter_transfer_listing_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class CounterTransferListingController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final AggregateRepository aggregateRepository = AggregateRepository();

  final headers =
      ["Sn", "Transfer to", "Transfer By", "Date", "No of items", ""].obs;
  final columnWidths = [0.2, 2.1, 0.4, 0.4, 0.4, 0.1];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getCounterTransferListingResponse =
      Rx<ApiResponse<CounterTransferListingAggregateResponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  @override
  void onInit() {
    log("Counter Tranfer Listing");
    super.onInit();
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      cells.add(
        Row(
          children: [
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
    return TableRow(children: cells);
  }

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(
      getCounterTransferListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Edit", "Delete"];

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final counterDetail = getCounterTransferListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${counterDetail?.toJson()}");
    for (int i = 0; i < headers.length; i++) {
      String? cellContent = "-";
      switch (i) {
        case 0:
          cellContent = (index + 1).toString();
          break;
        case 1:
          cellContent = counterDetail?.counterToName ?? "-";
          break;
        case 2:
          cellContent = counterDetail?.employeeName ?? "-";
          break;
        case 3:
          cellContent =
              counterDetail?.date != null
                  ? "${counterDetail!.date!.toLocal().year}-${counterDetail.date!.toLocal().month.toString().padLeft(2, '0')}-${counterDetail.date!.toLocal().day.toString().padLeft(2, '0')}"
                  : "-";
          break;
        case 4:
          cellContent = counterDetail?.count.toString() ?? "-";
          break;
        case 5:
          return TableRow(
            children: [
              ...cells,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        CustomDashedLineWidget(
                                          width: Get.width,
                                        ),
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
                          case 'Delete':
                            showCancelConfirmationDialog(
                              counterDetail?.counterFrom ?? "",
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
            ],
          );
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

  Future<void> cancelOrder(String orderId) async {
    try {
      await inventoryRepository.cancelCounterTransfer(orderId);
      // Refresh the list after successful cancellation
      await getCounterTransferListingDetails(resetList: true);
      showSuccessToast(message: 'Order cancelled successfully');
    } catch (e) {
      log("Error cancelling order: $e");
      showErrorToast(message: 'Failed to cancel order: ${e.toString()}');
    }
  }

  void showCancelConfirmationDialog(String orderId) {
    Get.dialog(
      CancelPaymentDialog(
        subtitle: 'Are you sure you want to cancel this order?',
        onYesPressed: () async {
          await cancelOrder(orderId);
        },
      ),
    );
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> getCounterTransferListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getCounterTransferListingResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await aggregateRepository
          .getCounterTransferListingAggregate(
            offsetId: lastOffsetId,
            limit: itemsPerPage,
            query: searchQuery.value,
          );

      if (resetList) {
        getCounterTransferListingResponse.value = ApiResponse.completed(
          response,
        );
      } else {
        final currentData =
            getCounterTransferListingResponse.value.data?.values ?? [];
        List<CounterTransferListingAggregateValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getCounterTransferListingResponse.value = ApiResponse.completed(
          response,
        );
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value) {
        lastOffsetId = response.pagination?.next?.toString();
      }
    } catch (e) {
      getCounterTransferListingResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getCounterTransferListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getCounterTransferListingDetails();
    }
  }

  // void resetFields() {}
}
