import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/models/get_party_details_by_ledger_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view_model/account_payment_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/view_model/account_receipt_payment_details_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/view_model/account_receipt_line_item_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/party_details_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AccountReceiptViewmodel extends GetxController {
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final PartyDetailsRepository _partyDetailsRepository =
      PartyDetailsRepository();

  final formKey = GlobalKey<FormState>();
  final paymentDateController = TextEditingController();

  final List<PosAccount> posAccounts = [
    PosAccount(id: "1", name: "POS Account", type: "POS"),
  ];

  void clearControllers() {
    setCurrentDate();
    selectedSelfParty.value = null;
    selectedVendorParty.value = null;
    getPartyDetailsResponse.value = ApiResponse.initial("initial");
    fetchReceiptNumber();
    try {
      final AccountsReceiptLineItemController lineItemController =
          Get.find<AccountsReceiptLineItemController>();
      lineItemController.clearItems();
    } catch (e) {
      log('Line item controller not found: $e');
    }
  }

  void setCurrentDate() {
    DateTime pickedDate = DateTime.now();
    paymentDateController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(8201),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  final RxString paymentNumber = ''.obs;
  Future<void> fetchReceiptNumber() async {
    try {
      final recordNumber = await _purchaseRepository.coreNextSequence(
        invoiceType: "payment_receipt_number",
      );
      paymentNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching receipt number: $e');
      paymentNumber.value = 'Error';
    }
  }

  // Party list response
  final partyListResponse = Rx<ApiResponse<List<dynamic>>>(
    ApiResponse.initial("Initial"),
  );

  // Fetch both customers and vendors
  Future<void> fetchPartyItems({required String query}) async {
    try {
      partyListResponse.value = ApiResponse.loading('Loading..');

      final customerResponse = await _partyDetailsRepository.searchCustomer(
        query,
      );
      final vendorResponse = await _partyDetailsRepository.searchVendor(query);

      List<dynamic> combinedList = [];

      if (customerResponse.values != null) {
        combinedList.addAll(customerResponse.values!);
      }

      if (vendorResponse.values != null) {
        combinedList.addAll(vendorResponse.values!);
      }

      partyListResponse.value = ApiResponse.completed(combinedList);
    } catch (e, stack) {
      log('Error fetching party list: $e $stack');
      partyListResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load party types");
    }
  }

  // Party handlers
  final Rx<dynamic> selectedVendorParty = Rx<dynamic>(null);
  void onVendorPartyChanged(dynamic newSelection) {
    selectedVendorParty.value = newSelection;
    getPartyDetailsById(
      partyId: newSelection.id.toString(),
      isCustomer: newSelection is CustomerSearchValue,
    );
  }

  final Rx<PosAccount?> selectedSelfParty = Rx<PosAccount?>(null);
  void onSelfPartyChanged(PosAccount? newSelection) {
    selectedSelfParty.value = newSelection;
  }

  // Party details response
  final getPartyDetailsResponse =
      Rx<ApiResponse<GetPartyDetailsByLedgerResponse>>(
        ApiResponse.initial("Initial"),
      );
  Future<void> getPartyDetailsById({
    required String partyId,
    required bool isCustomer,
  }) async {
    try {
      getPartyDetailsResponse.value = ApiResponse.loading('Loading..');

      final items = await _aggregateRepository.getPartyDetailsById(
        partyId: partyId,
        isCustomer: isCustomer,
      );

      final AccountsReceiptLineItemController controller =
          Get.find<AccountsReceiptLineItemController>();

      controller.updateItemsFromResponse(items);

      getPartyDetailsResponse.value = ApiResponse.completed(items);

      // After updating items, refresh payment amounts if payment dialog controller exists
      try {
        final AccountReceiptPaymentDetailsController paymentController =
            Get.find<AccountReceiptPaymentDetailsController>();

        // Small delay to ensure the line item controller has updated its totals
        Future.delayed(const Duration(milliseconds: 100), () {
          paymentController.setInvoiceNumberDropdown();
          paymentController.refreshPaymentAmounts();
        });
      } catch (e) {
        // Payment controller might not be initialized yet, which is fine
        log('Payment controller not found, will be initialized later: $e');
      }
    } catch (e, stack) {
      log('Error fetching party details: $e $stack');
      getPartyDetailsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load party details: $e");
    }
  }
}
