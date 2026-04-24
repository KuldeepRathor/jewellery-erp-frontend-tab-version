import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_invoice_details_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/get_repairs_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view/widgets/add_design_repair_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view/widgets/assigned_to_repair_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view/widgets/estimate_delivery_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view/widgets/repair_status_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/view/view_repair_page.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class RepairListingViewmodel extends GetxController {
  final AggregateRepository aggregrateRepository = AggregateRepository();

  final EstimationRepository estimationRepository = EstimationRepository();
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

  final repairListingResponse = Rx<ApiResponse<GetRepairsListingResponse>>(
    ApiResponse.initial('Empty data'),
  );

  @override
  void onInit() {
    super.onInit();
    getRepairsListing(resetList: true, isSearch: false);
  }

  @override
  void onClose() {
    // log("Invoice viewmodel deleted");
    super.onClose();
  }

  void onInvoiceNoTapped(String? id) {
    if (id != null) {
      log('Invoice No. $id tapped');
      // Get.to(() => SidebarLayoutWidget(
      //       child: InvoiceDetailsPage(
      //         id: id,
      //       ),
      //     ));
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: PurchaseReturnInvoiceDetailsScreen(id: id),
      );
    }
  }

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
        return dateInput; // Return original string if parsing fails
      }
    }

    if (date != null) {
      return DateFormat('dd-MM-yyyy').format(date);
    } else {
      return "-";
    }
  }

  Widget _buildActionColumn(GetRepairsListingValue vendorInvoice) {
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
                    newChild: ViewRepairPage(id: vendorInvoice.repairId ?? ""),
                  );
                  break;

                case 'Cancel':
                  showCancelConfirmationDialog(vendorInvoice.repairId ?? "");
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

  Future<void> cancelRepair(String repairId) async {
    try {
      await estimationRepository.deleteRepair(id: repairId);
      // Refresh the list after successful cancellation
      await getRepairsListing(resetList: true);
      showSuccessToast(message: 'Order cancelled successfully');
    } catch (e) {
      log("Error cancelling order: $e");
      showErrorToast(message: 'Failed to cancel order: ${e.toString()}');
    }
  }

  void showCancelConfirmationDialog(String repairId) {
    Get.dialog(
      CancelPaymentDialog(
        subtitle: 'Are you sure you want to cancel this order?',
        onYesPressed: () async {
          await cancelRepair(repairId);
        },
      ),
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
    final data = repairListingResponse.value.data?.values;
    if (data == null || data.isEmpty) {
      return [];
    }
    return List.generate(data.length, (index) => buildVendorTableRow(index));
  }

  TableRow buildVendorTableRow(int index) {
    List<Widget> vendor_cells = [];
    final vendorInvoice = repairListingResponse.value.data?.values?[index];

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
          cellContent = formatDate(vendorInvoice?.createdAt);

        // vendorInvoice?.createdAt.toString() ?? "-";
        case 1:
          cellContent = vendorInvoice?.customerName ?? "";
          break;
        case 2:
          cellContent = vendorInvoice?.repairNumber.toString() ?? "-";
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
        case 7: // Design Details column
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
                              AddDesignRepairDetailsDialog(
                                designId: vendorInvoice?.id.toString(),
                                repairDetails: vendorInvoice!,
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
                              RepairStatusDialog(
                                repairId: vendorInvoice!.id.toString(),
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
                                orderId: vendorInvoice?.id.toString() ?? "",
                                estimateDate:
                                    vendorInvoice?.estimatedDelivery.toString(),
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
        case 10:
          cellContent = vendorInvoice?.repairTakenByName.toString() ?? "-";
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
                              AssignedToRepairDialog(
                                repairDetails: vendorInvoice!,
                              ),
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
                              color:
                                  assignedUsersText != "Not Assigned"
                                      ? secondaryColor
                                      : Colors.black,
                              decoration:
                                  assignedUsersText != "Not Assigned"
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

    vendor_cells.add(_buildActionColumn(vendorInvoice!));

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

  Future<void> getRepairsListing({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      repairListingResponse.value = ApiResponse.loading("Loading");
      lastOffsetId = null;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await aggregrateRepository.getRepairsListing(
        query: searchQuery.value,
        offsetId: lastOffsetId,
        limit: itemsPerPage,
      );

      if (resetList) {
        repairListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = repairListingResponse.value.data?.values ?? [];
        final newData = response.values ?? [];

        final combinedData = [...currentData, ...newData];

        final updatedResponse = GetRepairsListingResponse(
          values: combinedData,
          pagination: response.pagination,
        );

        repairListingResponse.value = ApiResponse.completed(updatedResponse);
      }

      // Update lastOffsetId for pagination
      if (response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        repairListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> vendorLoadMoreItems() async {
    log("The query loadMore ${isLoadingMore.value}");
    // if (!isLoadingMore.value && hasMorePages.value) {
    log("The query calling more");
    await getRepairsListing();
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
      await getRepairsListing(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value &&
        repairListingResponse.value.data?.pagination?.next != null) {
      await getRepairsListing();
    }
  }
}
