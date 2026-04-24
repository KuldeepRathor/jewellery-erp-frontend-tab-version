import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/view_order/model/get_order_details_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewOrderController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final getInvoiceDetailsResponse =
      Rx<ApiResponse<GetOrderDetailsByIdResponse>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getOrderDetailsById({required String id}) async {
    try {
      getInvoiceDetailsResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await estimationRepository.getOrderDetailsById(id: id);
      getInvoiceDetailsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getInvoiceDetailsResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }
}
