import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/purchase_invoice_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/model/purchase_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/model/purchase_invoice_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_return_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';

class PurchaseInvoiceServices {
  final HttpDioClient _apiService = Get.find();

  Future getSequencesDropdown({
    required String? voucherType,
    required String? voucherSection,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.purchaseBaseUrl,
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

  Future getPurchaseRecordDropdown({String? party_id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.purchaseBaseUrl,
        "/all-purchase-record-dropdown",
        queryParameters: {"party_id": party_id},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future purchasePresignedUrl(PurchasePresignedUrlRequest request) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        '/purchase-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putPurchaseAttachments({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future editPurchaseAttachments({
    required String invoiceId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final body = jsonEncode(data);
      final response = await _apiService.put(
        AppUrl.purchaseBaseUrl,
        '/edit-purchase-attachments?id=$invoiceId',
        data: body,
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
        "/payment-methods",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addPurchaseInvoice({
    required PurchaseInvoiceRequestModel purchaseInvoiceRequest,
  }) async {
    try {
      final body = jsonEncode(purchaseInvoiceRequest.toJson());
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        '/purchase-invoice',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPurchaseInvoice({
    String? offsetId,
    int limit = 1,
    String query = '',
    PartyType? partyType,
    bool isService = false,
    bool? isCancelled,
    String? today_date,
  }) async {
    // Use a simple path without query parameters
    String path = '/purchase-invoices';

    // Build all query parameters in one place
    Map<String, dynamic> queryParameters = {
      "query": query,
      "limit": limit,
      "entity_type": partyType?.name ?? '',
      "is_cancelled": isCancelled,
      "is_service": isService,
      "today_date": today_date,
    };

    // Only add offset_id if it's not null and not empty
    if (offsetId != null && offsetId.isNotEmpty) {
      queryParameters["offset_id"] = offsetId;
    }

    // Remove null values to avoid sending them as empty parameters
    queryParameters.removeWhere((key, value) => value == null);

    try {
      log("The query will be $path with params: $queryParameters");
      final response = await _apiService.get(
        AppUrl.purchaseBaseUrl,
        path,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPurchaseInvoiceTwo({
    String? offsetId,
    int limit = 1,
    String query = '',
    PartyType? partyType,
    bool isService = false,
    bool? isCancelled,
    String? today_date,
    required PurchaseInvoiceListingRequest requestBody,
  }) async {
    // Use a simple path without query parameters
    String path = '/purchase-invoices';

    // Build all query parameters in one place
    Map<String, dynamic> queryParameters = {
      "query": query,
      "limit": limit,
      "entity_type": partyType?.name ?? '',
      "is_cancelled": isCancelled,
      "is_service": isService,
      "today_date": today_date,
    };

    // Only add offset_id if it's not null and not empty
    if (offsetId != null && offsetId.isNotEmpty) {
      queryParameters["offset_id"] = offsetId;
    }

    // Remove null values to avoid sending them as empty parameters
    queryParameters.removeWhere((key, value) => value == null);

    try {
      log("The query will be $path with params: $queryParameters");
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        path,
        queryParameters: queryParameters,
        data: jsonEncode(requestBody.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelPurchaseInvoice(String invoiceId) async {
    try {
      await _apiService.delete(
        AppUrl.purchaseBaseUrl,
        '/cancel-purchase-invoice/$invoiceId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getPurchaseInvoiceById({required String id}) async {
    String path = '/purchase-invoice/$id';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.purchaseBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Purchase Return Services
  Future addPurchaseReturnInvoice({
    required PurchaseReturnRequestModel purchaseReturnRequestModel,
  }) async {
    try {
      final body = jsonEncode(purchaseReturnRequestModel.toJson());
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        '/purchase-return',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPurchaseReturnInvoices({
    String? offsetId,
    int limit = 1,
    String query = '',
    PartyType? partyType,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/purchase-returns?query=$query&limit=$limit&offset_id=$offsetId&entity_type=${partyType?.name ?? ''}';
    } else {
      path =
          '/purchase-returns?query=$query&limit=$limit&entity_type=${partyType?.name ?? ''}';
    }
    try {
      log("The query will be $path");
      final response = await _apiService.get(
        // AppUrl.localBaseUrl,
        // '/customer_details?_page=$page&_per_page=$limit&name=$search',
        AppUrl.purchaseBaseUrl,
        path,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelPurchaseReturn(String returnId) async {
    try {
      await _apiService.delete(
        AppUrl.purchaseBaseUrl,
        '/cancel-purchase-return/$returnId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getPurchaseReturnInvoiceById({required String id}) async {
    String path = '/purchase-return/$id';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.purchaseBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
