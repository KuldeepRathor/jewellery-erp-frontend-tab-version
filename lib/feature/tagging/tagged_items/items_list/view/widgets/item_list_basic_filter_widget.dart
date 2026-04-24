import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/item_list_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class ItemListFilterWidget extends StatelessWidget {
  const ItemListFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<ItemListViewModel>();

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
        'grossWeight',
        'netWeight',
      ],
      onApplyFilters: () {
        viewModel.applyFilters();
      },
    );
  }
}
