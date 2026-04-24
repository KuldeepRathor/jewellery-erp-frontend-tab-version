import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_orders_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view/widgets/add_design_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view/widgets/assigned_to_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view/widgets/estimate_delivery_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view/widgets/status_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/view_order/view/view_order_page.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class OrderListingViewModel extends GetxController {
  final AggregateRepository _estimationRepository = AggregateRepository();
  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Common variables
  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  String? lastOffsetId;
  final itemsPerPage = 10;

  List<String> popUpValues = ["View", "Cancel"];
  final buy_headers =
      [
        "Date",
        "Customer Name",
        "Order No",
        "Item",
        "Weight",
        "Tag no",
        "Invoice no",
        "Design Details",
        "Status",
        "Est. Delivery",
        "Taken By",
        "Assigned To",
        "",
      ].obs;

  final buy_column_widths =
      [0.3, 0.5, 0.4, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.5, 0.4, 0.1].obs;

  final orderListingResponse = Rx<ApiResponse<GetOrdersListingResponse>>(
    ApiResponse.initial('Empty data'),
  );

  @override
  void onInit() {
    super.onInit();
    getOrdersListing(resetList: true, isSearch: false);
  }

  // String getStatusText(int? status) {
  //   switch (status) {
  //     case 0:
  //       return 'Unassigned';
  //     case 1:
  //       return 'Assigned';
  //     case 2:
  //       return 'Ready';
  //     default:
  //       return 'Unknown';
  //   }
  // }

  @override
  void onClose() {
    // log("Invoice viewmodel deleted");
    super.onClose();
  }

  void onInvoiceNoTapped(String? id) {
    if (id != null) {
      log('Invoice No. $id tapped');

      SidebarController sidebarController = Get.find();
      sidebarController.navigateToWidget(newChild: ViewOrderPage(id: id));
    }
  }

  Widget _buildActionColumn({required GetOrderListingValue? vendorInvoice}) {
    return Column(
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
            icon: const Icon(Icons.more_vert_outlined, size: 20),
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
                              element,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (element != "Cancel")
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
                case 'View':
                  SidebarController sidebarController = Get.find();
                  sidebarController.navigateToWidget(
                    newChild: ViewOrderPage(id: vendorInvoice?.id ?? ""),
                  );
                  break;
                case 'Cancel':
                  showCancelConfirmationDialog(vendorInvoice!.orderId!);
                  break;
              }
            },
          ),
        ),
        const SizedBox(height: 7),
        CustomDashedLineWidget(width: Get.width),
      ],
    );
  }

  TableRow buildVendorInvoiceTableHeaders() {
    return TableRow(
      children:
          buy_headers
              .map(
                (header) => Row(
                  children: [
                    if (header != "Sr") const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        header,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }

  List<TableRow> build_vendor_invoice_rows(BuildContext context) {
    final data = orderListingResponse.value.data?.values;
    if (data == null || data.isEmpty) {
      return [];
    }
    return List.generate(data.length, (index) => buildVendorTableRow(index));
  }

  TableRow buildVendorTableRow(int index) {
    List<Widget> vendor_cells = [];
    final vendorInvoice = orderListingResponse.value.data?.values?[index];

    // if (vendorInvoice == null) {
    //   return TableRow(
    //     children: List.generate(
    //       buy_headers.length,
    //       (index) => const SizedBox.shrink(),
    //     ),
    //   );
    // }

    for (var i = 0; i < buy_headers.length - 1; i++) {
      String cellContent = "-";
      switch (i) {
        case 0: // Serial number cell
          cellContent = convertDateTimeToString(
            (vendorInvoice?.createdAt ?? "-") as DateTime?,
          );
        case 1:
          cellContent = vendorInvoice?.customerName.toString() ?? "-";
          break;
        case 2:
          cellContent = vendorInvoice?.orderNumber.toString() ?? "-";
          break;
        case 3:
          cellContent = vendorInvoice?.itemDescription.toString() ?? "-";
          break;
        case 4:
          cellContent = vendorInvoice?.netWeight ?? "-";
          break;
        case 5:
          cellContent =
              "${vendorInvoice?.tagCode ?? ""} - ${vendorInvoice?.tagNumber ?? ""} ";
          break;
        case 6:
          cellContent = vendorInvoice?.saleNumber ?? "-";
          break;
        case 7:
          final design = vendorInvoice?.designImages.toString() ?? "-";
          vendor_cells.add(
            Column(
              children: [
                Row(
                  children: [
                    if (i != 0) const SizedBox(width: 4),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: InkWell(
                          onTap: () {
                            Get.dialog(
                              AddDesignDetailsDialog(
                                designId: vendorInvoice?.id.toString(),
                                orderDetails: vendorInvoice!,
                              ),
                            );
                          },
                          child: CustomText(
                            text: "View",
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color:
                                design != "-" ? secondaryColor : Colors.black,
                            decoration:
                                design != "-" ? TextDecoration.underline : null,
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
          continue;
        case 8:
          // cellContent = getStatusText(vendorInvoice?.status);
          final status = vendorInvoice?.status.toString() ?? "-";
          vendor_cells.add(
            Column(
              children: [
                Row(
                  children: [
                    if (i != 0) const SizedBox(width: 4),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: InkWell(
                          onTap: () {
                            Get.dialog(
                              StatusDialog(
                                orderId: vendorInvoice!.id.toString(),
                                status: vendorInvoice.status.toString(),
                              ),
                            );
                          },
                          child: Tooltip(
                            message: getStatusText(status),
                            child: CustomText(
                              text: status,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              color:
                                  status != "-" ? secondaryColor : Colors.black,
                              decoration:
                                  status != "-"
                                      ? TextDecoration.underline
                                      : null,
                            ),
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
          continue;
        case 9:
          final status = vendorInvoice?.estimatedDelivery ?? "ADD+";
          vendor_cells.add(
            Column(
              children: [
                Row(
                  children: [
                    if (i != 0) const SizedBox(width: 4),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: InkWell(
                          onTap: () {
                            Get.dialog(
                              EstimateDeliveryDialog(
                                orderId: vendorInvoice!.id.toString(),
                                estimateDate:
                                    vendorInvoice.estimatedDelivery.toString(),
                              ),
                            );
                          },
                          child: CustomText(
                            text: status,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color:
                                status != "-" ? secondaryColor : Colors.black,
                            decoration:
                                status != "-" ? TextDecoration.underline : null,
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
          continue;
        case 10:
          cellContent = vendorInvoice?.orderTakenByName ?? "-";
          break;

        case 11:
          final assignedUsers = vendorInvoice?.assignedUsers;
          final assignedUsersText =
              assignedUsers != null && assignedUsers.isNotEmpty
                  ? assignedUsers.map((user) => user.code).join(", ")
                  : "ADD+";

          vendor_cells.add(
            Column(
              children: [
                Row(
                  children: [
                    if (i != 0) const SizedBox(width: 4),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: InkWell(
                          onTap: () {
                            Get.dialog(
                              AssignedToDialog(orderDetails: vendorInvoice!),
                            );
                          },
                          child: Tooltip(
                            message: assignedUsersText,
                            child: CustomText(
                              text: assignedUsersText,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              color: secondaryColor,
                              decoration: TextDecoration.underline,
                            ),
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
          continue;
      }
      vendor_cells.add(
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

    vendor_cells.add(_buildActionColumn(vendorInvoice: vendorInvoice));

    return TableRow(children: vendor_cells);
  }

  String getStatusText(String? status) {
    if (status == null) return 'Unknown';
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _estimationRepository.cancelOrder(orderId);
      // Refresh the list after successful cancellation
      await getOrdersListing(resetList: true);
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

  Future<void> getOrdersListing({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      orderListingResponse.value = ApiResponse.loading("Loading");
      lastOffsetId = null;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _estimationRepository.getOrdersListing(
        query: searchQuery.value,
        offsetId: lastOffsetId,
        limit: itemsPerPage,
      );

      if (resetList) {
        orderListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = orderListingResponse.value.data?.values ?? [];
        final newData = response.values ?? [];

        final combinedData = [...currentData, ...newData];

        final updatedResponse = GetOrdersListingResponse(
          values: combinedData,
          pagination: response.pagination,
        );

        orderListingResponse.value = ApiResponse.completed(updatedResponse);
      }

      // Update lastOffsetId for pagination
      if (response.values?.isNotEmpty == true) {
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next;
        }
      }
    } catch (e) {
      if (resetList) {
        orderListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> vendorLoadMoreItems() async {
    log("The query loadMore ${isLoadingMore.value}");
    // if (!isLoadingMore.value && hasMorePages.value) {
    log("The query calling more");
    await getOrdersListing();
    // }
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      await getOrdersListing(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value &&
        orderListingResponse.value.data?.pagination?.next != null) {
      await getOrdersListing();
    }
  }
}
