import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/new_booking/model/get_allowed_booking_repsonse.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class NewBookingController extends GetxController {
  final weightController = TextEditingController();
  final advancePayableAmountController = TextEditingController();
  final JewelleryPlanRepository _repository = JewelleryPlanRepository();

  final getAllowedBookingsResponse = Rx<ApiResponse<GetAllowedBookingResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  final activeBookingRule = Rx<BookingRule?>(null);
  final noteText = RxString(
    '*Note- Enter weight to see advance amount details*',
  );
  final isValidBooking = RxBool(false);
  final currentAdvanceAmount = RxDouble(0.0);

  @override
  void onInit() {
    super.onInit();
    fetchAllowedBookings();
  }

  Future<void> fetchAllowedBookings() async {
    getAllowedBookingsResponse.value = ApiResponse.loading("LOADING");

    try {
      final response = await _repository.getAllowedBookings();
      getAllowedBookingsResponse.value = ApiResponse.completed(response);

      if (response.bookingRules.isNotEmpty) {
        activeBookingRule.value = response.bookingRules.firstWhere(
          (rule) => rule.status == true,
          orElse: () => response.bookingRules.first,
        );

        log('Active Booking Rule Found:');
        log(
          'Weight Range: ${activeBookingRule.value?.weightFrom} - ${activeBookingRule.value?.weightTo}',
        );
        log(
          'Advance Percentage: ${activeBookingRule.value?.advancePercentage}%',
        );
        log('Status: ${activeBookingRule.value?.status}');
      }
    } catch (e) {
      getAllowedBookingsResponse.value = ApiResponse.error(e.toString());
      log('Error fetching booking rules: $e');
      showErrorToast(message: "Failed to fetch allowed bookings");
    }
  }

  void onWeightChanged(String value) {
    log('Weight changed to: $value');
    isValidBooking.value = false;
    currentAdvanceAmount.value = 0.0;

    if (value.isEmpty || activeBookingRule.value == null) {
      advancePayableAmountController.text = '';
      noteText.value = '*Note- Enter weight to see advance amount details*';
      log('Weight empty or no active booking rule');
      return;
    }

    try {
      final weight = double.parse(value);
      final goldRateController = Get.find<GoldRateController>();
      final rate = double.parse(goldRateController.getRateForPurity('22k'));
      final percentage = activeBookingRule.value!.advancePercentage ?? 0;

      log('\n--- Calculation Details ---');
      log('Input Weight: $weight gms');
      log('Current Gold Rate (22K): ₹$rate');
      log('Advance Percentage: $percentage%');

      final minWeight = double.parse(
        activeBookingRule.value!.weightFrom ?? '0',
      );
      final maxWeight = double.parse(activeBookingRule.value!.weightTo ?? '0');

      log('Allowed Weight Range: $minWeight - $maxWeight gms');

      if (weight >= minWeight && weight <= maxWeight) {
        final totalAmount = weight * rate;
        final advanceAmount = (totalAmount * percentage) / 100;

        log('Total Amount (weight * rate): ₹$totalAmount');
        log('Advance Amount ((total * percentage) / 100): ₹$advanceAmount');

        currentAdvanceAmount.value = advanceAmount;
        isValidBooking.value = true;
        noteText.value =
            '*Note- You can collect the advance amount ₹${advanceAmount.toStringAsFixed(2)} as per your booking terms of $percentage% *';
      } else {
        noteText.value =
            '*Note- Weight should be between ${minWeight}g and ${maxWeight}g*';
        log('Weight out of allowed range');
        showErrorToast(
          message: "Weight should be between ${minWeight}g and ${maxWeight}g",
        );
      }
    } catch (e) {
      advancePayableAmountController.text = '';
      noteText.value =
          '*Note- Enter valid weight to see advance amount details*';
      log('Error in calculation: $e');
      showErrorToast(message: "Invalid input");
    }
  }

  bool validateBooking() {
    if (!isValidBooking.value) {
      showErrorToast(
        message:
            "Please enter valid weight and ensure calculations are complete",
      );
      return false;
    }

    if (currentAdvanceAmount.value <= 0) {
      showErrorToast(message: "Invalid advance amount");
      return false;
    }

    if (activeBookingRule.value == null) {
      showErrorToast(message: "Booking rules not loaded properly");
      return false;
    }

    return true;
  }

  clearControllers() {
    weightController.clear();
    advancePayableAmountController.clear();
    noteText.value = '*Note- Enter weight to see advance amount details*';
    isValidBooking.value = false;
    currentAdvanceAmount.value = 0.0;
    log('Controllers cleared');
  }

  @override
  void onClose() {
    weightController.dispose();
    advancePayableAmountController.dispose();
    super.onClose();
  }
}
