import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/line_item_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/line_stone_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/payment_detail_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/payment_method_detail_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/purchase_invoice_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/purchase_invoice_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_service_create/view_model/service_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_service_create/view_model/service_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_service_create/view_model/service_vendor_bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ServicePaymentDetailsController extends GetxController {
  final CGStValue = "0".obs;
  final IGStValue = "0".obs;
  final SGSTValue = "0".obs;
  final balanceAmountController = TextEditingController();
  final bankList = ["SBI", "Paytm", "HDFC", "ICICI", "Yes", "IB", "CUB", "KCC"];
  final calulcatedTaxTotalToShow = 0.0.obs;
  final controllers = <PaymentDetailsTableData>[].obs;
  final currentColIndex = 0.obs;
  final currentRowIndex = 0.obs;
  final displaySubTotal = "0".obs;
  final formKey = GlobalKey<FormState>();
  final hallMarkChargesController = TextEditingController();
  final methodList = ["Cash", "Card", "NEFT/RTGS", "UPI/IMPS", "Cheque"];
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
    hallMarkChargesController.addListener(() {
      getSubTotalWithHallmarkCharges();
      calculateGstvalues();
      update();
    });
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   addRow();
  //   calculateGstvalues();
  // }

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
    controllers.add(
      PaymentDetailsTableData(
        amount: TextEditingController(),
        method: TextEditingController(text: methodList.first),
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
      //   controllers.first.amount.clear();
      // controllers.first.upi_utr_cn.clear();
      // controllers.first.method.text = methodList.first;
      // controllers.first.date.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      // controllers.first.pos_bank.text = bankList.first;
      showErrorToast(message: "Cannot remove last row");
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
    ServiceItemDetailsWidgetController itemDetailsController =
        Get.find<ServiceItemDetailsWidgetController>();

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
    ServiceItemDetailsWidgetController itemDetailsController =
        Get.find<ServiceItemDetailsWidgetController>();

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

  void getRoundOffTotal() {
    ServiceItemDetailsWidgetController itemDetailsController =
        Get.find<ServiceItemDetailsWidgetController>();

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

    // Update GST values
    Future<String> igstVal = _organizationRepository.getGstType(
      gstNumber:
          Get.find<ServicePartyDetailsController>()
              .selectedParty
              .value
              .gstNumber
              .toString(),
    );
    // ignore: unrelated_type_equality_checks
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

    // Calculate total with GST and round off
    double igst = double.tryParse(IGStValue.value) ?? 0;
    double cgst = double.tryParse(CGStValue.value) ?? 0;
    double sgst = double.tryParse(SGSTValue.value) ?? 0;
    double round = double.tryParse(roundOffController.text) ?? 0;

    double value = igst + cgst + sgst + subTotalWithHallmark + round;

    roundOffTotalToShow.value = value;
    reCalculateTaxAfterRounding(itemDetailsController);
    updateBalanceAmount();

    update();
  }

  void reCalculateTaxAfterRounding(
    ServiceItemDetailsWidgetController itemDetailsController,
  ) {
    ServicePartyDetailsController partyController =
        Get.find<ServicePartyDetailsController>();
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
    double tcs = subTotal * (valueMultiplier / 100);
    double tds = subTotal * (valueMultiplier / 100);

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
    ServiceItemDetailsWidgetController itemDetailsController =
        Get.find<ServiceItemDetailsWidgetController>();

    // Get subtotal for tax calculations
    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );

    ServicePartyDetailsController partyController =
        Get.find<ServicePartyDetailsController>();
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
    CGStValue.value = "0";
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";
    clearTextController();

    ServiceItemDetailsWidgetController itemDetailsController =
        Get.find<ServiceItemDetailsWidgetController>();
    ServicePartyDetailsController partyController =
        Get.find<ServicePartyDetailsController>();

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
    roundOffTotalToShow.value = (totalCalculatedPrice + subTotalWithHallmark);

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
      double tds = subTotalWithHallmark * (valueMultiplier / 100);
      tdsController.text = tds.toStringAsFixed(2);
      totalCalculatedPrice -= tds;
    } else if (isPartyTCS) {
      double valueMultiplier = deductionPercent;
      double tcs = subTotalWithHallmark * (valueMultiplier / 100);
      tcsController.text = tcs.toStringAsFixed(2);
      totalCalculatedPrice -= tcs;
    }

    totalCalculatedPrice += subTotalWithHallmark;

    totalPrice.value = totalCalculatedPrice.toStringAsFixed(2);
    balanceAmountController.text = totalCalculatedPrice.toStringAsFixed(2);
    updateBalanceAmount();
    paidAmountController.text = "0";
    roundOffController.text = "0";
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
    } else {
      controllers.first.amount.clear();
      controllers.first.upi_utr_cn.clear();
      controllers.first.method.text = methodList.first;
      controllers.first.date.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now());
      controllers.first.pos_bank.text = bankList.first;
      // showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  Future<void> validateAndPostPurchaseInvoice() async {
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
    PurchaseInvoiceRequestModel invoiceModel = getConvertedRequestModel();
    log("The  details are here to send ${jsonEncode(invoiceModel.toJson())}");
    try {
      await _purchaseInvoiceViewmodel.postPurchaseInvoice(
        purchaseInvoiceRequest: invoiceModel,
      );
      clearAllControllers(invoiceType: "invoice_number_service");
      showSuccessToast(message: 'Purchase Invoice added successfully !');
      Get.back();
      SidebarController sidebarController = Get.find<SidebarController>();
      // sidebarController.selectSubItem(1, 3);
      sidebarController.selectSubMenuItem('stock', 'stock_purchase');
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
    ServiceItemDetailsWidgetController itemDetailsController =
        Get.find<ServiceItemDetailsWidgetController>();
    ServiceVendorBillDetailsWidgetController vendorBillDetailsController =
        Get.find<ServiceVendorBillDetailsWidgetController>();

    ServicePartyDetailsController partyController =
        Get.find<ServicePartyDetailsController>();
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
                grossWeight: "0",
                itemDescription: element.item_description.text.trim(),
                less:
                    element.less.text.trim().isEmpty
                        ? null
                        : element.less.text.trim(),
                mc:
                    element.mc.text.trim().isEmpty
                        ? null
                        : element.mc.text.trim(),
                netWeight: "0",
                pieces: 1,
                rate: "0",
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

    List<PaymentMethodDetailRequestModel> paymentMethodDetails =
        controllers
            .map(
              (element) => PaymentMethodDetailRequestModel(
                amount: element.amount.text,
                date: convertStringToDateTime(element.date.text),
                method: element.method.text,
                paymentCode: element.upi_utr_cn.text,
                // pos: element.pos_bank.text,
              ),
            )
            .toList();
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
      isService: true,
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
    );

    log("The  details are here ${jsonEncode(invoiceModel.toJson())}");
    return invoiceModel;
  }

  void clearAllControllers({required String invoiceType}) {
    ServiceItemDetailsWidgetController itemDetailsController =
        Get.find<ServiceItemDetailsWidgetController>();
    itemDetailsController.clearControllers();
    ServiceVendorBillDetailsWidgetController vendorBillDetailsController =
        Get.find<ServiceVendorBillDetailsWidgetController>();
    vendorBillDetailsController.clearControllers();
    vendorBillDetailsController.fetchNextInvoiceNumber(
      invoiceType: invoiceType,
    );

    RemarksController remarksController = Get.find<RemarksController>();
    remarksController.purchaseRemarks.value = "";

    final ServicePartyDetailsController partyDetailsController =
        Get.find<ServicePartyDetailsController>();
    partyDetailsController.selectedParty.value = null;
    partyDetailsController.searchController.value.text = "";
  }
}
