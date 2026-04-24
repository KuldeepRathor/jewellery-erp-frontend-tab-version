import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/get_daily_rate_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class GoldRateController extends GetxController {
  final selectedCarat = '22 K'.obs;
  final caratOptions = [
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
  ];
  final rates = <String, String>{}.obs;
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final getGoldRatesResponse = Rx<ApiResponse<DailyRateResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  @override
  void onInit() {
    super.onInit();
    fetchGoldRates();
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

      // caratOptions.assignAll(rates.keys);

      getGoldRatesResponse.value = ApiResponse.completed(response);
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
    }
  }

  String get currentRate => rates[selectedCarat.value] ?? "-";

  // Updated mapping to match dropdown values
  final Map<String, String> purityToCaratMap =
      {
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
      }.obs;

  // Function to get rate based on purity
  String getRateForPurity(String purity) {
    final caratValue = purityToCaratMap[purity.toLowerCase()];
    if (caratValue != null) {
      final rate = rates[caratValue] ?? '0';
      // Remove any currency symbols or non-numeric characters and convert to string
      return rate.replaceAll(RegExp(r'[^0-9.]'), '');
    }
    return '0';
  }
}
