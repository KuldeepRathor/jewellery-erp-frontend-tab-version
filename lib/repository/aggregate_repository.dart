import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/customer_balance/models/customer_balances_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/models/get_party_details_by_ledger_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/models/post_payment_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/payments_listing/models/get_payments_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/view_paymnets/model/get_payments_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/models/post_receipt_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/receipt_listing/models/get_receipts_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/view_receipt/model/get_receipts_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_dashboard/model/customer_dashboard_detail_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/view_estimate/model/get_estimate_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/model/get_global_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_orders_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_assign_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/models/get_reorder_line_items_by_design_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/models/post_reorder_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_listing/model/get_reorder_level_list_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_listing/model/get_wanted_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/get_purchase_invoice_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/model/daily_reports_filter_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/model/daily_reports_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/get_repairs_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_assign_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/model/get_inward_report_details_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/model/get_inward_report_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/model/get_inward_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/model/get_inward_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_details_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/create_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/delete_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/edit_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/edit_sequence_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_ornament_dropdown_voucher_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_sequence_listing_grouped_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_sequences_listing_grouped_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_voucher_sections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_voucher_types_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/update_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer_listing/model/counter_transfer_listing_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/multipart_upload/multipart_uploads_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/multipart_upload/multipart_uploads_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/multipart_upload/response_models.dart';
import 'package:jewellery_erp_frontend_tab_version/services/aggregate_services.dart';

class AggregateRepository {
  final AggregateServices _aggregateServices = AggregateServices();

  Future<Uint8List> getWebStoreInvoicePdf({required String invoiceId}) async {
    try {
      final response = await _aggregateServices.getWebStoreInvoicePdf(
        invoiceId: invoiceId,
      );

      // If response is already Uint8List, return it
      if (response is Uint8List) {
        return response;
      }
      // If response is List<int>, convert to Uint8List
      else if (response is List<int>) {
        return Uint8List.fromList(response);
      }
      // Handle other cases
      else {
        throw Exception('Invalid response type for PDF');
      }
    } catch (e) {
      log('Repository error getting webstore invoice PDF: $e');
      rethrow;
    }
  }

  // Video Upload - Initiate
  Future<MultipartUploadsResponse> multipartUploads({
    required MultipartUploadsRequest multipartUploadsRequest,
  }) async {
    try {
      final response = await _aggregateServices.multipartUploads(
        multipartUploadsRequest: multipartUploadsRequest,
      );
      return MultipartUploadsResponse.fromJson(response);
    } catch (e) {
      log('Repository error uploading video: $e');
      rethrow;
    }
  }

  // Get presigned URLs for parts
  Future<MultipartPresignedUrlsResponse> getMultipartPresignedUrls({
    required String uploadId,
    required List<int> partNumbers,
  }) async {
    try {
      final response = await _aggregateServices.getMultipartPresignedUrls(
        uploadId: uploadId,
        partNumbers: partNumbers,
      );
      // The response is a list, so parse it accordingly
      return MultipartPresignedUrlsResponse.fromJson(response);
    } catch (e) {
      log('Repository error getting presigned URLs: $e');
      rethrow;
    }
  }

  // Confirm part upload
  Future<MultipartConfirmResponse> confirmMultipartPart({
    required String uploadId,
    required int partNumber,
    required String etag,
    required int size,
  }) async {
    try {
      final response = await _aggregateServices.confirmMultipartPart(
        uploadId: uploadId,
        partNumber: partNumber,
        etag: etag,
        size: size,
      );
      return MultipartConfirmResponse.fromJson(response);
    } catch (e) {
      log('Repository error confirming part: $e');
      rethrow;
    }
  }

  // Complete multipart upload
  Future<MultipartCompleteResponse> completeMultipartUpload({
    required String uploadId,
  }) async {
    try {
      final response = await _aggregateServices.completeMultipartUpload(
        uploadId: uploadId,
      );
      return MultipartCompleteResponse.fromJson(response);
    } catch (e) {
      log('Repository error completing multipart upload: $e');
      rethrow;
    }
  }

