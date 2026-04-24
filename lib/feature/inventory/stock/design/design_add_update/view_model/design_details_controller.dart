import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/get_ornament_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/metal_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/get_stock_head_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class DesignDetailsController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rx<OrnamnetTypeValues?> selectedOrnamentType = Rx<OrnamnetTypeValues?>(
    null,
  );
  final Rx<GetStockHeadDropdownValue?> selectedStockHead =
      Rx<GetStockHeadDropdownValue?>(null);
  FocusNode designCodeFocusNode = FocusNode();
  FocusNode designNameFocusNode = FocusNode();
  TextEditingController designCodeController = TextEditingController();
  TextEditingController designNameController = TextEditingController();
  TextEditingController stockHeadController = TextEditingController();
  TextEditingController metalController = TextEditingController();

  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);
  final FocusNode stockHeadFocusNode = FocusNode();
  final FocusNode metalServiceTypeFocusNode = FocusNode();
  void clearControllers() {
    selectedOrnamentType.value = null;
    selectedStockHead.value = null;
    designCodeController.text = "";
    designNameController.text = "";
    getStockHeadListingResponse.value = ApiResponse.initial(
      "Loading stockhead",
    );
    getMetalTypesResponse.value = ApiResponse.initial("Loading metal type");
    metalTypes.clear();
    selectedMetalType.value = null;

    getMetalTypes();
    update();
  }

  Future<void> setOrnamentType(String? value) async {
    final List<OrnamnetTypeValues> ornamentList =
        getOrnamentTypeListingResponse.value.data?.values ?? [];
    OrnamnetTypeValues selectedObject = ornamentList.firstWhere(
      (element) => element.id == value,
    );
    selectedOrnamentType.value = selectedObject;
    log("Selected ornament type $value , : ${selectedObject.toJson()}");
    // selectedStockHead.value = null;
    // getStockHeadListingDetails(query: selectedObject.metalType?.id ?? "");
  }

  void setStockHead(String? value) {
    final stockHeadList = getStockHeadListingResponse.value.data?.values ?? [];
    GetStockHeadDropdownValue selectedObject = stockHeadList.firstWhere(
      (element) => element.id == value,
    );

    selectedStockHead.value = selectedObject;
    stockHeadController.text = selectedObject.name ?? "";
  }

  final getOrnamentTypeListingResponse = Rx<ApiResponse<OrnamentTypeResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getOrnamentsTypeListingDetails(String? metal_type) async {
    try {
      getOrnamentTypeListingResponse.value = ApiResponse.loading(
        "Loading Ornaments",
      );
      // await Future.delayed(Durations.extralong4);
      final response = await _inventoryRepository.getOrnamentType(
        metal_type: metal_type,
      );
      // if (response.values!.isNotEmpty) {
      //   selectedOrnamentType.value = response.values?.first;
      // }
      getOrnamentTypeListingResponse.value = ApiResponse.completed(response);
    } catch (e) {
      if (e is ApiException) {
        showErrorToast(message: "Could not load Ornament Type");
      }
      // showErrorToast(message: e.toString());
      getOrnamentTypeListingResponse.value = ApiResponse.error(e.toString());
    }
  }

  final getStockHeadListingResponse =
      Rx<ApiResponse<GetStockHeadDropdownResponse>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getStockHeadListingDetails({required String query}) async {
    try {
      getStockHeadListingResponse.value = ApiResponse.loading(
        "Loading stockhead",
      );

      final response = await _inventoryRepository.getStockHeadsDropdown(
        metal_type: int.tryParse(query),
        limit: 1000,
      );
      getStockHeadListingResponse.value = ApiResponse.completed(response);

      update();
    } catch (e, s) {
      log("Error : ${e.toString()}");
      log("stack : ${s.toString()}");
      if (e is ApiException) {
        showErrorToast(message: e.toStringPrefix());
      }
      getStockHeadListingResponse.value = ApiResponse.error(e.toString());
    }
  }

  void populateWithFetchedData(GetDesignResponseModel data) {
    // Populate design code and name
    designCodeController.text = data.code ?? '';
    designNameController.text = data.name ?? '';

    // Populate ornament type
    // OrnamnetTypeValues ornamnetTypeValues = OrnamnetTypeValues(
    //   id: data.ornament?.id,
    //   name: data.ornament?.name,
    //   code: data.ornament?.code,
    //   organizationId: data.ornament?.organizationId,
    //   hsnSac: null,
    //   metalType: null,
    //   openingWeight: data.ornament?.openingWeight,
    //   openingAmount: data.ornament?.openingAmount,
    //   gst: data.ornament?.gst,
    // );
    // OrnamentTypeResponse ornamentTypeResponse =
    //     OrnamentTypeResponse(values: [ornamnetTypeValues]);
    // getOrnamentTypeListingResponse.value =
    //     ApiResponse.completed(ornamentTypeResponse);
    // selectedOrnamentType.value = ornamnetTypeValues;

    // Populate stock head
    GetStockHeadDropdownValue stockHeadValue = GetStockHeadDropdownValue(
      id: data.stockHead?.id,
      name: data.stockHead?.name,
      code: data.stockHead?.code,
    );

    GetStockHeadDropdownResponse stockHeadResponse =
        GetStockHeadDropdownResponse(values: [stockHeadValue]);
    getStockHeadListingResponse.value = ApiResponse.completed(
      stockHeadResponse,
    );
    selectedStockHead.value = stockHeadValue;
    MetalTypeResponse metalTypeResponse = MetalTypeResponse(
      codeType: data.stockHead?.metalType?.typeName,
      typeName: data.stockHead?.metalType?.typeName,
      id: data.stockHead?.metalType?.id,
    );
    getMetalTypesResponse.value = ApiResponse.completed([metalTypeResponse]);
    selectedMetalType.value = metalTypeResponse;
    log("The populated value is ${data.toRawJson()}");

    update();
  }

  // Add code availability check method
  void checkCodeAvailability(String code) {
    if (code.isEmpty) {
      isCodeAvailable.value = true;
      isCheckingCode.value = false;
      return;
    }
    isCheckingCode.value = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await _inventoryRepository.validateCode(
          code,
          "design",
        );
        isCodeAvailable.value = isAvailable;
      } catch (e) {
        showErrorToast(message: "Failed to check code availability");
      } finally {
        isCheckingCode.value = false;
      }
    });
  }

  final getMetalTypesResponse = Rx<ApiResponse<List<MetalTypeResponse>>>(
    ApiResponse.initial("Initial"),
  );
  final RxList<MetalTypeResponse> metalTypes = <MetalTypeResponse>[].obs;
  final Rx<MetalTypeResponse?> selectedMetalType = Rx<MetalTypeResponse?>(null);
  Future<void> getMetalTypes() async {
    try {
      getMetalTypesResponse.value = ApiResponse.loading("Loading");
      final response = await _inventoryRepository.getMetalTypes();
      getMetalTypesResponse.value = ApiResponse.completed(response);
      metalTypes.assignAll(response);
    } catch (e) {
      getMetalTypesResponse.value = ApiResponse.error(e.toString());
      log('Error fetching metal types: $e');
    }
  }

  Future<void> setSelectedMetalType(MetalTypeResponse? value) async {
    selectedMetalType.value = value;
    metalController.text = value?.typeName ?? "";
    selectedStockHead.value = null;
    await getStockHeadListingDetails(query: selectedMetalType.value?.id ?? "");
    update();
  }
}
