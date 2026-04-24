// detailed_sales_summary_basic_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/view_model/detailed_sales_summary_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class DetailedSalesSummaryBasicFilterWidget extends StatelessWidget {
  const DetailedSalesSummaryBasicFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<DetailedSalesSummaryController>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const ['metalType', 'branch', 'dateRange', 'taggedBy'],
      onApplyFilters: viewModel.applyFilters,
    );
  }
}
