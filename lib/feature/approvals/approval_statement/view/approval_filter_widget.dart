// Create a new file: approval_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/view_model/approval_statement_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class ApprovalFilterWidget extends StatelessWidget {
  const ApprovalFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApprovalStatementsController>();

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
        'vendor', // This will be used for partyId
        'dateRange',
        'taggedBy',
        'grossWeight',
        'netWeight',
      ],
      onApplyFilters: () {
        controller.applyFilters();
      },
    );
  }
}
