import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/model/daily_stock_save_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class DailyStockReportServices {
  final HttpDioClient _apiService = Get.find();

  Future<List<int>> downloadsalesRecordDetailReport() async {
    try {
      final response = await _apiService.get<List<int>>(
        AppUrl.estimationBaseUrl,
        '/sales-record-detail-report/download-csv',
        responseType: ResponseType.bytes,
        // Set appropriate headers
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      log('Download error in service: $e');
      rethrow;
    }
  }

  Future salesRecordDetailReport() async {
    try {
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        '/sales-record-detail-report',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future dailyReportSubmit(DailyStockSaveRequestModel dailyStockModel) async {
    try {
      final body = dailyStockModel.toJson();
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/daily-manual-stock-count",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllDailyReport() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/get-counter-stock-heads',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
