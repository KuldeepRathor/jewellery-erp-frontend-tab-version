import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_jewellery_plan_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/send_jewellery_plan_otp_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/discount_calculations.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/otp_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesJewelleryPlanController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final EstimationRepository _estimationRepository = EstimationRepository();
  final JewelleryPlanRepository _jewelleryPlanRepository =
      JewelleryPlanRepository();
  final bookingDetailsController = TextEditingController();

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isFetchingDetails = false.obs;

  // Track total redeemable amount across all plans
  final totalRedeemableAmount = 0.0.obs;

  // Store multiple jewellery plans
  final selectedJewelleryPlans = <JewelleryPlanResponse>[].obs;
  final getJewelleryPlanResponse = Rx<ApiResponse<JewelleryPlanResponse>>(
    ApiResponse.initial("Initial"),
  );

  // @override
  // void onInit() {
  //   super.onInit();

  //   ever(
  //     selectedJewelleryPlans,
  //     (callback) {
  //       final SalesPaymentDetailsController salesPaymentDetailsController =
  //           Get.find<SalesPaymentDetailsController>();
  //       salesPaymentDetailsController.calculateGstvalues();
  //     },
  //   );
  // }

  @override
  void onClose() {
    bookingDetailsController.dispose();
    super.onClose();
  }

  void clearBookingDetails() {
    getJewelleryPlanResponse.value = ApiResponse.initial("Initial");
    bookingDetailsController.clear();
  }

  Future<void> fetchJewelleryPlan({String? query}) async {
    final searchText = query ?? bookingDetailsController.text.trim();
    log("The search text will be $searchText");
    if (searchText.isEmpty) return;

    try {
      isFetchingDetails.value = true;
      getJewelleryPlanResponse.value = ApiResponse.loading("Loading");

      final response = await _estimationRepository.getJewelleryPlan(
        jlSubscriptionId: searchText,
      );

      // Check if plan is already selected
      if (selectedJewelleryPlans.any(
        (plan) => plan.setupId == response.setupId,
      )) {
        showErrorToast(message: "This plan is already added");
        return;
      }

      double redeemableAmount = calculateDiscountForPlan(response);
      response.redeemableAmount = redeemableAmount;
      getJewelleryPlanResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Jewellery Plan details fetched successfully");
    } catch (e) {
      log('Error fetching booking details: $e');
      getJewelleryPlanResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch booking details $searchText");
    } finally {
      isFetchingDetails.value = false;
    }
  }

  void addJewelleryPlan() {
    if (getJewelleryPlanResponse.value.status != Status.COMPLETED) return;

    final plan = getJewelleryPlanResponse.value.data;
    if (plan == null) return;

    selectedJewelleryPlans.add(plan);
    updateTotalRedeemableAmount();

    // Clear the search field and response
    bookingDetailsController.clear();
    getJewelleryPlanResponse.value = ApiResponse.initial("Initial");
  }

  void removeJewelleryPlan(JewelleryPlanResponse plan) {
    selectedJewelleryPlans.remove(plan);
    updateTotalRedeemableAmount();
    if (selectedJewelleryPlans.isEmpty) {
      jewelleryPlanOtp = null;
      jewelleryPlanPhoneNumber = null;
    }
  }

  void updateTotalRedeemableAmount() {
    double total = 0;
    for (var plan in selectedJewelleryPlans) {
      total += calculateDiscountForPlan(plan);
    }
    totalRedeemableAmount.value = total;
  }

  Future<void> submitBooking() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedJewelleryPlans.isEmpty) {
      showErrorToast(message: "Please add at least one jewellery plan");
      return;
    }

    try {
      isLoading.value = true;
      Get.back();
      showSuccessToast(message: "Jewellery Plans added successfully");
    } catch (e) {
      log('Error submitting booking: $e');
      showErrorToast(message: "Failed to save booking");
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    selectedJewelleryPlans.clear();
    getJewelleryPlanResponse.value = ApiResponse.initial("initial");
    bookingDetailsController.clear();
    totalRedeemableAmount.value = 0;
    jewelleryPlanOtp = null;
    jewelleryPlanPhoneNumber = null;
    update();
  }

  double calculateDiscountForPlan(JewelleryPlanResponse plan) {
    if (plan.status != "CP") {
      return 0;
    }
    final CreateSalesItemDetailsController createSalesItemDetailsController =
        Get.find<CreateSalesItemDetailsController>();
    final RateCaratInputController rateCaratInputController =
        Get.find<RateCaratInputController>();

    final itemlist = createSalesItemDetailsController.getSortedEstimationList(
      sortBy: "va",
    );
    final items =
        itemlist
            .map(
              (e) => DiscountItem(
                weight: double.tryParse(e.nwt.text) ?? 0,
                va: e.originalVa,
                mc: e.originalMc,
                vaType: e.wastageType ?? "",
              ),
            )
            .toList();

    double weight = 0;
    double amount = 0;
    double currentRate =
        double.tryParse(rateCaratInputController.currentRate) ?? 0;

    if (plan.type == "Amount Based" || plan.type == "Daily Amount Based") {
      weight = (double.tryParse(plan.amount ?? "0") ?? 0) / currentRate;
      amount = double.tryParse(plan.amount ?? "0") ?? 0;
    } else if (plan.type == "Weight Based") {
      weight = double.tryParse(plan.totalWeight ?? "0") ?? 0;
      amount = double.tryParse(plan.amount ?? "0") ?? 0;
    }

    double discount = 0.0;
    if (plan.type == "Amount Based" || plan.type == "Daily Amount Based") {
      discount = DiscountCalculator.calculateDiscountForAmountBasedPlan(
        accumulatedWeight: weight,
        accumulatedAmount: amount,
        rate: currentRate,
        items: items,
      );
    } else if (plan.type == "Weight Based") {
      discount = DiscountCalculator.calculateDiscountForWeightBasedPlan(
        accumulatedWeight: weight,
        accumulatedAmount: amount,
        rate: currentRate,
        items: items,
      );
    }

    return discount;
  }

  Future<void> prefillJewelleryPlan({
    required List<JewelleryPlan>? jewelleryPlans,
  }) async {
    for (var element in jewelleryPlans ?? <JewelleryPlan>[]) {
      if (element.subscriptionId != null) {
        await fetchJewelleryPlan(query: element.subscriptionId);
        addJewelleryPlan();
      }
    }
  }

  final sendOtpResponse = Rx<ApiResponse<SendOtpResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<bool> sendOtpForClosePlan() async {
    try {
      String phoneNumber = getPhoneNumber();
      if (phoneNumber == "") {
        showErrorToast(message: "Party doesn't have phone number");
        return false;
      }
      log("Sending otp to $phoneNumber");
      sendOtpResponse.value = ApiResponse.loading("Sending OTP");
      final response = await _jewelleryPlanRepository.sendOtpForClosePlan(
        phoneNumber,
      );
      jewelleryPlanPhoneNumber = phoneNumber;
      sendOtpResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: response.message ?? "");
      return true;
    } catch (e) {
      sendOtpResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Unable to send OTP $e");
      return false;
    }
  }

  String getPhoneNumber() {
    CreateSalesEstimationSearchPartyController
    createSalesEstimationSearchPartyController =
        Get.find<CreateSalesEstimationSearchPartyController>();
    final value =
        createSalesEstimationSearchPartyController.selectedParty.value;
    String phoneNumber;
    if (value is CustomerSearchValue) {
      phoneNumber =
          value.address
              ?.firstWhereOrNull((element) => element.isDefault == true)
              ?.phoneNumber ??
          "";
    } else if (value is VendorSearchValue) {
      phoneNumber =
          value.address
              ?.firstWhereOrNull((element) => element.isDefault == true)
              ?.phoneNumber ??
          "";
    } else {
      phoneNumber = "";
    }
    return phoneNumber;
  }

  String? jewelleryPlanOtp;
  String? jewelleryPlanPhoneNumber;
  Future<void> showCustomReusableOtpDialog() async {
    bool value = await sendOtpForClosePlan();
    if (value == true) {
      Get.dialog(
        CustomReusableOtpDialog(
          otpLength: 4,
          title: 'Enter OTP',
          message:
              'Please enter the verification code sent to your mobile number',
          onResendOtp: () {
            sendOtpForClosePlan();
          },
          onSubmit: (otpValue) {
            jewelleryPlanOtp = otpValue;
            Get.back();
          },
          showResendButton: true,
          resendAfter: const Duration(seconds: 60),
        ),
        barrierDismissible: false,
      );
    }
  }
}
