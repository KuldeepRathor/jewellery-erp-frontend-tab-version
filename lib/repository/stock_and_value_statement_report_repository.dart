import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/models/item_difference_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/models/item_difference_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/model/stock_and_value_statement_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/stock_verification_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/get_tagging_item_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/weight_group_detail_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/weight_group_detail_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/metal_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';

import 'package:jewellery_erp_frontend_tab_version/services/stock_and_value_statement_report_service.dart';

class StockAndValueReportRepository {
  final StockAndValueReportServices stockAndValueReportServices =
      StockAndValueReportServices();

  Future<List<int>> downloadTaggedItemReport() async {
    try {
      final response =
          await stockAndValueReportServices.downloadTaggedItemReport();

      if (response.isEmpty) {
        throw Exception('Downloaded file is empty');
      }

      return response;
    } catch (e) {
      log('Download error in repository: $e');
      rethrow;
    }
  }

  Future<List<int>> downloadDetailTaggedItemReport({
    required List<String> weightGroupIds,
  }) async {
    try {
      final response = await stockAndValueReportServices
          .downloadDetailTaggedItemReport(weightGroupIds: weightGroupIds);

      if (response.isEmpty) {
        throw Exception('Downloaded file is empty');
      }

      return response;
    } catch (e) {
      log('Download error in repository: $e');
      rethrow;
    }
  }

