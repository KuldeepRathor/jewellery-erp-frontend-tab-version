import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/customer_purchase/view_model/customer_purchase_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class CustomerPurchaseListingFilterWidget extends StatelessWidget {
  const CustomerPurchaseListingFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<CustomerPurchaseViewModel>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        // 'metalType',
        'dateRange',
        'transactionTypes',
        'paymentStatus',
        'invoiceStatus',
        'ornament',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
