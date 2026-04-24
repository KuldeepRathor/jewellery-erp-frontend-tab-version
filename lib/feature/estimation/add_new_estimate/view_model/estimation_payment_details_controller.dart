// ignore_for_file: library_prefixes, avoid_print, unused_local_variable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_jewellery_plan_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

import 'advance_booking/advance_booking_controller.dart';
import 'estimation_item_details_controller.dart';
import 'estimation_search_party_controller.dart';
import 'estimation_view_model.dart';
import 'jewellery_plan/jewellery_plan_controller.dart';
import 'old_gold/old_gold_controller.dart';
import 'orders/add_orders_dialog_controller.dart';

class EstimationPaymentDetailsController extends GetxController {
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();

  final paymentHeaders = [
    'Sn',
    'Amount (₹)',
    'Method',
    'Date',
    'POS/Bank',
    'UPI/UTR/Cn.',
    '',
  ];
  final paymentColumnWidths = [0.1, 0.28, 0.28, 0.28, 0.28, 0.28, 0.2];
  final controllers = <PaymentDetailsTableData>[].obs;
  // final methodList = [
  //   'Cash',
  //   'Bank Transfer',
  //   'Credit Card',
  // ];
  final bankList = [
    "None",
    "SBI",
    "Paytm",
    "HDFC",
    "ICICI",
    "Yes",
    "IB",
    "CUB",
    "KCC",
  ];

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
  }

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    fetchPaymentMethods();
  }

  void initializeRow() {
    controllers.clear();
    addRow();
    currentRowIndex.value = 0;
    currentColIndex.value = 0;
  }

  void clearTextController() {
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
    controllers.add(
      PaymentDetailsTableData(
        amount: TextEditingController(),
        method: TextEditingController(
          text:
              paymentMethods.isNotEmpty
                  ? paymentMethods.first.method ?? ''
                  : '',
        ),
        date: TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ),
        pos_bank: TextEditingController(text: bankList.first),
        upi_utr_cn: TextEditingController(),
      ),
    );
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
    } else {
      // Get.snackbar(
      //   'Cannot Remove',
      //   'Cannot remove the last row.',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      showErrorToast(message: "Cannot remove the last row.");
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
      if (value == "Cash") {
        controllers[rowIndex].pos_bank.text = "None";
      }
      controllers.refresh();
    }
  }

  void setSelectedBank(String? value, int rowIndex) {
    if (value != null) {
      controllers[rowIndex].pos_bank.text = value;
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
        purchaseAmountValue -
        advanceAmountValue -
        roundOffValue +
        bankChargesAmountValue;
    if (price < 0) {
      showErrorToast(message: "Final Amount cannot be negative");
    }
    totalPrice.value = price.toStringAsFixed(2);

    calculateBalanceAmount();
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
    final itemDetailsController = Get.find<EstimationItemDetailsController>();
    final partyController = Get.find<EstimationSearchPartyController>();
    final oldGoldController = Get.find<OldGoldController>();
    final salesAdvanceBookingController = Get.find<AdvanceBookingController>();
    final salesJewelleryPlanController = Get.find<JewelleryPlanController>();
    final AddOrdersDialogController salesAddOrdersDialogController =
        Get.find<AddOrdersDialogController>();

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
    String gstNumber = _getPartyGSTNumber(partyController.selectedParty.value);
    String igstVal = await _organizationRepository.getGstType(
      gstNumber: gstNumber,
    );
    bool isIGST = igstVal == "igst";

    // Step 5: Calculate sales amount
    salesAmount.value = subTotal - schemeDisct - rateDisct - additionalLess;

    // Step 6: Calculate total GST per item
    double totalGSTTaxPerItem = _calculateTotalGSTTax(
      itemDetailsController.controllers.toList(),
    );

    // Step 7: Set GST values based on type
    _setGSTValues(totalGSTTaxPerItem, isIGST);
    gstNet.value = totalGSTTaxPerItem + salesAmount.value;

    // Step 8: Calculate tax deductions (TDS/TCS)
    double taxDeductionAmount = _calculateTaxDeduction(
      partyController.selectedParty.value,
      salesAmount.value,
    );
    taxDeductionNet.value = (gstNet.value - taxDeductionAmount).roundToDouble();

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

  // Helper methods to make the main function more readable
  double _getValueFromItemTotalHeaders(
    EstimationItemDetailsController controller,
    int index,
  ) {
    return double.tryParse(
          controller.totalHeadersValue[controller.totalHeadersValue.length +
              index],
        ) ??
        0;
  }

  double _getValueFromOldGoldTotalHeaders(
    OldGoldController controller,
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
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";
  }

  String _getPartyGSTNumber(dynamic party) {
    if (party is CustomerSearchValue || party is VendorSearchValue) {
      return party.gstNumber.toString();
    }
    return "";
  }

  double _calculateTotalGSTTax(
    List<EstimationItemDetailsTableData> controllers,
  ) {
    double total = 0;
    for (var itemDetail in controllers) {
      double salesAmount = double.parse(itemDetail.salesAmount);
      double gstRate =
          double.parse(
            itemDetail.itemResponse?.designLineItem?.ornament?.gst ?? "0",
          ) /
          100;
      total += salesAmount * gstRate;
    }
    return total;
  }

  void _setGSTValues(double totalGSTTaxPerItem, bool isIGST) {
    if (isIGST) {
      IGStValue.value = totalGSTTaxPerItem.toStringAsFixed(2);
    } else {
      double halfGST = totalGSTTaxPerItem / 2;
      CGStValue.value = halfGST.toStringAsFixed(2);
      SGSTValue.value = halfGST.toStringAsFixed(2);
    }
  }

  double _calculateTaxDeduction(dynamic party, double salesAmount) {
    if (party is! CustomerSearchValue && party is! VendorSearchValue) {
      return 0;
    }

    String? deductionType = party.deductionType;
    double deductionPercent =
        double.tryParse(party.deductionPercent ?? "0") ?? 0;
    double taxAmount = (salesAmount * (deductionPercent / 100)).roundToDouble();

    if (deductionType == "TDS") {
      tdsController.text = taxAmount.toStringAsFixed(2);
      return taxAmount;
    } else if (deductionType == "TCS") {
      tcsController.text = taxAmount.toStringAsFixed(2);
      return taxAmount;
    }
    return 0;
  }

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
    paidAmountController.text = "0";
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
    balanceAmountController.text = totalPrice.value;
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
    EstimationViewModel estimationViewModel = Get.find<EstimationViewModel>();
    controllers.removeWhere(
      (element) => element.amount.text.isEmpty || element.amount.text == "0",
    );
    // await Future.delayed(const Duration(milliseconds: 100));
    await estimationViewModel.validateAndSubmitEstimateRecord();
    Get.back();
  }

  clearControllers() {
    additional_less.value = 0.0;
    clearTextController();
  }
}
