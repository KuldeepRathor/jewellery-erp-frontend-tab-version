import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/get_daily_rate_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class RateCaratInputController extends GetxController {
  final selectedCarat = '22 K'.obs;
  final isEditing = false.obs;
  final TextEditingController rateEditingController = TextEditingController();

  // Original rates from API
  final rates = <String, String>{}.obs;

  // Edited rates for tracking changes
  final editedRates = <String, String>{}.obs;

  final caratOptions =
      [
        '24 K',
        '22 K',
        '18 K',
        '23 K',
        '20 K',
        '14 K',
        '9 K',
        'Silver 999',
        'Silver 925',
        'Plain',
        'Silver',
        'Platinum',
      ].obs;

  final InventoryRepository _inventoryRepository = InventoryRepository();
  final getGoldRatesResponse = Rx<ApiResponse<DailyRateResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  @override
  void onInit() {
    super.onInit();
    fetchGoldRates();
  }

  @override
  void onClose() {
    rateEditingController.dispose();
    super.onClose();
  }

  void setCaratForMetalType(int metalType) {
    switch (metalType) {
      case MetalTypeUtils.gold:
        selectedCarat.value = '22 K';
        break;
      case MetalTypeUtils.silver:
        selectedCarat.value = 'Silver';
        break;
      case MetalTypeUtils.platinum:
        selectedCarat.value = 'Platinum';
        break;
      default:
        selectedCarat.value = '22 K';
    }
    updateRateEditingController();
  }

  void clearController() {
    // Clear the text editing controller
    rateEditingController.clear();

    // Reset to default carat
    selectedCarat.value = '22 K';

    // Reset edited rates to original rates
    editedRates.value = Map.from(rates);

    // Reset editing state
    isEditing.value = false;

    // Update the controller with the default rate
    updateRateEditingController();

    if (_isRateInvalid(selectedCarat.value)) {
      showErrorToast(message: "Please update the rates");
    }
  }

  Future<void> fetchGoldRates() async {
    getGoldRatesResponse.value = ApiResponse.loading("LOADING");

    try {
      final response = await _inventoryRepository.getLatestDailyRate();

      rates.value = {
        '24 K': response.price24k ?? '-',
        '22 K': response.price22k ?? '-',
        '18 K': response.price18k ?? '-',
        '23 K': response.price23k ?? '-',
        '20 K': response.price20k ?? '-',
        '14 K': response.price14k ?? '-',
        '9 K': response.price9k ?? '-',
        'Silver 999': response.priceSilver999 ?? '-',
        'Silver 925': response.priceSilver925 ?? '-',
        'Plain': response.pricePlain ?? "-",
        'Silver': response.priceSilver ?? "-",
        'Platinum': response.pricePlatinum ?? "-",
      };

      editedRates.value = Map.from(rates);
      getGoldRatesResponse.value = ApiResponse.completed(response);

      // Set initial value for the text controller
      updateRateEditingController();
    } catch (e) {
      final handledResponse = handleDTOResponseErrors(e);
      getGoldRatesResponse.value = ApiResponse.error(handledResponse.message);
      showErrorToast(
        message: handledResponse.message ?? "Failed to fetch gold rates",
      );
    }
  }

  void updateSelectedCarat(String? newValue) {
    if (newValue != null) {
      selectedCarat(newValue);
      updateRateEditingController();

      if (_isRateInvalid(newValue)) {
        showErrorToast(message: "Please update the rates");
      }
    }
  }

  void startEditing() {
    isEditing.value = true;
    rateEditingController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: rateEditingController.text.length,
    );
  }

  void stopEditing() {
    isEditing.value = false;
    if (rateEditingController.text.isEmpty) {
      updateRateEditingController();
    }
  }

  void updateRateEditingController() {
    final currentValue =
        editedRates[selectedCarat.value] ?? rates[selectedCarat.value] ?? "-";
    rateEditingController.text = currentValue;
  }

  void updateRate(String? newRate) {
    if (newRate != null && newRate.isNotEmpty) {
      editedRates[selectedCarat.value] = newRate;
      // Notify any listeners that depend on the current rate
      update();
    }
  }

  bool _isRateInvalid(String caratLabel) {
    final rate = editedRates[caratLabel] ?? rates[caratLabel];
    return rate == null || rate.trim().isEmpty || rate.trim() == '-';
  }

  String get currentRate =>
      editedRates[selectedCarat.value] ?? rates[selectedCarat.value] ?? "-";

  String getRateForPurity(String purity) {
    // Normalize the input purity
    String normalizedPurity = purity.trim();

    // Try direct match first with current format
    for (String caratOption in caratOptions) {
      if (caratOption.toLowerCase() == normalizedPurity.toLowerCase()) {
        final rate = editedRates[caratOption] ?? rates[caratOption] ?? '0';
        return rate.replaceAll(RegExp(r'[^0-9.]'), '');
      }
    }

    // Try adding space between number and 'k' if not present
    if (RegExp(r'^\d+k', caseSensitive: false).hasMatch(normalizedPurity)) {
      String withSpace = normalizedPurity.replaceAllMapped(
        RegExp(r'(\d+)(k)', caseSensitive: false),
        (match) => '${match.group(1)} ${match.group(2)?.toUpperCase()}',
      );

      for (String caratOption in caratOptions) {
        if (caratOption.toLowerCase() == withSpace.toLowerCase()) {
          final rate = editedRates[caratOption] ?? rates[caratOption] ?? '0';
          return rate.replaceAll(RegExp(r'[^0-9.]'), '');
        }
      }
    }

    // Fallback to purityToCaratMap
    final caratValue = purityToCaratMap[normalizedPurity.toLowerCase()];
    if (caratValue != null) {
      final rate = editedRates[caratValue] ?? rates[caratValue] ?? '0';
      return rate.replaceAll(RegExp(r'[^0-9.]'), '');
    }

    return '0';
  }

  final Map<String, String> purityToCaratMap = {
    '9k': '9 K',
    '14k': '14 K',
    '18k': '18 K',
    '20k': '20 K',
    '22k': '22 K',
    '23k': '23 K',
    '24k': '24 K',
    'plain': 'Plain',
    'silver_999': 'Silver 999',
    'silver_925': 'Silver 925',
    'silver': 'Silver',
    'platinum': 'Platinum',
  };
  String getPurityFromCarat(String caratValue) {
    final entry = purityToCaratMap.entries.firstWhere(
      (entry) => entry.value == caratValue,
      orElse: () => const MapEntry('22k', '22 K'), // Default value if not found
    );
    return entry.key;
  }
}
