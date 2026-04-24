import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view_model/tagged_items_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class TaggedItemsDetailsFilterWidget extends StatelessWidget {
  const TaggedItemsDetailsFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<TaggedItemsDetailsController>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        'metalType', // For metal_type_ids
        'ornament', // For ornament_ids
        'weightGroup', // For weight_group_ids
        'stockHead', // For stock_head_ids
        'design', // For design_ids
        'purity', // For purities
        'counter', // For counter_ids
        'vendor', // For vendor_ids
        'grossWeight', // For gross_weight_range
        'netWeight', // For nett_weight_range
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
