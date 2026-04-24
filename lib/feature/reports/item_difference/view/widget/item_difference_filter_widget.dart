import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/view_model/item_difference_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class ItemDifferenceFilterWidget extends StatelessWidget {
  const ItemDifferenceFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<ItemDifferenceListingViewmodel>();

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
        'minMaxRecordNumber',
        'minMaxLotNumber',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
