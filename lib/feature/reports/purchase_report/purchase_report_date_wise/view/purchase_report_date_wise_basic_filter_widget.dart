// sales_report_date_wise_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_date_wise/view_model/purchase_report_date_wise_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class PurchaseReportDateWiseFilterWidget extends StatelessWidget {
  const PurchaseReportDateWiseFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PurchaseReportDateWiseController>();

    return ReportFilterWidget(
      controller: controller.filterController,
      visibleFilters: const ['dateRange'],
      onApplyFilters: () {
        controller.applyFilters();
      },
    );
  }
}
