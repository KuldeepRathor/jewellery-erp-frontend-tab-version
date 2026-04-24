import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/post_journal_entry_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/get_debit_note_purchase_return_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_dashboard/vendor_ledger/model/vendor_ledger_response.dart';
import 'package:jewellery_erp_frontend_tab_version/services/purchase_services.dart';

class PurchaseRepository {
  final PurchaseServices purchaseServices = PurchaseServices();

  //Debit note
  Future<GetPurchaseReturnDebitNoteResponse> getPurchaseReturnDebitNote(
    String? partyId,
  ) async {
    try {
      final response = await purchaseServices.getPurchaseReturnDebitNote(
        partyId,
      );
      return GetPurchaseReturnDebitNoteResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getNextInvoiceNumber({required String invoiceType}) async {
    final response = await purchaseServices.invoiceNumber(
      invoiceType: invoiceType,
    );
    return response["values"][0]["value"];
  }

  Future<PostJournalEntryRequest> postJournalEntry({
    required PostJournalEntryRequest journalEntryRequest,
  }) async {
    await purchaseServices.postJournalEntry(
      journalEntryRequest: journalEntryRequest,
    );

    return PostJournalEntryRequest();
  }

  Future<String> coreNextSequence({required String invoiceType}) async {
    final response = await purchaseServices.coreNextSequence(
      invoiceType: invoiceType,
    );
    return response["values"][0]["value"];
  }

  Future<GetAccountMappingResponse> getAccountMappings({String? query}) async {
    final response = await purchaseServices.getAccountMappings(query: query);

    return GetAccountMappingResponse.fromJson(response);
  }

  Future<VendorLedgerResponse> getVendorPurchaseAndReturnReport({
    required String vendorId,
  }) async {
    final response = await purchaseServices.getVendorPurchaseAndReturnReport(
      vendorId: vendorId,
    );
    return VendorLedgerResponse.fromJson(response);
  }
}
