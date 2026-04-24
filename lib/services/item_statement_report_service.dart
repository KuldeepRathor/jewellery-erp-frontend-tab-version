import 'dart:convert';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class ItemStatementReportServices {
  final HttpDioClient _apiService = Get.find();

  Future getStoneStatementReport({
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        "/item-wise-stone-report",
        data: jsonEncode(requestBody),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getItemStatementReport({
    Map<String, dynamic>? requestBody,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        // '/item-wise-report',
        "/item-wise-report-new",
        queryParameters: {"date_from": dateFrom, "date_to": dateTo},
        data: jsonEncode(requestBody),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getdMetalTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/stock-head-metal-types",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getOrnamentsMetalTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/ornament-metal-types",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
