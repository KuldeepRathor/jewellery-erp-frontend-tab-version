// ignore_for_file: library_prefixes, avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/old_gold/old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/purchase_invoice_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart'
    hide MetalType;
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesOldGoldController extends GetxController {
  final PurchaseInvoiceViewmodel purchaseInvoiceViewmodel = Get.put(
    PurchaseInvoiceViewmodel(),
  );
  final InventoryViewmodel _inventoryViewmodel = Get.put(InventoryViewmodel());
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final isLoading = false.obs;
  final paymentHeaders = [
    'Sn',
    'Code',
    'Description',
    'Pcs',
    'Gross Wt.',
    'Less',
    'Net Wt.',
    'Pure',
    'Rate',
    'Round Off',
    'Total',
    "",
  ];
  final oldGoldColumnWidths = [
    0.1,
    0.28,
    0.28,
    0.2,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.2,
    0.28,
    0.1,
  ];
  final totalColumnWidths = [
    0.66,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.2,
  ];
  final RxList<String> totalHeadersValue =
      <String>["Total", "0", "0", "0", "0", "0", "0", "0", "0", ""].obs;
  final controllers = <OldGoldDetailsTableData>[].obs;

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    updateTotals();
    // ever(
    //   controllers,
    //   (callback) {
    //     final SalesPaymentDetailsController salesPaymentDetailsController =
    //         Get.find<SalesPaymentDetailsController>();
    //     salesPaymentDetailsController.calculateGstvalues();
    //   },
    // );
  }

  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  void initializeRow() {
    getCodeList();
    getPurityDetails();

    // controllers.clear();
    if (controllers.isEmpty) {
      addRow();
    } else {
      // If there's already a first row, set its rate
      _setDefaultRateForRow(0);
    }
  }

  void _setDefaultRateForRow(int index) {
    try {
      if (controllers.isNotEmpty && index < controllers.length) {
        GoldRateController rateController = Get.find<GoldRateController>();
        String rate = rateController.getRateForPurity("22k");
        log("Setting default 22k rate for row $index: $rate");
        controllers[index].rate.text = rate;
      }
    } catch (e) {
      log("Error setting default rate for row $index: $e");
      if (index < controllers.length) {
        controllers[index].rate.text = "0";
      }
    }
  }

  Future<void> getCodeList() async {
    await _inventoryViewmodel.getAllOrnaments(isOldGold: true);

    codeList.assignAll(
      _inventoryViewmodel.getAllOrnamentsResponse.value.data?.values ?? [],
    );
    controllers.last.tableFocusNodes[0].requestFocus();
  }

  void setItemDescription(int index, String code) {
    GetAllOrnamentsResponseValue value = codeList.firstWhere(
      (item) => item.code == code,
    );

    controllers[index].code.text = value.code ?? "";
    controllers[index].ornamentId = value.id;
    controllers[index].ornamentName = value.name;
    controllers[index].description.text = value.name ?? "";

    // Store metal type from selected ornament
    controllers[index].selectedMetalType = value.metalType;

    // Determine purity type with defaults based on metal type
    String purityType;
    if (value.purity != null && value.purity!.isNotEmpty) {
      // Use the ornament's purity if available
      purityType = value.purity!;
    } else {
      // Set default purity based on metal type
      String metalTypeName = value.metalType?.typeName?.toUpperCase() ?? "";

      if (metalTypeName.contains("GOLD") ||
          metalTypeName.contains("HALLMARK")) {
        purityType = "22k";
      } else if (metalTypeName.contains("SILVER")) {
        purityType = "silver";
      } else if (metalTypeName.contains("PLATINUM")) {
        purityType = "platinum";
      } else {
        // Default fallback
        purityType = "22k";
      }
    }

    controllers[index].selectedPurityType = purityType;

    // Update rate based on purity type
    _updateRateBasedOnPurity(index, purityType);

    controllers.refresh();
    print("The values are ${value.toJson()}");
    update();
  }

  void onPurityTypeChanged(int index, String newPurityType) {
    controllers[index].selectedPurityType = newPurityType;
    _updateRateBasedOnPurity(index, newPurityType);
    controllers.refresh();
    update();
  }

  void _updateRateBasedOnPurity(int index, String purityType) {
    try {
      GoldRateController rateController = Get.find<GoldRateController>();
      String rate = rateController.getRateForPurity(purityType);

      log("Setting rate for purity $purityType: $rate");

      if (rate.isNotEmpty && rate != "0") {
        controllers[index].rate.text = rate;
      } else {
        controllers[index].rate.clear();
        showErrorToast(message: "Please update the rates");
        // If rate not found, keep existing rate or set to 0
        log("Rate not found for purity: $purityType");
      }

      // Recalculate amount with new rate
      calculateAmount(index);
    } catch (e) {
      log("Error updating rate based on purity: $e");
    }
  }

  final getPurityResponse = Rx<ApiResponse<GetPurityResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getPurityDetails() async {
    try {
      getPurityResponse.value = ApiResponse.loading("Loading Purity");
      final response = await _inventoryRepository.getAllPurityTypes();
      getPurityResponse.value = ApiResponse.completed(response);
    } catch (e) {
      if (e is ApiException) {
        showErrorToast(message: e.toStringPrefix());
      }
      getPurityResponse.value = ApiResponse.error(e.toString());
    }
  }

  void clearTextController() {
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    updateTotals();
  }

  void addRow() {
    final newRow = OldGoldDetailsTableData(
      amount: TextEditingController(),
      code: TextEditingController(),
      description: TextEditingController(),
      gross_wtt: TextEditingController(),
      less: TextEditingController(),
      net_wtt: TextEditingController(),
      pcs: TextEditingController(text: "1"),
      purity: TextEditingController(),
      rate: TextEditingController(),
      round_off: TextEditingController(text: "0"),
      total_amount: TextEditingController(),
      selectedPurityType: "22k",
      selectedMetalType: null,
    );
    // try {
    //   GoldRateController rateController = Get.find<GoldRateController>();
    //   String rateValue = rateController.getRateForPurity("22k");

    //   log("22k gold rate value: $rateValue");

    //   if (rateValue.isNotEmpty && rateValue != "null") {
    //     newRow.rate.text = rateValue;
    //   } else {
    //     log("22k rate is empty, setting default");
    //     newRow.rate.text = "0";
    //   }
    // } catch (e) {
    //   log("Error getting gold rate: $e");
    //   newRow.rate.text = "0";
    // }

    newRow.rate.clear();

    // print("Please update the rates");
    // showErrorToast(message: "Please update the rates");

    controllers.add(newRow);
  }

  String? validatePurity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    final purity = double.tryParse(value);
    if (purity == null) {
      return 'Invalid number';
    }
    if (purity < 0 || purity > 100) {
      return 'Purity must be between 0 and 100';
    }
    return null;
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
    } else {
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

  void handlePurityFocusLoss(int index) {
    final row = controllers[index];
    if (row.purity.text.trim().isEmpty) {
      row.purity.text = "100";
      // This will trigger calculation since purity now has a value
      calculateAmount(index);
    }
  }

  void updateTotals() {
    double totalPcs = 0;
    double totalGWt = 0;

    double totalNWt = 0;
    double totalLess = 0;
    // double totalPurity = 0;

    double totalRate = 0;
    double totalAmount = 0;
    double totalRoundOff = 0;

    for (var row in controllers) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gross_wtt.text) ?? 0;

      totalNWt += double.tryParse(row.net_wtt.text) ?? 0;
      totalLess += double.tryParse(row.less.text) ?? 0;
      // totalPurity += double.tryParse(row.purity.text) ?? 0;
      totalRate += double.tryParse(row.rate.text) ?? 0;
      totalRoundOff += double.tryParse(row.round_off.text) ?? 0;

      totalAmount += double.tryParse(row.total_amount.text)?.ceil() ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      totalPcs.toStringAsFixed(2),
      totalGWt.toStringAsFixed(3),
      totalLess.toStringAsFixed(2),
      totalNWt.toStringAsFixed(3), "",
      // totalPurity.toStringAsFixed(2),
      totalRate.toStringAsFixed(2),
      totalRoundOff.toStringAsFixed(2),
      totalAmount.ceil().toStringAsFixed(2),
      "",
    ];
    update();
    totalHeadersValue.refresh();
    controllers.refresh();
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
      if (controllers.length > currentRowIndex.value + 1) {
        currentRowIndex.value++;
        currentColIndex.value = 0;
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
      }
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

  void calculateAmount(int index) {
    final row = controllers[index];

    try {
      final netWt = double.tryParse(row.net_wtt.text) ?? 0;
      final purityText = row.purity.text.trim();
      final rate = double.tryParse(row.rate.text) ?? 0;

      // CHANGED: Only calculate if purity field has a value
      if (purityText.isEmpty) {
        // Clear amount and total amount if purity is empty
        row.amount.clear();
        row.total_amount.clear();
        updateTotals();
        return;
      }

      final purity = double.tryParse(purityText) ?? 100;

      // Calculate amount using the formula: NETWT*(PURITY/100) * RATE
      final amount = netWt * (purity / 100) * rate;
      row.amount.text = amount.toStringAsFixed(2);

      // Calculate total amount including round off
      final roundOff = double.tryParse(row.round_off.text) ?? 0;
      final totalAmount = amount + roundOff;
      row.total_amount.text = totalAmount.ceil().toStringAsFixed(2);

      updateTotals();
      // final SalesPaymentDetailsController salesPaymentDetailsController =
      //     Get.find<SalesPaymentDetailsController>();
      // salesPaymentDetailsController.calculateGstvalues();
    } catch (e) {
      log("Error calculating amount: $e");
    }
  }

  // Method to calculate net weight
  void calculateNetWeight(int index) {
    final row = controllers[index];

    try {
      final grossWt = double.tryParse(row.gross_wtt.text) ?? 0;
      final less = double.tryParse(row.less.text) ?? 0;
      final netWt = grossWt - less;

      row.net_wtt.text = netWt.toStringAsFixed(3);
      calculateAmount(index);
    } catch (e) {
      print("Error calculating net weight: $e");
    }
  }

  void prefillOldGoldValues({required List<OldGold>? oldGolds}) {
    if (oldGolds == null || oldGolds.isEmpty) return;

    controllers.clear(); // Clear existing controllers

    for (OldGold oldGold in oldGolds) {
      controllers.add(
        OldGoldDetailsTableData(
          // id: oldGold.id,
          code: TextEditingController(text: oldGold.code ?? ''),
          description: TextEditingController(text: oldGold.description ?? ''),
          pcs: TextEditingController(text: oldGold.pieces?.toString() ?? ''),
          gross_wtt: TextEditingController(text: oldGold.grossWeight ?? ''),
          less: TextEditingController(text: oldGold.less ?? ''),
          net_wtt: TextEditingController(text: oldGold.netWeight ?? ''),
          purity: TextEditingController(text: oldGold.purity ?? '100'),
          rate: TextEditingController(text: oldGold.rate ?? ''),
          amount: TextEditingController(text: oldGold.amount ?? ''),
          round_off: TextEditingController(text: oldGold.roundOff ?? ''),
          total_amount: TextEditingController(text: oldGold.total ?? ''),
          selectedPurityType: oldGold.purityType ?? "22k",
          selectedMetalType:
              oldGold.metalType?.id != null
                  ? MetalType(id: oldGold.metalType?.id ?? "")
                  : null,
          ornamentId: oldGold.ornamentId,
          ornamentName: oldGold.ornamentName,
        ),
      );
    }
    updateTotals();

    // Refresh the controllers list if using GetX
    controllers.refresh();
  }

  void resetRow(int index) {
    final String? originalId = controllers[index].id;

    // Reset all TextEditingControllers
    controllers[index].code.clear();
    controllers[index].description.clear();
    controllers[index].pcs.text = "1";
    controllers[index].gross_wtt.clear();
    controllers[index].less.clear();
    controllers[index].net_wtt.clear();
    controllers[index].purity.clear();

    // Reset to default purity type and rate
    controllers[index].selectedPurityType = "22k"; // ADDED
    controllers[index].rate.clear();

    // Get rate for default 22k gold
    // GoldRateController rateController = Get.find<GoldRateController>();
    // controllers[index].rate.text = rateController.getRateForPurity("22k");

    controllers[index].amount.clear();
    controllers[index].round_off.text = "0";
    controllers[index].total_amount.clear();

    // Reset ornament-related data
    controllers[index].ornamentId = null;
    controllers[index].ornamentName = null;
    controllers[index].selectedMetalType = null; // ADDED

    controllers[index].id = originalId;

    // Focus on the first field of the row
    controllers[index].tableFocusNodes[0].requestFocus();
    currentColIndex.value = 0;

    // Update totals and refresh UI
    updateTotals();
    controllers.refresh();
    update();
  }

  void clearAllFields() {
    for (int i = 0; i < controllers.length; i++) {
      resetRow(i);
    }
    // Optionally, keep only one row after clearing
    if (controllers.length > 1) {
      controllers.removeRange(1, controllers.length);
    }
    // Reset focus to the first field
    currentRowIndex.value = 0;
    currentColIndex.value = 0;
    controllers.first.tableFocusNodes[0].requestFocus();
    updateTotals();
    controllers.refresh();
    update();
  }

  void removeEmptyRows() {
    if (controllers.length > 1) {
      controllers.removeWhere(
        (element) =>
            element.code.text.isEmpty ||
            element.description.text.isEmpty ||
            (element.gross_wtt.text.isEmpty && element.net_wtt.text.isEmpty),
      );

      // Reset current indices to safe values
      currentRowIndex.value = controllers.isEmpty ? 0 : controllers.length - 1;

      currentColIndex.value = 0;

      // Request focus on the last valid row if controllers are not empty
      if (controllers.isNotEmpty) {
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
      }

      controllers.refresh();
    }
  }

  List<String> validateAllRows() {
    List<String> validationErrors = [];

    // Check if we have at least one valid entry
    if (controllers.isEmpty ||
        controllers.every(
          (element) =>
              element.code.text.isEmpty &&
              element.description.text.isEmpty &&
              element.gross_wtt.text.isEmpty &&
              element.net_wtt.text.isEmpty,
        )) {
      validationErrors.add("Please add at least one old gold entry");
      return validationErrors;
    }

    for (int i = 0; i < controllers.length; i++) {
      final row = controllers[i];

      if (row.code.text.isEmpty) {
        validationErrors.add("Row ${i + 1}: Code is required");
      }

      if (row.description.text.isEmpty) {
        validationErrors.add("Row ${i + 1}: Description is required");
      }

      if (row.gross_wtt.text.isEmpty && row.net_wtt.text.isEmpty) {
        validationErrors.add(
          "Row ${i + 1}: Either Gross Weight or Net Weight is required",
        );
      }

      // Validate numeric fields
      if (row.pcs.text.isNotEmpty && double.tryParse(row.pcs.text) == null) {
        validationErrors.add("Row ${i + 1}: Invalid pieces value");
      }

      if (row.gross_wtt.text.isNotEmpty &&
          double.tryParse(row.gross_wtt.text) == null) {
        validationErrors.add("Row ${i + 1}: Invalid gross weight");
      }

      if (row.net_wtt.text.isNotEmpty &&
          double.tryParse(row.net_wtt.text) == null) {
        validationErrors.add("Row ${i + 1}: Invalid net weight");
      }

      if (row.purity.text.isNotEmpty) {
        final purity = double.tryParse(row.purity.text);
        if (purity == null || purity < 0 || purity > 100) {
          validationErrors.add(
            "Row ${i + 1}: Purity must be between 0 and 100",
          );
        }
      }

      if (row.rate.text.isNotEmpty && double.tryParse(row.rate.text) == null) {
        validationErrors.add("Row ${i + 1}: Invalid rate value");
      }
    }

    return validationErrors;
  }

  /// Validates and saves old gold data
  Future<bool> validateAndSave() async {
    try {
      // Remove empty rows first
      removeEmptyRows();

      // Small delay to ensure UI updates
      await Future.delayed(const Duration(milliseconds: 100));

      // Validate all remaining rows
      List<String> validationErrors = validateAllRows();

      // Show validation errors if any
      if (validationErrors.isNotEmpty) {
        for (String error in validationErrors) {
          showErrorToast(message: error);
        }
        return false;
      }

      // If validation passes, return true
      return true;
    } catch (e) {
      showErrorToast(
        message: "An error occurred while validating: ${e.toString()}",
      );
      return false;
    }
  }
}
