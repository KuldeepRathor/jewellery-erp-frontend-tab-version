import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/model/get_stock_issue_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewApprovalIssueController extends GetxController {
  final InventoryRepository _purchaseInvoiceRepository = InventoryRepository();

  final getInvoiceDetailsResponse = Rx<ApiResponse<GetStockIssueByIdResponse>>(
    ApiResponse.initial("Initial"),
  );
  final RxList<String> totalHeadersValue =
      <String>[
        "",
        "Total",
        "",
        "",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "",
      ].obs;
  final columnWidths = [
    0.08, // Sn
    0.2, // Item Code
    0.2, // Tag No
    0.3, // Description
    0.2, // Pcs
    0.3, // G.Wt.
    0.3, // N.Wt.
    0.3, // VA
    0.2, // MC
    0.2, // Stone Cost
    0.2, // Hall Mark
    0.3, // Rate (new)
    0.2, // Cost Discount
    0.3, // Sales Amount
    0.3, // Total
    0.1, // Empty (for actions)
  ];

  final RxInt currentRowIndex = 0.obs;

  void showItemDetails(int index) {
    currentRowIndex.value = index;
  }

  Future<void> getInvoiceDetailsById({required String id}) async {
    try {
      getInvoiceDetailsResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await _purchaseInvoiceRepository.getStockIssueById(
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
