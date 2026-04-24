import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/view_estimate/model/get_estimate_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewEstimationController extends GetxController {
  // final EstimationRepository estimationRepository = EstimationRepository();
  final AggregateRepository aggregateRepository = AggregateRepository();

  final getEstimateByIdResponse = Rx<ApiResponse<GetEstimateByIdResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxInt currentTabIndex = 0.obs;

  void updateTabIndex(int index) {
    currentTabIndex.value = index;
  }

  Future<void> getEstimationRecordByIdAggregate({required String id}) async {
    try {
      getEstimateByIdResponse.value = ApiResponse.loading("Loading");
      final response = await aggregateRepository.getEstimationdById(id: id);
      getEstimateByIdResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getEstimateByIdResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }
}
