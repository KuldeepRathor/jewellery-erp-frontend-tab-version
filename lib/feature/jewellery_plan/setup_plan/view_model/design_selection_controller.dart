import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_all_stock_head_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_design_by_stock_head_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class DesignSelectionController extends GetxController {
  // Text Controllers
  final metalTypeSearchController = TextEditingController();
  final InventoryRepository inventoryRepository = InventoryRepository();

  // Observable lists and variables
  final stockHeadValues = <GetAllStockHeadsValue>[].obs;
  final filteredStockHeadValues = <GetAllStockHeadsValue>[].obs;

  final designs = <GetDesignByStockHeadIdValue>[].obs;
  final selectedDesigns = <bool>[].obs;

  final selectAll = true.obs;

  // Metal types related variables
  final stockHeadMetalTypes = <StockHeadMetalTypesResponse>[].obs;
  final selectedStockHeadMetalType = Rxn<StockHeadMetalTypesResponse>();

  // API response states
  final getAllStockHeadsResponse = Rx<ApiResponse<GetAllStockHeadsResponse>>(
    ApiResponse.initial("Initial"),
  );
  final getStockHeadMetalTypeResponse =
      Rx<ApiResponse<List<StockHeadMetalTypesResponse>>>(
        ApiResponse.initial("Initial"),
      );

  @override
  void onInit() {
    super.onInit();
    selectedDesigns.value = List.generate(designs.length, (index) => false);
    getStockHeadMetalTypes();
    getAllStockHeads();
  }

  final selectedDesignsList = <GetDesignByStockHeadIdValue>[].obs;

  void handleSave() {
    final List<GetDesignByStockHeadIdValue> selectedDesignList = [];
    for (int i = 0; i < designs.length; i++) {
      if (selectedDesigns[i]) {
        selectedDesignList.add(designs[i]);
      }
    }
    selectedDesignsList.assignAll(selectedDesignList); // Store selected designs
    Get.back();
  }

  String get selectedDesignsText {
    if (selectedDesignsList.isEmpty) return 'No designs selected';
    return selectedDesignsList.map((design) => design.name ?? '').join(', ');
  }

  // Fetch all stock heads
  Future<void> getAllStockHeads({String query = ""}) async {
    try {
      getAllStockHeadsResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getAllStockHeads(query: query);
      stockHeadValues.value = response.values ?? [];
      filteredStockHeadValues.value = stockHeadValues;
      getAllStockHeadsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching stock heads: $e');
      getAllStockHeadsResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Method to toggle select all
  void toggleSelectAll(bool? value) {
    if (value == null) return;
    selectAll.value = value;
    selectedDesigns.value = List<bool>.filled(designs.length, value);
    // Force refresh
    selectedDesigns.refresh();
  }

  // Method to toggle individual design selection
  void toggleDesignSelection(int index, bool? value) {
    if (value == null) return;
    selectedDesigns[index] = value;
    // Update selectAll based on whether all designs are selected
    selectAll.value = selectedDesigns.every((element) => element == true);
    // Force refresh the list
    selectedDesigns.refresh();
  }

  // Method to set selected metal type and filter stock heads
  void setSelectedStockHeadMetalType(StockHeadMetalTypesResponse? value) async {
    if (value != null) {
      selectedStockHeadMetalType.value = value;
      log('Selected metal type: ${value.id}');
      // Fetch stock heads filtered by metal type
      await getAllStockHeads(query: value.id ?? "");
    }
  }

  void searchDesigns(String query) {
    if (query.isEmpty) {
      // Reset to original designs list
      designs.value = originalDesigns;
    } else {
      // Filter designs based on search query
      designs.value =
          originalDesigns
              .where(
                (design) =>
                    design.name?.toLowerCase().contains(query.toLowerCase()) ??
                    false,
              )
              .toList();
    }
  }

  // Add a variable to store original designs:
  final originalDesigns = <GetDesignByStockHeadIdValue>[].obs;
  Future<void> getDesignsByStockHeadId(String stockHeadId) async {
    try {
      final response = await inventoryRepository.getDesignByStockHeadId(
        stockHeadId,
      );
      originalDesigns.value = response.values ?? [];
      designs.value = originalDesigns;
      selectAll.value = false;
      selectedDesigns.value = List<bool>.filled(designs.length, false);
    } catch (e) {
      log('Error fetching designs: $e');
    }
  }

  Future<void> getStockHeadMetalTypes() async {
    try {
      getStockHeadMetalTypeResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getStockHeadMetalTypes();
      stockHeadMetalTypes.value = response;
      if (stockHeadMetalTypes.isNotEmpty) {
        selectedStockHeadMetalType.value = stockHeadMetalTypes.first;
        // Fetch initial stock heads with first metal type
        await getAllStockHeads(query: stockHeadMetalTypes.first.id ?? "");
      }
      getStockHeadMetalTypeResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching stock head metal types: $e');
      getStockHeadMetalTypeResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Search functionality
  void searchItems(String query) {
    if (query.isEmpty) {
      filteredStockHeadValues.value = stockHeadValues;
    } else {
      filteredStockHeadValues.value =
          stockHeadValues
              .where(
                (item) =>
                    item.name?.toLowerCase().contains(query.toLowerCase()) ??
                    false,
              )
              .toList();
    }
  }

  @override
  void onClose() {
    metalTypeSearchController.dispose();
    super.onClose();
  }
}
