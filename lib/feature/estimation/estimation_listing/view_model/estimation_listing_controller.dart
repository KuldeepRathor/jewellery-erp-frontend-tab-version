import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/estimation_listing/model/get_estimation_record_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/view_estimate/view/view_estimate_template.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class EstimationListingController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Estimation No",
        "Pieces",
        "Total Amount",
        "Old Gold Amt.(₹) & gms",
        "Jewellery Plan Amt",
        "Advance Booking Amt.(₹)",
        // "Final Booking Amt.(₹)",
        // "Sales Counter",
        // "Sales Person",
        "",
      ].obs;
  final columnWidths = [
    0.6,
    0.6,
    0.6,
    0.6,
    0.6,
    0.6,
    //0.6
    //0.6
    //0.6
    0.1,
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getApprovalListingResponse =
      Rx<ApiResponse<GetEstimationRecordListing>>(
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

  List<String> popUpValues = ["View", "Edit", "Delete"];
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
      return DateFormat('yyyy-MM-dd').format(date);
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
      String cellContent = "-";
      Color textColor = Colors.black;
      TextDecoration? textDecoration;
      VoidCallback? onTapFunction;

      switch (i) {
        case 0:
          cellContent = approvalDetails?.estimateNumber ?? "-";
          // Make estimation number blue and underlined
          textColor = Colors.blue;
          textDecoration = TextDecoration.underline;
          // Make it clickable to open the estimate
          onTapFunction = () {
            log("View estimate open");
            PermissionGuardUtil.withActionPermission(2051, () {
              SidebarController sidebarController = Get.find();
              sidebarController.navigateToWidget(
                newChild: ViewEstimateTemplate(
                  estimateId: approvalDetails?.id ?? "",
                ),
              );
            });
          };
          break;
        case 1:
          cellContent = approvalDetails?.totalPieces.toString() ?? "-";
          break;
        case 2:
          cellContent = approvalDetails?.totalAmount ?? "-";
          break;
        case 3:
          cellContent = approvalDetails?.oldGoldAmount ?? "-";
          break;
        case 4:
          cellContent = approvalDetails?.jewelleryPlanAmount ?? "-";
          break;
        case 5:
          cellContent = approvalDetails?.advanceBookingAmount ?? "-";
          break;
        case 6:
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
                          case 'View':
                            SidebarController sidebarController = Get.find();
                            sidebarController.navigateToWidget(
                              newChild: ViewEstimateTemplate(
                                estimateId: approvalDetails?.id ?? "",
                              ),
                            );
                            break;
                          case 'Return':
                            break;
                          case 'Edit':
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
            ],
          );
      }

      // Create the cell widget with proper structure
      Widget cellWidget;

      if (onTapFunction != null) {
        // For clickable cells (like estimation number)
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
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getApprovalListingResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      final response = await estimationRepository.getEstimationRecordListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );
      if (resetList) {
        getApprovalListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getApprovalListingResponse.value.data?.values ?? [];
        List<GetEstimationRecordValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getApprovalListingResponse.value = ApiResponse.completed(response);
      }
      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next;
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

  void resetFields() {}
}
