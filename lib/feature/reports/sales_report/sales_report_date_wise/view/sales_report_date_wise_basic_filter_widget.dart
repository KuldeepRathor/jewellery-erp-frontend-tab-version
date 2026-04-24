// sales_report_date_wise_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_date_wise/view_model/sales_report_date_wise_controller.dart';

class SalesReportDateWiseFilterWidget extends StatelessWidget {
  const SalesReportDateWiseFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesReportDateWiseController>();

    return ReportFilterWidget(
      controller: controller.filterController,
      visibleFilters: const ['dateRange'],
      onApplyFilters: () {
        controller.applyFilters();
      },
    );
  }
}
