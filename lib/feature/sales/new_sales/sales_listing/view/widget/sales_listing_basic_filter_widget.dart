import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view_model/sales_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class SalesListingBasicFilterWidget extends StatelessWidget {
  const SalesListingBasicFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<SalesListingController>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        // 'metalType',
        'stockHead',
        'design',
        'branch',
        'dateRange',
        'itemStatus',
        'paymentStatus',
        'invoiceStatus',
        'vendor',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
