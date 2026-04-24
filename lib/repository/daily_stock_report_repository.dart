import 'dart:developer';

import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/model/sales_record_detail_report_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/model/daily_stock_report_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/model/daily_stock_save_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/services/daily_stock_report_services.dart';

class DailyStockReportRepository {
  final DailyStockReportServices dailyStockReportServices =
      DailyStockReportServices();

  Future<List<int>> downloadsalesRecordDetailReport() async {
    try {
      final response =
          await dailyStockReportServices.downloadsalesRecordDetailReport();

      if (response.isEmpty) {
        throw Exception('Downloaded file is empty');
      }

      return response;
    } catch (e) {
      log('Download error in repository: $e');
      rethrow;
    }
  }

  Future<SalesRecordDetailReportResponse> salesRecordDetailReport() async {
    final response = await dailyStockReportServices.salesRecordDetailReport();
    final data = SalesRecordDetailReportResponse.fromJson(response);
    return data;
  }

  Future<List<DailyStockResponseModel>> getAllDailyReport() async {
    final response = await dailyStockReportServices.getAllDailyReport();
    final List<DailyStockResponseModel> dailyStockList =
        List<DailyStockResponseModel>.from(
          response.map((x) => DailyStockResponseModel.fromJson(x)),
        );
    return dailyStockList;
  }

  Future<void> dailyReportSubmit(
    DailyStockSaveRequestModel dailyStockModel,
  ) async {
    await dailyStockReportServices.dailyReportSubmit(dailyStockModel);
  }
}
