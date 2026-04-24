import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/model/daily_reports_filter_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/model/daily_reports_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';

class DailyReportViewModel extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final BaseFilterController filterController = Get.put(BaseFilterController());
  DailyReportsFilterRequest? _currentFilterRequest;

  final dailyReportResponse = Rx<ApiResponse<DailyReportResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  @override
  void onInit() {
    super.onInit();
    log("Daily Report viewmodel initiated");
    filterController
        .fetchAllDropdownData(filterTypes: ['metalType', 'branch'])
        .then((_) {
          // Apply filters after dropdowns are loaded
          applyFilters();
        });
  }

  void clearFilters() {
    _currentFilterRequest = null;
    filterController.resetAllFilters();
    getDailyReportDetails();
  }

  @override
  void onClose() {
    log("Daily Report viewmodel Deleted");
    super.onClose();
  }

  void applyFilters() {
    // Create request from filters
    final requestBody = createRequestFromFilters();
    _currentFilterRequest = requestBody;
    log(_currentFilterRequest.toString());

    // Call API with the filter request
    getDailyReportDetails(requestBody: requestBody);
  }

  DailyReportsFilterRequest createRequestFromFilters() {
    return DailyReportsFilterRequest(
      // Metal types
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,

      // Branches
      branch:
          filterController.selectedBranches.isNotEmpty
              ? filterController.selectedBranches
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
    );
  }

  Future<void> getDailyReportDetails({
    DailyReportsFilterRequest? requestBody,
  }) async {
    try {
      dailyReportResponse.value = ApiResponse.loading("LOADING");

      final effectiveRequestBody = requestBody ?? DailyReportsFilterRequest();

      final response = await _aggregateRepository.getCompleteDailyReport(
        requestBody: effectiveRequestBody,
      );

      dailyReportResponse.value = ApiResponse.completed(response);
    } catch (e) {
      dailyReportResponse.value = ApiResponse.error(e.toString());
      log("Error fetching daily report: $e");
    }
  }

  String formatCurrency(String amount) {
    try {
      final value = double.parse(amount);
      return value.toStringAsFixed(2);
    } catch (e) {
      return amount;
    }
  }
}
