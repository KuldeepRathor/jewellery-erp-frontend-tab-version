// feature Repository

import 'dart:developer';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/purchase_invoice_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_paginated_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/model/purchase_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/model/purchase_invoice_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/get_purchase_record_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/services/purchase_invoice_services.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_resturn_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_return_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_listing/models/get_paginated_purchase_return_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';

class PurchaseInvoiceRepository {
  final PurchaseInvoiceServices _purchaseInvoiceServices =
      PurchaseInvoiceServices();

  Future<GetSequencesDropdownResponse> getSequencesDropdown({
    required String? voucherType,
    required String? voucherSection,
  }) async {
    try {
      final response = await _purchaseInvoiceServices.getSequencesDropdown(
        voucherType: voucherType,
        voucherSection: voucherSection,
      );

      return GetSequencesDropdownResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPurchaseRecordDropdownResponse> getPurchaseRecordDropdown({
    String? party_id,
  }) async {
    try {
      final response = await _purchaseInvoiceServices.getPurchaseRecordDropdown(
        party_id: party_id,
      );
      final data = GetPurchaseRecordDropdownResponse.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<PurchasePresignedUrlRequest> catalogImagePresignedUrl(
    PurchasePresignedUrlRequest request,
  ) async {
    try {
      final response = await _purchaseInvoiceServices.purchasePresignedUrl(
        request,
      );
      return PurchasePresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting purchase presigned URL: $e');
      rethrow;
    }
  }

  Future<void> editPurchaseAttachments({
    required String invoiceId,
    required List<PurchasePresignedUrlImage> attachments,
  }) async {
    try {
      final data = {
        "id": invoiceId,
        "purchase_attachments":
            attachments.map((attachment) => attachment.toJson()).toList(),
      };

      await _purchaseInvoiceServices.editPurchaseAttachments(
        invoiceId: invoiceId,
        data: data,
      );
    } catch (e) {
      log('Error updating purchase attachments: $e');
      rethrow;
    }
  }

  Future putPurchaseAttachments({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await _purchaseInvoiceServices.putPurchaseAttachments(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading attachment to S3: $e');
      rethrow;
    }
  }

  Future<List<PaymentMethodResponse>> getPaymentMethods() async {
    try {
      final response = await _purchaseInvoiceServices.getPaymentMethods();
      if (response is List) {
        return (response)
            .map((item) => PaymentMethodResponse.fromJson(item))
            .toList();
      } else {
        return [PaymentMethodResponse.fromJson(response)];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PurchaseInvoiceModel> addPurchaseInvoice({
    required PurchaseInvoiceRequestModel purchaseInvoiceRequest,
  }) async {
    final response = await _purchaseInvoiceServices.addPurchaseInvoice(
      purchaseInvoiceRequest: purchaseInvoiceRequest,
    );

    return PurchaseInvoiceModel.fromJson(response);
  }

  Future<PaginatedGetPurchaseListingResponse> getPurchaseInvoice({
    String? offsetId,
    int limit = 1,
    String query = '',
    PartyType? partyType,
    bool isService = false,
    bool? isCancelled,
    String? today_date,
  }) async {
    final response = await _purchaseInvoiceServices.getPurchaseInvoice(
      offsetId: offsetId,
      limit: limit,
      query: query,
      partyType: partyType,
      isCancelled: isCancelled,
      isService: isService,
      today_date: today_date,
    );

    final data = PaginatedGetPurchaseListingResponse.fromJson(response);
    return data;
  }

  Future<PaginatedGetPurchaseListingResponse> getPurchaseInvoiceTwo({
    String? offsetId,
    int limit = 1,
    String query = '',
    PartyType? partyType,
    bool isService = false,
    bool? isCancelled,
    String? today_date,
    required PurchaseInvoiceListingRequest requestBody,
  }) async {
    final response = await _purchaseInvoiceServices.getPurchaseInvoiceTwo(
      offsetId: offsetId,
      limit: limit,
      query: query,
      partyType: partyType,
      isCancelled: isCancelled,
      isService: isService,
      today_date: today_date,
      requestBody: requestBody,
    );

    final data = PaginatedGetPurchaseListingResponse.fromJson(response);
    return data;
  }

  Future<void> cancelPurchaseInvoice(String invoiceId) async {
    try {
      await _purchaseInvoiceServices.cancelPurchaseInvoice(invoiceId);
    } catch (e) {
      rethrow;
    }
  }

  Future<PurchaseInvoiceModel> getPurchaseInvoiceById({
    required String id,
  }) async {
    final response = await _purchaseInvoiceServices.getPurchaseInvoiceById(
      id: id,
    );

    final data = PurchaseInvoiceModel.fromJson(response);
    return data;
  }

  // Purchase Return Repository
  Future<PurchaseReturnResponseModel> addPurchaseReturnInvoice({
    required PurchaseReturnRequestModel purchaseReturnRequestModel,
  }) async {
    final response = await _purchaseInvoiceServices.addPurchaseReturnInvoice(
      purchaseReturnRequestModel: purchaseReturnRequestModel,
    );

    return PurchaseReturnResponseModel.fromJson(response);
  }

  Future<PaginatedGetPurchaseReturnListingResponse> getPurchaseReturnInvoices({
    String? offsetId,
    int limit = 1,
    String query = '',
    PartyType? partyType,
  }) async {
    final response = await _purchaseInvoiceServices.getPurchaseReturnInvoices(
      offsetId: offsetId,
      limit: limit,
      query: query,
      partyType: partyType,
    );

    final data = PaginatedGetPurchaseReturnListingResponse.fromJson(response);
    return data;
  }

  Future<void> cancelPurchaseReturn(String returnId) async {
    try {
      await _purchaseInvoiceServices.cancelPurchaseReturn(returnId);
    } catch (e) {
      rethrow;
    }
  }

  Future<PurchaseReturnResponseModel> getPurchaseReturnInvoiceById({
    required String id,
  }) async {
    final response = await _purchaseInvoiceServices
        .getPurchaseReturnInvoiceById(id: id);

    final data = PurchaseReturnResponseModel.fromJson(response);
    return data;
  }
}
