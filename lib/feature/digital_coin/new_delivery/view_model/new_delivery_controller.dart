import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/model/get_digital_coin_user_data_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/model/get_user_commodity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/view/otp_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/get_commodities_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class NewDeliveryController extends GetxController {
  final JewelleryPlanRepository _jewelleryPlanRepository =
      JewelleryPlanRepository();
  late PartyDetailsController partyDetailsController = Get.put(
    PartyDetailsController(),
  );
  final weightController = TextEditingController();

  final RxBool showUserLockerBalance = false.obs;

  // final amountController = TextEditingController();

  final RxList<GetCommoditiesResponse> commodityTypes =
      <GetCommoditiesResponse>[].obs;
  final Rx<GetCommoditiesResponse?> selectedCommodityType =
      Rx<GetCommoditiesResponse?>(null);

  final getCommoditiesTypesResponse =
      Rx<ApiResponse<List<GetCommoditiesResponse>>>(
        ApiResponse.initial("Initial"),
      );

  final getDigitalCoinUserDataResponse =
      Rx<ApiResponse<GetDigitalCoinUserDataResponse>>(
        ApiResponse.initial("Initial"),
      );
  final getUserCommodityResponse = Rx<ApiResponse<GetUserCommodityResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxBool isVerified = false.obs;

  @override
  void onInit() {
    log("Commodity Type Listing");
    getCommoditiesTypes();
    super.onInit();
  }

  void setSelectedCommodityType(GetCommoditiesResponse? value) {
    selectedCommodityType.value = value;
  }

  Future<void> handleSaveWithOTP() async {
    if (!validateFields()) return;

    final phoneNumber =
        partyDetailsController.selectedParty.value is CustomerSearchValue
            ? (partyDetailsController.selectedParty.value
                    as CustomerSearchValue)
                .phoneNumber
            : null;

    if (phoneNumber == null) {
      showErrorToast(message: 'Invalid customer phone number');
      return;
    }

    try {
      // ignore: unused_local_variable
      final sendOtpResponse = await sendOtpDigitalCoin(phoneNumber);
      showSuccessToast(message: "OTP sent successfully");

      final otpResult = await Get.dialog(const OtpDialog());
      if (otpResult != null) {
        final validationResponse = await validateOtpDigitalCoin(
          phoneNumber,
          otpResult,
        );
        if (validationResponse != null) {
          await createNewDelivery();
        }
      }
    } catch (e) {
      showErrorToast(message: e.toString());
      log('Error in OTP flow: $e');
    }
  }

  Future<dynamic> sendOtpDigitalCoin(String mobile) async {
    try {
      return await _jewelleryPlanRepository.sendOtpDigitalCoin(mobile);
    } catch (e) {
      showErrorToast(message: "Failed to send OTP");
      rethrow;
    }
  }

  Future<dynamic> validateOtpDigitalCoin(String mobile, String otp) async {
    try {
      return await _jewelleryPlanRepository.validateOtpDigitalCoin(mobile, otp);
    } catch (e) {
      showErrorToast(message: "Invalid OTP");
      rethrow;
    }
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

  Future<void> verifyUser(String phone) async {
    try {
      getDigitalCoinUserDataResponse.value = ApiResponse.loading("Loading");
      final response = await _jewelleryPlanRepository.getDigitalCoinUserData(
        phone: phone,
      );
      getDigitalCoinUserDataResponse.value = ApiResponse.completed(response);

      // Log the response details
      log('User Verification Response:');
      log('ID: ${response.data?.id}');

      // Set verified status
      isVerified.value = response.data != null;

      if (response.data?.id != null) {
        await getUserCommodity(response.data!.id!);
        showUserLockerBalance.value = true;
      }
    } catch (e) {
      getDigitalCoinUserDataResponse.value = ApiResponse.error(e.toString());
      isVerified.value = false;
      showUserLockerBalance.value = false;
      log('Error verifying user: $e');
    }
  }

  Future<void> getUserCommodity(int id) async {
    try {
      getUserCommodityResponse.value = ApiResponse.loading("Loading");
      final response = await _jewelleryPlanRepository.getUserCommodity(id: id);
      getUserCommodityResponse.value = ApiResponse.completed(response);

      showSuccessToast(message: "Fetched User Commodity data");
    } catch (e) {
      getUserCommodityResponse.value = ApiResponse.error(e.toString());
      log('Error fetching user commodity data: $e');
    }
  }

  final newDeliveryResponse = Rx<ApiResponse<dynamic>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> createNewDelivery() async {
    try {
      // Validate required fields
      if (!validateFields()) return;

      // Get user ID from the verified user data
      final userId = getDigitalCoinUserDataResponse.value.data?.data?.id;
      if (userId == null) {
        throw Exception('Please verify user first');
      }
      String phoneNumber = '';
      final selectedParty = partyDetailsController.selectedParty.value;

      if (selectedParty is CustomerSearchValue) {
        phoneNumber = selectedParty.phoneNumber ?? '';
      } else {
        throw Exception('Please select a valid customer');
      }

      if (phoneNumber.isEmpty) {
        throw Exception('Selected customer has no phone number');
      }

      // Set loading state
      newDeliveryResponse.value = ApiResponse.loading("Creating new delivery");

      // Call repository method
      final response = await _jewelleryPlanRepository.newDelivery(
        selectedCommodityType.value!.commodity!, // commodity
        weightController.text, // weight
        phoneNumber,
      );

      // Handle success
      newDeliveryResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Delivery created successfully");

      // Refresh user commodity data
      // await getUserCommodity(userId);

      // Clear input fields
      clearAllFields();
      SidebarController sidebarController = Get.find();
      sidebarController.popBackSelectedWidget();
      log('New Delivery Response: $response');
    } catch (e) {
      newDeliveryResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: e.toString());
      log('Error creating new delivery: $e');
    }
  }

  bool validateFields() {
    if (selectedCommodityType.value == null) {
      showErrorToast(message: 'Please select a commodity type');
      return false;
    }
    if (weightController.text.isEmpty) {
      showErrorToast(message: 'Please enter weight');
      return false;
    }
    if (!isVerified.value) {
      showErrorToast(message: 'Please verify user first');
      return false;
    }
    if (partyDetailsController.selectedParty.value == null) {
      showErrorToast(message: 'Please select a customer');
      return false;
    }
    return true;
  }

  void clearAllFields() {
    weightController.clear();
    selectedCommodityType.value = null;
    isVerified.value = false;

    showUserLockerBalance.value = false;

    final PartyDetailsController partyDetailsController =
        Get.find<PartyDetailsController>();
    partyDetailsController.clearControllers();
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }
}
