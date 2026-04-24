import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/models/post_receipt_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/view_model/account_receipt_line_item_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/view_model/account_receipt_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_receipt_methods_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sales_return_credit_note_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_account_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AccountReceiptPaymentDetailsTableData {
  TextEditingController amount;
  TextEditingController method;
  TextEditingController date;
  TextEditingController invoiceNumber;
  TextEditingController pos_bank;
  TextEditingController upi_utr_cn;
  List<FocusNode> tableFocusNodes = List.generate(6, (index) => FocusNode());

  AccountReceiptPaymentDetailsTableData({
    required this.amount,
    required this.method,
    required this.date,
    required this.invoiceNumber,
    required this.pos_bank,
    required this.upi_utr_cn,
  });
}

class AccountReceiptPaymentDetailsController extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final EstimationRepository _estimationRepository = EstimationRepository();
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  // In account_receipt_payment_details_dialog_controller.dart
  final paymentHeaders = [
    'Sn',
    'Invoice Number',
    'Method',
    'Amount (₹)',
    'POS/Bank',
    'Date',
    'UPI/UTR/Cn.',
    '',
  ];

  final paymentColumnWidths = [
    0.1, // Sn
    0.4, // Invoice Number
    0.295, // Method
    0.35, // Amount
    0.295, // POS/Bank
    0.4, // Date
    0.295, // UPI/UTR/Cn
    0.1, // Actions
  ];

  final RxList<AccountReceiptPaymentDetailsTableData> controllers =
      <AccountReceiptPaymentDetailsTableData>[].obs;
  final methodList = ["Cheque", "Card", "Cash"];
  final RxList<GetAccountSettingsResponse> accountSettingsList =
      <GetAccountSettingsResponse>[].obs;
  final RxList<String> bankList = <String>[].obs;
  final accountSettingsResponse =
      ApiResponse<List<GetAccountSettingsResponse>>.loading("LOADING").obs;

  final RxList<GetSalesReturnCreditNoteValue> creditNotesList =
      <GetSalesReturnCreditNoteValue>[].obs;
  final creditNotesResponse =
      ApiResponse<GetSalesReturnCreditNoteResponse>.loading("LOADING").obs;
  final isCreditNotesLoading = false.obs;

  // Mock invoice list - replace with actual data from AccountsReceiptLineItemController
  final invoiceList = ["INV-001", "INV-002", "INV-003"].obs;

  final amountController = TextEditingController(text: "100");
  final roundOffController = TextEditingController();
  final bankChargesController = TextEditingController();
  final totalController = "0".obs;
  final tcsController = "0".obs;
  final tdsController = "0".obs;
  final nettController = "0".obs;
  final finalTotalController = "0".obs;

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  // Mock customer type - replace with actual logic
  final isTcsCustomer = true.obs;

  @override
  void onInit() {
    super.onInit();
    initializeController();
    setupListeners();
    fetchAccountSettings();
  }

  void initializeController() {
    // addRow();
    amountController.text = "0";
    roundOffController.text = "0";
    bankChargesController.text = "0";
    calculateTotals();
  }

  void initializeRow() {
    if (controllers.isEmpty ||
        (controllers.length == 1 && controllers.first.amount.text.isEmpty)) {
      controllers.clear();
      addRow();

      // Always update the first row amount after adding
      if (controllers.isNotEmpty) {
        double totalAmount = double.tryParse(amountController.text) ?? 0;
        if (totalAmount > 0) {
          controllers[0].amount.text = totalAmount.toStringAsFixed(2);
          controllers.refresh();
        }
      }
    } else {
      // If controllers already exist, just update the first row amount
      _updateFirstPaymentRowAmount();
    }

    currentRowIndex.value = 0;
    currentColIndex.value = 0;
  }

  GetAccountSettingsResponse? getAccountByCode(String paymentCode) {
    try {
      return accountSettingsList.firstWhere(
        (account) => account.paymentCode == paymentCode,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchAccountSettings() async {
    try {
      accountSettingsResponse.value = ApiResponse.loading("LOADING");

      final response = await _organizationRepository.getAccountSettingsList();

      accountSettingsList.clear();
      accountSettingsList.addAll(response);

      // Convert to bank list for dropdown
      bankList.clear();
      bankList.add("None"); // Keep "None" as first option

      // Add account names from API response
      for (var account in response) {
        if (account.paymentCode != null && account.paymentCode!.isNotEmpty) {
          bankList.add(account.paymentCode!);
        }
      }

      // Update existing controllers if any
      if (controllers.isNotEmpty) {
        for (var controller in controllers) {
          if (controller.pos_bank.text.isEmpty ||
              controller.pos_bank.text == "") {
            controller.pos_bank.text = bankList.first;
          }
        }
      }

      accountSettingsResponse.value = ApiResponse.completed(response);
      log("Successfully loaded ${response.length} bank accounts");
    } catch (e) {
      log("Error getting account settings: $e");
      accountSettingsResponse.value = ApiResponse.error(e.toString());

      // Fallback to default list
      bankList.clear();
      bankList.addAll([
        "None",
        "SBI",
        "Paytm",
        "HDFC",
        "ICICI",
        "Yes",
        "IB",
        "CUB",
        "KCC",
      ]);

      showErrorToast(
        message: 'Failed to fetch bank accounts, using default list',
      );
    }
  }

  Future<void> fetchCreditNotes() async {
    try {
      // Get the selected party from AccountReceiptViewmodel
      final AccountReceiptViewmodel accountReceiptViewmodel = Get.find();

      final partyId = accountReceiptViewmodel.selectedVendorParty.value?.id;

      if (partyId == null || partyId.isEmpty) {
        showErrorToast(message: 'Please select a party first');
        return;
      }

      isCreditNotesLoading.value = true;
      creditNotesResponse.value = ApiResponse.loading("LOADING");

      final response = await _estimationRepository.getSalesReturnCreditNote(
        partyId,
      );

      creditNotesList.clear();
      if (response.values != null) {
        // Only add credit notes that are not consumed and have balance > 0
        creditNotesList.addAll(
          response.values!.where(
            (note) =>
                note.isConsumed != true &&
                (double.tryParse(note.balance ?? '0') ?? 0) > 0,
          ),
        );
      }

      creditNotesResponse.value = ApiResponse.completed(response);

      if (creditNotesList.isEmpty) {
        showErrorToast(message: 'No credit notes available for this party');
      }

      // Refresh the UI to update dropdowns
      controllers.refresh();
    } catch (e) {
      log("Error fetching credit notes: $e");
      creditNotesResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to fetch credit notes: ${e.toString()}');
    } finally {
      isCreditNotesLoading.value = false;
    }
  }

  GetSalesReturnCreditNoteValue? getCreditNoteById(String creditNoteId) {
    try {
      return creditNotesList.firstWhere((note) => note.id == creditNoteId);
    } catch (e) {
      return null;
    }
  }

  void setInvoiceNumberDropdown() {
    AccountsReceiptLineItemController accountsPaymentLineItemController =
        Get.find<AccountsReceiptLineItemController>();
    invoiceList.value =
        accountsPaymentLineItemController.items
            .map((element) => element.invoiceNumber)
            .toList();

    // Set the amount
    amountController.text = accountsPaymentLineItemController.totalHeadersValue
        .elementAt(4);

    // Calculate totals
    calculateTotals();

    // Update existing payment method amounts if controllers already exist
    _updateFirstPaymentRowAmount();
  }

  void setupListeners() {
    roundOffController.addListener(calculateTotals);
    bankChargesController.addListener(calculateTotals);
  }

  void addRow() {
    double totalAmount = double.tryParse(amountController.text) ?? 0;
    double currentTotal = 0;

    for (var controller in controllers) {
      currentTotal += double.tryParse(controller.amount.text) ?? 0;
    }

    double remainingAmount = totalAmount - currentTotal;

    controllers.add(
      AccountReceiptPaymentDetailsTableData(
        amount: TextEditingController(
          text:
              remainingAmount > 0 ? remainingAmount.toStringAsFixed(2) : "0.00",
        ),
        method: TextEditingController(
          text:
              receiptMethods.isNotEmpty
                  ? receiptMethods.first.method ?? ''
                  : '',
        ),
        date: TextEditingController(
          text: convertDateTimeToString(DateTime.now()),
        ),
        invoiceNumber: TextEditingController(),
        pos_bank: TextEditingController(
          text: bankList.isNotEmpty ? bankList.first : "None",
        ),
        upi_utr_cn: TextEditingController(),
      ),
    );
    controllers.refresh();
  }

  void calculateTotals() {
    final AccountReceiptViewmodel accountPaymentViewmodel = Get.find();

    double amount = double.tryParse(amountController.text) ?? 0;
    double roundOff = double.tryParse(roundOffController.text) ?? 0;
    double bankCharges = double.tryParse(bankChargesController.text) ?? 0;

    double total = amount + roundOff + bankCharges;
    totalController.value = total.toStringAsFixed(2);

    // Calculate TCS/TDS (assuming 1% for this example)
    double taxRate =
        (double.tryParse(
              accountPaymentViewmodel
                      .selectedVendorParty
                      .value
                      ?.deductionPercent ??
                  "",
            ) ??
            0) /
        100;

    bool isTcs =
        accountPaymentViewmodel.selectedVendorParty.value?.deductionType ==
        "TCS";

    bool isTds =
        accountPaymentViewmodel.selectedVendorParty.value?.deductionType ==
        "TDS";
    if (isTcs) {
      double tcs = total * taxRate;
      tcsController.value = tcs.toStringAsFixed(2);
      tdsController.value = "0";
      nettController.value = (total + tcs).toStringAsFixed(2);
    } else if (isTds) {
      double tds = total * taxRate;
      tdsController.value = tds.toStringAsFixed(2);
      tcsController.value = "0";
      nettController.value = (total + tds).toStringAsFixed(2);
    }

    finalTotalController.value = nettController.value;
  }

  void removeRow(int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers.refresh();
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      showErrorToast(message: "Cannot remove last row");
    }
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
      controllers.refresh();
    }
  }

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void toggleCustomerType() {
    isTcsCustomer.value = !isTcsCustomer.value;
    calculateTotals();
  }

  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;
  void moveNextFocus() {
    log(
      "The values are ${controllers[currentRowIndex.value].tableFocusNodes.length} $currentColIndex",
    );

    String currentMethod =
        controllers[currentRowIndex.value].method.text.toLowerCase();
    bool isCashMethod = currentMethod == "cash";

    // Handle navigation based on current column
    if (currentColIndex.value == 2) {
      // From Amount field
      if (isCashMethod) {
        // For Cash, skip POS/Bank and go to Date field
        currentColIndex.value = 4;
        controllers[currentRowIndex.value].tableFocusNodes[4].requestFocus();
      } else {
        // For other methods, go to POS/Bank field
        currentColIndex.value = 3;
        controllers[currentRowIndex.value].tableFocusNodes[3].requestFocus();
      }
    } else if (currentColIndex.value == 3) {
      // From POS/Bank, always go to Date field
      currentColIndex.value = 4;
      controllers[currentRowIndex.value].tableFocusNodes[4].requestFocus();
    } else if (currentColIndex.value == 4) {
      // From Date field
      if (isCashMethod) {
        // For Cash, skip UPI/UTR/CN and create new row
        validateAndAddRow();
        return;
      } else {
        // For other methods, go to UPI/UTR/CN field
        currentColIndex.value = 5;
        controllers[currentRowIndex.value].tableFocusNodes[5].requestFocus();
      }
    } else if (currentColIndex.value <
        controllers[currentRowIndex.value].tableFocusNodes.length - 1) {
      // Default next field navigation
      currentColIndex.value++;
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex.value < controllers.length - 1) {
      // Move to next row
      currentRowIndex.value++;
      currentColIndex.value = 0;
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      // We're at the last field of the last row, add new row
      validateAndAddRow();
    }

    log("moving focus moveNextFocus to $currentRowIndex : $currentColIndex");
  }

  void movePreviousFocus(FocusNode removeButtonFocusNode) {
    String currentMethod =
        controllers[currentRowIndex.value].method.text.toLowerCase();
    bool isCashMethod = currentMethod == "cash";

    if (currentColIndex.value == 4) {
      // If on Date field, go back based on method
      if (isCashMethod) {
        // For Cash, skip POS/Bank and go back to Amount field (index 2)
        currentColIndex.value = 2;
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
      } else {
        // For other methods, go back to POS/Bank field (index 3)
        currentColIndex.value = 3;
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
      }
    } else if (currentColIndex.value > 0) {
      currentColIndex.value--;
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex.value > 0) {
      currentRowIndex.value--;
      currentColIndex.value =
          controllers[currentRowIndex.value].tableFocusNodes.length - 1;
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      // We're at the first field of the first row
      removeButtonFocusNode.requestFocus();
    }

    log(
      "moving focus movePreviousFocus to $currentRowIndex : $currentColIndex",
    );
  }

  KeyEventResult moveFocus(
    KeyEventResult result,
    LogicalKeyboardKey keyboard, {
    required FocusNode previousFocusNode,
    required FocusNode nextFocusNode,
  }) {
    if (keyboard == LogicalKeyboardKey.arrowUp) {
      if (currentRowIndex > 0) {
        currentRowIndex.value--;
        log("moving focus move focus to $currentRowIndex : $currentColIndex");
      } else {
        previousFocusNode.requestFocus();
        // node.previousFocus();
        log("moving focus move focus to $currentRowIndex : $currentColIndex");
        return KeyEventResult.handled;
      }
    } else if (keyboard == LogicalKeyboardKey.arrowDown) {
      if (currentRowIndex.value < controllers.length - 1) {
        currentRowIndex.value++;
      } else {
        nextFocusNode.requestFocus();
        // node.nextFocus();
        return KeyEventResult.handled;
      }
    }
    controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
        .requestFocus();
    log("moving focus move focus to $currentRowIndex : $currentColIndex");
    return result;
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();

      // After adding row, focus on the new row's amount field
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );

        // Set focus to the new row's amount field and select text
        int newRowIndex = controllers.length - 1;
        controllers[newRowIndex].tableFocusNodes[0].requestFocus();
        currentRowIndex.value = newRowIndex;
        currentColIndex.value = 0;

        // Select all text in the amount field
        if (controllers[newRowIndex].amount.text.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 50), () {
            controllers[newRowIndex].amount.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controllers[newRowIndex].amount.text.length,
            );
          });
        }
      });
    }
  }

  bool validatePaymentRows() {
    // Remove empty rows before validation
    if (controllers.length > 1) {
      // Check if last row is empty
      final lastRow = controllers.last;
      if (lastRow.invoiceNumber.text.isEmpty) {
        controllers.removeLast();
      }
    }

    // Now validate remaining rows
    if (controllers.isEmpty) {
      showErrorToast(message: "At least one payment method is required");
      return false;
    }

    // Validate each remaining row
    for (int i = 0; i < controllers.length; i++) {
      final controller = controllers[i];

      // Check required fields
      if (controller.amount.text.isEmpty) {
        showErrorToast(message: "Amount is required in row ${i + 1}");
        return false;
      }
      if (controller.method.text.isEmpty) {
        showErrorToast(message: "Payment method is required in row ${i + 1}");
        return false;
      }
      if (controller.invoiceNumber.text.isEmpty) {
        showErrorToast(message: "Invoice number is required in row ${i + 1}");
        return false;
      }

      // Additional validations based on method
      final method = controller.method.text.toLowerCase();
      if (method != 'cash' && method != 'debit note') {
        if (controller.pos_bank.text.isEmpty) {
          showErrorToast(message: "POS/Bank is required in row ${i + 1}");
          return false;
        }
        if (controller.upi_utr_cn.text.isEmpty) {
          showErrorToast(message: "UPI/UTR/CN is required in row ${i + 1}");
          return false;
        }
      }
    }

    return true;
  }

  String? validateBasedOnMethod(String? value, int rowIndex, String fieldType) {
    if (rowIndex == controllers.length - 1) {
      final controller = controllers[rowIndex];
      bool isEmptyRow = controller.invoiceNumber.text.isEmpty;

      if (isEmptyRow) {
        // This is an empty last row, no validation needed
        return null;
      }
    }
    // Handle required fields first
    if (fieldType == 'amount') {
      if (value == null || value.isEmpty) {
        return 'Amount is required';
      }
      if (double.tryParse(value) == null) {
        return 'Please enter a valid amount';
      }
      return null;
    }

    if (fieldType == 'method') {
      if (value == null || value.isEmpty) {
        return 'Payment method is required';
      }
      return null;
    }

    if (fieldType == 'invoice_number') {
      if (value == null || value.isEmpty) {
        return 'Invoice number is required';
      }
      return null;
    }

    if (fieldType == 'date') {
      if (value == null || value.isEmpty) {
        return 'Date is required';
      }
      return null;
    }

    final method = controllers[rowIndex].method.text.toLowerCase();

    // For Cash and Credit Note methods, only validate required fields
    if (method == 'cash' || method == 'credit note') {
      return null;
    }

    // For other methods, validate all fields
    if (value == null || value.isEmpty) {
      if (fieldType == 'pos_bank') {
        return 'POS/Bank is required';
      } else if (fieldType == 'upi_utr_cn') {
        return 'UPI/UTR/CN is required';
      }
    }
    return null;
  }

  void setSelectedMethod(String? value, int rowIndex) {
    if (value != null) {
      controllers[rowIndex].method.text = value;

      if (value.toLowerCase() == "cash") {
        controllers[rowIndex].pos_bank.text = "None";
        controllers[rowIndex].upi_utr_cn.text = "";
      } else if (value.toLowerCase() == "credit note") {
        // Clear the bank field when credit note is selected
        controllers[rowIndex].pos_bank.text = "";
        controllers[rowIndex].upi_utr_cn.text = ""; // Clear this too

        // Fetch credit notes if not already loaded
        if (creditNotesList.isEmpty) {
          fetchCreditNotes();
        }
      } else {
        // For other payment methods, reset to default bank if needed
        if (controllers[rowIndex].pos_bank.text.isEmpty &&
            bankList.isNotEmpty) {
          controllers[rowIndex].pos_bank.text = bankList.first;
        }
      }
      controllers.refresh();
    }
  }

  // Add the ledger response
  final postPaymentResponse = Rx<ApiResponse<PostReceiptRequest>>(
    ApiResponse.initial("Initial"),
  );

  // Add ledger fetch method
  Future<void> postPayment() async {
    try {
      // if (!formKey.currentState!.validate()) {
      //   // Process the data
      //   showErrorToast(message: "Invalid data Entered");
      //   return;
      // }
      PostReceiptRequest postPaymentsRequest = getConvertedModel();
      postPaymentResponse.value = ApiResponse.loading('Loading..');
      final items = await _aggregateRepository.postReceipt(
        postPaymentsRequest: postPaymentsRequest,
      );

      postPaymentResponse.value = ApiResponse.completed(items);
      showSuccessToast(message: "Receipt saved successfully");
      Get.back();
      clearAllControllers();
    } catch (e, stack) {
      log('Error posting payment: $e $stack');
      postPaymentResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to save payment: $e");
    }
  }

  PostReceiptRequest getConvertedModel() {
    final AccountReceiptViewmodel accountPaymentViewmodel = Get.find();
    final AccountsReceiptLineItemController accountsPaymentLineItemController =
        Get.find();

    List<PostReceiptRequestLineItem>? lineItems =
        controllers.map((element) {
          final item = accountsPaymentLineItemController.items
              .toList()
              .firstWhereOrNull(
                (e) => e.invoiceNumber == element.invoiceNumber.text,
              );

          String invoiceType = item?.invoiceType ?? "-";
          String invoiceId = item?.id ?? "-";

          String? posAccountId;
          String? salesReturnId;
          String posValue = element.pos_bank.text;

          // Check if this is a credit note payment
          if (element.method.text.toLowerCase() == "credit note") {
            // For credit notes, pos_bank contains the credit note ID
            salesReturnId = posValue.isEmpty ? null : posValue;
            posAccountId = null; // No bank account for credit notes

            // Get the credit note details to retrieve the saleReturnNumber
            GetSalesReturnCreditNoteValue? creditNote = getCreditNoteById(
              posValue,
            );
            String transactionCode = creditNote?.saleReturnNumber ?? "";

            return PostReceiptRequestLineItem(
              amount: double.tryParse(element.amount.text) ?? 0,
              method: element.method.text,
              date: convertStringToDateTime(element.date.text),
              transactionType:
                  null, // Don't send transaction type for credit notes
              transactionCode: transactionCode, // Use the saleReturnNumber here
              invoiceNumber: element.invoiceNumber.text,
              invoiceType: invoiceType,
              invoiceId: invoiceId,
              remarks: "",
              saleReturnId: salesReturnId,
              posAccountId: posAccountId, // Add this line
            );
          } else {
            // For other payment methods, handle bank account
            if (posValue == "None" || posValue.isEmpty) {
              posAccountId = null;
            } else {
              // Get the actual account ID from the payment code
              final accountDetails = getAccountByCode(posValue);
              posAccountId = accountDetails?.id;
            }
            salesReturnId = null; // No sales return for regular payments

            return PostReceiptRequestLineItem(
              amount: double.tryParse(element.amount.text) ?? 0,
              method: element.method.text,
              date: convertStringToDateTime(element.date.text),
              transactionType: element.pos_bank.text,
              transactionCode: element.upi_utr_cn.text,
              invoiceNumber: element.invoiceNumber.text,
              invoiceType: invoiceType,
              invoiceId: invoiceId,
              remarks: "",
              saleReturnId: salesReturnId,
              posAccountId: posAccountId, // Add this line
            );
          }
        }).toList();

    PostReceiptRequest postPaymentsRequest = PostReceiptRequest(
      date: convertStringToDateTime(
        accountPaymentViewmodel.paymentDateController.text,
      ),
      amount: double.tryParse(amountController.text) ?? 0,
      roundOff: double.tryParse(roundOffController.text) ?? 0,
      bankCharges: double.tryParse(bankChargesController.text) ?? 0,
      total: double.tryParse(totalController.value) ?? 0,
      tcs: double.tryParse(tcsController.value) ?? 0,
      tds: double.tryParse(tdsController.value) ?? 0,
      nett: double.tryParse(nettController.value) ?? 0,
      partyId: accountPaymentViewmodel.selectedVendorParty.value!.id,
      partyType:
          accountPaymentViewmodel.selectedVendorParty.value
                  is CustomerSearchValue
              ? "customer"
              : "vendor",
      lineItems: lineItems,
      paymentReceiptNumber: accountPaymentViewmodel.paymentNumber.value,
    );

    return postPaymentsRequest;
  }

  void clearAllControllers() {
    final AccountReceiptViewmodel accountPaymentViewmodel = Get.find();
    final AccountsReceiptLineItemController accountsPaymentLineItemController =
        Get.find();
    accountPaymentViewmodel.clearControllers();
    accountsPaymentLineItemController.clearItems();
    controllers.clear();
    addRow();
  }

  final RxList<GetReceiptMethodsResponse> receiptMethods =
      <GetReceiptMethodsResponse>[].obs;

  final isLoading = false.obs;
  Future<void> fetchReceiptMethods() async {
    try {
      isLoading.value = true;
      final response = await _estimationRepository.getReceiptMethods();
      receiptMethods.clear();
      receiptMethods.addAll(response);

      if (controllers.isNotEmpty) {
        controllers[0].method.text = receiptMethods.first.method ?? '';
      }
    } catch (e) {
      showErrorToast(message: 'Failed to fetch receipt methods');
    } finally {
      isLoading.value = false;
    }
  }

  void onTotalAmountChanged() {
    if (controllers.isNotEmpty) {
      double totalAmount = double.tryParse(amountController.text) ?? 0;

      if (controllers.length == 1) {
        // If only one payment method, set it to total amount
        controllers[0].amount.text = totalAmount.toStringAsFixed(2);
      } else {
        // If multiple payment methods, redistribute only if needed
        _redistributePaymentAmountsOnTotalChange(totalAmount);
      }
      controllers.refresh();
    }
  }

  void _redistributePaymentAmountsOnTotalChange(double totalAmount) {
    if (controllers.isEmpty) return;

    // Get current total of all payment methods
    double currentTotal = 0;
    for (var controller in controllers) {
      currentTotal += double.tryParse(controller.amount.text) ?? 0;
    }

    // Only redistribute if there's a significant difference
    if ((currentTotal - totalAmount).abs() > 0.01) {
      // Get current amounts except first row
      double otherRowsTotal = 0;
      for (int i = 1; i < controllers.length; i++) {
        double amount = double.tryParse(controllers[i].amount.text) ?? 0;
        otherRowsTotal += amount;
      }

      // Set first row to remaining amount
      double firstRowAmount = totalAmount - otherRowsTotal;
      controllers[0].amount.text =
          firstRowAmount >= 0 ? firstRowAmount.toStringAsFixed(2) : "0.00";

      // If first row amount is negative, we need to adjust other rows
      if (firstRowAmount < 0) {
        // Reset all rows and distribute evenly
        double amountPerRow = totalAmount / controllers.length;
        for (int i = 0; i < controllers.length; i++) {
          controllers[i].amount.text = amountPerRow.toStringAsFixed(2);
        }
      }
    }
  }

  void onPaymentMethodAmountChanged(int rowIndex) {
    // Calculate total of all payment method amounts
    double totalPaymentMethods = 0;
    for (var paymentController in controllers) {
      totalPaymentMethods +=
          double.tryParse(paymentController.amount.text) ?? 0;
    }

    // Get the current total amount
    double currentTotalAmount = double.tryParse(amountController.text) ?? 0;

    // If this is not the last row, update remaining amounts
    if (controllers.length > 1 && rowIndex < controllers.length - 1) {
      // Update remaining rows to distribute the remaining amount
      double remainingAmount = currentTotalAmount - totalPaymentMethods;

      // Distribute remaining amount to subsequent rows
      for (int i = rowIndex + 1; i < controllers.length; i++) {
        if (i == controllers.length - 1) {
          // Last row gets the remaining amount
          controllers[i].amount.text =
              remainingAmount > 0 ? remainingAmount.toStringAsFixed(2) : "0.00";
        }
      }
    }

    controllers.refresh();
  }

  void _updateFirstPaymentRowAmount() {
    if (controllers.isNotEmpty) {
      // Get current total amount
      double totalAmount = double.tryParse(amountController.text) ?? 0;

      // If only one row exists, set it to the total amount
      if (controllers.length == 1) {
        controllers[0].amount.text = totalAmount.toStringAsFixed(2);
      } else {
        // If multiple rows exist, calculate remaining amount for first row
        double otherRowsTotal = 0;
        for (int i = 1; i < controllers.length; i++) {
          otherRowsTotal += double.tryParse(controllers[i].amount.text) ?? 0;
        }
        double firstRowAmount = totalAmount - otherRowsTotal;
        controllers[0].amount.text =
            firstRowAmount >= 0 ? firstRowAmount.toStringAsFixed(2) : "0.00";
      }
      controllers.refresh();
    }
  }

  void refreshPaymentAmounts() {
    if (controllers.isNotEmpty) {
      double totalAmount = double.tryParse(amountController.text) ?? 0;
      if (totalAmount > 0) {
        // If only one payment method, set it to total amount
        if (controllers.length == 1) {
          controllers[0].amount.text = totalAmount.toStringAsFixed(2);
        } else {
          // If multiple payment methods, update first row with remaining amount
          _updateFirstPaymentRowAmount();
        }
        controllers.refresh();
      }
    }
  }
}
