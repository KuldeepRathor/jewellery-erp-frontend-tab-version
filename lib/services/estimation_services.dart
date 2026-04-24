import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/estimation_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/old_gold_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/create_order_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_images_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/model/create_repair_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_images_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/model/sales_record_detail_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_date_wise/model/get_purchase_report_date_wise_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_date_wise/model/get_sales_report_date_wise_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/sales_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/models/post_sales_return_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/create_jewellery_plan_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/post_sales_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/model/sales_return_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class EstimationServices {
  final HttpDioClient _apiService = Get.find();

  Future getPurchaseReportTransactionWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    // GetCancelReportRequest? filterRequest,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/purchase-report-transaction-wise?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/purchase-report-transaction-wise?query=$query&limit=$limit';
    }

    try {
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        path,
        data: {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPurchaseReportDateWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    GetPurchaseReportDateWiseRequest? filterRequest,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/purchase-report-date-wise?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/purchase-report-date-wise?query=$query&limit=$limit';
    }

    try {
      final body = filterRequest?.toJson() ?? {};
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        path,
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPurchaseReportMonthWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    // GetCancelReportRequest? filterRequest,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/purchase-report-month-wise?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/purchase-report-month-wise?query=$query&limit=$limit';
    }

    try {
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        path,
        data: {"year": 0},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSalesReportDateWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    GetSalesReportDateWiseRequest? filterRequest,
  }) async {
    String path;
    if (offsetId != null) {
      path = '/sales-report-date-wise?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/sales-report-date-wise?query=$query&limit=$limit';
    }

    try {
      final body = filterRequest?.toJson() ?? {};
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        path,
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSalesReportMonthWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    // GetCancelReportRequest? filterRequest,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/sales-report-month-wise?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/sales-report-month-wise?query=$query&limit=$limit';
    }

    try {
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        path,
        data: {"year": 0},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSalesReportTransactionWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    // GetCancelReportRequest? filterRequest,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/sales-report-transaction-wise?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/sales-report-transaction-wise?query=$query&limit=$limit';
    }

    try {
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        path,
        data: {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> nextSequence({
    required String invoiceType,
  }) async {
    try {
      final body = {
        "types": [invoiceType],
      };
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSalesDropdown({String? query}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }

      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        "/get-sales-dropdown",
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Credit note
  Future getSalesReturnCreditNote(String? partyId) async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/sales-return-credit-note-party-id/$partyId',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Payment Methods

  Future getReceiptMethods() async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/receipt-methods',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPaymentMethods() async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/payment-methods',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSequencesDropdown({
    required String? voucherType,
    required String? voucherSection,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/sequences-dropdown',
        queryParameters: {
          "voucher_type": voucherType,
          "voucher_section": voucherSection,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getRepairDetailsById({required String? id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/repair/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getOrderDetailsById({required String? id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/order/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Repairs

  Future<void> deleteRepair({required String id}) async {
    try {
      await _apiService.delete(AppUrl.estimationBaseUrl, '/cancel-repair/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future updateRepairEstimationDate({
    String? id,
    String? estimation_date,
  }) async {
    try {
      final response = await _apiService.put(
        AppUrl.estimationBaseUrl,
        "/repair-estimation-date/$id",
        queryParameters: {"estimation_date": estimation_date},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future repairImage(RepairImagesRequest create_repair_request) async {
    try {
      final body = create_repair_request.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/repair-images",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future repairImagePresignedUrl(
    RepairImagesPresignedUrlRequest create_repair_request,
  ) async {
    try {
      final body = create_repair_request.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/repair-images-presigned-url-save",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future assignRepairStatus({
    String? id,
    String? tagging_line_item_id,
    String? status,
    String? sale_id,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/repair-status",
        data: {
          "id": id,
          "tagging_line_item_id": tagging_line_item_id,
          "status": status,
          "sale_id": sale_id,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createRepair(CreateRepairRequest create_repair_request) async {
    try {
      final body = create_repair_request.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/create-repair",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Orders

  Future<void> deleteOrder({required String id}) async {
    try {
      await _apiService.delete(AppUrl.estimationBaseUrl, '/cancel-order/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future getByExistingTag(String tag) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item-by-barcode-number?tag_barcode=$tag',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future orderImage(OrderImagesRequest create_order_request) async {
    try {
      final body = create_order_request.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/order-images",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future orderImagePresignedUrl(
    OrderImagesPresignedUrlRequest create_order_request,
  ) async {
    try {
      final body = create_order_request.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/order-images-presigned-url-save",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putOrderImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': lookupMimeType(imagePath).toString()},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future assignOrderStatus({
    String? id,
    String? tagging_line_item_id,
    String? status,
    String? sale_id,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/order-status",
        data: {
          "id": id,
          "tagging_line_item_id": tagging_line_item_id,
          "status": status,
          "sale_id": sale_id,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future unlinkOrderItemAndTagging({String? id}) async {
    try {
      final response = await _apiService.put(
        AppUrl.estimationBaseUrl,
        "/unlink-order-line-item-and-tagging/$id",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateOrderEstimationDate({
    String? id,
    String? estimation_date,
  }) async {
    try {
      final response = await _apiService.put(
        AppUrl.estimationBaseUrl,
        "/order-estimation-date/$id",
        queryParameters: {"estimation_date": estimation_date},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createOrder(CreateOrderRequest create_order_request) async {
    try {
      final body = create_order_request.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/create-order",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getOrdersListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/paginated-orders?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-orders?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.estimationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //jewellery plan

  // Future getSetupPlanListing() async {
  //   try {
  //     final response = await _apiService.get(
  //       AppUrl.estimationBaseUrl,
  //       '/jewellery_plans/',
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future getTermsAndCondition() async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/templates',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createJewelleryPlan(
    CreateJewelleryPlanRequest create_jewellery_plan_request,
  ) async {
    try {
      final body = create_jewellery_plan_request.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/create_plan",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getJeweleryPlanListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/jewellery_plans?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/jewellery_plans?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.estimationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> invoiceNumber({
    required String invoiceType,
  }) async {
    try {
      final body = {
        "types": [invoiceType],
      };
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Sales

  Future getSalesRecordById({required String? id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/sales-record/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSalesReturnRecordById({required String? id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/sales-return-record/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future salesNumber() async {
    try {
      final body = {
        "types": ["sale_number"],
      };
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future submitEstimationRecord({
    required PostEstimateRequestModel estimation_record_request,
  }) async {
    try {
      final body = estimation_record_request.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/estimation-record",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future estimateNumber() async {
    try {
      final body = {
        "types": ["estimate_number"],
      };
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAdvanceBooking({String? code, String? mobileNumber}) async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/advance-booking',
        queryParameters: {"code": code, "mobile_number": mobileNumber},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getOrderByOrderNumber(String orderNumber) async {
    String path = '/order';

    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        path,
        queryParameters: {"order_number": orderNumber},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getJewelleryPlan({required String? jlSubscriptionId}) async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/subscription',
        queryParameters: {"jl_subscription_id": jlSubscriptionId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getEstimationRecordListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-estimation-record?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-estimation-record?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.estimationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future submitOldGold(OldGoldRequest oldGoldRequest) async {
    try {
      final body = oldGoldRequest.toJson();

      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        "/old-gold",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addSalesInvoice({required PostSalesRequestModel salesRequest}) async {
    try {
      final body = jsonEncode(salesRequest.toJson());
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/create-sales-record',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sales By Sales EStimation Number
  Future getSaleByEstimationNumber({
    String? estimateNumber,
    String? metal_type,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-estimation-record-by-estimate-number',
        queryParameters: {
          "estimate_number": estimateNumber,
          "metal_type": metal_type,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getQuickOldGoldByEstimateNumber({String? estimateNumber}) async {
    try {
      final response = await _apiService.get(
        AppUrl.estimationBaseUrl,
        '/get-old-gold-by-estimate-number',
        queryParameters: {"old_gold_estimate_number": estimateNumber},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // GET Sales paginated
  Future getSalesPaginated({
    String? offsetId,
    int limit = 10,
    String query = '',
    required SalesListingRequest requestBody,
  }) async {
    String path;
    if (offsetId != null) {
      path = '/sales-listing?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/sales-listing?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        data: jsonEncode(requestBody.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSales({required String id}) async {
    try {
      await _apiService.delete(
        AppUrl.estimationBaseUrl,
        '/cancel-sales-record/$id',
      );
    } catch (e) {
      rethrow;
    }
  }
  // Sales Return

  Future getSalesReturnListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    required SalesReturnListingRequest requestBody,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/sales-return-listing?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/sales-return-listing?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        data: jsonEncode(requestBody.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSaleBySalesNumber({String? salesNumber}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-sales-record-by-sales-number',
        queryParameters: {"sales_number": salesNumber},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addSalesReturnInvoice({
    required PostSalesReturnRequest salesRequest,
  }) async {
    try {
      final body = jsonEncode(salesRequest.toJson());
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        '/sales-return-record',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPartyBalance({required List<String> partyNames}) async {
    try {
      final body = partyNames;
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/party-balances-aggregate',
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSalesRecoedDetailReport({
    required SalesRecordDetailReportRequest requestBody,
  }) async {
    try {
      final body = jsonEncode(requestBody.toJson());
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        '/sales-record-detail-report',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
