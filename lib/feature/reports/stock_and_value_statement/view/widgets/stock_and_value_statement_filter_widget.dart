import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/view_model/stock_and_value_statement_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class StockAndValueStatementReportFilterWidget extends StatelessWidget {
  const StockAndValueStatementReportFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<StockAndValueStatementReportViewModel>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        'metalType',
        'ornament',
        'purity',
        'branch',
        'vendor',
        'dateRange',
        'incGrossWeight',
        'incAmount',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
