import 'dart:convert';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/post_journal_entry_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class PurchaseServices {
  final HttpDioClient _apiService = Get.find();

  Future getPurchaseReturnDebitNote(String? partyId) async {
    try {
      final response = await _apiService.get(
        AppUrl.purchaseBaseUrl,
        '/purchase-return-debit-note-party-id/$partyId',
      );
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
        AppUrl.purchaseBaseUrl,
        "/next-invoice-number",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future postJournalEntry({
    required PostJournalEntryRequest journalEntryRequest,
  }) async {
    try {
      final body = jsonEncode(journalEntryRequest.toJson());
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        '/create-journal-entry',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> coreNextSequence({
    required String invoiceType,
  }) async {
    try {
      final body = {
        "types": [invoiceType],
      };
      final response = await _apiService.post(
        AppUrl.purchaseBaseUrl,
        "/core-next-sequence",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAccountMappings({String? query}) async {
    try {
      final response = await _apiService.get(
        AppUrl.purchaseBaseUrl,
        "/get-accounts-mappings",
        queryParameters: {"qeury": query},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getVendorPurchaseAndReturnReport({
    required String vendorId,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.purchaseBaseUrl,
        '/vendor-purchase-and-return-report/$vendorId',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
