import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_design_by_stock_head_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_value.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ReorderLevelController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  // API Response states
  final stockHeadsResponse = Rx<ApiResponse<StockHeadResponse>>(
    ApiResponse.initial("Initial"),
  );
  final designsResponse = Rx<ApiResponse<GetDesignByStockHeadIdResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Data lists
  final stockHeads = <StockHeadValue>[].obs;
  final designs = <GetDesignByStockHeadIdValue>[].obs;

  // Selected values
  final selectedStockHead = Rxn<StockHeadValue>();
  final selectedDesign = Rxn<GetDesignByStockHeadIdValue>();

  // Text editing controllers
  late TextEditingController stockHeadController;
  late TextEditingController designController;

  // Debouncer for search
  final _debouncer = CustomDebouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    initializeTextController();
    searchStockHeads("");
  }

  @override
  void onClose() {
    clearControllers();
    super.onClose();
  }

  void initializeTextController() {
    stockHeadController = TextEditingController();
    designController = TextEditingController();
  }

  void clearControllers() {
    log("Called destroy");
    stockHeadController.dispose();
    designController.dispose();
    selectedDesign.value = null;
    selectedStockHead.value = null;
    stockHeads.clear();
    designs.clear();
  }

  // Search stock heads
  void searchStockHeads(String query) {
    _debouncer.run(() async {
      try {
        stockHeadsResponse.value = ApiResponse.loading("Fetching stock heads");
        final response = await _inventoryRepository.getStockHeads(
          query: query,
          limit: 10,
        );
        stockHeads.value = response.values ?? [];
        stockHeadsResponse.value = ApiResponse.completed(response);
      } catch (e) {
        log('Error searching stock heads: $e');
        showErrorToast(message: "Failed to fetch stock heads: $e");
        stockHeadsResponse.value = ApiResponse.error(e.toString());
        stockHeads.clear();
      }
    });
  }

  // Get designs for selected stock head
  Future<void> getDesigns(String stockHeadId) async {
    try {
      designsResponse.value = ApiResponse.loading("Fetching designs");
      designController.clear();
      selectedDesign.value = null;

      final response = await _inventoryRepository.getDesignByStockHeadId(
        stockHeadId,
      );
      designs.value = response.values ?? [];
      designsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching designs: $e');
      showErrorToast(message: "Failed to fetch designs: $e");
      designsResponse.value = ApiResponse.error(e.toString());
      designs.clear();
    }
  }

  // Select stock head
  void selectStockHead(
    StockHeadValue head,
    FocusNode designTextFieldFocusNode,
  ) {
    selectedStockHead.value = head;
    stockHeadController.text = head.name ?? "-";
    getDesigns(head.id ?? "");
    designTextFieldFocusNode.requestFocus();
  }

  // Select design
  void selectDesign(GetDesignByStockHeadIdValue design) {
    selectedDesign.value = design;
    designController.text = '${design.code ?? "-"}   ${design.name ?? "-"}';
  }

  // Check if form is valid
  bool isFormValid() {
    return selectedStockHead.value != null && selectedDesign.value != null;
  }
}
