import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view_model/tagged_items_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class TaggedItemsFilterWidget extends StatelessWidget {
  const TaggedItemsFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put<TaggedItemsListingViewModel>(
      TaggedItemsListingViewModel(),
    );

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        'taggedBy', // For tagged_by_ids
        'branch', // For branch_ids
        'dateRange', // For date_range
        'grossWeight', // For gross_weight_range
        'netWeight', // For nett_weight_range (mapped to netWeight)
        'lotNumber', // For lot_number_range
        'recordNumber', // For tag_record_number_range
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
