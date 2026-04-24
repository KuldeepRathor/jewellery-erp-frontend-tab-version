import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/view_paymnets/model/get_payments_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewPaymentsController extends GetxController {
  final AggregateRepository aggregateRepository = AggregateRepository();

  final getPaymentsByIdResponse = Rx<ApiResponse<GetPaymentsByIdResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getSalesRecordById({required String id}) async {
    try {
      getPaymentsByIdResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await aggregateRepository.getPaymentsById(id: id);
      getPaymentsByIdResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getPaymentsByIdResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      // Get.snackbar("Error", "$e");
      showErrorToast(message: "$e");
    }
  }
}
