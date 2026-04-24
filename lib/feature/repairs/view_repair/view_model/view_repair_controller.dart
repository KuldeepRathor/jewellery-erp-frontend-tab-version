import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/model/get_repair_details_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewRepairController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final getRepairDetailsResponse =
      Rx<ApiResponse<GetRepairDetailsByIdResponse>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getRepairDetailsById({required String id}) async {
    try {
      getRepairDetailsResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await estimationRepository.getRepairDetailsById(id: id);
      getRepairDetailsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getRepairDetailsResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }
}
