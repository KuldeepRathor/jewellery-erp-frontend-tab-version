import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/view_approval_receipt/model/get_approval_receipt_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewApprovalReceiptController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final getInvoiceDetailsResponse =
      Rx<ApiResponse<GetApprovalReceiptByIdResponse>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getInvoiceDetailsById({required String id}) async {
    try {
      getInvoiceDetailsResponse.value = ApiResponse.loading("Loading");
      final response = await _inventoryRepository.getApprovalReceiptById(
        id: id,
      );
      getInvoiceDetailsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getInvoiceDetailsResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }
}
