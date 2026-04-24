import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/view_model/item_statement_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class ItemStatementReportFilterWidget extends StatelessWidget {
  const ItemStatementReportFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<ItemStatementReportViewModel>();

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
        'other',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
