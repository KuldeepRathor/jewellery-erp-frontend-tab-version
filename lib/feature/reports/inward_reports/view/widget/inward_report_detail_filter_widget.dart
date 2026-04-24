// inward_report_detail_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/view_model/inward_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class InwardReportDetailFilterWidget extends StatelessWidget {
  const InwardReportDetailFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<InwardReportViewmodel>();

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
        'status',
        'taggedBy',
        'minMaxGrossWeight',
        'minMaxNetWeight',
      ],
      onApplyFilters: () {
        // Call the specific method for applying filters on details page
        viewModel.applyFiltersForDetails();
      },
    );
  }
}
