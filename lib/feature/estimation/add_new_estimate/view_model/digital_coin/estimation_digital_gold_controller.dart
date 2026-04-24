import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/view_model/daily_rates_listing_view_model.dart';
import 'dart:developer';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/get_commodities_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/model/get_user_commodity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/get_daily_rate_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EstimationDigitalGoldController extends GetxController {
  final GlobalKey<FormState> quickOldGoldFormKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final weightController = TextEditingController();

  // Observable for selected commodity type
  final Rx<GetCommoditiesResponse?> selectedCommodityType =
      Rx<GetCommoditiesResponse?>(null);

  // Observable for available locker balance
  final Rx<double> availableLockerBalance = 0.0.obs;

  // Observable for entered weight
  final Rx<double> enteredWeight = 0.0.obs;

  // Observable for calculated amount
  final Rx<double> calculatedAmount = 0.0.obs;

  // Observable for validation status
  final RxBool isWeightValid = false.obs;

  @override
  void onClose() {
    phoneNumberController.dispose();
    weightController.dispose();
    super.onClose();
  }

  void clearControllers() {
    phoneNumberController.text = "";
    weightController.text = "";
    selectedCommodityType.value = null;
    availableLockerBalance.value = 0.0;
    enteredWeight.value = 0.0;
    calculatedAmount.value = 0.0;
    isWeightValid.value = false;
  }

  // Method to calculate amount based on commodity type and weight
  void calculateAmount(DailyRateResponse? dailyRates) {
    if (dailyRates == null ||
        !isWeightValid.value ||
        enteredWeight.value <= 0) {
      calculatedAmount.value = 0.0;
      return;
    }

    String? rateString;
    switch (selectedCommodityType.value?.commodity?.toLowerCase()) {
      case 'gold 24k':
        rateString = dailyRates.price24k;
        break;
      case 'gold 23k':
        rateString = dailyRates.price23k;
        break;
      case 'gold 22k':
        rateString = dailyRates.price22k;
        break;
      case 'gold 20k':
        rateString = dailyRates.price20k;
        break;
      case 'gold 18k':
        rateString = dailyRates.price18k;
        break;
      case 'gold 14k':
        rateString = dailyRates.price14k;
        break;
      case 'gold 9k':
        rateString = dailyRates.price9k;
        break;
      case 'silver':
        rateString = dailyRates.priceSilver;
        break;
      case 'silver 999':
        rateString = dailyRates.priceSilver999;
        break;
      case 'platinum':
        rateString = dailyRates.pricePlatinum;
        break;
      case 'plain':
        rateString = dailyRates.pricePlain;
        break;
      default:
        rateString = null;
    }

    if (rateString != null) {
      try {
        double rate = double.parse(rateString.replaceAll('₹', '').trim());
        calculatedAmount.value = rate * enteredWeight.value;
        log('Rate Calculation:');
        log('Selected Commodity: ${selectedCommodityType.value?.commodity}');
        log('Daily Rate: ₹$rate');
        log('Weight: ${enteredWeight.value} gms');
        log('Calculated Amount: ₹${calculatedAmount.value}');
      } catch (e) {
        log('Error calculating amount: $e');
        calculatedAmount.value = 0.0;
      }
    } else {
      log(
        'No matching rate found for commodity: ${selectedCommodityType.value?.commodity}',
      );
      calculatedAmount.value = 0.0;
    }
  }

  // Method to update selected commodity type and fetch its balance
  void updateSelectedCommodity(
    GetCommoditiesResponse? commodity,
    GetUserCommodityResponse? userCommodityResponse,
  ) {
    selectedCommodityType.value = commodity;

    if (commodity != null && userCommodityResponse?.data != null) {
      final matchingCommodity = userCommodityResponse?.data?.firstWhere(
        (element) =>
            element.commodity?.toLowerCase() ==
            commodity.commodity?.toLowerCase(),
      );

      availableLockerBalance.value = matchingCommodity?.weight ?? 0.0;
      log(
        'Available balance for ${commodity.commodity}: ${availableLockerBalance.value}',
      );

      // Recalculate amount with new commodity type
      calculateAmount(
        Get.find<DailyRatesListingViewModel>()
            .customerListingResponse
            .value
            .data
            ?.values
            ?.firstOrNull,
      );

      validateWeight(weightController.text);
    }
  }

  // Method to validate entered weight
  void validateWeight(String value) {
    if (value.isEmpty) {
      enteredWeight.value = 0.0;
      isWeightValid.value = false;
      return;
    }

    try {
      enteredWeight.value = double.parse(value);
      isWeightValid.value =
          enteredWeight.value <= availableLockerBalance.value &&
          enteredWeight.value > 0;

      log(
        'Validation - Entered: ${enteredWeight.value}, Available: ${availableLockerBalance.value}, Valid: ${isWeightValid.value}',
      );

      if (!isWeightValid.value) {
        if (enteredWeight.value <= 0) {
          showErrorToast(message: "Weight must be greater than 0");
          log('Error: Weight must be greater than 0');
        } else if (enteredWeight.value > availableLockerBalance.value) {
          showErrorToast(
            message:
                "Entered weight (${enteredWeight.value}) exceeds available balance (${availableLockerBalance.value})",
          );
          log(
            'Error: Entered weight (${enteredWeight.value}) exceeds available balance (${availableLockerBalance.value})',
          );
        }
      }

      // Calculate amount whenever weight changes
      calculateAmount(
        Get.find<DailyRatesListingViewModel>()
            .customerListingResponse
            .value
            .data
            ?.values
            ?.firstOrNull,
      );
    } catch (e) {
      log('Error parsing weight: $e');
      enteredWeight.value = 0.0;
      isWeightValid.value = false;
    }
  }

  // Method to get current commodity balance
  double getCurrentCommodityBalance() {
    return availableLockerBalance.value;
  }

  // Method to get current entered weight
  double getCurrentEnteredWeight() {
    return enteredWeight.value;
  }

  // Method to get calculated amount
  double getCalculatedAmount() {
    return calculatedAmount.value;
  }

  // Method to check if current selection is valid
  bool isCurrentSelectionValid() {
    return selectedCommodityType.value != null && isWeightValid.value;
  }
}
