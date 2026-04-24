import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/view/widget/item_difference_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/view_model/item_difference_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:svg_flutter/svg_flutter.dart';

class ItemDifferenceListing extends StatefulWidget {
  const ItemDifferenceListing({super.key});

  @override
  State<ItemDifferenceListing> createState() => _ItemDifferenceListingState();
}

class _ItemDifferenceListingState extends State<ItemDifferenceListing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ItemDifferenceListingViewmodel controller = Get.put(
    ItemDifferenceListingViewmodel(),
  );
  final ScrollController _scrollController = ScrollController();
  final FocusNode _tableFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    controller.setInitialConditions(isSearch: false);
    controller.getItemDifferenceReportDetails(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tableFocusNode.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.getItemDifferenceReportDetails();
    }
  }

  void _scrollToSelectedItem() {
    final selectedIndex = controller.selectedRowIndex.value;
    if (selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 54.0; // Approximate height of ListTile
      final scrollPosition = selectedIndex * itemHeight;

      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: KeyboardListener(
        focusNode: _tableFocusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              controller.selectPreviousRow();
              _scrollToSelectedItem();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              controller.selectNextRow();
              _scrollToSelectedItem();
            }
          }
        },
        child: ActionScopeWidget(
          onNewButtonTap: () {}, // No new action needed for report
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                header: 'Item Difference',
                isReport: true,
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
                      _buildTaggedItemDetailsHeader(),
                      _buildItemDifferenceTable(controller),
                      // const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Obx(() => _buildBottomDetailsWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaggedItemDetailsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Text(
            'Tagged Item Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 24),
          Obx(
            () => Text(
              controller.getFormattedDateRange(),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomDetailsWidget() {
    return Container(
      width: double.infinity,
      height: 200,
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top sticky indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(color: primaryColor),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Details grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Customer',
                            controller.selectedCustomer.value,
                          ),
                          _buildDetailRow(
                            'No',
                            controller.selectedInvoiceNo.value,
                          ),
                          _buildDetailRow(
                            'Txn type',
                            controller.selectedTxnType.value,
                          ),
                          _buildDetailRow(
                            'Time',
                            controller.selectedTime.value,
                          ),
                          _buildDetailRow(
                            'User',
                            controller.selectedUser.value,
                          ),
                        ],
                      ),
                    ),

                    // Middle column
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Head',
                            controller.selectedHead.value,
                          ),
                          _buildDetailRow(
                            'Ornament Type',
                            controller.selectedOrnamentType.value,
                          ),
                          _buildDetailRow(
                            'Item Group',
                            controller.selectedItemGroup.value,
                          ),
                          _buildDetailRow(
                            'Counter',
                            controller.selectedCounter.value,
                          ),
                          _buildDetailRow(
                            'Barcode No',
                            controller.selectedBarcodeNo.value,
                          ),
                        ],
                      ),
                    ),

                    // Right column
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Gross wt',
                            controller.selectedGrossWt.value,
                          ),
                          _buildDetailRow(
                            'Stone cost',
                            controller.selectedStoneCost.value,
                          ),
                        ],
                      ),
                    ),

                    // Image column
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/jewelry_placeholder.png',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                                size: 32,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label : ',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const ItemDifferenceFilterWidget(),
        const Spacer(),
        CustomButton2(
          onTap: () {
            controller.downloadReportDetails();
          },
          image: 'assets/svgs/download.svg',
          buttonName: 'Download',
        ),
        const SizedBox(width: 16),
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
        onChanged: controller.setSearchQuery,
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

  Widget _buildItemDifferenceTable(ItemDifferenceListingViewmodel controller) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Obx(() {
          final apiStatus =
              controller.itemDifferenceReportResponse.value.status;

          if (apiStatus == Status.COMPLETED) {
            final data = controller.itemDifferenceReportResponse.value.data;
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
                          (context, index, totalWidth) => const SizedBox(),
                      isLoadingMore: false,
                      addBottomSpace: false,
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

            // Return a Column with the table and total row
            return Column(
              children: [
                Expanded(
                  child: LineWiseCustomTable(
                    headers: controller.headers.toList(),
                    columnWidths: controller.columnWidths.toList(),
                    itemCount: data?.values?.length ?? 0,
                    controller: _scrollController,
                    isLoadingMore: controller.isLoadingMore.value,
                    buildRow: (context, index, totalWidth) {
                      final itemDetail = data?.values?.elementAt(index);

                      return SizedBox(
                        height: 54,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            canRequestFocus: false,
                            onTap: () {
                              controller.updateSelectedRow(index, itemDetail);
                            },
                            child: Obx(
                              () => Container(
                                color:
                                    controller.selectedRowIndex.value == index
                                        ? greyTextColor
                                        : Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: List.generate(
                                      controller.headers.length,
                                      (cellIndex) {
                                        String cellContent = "-";
                                        Color textColor = Colors.black;

                                        switch (cellIndex) {
                                          case 0: // Date
                                            cellContent =
                                                itemDetail?.createdAt != null
                                                    ? convertDateTimeToString(
                                                      itemDetail?.createdAt,
                                                    )
                                                    : "-";
                                            break;
                                          case 1: // Code
                                            cellContent =
                                                "${itemDetail?.code} - ${itemDetail?.tag}";
                                            break;
                                          case 2: // Description
                                            cellContent =
                                                itemDetail?.description ?? "-";
                                            break;
                                          case 3: // Pc
                                            cellContent =
                                                itemDetail?.pieces
                                                    ?.toString() ??
                                                "-";
                                            break;
                                          case 4: // Act. Net Wt
                                            cellContent =
                                                itemDetail?.actualWeight ?? "-";
                                            break;
                                          case 5: // Sales Wt
                                            cellContent =
                                                itemDetail?.salesWeight ?? "-";
                                            break;
                                          case 6: // Difference
                                            cellContent =
                                                itemDetail?.difference ?? "-";
                                            if (itemDetail?.difference !=
                                                null) {
                                              // If difference is negative, show in red
                                              final diff = double.tryParse(
                                                itemDetail!.difference!
                                                    .replaceAll(
                                                      RegExp(r'[^0-9.-]'),
                                                      '',
                                                    ),
                                              );
                                              if (diff != null && diff < 0) {
                                                textColor = redTextColor;
                                              }
                                            }
                                            break;
                                          case 7: // Amount
                                            cellContent =
                                                itemDetail?.amount ?? "-";
                                            break;
                                          default:
                                            cellContent = "-";
                                            break;
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
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0,
                                            ),
                                            child: Tooltip(
                                              message: cellContent,
                                              child: CustomText(
                                                text: cellContent,
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: 'Satoshi',
                                                fontWeight: FontWeight.w500,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Total row outside the scrollable area
                LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildTotalRow(constraints.maxWidth);
                  },
                ),
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
                    buildRow: (context, index, totalWidth) => const SizedBox(),
                    addBottomSpace: false,
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
                    buildRow: (context, index, totalWidth) => const SizedBox(),
                    addBottomSpace: false,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      controller.itemDifferenceReportResponse.value.message ??
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
    );
  }

  Widget _buildTotalRow(double totalWidth) {
    final ItemDifferenceListingViewmodel controller =
        Get.find<ItemDifferenceListingViewmodel>();

    return Obx(
      () => Container(
        height: 54,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF329464), // Green color from the image
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: List.generate(controller.headers.length, (cellIndex) {
              String cellContent = "";

              // Set the appropriate total values for the total row
              switch (cellIndex) {
                case 0:
                  cellContent = "Nett";
                  break;

                case 3: // Pieces
                  cellContent = controller.totalPieces.value;
                  break;
                case 4: // Actual Weight
                  cellContent = controller.totalActualWeight.value;
                  break;
                case 5: // Sales Weight
                  cellContent = controller.totalSalesWeight.value;
                  break;
                case 6: // Difference
                  cellContent = controller.totalDifference.value;
                  break;
                case 7: // Amount
                  cellContent = controller.totalAmount.value;
                  break;
                default:
                  cellContent = "";
                  break;
              }

              return SizedBox(
                width: getColumnWidthForSingleTableCell(
                  totalWidth: totalWidth,
                  columnWidth: controller.columnWidths[cellIndex],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CustomText(
                    text: cellContent,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
