// feature Repository

import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_orders_by_order_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/post_estimate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_old_gold/models/global_old_gold_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/estimation_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_advance_booking_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_jewellery_plan_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_quick_old_gold_by_estimate_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/old_gold_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/estimation_listing/model/get_estimation_record_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/create_order_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_orders_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_images_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/view_order/model/get_order_details_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/model/create_repair_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_images_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/model/get_repair_details_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/model/sales_record_detail_report_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/model/sales_record_detail_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_date_wise/model/get_purchase_report_date_wise_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_date_wise/model/get_purchase_report_date_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_month_wise/model/get_purchase_report_month_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_transaction_wise/model/get_purchase_report_transaction_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_date_wise/model/get_sales_report_date_wise_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_date_wise/model/get_sales_report_date_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_month_wise/model/get_sales_report_month_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_transaction_wise/model/get_sales_report_transaction_wise_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_party_balance_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_receipt_methods_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sales_return_credit_note_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_listing_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/sales_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/models/get_sales_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/models/post_sales_return_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/model/get_sales_return_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/model/sales_return_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/model/get_sales_return_record_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/create_jewellery_plan_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/post_sales_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_setup_plan_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/terms_and_condition_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/services/estimation_services.dart';

class EstimationRepository {
  final EstimationServices estimationServices = EstimationServices();

