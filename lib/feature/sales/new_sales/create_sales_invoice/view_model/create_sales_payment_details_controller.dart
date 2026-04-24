// ignore_for_file: library_prefixes, avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_jewellery_plan_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_receipt_methods_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sales_return_credit_note_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/post_sales_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/sales_hold_items_attention_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/advance_booking/sales_advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_reference_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/jewellery_plan/sales_jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/old_gold/sales_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/orders/sales_add_order_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/quick_estimate/sales_quick_estimate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/quick_old_gold/sales_quick_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_account_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesPaymentDetailsController extends GetxController {
  // final PurchaseInvoiceRepository _purchaseInvoiceRepository =
  //     PurchaseInvoiceRepository();
  final EstimationRepository _estimationRepository = EstimationRepository();
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final CreateSalesViewModel _createSalesViewModel =
      Get.find<CreateSalesViewModel>();

  final _isInitialized = false.obs;
  bool get isControllerInitialized => _isInitialized.value;

  final paymentHeaders = [
    'Sn',
    'Amount (₹)',
    'Method',
    'Date',
    'POS/Bank',
    'UPI/UTR/Cn.',
    '',
  ];
  final paymentColumnWidths = [0.1, 0.38, 0.28, 0.28, 0.28, 0.28, 0.2];
  final controllers = <PaymentDetailsTableData>[].obs;

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

  // final bankList = [
  //   "None",
  //   "SBI",
  //   "Paytm",
  //   "HDFC",
  //   "ICICI",
  //   "Yes",
  //   "IB",
  //   "CUB",
  //   "KCC",
  // ];

  final roundOffController = TextEditingController();
  final tcsController = TextEditingController();
  final tdsController = TextEditingController();
  final paidAmountController = TextEditingController();
  final balanceAmountController = TextEditingController();

  final purchaseAmountController = TextEditingController();
  final advanceAmountController = TextEditingController();
  final bankChargesAmountController = TextEditingController();

  final jewellerDiscount = TextEditingController();
  final jewellerDiscountFocusNode = FocusNode();
  final RxDouble additional_less = 0.0.obs;
  void setAdditionalLess({required double value}) {
    additional_less.value = value;
    calculateGstvalues();
  }

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  final salesAmountWithoutRoundoff = "0".obs;
  final salesAmountRoundoffDiff = "0".obs;

  final cgstWithoutRoundoff = "0".obs;
  final cgstRoundoffDiff = "0".obs;

  final sgstWithoutRoundoff = "0".obs;
  final sgstRoundoffDiff = "0".obs;

  final igstWithoutRoundoff = "0".obs;
  final igstRoundoffDiff = "0".obs;

  final nettGstWithoutRoundoff = "0".obs;
  final nettGstRoundoffDiff = "0".obs;

  final tcsWithoutRoundoff = "0".obs;
  final tcsRoundoffDiff = "0".obs;

  final tdsWithoutRoundoff = "0".obs;
  final tdsRoundoffDiff = "0".obs;

  final nettTdsTcsWithoutRoundoff = "0".obs;
  final nettTdsTcsRoundoffDiff = "0".obs;

  final finalAmountWithoutRoundoff = "0".obs;
  final finalAmountRoundoffDiff = "0".obs;

  @override
  void onInit() {
    super.onInit();
    _isInitialized.value = false;

    fetchReceiptMethods()
        .then((_) {
          return fetchAccountSettings();
        })
        .then((_) {
          _isInitialized.value = true;
        })
        .catchError((error) {
          log("Error during initialization: $error");
          _isInitialized.value = true; // Set to true even on error to show UI
        });
  }

  @override
  void onClose() {
    // Dispose all controllers and focus nodes
    for (var controller in controllers) {
      controller.amount.dispose();
      controller.method.dispose();
      controller.date.dispose();
      controller.pos_bank.dispose();
      controller.upi_utr_cn.dispose();
      // controller.dispose();
    }

    roundOffController.dispose();
    tcsController.dispose();
    tdsController.dispose();
    paidAmountController.dispose();
    balanceAmountController.dispose();
    purchaseAmountController.dispose();
    advanceAmountController.dispose();
    bankChargesAmountController.dispose();
    jewellerDiscount.dispose();
    jewellerDiscountFocusNode.dispose();
    scrollController.dispose();

    super.onClose();
  }

  Future<void> fetchCreditNotes() async {
    try {
      // Get the selected party
      final CreateSalesEstimationSearchPartyController partyController =
          Get.find<CreateSalesEstimationSearchPartyController>();

      final partyId = partyController.selectedParty.value?.id;

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

      showErrorToast(
        message: 'Failed to fetch bank accounts, using default list',
      );
    }
  }

  void initializeRow() {
    if (controllers.isEmpty ||
        (controllers.length == 1 && controllers.first.amount.text.isEmpty)) {
      controllers.clear();
      addRow();
      // if (controllers.isNotEmpty) {
      //   double totalReceived = double.tryParse(paidAmountController.text) ?? 0;
      //   if (totalReceived > 0) {
      //     controllers[0].amount.text = totalReceived.toStringAsFixed(2);
      //   }
      // }
    }
    currentRowIndex.value = 0;
    currentColIndex.value = 0;
  }

  void clearTextController() {
    for (var controllerData in controllers) {
      controllerData.amount.clear();
    }

    roundOffController.text = '';
    tcsController.text = '';
    tdsController.text = '';
    paidAmountController.text = '';
    balanceAmountController.text = '';
    purchaseAmountController.text = "";
    advanceAmountController.text = "";
    bankChargesAmountController.text = "";
    roundOffController.text = "";
  }

  void addRow() {
    print("Adding row");
    // double totalReceived = double.tryParse(paidAmountController.text) ?? 0;
    // double currentTotal = 0;

    // for (var controller in controllers) {
    //   currentTotal += double.tryParse(controller.amount.text) ?? 0;
    // }

    // double remainingAmount = totalReceived - currentTotal;

    controllers.add(
      PaymentDetailsTableData(
        // amount: TextEditingController(
        //     text: remainingAmount > 0
        //         ? remainingAmount.toStringAsFixed(2)
        //         : "0.00"),
        amount: TextEditingController(),
        method: TextEditingController(
          text:
              receiptMethods.isNotEmpty
                  ? receiptMethods.first.method ?? ''
                  : '',
        ),
        date: TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ),
        pos_bank: TextEditingController(
          text: bankList.isNotEmpty ? bankList.first : "None",
        ),
        upi_utr_cn: TextEditingController(),
      ),
    );

    int newRowIndex = controllers.length - 1;
    populateRemainingAmount(newRowIndex);
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
  }

  void onReceivedAmountChanged() {
    if (controllers.isNotEmpty) {
      double totalReceived = double.tryParse(paidAmountController.text) ?? 0;

      if (controllers.length == 1) {
        // If only one payment method, set it to total received
        controllers[0].amount.text = totalReceived.toStringAsFixed(2);
      } else {
        // If multiple payment methods, redistribute only if needed
        _redistributePaymentAmountsOnReceivedChange(totalReceived);
      }
      controllers.refresh();
    }
    calculateBalanceAmount();
  }

  void _redistributePaymentAmountsOnReceivedChange(double totalReceived) {
    if (controllers.isEmpty) return;

    // Get current total of all payment methods
    double currentTotal = 0;
    for (var controller in controllers) {
      currentTotal += double.tryParse(controller.amount.text) ?? 0;
    }

    // Only redistribute if there's a significant difference
    if ((currentTotal - totalReceived).abs() > 0.01) {
      // Get current amounts except first row
      double otherRowsTotal = 0;
      for (int i = 1; i < controllers.length; i++) {
        double amount = double.tryParse(controllers[i].amount.text) ?? 0;
        otherRowsTotal += amount;
      }

      // Set first row to remaining amount
      double firstRowAmount = totalReceived - otherRowsTotal;
      controllers[0].amount.text =
          firstRowAmount >= 0 ? firstRowAmount.toStringAsFixed(2) : "0.00";

      // If first row amount is negative, we need to adjust other rows
      if (firstRowAmount < 0) {
        // Reset all rows and distribute evenly
        double amountPerRow = totalReceived / controllers.length;
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

    // Get the current received amount
    double currentReceivedAmount =
        double.tryParse(paidAmountController.text) ?? 0;

    // If this is the only row or if we're adding a new row, update remaining amounts
    if (controllers.length > 1 && rowIndex < controllers.length - 1) {
      // Update remaining rows to distribute the remaining amount
      double remainingAmount = currentReceivedAmount - totalPaymentMethods;

      // Distribute remaining amount to subsequent rows
      for (int i = rowIndex + 1; i < controllers.length; i++) {
        if (i == controllers.length - 1) {
          // Last row gets the remaining amount
          controllers[i].amount.text =
              remainingAmount > 0 ? remainingAmount.toStringAsFixed(2) : "0.00";
        }
      }
    }

    // Update balance amount
    calculateBalanceAmount();
    controllers.refresh();
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

  void setSelectedBank(String? value, int rowIndex) {
    if (value != null) {
      controllers[rowIndex].pos_bank.text = value;
    }
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

  Future<void> selectDate(BuildContext context, int rowIndex) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controllers[rowIndex].date.text = DateFormat(
        'dd/MM/yy',
      ).format(picked); // Changed format
      controllers.refresh();
    } else if (controllers[rowIndex].date.text.isEmpty) {
      controllers[rowIndex].date.text = DateFormat(
        'dd/MM/yy',
      ).format(DateTime.now()); // Changed format
      controllers.refresh();
    }
  }

  final salesAmount = 0.0.obs;
  double schemeDisct = 0;
  double rateDisct = 0;
  RxDouble discount = 0.0.obs;
  final gstNet = 0.0.obs;
  final taxDeductionNet = 0.0.obs;

  final CGStValue = "0".obs;
  final SGSTValue = "0".obs;
  final IGStValue = "0".obs;
  final totalPrice = "0".obs;
  final originalTotalPrice = 0.0.obs;

  final roundOffTotalToShow = 0.0.obs;
  final calulcatedTaxTotalToShow = 0.0.obs;

  void reCalculateAfterRoundOff() {
    double purchaseAmountValue =
        double.tryParse(purchaseAmountController.text) ?? 0;
    double advanceAmountValue =
        double.tryParse(advanceAmountController.text) ?? 0;
    double bankChargesAmountValue =
        double.tryParse(bankChargesAmountController.text) ?? 0;
    double roundOffValue = double.tryParse(roundOffController.text) ?? 0;

    double price =
        originalTotalPrice.value -
        // purchaseAmountValue -
        // 2 times purchase amount was getting deducted so removed from one place
        advanceAmountValue -
        roundOffValue +
        bankChargesAmountValue;
    if (price < 0) {
      showErrorToast(message: "Final Amount cannot be negative");
    }
    totalPrice.value = price.toStringAsFixed(2);
    paidAmountController.text = totalPrice.value;
    _updateFirstPaymentRowAmount();
    calculateBalanceAmount();
  }

  void _updateFirstPaymentRowAmount() {
    if (controllers.isNotEmpty) {
      // Get current total received amount
      double totalReceived = double.tryParse(paidAmountController.text) ?? 0;

      // If only one row exists, set it to the total received amount
      if (controllers.length == 1) {
        controllers[0].amount.text = totalReceived.toStringAsFixed(2);
      } else {
        // If multiple rows exist, calculate remaining amount for first row
        double otherRowsTotal = 0;
        for (int i = 1; i < controllers.length; i++) {
          otherRowsTotal += double.tryParse(controllers[i].amount.text) ?? 0;
        }
        double firstRowAmount = totalReceived - otherRowsTotal;
        controllers[0].amount.text =
            firstRowAmount >= 0 ? firstRowAmount.toStringAsFixed(2) : "0.00";
      }
      controllers.refresh();
    }
  }

  void calculateBalanceAmount() {
    updateBalanceAmount();
  }

  void updateBalanceAmount() {
    double paid = double.tryParse(paidAmountController.text) ?? 0;
    double total = double.tryParse(totalPrice.value) ?? 0;
    double value = total - paid;
    balanceAmountController.text = value.toStringAsFixed(2);
  }

  Future<void> calculateGstvalues() async {
    // Initialize controllers
    clearTextController();
    final itemDetailsController = Get.find<CreateSalesItemDetailsController>();
    final partyController =
        Get.find<CreateSalesEstimationSearchPartyController>();
    final oldGoldController = Get.find<SalesOldGoldController>();
    final salesAdvanceBookingController =
        Get.find<SalesAdvanceBookingController>();
    final salesJewelleryPlanController =
        Get.find<SalesJewelleryPlanController>();
    final SalesAddOrdersDialogController salesAddOrdersDialogController =
        Get.find<SalesAddOrdersDialogController>();

    // Step 1: Calculate all discounts
    final costDiscount = _getValueFromItemTotalHeaders(
      itemDetailsController,
      -4,
    );
    final oldGoldDiscount = _getValueFromOldGoldTotalHeaders(
      oldGoldController,
      -2,
    );
    final jewelleryPlanDiscount =
        salesJewelleryPlanController.totalRedeemableAmount.value;

    final givenJewellerDiscount = double.tryParse(jewellerDiscount.text) ?? 0;
    final additionalLess = additional_less.value.toPrecision(2);
    print("The additional less is $additionalLess");

    // Step 2: Reset all values
    _resetCalculationValues(
      costDiscount: costDiscount.toStringAsFixed(2),
      jewelleryPlanDiscount: jewelleryPlanDiscount,
    );

    // Step 3: Calculate subtotal
    double subTotal = _getValueFromItemTotalHeaders(itemDetailsController, -3);

    // Step 4: Handle GST calculations
    String state_name = _getPartyGSTNumber(partyController.selectedParty.value);
    String igstVal = await _organizationRepository.getGstTypev2(
      state_name: state_name,
      in_store_sale: _createSalesViewModel.isStoreSale.value,
    );
    bool isIGST = igstVal == "igst";

    final additionalLessEntered = additional_less.value;

    // Step 5: Calculate sales amount
    double additionalLessForCalculation = (additionalLessEntered / 1.03)
        .toPrecision(2);
    double rawSalesAmount =
        subTotal - schemeDisct - rateDisct - additionalLessForCalculation;
    salesAmount.value = rawSalesAmount;

    // Store raw sales amount
    salesAmountWithoutRoundoff.value = rawSalesAmount.toStringAsFixed(2);
    salesAmountRoundoffDiff.value = "0"; // No rounding applied here

    // Step 6: Calculate total GST per item
    double rawTotalGSTTaxPerItem = _calculateTotalGSTTaxExcludingAdditional(
      itemDetailsController.controllers.toList(),
      additionalLess: additionalLess,
    );

    // Step 7: Set GST values with rounding tracking
    _setGSTValuesWithRounding(rawTotalGSTTaxPerItem, isIGST);

    double rawGstNet = rawTotalGSTTaxPerItem + salesAmount.value;
    gstNet.value = rawGstNet;

    // Store raw nett GST
    nettGstWithoutRoundoff.value = rawGstNet.toStringAsFixed(2);
    nettGstRoundoffDiff.value = "0"; // No rounding applied here

    // Step 8: Calculate tax deductions (TDS/TCS) with rounding tracking
    Map<String, double> taxDeductionResult = _calculateTaxDeductionWithRounding(
      partyController.selectedParty.value,
      salesAmount.value,
    );

    double rawTaxDeductionNet = gstNet.value - taxDeductionResult['total']!;
    taxDeductionNet.value = rawTaxDeductionNet.roundToDouble();

    // Store raw nett TDS/TCS
    nettTdsTcsWithoutRoundoff.value = rawTaxDeductionNet.toStringAsFixed(2);
    nettTdsTcsRoundoffDiff.value = (taxDeductionNet.value - rawTaxDeductionNet)
        .toStringAsFixed(2);

    // Step 9: Calculate advance amounts
    double jewelleryPlanPrincipalAmount = _calculateJewelleryPlanAmount(
      salesJewelleryPlanController.selectedJewelleryPlans.toList(),
    );
    double advanceBookingDiscount =
        salesAdvanceBookingController.totalAdvancePaid.value;
    double ordersAdvanceAmount =
        salesAddOrdersDialogController.totalAdvancePaid.value;

    // Step 10: Set final amounts
    _setFinalAmounts(
      oldGoldDiscount: oldGoldDiscount,
      jewelleryPlanAmount: jewelleryPlanPrincipalAmount,
      advanceBookingAmount: advanceBookingDiscount,
      ordersAdvanceAmount: ordersAdvanceAmount,
    );

    // Update balance
    updateBalanceAmount();
  }

  Map<String, double> _calculateTaxDeductionWithRounding(
    dynamic party,
    double salesAmount,
  ) {
    if (party is! CustomerSearchValue && party is! VendorSearchValue) {
      tcsWithoutRoundoff.value = "0";
      tcsRoundoffDiff.value = "0";
      tdsWithoutRoundoff.value = "0";
      tdsRoundoffDiff.value = "0";
      return {'total': 0, 'raw': 0};
    }

    String? deductionType = party.deductionType;
    double deductionPercent =
        double.tryParse(party.deductionPercent ?? "0") ?? 0;

    final itemDetailsController = Get.find<CreateSalesItemDetailsController>();

    double totalTaxAmount = 0;
    double rawTotalTaxAmount = 0;

    if (itemDetailsController.controllers.isNotEmpty) {
      double itemSalesTotal = 0;
      for (var item in itemDetailsController.controllers) {
        itemSalesTotal += double.tryParse(item.salesAmount) ?? 0;
      }

      for (var item in itemDetailsController.controllers) {
        double itemSalesAmount = double.tryParse(item.salesAmount) ?? 0;
        double itemProportion = itemSalesAmount / itemSalesTotal;
        double itemShareOfSalesAmount = salesAmount * itemProportion;

        // Calculate raw tax for this item
        double rawItemTax = itemShareOfSalesAmount * (deductionPercent / 100);
        rawTotalTaxAmount += rawItemTax;

        // Apply ceiling
        double itemTax = rawItemTax.ceil().toDouble();
        totalTaxAmount += itemTax;
      }
    } else {
      double rawTax = salesAmount * (deductionPercent / 100);
      rawTotalTaxAmount = rawTax;
      totalTaxAmount = rawTax.ceil().toDouble();
    }

    if (deductionType == "TDS") {
      tdsController.text = totalTaxAmount.toStringAsFixed(2);
      tdsWithoutRoundoff.value = rawTotalTaxAmount.toStringAsFixed(2);
      tdsRoundoffDiff.value = (totalTaxAmount - rawTotalTaxAmount)
          .toStringAsFixed(2);

      // Clear TCS
      tcsWithoutRoundoff.value = "0";
      tcsRoundoffDiff.value = "0";

      return {'total': totalTaxAmount, 'raw': rawTotalTaxAmount};
    } else if (deductionType == "TCS") {
      tcsController.text = totalTaxAmount.toStringAsFixed(2);
      tcsWithoutRoundoff.value = rawTotalTaxAmount.toStringAsFixed(2);
      tcsRoundoffDiff.value = (totalTaxAmount - rawTotalTaxAmount)
          .toStringAsFixed(2);

      // Clear TDS
      tdsWithoutRoundoff.value = "0";
      tdsRoundoffDiff.value = "0";

      return {'total': totalTaxAmount, 'raw': rawTotalTaxAmount};
    }

    return {'total': 0, 'raw': 0};
  }

  void _setGSTValuesWithRounding(double totalGSTTaxPerItem, bool isIGST) {
    double rawGST = totalGSTTaxPerItem;

    if (isIGST) {
      // Store IGST values
      IGStValue.value = rawGST.toStringAsFixed(2);
      igstWithoutRoundoff.value = rawGST.toStringAsFixed(2);
      igstRoundoffDiff.value = "0";

      // Clear CGST/SGST
      CGStValue.value = "0";
      cgstWithoutRoundoff.value = "0";
      cgstRoundoffDiff.value = "0";
      SGSTValue.value = "0";
      sgstWithoutRoundoff.value = "0";
      sgstRoundoffDiff.value = "0";
    } else {
      double rawHalfGST = rawGST / 2;

      // Store CGST values
      CGStValue.value = rawHalfGST.toStringAsFixed(2);
      cgstWithoutRoundoff.value = rawHalfGST.toStringAsFixed(2);
      cgstRoundoffDiff.value = "0";

      // Store SGST values
      SGSTValue.value = rawHalfGST.toStringAsFixed(2);
      sgstWithoutRoundoff.value = rawHalfGST.toStringAsFixed(2);
      sgstRoundoffDiff.value = "0";

      // Clear IGST
      IGStValue.value = "0";
      igstWithoutRoundoff.value = "0";
      igstRoundoffDiff.value = "0";
    }
  }

  // Helper methods to make the main function more readable
  double _getValueFromItemTotalHeaders(
    CreateSalesItemDetailsController controller,
    int index,
  ) {
    return double.tryParse(
          controller.totalHeadersValue[controller.totalHeadersValue.length +
              index],
        ) ??
        0;
  }

  double _getValueFromOldGoldTotalHeaders(
    SalesOldGoldController controller,
    int index,
  ) {
    return double.tryParse(
          controller.totalHeadersValue[controller.totalHeadersValue.length +
              index],
        ) ??
        0;
  }

  void _resetCalculationValues({
    required double jewelleryPlanDiscount,
    required String costDiscount,
  }) {
    salesAmount.value = 0;
    schemeDisct = jewelleryPlanDiscount;
    rateDisct = 0;
    discount.value = double.tryParse(costDiscount) ?? 0;
    gstNet.value = 0;
    taxDeductionNet.value = 0;

    CGStValue.value = "0";
    cgstWithoutRoundoff.value = "0";
    cgstRoundoffDiff.value = "0";

    SGSTValue.value = "0";
    sgstWithoutRoundoff.value = "0";
    sgstRoundoffDiff.value = "0";

    IGStValue.value = "0";
    igstWithoutRoundoff.value = "0";
    igstRoundoffDiff.value = "0";

    totalPrice.value = "0";

    salesAmountWithoutRoundoff.value = "0";
    salesAmountRoundoffDiff.value = "0";

    nettGstWithoutRoundoff.value = "0";
    nettGstRoundoffDiff.value = "0";

    tcsWithoutRoundoff.value = "0";
    tcsRoundoffDiff.value = "0";

    tdsWithoutRoundoff.value = "0";
    tdsRoundoffDiff.value = "0";

    nettTdsTcsWithoutRoundoff.value = "0";
    nettTdsTcsRoundoffDiff.value = "0";

    finalAmountWithoutRoundoff.value = "0";
    finalAmountRoundoffDiff.value = "0";
  }

  String _getPartyGSTNumber(dynamic party) {
    if (party is CustomerSearchValue || party is VendorSearchValue) {
      // Check if address list exists and is not empty
      if (party.address != null && party.address!.isNotEmpty) {
        // Get the first address and access its state property
        return party.address!.first.state?.toString() ?? "";
      }
      // If no addresses are available
      return "";
    }
    return "";
  }

  double _calculateTotalGSTTaxExcludingAdditional(
    List<CreateSalesItemDetailsTableData> controllers, {
    required double additionalLess,
  }) {
    double total = 0;
    for (var itemDetail in controllers) {
      // additionalLess is divided by the number of items
      // to distribute the amount equally among all items

      double salesAmount =
          double.parse(itemDetail.salesAmount) -
          ((additionalLess / 1.03) / controllers.length);
      log(
        "The sales amount is ${itemDetail.salesAmount} and additional less is $additionalLess and calculated sales amount is $salesAmount",
      );
      double gstRate = double.parse(itemDetail.gst) / 100;

      // Calculate GST for this item and apply ceiling individually
      double itemGst = (salesAmount * gstRate).ceil().toDouble();
      total += itemGst;
    }
    return total;
  }

  // void _setGSTValues(double totalGSTTaxPerItem, bool isIGST) {
  //   log(" Total Gst before calc ${totalGSTTaxPerItem.toString()}");
  //   if (isIGST) {
  //     IGStValue.value = totalGSTTaxPerItem.toStringAsFixed(2);
  //   } else {
  //     double halfGST = totalGSTTaxPerItem / 2;
  //     CGStValue.value = halfGST.toStringAsFixed(2);
  //     SGSTValue.value = halfGST.toStringAsFixed(2);
  //   }
  // }

  // double _calculateTaxDeduction(dynamic party, double salesAmount) {
  //   if (party is! CustomerSearchValue && party is! VendorSearchValue) {
  //     return 0;
  //   }

  //   String? deductionType = party.deductionType;
  //   double deductionPercent =
  //       double.tryParse(party.deductionPercent ?? "0") ?? 0;

  //   // Get item details controller to access individual item sales amounts
  //   final itemDetailsController = Get.find<CreateSalesItemDetailsController>();

  //   // Calculate TDS/TCS per item and apply ceiling individually, just like GST
  //   double totalTaxAmount = 0;

  //   if (itemDetailsController.controllers.isNotEmpty) {
  //     // Calculate the total of all individual item sales amounts
  //     double itemSalesTotal = 0;
  //     for (var item in itemDetailsController.controllers) {
  //       itemSalesTotal += double.tryParse(item.salesAmount) ?? 0;
  //     }

  //     // Calculate the proportion and apply to each item
  //     for (var item in itemDetailsController.controllers) {
  //       double itemSalesAmount = double.tryParse(item.salesAmount) ?? 0;
  //       // Calculate this item's proportion of the total sales amount
  //       double itemProportion = itemSalesAmount / itemSalesTotal;
  //       double itemShareOfSalesAmount = salesAmount * itemProportion;

  //       // Calculate tax for this item and apply ceiling
  //       double itemTax = (itemShareOfSalesAmount * (deductionPercent / 100))
  //           .ceil()
  //           .toDouble();
  //       totalTaxAmount += itemTax;
  //     }
  //   } else {
  //     // Fallback to simple ceiling if no items
  //     totalTaxAmount =
  //         (salesAmount * (deductionPercent / 100)).ceil().toDouble();
  //   }

  //   if (deductionType == "TDS") {
  //     tdsController.text = totalTaxAmount.toStringAsFixed(2);
  //     return totalTaxAmount;
  //   } else if (deductionType == "TCS") {
  //     tcsController.text = totalTaxAmount.toStringAsFixed(2);
  //     return totalTaxAmount;
  //   }
  //   return 0;
  // }

  double _calculateJewelleryPlanAmount(List<JewelleryPlanResponse> plans) {
    return plans.fold<double>(
      0,
      (sum, plan) => sum + (double.tryParse(plan.amount ?? "0") ?? 0),
    );
  }

  void _setFinalAmounts({
    required double oldGoldDiscount,
    required double jewelleryPlanAmount,
    required double advanceBookingAmount,
    required double ordersAdvanceAmount,
  }) {
    // Reset controllers
    // Comment out this line to keep paidAmountController empty by default
    // paidAmountController.text = "0";
    roundOffController.text = "0";
    bankChargesAmountController.text = "0";

    // Set purchase and advance amounts
    purchaseAmountController.text = oldGoldDiscount.toString();
    advanceAmountController.text = (jewelleryPlanAmount +
            advanceBookingAmount +
            ordersAdvanceAmount)
        .toStringAsFixed(2);

    // Calculate final price
    double purchaseAmount = double.tryParse(purchaseAmountController.text) ?? 0;
    double advanceAmount = double.tryParse(advanceAmountController.text) ?? 0;
    double bankCharges = double.tryParse(bankChargesAmountController.text) ?? 0;
    double roundOff = double.tryParse(roundOffController.text) ?? 0;

    double finalPrice =
        taxDeductionNet.value -
        purchaseAmount -
        advanceAmount -
        roundOff +
        bankCharges;

    // Update final values
    originalTotalPrice.value = finalPrice;
    totalPrice.value = finalPrice.toStringAsFixed(2);
    // Comment out these lines
    // paidAmountController.text = totalPrice.value;
    // _updateFirstPaymentRowAmount();
    balanceAmountController.text = finalPrice.toStringAsFixed(
      2,
    ); // Show balance as final amount initially
  }

  void populateReceivedAmountIfEmpty() {
    if (paidAmountController.text.isEmpty) {
      paidAmountController.text = totalPrice.value;
      _updateFirstPaymentRowAmount();
      calculateBalanceAmount();
    }
  }

  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;
  void movePreviousFocus(FocusNode removeButtonFocusNode) {
    if (currentColIndex.value > 0) {
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

  void moveNextFocus() {
    log(
      "The values are ${controllers[currentRowIndex.value].tableFocusNodes.length} $currentColIndex",
    );
    if (currentColIndex <
        controllers[currentRowIndex.value].tableFocusNodes.length - 1) {
      currentColIndex.value++;

      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex < controllers.length - 1) {
      currentRowIndex.value++;
      currentColIndex.value = 0;

      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      validateAndAddRow();
    }
    log("moving focus moveNextFocusto $currentRowIndex : $currentColIndex");
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
        print("inside else");
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

  void removeCurrentRow(int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      // updateTotals();
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      // Get.snackbar(
      //   'Cannot Remove',
      //   'Cannot remove the last row.',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  Future<void> validateAndPostPurchaseInvoice({required bool isHeld}) async {
    final CreateSalesViewModel createSalesViewModel =
        Get.find<CreateSalesViewModel>();
    // Check if sequence is selected and valid
    if (createSalesViewModel.selectedSequence.value == null) {
      showErrorToast(
        message: "Please select a valid sales number sequence",
        alignment: Alignment.center,
      );
      return;
    }
    if (createSalesViewModel.sequencesDropdownResponse.value.status ==
        Status.ERROR) {
      showErrorToast(
        message: "Cannot create invoice: Sales number sequence failed to load",
        alignment: Alignment.center,
      );
      return;
    }
    if (createSalesViewModel.sequencesDropdownList.isEmpty) {
      showErrorToast(
        message:
            "Cannot create invoice: No sales number sequences available for selected metal type",
        alignment: Alignment.center,
      );
      return;
    }
    bool hasValidPaymentAmount = false;
    // for (var controller in controllers) {
    //   double amount = double.tryParse(controller.amount.text) ?? 0;
    //   if (amount != 0) {
    //     hasValidPaymentAmount = true;
    //     break;
    //   }
    // }
    // if (!hasValidPaymentAmount) {
    //   showErrorToast(
    //     message: "Please enter the amount",
    //     alignment: Alignment.center,
    //   );
    //   return;
    // }
    controllers.removeWhere(
      (element) => element.amount.text.isEmpty || element.amount.text == "0",
    );

    if (controllers.isEmpty) {
      showErrorToast(
        message: "Please enter at least one payment method with amount",
        alignment: Alignment.center,
      );
      return;
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if (formKey.currentState!.validate() == false) {
      return;
    }
    double total = 0;
    for (var element in controllers) {
      total += double.tryParse(element.amount.text) ?? 0;
    }
    double paid = double.tryParse(paidAmountController.text) ?? 0;
    if (total != paid) {
      showErrorToast(
        message: "Paid amount not met!",
        alignment: Alignment.center,
      );
      return;
    }

    PostSalesRequestModel invoiceModel = getConvertedRequestModel(
      isHeld: isHeld,
    );
    log("The  details are here to send ${jsonEncode(invoiceModel.toJson())}");
    try {
      double balance = double.tryParse(balanceAmountController.text) ?? 0;
      if (balance != 0) {
        bool value = await Get.dialog(SalesHoldItemsAttentionDialog());
        if (value == false) {
          await _createSalesViewModel.addSalesInvoice(
            salesRequest: invoiceModel,
          );
          clearAllControllers(invoiceType: "invoice_number_vendor");
          showSuccessToast(message: 'Sale added successfully !');
          Get.back();
        }
        return;
      }
      await _createSalesViewModel.addSalesInvoice(salesRequest: invoiceModel);
      clearAllControllers(invoiceType: "invoice_number_vendor");
      showSuccessToast(message: 'Sale added successfully !');
      Get.back();
    } catch (e, s) {
      log("Error in validateAndPostPurchaseInvoice: $e \n $s");
      showErrorToast(
        message:
            _createSalesViewModel.postSalesResponse.value.message ??
            "Something went wrong",
      );
    }
  }

  PostSalesRequestModel getConvertedRequestModel({required bool isHeld}) {
    CreateSalesItemDetailsController itemDetailsController =
        Get.find<CreateSalesItemDetailsController>();

    CreateSalesEstimationSearchPartyController partyController =
        Get.find<CreateSalesEstimationSearchPartyController>();

    SalesOldGoldController oldGoldController =
        Get.find<SalesOldGoldController>();
    SalesJewelleryPlanController jewelleryPlanController =
        Get.find<SalesJewelleryPlanController>();

    SalesAdvanceBookingController advanceBookingController =
        Get.find<SalesAdvanceBookingController>();

    SalesAddOrdersDialogController salesAddOrdersDialogController =
        Get.find<SalesAddOrdersDialogController>();

    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          3],
    );
    //      +
    // schemeDisct +
    // rateDisct +
    // discount +
    // (double.tryParse(jewellerDiscount.text) ?? 0);

    List<PostSaleLineItemRequest>? lineItems =
        itemDetailsController.controllers
            .map(
              (element) => PostSaleLineItemRequest(
                ornamentId: element.ornamentId,
                shopId: element.shopId,
                designCode: element.designCode,
                ornamentCode: element.ornamentCode,
                ornamentName: element.ornamentName,
                code: element.code.text,
                taggingId: element.taggingId,
                tag: element.tagNumber,
                description: element.item_description.text,
                salesPersonId: element.employeeDetails?.id,
                taggingPieces: double.tryParse(element.pcs.text),
                taggingGrossWeight: element.originalGwt,
                taggingNetWeight: element.originalNwt,
                finalPieces: double.tryParse(element.pcs.text),
                finalGrossWeight: element.gwt.text,
                finalNetWeight: element.nwt.text,
                taggingVa: element.originalVa.toString(),
                finalVa: element.va.text,
                taggingMc: element.originalMc.toString(),
                finalMc: element.mc.text,
                stoneCost: element.stone.text,
                hallMark: element.hallMark.text,
                discount: element.costDiscount.text,
                salesAmount: element.salesAmount,
                salesAmountWithoutRoundoff: element.salesAmountWithoutRoundoff,
                salesAmountRoundoffDiff: element.salesAmountRoundoffDiff,
                totalAmount: element.total,
                totalAmountWithoutRoundoff: element.totalAmountWithoutRoundoff,
                totalAmountRoundoffDiff: element.totalAmountRoundoffDiff,
                makingChargesType: element.makingChargesType,
                minVa: (element.minVa),
                minMc: (element.minMC),
                wastageType: element.wastageType,
                itemHandover: element.isHandOver,
                costDiscount: double.tryParse(element.costDiscount.text),
                // counter: element.counter,
                // stockHead: element.stockHead,
                rate: element.rate.text,
              ),
            )
            .toList();

    List<PostSalePaymentMethodDetailRequest> paymentMethodDetails =
        controllers.map((element) {
          String? posAccountId;
          String? salesReturnId;
          String posValue = element.pos_bank.text;

          // Check if this is a credit note payment
          if (element.method.text.toLowerCase() == "credit note") {
            // For credit notes, pos_bank contains the credit note ID
            salesReturnId = posValue.isEmpty ? null : posValue;
            posAccountId = null; // No bank account for credit notes
          } else {
            // For other payment methods, handle as before
            if (posValue == "None" || posValue.isEmpty) {
              posAccountId = null;
            } else {
              final accountDetails = getAccountByCode(posValue);
              posAccountId = accountDetails?.id;
            }
            salesReturnId = null; // No sales return for regular payments
          }

          return PostSalePaymentMethodDetailRequest(
            amount: element.amount.text,
            date: convertStringToDateTime(element.date.text),
            method: element.method.text,
            paymentCode:
                element.method.text.toLowerCase() == "credit note"
                    ? element
                        .pos_bank
                        .text // For credit notes, use the credit note ID as payment code
                    : element
                        .upi_utr_cn
                        .text, // For others, use the UPI/UTR field
            pos:
                element.method.text.toLowerCase() == "credit note"
                    ? null // Don't send POS for credit notes
                    : element.pos_bank.text,
            posAccountId: posAccountId,
            organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
            salesReturnId: salesReturnId,
          );
        }).toList();
    SalesJewelleryPlanController salesJewelleryPlanController =
        Get.find<SalesJewelleryPlanController>();
    double jewelleryPlanPrincipalAmount = _calculateJewelleryPlanAmount(
      salesJewelleryPlanController.selectedJewelleryPlans.toList(),
    );
    PostSalePaymentDetailRequest
    paymentDetailsModel = PostSalePaymentDetailRequest(
      balanceAmount: (balanceAmountController.text.trim()),
      cgst: CGStValue.value,
      cgstWithoutRoundoff: cgstWithoutRoundoff.value,
      cgstRoundoffDiff: cgstRoundoffDiff.value,

      sgst: SGSTValue.value,
      sgstWithoutRoundoff: sgstWithoutRoundoff.value,
      sgstRoundoffDiff: sgstRoundoffDiff.value,

      igst: IGStValue.value,
      igstWithoutRoundoff: igstWithoutRoundoff.value,
      igstRoundoffDiff: igstRoundoffDiff.value,

      subTotal: subTotal.toStringAsFixed(2),

      tcs: tcsController.text.trim().isEmpty ? null : tcsController.text.trim(),
      tcsWithoutRoundoff: tcsWithoutRoundoff.value,
      tcsRoundoffDiff: tcsRoundoffDiff.value,

      tds: tdsController.text.trim().isEmpty ? null : tdsController.text.trim(),
      tdsWithoutRoundoff: tdsWithoutRoundoff.value,
      tdsRoundoffDiff: tdsRoundoffDiff.value,

      paymentMethodDetails: paymentMethodDetails,
      receivedAmount:
          paidAmountController.text.trim().isEmpty
              ? null
              : (paidAmountController.text.trim()),
      amount: totalPrice.value,
      advance: advanceAmountController.text,
      bankCharges: bankChargesAmountController.text,
      finalAmount: totalPrice.value,
      finalAmountWithoutRoundoff: finalAmountWithoutRoundoff.value,
      finalAmountRoundoffDiff: finalAmountRoundoffDiff.value,

      nettGst: gstNet.toStringAsFixed(2),
      nettGstWithoutRoundoff: nettGstWithoutRoundoff.value,
      nettGstRoundoffDiff: nettGstRoundoffDiff.value,

      nettTdsTcs: taxDeductionNet.toStringAsFixed(2),
      nettTdsTcsWithoutRoundoff: nettTdsTcsWithoutRoundoff.value,
      nettTdsTcsRoundoffDiff: nettTdsTcsRoundoffDiff.value,

      purchaseOldGold: purchaseAmountController.text,
      rateDiscount: rateDisct.toStringAsFixed(2),
      roundOff:
          roundOffController.text.trim().isEmpty
              ? "0"
              : roundOffController.text.trim(),
      salesAmount: salesAmount.toStringAsFixed(2),
      salesAmountWithoutRoundoff: salesAmountWithoutRoundoff.value,
      salesAmountRoundoffDiff: salesAmountRoundoffDiff.value,

      // salesRecordId: "",
      schemeDiscount: schemeDisct.toStringAsFixed(2),

      // total: totalPrice.value,
      // roundOff: roundOffController.text.trim().isEmpty
      //     ? null
      //     : roundOffController.text.trim(),
      advance_booking_amount: advanceBookingController.totalAdvancePaid.value,
      jewellery_plan_base_amount: jewelleryPlanPrincipalAmount,
      order_amount_used: salesAddOrdersDialogController.totalAdvancePaid.value,
    );

    String partyAddress = "";
    String partyCode = "";
    String? partyGst = "";
    String partyId = "";
    String partyName = "";
    String partyType = "";
    if (partyController.selectedParty.value is CustomerSearchValue) {
      final CustomerSearchValue customerSearchValue =
          partyController.selectedParty.value;
      partyAddress = customerSearchValue.address?.firstOrNull?.city ?? "";
      partyCode = customerSearchValue.readableId ?? "";
      partyGst = customerSearchValue.gstNumber;
      partyId = customerSearchValue.id ?? '';
      partyName = customerSearchValue.name ?? "";
      partyType = "customer";
    } else if (partyController.selectedParty.value is VendorSearchValue) {
      final VendorSearchValue vendorSearchValue =
          partyController.selectedParty.value;
      String address = "";
      if (vendorSearchValue.address?.isNotEmpty ?? false) {
        address = vendorSearchValue.address?.firstOrNull?.city ?? "";
      }
      partyAddress = address;
      partyCode = vendorSearchValue.code ?? "";
      partyGst = vendorSearchValue.gstNumber;
      partyId = vendorSearchValue.id ?? '';
      partyName = vendorSearchValue.name ?? "";
      partyType = "vendor";
    }

    List<PostSaleOldGoldRequest>? oldGolds =
        oldGoldController.controllers
            .where(
              (e) =>
                  e.total_amount.text.isNotEmpty && e.total_amount.text != "0",
            )
            .map(
              (element) => PostSaleOldGoldRequest(
                id: element.id,
                organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
                code: element.code.text.isEmpty ? null : element.code.text,
                description:
                    element.description.text.isEmpty
                        ? null
                        : element.description.text,
                pieces: element.pcs.text.isEmpty ? null : element.pcs.text,
                grossWeight:
                    element.gross_wtt.text.isEmpty
                        ? null
                        : element.gross_wtt.text,
                netWeight:
                    element.net_wtt.text.isEmpty ? null : element.net_wtt.text,
                less: element.less.text.isEmpty ? null : element.less.text,
                purity:
                    element.purity.text.isEmpty ? "100" : element.purity.text,
                purityType: element.selectedPurityType ?? "22k",
                metalType: element.selectedMetalType?.id ?? "1",
                ornamentId: element.ornamentId,
                rate: element.rate.text.isEmpty ? null : element.rate.text,
                amount:
                    element.amount.text.isEmpty ? null : element.amount.text,
                roundOff:
                    element.round_off.text.isEmpty
                        ? "0"
                        : element.round_off.text,
                total:
                    element.total_amount.text.isEmpty
                        ? null
                        : element.total_amount.text,
                ornamentCode:
                    element.code.text.isEmpty ? null : element.code.text,
                ornamentName: element.ornamentName,
                mc: "0",
                stone: "0",
                tch: "0",
                va: "0",
              ),
            )
            .toList();
    final jewelleryplanElementList =
        jewelleryPlanController.selectedJewelleryPlans.toList();
    List<PostSaleJewelleryPlanRequest>? jewelleryPlans =
        jewelleryplanElementList
            .map(
              (jewelleryplanElement) => PostSaleJewelleryPlanRequest(
                // id: jewelleryplanElement.id,
                installments: jewelleryplanElement.installments,
                subscriptionId: jewelleryplanElement.code,
                duration: jewelleryplanElement.planDuration,
                planId: jewelleryplanElement.id,
                redeemableAmount: jewelleryplanElement.amount,
                startDate: convertStringToDateTime(
                  jewelleryplanElement.startDate ?? "",
                  formatSent: DateFormat("dd/MM/yyyy"),
                ),
                totalWeight: jewelleryplanElement.totalWeight,
                type: jewelleryplanElement.type,
              ),
            )
            .toList();

    final advanceBookingElementList =
        advanceBookingController.selectedAdvanceBookings.toList();
    List<PostSaleAdvanceBookingDetailRequest>? advanceBookingDetails =
        advanceBookingElementList
            .map(
              (advanceBookingElement) => PostSaleAdvanceBookingDetailRequest(
                advancePaid: advanceBookingElement.cost?.toStringAsFixed(2),
                bookingId: advanceBookingElement.bookingId,
                rate: advanceBookingElement.rateValue?.toStringAsFixed(2),
                status: advanceBookingElement.status,
                weight: advanceBookingElement.quantity?.toStringAsFixed(3),
              ),
            )
            .toList();

    PostSalesRequestModel invoiceModel = PostSalesRequestModel(
      is_held: isHeld,
      voucherType: _createSalesViewModel.selectedSequence.value?.type,
      voucherSeriesId: _createSalesViewModel.selectedSequence.value?.id,
      in_store_sale: _createSalesViewModel.isStoreSale.value,
      paymentDetails: [paymentDetailsModel],
      organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
      designCode: itemDetailsController.controllers.firstOrNull?.designCode,
      partyName: partyName,

      // partyAddress: partyAddress,
      // partyCode: partyCode,
      // partyGst: partyGst,
      partyId: partyId,
      // partyInvoiceNumber:
      //     vendorBillDetailsController.invoiceNoController.text.trim(),
      // partyName: partyName,
      partyType: partyType,
      lineItems: lineItems,
      shopId: itemDetailsController.controllers.firstOrNull?.shopId,
      saleNumber: _createSalesViewModel.salesNumber.value,
      // remarks: remarksController.purchaseRemarks.value,
      remarks: "",
      // paymentStatus: false,
      advanceBookingDetails: advanceBookingDetails,
      customerHoldings: [],
      jewellerDiscount: double.tryParse(jewellerDiscount.text),
      jewelleryPlans: jewelleryPlans,
      oldGolds: oldGolds,
      ornamentCode: itemDetailsController.controllers.firstOrNull?.ornamentCode,
      ornamentName: itemDetailsController.controllers.firstOrNull?.ornamentName,
      partyAddress: partyAddress,
      partyCode: partyCode,
      partyGst: partyGst,
      partyInvoiceNumber: "",
      refernceInvoiceNumber:
          _createSalesViewModel.referenceInvoicTextController.text
              .toUpperCase(),
      orderId: salesAddOrdersDialogController.selectedOrders.firstOrNull?.id,
      jewelleryPlanOtp: jewelleryPlanController.jewelleryPlanOtp,
      jewelleryPlanPhoneNumber:
          jewelleryPlanController.jewelleryPlanPhoneNumber,
      metalType: _createSalesViewModel.selectedMetalType.value.toString(),
    );

    log("The  details are here ${jsonEncode(invoiceModel.toJson())}");
    return invoiceModel;
  }

  void clearPaymentDialogDataOnly() {
    // Clear only payment-related controllers and data
    for (var controller in controllers) {
      controller.amount.clear();
      controller.method.clear();
      controller.date.clear();
      controller.pos_bank.clear();
      controller.upi_utr_cn.clear();
    }
    controllers.clear();

    // Clear payment text controllers
    roundOffController.clear();
    tcsController.clear();
    tdsController.clear();
    paidAmountController.clear();
    balanceAmountController.clear();
    purchaseAmountController.clear();
    advanceAmountController.clear();
    bankChargesAmountController.clear();

    // Reset payment-related values
    salesAmount.value = 0;
    schemeDisct = 0;
    rateDisct = 0;
    discount.value = 0.0;
    gstNet.value = 0.0;
    taxDeductionNet.value = 0.0;
    CGStValue.value = "0";
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";
    originalTotalPrice.value = 0.0;
  }

  void clearAllControllers({required String invoiceType}) {
    // Clear all payment details controllers
    for (var controller in controllers) {
      controller.amount.clear();
      controller.method.clear();
      controller.date.clear();
      controller.pos_bank.clear();
      controller.upi_utr_cn.clear();
    }
    controllers.clear();

    // Clear all text controllers
    roundOffController.clear();
    tcsController.clear();
    tdsController.clear();
    paidAmountController.clear();
    balanceAmountController.clear();
    purchaseAmountController.clear();
    advanceAmountController.clear();
    bankChargesAmountController.clear();
    jewellerDiscount.clear();

    // Reset values
    additional_less.value = 0.0;
    salesAmount.value = 0;
    schemeDisct = 0;
    rateDisct = 0;
    discount.value = 0.0;
    gstNet.value = 0.0;
    taxDeductionNet.value = 0.0;
    CGStValue.value = "0";
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";
    originalTotalPrice.value = 0.0;

    // Clear other controllers
    final CreateSalesItemDetailsController itemDetailsController =
        Get.find<CreateSalesItemDetailsController>();
    final RemarksController remarksController = Get.find<RemarksController>();
    final CreateSalesEstimationSearchPartyController partyDetailsController =
        Get.find<CreateSalesEstimationSearchPartyController>();
    final CreateSalesViewModel createSalesViewModel =
        Get.find<CreateSalesViewModel>();
    final SalesOldGoldController oldGoldController =
        Get.find<SalesOldGoldController>();
    final SalesAdvanceBookingController advanceBookingController =
        Get.find<SalesAdvanceBookingController>();
    final SalesJewelleryPlanController jewelleryPlanController =
        Get.find<SalesJewelleryPlanController>();
    final SalesQuickEstimateController salesQuickEstimateController =
        Get.find<SalesQuickEstimateController>();
    final SalesQuickOldGoldController salesQuickOldGoldController =
        Get.find<SalesQuickOldGoldController>();
    final HoldItemsReferencePartyController holdItemsReferencePartyController =
        Get.find<HoldItemsReferencePartyController>();
    final HoldItemDetailsController holdItemDetailsController =
        Get.find<HoldItemDetailsController>();

    // Clear all controllers
    itemDetailsController.clearControllers();
    remarksController.purchaseRemarks.value = "";
    partyDetailsController.clearControllers();
    createSalesViewModel.clearControllers();
    oldGoldController.clearTextController();
    advanceBookingController.clearControllers();
    jewelleryPlanController.clearControllers();
    salesQuickEstimateController.clearControllers();
    salesQuickOldGoldController.clearControllers();
    holdItemsReferencePartyController.clearControllers();
    holdItemDetailsController.clearControllers();
  }

  PostSalesRequestModel getConvertedRequestModelForHoldItems({
    required List<HoldItemDetailsTableData>? holdItemsTableDataControllers,
    required List<AddMoreItemClass> addMoreItems,
    required bool isHeld,
  }) {
    CreateSalesItemDetailsController itemDetailsController =
        Get.find<CreateSalesItemDetailsController>();

    // VendorBillDetailsController vendorBillDetailsController =
    //     Get.find<VendorBillDetailsController>();

    CreateSalesEstimationSearchPartyController partyController =
        Get.find<CreateSalesEstimationSearchPartyController>();
    // RemarksController remarksController = Get.find<RemarksController>();

    SalesOldGoldController oldGoldController =
        Get.find<SalesOldGoldController>();

    SalesJewelleryPlanController jewelleryPlanController =
        Get.find<SalesJewelleryPlanController>();

    SalesAdvanceBookingController advanceBookingController =
        Get.find<SalesAdvanceBookingController>();

    SalesAddOrdersDialogController salesAddOrdersDialogController =
        Get.find<SalesAddOrdersDialogController>();

    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          3],
    );
    //      +
    // schemeDisct +
    // rateDisct +
    // discount +
    // (double.tryParse(jewellerDiscount.text) ?? 0);

    List<PostSaleLineItemRequest>? lineItems =
        holdItemsTableDataControllers
            ?.map(
              (element) => PostSaleLineItemRequest(
                ornamentId: element.createSalesItemDetailsTableData.ornamentId,
                designCode: element.createSalesItemDetailsTableData.designCode,
                ornamentCode:
                    element.createSalesItemDetailsTableData.ornamentCode,
                ornamentName:
                    element.createSalesItemDetailsTableData.ornamentName,
                shopId: element.createSalesItemDetailsTableData.shopId,
                code: element.createSalesItemDetailsTableData.code.text,
                taggingId: element.createSalesItemDetailsTableData.taggingId,
                tag: element.createSalesItemDetailsTableData.tagNumber,
                description:
                    element
                        .createSalesItemDetailsTableData
                        .item_description
                        .text,
                salesPersonId:
                    element.createSalesItemDetailsTableData.employeeDetails?.id,
                taggingPieces: double.tryParse(
                  element.createSalesItemDetailsTableData.pcs.text,
                ),
                taggingGrossWeight:
                    element.createSalesItemDetailsTableData.originalGwt,
                taggingNetWeight:
                    element.createSalesItemDetailsTableData.originalNwt,
                finalPieces: double.tryParse(
                  element.createSalesItemDetailsTableData.pcs.text,
                ),
                finalGrossWeight:
                    element.createSalesItemDetailsTableData.gwt.text,
                finalNetWeight:
                    element.createSalesItemDetailsTableData.nwt.text,
                taggingVa:
                    element.createSalesItemDetailsTableData.originalVa
                        .toString(),
                finalVa: element.createSalesItemDetailsTableData.va.text,
                taggingMc:
                    element.createSalesItemDetailsTableData.originalMc
                        .toString(),
                finalMc: element.createSalesItemDetailsTableData.mc.text,
                stoneCost: element.createSalesItemDetailsTableData.stone.text,
                hallMark: element.createSalesItemDetailsTableData.hallMark.text,
                discount:
                    element.createSalesItemDetailsTableData.costDiscount.text,
                salesAmount:
                    element.createSalesItemDetailsTableData.salesAmount,
                totalAmount: element.createSalesItemDetailsTableData.total,
                makingChargesType:
                    element.createSalesItemDetailsTableData.makingChargesType,
                minVa: (element.createSalesItemDetailsTableData.minVa),
                minMc: (element.createSalesItemDetailsTableData.minMC),
                wastageType:
                    element.createSalesItemDetailsTableData.wastageType,
                itemHandover: element.isSelected == true ? false : true,
                costDiscount: double.tryParse(
                  element.createSalesItemDetailsTableData.costDiscount.text,
                ),
                // counter: element.createSalesItemDetailsTableData.counter,
                // stockHead: element.createSalesItemDetailsTableData.stockHead,
                rate: element.createSalesItemDetailsTableData.rate.text,
              ),
            )
            .toList();

    List<PostSalePaymentMethodDetailRequest> paymentMethodDetails =
        controllers
            .map(
              (element) => PostSalePaymentMethodDetailRequest(
                amount: (element.amount.text),
                date: convertStringToDateTime(element.date.text),
                method: element.method.text,
                paymentCode: element.upi_utr_cn.text,
                pos: element.pos_bank.text,
                organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
                // salesPaymentDetailsId: ""
              ),
            )
            .toList();
    SalesJewelleryPlanController salesJewelleryPlanController =
        Get.find<SalesJewelleryPlanController>();
    double jewelleryPlanPrincipalAmount = _calculateJewelleryPlanAmount(
      salesJewelleryPlanController.selectedJewelleryPlans.toList(),
    );
    PostSalePaymentDetailRequest
    paymentDetailsModel = PostSalePaymentDetailRequest(
      organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
      balanceAmount: (balanceAmountController.text.trim()),
      cgst: CGStValue.value,
      sgst: SGSTValue.value,
      igst: IGStValue.value,
      subTotal: (subTotal.toStringAsFixed(2)),
      tcs: tcsController.text.trim().isEmpty ? null : tcsController.text.trim(),
      tds: tdsController.text.trim().isEmpty ? null : tdsController.text.trim(),
      paymentMethodDetails: paymentMethodDetails,
      receivedAmount:
          paidAmountController.text.trim().isEmpty
              ? null
              : (paidAmountController.text.trim()),
      amount: totalPrice.value,
      advance: advanceAmountController.text,
      bankCharges: bankChargesAmountController.text,
      finalAmount: totalPrice.value,
      nettGst: gstNet.toStringAsFixed(2),
      nettTdsTcs: taxDeductionNet.toStringAsFixed(2),
      purchaseOldGold: purchaseAmountController.text,
      rateDiscount: rateDisct.toStringAsFixed(2),
      roundOff:
          roundOffController.text.trim().isEmpty
              ? "0"
              : roundOffController.text.trim(),
      salesAmount: salesAmount.toStringAsFixed(2),
      // salesRecordId: "",
      schemeDiscount: schemeDisct.toStringAsFixed(2),

      // total: totalPrice.value,
      // roundOff: roundOffController.text.trim().isEmpty
      //     ? null
      //     : roundOffController.text.trim(),
      advance_booking_amount: advanceBookingController.totalAdvancePaid.value,
      jewellery_plan_base_amount: jewelleryPlanPrincipalAmount,
      order_amount_used: salesAddOrdersDialogController.totalAdvancePaid.value,
    );

    String partyAddress = "";
    String partyCode = "";
    String? partyGst = "";
    String partyId = "";
    String partyName = "";
    String partyType = "";
    if (partyController.selectedParty.value is CustomerSearchValue) {
      final CustomerSearchValue customerSearchValue =
          partyController.selectedParty.value;
      partyAddress = customerSearchValue.address?.firstOrNull?.city ?? "";
      partyCode = "";
      partyGst = customerSearchValue.gstNumber;
      partyId = customerSearchValue.id ?? '';
      partyName = customerSearchValue.name ?? "";
      partyType = "customer";
    } else if (partyController.selectedParty.value is VendorSearchValue) {
      final VendorSearchValue vendorSearchValue =
          partyController.selectedParty.value;
      String address = "";
      if (vendorSearchValue.address?.isNotEmpty ?? false) {
        address = vendorSearchValue.address?.firstOrNull?.city ?? "";
      }
      partyAddress = address;
      partyCode = vendorSearchValue.code ?? "";
      partyGst = vendorSearchValue.gstNumber;
      partyId = vendorSearchValue.id ?? '';
      partyName = vendorSearchValue.name ?? "";
      partyType = "vendor";
    }

    List<PostSaleOldGoldRequest>? oldGolds =
        oldGoldController.controllers
            .map(
              (element) => PostSaleOldGoldRequest(
                id: element.id,
                organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
                code: element.code.text.isEmpty ? null : element.code.text,
                description:
                    element.description.text.isEmpty
                        ? null
                        : element.description.text,
                pieces: element.pcs.text.isEmpty ? null : element.pcs.text,
                grossWeight:
                    element.gross_wtt.text.isEmpty
                        ? null
                        : element.gross_wtt.text,
                netWeight:
                    element.net_wtt.text.isEmpty ? null : element.net_wtt.text,
                less: element.less.text.isEmpty ? null : element.less.text,
                purity:
                    element.purity.text.isEmpty ? "100" : element.purity.text,
                purityType: element.selectedPurityType ?? "22k",
                metalType: element.selectedMetalType?.id ?? "1",
                ornamentId: element.ornamentId,
                rate: element.rate.text.isEmpty ? null : element.rate.text,
                amount:
                    element.amount.text.isEmpty ? null : element.amount.text,
                roundOff:
                    element.round_off.text.isEmpty
                        ? null
                        : element.round_off.text,
                total:
                    element.total_amount.text.isEmpty
                        ? null
                        : element.total_amount.text,
                ornamentCode:
                    element.code.text.isEmpty ? null : element.code.text,
                ornamentName: element.ornamentName,
                mc: "0",
                stone: "0",
                tch: "0",
                va: "0",
              ),
            )
            .toList();
    final jewelleryplanElementList =
        jewelleryPlanController.selectedJewelleryPlans.toList();
    List<PostSaleJewelleryPlanRequest>? jewelleryPlans =
        jewelleryplanElementList
            .map(
              (jewelleryplanElement) => PostSaleJewelleryPlanRequest(
                // id: jewelleryplanElement.id,
                installments: jewelleryplanElement.installments,
                subscriptionId: jewelleryplanElement.code,
                duration: jewelleryplanElement.planDuration,
                planId: jewelleryplanElement.id,
                redeemableAmount: jewelleryplanElement.amount,
                startDate: convertStringToDateTime(
                  jewelleryplanElement.startDate ?? "",
                  formatSent: DateFormat("dd/MM/yyyy"),
                ),
                totalWeight: jewelleryplanElement.totalWeight,
                type: jewelleryplanElement.type,
              ),
            )
            .toList();
    final advanceBookingElementList =
        advanceBookingController.selectedAdvanceBookings.toList();
    List<PostSaleAdvanceBookingDetailRequest>? advanceBookingDetails =
        advanceBookingElementList
            .map(
              (advanceBookingElement) => PostSaleAdvanceBookingDetailRequest(
                advancePaid: advanceBookingElement.cost?.toStringAsFixed(2),
                bookingId: advanceBookingElement.bookingId,
                rate: advanceBookingElement.rateValue?.toStringAsFixed(2),
                status: advanceBookingElement.status,
                weight: advanceBookingElement.quantity?.toStringAsFixed(3),
              ),
            )
            .toList();

    List<PostSaleCustomerHoldingRequest>? customerHoldings =
        addMoreItems
            .map(
              (e) => PostSaleCustomerHoldingRequest(
                organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
                shopId: itemDetailsController.controllers.firstOrNull?.shopId,
                itemDescription: e.itemDescription,
                netWeight: double.tryParse(e.netWeight),
                customerId: partyId,
                // salesRecordId: "",
                isReturned: false,
              ),
            )
            .toList();
    PostSalesRequestModel invoiceModel = PostSalesRequestModel(
      is_held: isHeld,

      voucherType: _createSalesViewModel.selectedSequence.value?.type,
      voucherSeriesId: _createSalesViewModel.selectedSequence.value?.id,

      in_store_sale: _createSalesViewModel.isStoreSale.value,
      paymentDetails: [paymentDetailsModel],
      organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
      designCode:
          holdItemsTableDataControllers
              ?.firstOrNull
              ?.createSalesItemDetailsTableData
              .designCode,
      partyName: partyName,
      partyId: partyId,
      partyType: partyType,
      lineItems: lineItems,
      shopId: itemDetailsController.controllers.firstOrNull?.shopId,
      saleNumber: _createSalesViewModel.salesNumber.value,
      remarks: "",
      // paymentStatus: false,
      advanceBookingDetails: advanceBookingDetails,
      customerHoldings: customerHoldings,
      jewellerDiscount: double.tryParse(jewellerDiscount.text),
      jewelleryPlans: jewelleryPlans,
      oldGolds: oldGolds,
      ornamentCode: itemDetailsController.controllers.firstOrNull?.ornamentCode,
      ornamentName: itemDetailsController.controllers.firstOrNull?.ornamentName,
      partyAddress: partyAddress,
      partyCode: partyCode,
      partyGst: partyGst,
      partyInvoiceNumber: "",
      refernceInvoiceNumber:
          _createSalesViewModel.referenceInvoicTextController.text
              .toUpperCase(),
      orderId: salesAddOrdersDialogController.selectedOrders.firstOrNull?.id,
      jewelleryPlanOtp: jewelleryPlanController.jewelleryPlanOtp,
      jewelleryPlanPhoneNumber:
          jewelleryPlanController.jewelleryPlanPhoneNumber,
      metalType: _createSalesViewModel.selectedMetalType.value.toString(),
    );

    log("The  details are here ${jsonEncode(invoiceModel.toJson())}");
    return invoiceModel;
  }

  Future<void> postAddSaleWithHoldings({
    required List<HoldItemDetailsTableData>? holdItemsTableDataControllers,
    required List<AddMoreItemClass> addMoreItems,
    required bool isHeld,
  }) async {
    PostSalesRequestModel invoiceModel = getConvertedRequestModelForHoldItems(
      holdItemsTableDataControllers: holdItemsTableDataControllers,
      addMoreItems: addMoreItems,
      isHeld: isHeld,
    );
    log("The  details are here to send ${jsonEncode(invoiceModel.toJson())}");
    try {
      await _createSalesViewModel.addSalesInvoice(salesRequest: invoiceModel);
      clearAllControllers(invoiceType: "invoice_number_vendor");
      showSuccessToast(message: 'Sale added successfully !');
      Get.back();
    } catch (e, s) {
      log("Error in validateAndPostPurchaseInvoice: $e \n $s");
      showErrorToast(
        message:
            _createSalesViewModel.postSalesResponse.value.message ??
            "Something went wrong",
      );
      rethrow;
    }
  }

  void prefillSalesPaymentValues({
    required double? additionalLess,
    required String? jewelleryDiscount,
    List<PostSalePaymentDetailRequest>? paymentDetails,
  }) {
    // Set basic values
    additional_less.value = additionalLess ?? 0.0;
    jewellerDiscount.text = jewelleryDiscount ?? "";

    // If no payment details, nothing else to do
    if (paymentDetails == null || paymentDetails.isEmpty) {
      return;
    }

    // Get the first payment detail item
    final paymentDetail = paymentDetails.first;

    // Clear existing controllers to prevent duplicates
    controllers.clear();

    // Set GST values
    CGStValue.value = paymentDetail.cgst ?? "0";
    SGSTValue.value = paymentDetail.sgst ?? "0";
    IGStValue.value = paymentDetail.igst ?? "0";

    // Set amount values
    totalPrice.value = paymentDetail.amount ?? "0";
    if (paymentDetail.finalAmount != null) {
      originalTotalPrice.value =
          double.tryParse(paymentDetail.finalAmount!) ?? 0.0;
    }

    // Set other fields
    tcsController.text = paymentDetail.tcs ?? "";
    tdsController.text = paymentDetail.tds ?? "";

    // Set received amount
    if (paymentDetail.receivedAmount == null ||
        paymentDetail.receivedAmount == "0") {
      paidAmountController.text = totalPrice.value;
    } else {
      paidAmountController.text = paymentDetail.receivedAmount ?? "0";
    }

    balanceAmountController.text = paymentDetail.balanceAmount ?? "0";
    advanceAmountController.text = paymentDetail.advance ?? "0";
    bankChargesAmountController.text = paymentDetail.bankCharges ?? "0";
    purchaseAmountController.text = paymentDetail.purchaseOldGold ?? "0";
    roundOffController.text = paymentDetail.roundOff ?? "0";

    // Set calculation values
    salesAmount.value =
        double.tryParse(paymentDetail.salesAmount ?? "0") ?? 0.0;
    gstNet.value = double.tryParse(paymentDetail.nettGst ?? "0") ?? 0.0;
    taxDeductionNet.value =
        double.tryParse(paymentDetail.nettTdsTcs ?? "0") ?? 0.0;
    rateDisct = double.tryParse(paymentDetail.rateDiscount ?? "0") ?? 0.0;
    schemeDisct = double.tryParse(paymentDetail.schemeDiscount ?? "0") ?? 0.0;

    // Handle payment method details
    if (paymentDetail.paymentMethodDetails != null &&
        paymentDetail.paymentMethodDetails!.isNotEmpty) {
      for (var methodDetail in paymentDetail.paymentMethodDetails!) {
        controllers.add(
          PaymentDetailsTableData(
            amount: TextEditingController(text: methodDetail.amount ?? "0"),
            method: TextEditingController(text: methodDetail.method ?? ""),
            date: TextEditingController(
              text:
                  methodDetail.date != null
                      ? DateFormat('dd/MM/yyyy').format(methodDetail.date!)
                      : DateFormat('dd/MM/yyyy').format(DateTime.now()),
            ),
            pos_bank: TextEditingController(
              text: methodDetail.pos ?? bankList.first,
            ),
            upi_utr_cn: TextEditingController(
              text: methodDetail.paymentCode ?? "",
            ),
          ),
        );
      }
    }

    // If no payment methods were added, ensure there's at least one row
    if (controllers.isEmpty) {
      addRow();
      // Set first row amount to total received amount
      if (controllers.isNotEmpty) {
        double totalReceived = double.tryParse(paidAmountController.text) ?? 0;
        controllers[0].amount.text = totalReceived.toStringAsFixed(2);
      }
    }

    // Reset current indices to beginning for proper focus
    currentRowIndex.value = 0;
    currentColIndex.value = 0;

    // Refresh controllers to update UI
    controllers.refresh();
  }

  bool isJewellerDiscountApplied() {
    final discountValue = double.tryParse(jewellerDiscount.text) ?? 0;
    return discountValue > 0;
  }

  double calculateRemainingAmount() {
    // Get the total amount that needs to be paid
    double total = double.tryParse(totalPrice.value) ?? 0;

    // Calculate sum of all existing payment amounts
    double totalPaid = 0;
    for (var controller in controllers) {
      double amount = double.tryParse(controller.amount.text) ?? 0;
      totalPaid += amount;
    }

    // Return remaining amount
    double remaining = total - totalPaid;
    return remaining > 0 ? remaining : 0;
  }

  void populateRemainingAmount(int rowIndex) {
    if (rowIndex < 0 || rowIndex >= controllers.length) return;

    double total = double.tryParse(paidAmountController.text) ?? 0;
    double totalPaid = 0;

    for (int i = 0; i < controllers.length; i++) {
      if (i != rowIndex) {
        double amount = double.tryParse(controllers[i].amount.text) ?? 0;
        totalPaid += amount;
      }
    }

    double remaining = total - totalPaid;
    if (remaining > 0) {
      controllers[rowIndex].amount.text = remaining.toStringAsFixed(2);
    }
  }
}
