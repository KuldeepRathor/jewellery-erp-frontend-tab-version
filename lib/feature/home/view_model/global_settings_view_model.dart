import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/model/get_global_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class GlobalSettingsViewModel extends GetxController {
  // final EstimationRepository estimationRepository = EstimationRepository();
  final AggregateRepository aggregateRepository = AggregateRepository();

  final getGlobalSettingsResponse = Rx<ApiResponse<GetGlobalSettingsResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getGlobalSettings() async {
    try {
      getGlobalSettingsResponse.value = ApiResponse.loading("Loading");
      final response = await aggregateRepository.getGlobalSettings();
      getGlobalSettingsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getGlobalSettingsResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }
}
