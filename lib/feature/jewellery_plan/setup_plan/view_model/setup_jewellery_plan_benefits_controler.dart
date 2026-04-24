import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/design_selection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SetupJewelleryPlanBenefitsController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  // Text Controllers
  final vaBenefitController = TextEditingController();
  final vaBenefitUptoController = TextEditingController();
  final mcBenefitController = TextEditingController();
  final mcBenefitUptoController = TextEditingController();
  final stoneBenefitController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Reactive variables
  final installmentBonus = RxString("1.0");
  final gstType = RxString("Charge GST");
  final applicableDesigns = RxString("3 Months");

  final RxList<StockHeadMetalTypesResponse> stockHeadMetalTypes =
      <StockHeadMetalTypesResponse>[].obs;
  final Rx<StockHeadMetalTypesResponse?> selectedStockHeadMetalType =
      Rx<StockHeadMetalTypesResponse?>(null);

  final RxList<GetStoneRatesValue> stoneType = <GetStoneRatesValue>[].obs;

  final Rx<GetStoneRatesValue?> selectedStoneType = Rx<GetStoneRatesValue?>(
    null,
  );

  void setStoneType(GetStoneRatesValue? value) {
    selectedStoneType.value = value;
  }

  void setSelectedStockHeadMetalType(StockHeadMetalTypesResponse? value) {
    selectedStockHeadMetalType.value = value;
    getStockHeadMetalTypes();
  }

  @override
  void onInit() {
    super.onInit();
    getStockHeadMetalTypes();
    loadStoneRates();
  }

  // Lists for dropdown options

  final installmentBonusOptions = [
    "0.5",
    "1.0",
    "1.5",
    "2.0",
    "2.5",
    "3.0",
    "3.5",
    "4.0",
  ];

  void setInstallmentBonus(String? bonus) {
    if (bonus != null) {
      // Store the raw number value
      installmentBonus.value = bonus.trim();
    }
  }

  void setGstType(String? type) {
    if (type != null) {
      gstType.value = type;
    }
  }

  final getStoneRatesResponse =
      Rx<ApiResponse<GetStoneRatesResponse>>(
        ApiResponse.initial("Initial"),
      ).obs;

  Future<void> loadStoneRates() async {
    try {
      getStoneRatesResponse.value.value = ApiResponse.loading("Loading");

      final response = await inventoryRepository.getStoneRates(
        nextPage: null, // We want to load all stone rates for dropdown
        limit: 1000, // Set a reasonable limit for dropdown items
        query: '', // No search query needed for dropdown
      );

      if (response.values != null && response.values!.isNotEmpty) {
        // Update the stone types list
        stoneType.assignAll(response.values!);

        // Set the first stone type as default selection if none is selected
        if (selectedStoneType.value == null && stoneType.isNotEmpty) {
          selectedStoneType.value = stoneType.first;
        }
      }

      getStoneRatesResponse.value.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error loading stone rates: $e');
      getStoneRatesResponse.value.value = ApiResponse.error(e.toString());
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

  // Method to reset all fields
  void resetFields() {
    vaBenefitController.clear();
    vaBenefitUptoController.clear();
    mcBenefitController.clear();
    mcBenefitUptoController.clear();
    stoneBenefitController.clear();
    stoneType.clear();
    installmentBonus.value = "3 Months";
    gstType.value = "Charge GST";
    applicableDesigns.value = "3 Months";
  }

  String? validatePercentage(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < 0 || number > 100) {
      return 'Percentage must be between 0 and 100';
    }
    return null;
  }

  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validate VA Benefits
    if (vaBenefitController.text.isEmpty ||
        vaBenefitUptoController.text.isEmpty) {
      showErrorToast(message: "VA benefit fields are required");
      return false;
    }

    // Validate MC Benefits
    if (mcBenefitController.text.isEmpty ||
        mcBenefitUptoController.text.isEmpty) {
      showErrorToast(message: "MC benefit fields are required");
      return false;
    }

    // Validate Stone Benefits
    if (stoneBenefitController.text.isEmpty) {
      showErrorToast(message: "Stone benefit is required");
      return false;
    }

    // Validate Stone Type Selection
    if (selectedStoneType.value == null) {
      showErrorToast(message: "Please select a stone type");
      return false;
    }

    // Validate Stock Head Metal Type
    if (selectedStockHeadMetalType.value == null) {
      showErrorToast(message: "Please select a metal type");
      return false;
    }

    // Validate Design Selection
    DesignSelectionController designController =
        Get.find<DesignSelectionController>();
    if (designController.selectedDesignsList.isEmpty) {
      showErrorToast(message: "Please select at least one design");
      return false;
    }

    // Validate VA benefit percentages
    double vaBenefit = double.parse(vaBenefitController.text);
    double vaBenefitUpto = double.parse(vaBenefitUptoController.text);
    if (vaBenefit > vaBenefitUpto) {
      showErrorToast(
        message: "VA benefit cannot be greater than its maximum limit",
      );
      return false;
    }

    // Validate MC benefit percentages
    double mcBenefit = double.parse(mcBenefitController.text);
    double mcBenefitUpto = double.parse(mcBenefitUptoController.text);
    if (mcBenefit > mcBenefitUpto) {
      showErrorToast(
        message: "MC benefit cannot be greater than its maximum limit",
      );
      return false;
    }

    return true;
  }

  // Cleanup method
  @override
  void onClose() {
    vaBenefitController.dispose();
    vaBenefitUptoController.dispose();
    mcBenefitController.dispose();
    mcBenefitUptoController.dispose();
    stoneBenefitController.dispose();
    super.onClose();
  }
}
