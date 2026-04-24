import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view_model/outward_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class OutwardReportFilterWidget extends StatelessWidget {
  const OutwardReportFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final OutwardReportViewmodel controller = Get.find();

    return ReportFilterWidget(
      controller: controller.filterController,
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
        controller.applyFilters();
      },
    );
  }
}
