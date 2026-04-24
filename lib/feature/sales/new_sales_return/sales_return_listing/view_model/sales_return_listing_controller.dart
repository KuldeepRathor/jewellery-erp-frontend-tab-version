import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/model/get_sales_return_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/model/sales_return_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view/view_sales_return_record_page.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class SalesReturnListingController extends GetxController {
  final EstimationRepository _estimationRepository = EstimationRepository();
  final BaseFilterController filterController = Get.put(BaseFilterController());

  SalesReturnListingRequest? currentRequest;

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Rtn. Date",
        "Rtn. Inv. No",
        "Sales. Inv. No",
        "Customer Name/ No.",
        "Rtn. Pcs",
        "Rtn. Wt",
        "Rtn. Amount (₹)",
        "Adj Inv. no",
        "Pending Amt",
        "Status",
        "",
      ].obs;
  final columnWidths = [0.4, 0.4, 0.4, 0.7, 0.2, 0.4, 0.4, 0.4, 0.4, 0.4, 0.1];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getApprovalListingResponse =
      Rx<ApiResponse<GetSalesReturnPaginatedResponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  @override
  void onInit() {
    log("Approval Listing");
    // getMetalTypes();
    super.onInit();

    filterController.resetAllFilters();

    filterController.fetchAllDropdownData(
      filterTypes: ['metalType', 'dateRange', 'invoiceStatus', 'pendingAmount'],
    );
  }

  SalesReturnListingRequest createRequestFormFilters() {
    return SalesReturnListingRequest(
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes.first.id
              : null,
      dateFrom: filterController.dateFrom.value,
      dateTo: filterController.dateTo.value,
      invoiceStatus: filterController.selectedInvoiceStatus.value?.value,
      pendingAmountFrom: filterController.minPendingAmount.value,
      pendingAmountTo: filterController.maxPendingAmount.value,
    );
  }

  void applyFilters() {
    // Create request from filters
    final requestBody = createRequestFormFilters();

    currentRequest = requestBody;

    // Call API with the filter request
    getApprovalListingDetails(
      isSearch: false,
      resetList: true,
      requestBody: requestBody,
    );
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      // String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            // if (header != "Sn")
            //   const SizedBox(
            //     width: 4,
            //   ),
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
      getApprovalListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["View"];
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

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final approvalDetails = getApprovalListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${approvalDetails?.toJson()}");
    for (int i = 0; i < headers.length; i++) {
      String? cellContent = "-";
      Color textColor = Colors.black;
      VoidCallback? onTapFunction;
      TextDecoration? textDecoration;

      switch (i) {
        case 0:
          cellContent = formatDate(approvalDetails?.createdAt);
          break;
        case 1:
          cellContent = approvalDetails?.saleReturnNumber ?? "-";
          textColor = Colors.blue;
          textDecoration = TextDecoration.underline;
          onTapFunction = () {
            SidebarController sidebarController = Get.find();
            sidebarController.navigateToWidget(
              newChild: ViewSalesReturnInvoicePage(
                id: approvalDetails?.id.toString() ?? "",
              ),
            );
          };
          break;
        case 2:
          cellContent = approvalDetails?.saleNumber ?? "-";

          break;
        case 3:
          cellContent = approvalDetails?.name ?? "-";

          break;
        case 4:
          // // Calculate rate per gram
          // double totalAmount = 0;
          // double totalWeight = 0;

          // approvalDetails?.lineItems?.forEach((item) {
          //   totalAmount += double.tryParse(item.salesAmount ?? "0") ?? 0;
          //   totalWeight += double.tryParse(item.finalNetWeight ?? "0") ?? 0;
          // });

          // // Calculate rate per gram
          // double ratePerGram = totalWeight > 0 ? totalAmount / totalWeight : 0;
          cellContent = approvalDetails?.pieces.toString() ?? "-";
          break;
        case 5:
          cellContent = approvalDetails?.netWeight ?? "-";

          break;
        case 6:
          cellContent = "₹${approvalDetails?.invoiceAmount ?? "-"}";

          break;
        case 7:
          if (approvalDetails?.adjustInvoices != null &&
              approvalDetails!.adjustInvoices!.isNotEmpty) {
            cellContent = approvalDetails.adjustInvoices!
                .map((invoice) => invoice.adjustInvoiceNumber ?? "-")
                .where((number) => number != "-" && number.isNotEmpty)
                .join(", ");

            // If no valid invoice numbers found, show "-"
            if (cellContent.isEmpty) {
              cellContent = "-";
            }
          } else {
            cellContent = "-";
          }

          break;
        case 8:
          final invoiceAmount = approvalDetails?.balance ?? "0";
          cellContent =
              "₹${double.tryParse(invoiceAmount)?.toStringAsFixed(2) ?? "-"}";
          // cellContent = approvalDetails?.balance ?? "";
          // textColor = approvalDetails?.paymentStatus == true
          //     ? Colors.green
          //     : Colors.amber;
          break;
        case 9:
          final invoiceAmount = approvalDetails?.invoiceAmount ?? "0";
          cellContent =
              "₹${double.tryParse(invoiceAmount)?.toStringAsFixed(2) ?? "-"}";
          cellContent = approvalDetails?.paymentStatus.toString() ?? "";
          // textColor = approvalDetails?.paymentStatus == true
          //     ? Colors.green
          //     : Colors.amber;
          break;
        case 10:
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
                                      if (element != "Cancel")
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
                          case 'View':
                            SidebarController sidebarController = Get.find();
                            sidebarController.navigateToWidget(
                              newChild: ViewSalesReturnInvoicePage(
                                id: approvalDetails?.id.toString() ?? "",
                              ),
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
      Widget cellWidget;
      if (onTapFunction != null) {
        // For clickable cells (like sales return number)
        cellWidget = GestureDetector(
          onTap: onTapFunction,
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
                decoration: textDecoration,
              ),
            ),
          ),
        );
      } else {
        // For non-clickable cells
        cellWidget = Padding(
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
              decoration: textDecoration,
            ),
          ),
        );
      }
      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (i != 0) const SizedBox(width: 4),
                Flexible(child: cellWidget),
              ],
            ),
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> getApprovalListingDetails({
    bool resetList = false,
    bool isSearch = false,
    SalesReturnListingRequest? requestBody,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getApprovalListingResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      final effectiveRequestBody =
          requestBody ?? currentRequest ?? SalesReturnListingRequest();
      final response = await _estimationRepository.getSalesReturnListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
        requestBody: effectiveRequestBody,
      );
      if (resetList) {
        getApprovalListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getApprovalListingResponse.value.data?.values ?? [];
        List<GetSalesReturnPaginatedResponseValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getApprovalListingResponse.value = ApiResponse.completed(response);
      }
      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.pagination?.next;
      }
    } catch (e) {
      getApprovalListingResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getApprovalListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getApprovalListingDetails();
    }
  }

  void resetFields() {}
}
