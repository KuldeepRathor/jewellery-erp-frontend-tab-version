import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_view/model/get_material_in_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewMaterialInController extends GetxController {
  final InventoryRepository estimationRepository = InventoryRepository();

  final getMaterialInByIdResponse = Rx<ApiResponse<GetMaterialInByIdResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getMaterialInById({required String id}) async {
    try {
      getMaterialInByIdResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await estimationRepository.getMaterialInById(id: id);
      getMaterialInByIdResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getMaterialInByIdResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }
}
