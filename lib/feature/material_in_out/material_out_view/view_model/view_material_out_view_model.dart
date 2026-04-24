import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_view/model/get_material_out_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewMaterialOutController extends GetxController {
  final InventoryRepository estimationRepository = InventoryRepository();

  final getMaterialOutByIdResponse =
      Rx<ApiResponse<GetMaterialOutByIdResponse>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getMaterialOutById({required String id}) async {
    try {
      getMaterialOutByIdResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await estimationRepository.getMaterialOutById(id: id);
      getMaterialOutByIdResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getMaterialOutByIdResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }
}
