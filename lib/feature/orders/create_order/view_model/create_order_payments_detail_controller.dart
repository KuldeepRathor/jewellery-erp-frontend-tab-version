// ignore_for_file: library_prefixes, avoid_print

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/create_order_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CreateOrderPaymentDetailsController extends GetxController {
  final EstimationRepository _estimationRepository = EstimationRepository();
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
  final methodList = ["Cheque", "Card", "Cash"];
  final bankList = ["SBI", "Paytm", "HDFC", "ICICI", "Yes", "IB", "CUB", "KCC"];

  final roundOffController = TextEditingController();
  final tcsController = TextEditingController();
  final tdsController = TextEditingController();
  final paidAmountController = TextEditingController();
  final balanceAmountController = TextEditingController();

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();
  final RxList<PaymentMethodResponse> paymentMethods =
      <PaymentMethodResponse>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  final FocusNode paidAmountFocusNode = FocusNode();

  @override
  void dispose() {
    paidAmountFocusNode.dispose();
    super.dispose();
  }

  double getOldGoldTotal() {
    final CreateOrderOldGoldController oldGoldController =
        Get.find<CreateOrderOldGoldController>();

    if (oldGoldController.totalHeadersValue.length > 8) {
      return double.tryParse(oldGoldController.totalHeadersValue[8]) ?? 0;
    }
    return 0;
  }

  Future<void> fetchPaymentMethods() async {
    try {
      isLoading.value = true;
      final response = await _purchaseInvoiceRepository.getPaymentMethods();
      paymentMethods.clear();
      paymentMethods.addAll(response);

      // Set default method for existing controllers
      if (controllers.isNotEmpty) {
        controllers[0].method.text =
            paymentMethods.isNotEmpty
                ? paymentMethods.first.method ?? ''
                : methodList.first;
      }
    } catch (e) {
      // Fallback to local list if API fails
      showErrorToast(message: 'Failed to fetch payment methods');

      // If API call fails, initialize with local method list
      if (controllers.isNotEmpty && controllers[0].method.text.isEmpty) {
        controllers[0].method.text = methodList.first;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void initializeRow() {
    controllers.clear();
    addRow();
  }

  void clearTextController() {
    roundOffController.text = '';
    tcsController.text = '';
    tdsController.text = '';
    paidAmountController.text = '';
    balanceAmountController.text = '';
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
                  : methodList.first,
        ),
        date: TextEditingController(
          text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
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
      // Auto-move to next focus after selection
      moveNextFocus();
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
      log("Setting date $picked");
      controllers[rowIndex].date.text = DateFormat('yyyy-MM-dd').format(picked);
      controllers.refresh();
    }
  }

  final CGStValue = "0".obs;
  final SGSTValue = "0".obs;
  final IGStValue = "0".obs;
  final totalPrice = "0".obs;

  final roundOffTotalToShow = 0.0.obs;
  final calulcatedTaxTotalToShow = 0.0.obs;

  void calculateBalanceAmount() {
    updateBalanceAmount();
  }

  String getTotalGstValue() {
    CreateOrderItemDetailsController itemDetailsController =
        Get.find<CreateOrderItemDetailsController>();

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

  void getRoundOffTotal() {
    CreateOrderItemDetailsController itemDetailsController =
        Get.find<CreateOrderItemDetailsController>();

    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );
    double igst = double.tryParse(IGStValue.value) ?? 0;
    double cgst = double.tryParse(CGStValue.value) ?? 0;
    double sgst = double.tryParse(SGSTValue.value) ?? 0;

    double round = double.tryParse(roundOffController.text) ?? 0;

    double value = igst + cgst + sgst + subTotal + round;

    roundOffTotalToShow.value = value;
    calculateTaxChange();
    // Update balance amount whenever roundoff changes
    updateBalanceAmount();
  }

  Future<void> calculateGstvalues() async {
    print("Calculating GST values");
    CGStValue.value = "0";
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";
    clearTextController();

    CreateOrderItemDetailsController itemDetailsController =
        Get.find<CreateOrderItemDetailsController>();

    double totalGSTAmount = 0;
    double subTotalWithoutGST = 0;

    // Get old gold total
    double oldGoldTotal = getOldGoldTotal();

    // Calculate GST per item and sum them up
    for (var itemDetail in itemDetailsController.controllers) {
      double itemAmount = double.tryParse(itemDetail.amount.text) ?? 0;
      double gstPercentage = double.tryParse(itemDetail.gst.text) ?? 0;

      double baseAmount = itemAmount / (1 + (gstPercentage / 100));
      double gstAmount = itemAmount - baseAmount;

      totalGSTAmount += gstAmount;
      subTotalWithoutGST += baseAmount;
    }

    // Split GST equally between CGST and SGST
    CGStValue.value = (totalGSTAmount / 2).toStringAsFixed(2);
    SGSTValue.value = (totalGSTAmount / 2).toStringAsFixed(2);

    // Calculate total after GST but before old gold deduction
    double totalBeforeOldGold = subTotalWithoutGST + totalGSTAmount;

    // Deduct old gold amount
    double totalAfterOldGold = totalBeforeOldGold - oldGoldTotal;

    roundOffTotalToShow.value = totalAfterOldGold;
    totalPrice.value = totalAfterOldGold.toStringAsFixed(2);
    balanceAmountController.text = totalAfterOldGold.toStringAsFixed(2);
    paidAmountController.text = "0";
    roundOffController.text = "0";

    updateBalanceAmount();
    update();
  }

  String getTotalBeforeOldGold() {
    CreateOrderItemDetailsController itemDetailsController =
        Get.find<CreateOrderItemDetailsController>();

    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );
    double igst = double.tryParse(IGStValue.value) ?? 0;
    double cgst = double.tryParse(CGStValue.value) ?? 0;
    double sgst = double.tryParse(SGSTValue.value) ?? 0;

    double totalBeforeOldGold = subTotal + igst + cgst + sgst;
    return totalBeforeOldGold.toStringAsFixed(2);
  }

  String getSubTotalWithoutGST() {
    CreateOrderItemDetailsController itemDetailsController =
        Get.find<CreateOrderItemDetailsController>();

    double subTotalWithoutGST = 0;

    for (var itemDetail in itemDetailsController.controllers) {
      double itemAmount = double.tryParse(itemDetail.amount.text) ?? 0;
      double gstPercentage = double.tryParse(itemDetail.gst.text) ?? 0;

      // Calculate the base amount (before GST) from the total amount
      double baseAmount = itemAmount / (1 + (gstPercentage / 100));
      subTotalWithoutGST += baseAmount;
    }

    return subTotalWithoutGST.toStringAsFixed(2);
  }

  void calculateTaxChange() {
    double value = roundOffTotalToShow.value;

    if (tdsController.text.isNotEmpty) {
      value -= double.tryParse(tdsController.text) ?? 0;
    }
    if (tcsController.text.isNotEmpty) {
      value -= double.tryParse(tcsController.text) ?? 0;
    }

    totalPrice.value = value.toStringAsFixed(2);
    updateBalanceAmount();
  }

  void updateBalanceAmount() {
    double paid = double.tryParse(paidAmountController.text) ?? 0;
    double total = double.tryParse(totalPrice.value) ?? 0;
    double value = total - paid;
    balanceAmountController.text = value.toStringAsFixed(2);
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
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
      // updateTotals();
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

  Future<void> validateAndSaveOrder() async {
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
        message: "Paid amount does not match total amount!",
        alignment: Alignment.center,
      );
      return;
    }

    try {
      final CreateOrderViewModel orderViewModel =
          Get.find<CreateOrderViewModel>();
      final CreateOrderItemDetailsController itemController =
          Get.find<CreateOrderItemDetailsController>();

      final CreateOrderPartyDetailsController partyController = Get.find();
      final CreateOrderOldGoldController oldGoldController =
          Get.find<CreateOrderOldGoldController>();

      final lineItems =
          itemController.controllers.asMap().entries.map((entry) {
            final item = entry.value;

            return CreateOrderLineItem(
              itemDescription: item.item_description.text,
              size: item.size.text,
              purity: item.purity.text,
              netWeight: item.nwt.text,
              amount: (item.amount.text),
              // Add estimation details if available
              grossWeight: (item.nwt.text),

              wastage: (item.va.text),
              wastageType: item.wastageType ?? "%",
              makingChargeType: item.makingChargesType ?? "pcs",
              makingCharge: (item.mc.text),
              stoneCharge: (item.stone.text),
              gstPercentage: (item.gst.text),
              ratePerGm: (item.rate.text == "-") ? "0" : (item.rate.text),
              fixedRate: (item.rate.text == "-") ? "0" : (item.rate.text),
              total: (item.amount.text),
              status: "pending",
            );
          }).toList();

      final oldGolds =
          oldGoldController.controllers
              .where(
                (e) =>
                    e.total_amount.text.isNotEmpty &&
                    e.total_amount.text != "0",
              )
              .map(
                (element) => CreateOrderOldGold(
                  code: element.code.text,
                  description: element.description.text,
                  pieces: int.tryParse(element.pcs.text),
                  grossWeight: element.gross_wtt.text,
                  netWeight: element.net_wtt.text,
                  less: element.less.text,
                  purityType: element.purity.text,
                  ornamentId: element.ornamentId,
                  rate: element.rate.text,
                  amount: element.amount.text,
                  roundOff: element.round_off.text,
                  total: element.total_amount.text,
                  isReceived: false,
                  isCompleted: false,
                ),
              )
              .toList();

      // Convert to PaymentMethodDetail objects first
      final paymentMethodDetails =
          controllers
              .map(
                (controller) => PaymentMethodDetail(
                  amount: (controller.amount.text),
                  method: controller.method.text,
                  date: controller.date.text,
                  pos: controller.pos_bank.text,
                  paymentCode: controller.upi_utr_cn.text,
                ),
              )
              .toList();

      // Calculate GST amount
      double gstAmount =
          (double.tryParse(CGStValue.value) ?? 0) +
          (double.tryParse(SGSTValue.value) ?? 0) +
          (double.tryParse(IGStValue.value) ?? 0);

      // Create PaymentDetail with PaymentMethodDetails
      final paymentDetails = [
        CreateOrderPaymentDetail(
          amount: (totalPrice.value),
          gst: gstAmount.toString(),
          balanceAmount: (balanceAmountController.text),
          finalAmount: (totalPrice.value),
          paymentMethodDetails: paymentMethodDetails,
          receivedAmount: (paidAmountController.text),
          remainingAmount:
              (balanceAmountController.text), // Same as balance for now
        ),
      ];

      final request = CreateOrderRequest(
        commodityType: orderViewModel.selectedCommodity.value,
        // orderNumber: orderViewModel
        //     .invoiceNumber.value, // Use the generated order number
        bookingType:
            orderViewModel.RateFixMode.value ? "Rate Fix" : "Rate Unfix",
        orderDate: orderViewModel.orderDateController.text,
        orderTakenBy: orderViewModel.selectedEmployee.value?.id.toString(),
        remarks:
            orderViewModel.notesController.text.isNotEmpty
                ? orderViewModel.notesController.text
                : null,
        lineItems: lineItems,
        paymentDetails: paymentDetails,
        customerId:
            partyController.selectedParty.value is CustomerSearchValue
                ? (partyController.selectedParty.value as CustomerSearchValue)
                    .id
                    .toString()
                : null,
        oldGolds: oldGolds.isNotEmpty ? oldGolds : null,
      );

      // Log the request for debugging
      log("Order Request: ${request.toRawJson()}");

      final response = await _estimationRepository.createOrder(request);
      log(response.toString());
      showSuccessToast(message: 'Order created successfully!');
      orderViewModel.clearAllFields();

      Get.back();

      final SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.selectSubMenuItem(
        'orders_repairs',
        'orders_repairs_order',
      );
    } catch (e, s) {
      log("Error creating order: $e\n$s");
      showErrorToast(message: "Failed to create order: ${e.toString()}");
    }
  }

  void clearAllControllers({required String invoiceType}) {
    final PartyDetailsController partyDetailsController =
        Get.find<PartyDetailsController>();
    partyDetailsController.selectedParty.value = null;
    partyDetailsController.searchController.value.text = "";
  }
}
