import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/models/item_difference_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class StockAndValueReportServices {
  final HttpDioClient _apiService = Get.find();

  Future<List<int>> downloadTaggedItemReport() async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.inventoryBaseUrl,
        '/get-tagging-report-weight-wise-download-csv',
        responseType: ResponseType.bytes,
        data: {},
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

  Future<List<int>> downloadDetailTaggedItemReport({
    required List<String> weightGroupIds,
  }) async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.aggregateBaseUrl,
        '/get-detail-tagging-weight-wise-download-csv',
        responseType: ResponseType.bytes,
        data: jsonEncode({"weight_group": weightGroupIds}),
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

  Future<dynamic> getItemDifferenceReport({
    required ItemDifferenceReportRequest requestBody,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        '/sales-item-difference-report',
        data: requestBody.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadItemDifferenceReport({
    required ItemDifferenceReportRequest requestBody,
  }) async {
    try {
      // Try to get bytes directly
      try {
        final response = await _apiService.post<List<int>>(
          data: requestBody.toJson(),
          AppUrl.estimationBaseUrl,
          '/sales-item-difference-report/download-csv',
          responseType: ResponseType.bytes,
        );
        return response;
      } catch (e) {
        // If bytes request fails, try as string and convert
        final stringResponse = await _apiService.post<String>(
          data: requestBody.toJson(),
          AppUrl.estimationBaseUrl,
          '/sales-item-difference-report/download-csv',
          responseType:
              ResponseType.plain, // or whatever your client uses for plain text
        );
        return utf8.encode(stringResponse);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getStockVerification({
    Map<String, dynamic>? requestBody,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/stock-verification/v2',
        data: jsonEncode(requestBody),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTaggedItemReport({
    int limit = 10,
    String query = '',
    Map<String, dynamic>? requestBody,
    // String startDate = '',
    // String endDate = '',
  }) async {
    String path;
    path = '/get-tagging-report-weight-wise?limit=$limit&query=$query';
    try {
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        path,
        data: jsonEncode(requestBody),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getWeightGroupDetails({required List<String> weightGroupIds}) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/get-detail-tagging-weight-wise',
        data: jsonEncode({"weight_group": weightGroupIds}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getStockHeadDetails({required List<String> stockHeadIds}) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/get-detail-tagging-weight-wise',
        data: jsonEncode({"stock_head": stockHeadIds}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDetailTaggingWeightWise({
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/get-detail-tagging-weight-wise',
        data: jsonEncode(requestBody),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadInwardReportDetails({required String code}) async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.aggregateBaseUrl,
        '/item-wise-inward-detail-report/download-csv',
        queryParameters: {'code': code},
        data: jsonEncode({}),
        responseType: ResponseType.bytes,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadOutwardReportDetails({required String code}) async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.aggregateBaseUrl,
        '/item-wise-outward-detail-report/download-csv',
        queryParameters: {'code': code},
        data: jsonEncode({}),
        responseType: ResponseType.bytes,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadItemStatementReport({
    required Map<String, dynamic> requestBody,
    required String dateFrom,
    required String dateTo,
  }) async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.aggregateBaseUrl,
        '/item-wise-report/download-csv',
        data: jsonEncode({
          ...requestBody,
          "date_from": dateFrom,
          "date_to": dateTo,
        }),
        responseType: ResponseType.bytes,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadInwardReport({
    required Map<String, dynamic> requestBody,
    required String dateFrom,
    required String dateTo,
    int limit = 10000,
  }) async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.aggregateBaseUrl,
        '/item-wise-inward-report/download-csv',
        queryParameters: {
          'limit': limit,
          'date_from': dateFrom,
          'date_to': dateTo,
        },
        data: jsonEncode(requestBody),
        responseType: ResponseType.bytes,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadOutwardReport({
    required Map<String, dynamic> requestBody,
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10000,
  }) async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.aggregateBaseUrl,
        '/item-wise-outward-report/download-csv',
        queryParameters: {
          'limit': limit,
          'date_from': "2024-01-21",
          // DateFormat('yyyy-MM-dd').format(startDate),
          'date_to': "2025-01-21",
          // DateFormat('yyyy-MM-dd').format(endDate),
        },
        data: jsonEncode(requestBody),
        responseType: ResponseType.bytes,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadStockAndValueReport({
    required Map<String, dynamic> requestBody,
    required String startDate,
    required String endDate,
    int limit = 10000,
  }) async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.aggregateBaseUrl,
        '/inward-outward-report/download-csv',
        queryParameters: {
          'limit': limit,
          'date_from': startDate,
          'date_to': endDate,
        },
        data: jsonEncode(requestBody),
        responseType: ResponseType.bytes,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getStockAndValueStatementReport({
    String? startDate,
    String? endDate,
    int limit = 10,
    String query = '',
    Map<String, dynamic>? requestBody,
  }) async {
    String path;
    path = '?limit=$limit&date_from=$startDate&date_to=$endDate&query=$query';
    try {
      final response = await _apiService.post(
        AppUrl.stockAndValueStatementBaseUrl,
        path,
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
