import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/stock_verification_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view/widgets/stock_verification_footer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view/widgets/stock_verification_report_animated_item_report_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view/widgets/stock_verification_report_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view_model/stock_verification_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view_model/stock_verification_upload_image_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:svg_flutter/svg.dart';

class StockVerificationReportsPage extends StatefulWidget {
  const StockVerificationReportsPage({super.key, this.id});
  final String? id;

  @override
  State<StockVerificationReportsPage> createState() =>
      _StockVerificationReportsPageState();
}

class _StockVerificationReportsPageState
    extends State<StockVerificationReportsPage> {
  final StockVerificationReportViewModel stockVerificationViewModel = Get.put(
    StockVerificationReportViewModel(),
  );
  final StockVerificationImageUploadController imageUploadController = Get.put(
    StockVerificationImageUploadController(),
  );

  final FocusNode _tableFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    stockVerificationViewModel.setInitialConditions(isSearch: false);
    stockVerificationViewModel.getStockVerificationList(resetList: true).then((
      _,
    ) {
      if ((stockVerificationViewModel
                  .stockVerificationList
                  .value
                  .data
                  ?.isNotEmpty ??
              false) &&
          stockVerificationViewModel.stockVerificationList.value.status ==
              Status.COMPLETED) {
        stockVerificationViewModel.showItemDetails(index: 0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tableFocusNode.dispose();
    super.dispose();
  }

  void _scrollToSelectedItem() {
    final selectedIndex = stockVerificationViewModel.selectedItemIndex.value;
    if (selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 48.0; // Approximate height of row
      final scrollPosition = selectedIndex * itemHeight;

      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final currentIndex = stockVerificationViewModel.selectedItemIndex.value;
      final itemCount =
          stockVerificationViewModel.stockVerificationList.value.data?.length ??
          0;

      if (event.logicalKey == LogicalKeyboardKey.arrowUp && currentIndex > 0) {
        stockVerificationViewModel.showItemDetails(index: currentIndex - 1);
        _scrollToSelectedItem();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
          currentIndex < itemCount - 1) {
        stockVerificationViewModel.showItemDetails(index: currentIndex + 1);
        _scrollToSelectedItem();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
        },
        child: Actions(
          actions: {
            DiscardIntent: CallbackAction<DiscardIntent>(
              onInvoke: (intent) {
                stockVerificationViewModel.resetScannedItems();

                return;
              },
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: Focus(
              focusNode: _tableFocusNode,
              onKeyEvent: _handleKeyEvent,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderWidget(header: "Item Verification"),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    _buildActionBar(context),
                                    const SizedBox(height: 16),
                                    _buildCustomTable(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Obx(
                            () =>
                                StockVerificationReportAnimatedItemDetailsWidget(
                                  isVisible:
                                      stockVerificationViewModel
                                          .isItemDetailsVisible
                                          .value,
                                  onClose:
                                      () =>
                                          stockVerificationViewModel
                                              .hideItemDetails(),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const StockVerificationFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTableHeader(),
              Expanded(child: _buildTableContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children:
            stockVerificationViewModel.headers
                .asMap()
                .entries
                .map(
                  (entry) => Expanded(
                    flex:
                        (stockVerificationViewModel.columnWidths[entry.key] *
                                100)
                            .toInt(),
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildTableContent() {
    return Obx(() {
      final apiStatus =
          stockVerificationViewModel.stockVerificationList.value.status;
      final selectedIndex = stockVerificationViewModel.selectedItemIndex.value;
      final filteredList = stockVerificationViewModel.getFilteredList();

      if (apiStatus == Status.COMPLETED) {
        if (filteredList.isEmpty) {
          return Center(
            child: SvgPicture.asset('assets/svgs/error/no_records_found.svg'),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            return Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap:
                      () => stockVerificationViewModel.showItemDetails(
                        index: index,
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xffE6E8FF) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildTableRow(index, filteredList[index]),
                  ),
                ),
                if (index == filteredList.length - 1)
                  SizedBox(height: MediaQuery.of(context).size.height * 0.33),
              ],
            );
          },
        );
      } else if (apiStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Center(
          child: Text(
            stockVerificationViewModel.stockVerificationList.value.message ??
                'Error loading data',
          ),
        );
      }
    });
  }

  Widget _buildTableRow(int index, GetStockVerificationReportResponse item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: [
          // Status
          Expanded(
            flex: 20,
            child:
                (item.isScanned == true)
                    ? const Icon(Icons.check)
                    : const SizedBox.shrink(),
          ),
          // Tag Number
          Expanded(
            flex: 20,
            child: CustomText(
              text: "${item.code?.toString()} - ${item.tagNumber?.toString()}",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Barcode
          Expanded(
            flex: 20,
            child: CustomText(
              text: item.tagBarcode ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Item/Design Name - will need to be fetched separately
          Expanded(
            flex: 80,
            child: CustomText(
              text: item.design?.name ?? '-', // Will be shown in details view
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Pieces
          Expanded(
            flex: 25,
            child: CustomText(
              text: item.pieces?.toString() ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Gross Weight
          Expanded(
            flex: 35,
            child: CustomText(
              text: item.grossWeight ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Net Weight
          Expanded(
            flex: 35,
            child: CustomText(
              text: item.netWeight ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Tagged By
          Expanded(
            flex: 35,
            child: CustomText(
              text: item.employeeDetails?.code ?? "-",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Tagged Date
          Expanded(
            flex: 25,
            child: CustomText(
              text: stockVerificationViewModel.getFormattedDate(item.createdAt),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Actions
          Expanded(
            flex: 10,
            child: Column(
              children: [
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
                          ...stockVerificationViewModel.popUpValues.map((
                            element,
                          ) {
                            return PopupMenuItem<String>(
                              value: element,
                              height: 0,
                              child: SizedBox(
                                width: 120,
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
                                    CustomDashedLineWidget(width: Get.width),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                    onSelected: (String value) {
                      switch (value) {
                        case 'View Item':
                          stockVerificationViewModel.showItemDetails(
                            index: index,
                          );
                          break;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 3, child: _buildSearchField()),
        const SizedBox(width: 16),
        Flexible(flex: 1, child: _buildStatusFilterDropdown()),
        const StockVerificationReportFilterWidget(),
        const Spacer(),
        // const TaggedItemReportBasicFilterWidget(),
      ],
    );
  }

  Widget _buildStatusFilterDropdown() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: stockVerificationViewModel.selectedFilterStatus.value,
            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            isExpanded: true,
            hint: const Text('Filter by Status'),
            onChanged: (String? newValue) {
              if (newValue != null) {
                stockVerificationViewModel.setFilterStatus(newValue);
              }
            },
            items:
                stockVerificationViewModel.filterStatusOptions
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          stockVerificationViewModel.getStatusCountText(value),
                        ),
                      );
                    })
                    .toList(),
          ),
        ),
      ),
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
        onChanged: stockVerificationViewModel.setSearchQuery,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search by tag number, barcode or item name',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }
}
