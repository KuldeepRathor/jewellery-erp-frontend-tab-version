import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_listing/view/customer_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/view/daily_stock_save_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/view_model/daily_stock_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class DailyStockReports extends GetView<DailyStockReportViewModel> {
  const DailyStockReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: GetBuilder<DailyStockReportViewModel>(
        builder: (_) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: 'Daily Stock',
                  isReport: true,
                  wantBackButton: true,
                  onBackButtonTap: () {
                    Get.back();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildActionBar(context),
                      const SizedBox(height: 16),
                      _buildTabBarAndView(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBarAndView(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.815,
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children:
                  [
                    'All Counter',
                  ].map((type) => _buildStockTable(context)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        tabs: ['All Counter'].map((type) => Tab(text: type)).toList(),
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: primaryColor,
        tabAlignment: TabAlignment.start,
      ),
    );
  }

  Widget _buildStockTable(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildTableStates(context),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 500, child: _buildSearchField()),
        const SizedBox(width: 16),
        _buildFilterButton(context),
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

  Widget _buildFilterButton(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: primaryColor.withBlue(190),
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: PopupMenuButton(
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.transparent,
        elevation: 4,
        itemBuilder:
            (context) => [
              PopupMenuItem(
                enabled: false,
                height: 0,
                padding: EdgeInsets.zero,
                child: AvailableFilterWidget(
                  onSelectionChanged: (selectedTypes) {},
                ),
              ),
            ],
        child: const CustomPopUpIcon(
          buttonName: 'Filter',
          image: 'assets/svgs/filter.svg',
        ),
      ),
    );
  }

  Widget _buildTableStates(BuildContext context) {
    return Obx(() {
      final apiStatus = controller.dailyStockReportList.value.status;
      if (apiStatus == Status.COMPLETED) {
        final data = controller.dailyStockReportList.value.data;
        if (data?.isEmpty ?? true) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTableWidget(
                headers: [buildTableHeaders()],
                columnWidths: controller.columnWidths,
                rows: const [],
                isLoadingMore: false,
                addSizedBox: false,
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
        return ListView(
          controller: controller.scrollController,
          children: [
            CustomTableWidget(
              headers: [buildTableHeaders()],
              columnWidths: controller.columnWidths,
              rows: buildRows(context),
              addSizedBox: true,
            ),
            if (controller.hasMoreData.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      } else if (apiStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else if (apiStatus == Status.ERROR) {
        return Center(
          child: Text(
            controller.dailyStockReportList.value.message ??
                "Something went wrong",
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];
    for (var i = 0; i < controller.headersDailyStock.length; i++) {
      cells.add(
        Row(
          children: [
            Flexible(
              child: CustomText(
                text: controller.headersDailyStock.elementAt(i),
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
      controller.dailyStockReportList.value.data?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final dailyStock = controller.dailyStockReportList.value.data?[index];
    for (int i = 0; i < controller.headersDailyStock.length - 1; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = "${index + 1}";
          break;
        case 1:
          cellContent = dailyStock?.counterName ?? '';
          break;
        case 2:
          cellContent = dailyStock?.totalItems.toString() ?? '';
          break;
      }

      cells.add(
        Column(
          children: [
            InkWell(
              onTap: () {
                controller.controllers.clear();
                controller.sunbmittedSuccess.value = false;
                controller.addRow(dailyStock?.stockHeads ?? []);
                Get.dialog(
                  DailyStockSaveDialog(dailyStockResponseModel: dailyStock!),
                );
              },
              child: Row(
                children: [
                  if (i != 0) const SizedBox(width: 4),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: cellContent,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

    cells.add(
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.4),
            child: Theme(
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
                      ...controller.popUpValues.map((element) {
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
                                if (element != "Delete")
                                  CustomDashedLineWidget(width: Get.width),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                onSelected: (String value) {
                  switch (value) {
                    case 'Edit':
                      break;
                  }
                },
              ),
            ),
          ),
          CustomDashedLineWidget(width: Get.width),
        ],
      ),
    );

    return TableRow(children: cells);
  }
}
