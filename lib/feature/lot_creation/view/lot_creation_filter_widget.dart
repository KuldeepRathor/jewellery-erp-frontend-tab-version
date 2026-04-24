import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/view_model/lot_creation_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/report_filter_widget.dart';

class LotCreationFilterWidget extends StatelessWidget {
  const LotCreationFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<LotCreationViewModel>();

    return ReportFilterWidget(
      controller: viewModel.filterController,
      visibleFilters: const [
        'dateRange',
        'netWeight',
        'grossWeight',
        'lotNumber',
        'purity',
        'branch',
        // 'status',
        'vendor',
      ],
      onApplyFilters: () {
        viewModel.applyFiltersFromController();
      },
    );
  }
}
