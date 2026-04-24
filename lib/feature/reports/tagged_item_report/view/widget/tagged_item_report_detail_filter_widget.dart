// tagged_item_report_detail_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view_model/tagged_item_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class TaggedItemReportDetailFilterWidget extends StatelessWidget {
  const TaggedItemReportDetailFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<TaggedItemReportViewModel>();

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
        'taggedBy',
        'dateRange',
        'recordNumber',
        'lotNumber',
        'grossWeight',
        'netWeight',
        'status',
      ],
      onApplyFilters: () {
        viewModel.applyFiltersForDetails();
      },
    );
  }
}
