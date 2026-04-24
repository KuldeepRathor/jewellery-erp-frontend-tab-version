import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/view_model/sales_return_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class SalesReturnFilterWidget extends StatelessWidget {
  const SalesReturnFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<SalesReturnListingController>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        'metalType',
        'dateRange',
        'invoiceStatus',
        'pendingAmount',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
