import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_resturn_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class PurchaseReturnInvoiceInvoiceDeatilsController extends GetxController {
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();

  final getInvoiceDetailsResponse =
      Rx<ApiResponse<PurchaseReturnResponseModel>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getInvoiceDetailsById({required String id}) async {
    try {
      getInvoiceDetailsResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await _purchaseInvoiceRepository
          .getPurchaseReturnInvoiceById(id: id);
      getInvoiceDetailsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getInvoiceDetailsResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      // Get.snackbar("Error", "$e");
      showErrorToast(message: "$e");
    }
  }
}