  //Global Settings

  Future<List<GetSequencesListingGroupedResponse>> getSequencesListingGrouped({
    GetSequencesListingGroupedRequest? request,
  }) async {
    try {
      final response = await _aggregateServices.getSequencesListingGrouped(
        request: request,
      );
      if (response is List) {
        return response
            .map((item) => GetSequencesListingGroupedResponse.fromJson(item))
            .toList();
      } else {
        return [GetSequencesListingGroupedResponse.fromJson(response)];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<List<EditSequenceResponse>>> editSequence({
    required EditSequenceRequest editSequenceRequest,
  }) async {
    try {
      final response = await _aggregateServices.editSequence(
        editSequenceRequest: editSequenceRequest,
      );

      final parsedList =
          (response as List)
              .map((e) => EditSequenceResponse.fromJson(e))
              .toList();

      return ApiResponse.completed(parsedList);
    } catch (e) {
      log('Repository error creating sequence: $e');
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<void>> updateSequence({
    required UpdateSequenceRequest updateSequenceRequest,
  }) async {
    try {
      final response = await _aggregateServices.updateSequence(
        updateSequenceRequest: updateSequenceRequest,
      );
      // ignore: void_checks
      return ApiResponse.completed(response);
    } catch (e) {
      log('Repository error creating sequence: $e');
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<dynamic>> createSequence({
    required CreateSequenceRequest createSequenceRequest,
  }) async {
    try {
      final response = await _aggregateServices.createSequence(
        createSequenceRequest: createSequenceRequest,
      );

      return ApiResponse.completed(response);
    } catch (e) {
      log('Repository error creating sequence: $e');
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<dynamic>> deleteSequence({
    required DeleteSequenceRequest deleteSequenceRequest,
  }) async {
    try {
      final response = await _aggregateServices.deleteSequence(
        deleteSequenceRequest: deleteSequenceRequest,
      );

      final data = response is String ? jsonDecode(response) : response;

      if (data['deleted'] == true) {
        return ApiResponse.completed(data);
      } else {
        return ApiResponse.error(data['reason'] ?? 'Failed to delete row');
      }
    } catch (e) {
      log('Repository error deleting sequence: $e');
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<GetOrnamentTypeDropdownVoucherResponse>>>
  getOrnamentTypeDropdownVoucher() async {
    try {
      final response =
          await _aggregateServices.getOrnamentTypeDropdownVoucher();

      // The API returns data directly as an array
      List<GetOrnamentTypeDropdownVoucherResponse> ornamentTypes = [];

      if (response is List) {
        ornamentTypes =
            response
                .map(
                  (item) =>
                      GetOrnamentTypeDropdownVoucherResponse.fromJson(item),
                )
                .toList();
      }

      return ApiResponse.completed(ornamentTypes);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<GetVoucherSectionResponse>>>
  getVoucherSections() async {
    try {
      final response = await _aggregateServices.getVoucherSections();

      // The API returns data directly as an array
      List<GetVoucherSectionResponse> voucherSections = [];

      if (response is List) {
        voucherSections =
            response
                .map((item) => GetVoucherSectionResponse.fromJson(item))
                .toList();
      }

      return ApiResponse.completed(voucherSections);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<GetVoucherTypeResponse>>> getVoucherTypes() async {
    try {
      final response = await _aggregateServices.getVoucherTypes();

      // The API returns data directly as an array
      List<GetVoucherTypeResponse> voucherTypes = [];

      if (response is List) {
        voucherTypes =
            response
                .map((item) => GetVoucherTypeResponse.fromJson(item))
                .toList();
      }

      return ApiResponse.completed(voucherTypes);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<GetGlobalSettingsResponse> getGlobalSettings() async {
    final response = await _aggregateServices.getGlobalSettings();
    return GetGlobalSettingsResponse.fromJson(response);
  }

  Future<GetPurchaseInvoiceById> getPurchaseInvoiceById({
    required String id,
  }) async {
    final response = await _aggregateServices.getPurchaseInvoiceById(id: id);
    return GetPurchaseInvoiceById.fromJson(response);
  }
  //Estimation

  Future<GetEstimateByIdResponse> getEstimationdById({
    required String id,
  }) async {
    final response = await _aggregateServices.getEstimationById(id: id);
    return GetEstimateByIdResponse.fromJson(response);
  }

  //customer dashboard

  Future<CustomerDashboardDetailsResponse> getCustomerDashboardDetails({
    required String id,
  }) async {
    final response = await _aggregateServices.getCustomerDashboardDetails(
      id: id,
    );
    return CustomerDashboardDetailsResponse.fromJson(response);
  }

  //counter transfer

  Future<CounterTransferListingAggregateResponse>
  getCounterTransferListingAggregate({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await _aggregateServices
        .getCounterTransferListingAggregate(
          offsetId: offsetId,
          limit: limit,
          query: query,
        );
    final data = CounterTransferListingAggregateResponse.fromJson(response);
    return data;
  }

  //Sales

  Future<GetSalesRecordByIdAggregateResponse> getSalesRecordById({
    required String id,
  }) async {
    final response = await _aggregateServices.getSalesRecordById(id: id);
    return GetSalesRecordByIdAggregateResponse.fromJson(response);
  }

  //Repairs

  Future<RepairAssignRequest> assignRepairToVendor({
    required RepairAssignRequest repair_assign_request,
    required String repair_line_item_id,
  }) async {
    await _aggregateServices.assignRepairToVendor(
      repair_assign_request: repair_assign_request,
      repair_line_item_id: repair_line_item_id,
    );
    return RepairAssignRequest();
  }

  Future<GetRepairsListingResponse> getRepairsListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await _aggregateServices.getRepairsListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetRepairsListingResponse.fromJson(response);
    return data;
  }

  //Orders

  Future<OrderAssignRequest> assignOrderToVendor({
    required OrderAssignRequest order_assign_request,
    required String order_line_item_id,
  }) async {
    await _aggregateServices.assignOrderToVendor(
      order_assign_request: order_assign_request,
      order_line_item_id: order_line_item_id,
    );
    return OrderAssignRequest();
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _aggregateServices.cancelOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetOrdersListingResponse> getOrdersListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await _aggregateServices.getOrdersListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetOrdersListingResponse.fromJson(response);
    return data;
  }

  Future<GetReceiptsByIdResponse> getReceiptsById({required String id}) async {
    final response = await _aggregateServices.getReceiptsById(id: id);
    return GetReceiptsByIdResponse.fromJson(response);
  }

  Future<GetPaymentsByIdResponse> getPaymentsById({required String id}) async {
    final response = await _aggregateServices.getPaymentsById(id: id);
    return GetPaymentsByIdResponse.fromJson(response);
  }

  Future<GetPartyDetailsByLedgerResponse> getPartyDetailsById({
    required String partyId,
    required bool isCustomer,
  }) async {
    final response = await _aggregateServices.getPartyDetailsById(
      partyId: partyId,
      isCustomer: isCustomer,
    );
    return GetPartyDetailsByLedgerResponse.fromJson(response);
  }

  Future<PostPaymentsRequest> postPayment({
    required PostPaymentsRequest postPaymentsRequest,
  }) async {
    await _aggregateServices.postPayment(
      postPaymentsRequest: postPaymentsRequest,
    );
    return PostPaymentsRequest();
  }

  Future<GetPaymentsPaginated> getPaymentsPaginated({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    log("The query will be r $query");
    final response = await _aggregateServices.getPaymentsPaginated(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );

    final data = GetPaymentsPaginated.fromJson(response);
    return data;
  }

  Future<void> cancelPayment({required String paymentId}) async {
    try {
      await _aggregateServices.cancelPayment(paymentId: paymentId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelPaymentReceipt(String receiptId) async {
    try {
      await _aggregateServices.cancelPaymentReceipt(receiptId);
    } catch (e) {
      rethrow;
    }
  }

  Future<PostReceiptRequest> postReceipt({
    required PostReceiptRequest postPaymentsRequest,
  }) async {
    await _aggregateServices.postReceipt(
      postPaymentsRequest: postPaymentsRequest,
    );
    return PostReceiptRequest();
  }

  Future<GetReceiptsPaginated> getReceiptsPaginated({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    log("The query will be r $query");
    final response = await _aggregateServices.getReceiptsPaginated(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );

    final data = GetReceiptsPaginated.fromJson(response);
    return data;
  }

  Future<GetReorderLineItemsResponse> getReorderLineItemsByDesignId({
    required String designId,
  }) async {
    final response = await _aggregateServices.getReorderLineItemsByDesignId(
      designId: designId,
    );
    return GetReorderLineItemsResponse.fromJson(response);
  }

  Future<PostReorderRequest> postReorder({
    required PostReorderRequest postReorderRequest,
  }) async {
    await _aggregateServices.postReorder(
      postReorderRequest: postReorderRequest,
    );
    return PostReorderRequest();
  }

  Future<GetReorderLevelResponse> getPaginatedWReorderList({
    String? offsetId,
    int limit = 10,
    String query = '',
    required GetReorderLevelRequest requestBody,
  }) async {
    log("The query will be r $query");
    final response = await _aggregateServices.getPaginatedWReorderList(
      offsetId: offsetId,
      limit: limit,
      query: query,
      requestBody: requestBody,
    );

    final data = GetReorderLevelResponse.fromJson(response);
    return data;
  }

  Future<GetOutwardReportResponse> getOutwardReport({
    required GetOutwardReportRequest requestBody,
  }) async {
    final response = await _aggregateServices.getOutwardReport(
      requestBody: requestBody,
    );

    final data = GetOutwardReportResponse.fromJson(response);
    return data;
  }

  Future<GetOutwardReportDetailsResponse> getOutwardReportDetails({
    // required String code,
    GetOutwardReportDetailRequest? requestBody,
  }) async {
    final response = await _aggregateServices.getOutwardReportDetails(
      // code: code,
      requestBody: requestBody,
    );

    final data = GetOutwardReportDetailsResponse.fromJson(response);
    return data;
  }

  Future<GetInwardReportResponse> getInwardReport({
    required GetInwardReportRequest requestBody,
  }) async {
    final response = await _aggregateServices.getInwardReport(
      requestBody: requestBody,
    );

    final data = GetInwardReportResponse.fromJson(response);
    return data;
  }

  Future<GetInwardReportDetailsResponse> getInwardReportDetails({
    // required String code,
    GetInwardReportDetailRequest? requestBody,
  }) async {
    final response = await _aggregateServices.getInwardReportDetails(
      // code: code,
      requestBody: requestBody,
    );

    final data = GetInwardReportDetailsResponse.fromJson(response);
    return data;
  }

  Future<DailyReportResponse> getCompleteDailyReport({
    DailyReportsFilterRequest? requestBody,
  }) async {
    try {
      // Convert the request to JSON map
      final requestMap = requestBody?.toJson();

      // Remove null or empty values
      requestMap?.removeWhere(
        (key, value) => value == null || (value is List && value.isEmpty),
      );

      final response = await _aggregateServices.getCompleteDailyReport(
        requestBody: requestMap,
      );

      final data = DailyReportResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomerBalancesAggregateResponse>
  getCustomerBalancesAggregate() async {
    final response = await _aggregateServices.getCustomerBalancesAggregate();
    return CustomerBalancesAggregateResponse.fromJson(response);
  }
}
