import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/get_stock_head_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/get_ornament_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class OnlineOnlyDesignDetailsController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rx<OrnamnetTypeValues?> selectedOrnamentType = Rx<OrnamnetTypeValues?>(
    null,
  );

  final Rx<GetStockHeadDropdownValue?> selectedStockHead =
      Rx<GetStockHeadDropdownValue?>(null);
  final ornamentsResponse = Rx<ApiResponse<GetAllOrnamentsResponse>>(
    ApiResponse.initial("Initial"),
  );
  final RxList<GetAllOrnamentsResponseValue> ornamentsList =
      <GetAllOrnamentsResponseValue>[].obs;
  final Rx<GetAllOrnamentsResponseValue?> selectedOrnament =
      Rx<GetAllOrnamentsResponseValue?>(null);

  // late QuillController descriptionQuillController;

  FocusNode designCodeFocusNode = FocusNode();
  FocusNode designNameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  TextEditingController designCodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController stockHeadController = TextEditingController();
  TextEditingController metalController = TextEditingController();

  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);
  final FocusNode stockHeadFocusNode = FocusNode();
  final FocusNode metalServiceTypeFocusNode = FocusNode();
  @override
  void onInit() {
    super.onInit();
    // Initialize QuillController
    // descriptionQuillController = QuillController.basic();
  }

  void clearControllers() {
    selectedOrnamentType.value = null;
    selectedStockHead.value = null;
    designCodeController.text = "";
    titleNameController.text = "";
    // descriptionQuillController.clear();
    categoryController.text = "";
    getStockHeadListingResponse.value = ApiResponse.initial(
      "Loading stockhead",
    );

    ornamentsList.clear();
    selectedOrnament.value = null;
    fetchOrnaments();
    getStockHeadListingDetails(query: "");

    update();
  }

  // String getDescriptionAsJson() {
  //   final delta = descriptionQuillController.document.toDelta();
  //   return jsonEncode(delta.toJson());
  // }

  // // Method to get plain text from description
  // String getDescriptionAsPlainText() {
  //   return descriptionQuillController.document.toPlainText();
  // }

  // Method to set description from JSON (when loading data)
  // void setDescriptionFromJson(String jsonString) {
  //   try {
  //     final json = jsonDecode(jsonString);
  //     descriptionQuillController.document = Document.fromJson(json);
  //   } catch (e) {
  //     // If JSON parsing fails, treat as plain text
  //     descriptionQuillController.document = Document()..insert(0, jsonString);
  //   }
  // }

  Future<void> fetchOrnaments() async {
    try {
      ornamentsResponse.value = ApiResponse.loading("Fetching ornaments");
      final response = await _inventoryRepository.getAllOrnaments();

      ornamentsResponse.value = ApiResponse.completed(response);
      ornamentsList.assignAll(response.values ?? []);
    } catch (e) {
      ornamentsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to fetch ornaments');
    }
  }

  void setSelectedOrnament(GetAllOrnamentsResponseValue? value) {
    selectedOrnament.value = value;
    // You might want to trigger other actions here
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

    categoryController.text = selectedObject.category?.categoryName ?? "";

    update();
  }

  final getOrnamentTypeListingResponse = Rx<ApiResponse<OrnamentTypeResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getOrnamentsTypeListingDetails(String? metal_type) async {
    try {
      getOrnamentTypeListingResponse.value = ApiResponse.loading(
        "Loading Ornaments",
      );

      final response = await _inventoryRepository.getOrnamentType(
        metal_type: metal_type,
      );

      getOrnamentTypeListingResponse.value = ApiResponse.completed(response);
    } catch (e) {
      if (e is ApiException) {
        showErrorToast(message: "Could not load Ornament Type");
      }
      // showErrorToast(message: e.toString());
      getOrnamentTypeListingResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Updated to use the new API response type
  final getStockHeadListingResponse =
      Rx<ApiResponse<GetStockHeadDropdownResponse>>(
        ApiResponse.initial("Initial"),
      );

  // Updated method to use the new API
  Future<void> getStockHeadListingDetails({required String query}) async {
    try {
      getStockHeadListingResponse.value = ApiResponse.loading(
        "Loading stockhead",
      );

      // Use the new getStockHeadsDropdown API
      final response = await _inventoryRepository.getStockHeadsDropdown(
        limit: 1000,
        query: query,
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
    titleNameController.text = data.name ?? '';

    // Populate stock head - convert to GetStockHeadDropdownValue
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

  @override
  void onClose() {
    // descriptionQuillController.dispose();
    designCodeFocusNode.dispose();
    designNameFocusNode.dispose();
    descriptionFocusNode.dispose();
    stockHeadFocusNode.dispose();
    metalServiceTypeFocusNode.dispose();
    super.onClose();
  }
}
