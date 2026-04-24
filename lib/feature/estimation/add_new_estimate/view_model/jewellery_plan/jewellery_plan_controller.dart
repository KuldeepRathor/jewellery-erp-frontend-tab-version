import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_jewellery_plan_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/discount_calculations.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class JewelleryPlanController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final EstimationRepository _estimationRepository = EstimationRepository();
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

  @override
  void onClose() {
    bookingDetailsController.dispose();
    super.onClose();
  }

  void clearBookingDetails() {
    getJewelleryPlanResponse.value = ApiResponse.initial("Initial");
    bookingDetailsController.clear();
  }

  Future<void> fetchJewelleryPlan() async {
    final searchText = bookingDetailsController.text.trim();
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
      showErrorToast(message: "Failed to fetch booking details");
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
    update();
  }

  double calculateDiscountForPlan(JewelleryPlanResponse plan) {
    // calculate discount only if the plan is completed else return zero benefit
    if (plan.status != "CP") {
      return 0;
    }
    final EstimationItemDetailsController estimationItemDetailsController =
        Get.find<EstimationItemDetailsController>();
    final RateCaratInputController rateCaratInputController =
        Get.find<RateCaratInputController>();

    final itemlist = estimationItemDetailsController.getSortedEstimationList(
      sortBy: "va",
    );
    final items =
        itemlist
            .map(
              (e) => DiscountItem(
                weight: double.tryParse(e.nwt.text) ?? 0,
                va: e.originalVa,
                mc: e.originalMc,
                vaType:
                    e
                        .itemResponse
                        ?.design
                        ?.lineItems
                        ?.firstOrNull
                        ?.wastageType ??
                    "",
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
}
