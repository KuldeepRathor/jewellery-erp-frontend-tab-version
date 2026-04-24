import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/order_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/view/webstore_details_settlements_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/view_model/webstore_settlements_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:svg_flutter/svg_flutter.dart';

class WebStoreSettlementsPage extends StatefulWidget {
  const WebStoreSettlementsPage({super.key});

  @override
  State<WebStoreSettlementsPage> createState() =>
      _WebStoreSettlementsPageState();
}

class _WebStoreSettlementsPageState extends State<WebStoreSettlementsPage> {
  final controller = Get.put<WebStoreSettlementsViewModel>(
    WebStoreSettlementsViewModel(),
  );
  final SidebarController sidebarController = Get.find<SidebarController>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getSettlementsListing(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final controllerCreation =
    //     Get.create<WebstoreOrdersViewModel>(() => WebstoreOrdersViewModel());
    // final controller = Get.find<WebstoreOrdersViewModel>();

    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              header: 'Settlements',
              wantBackButton: true,
              onBackButtonTap: () {
                Get.back();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Stack(
                        children: [
                          _buildVendorTable(controller),
                          Obx(
                            () => AnimatedPositioned(
                              right:
                                  controller.isDrawerVisible.value
                                      ? 0
                                      : (MediaQuery.of(context).size.width *
                                              0.26) *
                                          -1,
                              top: 0,
                              bottom: 0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInCubic,
                              child: const OrderDetailsScreen(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {},
          image: 'assets/svgs/filter.svg',
          buttonName: 'Filter',
        ),
        const SizedBox(width: 16),
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
        onChanged: controller.setSeachQuery,
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

  Widget _buildVendorTable(WebStoreSettlementsViewModel controller) {
    return Container(
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
              "Settlements",
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
                    controller
                        .getPaginatedGetOrderSettlementListingResponse
                        .value
                        .status;

                if (apiStatus == Status.COMPLETED) {
                  final data =
                      controller
                          .getPaginatedGetOrderSettlementListingResponse
                          .value
                          .data;
                  if (data?.values?.isEmpty ?? true) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: 0,
                            buildRow:
                                (context, index, totalWidth) =>
                                    const SizedBox(),
                            isLoadingMore: false,
                            addBottomSpace: false,
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/svgs/error/no_records_found.svg',
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return LineWiseCustomTable(
                    headers: controller.headers.toList(),
                    columnWidths: controller.columnWidths.toList(),
                    itemCount: data?.values?.length ?? 0,
                    controller: _scrollController,
                    isLoadingMore: controller.isLoadingMore.value,
                    buildRow: (context, index, totalWidth) {
                      final headerValue = data?.values?.elementAt(index);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          focusColor: greyTextColor,
                          onTap: () {
                            controller.showItemDetails(
                              index: headerValue?.id ?? "",
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: List.generate(
                                controller.headers.length,
                                (cellIndex) {
                                  String cellContent = "-";
                                  switch (cellIndex) {
                                    case 0:
                                      cellContent =
                                          headerValue?.recordCreatedAt != null
                                              ? DateFormat('dd/MM/yyyy').format(
                                                headerValue!.recordCreatedAt!,
                                              )
                                              : "-";
                                      break;
                                    case 1:
                                      cellContent =
                                          headerValue?.count.toString() ?? "-";
                                      break;
                                    case 2:
                                      cellContent = _formatAmount(
                                        headerValue?.totalOnlineAmount,
                                      );
                                      break;

                                    case 3:
                                      cellContent = _formatAmount(
                                        headerValue?.txnCharges,
                                      );
                                      break;
                                    case 4:
                                      cellContent = _formatAmount(
                                        headerValue?.txnChargesGst ?? "-",
                                      );
                                      break;
                                    case 5:
                                      cellContent = _formatAmount(
                                        headerValue?.settlementAmount ?? "-",
                                      );
                                      break;

                                    case 6:
                                      cellContent =
                                          headerValue?.settlementId ?? "-";
                                      break;
                                    case 7:
                                      cellContent =
                                          headerValue?.settlementTime != null
                                              ? DateFormat('dd/MM/yyyy').format(
                                                headerValue!.settlementTime!,
                                              )
                                              : "-";
                                      break;

                                    // In the case 8 of your table building
                                    case 8:
                                      return InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => WebStoreSettlementDetailsPage(
                                              settlementId:
                                                  headerValue?.id ?? "",
                                              settlementAmount:
                                                  headerValue
                                                      ?.settlementAmount ??
                                                  "0",
                                            ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: secondaryColor.withOpacity(
                                              0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            "View Details",
                                            style: TextStyle(
                                              color: secondaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Satoshi',
                                            ),
                                          ),
                                        ),
                                      );
                                    default:
                                      cellContent = "-";
                                  }

                                  return SizedBox(
                                    width: getColumnWidthForSingleTableCell(
                                      totalWidth: totalWidth,
                                      columnWidth:
                                          controller.columnWidths[cellIndex],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      child: CustomText(
                                        text: cellContent,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (apiStatus == Status.LOADING) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: LineWiseCustomTable(
                          headers: controller.headers.toList(),
                          columnWidths: controller.columnWidths.toList(),
                          itemCount: 0,
                          buildRow:
                              (context, index, totalWidth) => const SizedBox(),
                          addBottomSpace: false,
                        ),
                      ),
                      const Expanded(
                        flex: 14,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  );
                } else if (apiStatus == Status.ERROR) {
                  return Column(
                    children: [
                      Expanded(
                        child: LineWiseCustomTable(
                          headers: controller.headers.toList(),
                          columnWidths: controller.columnWidths.toList(),
                          itemCount: 0,
                          buildRow:
                              (context, index, totalWidth) => const SizedBox(),
                          addBottomSpace: false,
                        ),
                      ),
                      const Expanded(
                        flex: 15,
                        child: Center(
                          child: Text(
                            "controller.value.message",
                            // ??
                            //     "Something went wrong",
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
    );
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';

    try {
      double value =
          amount is String ? double.parse(amount) : amount.toDouble();

      // Format to 2 decimal places
      String formatted = value.toStringAsFixed(2);

      // Remove trailing zeros and decimal point if not needed
      formatted = formatted.replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

      return formatted;
    } catch (e) {
      return '0';
    }
  }

  // Widget _buildActionMenu(GetWebStoreOrdersListResponse? headerValue) {
  //   return Theme(
  //     data: ThemeData(
  //       focusColor: greyTextColor,
  //       tooltipTheme: const TooltipThemeData(
  //         decoration: BoxDecoration(
  //           color: Colors.transparent,
  //         ),
  //       ),
  //     ),
  //     child: CustomPopupMenuButtonWidget<String>(
  //       icon: const Icon(Icons.more_vert),
  //       itemBuilder: (BuildContext context) =>
  //           headerValue!.statusDropdown!.map((element) {
  //         return PopupMenuItem<String>(
  //           value: element.status ?? "",
  //           height: 0,
  //           child: SizedBox(
  //             width: 88,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   element.status ?? "",
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 if (element !=
  //                     controller.getStatusListingForWebStoreItemResponse.value
  //                         .data?.last)
  //                   CustomDashedLineWidget(width: Get.width)
  //               ],
  //             ),
  //           ),
  //         );
  //       }).toList(),
  //       onSelected: (String value) {
  //         switch (value) {
  //           case 'Shipped':
  //             // controller.markAsShipped(headerValue!);
  //
  //             break;
  //           case 'Return':
  //             // controller.onReturnTapped();
  //             break;
  //           case 'Delivered':
  //             // controller.onDeliveryTapped();
  //             break;
  //           case 'Cancel':
  //             // controller.onCancelTapped();
  //             break;
  //         }
  //       },
  //     ),
  //   );
  // }
}
