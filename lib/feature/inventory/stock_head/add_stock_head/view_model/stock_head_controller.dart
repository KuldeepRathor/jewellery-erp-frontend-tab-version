import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view_model/size_group_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view_model/weight_group_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/stock_head_listing/view_model/stock_head_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/add_stock_head_request.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class StockHeadController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final SidebarController sidebarController = Get.find();

  final WeightGroupController weightGroupController = Get.put(
    WeightGroupController(),
  );
  final SizeGroupController sizeGroupController = Get.put(
    SizeGroupController(),
  );

  final Rx<CategoriesResponse?> selectedCategories = Rx<CategoriesResponse?>(
    null,
  );
  final RxList<CategoriesResponse> categories = <CategoriesResponse>[].obs;

  final Rx<StockHeadMetalTypesResponse?> selectedStockHeadMetalType =
      Rx<StockHeadMetalTypesResponse?>(null);
  final RxList<StockHeadMetalTypesResponse> stockHeadMetalTypes =
      <StockHeadMetalTypesResponse>[].obs;

  final RxInt returnTabIndex = 0.obs;
  final stockHeadCodeController = TextEditingController();
  final stockHeadNameController = TextEditingController();

  final hallMarkChargesController = TextEditingController();
  final RxBool isHallMarkRequired = false.obs;

  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;

  final _deboncer = CustomDebouncer(milliseconds: 500);

  final getStockHeadListingResponse = Rx<ApiResponse<StockHeadResponse>>(
    ApiResponse.initial("Initial"),
  );

  @override
  void onInit() {
    log("Stock Head initialized");

    super.onInit();
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

  final getCategoriesResponse = Rx<ApiResponse<List<CategoriesResponse>>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> getCategories() async {
    try {
      getCategoriesResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getCategories();
      getCategoriesResponse.value = ApiResponse.completed(response);
      categories.value = response;
    } catch (e) {
      log('Error fetching categories: $e');
      getCategoriesResponse.value = ApiResponse.error(e.toString());
    }
  }

  final getStockHeadMetalTypeResponse =
      Rx<ApiResponse<List<StockHeadMetalTypesResponse>>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getStockHeadMetalTypes({required int tabIndex}) async {
    try {
      getStockHeadMetalTypeResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getStockHeadMetalTypes();
      stockHeadMetalTypes.value = response;
      getStockHeadMetalTypeResponse.value = ApiResponse.completed(response);
      setMetalType(tabIndex: tabIndex);
    } catch (e) {
      log('Error fetching stock head metal types: $e');
      getStockHeadMetalTypeResponse.value = ApiResponse.error(e.toString());
    }
  }

  void setSelectedStockHeadMetalType(StockHeadMetalTypesResponse? value) {
    selectedStockHeadMetalType.value = value;
    // getStockHeadListingDetails();
  }

  final addStockHeadRequest = Rx<ApiResponse<AddStockHeadRequest>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> addStockHead({int currentTab = 0}) async {
    try {
      log("Current tab $currentTab");
      // Collect all validation errors
      List<String> errors = [];
      // if (currentTab == 0) {
      //   weightGroupController.formKey.currentState!.validate();
      // }
      // if (currentTab == 1) {
      //   sizeGroupController.formKey.currentState!.validate();
      // }

      // Validate all required fields
      if (stockHeadNameController.text.isEmpty) {
        errors.add("Stock Head Name is required");
      }

      if (stockHeadCodeController.text.isEmpty) {
        errors.add("Stock Head Code is required");
      }

      if (isCodeAvailable.value == false) {
        errors.add("Invalid code");
      }

      if (selectedCategories.value?.id == null) {
        errors.add("Please select a category");
      }

      if (selectedStockHeadMetalType.value?.id == null) {
        errors.add("Please select a metal type");
      }

      if (weightGroupController.rows.isEmpty) {
        errors.add("At least one weight group is required");
      }

      if (!weightGroupController.validateAllCodes()) {
        errors.add("Please check Weight groups");
      }

      if (sizeGroupController.isRequired.value == true) {
        if (!sizeGroupController.validateAllCodes()) {
          errors.add("Please check Size groups");
        }
      }

      // Show errors if any and return

      if (errors.isNotEmpty) {
        for (String error in errors) {
          showErrorToast(message: error);
        }
        return;
      }

      addStockHeadRequest.value = ApiResponse.loading("Loading");

      String? hallmarkExtraCharge;
      if (isHallMarkRequired.value) {
        hallmarkExtraCharge =
            hallMarkChargesController.text.isEmpty
                ? "0.0"
                : hallMarkChargesController.text;
      }
      // Filter out empty weight groups
      final validWeightGroups =
          weightGroupController.rows
              .where((row) => weightGroupController.isRowEmpty(row) == false)
              .map(
                (row) => WeightGroup(
                  name: row.name.text,
                  code: row.code.text,
                  minWeight: row.minWeight.text,
                  maxWeight: row.maxWeight.text,
                ),
              )
              .toList();

      // Filter out empty size groups
      final validSizeGroups =
          sizeGroupController.rows
              .where((row) => sizeGroupController.isRowEmpty(row) == false)
              .map((row) => SizeGroup(code: row.code.text, size: row.size.text))
              .toList();

      final addStockRequest = AddStockHeadRequest(
        name: stockHeadNameController.text,
        code: stockHeadCodeController.text,
        category: Category(id: selectedCategories.value!.id),
        hallmarkExtraCharge: hallmarkExtraCharge,
        metalType: Category(id: selectedStockHeadMetalType.value!.id),
        isNetWeight: weightGroupController.isNettWtSelected.value,
        weightGroups: validWeightGroups,
        sizeGroups: validSizeGroups,
        sizeRequired: sizeGroupController.isRequired.value,
      );

      final response = await inventoryRepository.addStockHead(addStockRequest);
      addStockHeadRequest.value = ApiResponse.completed(response);

      showSuccessToast(message: "Stock Head Added Successfully");
      resetFields();

      final listingController = Get.find<StockHeadListingController>();
      listingController.currentTabIndex.value = returnTabIndex.value;

      sidebarController.popBackSelectedWidget();
    } catch (e, s) {
      log("Error in adding stock head $s");
      addStockHeadRequest.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to add Stock Head: ${e.toString()}");
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
    selectedCategories.value = null;
    selectedStockHeadMetalType.value =
        stockHeadMetalTypes.isNotEmpty ? stockHeadMetalTypes.first : null;

    // Reset Weight and Size group controllers
    weightGroupController.resetFields();
    sizeGroupController.resetFields();
  }

  void setMetalType({required int tabIndex}) {
    returnTabIndex.value = tabIndex;
    StockHeadMetalTypesResponse? value;
    switch (tabIndex) {
      case 0:
        value = getStockHeadMetalTypeResponse.value.data?.firstWhere(
          (element) => element.typeName?.toLowerCase() == "gold",
        );

        break;
      case 1:
        value = getStockHeadMetalTypeResponse.value.data?.firstWhere(
          (element) => element.typeName?.toLowerCase() == "platinum",
        );

        break;
      case 2:
        value = getStockHeadMetalTypeResponse.value.data?.firstWhere(
          (element) => element.typeName?.toLowerCase() == "silver",
        );

        break;
      default:
        value = getStockHeadMetalTypeResponse.value.data?.firstWhere(
          (element) => element.typeName?.toLowerCase() == "gold",
        );
        break;
    }
    selectedStockHeadMetalType.value = value;
  }

  void onDiscardStockHead() {
    resetFields();
    final listingController = Get.find<StockHeadListingController>();
    listingController.currentTabIndex.value = returnTabIndex.value;

    sidebarController.popBackSelectedWidget();
  }
}
