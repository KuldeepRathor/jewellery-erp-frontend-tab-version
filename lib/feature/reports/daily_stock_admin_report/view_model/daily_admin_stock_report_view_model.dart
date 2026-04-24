import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_admin_report/model/get_admin_daily_stock_count_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class DailyAdminStockReportViewModel extends GetxController {
  final InventoryRepository _repository = InventoryRepository();

  final stockCountResponse = Rx<ApiResponse<GetAdminDailyStockCountResponse>>(
    ApiResponse.initial("Initial"),
  );

  final selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchStockCount();
  }

  Future<void> fetchStockCount() async {
    try {
      stockCountResponse.value = ApiResponse.loading('Loading...');

      final dateFilter = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final response = await _repository.getCounterWiseStockCount(
        dateFilter: dateFilter,
      );

      stockCountResponse.value = ApiResponse.completed(response);
    } catch (e, stack) {
      log('Error fetching stock count: $e $stack');
      stockCountResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load stock count: $e");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      fetchStockCount();
    }
  }
}
