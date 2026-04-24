import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewSalesController extends GetxController {
  // final EstimationRepository estimationRepository = EstimationRepository();
  final AggregateRepository aggregateRepository = AggregateRepository();

  final getSalesRecordByIdAggregateResponse =
      Rx<ApiResponse<GetSalesRecordByIdAggregateResponse>>(
        ApiResponse.initial("Initial"),
      );

  final RxInt currentTabIndex = 0.obs;

  void updateTabIndex(int index) {
    currentTabIndex.value = index;
  }

  Future<void> getSalesRecordByIdAggregate({required String id}) async {
    try {
      getSalesRecordByIdAggregateResponse.value = ApiResponse.loading(
        "Loading",
      );
      final response = await aggregateRepository.getSalesRecordById(id: id);
      getSalesRecordByIdAggregateResponse.value = ApiResponse.completed(
        response,
      );
    } catch (e) {
      getSalesRecordByIdAggregateResponse.value = ApiResponse.error(
        e.toString(),
      );
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }
}

class ViewSalesTabController extends GetxController {
  final RxInt currentTabIndex = 0.obs;

  void updateTabIndex(int index) {
    currentTabIndex.value = index;
  }
}
