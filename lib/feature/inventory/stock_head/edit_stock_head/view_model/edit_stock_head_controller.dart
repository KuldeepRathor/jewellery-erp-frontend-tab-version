import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/model/edit_stock_head_request.dart'
    as edit_model;
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/model/get_stock_head_by_id.dart';
// import 'package:jewellery_erp_frontend_tab_version/model/stock_head/add_stock_head_request.dart'
//     hide WeightGroup, SizeGroup;

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/view_model/edit_size_group_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/view_model/edit_weight_group_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/stock_head_listing/view_model/stock_head_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
// import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EditStockHeadController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final SidebarController sidebarController = Get.find();

  final StockHeadListingController stockHeadListingController = Get.find();

  final EditWeightGroupController weightGroupController = Get.put(
    EditWeightGroupController(),
  );
  final EditSizeGroupController sizeGroupController = Get.put(
    EditSizeGroupController(),
  );

  final Rx<CategoriesResponse?> selectedCategories = Rx<CategoriesResponse?>(
    null,
  );
  final RxList<CategoriesResponse> categories = <CategoriesResponse>[].obs;

  final Rx<StockHeadMetalTypesResponse?> selectedStockHeadMetalType =
      Rx<StockHeadMetalTypesResponse?>(null);
  final RxList<StockHeadMetalTypesResponse> stockHeadMetalTypes =
      <StockHeadMetalTypesResponse>[].obs;

  final stockHeadCodeController = TextEditingController();
  final stockHeadNameController = TextEditingController();

  final hallMarkChargesController = TextEditingController();
  final RxBool isHallMarkRequired = false.obs;

  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;

  final _deboncer = CustomDebouncer(milliseconds: 500);

  // final getStockHeadListingResponse = Rx<ApiResponse<StockHeadResponse>>(
  //   ApiResponse.initial("Initial"),
  // );

  @override
  void onInit() {
    log("Stock Head initialized");
    // getStockHeadMetalTypes();
    // getCategories();
    super.onInit();
  }

  void populateStockHeadData() {
    final stockHeadDetails = getStockHeadByIdResponse.value.data;
    if (stockHeadDetails != null) {
      // Populate basic details
      stockHeadCodeController.text = stockHeadDetails.code ?? '';
      stockHeadNameController.text = stockHeadDetails.name ?? '';

      // Populate hallmark charges
      if (stockHeadDetails.hallmarkExtraCharge != null) {
        isHallMarkRequired.value = true;
        hallMarkChargesController.text =
            stockHeadDetails.hallmarkExtraCharge!.toString();
      }

      // Set metal type
      if (stockHeadDetails.metalType != null) {
        final metalType = stockHeadMetalTypes.firstWhereOrNull(
          (type) => type.id == stockHeadDetails.metalType!.id,
        );
        if (metalType != null) {
          selectedStockHeadMetalType.value = metalType;
        }
      }

      // Set category
      if (stockHeadDetails.category != null) {
        final category = categories.firstWhereOrNull(
          (cat) => cat.id == stockHeadDetails.category!.id,
        );
        if (category != null) {
          selectedCategories.value = category;
        }
      }

      weightGroupController.rows.clear();
      if (stockHeadDetails.weightGroups != null) {
        for (var group in stockHeadDetails.weightGroups!) {
          weightGroupController.rows.add(
            WeightGroupRow(
              code: TextEditingController(text: group.code),
              name: TextEditingController(text: group.name),
              minWeight: TextEditingController(text: group.minWeight),
              maxWeight: TextEditingController(text: group.maxWeight),
              id: group.id,
            ),
          );
        }
      }

      sizeGroupController.rows.clear();
      if (stockHeadDetails.sizeGroups != null) {
        sizeGroupController.setSizeRequired(
          stockHeadDetails.sizeRequired ?? false,
        );
        for (var group in stockHeadDetails.sizeGroups!) {
          sizeGroupController.rows.add(
            SizeGroupRow(
              code: TextEditingController(text: group.code),
              size: TextEditingController(text: group.size),
              id: group.id,
            ),
          );
        }
      }

      if (weightGroupController.rows.isEmpty) {
        weightGroupController.addRow();
      }
      if (sizeGroupController.rows.isEmpty) {
        sizeGroupController.addRow();
      }
      weightGroupController.initializeCodeAvailability();
      sizeGroupController.initializeCodeAvailability();
    }
  }

  void checkCodeAvailability(String code, String model) {
    if (code.isEmpty) {
      isCodeAvailable.value = true;
      isCheckingCode.value = false;
      return;
    }
    isCheckingCode.value = true;
    _deboncer.run(() async {
      try {
        final isAvailable = await inventoryRepository.validateCode(code, model);
        isCodeAvailable.value = isAvailable;
      } catch (e) {
        showErrorToast(message: "Failed to check code Availability");
      } finally {
        isCheckingCode.value = false;
      }
    });
  }

  final Rx<ApiResponse<GetStockHeadById>> getStockHeadByIdResponse =
      Rx<ApiResponse<GetStockHeadById>>(ApiResponse.initial("Initial"));

  Future<void> fetchStockHeadDetails(String stockHeadId) async {
    try {
      getStockHeadByIdResponse.value = ApiResponse.loading("Loading");
      if (categories.isEmpty) {
        await getCategories();
      }

      if (stockHeadMetalTypes.isEmpty) {
        await getStockHeadMetalTypes();
      }
      final response = await inventoryRepository.getStockHeadById(stockHeadId);
      getStockHeadByIdResponse.value = ApiResponse.completed(response);
      populateStockHeadData();
    } catch (e) {
      log('Error fetching stock head details: $e');
      getStockHeadByIdResponse.value = ApiResponse.error(e.toString());
    }
  }

  final getCategoriesResponse = Rx<ApiResponse<List<CategoriesResponse>>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> getCategories() async {
    try {
      getCategoriesResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getCategories();
      getCategoriesResponse.value = ApiResponse.completed(response);
      categories.value = response;
      if (categories.isNotEmpty) {
        selectedCategories.value = categories.first;
      }
    } catch (e) {
      log('Error fetching categories: $e');
      getCategoriesResponse.value = ApiResponse.error(e.toString());
    }
  }

  final getStockHeadMetalTypeResponse =
      Rx<ApiResponse<List<StockHeadMetalTypesResponse>>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getStockHeadMetalTypes() async {
    try {
      getStockHeadMetalTypeResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getStockHeadMetalTypes();
      stockHeadMetalTypes.value = response;
      if (stockHeadMetalTypes.isNotEmpty) {
        selectedStockHeadMetalType.value = stockHeadMetalTypes.first;
      }
      getStockHeadMetalTypeResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching stock head metal types: $e');
      getStockHeadMetalTypeResponse.value = ApiResponse.error(e.toString());
    }
  }

  void setSelectedStockHeadMetalType(StockHeadMetalTypesResponse? value) {
    selectedStockHeadMetalType.value = value;
    // getStockHeadListingDetails();
  }

  final editStockHeadRequest = Rx<ApiResponse<edit_model.EditStockHeadRequest>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> editStockHead({int currentTab = 0}) async {
    try {
      log("Current tab $currentTab");
      // Collect all validation errors
      List<String> errors = [];

      if (stockHeadNameController.text.isEmpty) {
        errors.add("Stock Head Name is required");
      }

      if (weightGroupController.rows.isEmpty) {
        errors.add("At least one weight group is required");
      }

      if (sizeGroupController.isRequired.value == true) {
        if (!sizeGroupController.validateAllCodes()) {
          errors.add("Please check Size groups");
        }
      }

      if (errors.isNotEmpty) {
        for (String error in errors) {
          showErrorToast(message: error);
        }
        return;
      }

      editStockHeadRequest.value = ApiResponse.loading("Loading");

      // Filter out empty weight groups and add IDs
      final validWeightGroups =
          weightGroupController.rows
              .where(
                (row) =>
                    row.name.text.isNotEmpty &&
                    row.code.text.isNotEmpty &&
                    row.minWeight.text.isNotEmpty &&
                    row.maxWeight.text.isNotEmpty,
              )
              .map(
                (row) => edit_model.WeightGroup(
                  name: row.name.text,
                  code: row.code.text,
                  minWeight: row.minWeight.text,
                  maxWeight: row.maxWeight.text,
                  id: row.id,
                ),
              )
              .toList();

      // Filter out empty size groups and add IDs
      final validSizeGroups =
          sizeGroupController.rows
              .where(
                (row) => row.code.text.isNotEmpty && row.size.text.isNotEmpty,
              )
              .map(
                (row) => edit_model.SizeGroup(
                  code: row.code.text,
                  size: row.size.text,
                  id: row.id,
                ),
              )
              .toList();

      // Get stockHeadId from getStockHeadByIdResponse
      final stockHeadId = getStockHeadByIdResponse.value.data?.id;
      if (stockHeadId == null) {
        showErrorToast(message: "Stock Head ID not found");
        return;
      }

      final editStockRequest = edit_model.EditStockHeadRequest(
        id: stockHeadId,
        name: stockHeadNameController.text,
        isNetWeight: weightGroupController.isNettWtSelected.value,
        sizeRequired: sizeGroupController.isRequired.value,
        weightGroups: validWeightGroups,
        sizeGroups: validSizeGroups,
        category: edit_model.CategoryRequest(id: selectedCategories.value?.id),
      );

      final response = await inventoryRepository.editStockHead(
        stockHeadId,
        editStockRequest,
      );
      editStockHeadRequest.value = ApiResponse.completed(response);

      showSuccessToast(message: "Stock Head Updated Successfully");
      resetFields();
      sidebarController.popBackSelectedWidget();
    } catch (e, s) {
      log("Error in editing stock head $s");
      editStockHeadRequest.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to edit Stock Head: ${e.toString()}");
    }
  }

  void setSelectedCategories(CategoriesResponse? value) {
    selectedCategories.value = value;
  }

  void resetFields() {
    stockHeadCodeController.clear();
    stockHeadNameController.clear();
    hallMarkChargesController.clear();
    isHallMarkRequired.value = false;
    isCodeAvailable.value = true;
    isCheckingCode.value = false;
    selectedCategories.value = categories.isNotEmpty ? categories.first : null;
    selectedStockHeadMetalType.value =
        stockHeadMetalTypes.isNotEmpty ? stockHeadMetalTypes.first : null;

    // Reset Weight and Size group controllers
    weightGroupController.resetFields();
    sizeGroupController.resetFields();
  }

  void onDiscardStockHead() {
    resetFields();
    sidebarController.popBackSelectedWidget();
  }
}
