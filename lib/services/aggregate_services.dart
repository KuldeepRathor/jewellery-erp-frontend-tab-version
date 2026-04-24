import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/models/post_payment_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/models/post_receipt_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_assign_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/models/post_reorder_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_listing/model/get_reorder_level_list_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_assign_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/model/get_inward_report_details_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/model/get_inward_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_details_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/create_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/delete_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/edit_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_sequence_listing_grouped_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/update_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/multipart_upload/multipart_uploads_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class AggregateServices {
  final HttpDioClient _apiService = Get.find();

  Future<dynamic> getWebStoreInvoicePdf({required String invoiceId}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/webstore-invoice-pdf/$invoiceId',
        options: Options(
          responseType: ResponseType.bytes, // Important for PDF download
          headers: {
            'accept':
                'application/pdf', // Change to PDF since we're downloading a PDF
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Video Upload - Initiate multipart upload
  Future multipartUploads({
    required MultipartUploadsRequest multipartUploadsRequest,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/multipart-uploads',
        data: multipartUploadsRequest.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get presigned URLs for multipart upload parts
  Future getMultipartPresignedUrls({
    required String uploadId,
    required List<int> partNumbers,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/multipart-uploads/$uploadId/parts/presigned-urls',
        data: {'part_numbers': partNumbers},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> uploadPartToS3Alternative({
    required String presignedUrl,
    required Uint8List partData,
    required String contentType,
  }) async {
    try {
      final response = await _apiService.putUrlLink(
        presignedUrl,
        data: partData,
        options: Options(
          headers: {'Content-Type': contentType},
          responseType: ResponseType.plain,
          validateStatus: (status) => status! < 500,
        ),
      );

      // If your HttpDioClient returns the Dio Response object
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Confirm individual part upload
  Future confirmMultipartPart({
    required String uploadId,
    required int partNumber,
    required String etag,
    required int size,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/multipart-uploads/$uploadId/parts/$partNumber/confirm',
        data: {'etag': etag, 'size': size},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Complete multipart upload
  Future completeMultipartUpload({required String uploadId}) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/multipart-uploads/$uploadId/complete',
        data: '', // Empty body as per the curl example
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  //Global Settings

  Future getSequencesListing() async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/get-sequences-listing',
        data: "{}",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSequencesListingGrouped({
    GetSequencesListingGroupedRequest? request,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/get-sequences-listing-grouped',
        data: request != null ? request.toRawJson() : "{}",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future editSequence({
    required EditSequenceRequest editSequenceRequest,
  }) async {
    try {
      final body = editSequenceRequest.toJson();

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        "/get-sequences-listing",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateSequence({
    required UpdateSequenceRequest updateSequenceRequest,
  }) async {
    try {
      final body = updateSequenceRequest.toJson();

      final response = await _apiService.put(
        AppUrl.aggregateBaseUrl,
        "/update-sequence",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createSequence({
    required CreateSequenceRequest createSequenceRequest,
  }) async {
    try {
      final body = createSequenceRequest.toJson();

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        "/create-sequence",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteSequence({
    required DeleteSequenceRequest deleteSequenceRequest,
  }) async {
    try {
      final body = deleteSequenceRequest.toJson();

      final response = await _apiService.delete(
        AppUrl.aggregateBaseUrl,
        "/delete-sequence",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getOrnamentTypeDropdownVoucher() async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-ornament-type-dropdown-voucher',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getVoucherTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-voucher-types',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getVoucherSections() async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-voucher-sections',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getGlobalSettings() async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-global-settings',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPurchaseInvoiceById({required String id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/purchase-invoice/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Estimation

  Future getEstimationById({required String id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-estimation-record-by-id-aggregated/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //customer dashboard

  Future getCustomerDashboardDetails({required String id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/customer-dashboard-details',
        queryParameters: {"id": id},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //counter transfer
  Future getCounterTransferListingAggregate({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-counter-transfer-aggregated?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-counter-transfer-aggregated?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //sales

  Future getSalesRecordById({required String id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/sales-record/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Repairs
  Future assignRepairToVendor({
    required String repair_line_item_id,
    required RepairAssignRequest repair_assign_request,
  }) async {
    try {
      final body = repair_assign_request.toJson();

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/repair-assign',
        queryParameters: {"repair_line_item_id": repair_line_item_id},
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getRepairsListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/paginated-repairs?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-repairs?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Orders

  Future assignOrderToVendor({
    required String order_line_item_id,
    required OrderAssignRequest order_assign_request,
  }) async {
    try {
      final body = order_assign_request.toJson();

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/order-assign',
        queryParameters: {"order_line_item_id": order_line_item_id},
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _apiService.delete(
        AppUrl.estimationBaseUrl,
        '/cancel-order/$orderId',
      );
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
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getReceiptsById({required String id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/payment-receipt-by-id',
        queryParameters: {"id": id},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPaymentsById({required String id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/payment-by-id',
        queryParameters: {"id": id},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPartyDetailsById({
    required String partyId,
    required bool isCustomer,
  }) async {
    String value;
    if (isCustomer) {
      value = 'customer';
    } else {
      value = 'vendor';
    }
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-party-details/$partyId?party_type=$value',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future postPayment({required PostPaymentsRequest postPaymentsRequest}) async {
    try {
      final body = postPaymentsRequest.toJson();

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        "/payments",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPaymentsPaginated({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/payments?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/payments?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelPayment({required String paymentId}) async {
    try {
      await _apiService.delete(
        AppUrl.aggregateBaseUrl,
        '/cancel-payment/$paymentId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelPaymentReceipt(String receiptId) async {
    try {
      await _apiService.delete(
        AppUrl.aggregateBaseUrl,
        '/cancel-payment-receipt/$receiptId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future postReceipt({required PostReceiptRequest postPaymentsRequest}) async {
    try {
      final body = postPaymentsRequest.toJson();

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        "/payments-receipt",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getReceiptsPaginated({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/payments-receipt?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/payments-receipt?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getReorderLineItemsByDesignId({required String designId}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/reorder-aggregate',
        queryParameters: {"design_id": designId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future postReorder({required PostReorderRequest postReorderRequest}) async {
    try {
      final body = postReorderRequest.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/create-reorder",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPaginatedWReorderList({
    String? offsetId,
    int limit = 10,
    String query = '',
    required GetReorderLevelRequest requestBody,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-reorder-aggregate?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-reorder-aggregate?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
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

  Future getOutwardReport({
    required GetOutwardReportRequest requestBody,
  }) async {
    String path = "/item-wise-outward-report";

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

  Future getOutwardReportDetails({
    // required String code,
    GetOutwardReportDetailRequest? requestBody,
  }) async {
    String path = "/item-wise-outward_detail-report";

    try {
      // Prepare the request body with filters
      Map<String, dynamic> data = {};
      if (requestBody != null) {
        data = requestBody.toJson();
      }

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        // queryParameters: {"code": code},
        data: jsonEncode(data),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getInwardReport({required GetInwardReportRequest requestBody}) async {
    String path = "/item-wise-inward-report";

    try {
      // log("The query will be $query");
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

  Future getInwardReportDetails({
    // required String code,
    GetInwardReportDetailRequest? requestBody,
  }) async {
    String path = "/item-wise-inward-detail-report";

    try {
      // Prepare the request body with filters
      Map<String, dynamic> data = {};
      if (requestBody != null) {
        data = requestBody.toJson();
      }

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        // queryParameters: {"code": code},
        data: jsonEncode(data),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCompleteDailyReport({
    Map<String, dynamic>? requestBody,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/complete-daily-report',
        data: requestBody,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCustomerBalancesAggregate() async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/customer-balances-aggregate',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
