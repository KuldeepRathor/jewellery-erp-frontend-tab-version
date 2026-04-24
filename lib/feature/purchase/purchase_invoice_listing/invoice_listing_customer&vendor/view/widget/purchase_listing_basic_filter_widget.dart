import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view_model/invoice_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class PurchaseListingBasicFilterWidget extends StatelessWidget {
  const PurchaseListingBasicFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<InvoiceListingViewModel>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        'metalType',
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
