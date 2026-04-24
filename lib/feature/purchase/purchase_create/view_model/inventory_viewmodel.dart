import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class InventoryViewmodel extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final Rx<ApiResponse<GetAllOrnamentsResponse>> getAllOrnamentsResponse = Rx(
    ApiResponse.initial("initial"),
  );

  Future<void> getAllOrnaments({
    bool? isStone,
    bool? isOldGold,
    bool? isService,
  }) async {
    try {
      getAllOrnamentsResponse.value = ApiResponse.loading("loading");

      final response = await _inventoryRepository.getAllOrnaments(
        isOldGold: isOldGold,
        isService: isService,
        isStone: isStone,
      );
      getAllOrnamentsResponse.value = ApiResponse.completed(response);
    } catch (e, s) {
      log("Error in getAllOrnaments : $e : $s");
      getAllOrnamentsResponse.value = ApiResponse.error(e.toString());
    }
  }
}
