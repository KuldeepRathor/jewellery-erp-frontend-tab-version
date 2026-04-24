import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt_listing/model/get_approval_receipt_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/view_approval_receipt/view/view_approval_receipt_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class ApprovalReceiptListingController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  SidebarController sidebarController = Get.find();

  final formKey = GlobalKey<FormState>();

  // Add row selection tracking
  final RxInt selectedRowIndex = (-1).obs;
  final Rx<GetApprovalReceiptListingValue?> selectedApproval = Rx(null);

  // Add tagging details response
  final taggingDetailsResponse = Rx<ApiResponse<GetTaggingLineItemResponse>>(
    ApiResponse.initial("Initial"),
  );

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Issue Date",
        "Receipt Number",
        "Receipt By",
        "Customer Ph no",
        "Tag Number",
        "Description",
        "Gross Weight",
        "Nett Weight",
        "Stone Cost",
        "",
      ].obs;
  final columnWidths = [
    0.35,
    0.35,
    0.55,
    0.35,
    0.35,
    0.55,
    0.35,
    0.35,
    0.35,
    0.1,
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getApprovalListingResponse =
      Rx<ApiResponse<GetApprovalReceiptListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  @override
  void onInit() {
    log("Approval Receipt Listing");
    super.onInit();
  }

  // Add row selection methods
  void updateSelectedRow(int index, GetApprovalReceiptListingValue? rowData) {
    selectedRowIndex.value = index;
    selectedApproval.value = rowData;

    if (rowData != null && rowData.taggingId != null) {
      // Fetch tagging details using tagging ID
      fetchTaggingDetails(rowData.taggingId!);
    } else {
      // Clear tagging details if no valid ID
      taggingDetailsResponse.value = ApiResponse.initial("Initial");
    }
  }

  void selectNextRow() {
    final maxIndex =
        (getApprovalListingResponse.value.data?.values?.length ?? 0) - 1;
    if (selectedRowIndex.value < maxIndex) {
      final nextIndex = selectedRowIndex.value + 1;
      final nextRow = getApprovalListingResponse.value.data?.values?.elementAt(
        nextIndex,
      );
      updateSelectedRow(nextIndex, nextRow);
    }
  }

  void selectPreviousRow() {
    if (selectedRowIndex.value > 0) {
      final previousIndex = selectedRowIndex.value - 1;
      final previousRow = getApprovalListingResponse.value.data?.values
          ?.elementAt(previousIndex);
      updateSelectedRow(previousIndex, previousRow);
    }
  }

  // Add method to fetch tagging details
  Future<void> fetchTaggingDetails(String taggingId) async {
    taggingDetailsResponse.value = ApiResponse.loading("Loading");
    try {
      final response = await inventoryRepository.getTaggingLineItem(taggingId);
      taggingDetailsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      taggingDetailsResponse.value = ApiResponse.error(e.toString());
      log("Error fetching tagging details: $e");
    }
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      cells.add(
        Row(
          children: [
            if (i != 0) const SizedBox(width: 4),
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

  List<String> popUpValues = ["View", "Delete"];

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
        return dateInput;
      }
    }

    if (date != null) {
      return DateFormat('yyyy-MM-dd').format(date);
    } else {
      return "-";
    }
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final approvalDetails = getApprovalListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${approvalDetails?.toJson()}");

    for (int i = 0; i < headers.length; i++) {
      if (i < headers.length - 1) {
        // Regular data cells
        String cellContent = "-";
        TextDecoration? textDecoration;
        VoidCallback? onTapFunction;
        switch (i) {
          case 0:
            cellContent = _formatDate(approvalDetails?.createdAt);
            break;
          case 1:
            cellContent = approvalDetails?.invoiceNumber ?? "-";
            textDecoration = TextDecoration.underline;
            onTapFunction = () {
              log("View approval issue open");
              // Navigate to view approval issue page
              sidebarController.navigateToWidget(
                newChild: ViewApprovalReceiptPage(
                  id: approvalDetails?.approvalReceiptId ?? "",
                ),
              );
            };
            break;
          case 2:
            cellContent = "-";
            break;
          case 3:
            cellContent = approvalDetails?.customerPhoneNumber ?? "-";
            break;
          case 4:
            cellContent = "${approvalDetails?.code} - ${approvalDetails?.tag}";
            break;
          case 5:
            cellContent = approvalDetails?.description ?? "-";
            break;
          case 6:
            cellContent = approvalDetails?.grossWeight ?? "-";
            break;
          case 7:
            cellContent = approvalDetails?.netWeight ?? "-";
            break;
          case 8:
            cellContent = approvalDetails?.stoneCost ?? "-";
            break;
        }

        cells.add(
          Column(
            children: [
              Obx(
                () => InkWell(
                  onTap:
                      onTapFunction ??
                      () {
                        updateSelectedRow(index, approvalDetails);
                      },
                  child: Container(
                    color:
                        selectedRowIndex.value == index
                            ? greyTextColor.withOpacity(0.1)
                            : Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        if (i != 0) const SizedBox(width: 4),
                        Flexible(
                          child: Tooltip(
                            message: cellContent,
                            child: CustomText(
                              text: cellContent,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              decoration: textDecoration,
                              color:
                                  textDecoration != null
                                      ? Colors.blue
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomDashedLineWidget(width: Get.width),
            ],
          ),
        );
      } else {
        // Action column
        cells.add(
          Column(
            children: [
              Obx(
                () => InkWell(
                  onTap: () {
                    updateSelectedRow(index, approvalDetails);
                  },
                  child: Container(
                    color:
                        selectedRowIndex.value == index
                            ? greyTextColor.withOpacity(0.1)
                            : Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Theme(
                          data: ThemeData(
                            focusColor: greyTextColor,
                            tooltipTheme: const TooltipThemeData(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          child: CustomPopupMenuButtonWidget<String>(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder:
                                (
                                  BuildContext context,
                                ) => <PopupMenuEntry<String>>[
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
                                case 'View':
                                  sidebarController.navigateToWidget(
                                    newChild: ViewApprovalReceiptPage(
                                      id:
                                          approvalDetails?.approvalReceiptId ??
                                          "",
                                    ),
                                  );
                                  break;
                                case 'Delete':
                                  break;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 7),
                      ],
                    ),
                  ),
                ),
              ),
              CustomDashedLineWidget(width: Get.width),
            ],
          ),
        );
      }
    }

    return TableRow(
      decoration: BoxDecoration(
        color:
            selectedRowIndex.value == index
                ? const Color(0xffE6E8FF)
                : Colors.transparent,
      ),
      children: cells,
    );
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
    selectedRowIndex.value = -1;
    selectedApproval.value = null;
    taggingDetailsResponse.value = ApiResponse.initial("Initial");
  }

  Future<void> getApprovalListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getApprovalListingResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      final response = await inventoryRepository.getApprovalReceiptListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );
      if (resetList) {
        getApprovalListingResponse.value = ApiResponse.completed(response);
        // Auto-select first row if available
        if (response.values?.isNotEmpty ?? false) {
          updateSelectedRow(0, response.values!.first);
        }
      } else {
        final currentData = getApprovalListingResponse.value.data?.values ?? [];
        List<GetApprovalReceiptListingValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getApprovalListingResponse.value = ApiResponse.completed(response);
      }
      hasMorePages.value = response.pagination?.nextPage != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.nextPage != null) {
          lastOffsetId = response.pagination?.nextPage.toString();
        }
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

  void resetFields() {
    selectedRowIndex.value = -1;
    selectedApproval.value = null;
    taggingDetailsResponse.value = ApiResponse.initial("Initial");
  }
}
