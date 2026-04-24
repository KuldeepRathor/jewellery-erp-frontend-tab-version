import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/view/lot_creation_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/view_model/lot_creation_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

import 'package:svg_flutter/svg_flutter.dart';

class LotCreationPage extends StatefulWidget {
  const LotCreationPage({super.key});

  @override
  State<LotCreationPage> createState() => _LotCreationPageState();
}

class _LotCreationPageState extends State<LotCreationPage> {
  late final LotCreationViewModel controller;
  final SidebarController sidebarController = Get.find<SidebarController>();

  final ScrollController _scrollController = ScrollController();
  late LinkedScrollControllerGroup _horizontalControllersGroup;
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;
  @override
  void initState() {
    super.initState();
    controller = Get.put<LotCreationViewModel>(LotCreationViewModel());
    controller.setInitialConditions(isSearch: false);
    controller.getVendorListingDetails(resetList: true);
    _scrollController.addListener(_scrollListener);
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    Get.delete<LotCreationViewModel>();
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
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap: () {
          controller.showLotEntryDialog();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: 'LOT items'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Stack(children: [_buildVendorTable(controller)]),
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
        const LotCreationFilterWidget(),
        const Spacer(),
        CustomButton2(
          onTap: () {
            controller.showLotEntryDialog();
          },
          image: 'assets/svgs/add.svg',
          buttonName: 'New LOT Entry',
        ),
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

  Widget _buildVendorTable(LotCreationViewModel controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final apiStatus =
                    controller.getVendorListingDetailsResponse.value.status;

                if (apiStatus == Status.COMPLETED) {
                  final data =
                      controller.getVendorListingDetailsResponse.value.data;
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

                  return Column(
                    children: [
                      LineWiseCustomHeaderTableForLot(
                        headers: controller.topHeaders,
                        columnWidths: controller.topColumnWidths,
                        headerScrollController: _horizontalController1,
                      ),
                      Expanded(
                        child: LineWiseCustomTable(
                          headers: controller.headers.toList(),
                          columnWidths: controller.columnWidths.toList(),
                          itemCount: data?.values?.length ?? 0,
                          controller: _scrollController,
                          headerScrollController: _horizontalController2,
                          isLoadingMore: controller.isLoadingMore.value,
                          buildRow: (context, index, totalWidth) {
                            final headerValue = data?.values?.elementAt(index);
                            Color? textColor;
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                focusColor: greyTextColor,
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 8.0,
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
                                          cellContent = convertDateTimeToString(
                                            headerValue?.createdAt,
                                          );
                                          break;
                                        case 2:
                                          cellContent =
                                              headerValue?.lotEntryNumber ??
                                              "-";
                                          return InkWell(
                                            onTap: () {
                                              controller.showLotEntryDialog(
                                                lotData: headerValue!,
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: SizedBox(
                                              width: getColumnWidthForSingleTableCell(
                                                totalWidth: totalWidth,
                                                columnWidth:
                                                    controller
                                                        .columnWidths[cellIndex],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4.0,
                                                    ),
                                                child: CustomText(
                                                  text: cellContent,
                                                  fontSize: 16,
                                                  color: secondaryColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: 'Satoshi',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );

                                        case 3:
                                          // Format the list of record numbers as a comma-separated string
                                          cellContent =
                                              headerValue?.recordNumber !=
                                                          null &&
                                                      headerValue!
                                                          .recordNumber!
                                                          .isNotEmpty
                                                  ? headerValue.recordNumber!
                                                      .join(", ")
                                                  : "-";
                                          return InkWell(
                                            onTap: () {},
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: SizedBox(
                                              width: getColumnWidthForSingleTableCell(
                                                totalWidth: totalWidth,
                                                columnWidth:
                                                    controller
                                                        .columnWidths[cellIndex],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4.0,
                                                    ),
                                                child: CustomText(
                                                  text: cellContent,
                                                  fontSize: 16,
                                                  color: secondaryColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: 'Satoshi',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        case 4:
                                          cellContent =
                                              headerValue?.transactionType ??
                                              "-";
                                          break;
                                        case 5:
                                          cellContent =
                                              headerValue?.vendor_code ?? "-";
                                          // Credit
                                          break;
                                        case 6:
                                          cellContent =
                                              headerValue?.grossWeight ?? "-";

                                          break;
                                        case 7:
                                          cellContent =
                                              headerValue?.netWeight ?? "-";

                                          break;
                                        case 8:
                                          cellContent =
                                              headerValue?.pieces.toString() ??
                                              "-";

                                          break;
                                        case 9:
                                          // Show all purities instead of just the first one
                                          cellContent = _getAllPurities(
                                            headerValue?.lotPurity,
                                          );
                                          break;

                                        case 10:
                                          cellContent =
                                              headerValue?.taggingValues?.pieces
                                                  .toString() ??
                                              "-";

                                          break;
                                        case 11:
                                          cellContent =
                                              headerValue
                                                  ?.taggingValues
                                                  ?.grossWeight ??
                                              "-";

                                          break;

                                        case 12:
                                          cellContent =
                                              headerValue
                                                  ?.taggingValues
                                                  ?.netWeight ??
                                              "-";

                                          break;

                                        case 13:
                                          cellContent =
                                              headerValue
                                                  ?.differenceValues
                                                  ?.pieces
                                                  .toString() ??
                                              "-";
                                          // Check if there's a difference between pieces
                                          if (headerValue?.pieces !=
                                                  headerValue
                                                      ?.taggingValues
                                                      ?.pieces &&
                                              headerValue
                                                      ?.differenceValues
                                                      ?.pieces !=
                                                  0) {
                                            textColor = Colors.red;
                                          }
                                          break;

                                        // For difference gross weight (case 14):
                                        case 14:
                                          cellContent =
                                              headerValue
                                                  ?.differenceValues
                                                  ?.grossWeight ??
                                              "-";
                                          // Check if there's a difference in gross weight
                                          if (_hasDifference(
                                                headerValue?.grossWeight,
                                                headerValue
                                                    ?.taggingValues
                                                    ?.grossWeight,
                                              ) &&
                                              headerValue
                                                      ?.differenceValues
                                                      ?.grossWeight !=
                                                  "0") {
                                            textColor = Colors.red;
                                          }
                                          break;

                                        // For difference net weight (case 15):
                                        case 15:
                                          cellContent =
                                              headerValue
                                                  ?.differenceValues
                                                  ?.netWeight ??
                                              "-";
                                          // Check if there's a difference in net weight
                                          if (_hasDifference(
                                                headerValue?.netWeight,
                                                headerValue
                                                    ?.taggingValues
                                                    ?.netWeight,
                                              ) &&
                                              headerValue
                                                      ?.differenceValues
                                                      ?.netWeight !=
                                                  "0") {
                                            textColor = Colors.red;
                                          }
                                          break;

                                        // For status (case 16):
                                        case 16:
                                          cellContent =
                                              headerValue?.status ?? "-";
                                          // Apply color based on status
                                          textColor = _getStatusColor(
                                            cellContent,
                                          );
                                          break;

                                        case 17:
                                          return _buildActionMenu(headerValue);
                                        default:
                                          cellContent = "1234.123456";
                                      }

                                      return SizedBox(
                                        width: getColumnWidthForSingleTableCell(
                                          totalWidth: totalWidth,
                                          columnWidth:
                                              controller
                                                  .columnWidths[cellIndex],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                            vertical: 4,
                                          ),
                                          child: CustomText(
                                            text: cellContent,
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                            color: textColor,
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
                    ],
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
                      Expanded(
                        flex: 15,
                        child: Center(
                          child: Text(
                            controller
                                    .getVendorListingDetailsResponse
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
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  // Helper method to check if there's a difference in values
  bool _hasDifference(String? value1, String? value2) {
    if (value1 == null || value2 == null) return false;
    return value1 != value2;
  }

  String _getAllPurities(List<LotPurity>? purities) {
    if (purities == null || purities.isEmpty) return "-";
    return purities.map((p) => p.purityType).where((p) => p != null).join(", ");
  }

  Widget _buildActionMenu(GetLotEntriesValue? headerValue) {
    return Theme(
      data: ThemeData(
        focusColor: greyTextColor,
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: CustomPopupMenuButtonWidget<String>(
        icon: const Icon(Icons.more_vert),
        itemBuilder:
            (BuildContext context) =>
                controller.popUpValues.map((element) {
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            element,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (element != controller.popUpValues.last)
                            CustomDashedLineWidget(width: Get.width),
                        ],
                      ),
                    ),
                  );
                }).toList(),
        onSelected: (String value) {
          if (headerValue?.id == null) {
            showErrorToast(
              message: 'Cannot perform this action. Item ID not found.',
            );
            return;
          }

          switch (value) {
            case 'Edit':
              controller.showLotEntryDialog(lotData: headerValue!);
              break;
            case 'Complete':
              // Show confirmation dialog for complete action
              controller.showCompleteConfirmationDialog(headerValue!.id!);
              break;
            case 'Cancel':
              // Show confirmation dialog for cancel action
              controller.showCancelConfirmationDialog(headerValue!.id!);
              break;
            case 'Return':
              controller.onReturnTapped();
              break;
            case 'Delivered':
              controller.onDeliveryTapped();
              break;
          }
        },
      ),
    );
  }
}
