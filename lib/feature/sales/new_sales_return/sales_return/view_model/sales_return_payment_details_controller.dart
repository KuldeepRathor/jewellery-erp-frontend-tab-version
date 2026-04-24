// ignore_for_file: library_prefixes, avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/models/post_sales_return_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

import '../../../../purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import '../../../new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';

class SalesReturnPaymentDetailsController extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final SalesReturnViewmodel _createSalesViewModel =
      Get.find<SalesReturnViewmodel>();
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
  final methodList = ['Cash', 'Bank Transfer', 'Credit Card'];
  final bankList = ["SBI", "Paytm", "HDFC", "ICICI", "Yes", "IB", "CUB", "KCC"];

  final roundOffController = TextEditingController();
  final tcsController = TextEditingController();
  final tdsController = TextEditingController();
  final paidAmountController = TextEditingController();
  final balanceAmountController = TextEditingController();

  final purchaseAmountController = TextEditingController();
  final advanceAmountController = TextEditingController();
  final bankChargesAmountController = TextEditingController();

  final jewellerDiscount = TextEditingController();

  final schemeDiscountController = TextEditingController(text: "0");
  final rateDiscountController = TextEditingController(text: "0");
  final discountController = TextEditingController(text: "0");

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  final _calculationDebouncer = CustomDebouncer(milliseconds: 500);
  final _roundOffDebouncer = CustomDebouncer(milliseconds: 500);

  // Update the discount text field handlers

  void calculateGstvaluesWithDebouncer() {
    _calculationDebouncer.run(() {
      calculateGstvalues();
    });
  }

  // Update round off related handlers
  void reCalculateAfterRoundOffWithDebouncer() {
    _roundOffDebouncer.run(() {
      reCalculateAfterRoundOff();
    });
  }

  // // Update tax related handlers
  // void onTcsChanged(String value) {
  //   _taxDebouncer.call(() {
  //     calculateTaxChange();
  //   });
  // }

  // void onTdsChanged(String value) {
  //   _taxDebouncer.call(() {
  //     calculateTaxChange();
  //   });
  // }

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
        method: TextEditingController(text: methodList.first),
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

  final salesAmount = 0.0.obs;
  double schemeDisct = 0;
  double rateDisct = 0;
  double discount = 0;
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
    print("Calculating values");

    clearTextController();
    SalesReturnItemDetailsController itemDetailsController =
        Get.find<SalesReturnItemDetailsController>();
    SalesReturnSearchPartyController partyController =
        Get.find<SalesReturnSearchPartyController>();

    // SalesOldGoldController oldGoldController =
    //     Get.find<SalesOldGoldController>();
    // SalesAdvanceBookingController salesAdvanceBookingController =
    //     Get.find<SalesAdvanceBookingController>();
    // SalesJewelleryPlanController salesJewelleryPlanController =
    //     Get.find<SalesJewelleryPlanController>();

    // final costDiscount = itemDetailsController
    //     .totalHeadersValue[itemDetailsController.totalHeadersValue.length - 4];
    // final oldGoldDiscount = oldGoldController
    //     .totalHeadersValue[oldGoldController.totalHeadersValue.length - 2];
    // final jewelleryPlanDiscount =
    //     salesJewelleryPlanController.redeemableAmount.value;

    // final advanceBookingDiscount = salesAdvanceBookingController
    //         .selectedAdvanceBookingDetails.value?.cost ??
    //     0;
    salesAmount.value = 0;
    schemeDisct = double.tryParse(schemeDiscountController.text) ?? 0;
    rateDisct = double.tryParse(rateDiscountController.text) ?? 0;
    discount = double.tryParse(discountController.text) ?? 0;

    gstNet.value = 0;
    taxDeductionNet.value = 0;
    CGStValue.value = "0";
    SGSTValue.value = "0";
    IGStValue.value = "0";
    totalPrice.value = "0";

    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          3],
    );
    // double totalCalculatedPrice = 0;
    double totalGSTTaxPerItem = 0;
    Math.Random random = Math.Random();

    String igstVal = await _organizationRepository.getGstType(
      gstNumber: partyController.selectedParty.value.gstNumber.toString(),
    );

    bool randomIGST = igstVal == "igst";
    log("The random gst value is $randomIGST");
    salesAmount.value = subTotal - schemeDisct - rateDisct - discount;
    // Calculate GST values
    // for (var itemDetail in itemDetailsController.controllers
    //     .where(
    //       (element) => element.isSelected,
    //     )
    //     .toList()) {
    //   double val = double.parse(itemDetail.salesAmount.text) *
    //       (double.parse(itemDetail.gst) / 100);
    //   log("MULTIPLYING : ${itemDetail.salesAmount} * ${(double.parse(itemDetail.gst) / 100)}");
    //   totalGSTTaxPerItem = totalGSTTaxPerItem + val;
    // }
    for (var itemDetail
        in itemDetailsController.controllers
            .where((element) => element.isSelected)
            .toList()) {
      double itemSalesAmount = double.parse(itemDetail.salesAmount.text);
      double gstRate = double.parse(itemDetail.gst) / 100;

      // Apply ceiling to EACH item's GST (matching sales behavior)
      double itemGst = (itemSalesAmount * gstRate).ceil().toDouble();
      totalGSTTaxPerItem += itemGst;

      log(
        "Item: ${itemDetail.code.text}, Sales: $itemSalesAmount, GST Rate: ${gstRate * 100}%, Item GST: $itemGst",
      );
    }
    log(
      "Total GST (with ceiling per item): $totalGSTTaxPerItem, Is IGST: $randomIGST",
    );

    log("Random IGST $randomIGST");
    // Set GST values
    if (randomIGST) {
      log("inside Random IGST $randomIGST");
      IGStValue.value = totalGSTTaxPerItem.toStringAsFixed(2);
      CGStValue.value = "0";
      SGSTValue.value = "0";
    } else {
      log("outside Random IGST $randomIGST");
      CGStValue.value = (totalGSTTaxPerItem / 2).toStringAsFixed(2);
      SGSTValue.value = (totalGSTTaxPerItem / 2).toStringAsFixed(2);
      IGStValue.value = "0";
    }

    gstNet.value = (totalGSTTaxPerItem + salesAmount.value);

    bool isPartyTDS;
    bool isPartyTCS;
    double deductionPercent;
    double taxDeductionAmount = 0;

    if (partyController.selectedParty.value is CustomerSearchValue) {
      final CustomerSearchValue customerSearchValue =
          partyController.selectedParty.value;
      isPartyTDS = customerSearchValue.deductionType == "TDS";
      isPartyTCS = customerSearchValue.deductionType == "TCS";
      deductionPercent =
          double.tryParse(customerSearchValue.deductionPercent ?? "null") ?? 0;
    } else {
      final vendorSearchValue = partyController.selectedParty.value;
      isPartyTDS = vendorSearchValue.deductionType == "TDS";
      isPartyTCS = vendorSearchValue.deductionType == "TCS";
      deductionPercent =
          double.tryParse(vendorSearchValue.deductionPercent ?? "null") ?? 0;
    }

    // Calculate TCS and TDS based on subtotal
    // if (isPartyTDS) {
    //   double valueMultiplier = deductionPercent;
    //   print("TDS calculated $valueMultiplier");
    //   double tds =
    //       salesAmount * (valueMultiplier / 100); // Changed to use subtotal
    //   tdsController.text = tds.toStringAsFixed(2);
    //   taxDeductionAmount = tds;
    // } else if (isPartyTCS) {
    //   double valueMultiplier = deductionPercent;
    //   print("TCS calculated $valueMultiplier");
    //   double tcs =
    //       salesAmount * (valueMultiplier / 100); // Changed to use subtotal
    //   tcsController.text = tcs.toStringAsFixed(2);
    //   taxDeductionAmount = tcs;
    // }
    // taxDeductionNet.value = gstNet.value - taxDeductionAmount;
    if (isPartyTDS || isPartyTCS) {
      double totalTax = 0;

      // Get selected items
      final selectedItems =
          itemDetailsController.controllers
              .where((element) => element.isSelected)
              .toList();

      if (selectedItems.isNotEmpty) {
        // Calculate total of item sales amounts
        double itemSalesTotal = 0;
        for (var item in selectedItems) {
          itemSalesTotal += double.tryParse(item.salesAmount.text) ?? 0;
        }

        // Calculate tax per item with ceiling
        for (var item in selectedItems) {
          double itemSalesAmount = double.tryParse(item.salesAmount.text) ?? 0;
          double itemProportion = itemSalesAmount / itemSalesTotal;
          double itemShareOfSalesAmount = salesAmount.value * itemProportion;

          // Apply ceiling to each item's tax
          double itemTax =
              (itemShareOfSalesAmount * (deductionPercent / 100))
                  .ceil()
                  .toDouble();
          totalTax += itemTax;

          log(
            "Item: ${item.code.text}, Sales: $itemSalesAmount, Proportion: $itemProportion, Tax: $itemTax",
          );
        }
      } else {
        // Fallback: simple ceiling if no items
        totalTax =
            (salesAmount.value * (deductionPercent / 100)).ceil().toDouble();
      }

      if (isPartyTDS) {
        print("TDS calculated: $totalTax");
        tdsController.text = totalTax.toStringAsFixed(2);
        taxDeductionAmount = totalTax;
      } else if (isPartyTCS) {
        print("TCS calculated: $totalTax");
        tcsController.text = totalTax.toStringAsFixed(2);
        taxDeductionAmount = totalTax;
      }
    }
    taxDeductionNet.value = gstNet.value - taxDeductionAmount;

    // Set initial values for payment fields
    paidAmountController.text = "0";
    roundOffController.text = "0";
    purchaseAmountController.text = "0";
    advanceAmountController.text = "0";
    bankChargesAmountController.text = "0";

    double purchaseAmountValue =
        double.tryParse(purchaseAmountController.text) ?? 0;
    double advanceAmountValue =
        double.tryParse(advanceAmountController.text) ?? 0;
    double bankChargesAmountValue =
        double.tryParse(bankChargesAmountController.text) ?? 0;
    double roundOffValue = double.tryParse(roundOffController.text) ?? 0;

    double price =
        taxDeductionNet.value -
        purchaseAmountValue -
        advanceAmountValue -
        roundOffValue +
        bankChargesAmountValue;
    originalTotalPrice.value = price;

    totalPrice.value = price.toStringAsFixed(2);
    balanceAmountController.text = totalPrice.value;
    updateBalanceAmount();
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

  Future<void> validateAndPostPurchaseInvoice() async {
    // if (formKey.currentState!.validate() == false) {
    //   return;
    // }

    PostSalesReturnRequest invoiceModel = getConvertedRequestModel();
    log("The  details are here to send ${jsonEncode(invoiceModel.toJson())}");
    try {
      await _createSalesViewModel.addSalesReturnInvoice(
        salesRequest: invoiceModel,
      );
      clearAllControllers(invoiceType: "invoice_number_vendor");
      showSuccessToast(message: 'Sale Return added successfully !');
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

  PostSalesReturnRequest getConvertedRequestModel() {
    SalesReturnItemDetailsController itemDetailsController =
        Get.find<SalesReturnItemDetailsController>();

    SalesReturnSearchPartyController partyController =
        Get.find<SalesReturnSearchPartyController>();

    String subTotal =
        itemDetailsController.totalHeadersValue[itemDetailsController
                .totalHeadersValue
                .length -
            2];

    final listOfSelectedLineItemsToReturn =
        itemDetailsController.controllers
            .where((element) => element.isSelected)
            .toList();

    List<PostSalesReturnLineItemRequest>? lineItems =
        listOfSelectedLineItemsToReturn
            .map(
              (element) => PostSalesReturnLineItemRequest(
                organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
                ornamentId: element.itemResponse?.ornamentId,
                shopId: element.itemResponse?.taggingRecord?.shopId,
                code: element.code.text,
                taggingId: element.itemResponse?.taggingId,
                tag: element.itemResponse?.tag,
                description: element.item_description.text,
                salesPersonId: partyController.selectedEmployee.value?.id,
                taggingVa: element.originalVa,
                finalVa: double.tryParse(element.va.text),
                taggingMc: element.originalMc,
                finalMc: double.tryParse(element.mc.text),
                stoneCost: double.tryParse(element.stone.text),
                hallMark: double.tryParse(element.hallMark.text),
                discount: double.tryParse(element.costDiscount.text),
                salesAmount: double.tryParse(element.salesAmount.text),
                totalAmount: double.tryParse(element.total.text),
                grossWeight: double.tryParse(element.gwt.text),
                netWeight: double.tryParse(element.nwt.text),
                pieces: double.tryParse(element.pcs.text),
                saleLineItemId: element.itemResponse?.id,
                designCode: element.itemResponse?.taggingRecord?.design?.code,
                ornamentCode:
                    element
                        .itemResponse
                        ?.taggingRecord
                        ?.designLineItem
                        ?.ornament
                        ?.code,
                ornamentName:
                    element
                        .itemResponse
                        ?.taggingRecord
                        ?.designLineItem
                        ?.ornament
                        ?.name,
              ),
            )
            .toList();

    PostSalesReturnPaymentDetailRequest
    paymentDetailsModel = PostSalesReturnPaymentDetailRequest(
      organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
      cgst: CGStValue.value,
      sgst: SGSTValue.value,
      igst: IGStValue.value,
      subTotal: (subTotal),
      tcs: tcsController.text.trim().isEmpty ? null : tcsController.text.trim(),
      tds: tdsController.text.trim().isEmpty ? null : tdsController.text.trim(),
      amount: totalPrice.value,
      advance: advanceAmountController.text,
      bankCharges: bankChargesAmountController.text,
      finalAmount: totalPrice.value,
      nettGst: gstNet.toStringAsFixed(2),
      nettTdsTcs: taxDeductionNet.toStringAsFixed(2),
      purchaseOldGold: purchaseAmountController.text,
      rateDiscount: rateDisct.toStringAsFixed(2),
      roundOff: roundOffController.text,
      salesAmount: salesAmount.toStringAsFixed(2),
      schemeDiscount: schemeDisct.toStringAsFixed(2),
      balance: "0",
      isConsumed: false,
    );

    String partyAddress = "";
    String partyCode = "";
    String? partyGst = "";
    String partyId = "";
    String partyName = "";
    String partyType = "";

    // Fix: Handle both specific search value types and PartyDetails
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
      if (vendorSearchValue.address != null) {
        final a = vendorSearchValue.address as List<Address>;
        address = a.firstOrNull?.city ?? "";
      }
      partyAddress = address;
      partyGst = vendorSearchValue.gstNumber;
      partyId = vendorSearchValue.id ?? '';
      partyName = vendorSearchValue.name ?? "";
      partyType = "vendor";
    } else if (partyController.selectedParty.value is PartyDetails) {
      // Handle PartyDetails - determine type from the original sales response
      final PartyDetails partyDetails = partyController.selectedParty.value;

      // Get the party type from the original sales response
      final SalesReturnViewmodel salesReturnViewmodel =
          Get.find<SalesReturnViewmodel>();
      final originalResponse =
          salesReturnViewmodel.getSaleBySalesNumberResponse.value.data;

      partyAddress = partyDetails.address?.firstOrNull?.city ?? "";
      partyCode = partyDetails.readableId ?? "";
      partyGst = partyDetails.gstNumber;
      partyId = partyDetails.id ?? '';
      partyName = partyDetails.name ?? "";

      // Use the party type from the original response
      partyType =
          originalResponse?.partyType ??
          "customer"; // default to customer if not found
    } else {
      // Fallback for any other type
      dynamic vendorSearchValue = partyController.selectedParty.value;
      String address = "";
      if (vendorSearchValue.address != null) {
        try {
          final a = vendorSearchValue.address as List<Address>;
          address = a.firstOrNull?.city ?? "";
        } catch (e) {
          address = "";
        }
      }
      partyAddress = address;
      partyGst = vendorSearchValue.gstNumber;
      partyId = vendorSearchValue.id ?? '';
      partyName = vendorSearchValue.name ?? "";
      partyType =
          "vendor"; // Keep as fallback but now PartyDetails case is handled above
    }

    PostSalesReturnRequest invoiceModel = PostSalesReturnRequest(
      voucherType: _createSalesViewModel.selectedSequence.value?.type,
      voucherSeriesId: _createSalesViewModel.selectedSequence.value?.id,
      paymentDetails: [paymentDetailsModel],
      partyName: partyName,
      organizationId: "a8a1c2f088a94f57a2d4b8e4c9a155f4",
      partyId: partyId,
      partyType: partyType,
      lineItems: lineItems,
      shopId:
          itemDetailsController
              .controllers
              .firstOrNull
              ?.itemResponse
              ?.taggingRecord
              ?.shopId,
      remarks: "",
      saleReturnNumber: _createSalesViewModel.salesNumber.value,
      saleRecordId:
          itemDetailsController
              .controllers
              .firstOrNull
              ?.itemResponse
              ?.saleRecordId,
    );

    log("The  details are here ${jsonEncode(invoiceModel.toJson())}");
    return invoiceModel;
  }

  void clearAllControllers({required String invoiceType}) {
    SalesReturnItemDetailsController itemDetailsController =
        Get.find<SalesReturnItemDetailsController>();
    itemDetailsController.clearControllers();

    RemarksController remarksController = Get.find<RemarksController>();
    remarksController.purchaseRemarks.value = "";

    final SalesReturnSearchPartyController partyDetailsController =
        Get.find<SalesReturnSearchPartyController>();

    partyDetailsController.clearControllers();

    SalesReturnViewmodel salesReturnViewmodel =
        Get.find<SalesReturnViewmodel>();
    salesReturnViewmodel.clearControllers();
  }
}
