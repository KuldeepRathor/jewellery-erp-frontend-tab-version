import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stone_statement_report/view_model/stone_statement_report_view_model.dart';

class StoneStatementReportFilterWidget extends StatelessWidget {
  const StoneStatementReportFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<StoneStatementReportViewModel>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        'metalType',
        'ornament',
        'stockHead',
        'weightGroup',
        'design',
        'purity',
        'branch',
        'counter',
        'size',
        'vendor',
        'dateRange',
        'incGrossWeight',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
