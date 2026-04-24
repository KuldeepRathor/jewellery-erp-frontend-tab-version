import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_dashboard/vendor_ledger/view_model/vendor_ledger_dashboard_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:svg_flutter/svg.dart';

class VendorLedgerDashboardPage extends StatefulWidget {
  const VendorLedgerDashboardPage({
    super.key,
    this.vendorId,
    this.vendorDetails,
  });

  final String? vendorId;
  final GetVendorByIdResponse? vendorDetails;

  @override
  State<VendorLedgerDashboardPage> createState() =>
      _VendorLedgerDashboardPageState();
}

class _VendorLedgerDashboardPageState extends State<VendorLedgerDashboardPage> {
  final VendorLedgerDashboardController controller = Get.put(
    VendorLedgerDashboardController(),
  );

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.fetchAllFilters();
    controller.setInitialConditions(isSearch: false);
    controller.getCustomerListingDetails(vendorId: widget.vendorId ?? "");

    _scrollController.addListener(_scrollListener);
  }

  Widget buildInfoColumn(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          text: title,
          color: secondaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        const SizedBox(height: 4),
        CustomText(text: content, fontWeight: FontWeight.w700, fontSize: 22),
      ],
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // controller.loadMoreItems();
    }
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        // Metal Filter
        // _buildFilter(
        //   label: 'Filter',
        //   items: controller.metalTypes,
        //   selectedItems: controller.selectedMetalTypes,
        //   onItemSelected: controller.selectMetalType,
        //   response: controller.metalTypeResponse,
        // ),
        const SizedBox(width: 16),

        // CommonFilterWidget(
        //   menuItems: const [],
        //   popupBackgroundColor: Colors.transparent,
        //   offset: const Offset(0, 45),
        //   elevation: 4.0,
        //   borderRadius: BorderRadius.circular(8),
        //   focusColor: Colors.blue.withAlpha(190),
        //   child: GestureDetector(
        //     onTap: () {
        //       controller.selectDate(context);
        //     },
        //     child: const CustomPopUpIcon(
        //       buttonName: 'Date',
        //       image: 'assets/svgs/filter.svg',
        //     ),
        //   ),
        // ),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {},
          image: 'assets/svgs/download.svg',
          buttonName: 'Download',
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        autofocus: true,
        // onChanged: controller.setSearchQuery,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }

  Widget _buildCustomerTable(VendorLedgerDashboardController controller) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Ledgers",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final apiStatus =
                      controller.customerListingResponse.value.status;

                  if (apiStatus == Status.COMPLETED) {
                    final data = controller.customerListingResponse.value.data;
                    if (data?.values?.isEmpty ?? true) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            child: LineWiseCustomTable(
                              headers: controller.headers.toList(),
                              columnWidths: controller.columnWidths.toList(),
                              itemCount: 0,
                              buildRow:
                                  (context, index, totalWidth) =>
                                      const SizedBox.shrink(),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svgs/error/no_records_found.svg',
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: data?.values?.length ?? 0,
                            buildRow: (context, index, totalWidth) {
                              final customerDetail = data?.values?.elementAt(
                                index,
                              );

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    if (customerDetail != null) {
                                      controller.navigateToViewByType(
                                        customerDetail,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ),
                                    child: Row(
                                      children: List.generate(controller.headers.length, (
                                        cellIndex,
                                      ) {
                                        String cellContent = "-";
                                        switch (cellIndex) {
                                          case 0:
                                            cellContent = "${index + 1}";
                                            break;
                                          case 1:
                                            cellContent =
                                                convertDateTimeToString(
                                                  customerDetail?.invoiceDate,
                                                );
                                            break;
                                          case 2:
                                            cellContent =
                                                customerDetail?.invoiceNumber ??
                                                "-";
                                            break;
                                          case 3:
                                            cellContent =
                                                customerDetail?.description ??
                                                "-";
                                            break;
                                          case 4:
                                            cellContent =
                                                customerDetail?.type ?? "-";
                                            break;
                                          case 5:
                                            cellContent =
                                                customerDetail?.weight ?? "-";
                                            break;
                                          case 6:
                                            cellContent =
                                                customerDetail?.sgst ?? "-";
                                            break;
                                          case 7:
                                            cellContent =
                                                customerDetail?.cgst ?? "-";
                                            break;
                                          case 8:
                                            cellContent =
                                                customerDetail?.igst ?? "-";
                                            break;
                                          case 9:
                                            cellContent =
                                                customerDetail?.tds ?? "-";
                                            break;
                                          case 10:
                                            cellContent =
                                                customerDetail?.tcs ?? "-";
                                            break;
                                          case 11:
                                            cellContent =
                                                customerDetail?.dr ?? "-";
                                            break;
                                          case 12:
                                            cellContent =
                                                customerDetail?.cr ?? "-";
                                            break;
                                          case 13:
                                            cellContent =
                                                customerDetail?.balanceAmount ??
                                                "-";
                                            break;
                                          case 14:
                                            // Actions column
                                            return SizedBox(
                                              width: getColumnWidthForSingleTableCell(
                                                totalWidth: totalWidth,
                                                columnWidth:
                                                    controller
                                                        .columnWidths[cellIndex],
                                              ),
                                              child: Theme(
                                                data: ThemeData(
                                                  focusColor: greyTextColor,
                                                  tooltipTheme:
                                                      const TooltipThemeData(
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                      ),
                                                ),
                                                child: CustomPopupMenuButtonWidget<
                                                  String
                                                >(
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                  ),
                                                  itemBuilder:
                                                      (
                                                        BuildContext context,
                                                      ) => <
                                                        PopupMenuEntry<String>
                                                      >[
                                                        ...controller.popUpValues.map((
                                                          element,
                                                        ) {
                                                          return PopupMenuItem<
                                                            String
                                                          >(
                                                            value: element,
                                                            height: 0,
                                                            child: SizedBox(
                                                              width: 88,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Text(
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    element,
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  if (element !=
                                                                      controller
                                                                          .popUpValues
                                                                          .last)
                                                                    CustomDashedLineWidget(
                                                                      width:
                                                                          Get.width,
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
                                                        break;
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                        }

                                        return SizedBox(
                                          width:
                                              getColumnWidthForSingleTableCell(
                                                totalWidth: totalWidth,
                                                columnWidth:
                                                    controller
                                                        .columnWidths[cellIndex],
                                              ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: cellIndex == 0 ? 0 : 4.0,
                                              right: 4.0,
                                            ),
                                            child: CustomText(
                                              text: cellContent,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: 'Satoshi',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: LineWiseCustomHeaderTable(
                            headers: [
                              'Total', // First column
                              ...List.filled(10, ''), // Empty columns
                              controller.totalDr.value.toStringAsFixed(
                                2,
                              ), // DR column
                              controller.totalCr.value.toStringAsFixed(
                                2,
                              ), // CR column
                              '', // Action column
                            ],
                            columnWidths: controller.columnWidths.toList(),
                            backgroundColor: greenColor,
                            textColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else if (apiStatus == Status.LOADING) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: 0,
                            buildRow: (
                              BuildContext context,
                              int index,
                              double totalWidth,
                            ) {
                              return const SizedBox();
                            },
                          ),
                        ),
                        const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    );
                  } else if (apiStatus == Status.ERROR) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: 0,
                            buildRow: (
                              BuildContext context,
                              int index,
                              double totalWidth,
                            ) {
                              return const SizedBox();
                            },
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              controller
                                      .customerListingResponse
                                      .value
                                      .message ??
                                  "Something went wrong",
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFilter({
  //   required String label,
  //   required List<DropdownItem> items,
  //   required List<DropdownItem> selectedItems,
  //   required Function(DropdownItem) onItemSelected,
  //   required Rx<ApiResponse<List<DropdownItem>>> response,
  // }) {
  //   return CommonFilterWidget(
  //     menuItems: [
  //       PopupMenuItem(
  //         enabled: false,
  //         height: 0,
  //         padding: const EdgeInsets.all(0),
  //         child: Obx(() {
  //           switch (response.value.status) {
  //             case Status.LOADING:
  //               return Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(12),
  //                   color: Colors.white,
  //                 ),
  //                 child: const Center(child: CircularProgressIndicator()),
  //               );

  //             case Status.COMPLETED:
  //               if (items.isEmpty) {
  //                 return Container(
  //                   height: 100,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(12),
  //                     color: Colors.white,
  //                   ),
  //                   child: const Center(child: Text("No items available")),
  //                 );
  //               }
  //               return GenericFilterWidget(
  //                 label: label,
  //                 items: items,
  //                 selectedItems: selectedItems,
  //                 onItemSelected: onItemSelected,
  //                 onSubmit: () {
  //                   // controller.getCustomerListingDetails();
  //                   Get.back();
  //                 },
  //               );

  //             case Status.ERROR:
  //               return Container(
  //                 height: 100,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(12),
  //                   color: Colors.white,
  //                 ),
  //                 child: Center(
  //                   child: Text(response.value.message ?? "Error loading data"),
  //                 ),
  //               );

  //             default:
  //               return const SizedBox(
  //                 height: 100,
  //                 child: Center(child: Text("Loading...")),
  //               );
  //           }
  //         }),
  //       ),
  //     ],
  //     popupBackgroundColor: Colors.transparent,
  //     offset: const Offset(0, 45),
  //     elevation: 4.0,
  //     borderRadius: BorderRadius.circular(8),
  //     focusColor: Colors.blue.withAlpha(190),
  //     child: CustomPopUpIcon(
  //       buttonName: label,
  //       image: 'assets/svgs/filter.svg',
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final controllerCreation =
    //     Get.create<CustomerListingViewmodel>(() => CustomerListingViewmodel());
    // final controller = Get.find<CustomerListingViewmodel>();

    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HeaderWidget(header: 'AGJ Anatam Gold Jewelers'),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: CustomText(
                text: widget.vendorDetails?.name ?? "",
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    _buildCustomerTable(controller),
                  ],
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 30,
                ),
                child: Obx(() {
                  double value =
                      controller.totalCr.value - controller.totalDr.value;
                  return buildInfoColumn(
                    "Balance",
                    "₹ ${value.toStringAsFixed(2)}",
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
