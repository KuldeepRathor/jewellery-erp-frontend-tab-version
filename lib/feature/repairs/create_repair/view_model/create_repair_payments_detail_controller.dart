import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/model/create_repair_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view_model/create_repair_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view_model/create_repair_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view_model/create_repair_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CreateRepairPaymentDetailsController extends GetxController {
  // final PurchaseInvoiceViewmodel _purchaseInvoiceViewmodel =
  // Get.put(PurchaseInvoiceViewmodel());
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
    log("Adding row");
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
    CreateRepairItemDetailsController itemDetailsController =
        Get.find<CreateRepairItemDetailsController>();

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
    CreateRepairItemDetailsController itemDetailsController =
        Get.find<CreateRepairItemDetailsController>();

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
    log("Calculating GST values");
    CGStValue.value = "0";
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";
    clearTextController();

    CreateRepairItemDetailsController itemDetailsController =
        Get.find<CreateRepairItemDetailsController>();

    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );
    double totalCalculatedPrice = 0;
    double totalValueSoFor = 0;

    // Calculate GST values
    for (var itemDetail in itemDetailsController.controllers) {
      // Assuming each item has a GST field similar to the purchase controller
      double itemAmount = double.tryParse(itemDetail.amount.text) ?? 0;
      double gstPercentage = double.tryParse(itemDetail.gst) ?? 0;
      double gstValue = itemAmount * (gstPercentage / 100);
      totalValueSoFor += gstValue;
    }

    // For simplicity, let's split GST equally between CGST and SGST
    // You might want to add logic to determine IGST vs CGST+SGST based on your requirements
    CGStValue.value = (totalValueSoFor / 2).toStringAsFixed(2);
    SGSTValue.value = (totalValueSoFor / 2).toStringAsFixed(2);

    totalCalculatedPrice = totalValueSoFor + subTotal;
    roundOffTotalToShow.value = totalCalculatedPrice;

    totalPrice.value = totalCalculatedPrice.toStringAsFixed(2);
    balanceAmountController.text = totalCalculatedPrice.toStringAsFixed(2);
    paidAmountController.text = "0";
    roundOffController.text = "0";

    updateBalanceAmount();
    update();
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

  double? _parseDouble(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value);
  }

  Future<void> validateAndSaveRepair() async {
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
      final CreateRepairViewModel orderViewModel =
          Get.find<CreateRepairViewModel>();
      final CreateRepairItemDetailsController itemController =
          Get.find<CreateRepairItemDetailsController>();
      final CreateRepairPartyDetailsController partyController = Get.find();

      final lineItems =
          itemController.controllers.asMap().entries.map((entry) {
            // final index = entry.key;
            final item = entry.value;

            return LineItem(
              itemDescription: item.item_description.text,
              size: item.size.text,
              purity: item.purity.text,

              // netWeight: double.tryParse(item.nwt.text)?.toInt(),
              // amount: double.tryParse(item.amount.text)?.toInt(),
              // // Add estimation details if available
              // grossWeight:
              //     estimation != null ? double.tryParse(estimation.gwt.text) : null,
              // wastagePercentage: estimation?.wst_unit == "%"
              //     ? double.tryParse(estimation!.wst.text)
              //     : null,
              // makingCharge:
              //     estimation != null ? double.tryParse(estimation.mc.text) : null,
              // stoneCharge: estimation != null
              //     ? double.tryParse(estimation.stone.text)
              //     : null,
              // gstPercentage:
              //     estimation != null ? double.tryParse(estimation.gst.text) : null,
              // ratePerGm: 0,
              // // estimation != null ? double.tryParse(estimation.gst.text) : null,
              // total: double.tryParse(item.amount.text)?.toInt(),
              amount: _parseDouble(item.amount.text),
              status: "pending",
            );
          }).toList();

      // Convert to PaymentMethodDetail objects first
      final paymentMethodDetails =
          controllers
              .map(
                (controller) => PaymentMethodDetail(
                  amount: double.tryParse(controller.amount.text),
                  method: controller.method.text,
                  date: controller.date.text,
                  pos: controller.pos_bank.text,
                  paymentCode: controller.upi_utr_cn.text,
                ),
              )
              .toList();

      // Create PaymentDetail with PaymentMethodDetails
      final paymentDetails = [
        PaymentDetail(
          amount: double.tryParse(paidAmountController.text),
          balanceAmount: double.tryParse(balanceAmountController.text),
          finalAmount: double.tryParse(totalPrice.value),
          paymentMethodDetails: paymentMethodDetails,
          receivedAmount: double.tryParse(balanceAmountController.text),
        ),
      ];
      final request = CreateRepairRequest(
        commodityType: orderViewModel.selectedCommodity.value,
        bookingType: orderViewModel.selectedBooking.value,
        repairDate: orderViewModel.repairDateController.text,
        repairTakenBy: orderViewModel.selectedEmployee.value?.id.toString(),
        lineItems: lineItems,
        paymentDetails: paymentDetails,
        customerId:
            partyController.selectedParty.value is CustomerSearchValue
                ? (partyController.selectedParty.value as CustomerSearchValue)
                    .id
                    .toString()
                : null,
      );

      // ignore: unused_local_variable
      final response = await _estimationRepository.createRepair(request);

      showSuccessToast(message: 'Repair created successfully!');

      Get.back();

      final SidebarController sidebarController = Get.find<SidebarController>();
      // sidebarController.selectSubItem(1, 3);
      sidebarController.selectSubMenuItem(
        'orders_repairs',
        'orders_repairs_repair',
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
