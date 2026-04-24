import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/widget/detail_view_widgets/animated_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/widget/tagged_items_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/widget/detail_view_widgets/tagged_items_details_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view_model/tagged_items_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view_model/tagged_items_image_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class TaggedItemsDetailsPage extends StatefulWidget {
  const TaggedItemsDetailsPage({super.key, this.id});
  final String? id;

  @override
  State<TaggedItemsDetailsPage> createState() => _TaggedItemsDetailsPageState();
}

class _TaggedItemsDetailsPageState extends State<TaggedItemsDetailsPage> {
  final TaggedItemDetailsImageUploadController
  taggedItemDetailsImageUploadController = Get.put(
    TaggedItemDetailsImageUploadController(),
  );
  final TaggedItemsDetailsController controller = Get.put(
    TaggedItemsDetailsController(),
  );
  final ScrollController _scrollController = ScrollController();
  final FocusNode _tableFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getTaggedItemsById(id: widget.id ?? "");
    controller.hideItemDetails();

    // Request focus after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tableFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _tableFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedItem() {
    final selectedIndex = controller.selectedRowIndex.value;
    if (selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 50.0; // Match the height used in buildRow
      final scrollPosition = selectedIndex * itemHeight;

      // Get viewport dimensions
      final viewportHeight = _scrollController.position.viewportDimension;
      final currentScroll = _scrollController.position.pixels;
      final maxScroll = _scrollController.position.maxScrollExtent;

      // Calculate if selected item is visible
      final itemTop = scrollPosition;
      final itemBottom = itemTop + itemHeight;
      final viewportTop = currentScroll;
      final viewportBottom = currentScroll + viewportHeight;

      // Scroll only if item is not fully visible
      if (itemTop < viewportTop || itemBottom > viewportBottom) {
        final targetScroll = (itemTop - viewportHeight / 2 + itemHeight / 2)
            .clamp(0.0, maxScroll);

        _scrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: GestureDetector(
        onTap: () {
          // Request focus when tapping anywhere in the scaffold
          _tableFocusNode.requestFocus();
        },
        child: KeyboardListener(
          focusNode: _tableFocusNode,
          autofocus: true,
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
          child: Actions(
            actions: <Type, Action<Intent>>{
              SaveDesignIntent: CallbackAction<SaveDesignIntent>(
                onInvoke: (intent) {
                  bool isLoading =
                      controller.postDesignResponse.value.status ==
                      Status.LOADING;
                  if (isLoading == false) {
                    _handleSaveOrUpdate();
                  }
                  return;
                },
              ),
            },
            child: Shortcuts(
              shortcuts: <LogicalKeySet, Intent>{
                LogicalKeySet(
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.keyS,
                    ):
                    const SaveDesignIntent(),
              },
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    // Request focus back if lost
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted && !_tableFocusNode.hasFocus) {
                        _tableFocusNode.requestFocus();
                      }
                    });
                  }
                },
                child: Column(
                  children: [
                    const TaggedItemsHeaderWidget(),
                    Expanded(
                      child: Stack(
                        children: [
                          // Main content area
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      _buildActionBar(context),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: _buildOrnamentTypeTable(
                                          controller,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Positioned animated item details widget ABOVE the totals bar
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Obx(
                              () => AnimatedItemDetailsWidget(
                                isVisible:
                                    controller.isItemDetailsVisible.value,
                                onClose: () => controller.hideItemDetails(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Totals bar - always at the bottom
                    Obx(() {
                      final apiStatus =
                          controller
                              .getOrnamentTypeListingResponse
                              .value
                              .status;
                      if (apiStatus == Status.COMPLETED) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          height: 50,
                          color: Colors.white,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Calculate stone column boundaries
                              final totalWidth =
                                  MediaQuery.of(context).size.width;

                              final stoneColumnWidth =
                                  getColumnWidthForSingleTableCell(
                                    totalWidth: totalWidth,
                                    columnWidth: controller.columnWidths[9],
                                  );

                              // Calculate the left position for stone column
                              double stoneColumnLeft = 24; // padding
                              for (int i = 0; i < 9; i++) {
                                stoneColumnLeft +=
                                    getColumnWidthForSingleTableCell(
                                      totalWidth: totalWidth,
                                      columnWidth: controller.columnWidths[i],
                                    );
                              }

                              final stoneData =
                                  controller
                                      .getOrnamentTypeListingResponse
                                      .value
                                      .data
                                      ?.stoneData;

                              final hasStoneData =
                                  stoneData != null && stoneData.isNotEmpty;

                              return Stack(
                                children: [
                                  // Your existing totals bar
                                  ItemListHeaderTable(
                                    headers:
                                        controller.totalHeadersValue.toList(),
                                    columnWidthsCustom: getColumnWidths(
                                      columnWidths: controller.columnWidths,
                                      context: context,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    backgroundColor: totalGreenColor,
                                  ),

                                  // Clickable overlay for stone weight column
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: stoneColumnLeft,
                                    width: stoneColumnWidth,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap:
                                            hasStoneData
                                                ? () {
                                                  controller
                                                      .showStoneDetailsDialog();
                                                }
                                                : null,
                                        child: Container(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizedBox(height: 56);
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrnamentTypeTable(TaggedItemsDetailsController controller) {
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
              "Tagged Items",
              style: TextStyle(fontSize: 16, fontFamily: 'Satoshi'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTableStates(),
            ),
          ),
        ],
      ),
    );
  }
  // Updated _buildTableStates method in tagged_items_details_page.dart

  Widget _buildTableStates() {
    return Obx(() {
      final apiStatus = controller.getOrnamentTypeListingResponse.value.status;
      log("API Status: $apiStatus");

      if (apiStatus == Status.COMPLETED) {
        final lineItems =
            controller.getOrnamentTypeListingResponse.value.data?.lineItems ??
            [];

        if (lineItems.isEmpty) {
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LineWiseCustomTable(
                headers: controller.headers.toList(),
                columnWidths: controller.columnWidths.toList(),
                itemCount: lineItems.length,
                controller: _scrollController,
                isLoadingMore: controller.isLoadingMore.value,
                buildRow: (context, index, totalWidth) {
                  final ornamentDetail = lineItems[index];

                  return SizedBox(
                    height: 50, // Adjust based on your content
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        canRequestFocus: false,
                        onTap: () {
                          controller.showItemDetails(index: index);
                        },
                        child: Obx(
                          () => Container(
                            color:
                                controller.selectedRowIndex.value == index
                                    ? greyTextColor.withOpacity(0.1)
                                    : Colors.transparent,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
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
                                                ornamentDetail.code ?? "-";
                                            break;
                                          case 2:
                                            cellContent =
                                                ornamentDetail.tagNumber == null
                                                    ? ""
                                                    : ornamentDetail.tagNumber
                                                        .toString();
                                            break;
                                          case 3:
                                            cellContent =
                                                ornamentDetail.tagBarcode ??
                                                "-";
                                            break;
                                          case 4:
                                            cellContent =
                                                ornamentDetail.purity ?? "-";
                                            break;
                                          case 5:
                                            cellContent =
                                                ornamentDetail.design?.name ??
                                                "-";
                                            break;
                                          case 6:
                                            cellContent =
                                                ornamentDetail.pieces
                                                    ?.toString() ??
                                                "-";
                                            break;
                                          case 7:
                                            cellContent =
                                                ornamentDetail.netWeight ?? "-";
                                            break;
                                          case 8:
                                            cellContent =
                                                ornamentDetail.grossWeight ??
                                                "-";
                                            break;
                                          case 9:
                                            cellContent =
                                                ornamentDetail.lineStones
                                                    ?.fold<double>(0, (
                                                      sum,
                                                      stone,
                                                    ) {
                                                      double value;
                                                      if (stone.carat != null) {
                                                        value =
                                                            sum +
                                                            (double.tryParse(
                                                                  stone.carat ??
                                                                      "0",
                                                                ) ??
                                                                0);
                                                      } else if (stone.weight !=
                                                          null) {
                                                        double
                                                        convertedToCaratWeight =
                                                            ((double.tryParse(
                                                                      stone.weight ??
                                                                          '0',
                                                                    ) ??
                                                                    0) *
                                                                5);
                                                        value =
                                                            sum +
                                                            convertedToCaratWeight;
                                                      } else {
                                                        value = sum;
                                                      }
                                                      return value;
                                                    })
                                                    .toStringAsFixed(3) ??
                                                "-";
                                            break;
                                          case 10:
                                            cellContent =
                                                ornamentDetail
                                                    .counter
                                                    ?.counterName ??
                                                "-";
                                            break;
                                          case 11:
                                            // Images column
                                            return SizedBox(
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
                                                child: Obx(() {
                                                  int imageCount = 0;
                                                  if (ornamentDetail.id !=
                                                      null) {
                                                    final TaggedItemDetailsImageUploadController
                                                    imageController =
                                                        Get.find<
                                                          TaggedItemDetailsImageUploadController
                                                        >();
                                                    imageCount =
                                                        imageController
                                                            .getImagesForLineItem(
                                                              ornamentDetail
                                                                  .id!,
                                                            )
                                                            .length;
                                                  }

                                                  return imageCount == 0
                                                      ? const Icon(
                                                        Icons
                                                            .file_upload_outlined,
                                                        color: secondaryColor,
                                                        size: 20,
                                                      )
                                                      : CustomText(
                                                        text:
                                                            "$imageCount Image${imageCount > 1 ? 's' : ''}",
                                                        fontSize: 16,
                                                        color: secondaryColor,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        fontFamily: 'Satoshi',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      );
                                                }),
                                              ),
                                            );
                                          case 12:
                                            // Empty column for actions
                                            cellContent = "";
                                            break;
                                          default:
                                            cellContent = "-";
                                            break;
                                        }

                                        if (cellIndex == 11 ||
                                            cellIndex == 12) {
                                          // Already handled above
                                          return cellIndex == 12
                                              ? SizedBox(
                                                width: getColumnWidthForSingleTableCell(
                                                  totalWidth: totalWidth,
                                                  columnWidth:
                                                      controller
                                                          .columnWidths[cellIndex],
                                                ),
                                              )
                                              : const SizedBox.shrink();
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
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                // Add the dashed line at the bottom
                                const CustomDashedLineWidget(
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
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
            const Expanded(child: Center(child: CircularProgressIndicator())),
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
                  controller.getOrnamentTypeListingResponse.value.message ??
                      "Something went wrong",
                ),
              ),
            ),
          ],
        );
      }

      return const SizedBox();
    });
  }

  void _handleSaveOrUpdate() {
    controller.updateTaggedItems(
      id: widget.id ?? "-",
      taggedItemDetailsImageUploadController:
          taggedItemDetailsImageUploadController,
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        const TaggedItemsDetailsFilterWidget(),
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
        // Remove autofocus to prevent stealing keyboard focus
        autofocus: false,
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
        onTap: () {
          // Temporarily remove table focus when search is clicked
        },
        onEditingComplete: () {
          _tableFocusNode.requestFocus();
        },
      ),
    );
  }
}

class CustomFilterDropdown extends StatelessWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;

  const CustomFilterDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text(
            'Filter Metal Type',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          isExpanded: true,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          elevation: 8,
          // Removed itemHeight property
        ),
      ),
    );
  }
}
