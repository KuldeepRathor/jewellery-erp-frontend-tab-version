import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/model/sales_record_detail_report_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/model/sales_record_detail_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/model/get_inward_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/daily_stock_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/file_download_util.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class DetailedSalesSummaryController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();
  final BaseFilterController filterController = Get.put(BaseFilterController());
  SalesRecordDetailReportRequest? _currentFilterRequest;
  final salesRecordDetailReportResponse =
      Rx<ApiResponse<SalesRecordDetailReportResponse>>(
        ApiResponse.initial("INITIAL"),
      );

  final DailyStockReportRepository _reportRepository =
      DailyStockReportRepository();
  final headers =
      [
        'Sr',
        'Invoice Date',
        'Invoice Number',
        'Tag Number',
        'Item Description',
        'Code',
        'Pcs',
        'Gross Weight',
        'Net Weight',
        'Stone Weight Carat',
        'Stone Amount',
        'Old Gold Nett Weight',
        'Old Gold Gross Weight',
        'Old Gold Amount',
        'Weight Difference',
        'Received Amount',
        'Cash',
        'Card',
        'NEFT/RTGS',
        'UPI/IMPS',
        'Cheque',
        // 'Actions'
      ].obs;

  final columnWidths =
      [
        0.1, // Sr
        0.4, // Invoice Date
        0.4, // Invoice Number
        0.4, // Tag Number
        0.7, // Item Description
        0.4, // Code
        0.4, // Pieces
        0.5, // Gross Weight
        0.5, // Net Weight
        0.5, // Stone Weight Carat
        0.5, // Stone Amount
        0.5, // Old Gold Nett Weight
        0.5, // Old Gold Gross Weight
        0.5, // Old Gold Amount
        0.5, // Weight Difference
        0.5, // Received Amount
        0.5, // Cash
        0.5, // Card
        0.5, // NEFT/RTGS
        0.5, // UPI/IMPS
        0.5, // Cheque
        // 0.2, // Actions
      ].obs;

  final customerListingResponse = Rx<ApiResponse<GetInwardReportResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterController.resetAllFilters();

      filterController.fetchAllDropdownData(
        filterTypes: ['metalType', 'branch', 'dateRange', 'taggedBy'],
      );

      getSalesRecoedDetail();
    });
  }

  void applyFilters() {
    // Create request from filters
    final requestBody = createRequestFromFilters();
    _currentFilterRequest = requestBody;
    log(_currentFilterRequest.toString());

    // Call API with the filter request
    getSalesRecoedDetail(requestBody: requestBody);
  }

  SalesRecordDetailReportRequest createRequestFromFilters() {
    return SalesRecordDetailReportRequest(
      /// ✅ Branch
      branch:
          filterController.selectedBranches.isNotEmpty
              ? filterController.selectedBranches
                  .where((e) => e.id != null)
                  .map((e) => e.id!)
                  .toList()
              : null,

      /// ✅ Metal Type
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
                  .where(
                    (user) => user.id != null && int.tryParse(user.id!) != null,
                  )
                  .map((user) => int.parse(user.id!))
                  .toList()
              : null,

      /// ✅ Date From
      dateFrom: filterController.dateFrom.value,

      /// ✅ Date To
      dateTo: filterController.dateTo.value,

      /// ✅ Users
      users:
          filterController.selectedTaggedBys.isNotEmpty
              ? filterController.selectedTaggedBys
                  .where((e) => e.id != null)
                  .map((e) => e.id!)
                  .toList()
              : null,
    );
  }

  Future<void> getSalesRecoedDetail({
    SalesRecordDetailReportRequest? requestBody,
  }) async {
    try {
      salesRecordDetailReportResponse.value = ApiResponse.loading("LOADING");

      final effectiveRequestBody =
          requestBody ?? SalesRecordDetailReportRequest();

      final response = await estimationRepository.getSalesRecoedDetailReport(
        requestBody: effectiveRequestBody,
      );

      salesRecordDetailReportResponse.value = ApiResponse.completed(response);
    } catch (e) {
      salesRecordDetailReportResponse.value = ApiResponse.error(e.toString());
      log("Error fetching daily report: $e");
    }
  }

  final salesRecordResponse = Rx<ApiResponse<SalesRecordDetailReportResponse>>(
    ApiResponse.initial("INITIAL"),
  );
  Future<void> getSalesRecordDetails() async {
    try {
      salesRecordResponse.value = ApiResponse.loading("Loading");
      final response = await _reportRepository.salesRecordDetailReport();
      salesRecordResponse.value = ApiResponse.completed(response);
    } catch (e) {
      salesRecordResponse.value = ApiResponse.error(e.toString());
      log('Error fetching sales record details: $e');
    }
  }

  TableRow buildTableHeaders() {
    log("The controllers length : ${headers.length} ");
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sr") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  Future<void> downloadReport() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await _reportRepository.downloadsalesRecordDetailReport();

      // Close loading dialog
      Get.back();

      // Use the utility class to handle file download
      final success = await FileDownloadUtil.downloadFile(
        fileData: result,
        fileNamePrefix: 'stock_and_value_report',
        fileExtension: 'csv',
      );

      if (success) {
        showSuccessToast(message: "Report downloaded successfully");
      } else {
        showErrorToast(message: "Download cancelled or failed");
      }
    } catch (e) {
      Get.back(); // Close loading dialog if error occurs
      showErrorToast(message: "Failed to download report: ${e.toString()}");
    }
  }

  List<String> popUpValues = ["View"];

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final record = salesRecordDetailReportResponse.value.data?.values
        ?.elementAt(index);

    if (record == null) return const TableRow(children: []);

    // Add cells based on the record data
    cells.addAll([
      _buildCell("${index + 1}"),
      _buildCell(record.invoiceDate?.toString().split(' ')[0] ?? '-'),
      _buildCell(record.invoiceNumber ?? '-'),
      _buildCell("${record.code}-${record.tagNumber} "),
      _buildCell(record.itemDescription ?? '-'),
      _buildCell(record.code ?? '-'),
      _buildCell(record.pieces?.toString() ?? '-'),
      _buildCell(record.grossWeight ?? '-'),
      _buildCell(record.netWeight ?? '-'),
      _buildCell(record.stoneWeightCarat ?? '-'),
      _buildCell(record.stoneAmount ?? '-'),
      _buildCell(record.oldGoldNettWeight ?? '-'),
      _buildCell(record.oldGoldGrossWeight ?? '-'),
      _buildCell(record.oldGoldAmount ?? '-'),
      _buildCell(record.weightDifference ?? '-'),
      _buildCell(record.receivedAmount ?? '-'),
      _buildCell(record.paymentMethodCash ?? '-'),
      _buildCell(record.paymentMethodCard ?? '-'),
      _buildCell(record.paymentMethodNeftRtgs ?? '-'),
      _buildCell(record.paymentMethodUpiImps ?? '-'),
      _buildCell(record.paymentMethodCheque ?? '-'),
    ]);

    return TableRow(children: cells);
  }

  Widget _buildCell(String text) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CustomText(
            text: text,
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomDashedLineWidget(width: Get.width),
      ],
    );
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }
}
