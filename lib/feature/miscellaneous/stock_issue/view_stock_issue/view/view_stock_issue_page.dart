import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/model/get_stock_issue_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/view/view_stock_issue_bottom_sticky_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/view/view_stock_issue_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/view_model/view_stock_issue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

class ViewStockIssuePage extends StatefulWidget {
  const ViewStockIssuePage({super.key, required this.id});
  final String id;
  @override
  State<ViewStockIssuePage> createState() => _ViewStockIssuePageState();
}

class _ViewStockIssuePageState extends State<ViewStockIssuePage> {
  final ViewApprovalIssueController stockIssueController = Get.put(
    ViewApprovalIssueController(),
  );

  @override
  void initState() {
    super.initState();
    stockIssueController.getInvoiceDetailsById(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/svgs/auth/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          Obx(() {
            final response =
                stockIssueController.getInvoiceDetailsResponse.value;
            if (response.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            } else if (response.status == Status.ERROR) {
              return Center(child: Text('Error: ${response.message}'));
            } else if (response.status == Status.COMPLETED &&
                response.data != null) {
              final data = response.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    header: 'View Stock Issue',
                    wantBackButton: true,
                    onBackButtonTap: () {
                      SidebarController sidebarController = Get.find();
                      log("Popping values from ");
                      sidebarController.popBackSelectedWidget();
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildIssueDetailsSection(data),
                            const SizedBox(height: 16),
                            ViewStockIssueItemDetailsWidget(data: data),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const ViewStockIssueBottomStickyWidget(),
                ],
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          }),
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> getColumnWidths({
    required List<double> columnWidths,
    required BuildContext context,
  }) {
    Map<int, TableColumnWidth> widths = {};
    for (int i = 0; i < columnWidths.length; i++) {
      widths[i] = FixedColumnWidth(
        (MediaQuery.of(context).size.width - 32) * (columnWidths[i] / 4),
      );
    }
    return widths;
  }

  Widget _buildIssueDetailsSection(GetStockIssueByIdResponse data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailField(
                  "Issue Date",
                  formatDate(data.issueDate),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailField(
                  "Issue Number",
                  data.issueInvoiceNumber ?? '-',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildDetailField("Reason", data.reason ?? '-')),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Remarks",
                      fontSize: 12,
                      color: primaryTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: grey1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          child: CustomText(
                            text: data.remarks ?? "",
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 12,
          color: primaryTextColor,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 8),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: grey1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: value,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return "${date.day}-${date.month}-${date.year}";
  }
}