  Future<GetPurchaseReportTransactionWiseReponse>
  getPurchaseReportTransactionWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    // GetCancelReportRequest? filterRequest,
  }) async {
    final response = await estimationServices
        .getPurchaseReportTransactionWiseListing(
          offsetId: offsetId,
          limit: limit,
          query: query,
          // filterRequest: filterRequest,
        );
    final data = GetPurchaseReportTransactionWiseReponse.fromJson(response);
    return data;
  }

  Future<GetPurchaseReportDateWiseReponse> getPurchaseReportDateWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    GetPurchaseReportDateWiseRequest? filterRequest,
  }) async {
    final response = await estimationServices.getPurchaseReportDateWiseListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
      filterRequest: filterRequest,
    );
    final data = GetPurchaseReportDateWiseReponse.fromJson(response);
    return data;
  }

  Future<GetPurchaseReportMonthWiseReponse> getPurchaseReportMonthWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    // GetCancelReportRequest? filterRequest,
  }) async {
    final response = await estimationServices.getPurchaseReportMonthWiseListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
      // filterRequest: filterRequest,
    );
    final data = GetPurchaseReportMonthWiseReponse.fromJson(response);
    return data;
  }

  Future<GetSalesReportTransactionWiseReponse>
  getSalesReportTransactionWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    // GetCancelReportRequest? filterRequest,
  }) async {
    final response = await estimationServices
        .getSalesReportTransactionWiseListing(
          offsetId: offsetId,
          limit: limit,
          query: query,
          // filterRequest: filterRequest,
        );
    final data = GetSalesReportTransactionWiseReponse.fromJson(response);
    return data;
  }

  Future<GetSalesReportDateWiseReponse> getSalesReportDateWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    GetSalesReportDateWiseRequest? filterRequest,
  }) async {
    final response = await estimationServices.getSalesReportDateWiseListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
      filterRequest: filterRequest,
    );
    final data = GetSalesReportDateWiseReponse.fromJson(response);
    return data;
  }

  Future<GetSalesReportMonthWiseReponse> getSalesReportMonthWiseListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    // GetCancelReportRequest? filterRequest,
  }) async {
    final response = await estimationServices.getSalesReportMonthWiseListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
      // filterRequest: filterRequest,
    );
    final data = GetSalesReportMonthWiseReponse.fromJson(response);
    return data;
  }

  Future<String> nextSequence({required String invoiceType}) async {
    final response = await estimationServices.nextSequence(
      invoiceType: invoiceType,
    );
    return response["values"][0]["value"];
  }

  Future<GetSalesDropdownResponse> getSalesDropdown() async {
    try {
      final response = await estimationServices.getSalesDropdown();
      final data = GetSalesDropdownResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetSalesDropdownResponse> getSalesDropdownWithQuery(
    String query,
  ) async {
    try {
      final response = await estimationServices.getSalesDropdown(query: query);
      final data = GetSalesDropdownResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  //Credit note
  Future<GetSalesReturnCreditNoteResponse> getSalesReturnCreditNote(
    String? partyId,
  ) async {
    try {
      final response = await estimationServices.getSalesReturnCreditNote(
        partyId,
      );
      return GetSalesReturnCreditNoteResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Methods
  Future<List<GetReceiptMethodsResponse>> getReceiptMethods() async {
    try {
      final response = await estimationServices.getReceiptMethods();
      // Assuming the response is a list
      if (response is List) {
        return response
            .map((item) => GetReceiptMethodsResponse.fromJson(item))
            .toList();
      } else {
        // If it's a single object, wrap it in a list
        return [GetReceiptMethodsResponse.fromJson(response)];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GetReceiptMethodsResponse> getPaymentMethods() async {
    try {
      final response = await estimationServices.getPaymentMethods();
      return GetReceiptMethodsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetSequencesDropdownResponse> getSequencesDropdown({
    required String? voucherType,
    required String? voucherSection,
  }) async {
    try {
      final response = await estimationServices.getSequencesDropdown(
        voucherType: voucherType,
        voucherSection: voucherSection,
      );

      return GetSequencesDropdownResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetRepairDetailsByIdResponse> getRepairDetailsById({
    required String? id,
  }) async {
    try {
      final response = await estimationServices.getRepairDetailsById(id: id);
      return GetRepairDetailsByIdResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetOrderDetailsByIdResponse> getOrderDetailsById({
    required String? id,
  }) async {
    try {
      final response = await estimationServices.getOrderDetailsById(id: id);
      return GetOrderDetailsByIdResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //Repairs
  Future<void> deleteRepair({required String id}) async {
    try {
      await estimationServices.deleteRepair(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future updateRepairEstimationDate({
    String? id,
    String? estimation_date,
  }) async {
    try {
      final response = await estimationServices.updateRepairEstimationDate(
        id: id,
        estimation_date: estimation_date,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<RepairImagesRequest> repairImage(
    RepairImagesRequest create_repair_request,
  ) async {
    final response = await estimationServices.repairImage(
      create_repair_request,
    );
    return RepairImagesRequest.fromJson(response);
  }

  Future<RepairImagesPresignedUrlRequest> repairImagePresignedUrl(
    RepairImagesPresignedUrlRequest create_repair_request,
  ) async {
    final response = await estimationServices.repairImagePresignedUrl(
      create_repair_request,
    );
    return RepairImagesPresignedUrlRequest.fromJson(response);
  }

  Future assignRepairStatus({
    String? id,
    String? tagging_line_item_id,
    String? status,
    String? sale_id,
  }) async {
    try {
      final response = await estimationServices.assignRepairStatus(
        id: id,
        tagging_line_item_id: tagging_line_item_id,
        status: status,
        sale_id: sale_id,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateRepairRequest> createRepair(
    CreateRepairRequest create_repair_request,
  ) async {
    final response = await estimationServices.createRepair(
      create_repair_request,
    );
    return CreateRepairRequest.fromJson(response);
  }

  //Orders
  Future<void> deleteOrder({required String id}) async {
    try {
      await estimationServices.deleteOrder(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetTaggingLineItemCodeTagResponse> getByExistingTag(String tag) async {
    final response = await estimationServices.getByExistingTag(tag);

    return GetTaggingLineItemCodeTagResponse.fromJson(response);
  }

  Future<OrderImagesRequest> orderImage(
    OrderImagesRequest create_order_request,
  ) async {
    final response = await estimationServices.orderImage(create_order_request);
    return OrderImagesRequest.fromJson(response);
  }

  Future<OrderImagesPresignedUrlRequest> orderImagePresignedUrl(
    OrderImagesPresignedUrlRequest create_order_request,
  ) async {
    final response = await estimationServices.orderImagePresignedUrl(
      create_order_request,
    );
    return OrderImagesPresignedUrlRequest.fromJson(response);
  }

  Future putOrderImages({
    required String putUrl,
    required String imagePath,
  }) async {
    final response = await estimationServices.putOrderImages(
      putUrl: putUrl,
      imagePath: imagePath,
    );
    return response;
  }

  Future assignOrderStatus({
    String? id,
    String? tagging_line_item_id,
    String? status,
    String? sale_id,
  }) async {
    try {
      final response = await estimationServices.assignOrderStatus(
        id: id,
        tagging_line_item_id: tagging_line_item_id,
        status: status,
        sale_id: sale_id,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future unlinkOrderItemAndTagging({String? id}) async {
    try {
      final response = await estimationServices.unlinkOrderItemAndTagging(
        id: id,
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
      final response = await estimationServices.updateOrderEstimationDate(
        id: id,
        estimation_date: estimation_date,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateOrderRequest> createOrder(
    CreateOrderRequest create_order_request,
  ) async {
    final response = await estimationServices.createOrder(create_order_request);
    return CreateOrderRequest.fromJson(response);
  }

  Future<GetOrdersListingResponse> getOrdersListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await estimationServices.getOrdersListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetOrdersListingResponse.fromJson(response);
    return data;
  }

  //jewellery Plan

  //  Future<GetSetupPlanListingResponse> getSetupPlanListing() async {
  //     try {
  //       final response = await estimationServices.getSetupPlanListing();
  //       return GetSetupPlanListingResponse.fromJson(response);
  //     } catch (e) {
  //       rethrow;
  //     }
  //   }

  Future<TermsAndConditionResponse> getTermsAndCondition() async {
    try {
      final response = await estimationServices.getTermsAndCondition();
      return TermsAndConditionResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateJewelleryPlanRequest> createJewelleryPlan(
    CreateJewelleryPlanRequest create_jewellery_plan_request,
  ) async {
    final response = await estimationServices.createJewelleryPlan(
      create_jewellery_plan_request,
    );
    return CreateJewelleryPlanRequest.fromJson(response);
  }

  Future<GetSetupPlanListingResponse> getJeweleryPlanListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await estimationServices.getJeweleryPlanListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetSetupPlanListingResponse.fromJson(response);
    return data;
  }

  Future<String> getNextInvoiceNumber({required String invoiceType}) async {
    final response = await estimationServices.invoiceNumber(
      invoiceType: invoiceType,
    );
    return response["values"][0]["value"];
  }

  Future<PostEstimateResponse> submitEstimationRecord({
    required PostEstimateRequestModel estimation_record_request,
  }) async {
    final response = await estimationServices.submitEstimationRecord(
      estimation_record_request: estimation_record_request,
    );
    return PostEstimateResponse.fromJson(response);
  }

  Future<String> estimationNumber() async {
    final response = await estimationServices.estimateNumber();
    return response["values"][0]["value"];
  }

  Future<String> salesNumber() async {
    final response = await estimationServices.salesNumber();
    return response["values"][0]["value"];
  }

  Future<GetAdvanceBookingResponse> getAdvanceBooking({
    String? code,
    String? mobileNumber,
  }) async {
    try {
      final response = await estimationServices.getAdvanceBooking(
        code: code,
        mobileNumber: mobileNumber,
      );
      return GetAdvanceBookingResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrdersByOrderNumberResponse> getOrderByOrderNumber(
    String orderNumber,
  ) async {
    final response = await estimationServices.getOrderByOrderNumber(
      orderNumber,
    );
    final data = OrdersByOrderNumberResponse.fromJson(response);
    return data;
  }

  Future<JewelleryPlanResponse> getJewelleryPlan({
    required String? jlSubscriptionId,
  }) async {
    try {
      final response = await estimationServices.getJewelleryPlan(
        jlSubscriptionId: jlSubscriptionId,
      );
      return JewelleryPlanResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetEstimationRecordListing> getEstimationRecordListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await estimationServices.getEstimationRecordListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetEstimationRecordListing.fromJson(response);
    return data;
  }

  Future<PostGlobalOldGoldResponse> submitOldGold(
    OldGoldRequest oldGoldRequest,
  ) async {
    final response = await estimationServices.submitOldGold(oldGoldRequest);
    return PostGlobalOldGoldResponse.fromJson(response);
  }

  // Sales

  // Future<GetSalesRecordByIdResponse> getSalesRecordById({
  //   required String? id,
  // }) async {
  //   try {
  //     final response = await estimationServices.getSalesRecordById(
  //       id: id,
  //     );
  //     return GetSalesRecordByIdResponse.fromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<GetSalesReturnRecordByIdResponse> getSalesReturnRecordById({
    required String? id,
  }) async {
    try {
      final response = await estimationServices.getSalesReturnRecordById(
        id: id,
      );
      return GetSalesReturnRecordByIdResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetSalesRecordByIdAggregateResponse> addSalesInvoice({
    required PostSalesRequestModel salesRequest,
  }) async {
    final response = await estimationServices.addSalesInvoice(
      salesRequest: salesRequest,
    );

    return GetSalesRecordByIdAggregateResponse.fromJson(response);
  }

  // Sales By Sales EStimation Number
  Future<GetSaleByEstimateResponse> getSaleByEstimationNumber({
    String? estimateNumber,
    String? metalType,
  }) async {
    final response = await estimationServices.getSaleByEstimationNumber(
      estimateNumber: estimateNumber,
      metal_type: metalType,
    );
    return GetSaleByEstimateResponse.fromJson(response);
  }

  Future<GetQuickOldGoldByEstimateNumberResponse>
  getQuickOldGoldByEstimateNumber({String? estimateNumber}) async {
    final response = await estimationServices.getQuickOldGoldByEstimateNumber(
      estimateNumber: estimateNumber,
    );
    return GetQuickOldGoldByEstimateNumberResponse.fromJson(response);
  }

  Future<GetSalesPaginatedResponse> getSalesPaginated({
    required SalesListingRequest requestBody,
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await estimationServices.getSalesPaginated(
      offsetId: offsetId,
      limit: limit,
      query: query,
      requestBody: requestBody,
    );
    final data = GetSalesPaginatedResponse.fromJson(response);
    return data;
  }

  Future<void> deleteSales({required String id}) async {
    try {
      await estimationServices.deleteSales(id: id);
    } catch (e) {
      rethrow;
    }
  }
  // Sales Return

  Future<GetSalesReturnPaginatedResponse> getSalesReturnListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    required SalesReturnListingRequest requestBody,
  }) async {
    final response = await estimationServices.getSalesReturnListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
      requestBody: requestBody,
    );
    final data = GetSalesReturnPaginatedResponse.fromJson(response);
    return data;
  }

  Future<GetSalesRecordByIdAggregateResponse> getSaleBySalesNumber({
    String? salesNumber,
  }) async {
    final response = await estimationServices.getSaleBySalesNumber(
      salesNumber: salesNumber,
    );
    return GetSalesRecordByIdAggregateResponse.fromJson(response);
  }

  // Future<GetEstimationByEstimateResponse> getEstimateByEstimationNumber({
  //   String? estimateNumber,
  // }) async {
  //   final response = await estimationServices.getEstimateByEstimationNumber(
  //       estimateNumber: estimateNumber);
  //   return GetEstimationByEstimateResponse.fromJson(response);
  // }

  Future<PostSalesReturnRequest> addSalesReturnInvoice({
    required PostSalesReturnRequest salesRequest,
  }) async {
    await estimationServices.addSalesReturnInvoice(salesRequest: salesRequest);

    // return PostSalesRequestModel.fromJson(response);
    return PostSalesReturnRequest();
  }

  Future<PartyBalanceResponse> getPartyBalance({
    required List<String> partyNames,
  }) async {
    final response = await estimationServices.getPartyBalance(
      partyNames: partyNames,
    );

    // return PostSalesRequestModel.fromJson(response);
    return PartyBalanceResponse.fromJson(response);
  }

  //Sales Record Detail Report
  Future<SalesRecordDetailReportResponse> getSalesRecoedDetailReport({
    required SalesRecordDetailReportRequest requestBody,
  }) async {
    final response = await estimationServices.getSalesRecoedDetailReport(
      requestBody: requestBody,
    );

    return SalesRecordDetailReportResponse.fromJson(response);
  }
}
