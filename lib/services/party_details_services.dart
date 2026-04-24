import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class PartyDetailsServices {
  final HttpDioClient _apiService = Get.find();

  Future searchCustomers(String query) async {
    try {
      final response = await _apiService.get(
        AppUrl.customerBaseUrl,
        "/customers",
        queryParameters: {"query": query},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future searchVendors(String query) async {
    try {
      final response = await _apiService.get(
        AppUrl.vendorBaseUrl,
        "/vendors",
        queryParameters: {"query": query},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
