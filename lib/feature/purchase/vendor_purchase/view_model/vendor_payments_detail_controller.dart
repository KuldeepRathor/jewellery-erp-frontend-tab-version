import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/get_debit_note_purchase_return_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/line_item_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/line_stone_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/payment_detail_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/payment_method_detail_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/purchase_invoice_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/purchase_invoice_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/vendor_purchase/view_model/vendor_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_account_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class VendorPaymentDetailsController extends GetxController {
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();

  final PurchaseRepository _purchaseRepository = PurchaseRepository();

  final CGStValue = "0".obs;
  final IGStValue = "0".obs;
  final SGSTValue = "0".obs;
  final balanceAmountController = TextEditingController();

  final RxList<GetAccountSettingsResponse> accountSettingsList =
      <GetAccountSettingsResponse>[].obs;
  final RxList<String> bankList = <String>[].obs;
  final accountSettingsResponse =
      ApiResponse<List<GetAccountSettingsResponse>>.loading("LOADING").obs;

  final RxList<GetPurchaseReturnDebitNoteValue> debitNotesList =
      <GetPurchaseReturnDebitNoteValue>[].obs;
  final debitNotesResponse =
      ApiResponse<GetPurchaseReturnDebitNoteResponse>.loading("LOADING").obs;
  final isDebitNotesLoading = false.obs;

  // final bankList = [
  //   "SBI",
  //   "Paytm",
  //   "HDFC",
  //   "ICICI",
  //   "Yes",
  //   "IB",
  //   "CUB",
  //   "KCC",
  // ];

  final calulcatedTaxTotalToShow = 0.0.obs;
  final controllers = <PaymentDetailsTableData>[].obs;
  final currentColIndex = 0.obs;
  final currentRowIndex = 0.obs;
  final displaySubTotal = "0".obs;
  final formKey = GlobalKey<FormState>();
  final hallMarkChargesController = TextEditingController();

  // final methodList = [
  //   "Cash",
  //   "Card",
  //   "NEFT/RTGS",
  //   "UPI/IMPS",
  //   "Cheque",
  // ];
  final paidAmountController = TextEditingController();
  final paidAmountFocusNode = FocusNode();
  final paymentColumnWidths = [0.1, 0.28, 0.28, 0.28, 0.28, 0.28, 0.2];

  final paymentHeaders = [
    'Sn',
    'Amount (₹)',
    'Method',
    'Date',
    'POS/Bank',
    'UPI/UTR/Cn.',
    '',
  ];

  final roundOffController = TextEditingController();
  final roundOffTotalToShow = 0.0.obs;
  final scrollController = ScrollController();
  final tcsController = TextEditingController();
  final tdsController = TextEditingController();
  final totalPrice = "0".obs;

  final OrganizationRepository _organizationRepository =
      OrganizationRepository();

  final PurchaseInvoiceViewmodel _purchaseInvoiceViewmodel = Get.put(
    PurchaseInvoiceViewmodel(),
  );

  @override
  void onClose() {
    paidAmountFocusNode.dispose();
    hallMarkChargesController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
    fetchAccountSettings();
  }

  void initializeRow() {
    controllers.clear();
    addRow();
    currentRowIndex.value = 0;
    currentColIndex.value = 0;

    if (controllers.isNotEmpty) {
      double totalReceived = double.tryParse(paidAmountController.text) ?? 0;
      if (totalReceived > 0) {
        controllers[0].amount.text = totalReceived.toStringAsFixed(2);
      }
    }
  }

  Future<void> fetchDebitNotes() async {
    try {
      // Get the selected party
      final VendorDetailsController partyController =
          Get.find<VendorDetailsController>();

      final partyId = partyController.selectedParty.value?.id;

      if (partyId == null || partyId.isEmpty) {
        showErrorToast(message: 'Please select a party first');
        return;
      }

      isDebitNotesLoading.value = true;
      debitNotesResponse.value = ApiResponse.loading("LOADING");

      final response = await _purchaseRepository.getPurchaseReturnDebitNote(
        partyId,
      );

      debitNotesList.clear();
      if (response.values != null) {
        // Only add debit notes that are not consumed and have balance > 0
        debitNotesList.addAll(
          response.values!.where(
            (note) =>
                note.isConsumed != true &&
                (double.tryParse(note.balance ?? '0') ?? 0) > 0,
          ),
        );
      }

      debitNotesResponse.value = ApiResponse.completed(response);

      if (debitNotesList.isEmpty) {
        showErrorToast(message: 'No debit notes available for this party');
      }

      // Refresh the UI to update dropdowns
      controllers.refresh();
    } catch (e) {
      log("Error fetching debit notes: $e");
      debitNotesResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to fetch debit notes: ${e.toString()}');
    } finally {
      isDebitNotesLoading.value = false;
    }
  }

  // Add helper method to get debit note by ID
  GetPurchaseReturnDebitNoteValue? getDebitNoteById(String debitNoteId) {
    try {
      return debitNotesList.firstWhere((note) => note.id == debitNoteId);
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

  void clearTextController() {
    roundOffController.text = '';
    tcsController.text = '';
    tdsController.text = '';
    paidAmountController.text = '';
    balanceAmountController.text = '';
  }

  void addRow() {
    log("Adding row");
    double totalReceived = double.tryParse(paidAmountController.text) ?? 0;
    double currentTotal = 0;

    // Calculate the current total from all existing payment rows
    for (var controller in controllers) {
      currentTotal += double.tryParse(controller.amount.text) ?? 0;
    }

    // Calculate remaining amount
    double remainingAmount = totalReceived - currentTotal;

    controllers.add(
      PaymentDetailsTableData(
        amount: TextEditingController(
          text:
              remainingAmount > 0 ? remainingAmount.toStringAsFixed(2) : "0.00",
        ), // Set the remaining amount
        method: TextEditingController(
          text:
              paymentMethods.isNotEmpty
                  ? paymentMethods.first.method ?? ''
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
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
    } else {
      //   controllers.first.amount.clear();
      // controllers.first.upi_utr_cn.clear();
      // controllers.first.method.text = methodList.first;
      // controllers.first.date.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      // controllers.first.pos_bank.text = bankList.first;
      showErrorToast(message: "Cannot remove last row");
    }
  }

  final RxList<PaymentMethodResponse> paymentMethods =
      <PaymentMethodResponse>[].obs;
  final isLoading = false.obs;
  Future<void> fetchPaymentMethods() async {
    try {
      isLoading.value = true;
      final response = await _purchaseInvoiceRepository.getPaymentMethods();
      paymentMethods.clear();
      paymentMethods.addAll(response);

      if (controllers.isNotEmpty) {
        controllers[0].method.text = paymentMethods.first.method ?? '';
      }
    } catch (e) {
      showErrorToast(message: 'Failed to fetch payment methods');
    } finally {
      isLoading.value = false;
    }
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      });
    }
  }

  void setSelectedMethod(String? value, int rowIndex) {
    if (value != null) {
      controllers[rowIndex].method.text = value;

      if (value.toLowerCase() == "cash") {
        controllers[rowIndex].pos_bank.text = bankList.first;
        controllers[rowIndex].upi_utr_cn.text = "";
      } else if (value.toLowerCase() == "debit note") {
        // Clear the bank field when debit note is selected
        controllers[rowIndex].pos_bank.text = "";
        controllers[rowIndex].upi_utr_cn.text = ""; // Clear this too

        // Fetch debit notes if not already loaded
        if (debitNotesList.isEmpty) {
          fetchDebitNotes();
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
      initialEntryMode: DatePickerEntryMode.calendar,
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

  String getTotalGstValue() {
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();

    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );
    double igst = double.tryParse(IGStValue.value) ?? 0;
    double cgst = double.tryParse(CGStValue.value) ?? 0;
    double sgst = double.tryParse(SGSTValue.value) ?? 0;
    double value = igst + cgst + sgst + subTotal;
    return value.toStringAsFixed(2);
  }

  double getSubTotalWithHallmarkCharges() {
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();

    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );
    double hallmarkCharges =
        double.tryParse(hallMarkChargesController.text) ?? 0;

    double total = subTotal + hallmarkCharges;
    displaySubTotal.value = total.toStringAsFixed(2);
    return total;
  }

  void calculateRoundOff() {
    // Get the current total before round off
    double igst = double.tryParse(IGStValue.value) ?? 0;
    double cgst = double.tryParse(CGStValue.value) ?? 0;
    double sgst = double.tryParse(SGSTValue.value) ?? 0;
    double subTotalWithHallmark = getSubTotalWithHallmarkCharges();

    // Calculate total without round off
    double totalBeforeRoundOff = igst + cgst + sgst + subTotalWithHallmark;

    // Calculate round off value to nearest rupee
    double roundOffValue = totalBeforeRoundOff.round() - totalBeforeRoundOff;

    // Update round off controller
    roundOffController.text = roundOffValue.toStringAsFixed(2);

    // Calculate final rounded total
    roundOffTotalToShow.value =
        (totalBeforeRoundOff + roundOffValue).roundToDouble();

    // Recalculate tax after rounding
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();
    reCalculateTaxAfterRounding(itemDetailsController);
    updateBalanceAmount();

    update();
  }

  Future<void> getRoundOffTotal() async {
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();

    // Recalculate GST values based on the new subtotal with hallmark charges
    double subTotalWithHallmark = getSubTotalWithHallmarkCharges();
    double totalValueSoFor = 0;

    // Recalculate GST for each item based on its amount
    for (var itemDetail in itemDetailsController.controllers.toList()) {
      double val =
          double.parse(itemDetail.amount.text) *
          (double.parse(itemDetail.gst) / 100);
      totalValueSoFor = totalValueSoFor + val;
    }

    // Update GST values - CORRECTLY HANDLE THE FUTURE
    String igstVal = await _organizationRepository.getGstType(
      gstNumber:
          Get.find<VendorDetailsController>().selectedParty.value.gstNumber
              .toString(),
    );

    bool isIGST = igstVal == "igst";

    if (isIGST) {
      IGStValue.value = totalValueSoFor.toStringAsFixed(2);
      CGStValue.value = "0";
      SGSTValue.value = "0";
    } else {
      IGStValue.value = "0";
      CGStValue.value = (totalValueSoFor / 2).toStringAsFixed(2);
      SGSTValue.value = (totalValueSoFor / 2).toStringAsFixed(2);
    }

    // Calculate total with GST and user-provided round off
    double igst = double.tryParse(IGStValue.value) ?? 0;
    double cgst = double.tryParse(CGStValue.value) ?? 0;
    double sgst = double.tryParse(SGSTValue.value) ?? 0;
    double round = double.tryParse(roundOffController.text) ?? 0;

    double value = igst + cgst + sgst + subTotalWithHallmark + round;

    roundOffTotalToShow.value = value.toPrecision(2);
    reCalculateTaxAfterRounding(itemDetailsController);
    updateBalanceAmount();

    update();
  }

  void reCalculateTaxAfterRounding(
    ItemDetailsController itemDetailsController,
  ) {
    VendorDetailsController partyController =
        Get.find<VendorDetailsController>();
    bool isPartyTDS;
    bool isPartyTCS;
    double deductionPercent;

    // Get subtotal from itemDetailsController
    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );

    if (partyController.selectedParty.value is CustomerSearchValue) {
      final CustomerSearchValue customerSearchValue =
          partyController.selectedParty.value;
      isPartyTDS = customerSearchValue.deductionType == "TDS";
      isPartyTCS = customerSearchValue.deductionType == "TCS";

      deductionPercent =
          double.tryParse(customerSearchValue.deductionPercent ?? "null") ?? 0;
    } else {
      final VendorSearchValue vendorSearchValue =
          partyController.selectedParty.value;
      isPartyTDS = vendorSearchValue.deductionType == "TDS";
      isPartyTCS = vendorSearchValue.deductionType == "TCS";
      deductionPercent =
          double.tryParse(vendorSearchValue.deductionPercent ?? "null") ?? 0;
    }

    double valueMultiplier = deductionPercent;

    // Calculate TCS and TDS based on subtotal instead of roundOffTotalToShow
    double tcs = (subTotal * (valueMultiplier / 100)).roundToDouble();
    double tds = (subTotal * (valueMultiplier / 100)).roundToDouble();

    if (isPartyTDS) {
      tdsController.text = tds.toStringAsFixed(2);
      totalPrice.value = (roundOffTotalToShow.value - tds).toStringAsFixed(2);
    } else if (isPartyTCS) {
      tcsController.text = tcs.toStringAsFixed(2);
      totalPrice.value = (roundOffTotalToShow.value - tcs).toStringAsFixed(2);
    } else {
      totalPrice.value = roundOffTotalToShow.value.toStringAsFixed(2);
    }

    updateBalanceAmount();
  }

  void calculateTaxChange() {
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();

    // Get subtotal for tax calculations
    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );

    VendorDetailsController partyController =
        Get.find<VendorDetailsController>();
    double deductionPercent = 0;

    if (partyController.selectedParty.value is VendorSearchValue) {
      final VendorSearchValue vendorSearchValue =
          partyController.selectedParty.value;
      deductionPercent =
          double.tryParse(vendorSearchValue.deductionPercent ?? "null") ?? 0;
    }

    // Recalculate TDS and TCS based on subtotal
    double tds = subTotal * (deductionPercent / 100);
    double tcs = subTotal * (deductionPercent / 100);

    if (partyController.selectedParty.value is VendorSearchValue) {
      final VendorSearchValue vendorSearchValue =
          partyController.selectedParty.value;
      if (vendorSearchValue.deductionType == "TDS") {
        tdsController.text = tds.toStringAsFixed(2);
      } else if (vendorSearchValue.deductionType == "TCS") {
        tcsController.text = tcs.toStringAsFixed(2);
      }
    }

    double value = roundOffTotalToShow.value.toPrecision(2);
    if (tdsController.text.isNotEmpty) {
      value -= double.tryParse(tdsController.text) ?? 0;
    }
    if (tcsController.text.isNotEmpty) {
      value -= double.tryParse(tcsController.text) ?? 0;
    }

    totalPrice.value = value.toStringAsFixed(2);
    updateBalanceAmount();
  }

  void calculateBalanceAmount() {
    updateBalanceAmount();
  }

  void updateBalanceAmount() {
    double paid = double.tryParse(paidAmountController.text) ?? 0;
    double total = double.tryParse(totalPrice.value) ?? 0;

    if (paid > total) {
      showErrorToast(message: "Paid amount cannot be greater than net amount");
      paidAmountController.text = total.toStringAsFixed(2);
      paid = total;
    }
    double value = total - paid;
    balanceAmountController.text = value.toStringAsFixed(2);
  }

  Future<void> calculateGstvalues() async {
    log("Calculating values");
    CGStValue.value = "0";
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";
    clearTextController();

    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();
    VendorDetailsController partyController =
        Get.find<VendorDetailsController>();

    double subTotalWithHallmark = getSubTotalWithHallmarkCharges();
    double totalCalculatedPrice = 0;
    double totalValueSoFor = 0;

    String igstVal = await _organizationRepository.getGstType(
      gstNumber: partyController.selectedParty.value.gstNumber.toString(),
    );

    bool randomIGST = igstVal == "igst";
    log("The random gst value is $randomIGST");

    // Calculate GST values based on item amounts
    for (var itemDetail in itemDetailsController.controllers.toList()) {
      // Calculate proportion of this item's amount to total subtotal
      double itemAmount = double.parse(itemDetail.amount.text);
      double proportion =
          itemAmount /
          (subTotalWithHallmark -
              (double.tryParse(hallMarkChargesController.text) ?? 0));

      // Add proportional hallmark charges to item amount for GST calculation
      double hallmarkPortion =
          (double.tryParse(hallMarkChargesController.text) ?? 0) * proportion;
      double totalItemAmount = itemAmount + hallmarkPortion;

      double val = totalItemAmount * (double.parse(itemDetail.gst) / 100);
      log("MULTIPLYING : $totalItemAmount * ${itemDetail.gst}");
      totalValueSoFor = totalValueSoFor + val;
    }

    if (randomIGST) {
      IGStValue.value = totalValueSoFor.toStringAsFixed(2);
      CGStValue.value = "0";
      SGSTValue.value = "0";
    } else {
      IGStValue.value = "0";
      CGStValue.value = (totalValueSoFor / 2).toStringAsFixed(2);
      SGSTValue.value = (totalValueSoFor / 2).toStringAsFixed(2);
    }

    totalCalculatedPrice = totalCalculatedPrice + totalValueSoFor;
    double totalBeforeRound = totalCalculatedPrice + subTotalWithHallmark;

    // Calculate round off value to nearest rupee
    double roundOffValue = totalBeforeRound.round() - totalBeforeRound;
    roundOffController.text = roundOffValue.toStringAsFixed(2);

    // Update total with round off included
    roundOffTotalToShow.value = (totalCalculatedPrice +
            subTotalWithHallmark +
            roundOffValue)
        .toPrecision(2);

    bool isPartyTDS;
    bool isPartyTCS;
    double deductionPercent;

    if (partyController.selectedParty.value is CustomerSearchValue) {
      final CustomerSearchValue customerSearchValue =
          partyController.selectedParty.value;
      isPartyTDS = customerSearchValue.deductionType == "TDS";
      isPartyTCS = customerSearchValue.deductionType == "TCS";
      deductionPercent =
          double.tryParse(customerSearchValue.deductionPercent ?? "null") ?? 0;
    } else {
      final VendorSearchValue vendorSearchValue =
          partyController.selectedParty.value;
      isPartyTDS = vendorSearchValue.deductionType == "TDS";
      isPartyTCS = vendorSearchValue.deductionType == "TCS";
      deductionPercent =
          double.tryParse(vendorSearchValue.deductionPercent ?? "null") ?? 0;
    }

    // Calculate TCS and TDS based on subtotal with hallmark charges
    if (isPartyTDS) {
      double valueMultiplier = deductionPercent;
      log("TDS calculated $valueMultiplier");
      double tds =
          (subTotalWithHallmark * (valueMultiplier / 100)).roundToDouble();
      tdsController.text = tds.toStringAsFixed(2);
      totalCalculatedPrice -= tds;
    } else if (isPartyTCS) {
      double valueMultiplier = deductionPercent;
      log("TCS calculated $valueMultiplier");
      double tcs =
          (subTotalWithHallmark * (valueMultiplier / 100)).roundToDouble();
      tcsController.text = tcs.toStringAsFixed(2);
      totalCalculatedPrice -= tcs;
    }

    totalCalculatedPrice += subTotalWithHallmark + roundOffValue;

    totalPrice.value = totalCalculatedPrice.toStringAsFixed(2);
    balanceAmountController.text = totalCalculatedPrice.toStringAsFixed(2);
    updateBalanceAmount();
    paidAmountController.text = "0";

    update();
  }

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
        log("inside else");
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
      controllers.first.amount.clear();
      controllers.first.upi_utr_cn.clear();
      controllers.first.method.text = paymentMethods.first.method ?? "";
      controllers.first.date.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now());
      controllers.first.pos_bank.text = bankList.first;
      // showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  Future<void> validateAndPostPurchaseInvoice() async {
    double paid = double.tryParse(paidAmountController.text) ?? 0;

    if (paid > 0) {
      if (formKey.currentState!.validate() == false) {
        return;
      }

      // Calculate total from controllers
      double total = 0;
      for (var element in controllers) {
        total += double.tryParse(element.amount.text) ?? 0;
      }

      // Validate that entered amounts match
      if (total != paid) {
        showErrorToast(
          message: "Paid amount not met!",
          alignment: Alignment.center,
        );
        return;
      }
    }
    controllers.removeWhere(
      (element) => element.amount.text.isEmpty || element.amount.text == "0",
    );
    PurchaseInvoiceRequestModel invoiceModel = getConvertedRequestModel();
    log("The  details are here to send ${jsonEncode(invoiceModel.toJson())}");
    try {
      await _purchaseInvoiceViewmodel.postPurchaseInvoice(
        purchaseInvoiceRequest: invoiceModel,
      );
      clearAllControllers(invoiceType: "invoice_number_vendor");
      showSuccessToast(message: 'Purchase Invoice added successfully !');
      Get.back();
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.popBackSelectedWidget();
    } catch (e, s) {
      log("Error in validateAndPostPurchaseInvoice: $e \n $s");
      showErrorToast(
        message:
            _purchaseInvoiceViewmodel
                .postPurchaseInvoiceResponse
                .value
                .message ??
            "Something went wrong",
      );
    }
  }

  PurchaseInvoiceRequestModel getConvertedRequestModel() {
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();
    VendorBillDetailsController vendorBillDetailsController =
        Get.find<VendorBillDetailsController>();

    VendorDetailsController partyController =
        Get.find<VendorDetailsController>();
    RemarksController remarksController = Get.find<RemarksController>();

    String subTotal =
        itemDetailsController.totalHeadersValue[itemDetailsController
                .totalHeadersValue
                .length -
            2];

    List<LineItemRequestModel>? lineItems =
        itemDetailsController.controllers
            .map(
              (element) => LineItemRequestModel(
                amount: element.amount.text.trim(),
                code: element.code.text.trim(),
                ornamentId: element.codeId,
                ornamentCode: element.code.text.trim(),
                ornamentName: element.ornament_name,
                hsnSac: element.hsn_sac.trim(),
                hsnSacType: element.hsn_sac_type.trim(),
                ornamentMetalType: element.ornament_metal_type.trim(),
                grossWeight: element.gwt.text.trim(),
                itemDescription: element.item_description.text.trim(),
                less:
                    element.less.text.trim().isEmpty
                        ? null
                        : element.less.text.trim(),
                mc:
                    element.mc.text.trim().isEmpty
                        ? null
                        : element.mc.text.trim(),
                netWeight: element.nwt.text.trim(),
                pieces: int.tryParse(element.pcs.text.trim()),
                rate: element.rate.text.trim(),
                stone:
                    element.stone.text.trim().isEmpty
                        ? null
                        : element.stone.text.trim(),
                tch:
                    element.wst_unit == "%"
                        ? (element.wst.text.trim().isEmpty
                            ? null
                            : element.wst.text.trim())
                        : null,
                va: element.wst_unit != "%" ? element.wst.text.trim() : null,
                lineStones:
                    element.stoneDetailsTableData
                        .map(
                          (stone) => LineStoneRequestModel(
                            carat:
                                stone.weightUnit == "CT"
                                    ? stone.carat_weight.text.trim().isEmpty
                                        ? null
                                        : stone.carat_weight.text.trim()
                                    : null,
                            name: stone.name.text.trim(),
                            pieces: int.tryParse(stone.pcs.text.trim()),
                            rate: stone.rate.text.trim(),
                            total: stone.total.text.trim(),
                            weight:
                                stone.weightUnit != "CT"
                                    ? stone.carat_weight.text.trim()
                                    : null,
                          ),
                        )
                        .toList(),
              ),
            )
            .toList();

    bool isPaidAmountZero =
        double.tryParse(paidAmountController.text.trim()) == 0;
    bool isBalanceEqualToNet =
        double.tryParse(balanceAmountController.text.trim()) ==
        double.tryParse(totalPrice.value);

    List<PaymentMethodDetailRequestModel> paymentMethodDetails = [];

    if (!(isPaidAmountZero && isBalanceEqualToNet)) {
      paymentMethodDetails =
          controllers.map((element) {
            String? posAccountId;
            String? purchaseReturnId; // Add this for debit notes
            String posValue = element.pos_bank.text;

            // Check if this is a debit note payment
            if (element.method.text.toLowerCase() == "debit note") {
              // For debit notes, pos_bank contains the debit note ID
              purchaseReturnId = posValue.isEmpty ? null : posValue;
              posAccountId = null; // No bank account for debit notes
            } else {
              // For other payment methods, handle as before
              if (posValue == "None" || posValue.isEmpty) {
                posAccountId = null;
              } else {
                final accountDetails = getAccountByCode(posValue);
                posAccountId = accountDetails?.id;
              }
              purchaseReturnId =
                  null; // No purchase return for regular payments
            }

            return PaymentMethodDetailRequestModel(
              amount: element.amount.text,
              date: convertStringToDateTime(element.date.text),
              method: element.method.text,
              paymentCode:
                  element.method.text.toLowerCase() == "debit note"
                      ? element
                          .pos_bank
                          .text // For debit notes, use the debit note ID as payment code
                      : element
                          .upi_utr_cn
                          .text, // For others, use the UPI/UTR field
              posAccountId: posAccountId,
              purchaseReturnId:
                  purchaseReturnId, // Add this field to your model
            );
          }).toList();
    }
    PaymentDetailRequestModel paymentDetailsModel = PaymentDetailRequestModel(
      balanceAmount: balanceAmountController.text.trim(),
      cgst: CGStValue.value,
      sgst: SGSTValue.value,
      igst: IGStValue.value,
      paidAmount:
          paidAmountController.text.trim().isEmpty
              ? null
              : paidAmountController.text.trim(),
      hallmark:
          hallMarkChargesController.text.trim().isEmpty
              ? null
              : hallMarkChargesController.text.trim(),
      subTotal: subTotal,
      tcs: tcsController.text.trim().isEmpty ? null : tcsController.text.trim(),
      tds: tdsController.text.trim().isEmpty ? null : tdsController.text.trim(),
      nett: totalPrice.value,
      paymentMethodDetails: paymentMethodDetails,
      total: totalPrice.value,
      roundOff:
          roundOffController.text.trim().isEmpty
              ? "0"
              : roundOffController.text.trim(),
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
      partyAddress = customerSearchValue.address?.first.city ?? "";
      partyCode = "";
      partyGst = customerSearchValue.gstNumber;
      partyId = customerSearchValue.id ?? '';
      partyName = customerSearchValue.name ?? "";
      partyType = "customer";
    } else {
      final VendorSearchValue vendorSearchValue =
          partyController.selectedParty.value;
      String address = "";
      if (vendorSearchValue.address?.isNotEmpty ?? false) {
        address = vendorSearchValue.address?.first.city ?? "";
      }
      partyAddress = address;
      partyCode = vendorSearchValue.code ?? "";
      partyGst = vendorSearchValue.gstNumber;
      partyId = vendorSearchValue.id ?? '';
      partyName = vendorSearchValue.name ?? "";
      partyType = "vendor";
    }
    PurchaseInvoiceRequestModel invoiceModel = PurchaseInvoiceRequestModel(
      paymentDetails: [paymentDetailsModel],
      organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
      partyAddress: partyAddress,
      partyCode: partyCode,
      partyGst: partyGst,
      partyId: partyId,
      partyInvoiceNumber:
          vendorBillDetailsController.invoiceNoController.text.trim(),
      partyName: partyName,
      partyType: partyType,
      invoiceCreateDate: convertStringToDateTime(
        vendorBillDetailsController.invoiceCreatedController.text.trim(),
        formatSent: DateFormat('dd-MM-yyyy'),
      ),
      invoiceNumber: vendorBillDetailsController.invoiceNumber.trim(),
      invoiceReceiveDate: convertStringToDateTime(
        vendorBillDetailsController.invoiceReceivedController.text.trim(),
        formatSent: DateFormat('dd-MM-yyyy'),
      ),
      lineItems: lineItems,
      remark: remarksController.purchaseRemarks.value,
      isService: false,
    );

    log("The  details are here ${jsonEncode(invoiceModel.toJson())}");
    return invoiceModel;
  }

  void updateFirstPaymentRowAmount() {
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

  void clearAllControllers({required String invoiceType}) {
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();
    itemDetailsController.clearControllers();
    VendorBillDetailsController vendorBillDetailsController =
        Get.find<VendorBillDetailsController>();
    vendorBillDetailsController.clearControllers();
    vendorBillDetailsController.fetchNextInvoiceNumber(
      invoiceType: invoiceType,
    );

    RemarksController remarksController = Get.find<RemarksController>();
    remarksController.purchaseRemarks.value = "";

    debitNotesList.clear();

    final VendorDetailsController partyDetailsController =
        Get.find<VendorDetailsController>();
    partyDetailsController.selectedParty.value = null;
    partyDetailsController.searchController.value.text = "";
  }
}
