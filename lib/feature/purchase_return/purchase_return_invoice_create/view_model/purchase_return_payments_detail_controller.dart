// ignore_for_file: library_prefixes, avoid_print

import 'dart:convert';
import 'dart:developer';
// import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/line_item_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/line_stone_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/payment_detail_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/payment_method_detail_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/purchase_invoice_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/view_model/purchase_return_bill_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_return_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/view_model/purchase_return_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/view_model/purchase_return_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/view_model/purchase_return_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class PurchaseReturnPaymentDetailsController extends GetxController {
  final PurchaseReturnInvoiceViewmodel _purchaseReturnInvoiceViewmodel =
      Get.put(PurchaseReturnInvoiceViewmodel());

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
  // final methodList = ["Cheque", "Card", "Cash"];
  final bankList = ["SBI", "Paytm", "HDFC", "ICICI", "Yes", "IB", "CUB", "KCC"];

  final roundOffController = TextEditingController();
  final tcsController = TextEditingController();
  final tdsController = TextEditingController();
  final paidAmountController = TextEditingController();
  final balanceAmountController = TextEditingController();
  final hallMarkChargesController = TextEditingController();

  final displaySubTotal = "0".obs;

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

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

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
    // hallMarkChargesController.addListener(() {
    //   getSubTotalWithHallmarkCharges();
    //   calculateGstvalues();
    //   update();
    // });
  }

  // @override
  // void onClose() {
  //   hallMarkChargesController.dispose();
  //   super.onClose();
  // }

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

  void clearTextController() {
    hallMarkChargesController.text = '';
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
                  : '',
        ),
        date: TextEditingController(),
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
      controllers[rowIndex].date.text = DateFormat('dd/MM/yyyy').format(picked);
      controllers.refresh();
    }
  }

  final CGStValue = "0".obs;
  final SGSTValue = "0".obs;
  final IGStValue = "0".obs;
  final totalPrice = "0".obs;

  final roundOffTotalToShow = 0.0.obs;
  final calulcatedTaxTotalToShow = 0.0.obs;

  double getSubTotalWithHallmarkCharges() {
    PurchaseReturnItemDetailsController itemDetailsController =
        Get.find<PurchaseReturnItemDetailsController>();

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

  String getTotalGstValue() {
    PurchaseReturnItemDetailsController itemDetailsController =
        Get.find<PurchaseReturnItemDetailsController>();

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
    PurchaseReturnItemDetailsController itemDetailsController =
        Get.find<PurchaseReturnItemDetailsController>();

    double subTotalWithHallmark = getSubTotalWithHallmarkCharges();
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
    PurchaseReturnItemDetailsController itemDetailsController,
  ) {
    PurchaseReturnPartyDetailsController partyController =
        Get.find<PurchaseReturnPartyDetailsController>();
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
    PurchaseReturnItemDetailsController itemDetailsController =
        Get.find<PurchaseReturnItemDetailsController>();

    // Get subtotal for tax calculations
    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );

    PurchaseReturnPartyDetailsController partyController =
        Get.find<PurchaseReturnPartyDetailsController>();
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
    double value = total - paid;
    balanceAmountController.text = value.toStringAsFixed(2);
  }

  Future<void> calculateGstvalues() async {
    print("Calculating values");
    CGStValue.value = "0";
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";

    // Clear specific controllers except hallMarkChargesController
    tcsController.text = '';
    tdsController.text = '';
    paidAmountController.text = '';
    balanceAmountController.text = '';

    PurchaseReturnItemDetailsController itemDetailsController =
        Get.find<PurchaseReturnItemDetailsController>();
    PurchaseReturnPartyDetailsController partyController =
        Get.find<PurchaseReturnPartyDetailsController>();

    // Get initial subtotal before hallmark charges
    double initialSubTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );

    // Add hallmark charges to get final subtotal
    double hallmarkCharges =
        double.tryParse(hallMarkChargesController.text) ?? 0;
    double subTotalWithHallmark = initialSubTotal + hallmarkCharges;
    displaySubTotal.value = subTotalWithHallmark.toStringAsFixed(2);

    double totalCalculatedPrice = 0;
    double totalValueSoFor = 0;
    // String getPartyGSTNumber(dynamic party) {
    //   if (party is CustomerSearchValue || party is VendorSearchValue) {
    //     // Check if address list exists and is not empty
    //     if (party.address != null && party.address!.isNotEmpty) {
    //       // Get the first address and access its state property
    //       return party.address!.first.state?.toString() ?? "";
    //     }
    //     // If no addresses are available
    //     return "";
    //   }
    //   return "";
    // }

    String igstVal = await _organizationRepository.getGstType(
      gstNumber: partyController.selectedParty.value.gstNumber.toString(),
    );
    // state_name: getPartyGSTNumber(
    //     partyController.selectedParty.value.gstNumber.toString()));`

    bool isIGST = igstVal == "igst";
    log("The GST type is $isIGST");

    // Calculate GST values on each line item
    for (var itemDetail in itemDetailsController.controllers.toList()) {
      double itemAmount = double.parse(itemDetail.amount.text);
      double gstRate = double.parse(itemDetail.gst) / 100;

      // Calculate GST amount for this item
      double gstAmount = itemAmount * gstRate;
      totalValueSoFor += gstAmount;
    }

    // Add hallmark charges GST
    double hallmarkGST =
        hallmarkCharges * 0.03; // Assuming 3% GST on hallmark charges
    totalValueSoFor += hallmarkGST;

    // Assign GST values based on type
    if (isIGST) {
      IGStValue.value = totalValueSoFor.toStringAsFixed(2);
    } else {
      CGStValue.value = (totalValueSoFor / 2).toStringAsFixed(2);
      SGSTValue.value = (totalValueSoFor / 2).toStringAsFixed(2);
    }

    totalCalculatedPrice = totalValueSoFor;
    roundOffTotalToShow.value = (totalCalculatedPrice + subTotalWithHallmark);

    // Calculate TDS/TCS
    bool isPartyTDS = false;
    bool isPartyTCS = false;
    double deductionPercent = 0;

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

    // Calculate TCS and TDS based on subtotal including hallmark
    if (isPartyTDS) {
      double tds =
          (subTotalWithHallmark * (deductionPercent / 100)).roundToDouble();
      tdsController.text = tds.toStringAsFixed(2);
      totalCalculatedPrice -= tds;
    } else if (isPartyTCS) {
      double tcs =
          (subTotalWithHallmark * (deductionPercent / 100)).roundToDouble();
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
      showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  Future<void> validateAndPostPurchaseReturnInvoice() async {
    // if (formKey.currentState!.validate() == false) {
    //   return;
    // }
    // double total = 0;
    // for (var element in controllers) {
    //   total += double.tryParse(element.amount.text) ?? 0;
    // }
    // double paid = double.tryParse(paidAmountController.text) ?? 0;
    // if (total != paid) {
    //   showErrorToast(
    //     message: "Paid amount not met!",
    //     alignment: Alignment.center,
    //   );
    //   return;
    // }

    // Convert invoice model to return model
    PurchaseInvoiceRequestModel invoiceModel = getConvertedRequestModel();
    PurchaseReturnRequestModel returnModel = convertToReturnModel(invoiceModel);

    log("Return model details: ${jsonEncode(returnModel.toJson())}");

    try {
      await _purchaseReturnInvoiceViewmodel.postPurchaseReturnInvoice(
        purchaseReturnRequestModel: returnModel,
      );
      clearAllControllers(invoiceType: "return_invoice_number_vendor");
      showSuccessToast(message: 'Purchase Return added successfully!');
      Get.back();
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.popBackSelectedWidget();
    } catch (e, s) {
      log("Error in validateAndPostPurchaseReturnInvoice: $e \n $s");
      showErrorToast(
        message:
            _purchaseReturnInvoiceViewmodel
                .postPurchaseReturnInvoiceResponse
                .value
                .message ??
            "Something went wrong",
      );
    }
  }

  final PurchaseReturnPartyDetailsController partyDetailsController =
      Get.find<PurchaseReturnPartyDetailsController>();

  PurchaseReturnRequestModel convertToReturnModel(
    PurchaseInvoiceRequestModel invoiceModel,
  ) {
    // Convert payment details
    List<PaymentDetail> paymentDetails = [];
    if (invoiceModel.paymentDetails != null &&
        invoiceModel.paymentDetails!.isNotEmpty) {
      PaymentDetailRequestModel paymentDetail =
          invoiceModel.paymentDetails!.first;
      paymentDetails.add(
        PaymentDetail(
          //    hallmark: hallMarkChargesController.text.trim().isEmpty
          // ? null
          // : hallMarkChargesController.text.trim(),
          cgst: paymentDetail.cgst,
          nett: paymentDetail.nett,
          roundOff: paymentDetail.roundOff,
          sgst: paymentDetail.sgst,
          subTotal: paymentDetail.subTotal,
          tcs: paymentDetail.tcs,
          tds: paymentDetail.tds,
          total: paymentDetail.total,
        ),
      );
    }

    // Convert line items
    List<PurchaseReturnRequestLineItem> lineItems =
        invoiceModel.lineItems?.map((item) {
          // Convert line stones
          List<PurchaseReturnRequestLineStone> stones =
              item.lineStones?.map((stone) {
                return PurchaseReturnRequestLineStone(
                  carat: stone.carat,
                  name: stone.name,
                  organizationId: invoiceModel.organizationId,
                  pieces: stone.pieces,
                  rate: stone.rate,
                  total: stone.total,
                  weight: stone.weight,
                );
              }).toList() ??
              [];

          return PurchaseReturnRequestLineItem(
            hsnSac: item.hsnSac,
            hsnSacType: item.hsnSacType,
            ornamentMetalType: item.ornamentMetalType,
            amount: item.amount,
            code: item.code,
            ornamentId: item.ornamentId,
            ornamentCode: item.ornamentCode,
            ornamentName: item.ornamentName,
            grossWeight: item.grossWeight,
            itemDescription: item.itemDescription,
            less: item.less,
            lineStones: stones,
            mc: item.mc,
            netWeight: item.netWeight,
            organizationId: invoiceModel.organizationId,
            pieces: item.pieces,
            rate: item.rate,
            stone: item.stone,
            tch: (item.tch == null || item.tch == "") ? null : item.tch,
            va: (item.va == null || item.va == "") ? null : item.va,
          );
        }).toList() ??
        [];

    // Create return model
    final billDetailsController =
        Get.find<PurchaseReturnBillDetailsController>();
    return PurchaseReturnRequestModel(
      lineItems: lineItems,
      isService: false,
      organizationId: invoiceModel.organizationId,
      partyAddress: invoiceModel.partyAddress,
      partyCode: invoiceModel.partyCode,
      partyGst: invoiceModel.partyGst,
      partyId: invoiceModel.partyId,
      partyInvoiceNumber: invoiceModel.partyInvoiceNumber,
      partyName: invoiceModel.partyName,
      partyType: invoiceModel.partyType,
      paymentDetails: paymentDetails,
      remark: invoiceModel.remark,
      returnCreateDate: invoiceModel.invoiceCreateDate,
      returnReceiveDate: invoiceModel.invoiceReceiveDate,
      purchaseRecordId: partyDetailsController.selectedPurchaseRecordId,
      voucherType: billDetailsController.selectedSequence.value?.type,
      voucherSeriesId: billDetailsController.selectedSequence.value?.id,
    );
  }

  PurchaseInvoiceRequestModel getConvertedRequestModel() {
    PurchaseReturnItemDetailsController itemDetailsController =
        Get.find<PurchaseReturnItemDetailsController>();
    PurchaseReturnBillDetailsController vendorBillDetailsController =
        Get.find<PurchaseReturnBillDetailsController>();

    PurchaseReturnPartyDetailsController partyController =
        Get.find<PurchaseReturnPartyDetailsController>();
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
      paidAmount: "0",
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
      invoiceNumber: vendorBillDetailsController.salesNumber.value.trim(),
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
    PurchaseReturnItemDetailsController itemDetailsController =
        Get.find<PurchaseReturnItemDetailsController>();
    itemDetailsController.clearControllers();
    PurchaseReturnBillDetailsController billDetailsController =
        Get.find<PurchaseReturnBillDetailsController>();
    billDetailsController.clearControllers();

    RemarksController remarksController = Get.find<RemarksController>();
    remarksController.purchaseRemarks.value = "";

    final PurchaseReturnPartyDetailsController partyDetailsController =
        Get.find<PurchaseReturnPartyDetailsController>();
    partyDetailsController.selectedParty.value = null;
    partyDetailsController.searchController.value.text = "";
  }
}
