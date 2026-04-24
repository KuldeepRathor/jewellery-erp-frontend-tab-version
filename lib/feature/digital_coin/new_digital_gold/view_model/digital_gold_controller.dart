import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/calculate_amount_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/get_commodities_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class DigitalGoldController extends GetxController {
  final JewelleryPlanRepository _jewelleryPlanRepository =
      JewelleryPlanRepository();
  final weightController = TextEditingController();
  final amountController = TextEditingController();

  final calculateDigitalGoldResponse = Rx<ApiResponse<CalculateAmountResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxList<GetCommoditiesResponse> commodityTypes =
      <GetCommoditiesResponse>[].obs;
  final Rx<GetCommoditiesResponse?> selectedCommodityType =
      Rx<GetCommoditiesResponse?>(null);

  final getCommoditiesTypesResponse =
      Rx<ApiResponse<List<GetCommoditiesResponse>>>(
        ApiResponse.initial("Initial"),
      );

  final newDeliveryResponse = Rx<ApiResponse<dynamic>>(
    ApiResponse.initial("Initial"),
  );

  @override
  void onInit() {
    log("Commodity Type Listing");
    getCommoditiesTypes();
    super.onInit();
  }

  void setSelectedCommodityType(GetCommoditiesResponse? value) {
    selectedCommodityType.value = value;
  }

  Future<void> getCommoditiesTypes() async {
    try {
      getCommoditiesTypesResponse.value = ApiResponse.loading("Loading");
      final response = await _jewelleryPlanRepository.getCommodities();
      getCommoditiesTypesResponse.value = ApiResponse.completed(response);
      commodityTypes.assignAll(response);
    } catch (e) {
      getCommoditiesTypesResponse.value = ApiResponse.error(e.toString());
      log('Error fetching commodity types: $e');
    }
  }

  Future<void> calculateDigitalGold() async {
    try {
      if (selectedCommodityType.value == null) {
        throw Exception('Please select a commodity type');
      }

      final int? amount =
          amountController.text.isEmpty
              ? null
              : int.tryParse(amountController.text);

      final int? weight =
          weightController.text.isEmpty
              ? null
              : int.tryParse(weightController.text);

      if (amount == null && weight == null) {
        throw Exception('Please enter either amount or weight');
      }

      calculateDigitalGoldResponse.value = ApiResponse.loading("Calculating");

      final response = await _jewelleryPlanRepository.calculteDigitalGold(
        selectedCommodityType.value!.commodity!,
        amount, // Now passing null when no amount is entered
        weight, // Now passing null when no weight is entered
      );

      calculateDigitalGoldResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Amount Calculated");
      log('Calculate Digital Gold Response: ${response.toJson()}');
    } catch (e) {
      calculateDigitalGoldResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: e.toString());
      log('Error calculating digital gold: $e');
    }
  }

  void clearAllFields() {
    weightController.clear();
    amountController.clear();
    selectedCommodityType.value = null;
    calculateDigitalGoldResponse.value = ApiResponse.initial("Initial");

    final PartyDetailsController partyDetailsController =
        Get.find<PartyDetailsController>();
    partyDetailsController.clearControllers();
  }
}
