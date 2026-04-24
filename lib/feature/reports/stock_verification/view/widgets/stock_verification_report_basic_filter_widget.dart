// In stock_verification_report_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view_model/stock_verification_report_view_model.dart';

class StockVerificationReportFilterWidget extends StatelessWidget {
  const StockVerificationReportFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<StockVerificationReportViewModel>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        'metalType',
        'ornament',
        'weightGroup',
        'stockHead',
        'counter',
        'purity',
        'design',
        'vendor',
        'taggedBy',
        'grossWeight',
        'netWeight',
        'dateRange',
        'recordNumber',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
