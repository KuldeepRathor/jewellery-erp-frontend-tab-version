import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/model/item_statement_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stone_statement_report/model/stone_statement_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/metal_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/services/item_statement_report_service.dart';

class ItemStatementReportRepository {
  final ItemStatementReportServices itemStatementReportServices =
      ItemStatementReportServices();

  Future<ItemStatementReportResponseModel> getItemStatementReport({
    Map<String, dynamic>? requestBody,
    String? dateFrom,
    String? dateTo,
  }) async {
    final response = await itemStatementReportServices.getItemStatementReport(
      requestBody: requestBody,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    final data = ItemStatementReportResponseModel.fromJson(response);
    return data;
  }

  Future<List<MetalTypeResponse>> getdMetalTypes() async {
    final response = await itemStatementReportServices.getdMetalTypes();
    return (response as List)
        .map((item) => MetalTypeResponse.fromJson(item))
        .toList();
  }

  Future<List<StockHeadMetalTypesResponse>> getOrnamentsMetalTypes() async {
    final response = await itemStatementReportServices.getOrnamentsMetalTypes();
    return (response as List)
        .map((item) => StockHeadMetalTypesResponse.fromJson(item))
        .toList();
  }

  Future<StoneStatementReportResponse> getStoneStatementReport({
    required Map<String, dynamic> requestBody,
  }) async {
    final response = await itemStatementReportServices.getStoneStatementReport(
      requestBody: requestBody,
    );
    final data = StoneStatementReportResponse.fromJson(response);
    return data;
  }
}