  Future<ItemDifferenceReportResponse> getItemDifferenceReport({
    required ItemDifferenceReportRequest requestBody,
  }) async {
    try {
      final response = await stockAndValueReportServices
          .getItemDifferenceReport(requestBody: requestBody);
      final data = ItemDifferenceReportResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadItemDifferenceReport({
    required ItemDifferenceReportRequest requestBody,
  }) async {
    try {
      final response = await stockAndValueReportServices
          .downloadItemDifferenceReport(requestBody: requestBody);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetStockVerificationReportResponse> getStockVerification({
    Map<String, dynamic>? requestBody,
  }) async {
    try {
      final response = await stockAndValueReportServices.getStockVerification(
        requestBody: requestBody,
      );
      final data = GetStockVerificationReportResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetStockVerificationReportResponse>> getStockVerificationList({
    Map<String, dynamic>? requestBody,
  }) async {
    try {
      final response = await stockAndValueReportServices.getStockVerification(
        requestBody: requestBody,
      );

      if (response is List) {
        return (response)
            .map((item) => GetStockVerificationReportResponse.fromJson(item))
            .toList();
      } else {
        throw Exception('Unexpected response format from API');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GetTaggingItemReportResponse> getTaggedItemReport({
    Map<String, dynamic>? requestBody,
    int limit = 10,
    String query = '',
    // String? startDate,
    // String? endDate,
  }) async {
    final response = await stockAndValueReportServices.getTaggedItemReport(
      limit: limit,
      requestBody: requestBody,
      query: query,
      // startDate: startDate ?? "",
      // endDate: endDate ?? "",
    );
    final data = GetTaggingItemReportResponse.fromJson(response);
    return data;
  }

  Future<WeightGroupDetailResponse> getWeightGroupDetails({
    required List<String> weightGroupIds,
  }) async {
    try {
      final response = await stockAndValueReportServices.getWeightGroupDetails(
        weightGroupIds: weightGroupIds,
      );
      final data = WeightGroupDetailResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<WeightGroupDetailResponse> getStockHeadDetails({
    required List<String> stockHeadIds,
  }) async {
    try {
      final response = await stockAndValueReportServices.getStockHeadDetails(
        stockHeadIds: stockHeadIds,
      );
      final data = WeightGroupDetailResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<WeightGroupDetailResponse> getWeightGroupDetailsWithFilters({
    required List<String> weightGroupIds,
    WeightGroupDetailRequest? requestBody,
  }) async {
    try {
      final body = requestBody?.toJson() ?? {};
      body['weight_group'] = weightGroupIds;

      final response = await stockAndValueReportServices
          .getDetailTaggingWeightWise(requestBody: body);
      final data = WeightGroupDetailResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<WeightGroupDetailResponse> getStockHeadDetailsWithFilters({
    required List<String> stockHeadIds,
    WeightGroupDetailRequest? requestBody,
  }) async {
    try {
      final body = requestBody?.toJson() ?? {};
      body['stock_head'] = stockHeadIds;

      final response = await stockAndValueReportServices
          .getDetailTaggingWeightWise(requestBody: body);
      final data = WeightGroupDetailResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadInwardReportDetails({required String code}) async {
    try {
      final response = await stockAndValueReportServices
          .downloadInwardReportDetails(code: code);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadOutwardReportDetails({required String code}) async {
    try {
      final response = await stockAndValueReportServices
          .downloadOutwardReportDetails(code: code);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadItemStatementReport({
    required String dateFrom,
    required String dateTo,
    required String type,
    List<String> metalType = const [],
    List<String> stockHead = const [],
    List<String> weightGroup = const [],
    List<String> design = const [],
    List<String> partyType = const [],
    List<String> counterId = const [],
  }) async {
    try {
      final requestBody = {
        "type": type,
        "metal_type": metalType,
        "stock_head": stockHead,
        "weight_group": weightGroup,
        "design": design,
        "party_type": partyType,
        "counter_id": counterId,
      };

      final response = await stockAndValueReportServices
          .downloadItemStatementReport(
            requestBody: requestBody,
            dateFrom: dateFrom,
            dateTo: dateTo,
          );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadInwardReport({
    required DateTime dateFrom,
    required DateTime dateTo,
    required List<String> metalType,
    required List<String> stockHead,
    required List<String> design,
    required List<String> counterId,
    required String type,
    int limit = 10000,
  }) async {
    try {
      final dateFormatter = DateFormat('yyyy-MM-dd');
      final requestBody = {
        "type": type,
        "metal_type": metalType,
        "stock_head": stockHead,
        "design": design,
        "counter_id": counterId,
        "date_from": dateFormatter.format(dateFrom),
        "date_to": dateFormatter.format(dateTo),
      };

      final response = await stockAndValueReportServices.downloadInwardReport(
        requestBody: requestBody,
        dateFrom: dateFormatter.format(dateFrom),
        dateTo: dateFormatter.format(dateTo),
        limit: limit,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadOutwardReport({
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, dynamic> requestBody,
    int limit = 10000,
  }) async {
    try {
      final response = await stockAndValueReportServices.downloadOutwardReport(
        requestBody: requestBody,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> downloadStockAndValueReport({
    required String startDate,
    required String endDate,
    Map<String, dynamic>? requestBody,
    int limit = 10000,
  }) async {
    try {
      final response = await stockAndValueReportServices
          .downloadStockAndValueReport(
            requestBody: requestBody ?? {"metal_type": []},
            startDate: startDate,
            endDate: endDate,
            limit: limit,
          );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<StockAndStatmentValueReportResponseModel>
  getStockAndStatementValueReport({
    Map<String, dynamic>? requestBody,
    String? startDate,
    String? endDate,
    int limit = 10,
    String query = '',
  }) async {
    final response = await stockAndValueReportServices
        .getStockAndValueStatementReport(
          limit: limit,
          endDate: endDate,
          startDate: startDate,
          requestBody: requestBody,
          query: query,
        );
    final data = StockAndStatmentValueReportResponseModel.fromJson(response);
    return data;
  }

  Future<List<MetalTypeResponse>> getdMetalTypes() async {
    final response = await stockAndValueReportServices.getdMetalTypes();
    return (response as List)
        .map((item) => MetalTypeResponse.fromJson(item))
        .toList();
  }

  Future<List<StockHeadMetalTypesResponse>> getOrnamentsMetalTypes() async {
    final response = await stockAndValueReportServices.getOrnamentsMetalTypes();
    return (response as List)
        .map((item) => StockHeadMetalTypesResponse.fromJson(item))
        .toList();
  }
}
