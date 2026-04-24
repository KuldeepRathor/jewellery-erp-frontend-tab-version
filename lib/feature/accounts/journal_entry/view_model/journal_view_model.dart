import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/post_journal_entry_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view_model/journal_entry_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class JournalViewModel extends GetxController {
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  final formKey = GlobalKey<FormState>();
  final postingDateController = TextEditingController();
  TextEditingController referenceTextController = TextEditingController();
  void clearControllers() {
    postingDateController.text = "";
    referenceTextController.text = "";
    // fetchvoucher number;
    fetchVoucherNumber();
    postJournalResponse.value = ApiResponse.initial('Empty data');
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

  final postJournalResponse = Rx<ApiResponse<PostJournalEntryRequest>>(
    ApiResponse.initial('Empty data'),
  );

  Future<void> postJournalEntry() async {
    final AccountTableController accountTableController =
        Get.find<AccountTableController>();

    log("${formKey.currentState!.validate() == false}");
    if (accountTableController.formKey.currentState!.validate() == false ||
        accountTableController.validateRequiredFields() == false ||
        formKey.currentState!.validate() == false) {
      showErrorToast(message: "Please enter valid data");
      return;
    }
    log("Sending data");
    postJournalResponse.value = ApiResponse.loading("Loading");
    try {
      PostJournalEntryRequest journalEntryRequest = getConvertedModel();
      final response = await _purchaseRepository.postJournalEntry(
        journalEntryRequest: journalEntryRequest,
      );
      postJournalResponse.value = ApiResponse.completed(response);
      clearControllers();
      accountTableController.clearControllers();
      accountTableController.addRow();
    } catch (e, s) {
      log("Error in postPurchaseInvoice $e \n $s");
      final handledResponse = handleDTOResponseErrors(e);
      postJournalResponse.value = ApiResponse.error(handledResponse.message);
      // showErrorToast(
      //     message: handledResponse.message ?? "Something went wrong ");
      rethrow;
    }
  }

  PostJournalEntryRequest getConvertedModel() {
    final AccountTableController accountTableController =
        Get.find<AccountTableController>();

    List<PostJournalEntryRequestLineItem>? lineItems =
        accountTableController.controllers
            .map(
              (element) => PostJournalEntryRequestLineItem(
                accountCode: element.acCode.text,
                accountName: element.accountName.text,
                debit: double.tryParse(element.debit.text),
                credit: double.tryParse(element.credit.text),
                remarks: element.remarks.text,
              ),
            )
            .toList();
    PostJournalEntryRequest journalEntryRequest = PostJournalEntryRequest(
      date: convertStringToDateTime(postingDateController.text),
      voucherNumber: voucherNumber.value,
      reference: referenceTextController.text,
      lineItems: lineItems,
    );
    return journalEntryRequest;
  }

  final RxString voucherNumber = ''.obs;
  Future<void> fetchVoucherNumber() async {
    try {
      final recordNumber = await _purchaseRepository.coreNextSequence(
        invoiceType: "voucher_number",
      );
      voucherNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching voucher number: $e');
      voucherNumber.value = 'Error';
    }
  }
}
