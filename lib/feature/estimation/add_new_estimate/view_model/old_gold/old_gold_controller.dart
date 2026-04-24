import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/old_gold/old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class OldGoldController extends GetxController {
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
    // addRow();
    updateTotals();
  }

  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  void initializeRow() {
    getCodeList();
    getPurityDetails();

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
    totalHeadersValue.value = [
      "Total",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "",
    ];
    controllers.refresh();
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
      purity: TextEditingController(text: "100"),
      rate: TextEditingController(),
      round_off: TextEditingController(text: "0"),
      total_amount: TextEditingController(),
      selectedPurityType: "22k",
      selectedMetalType: null,
    );
    // updateTotals();
    try {
      GoldRateController rateController = Get.find<GoldRateController>();
      String rateValue = rateController.getRateForPurity("22k");

      log("22k gold rate value: $rateValue");

      if (rateValue.isNotEmpty && rateValue != "null") {
        newRow.rate.text = rateValue;
      } else {
        log("22k rate is empty, setting default");
        newRow.rate.text = "0";
      }
    } catch (e) {
      log("Error getting gold rate: $e");
      newRow.rate.text = "0";
    }

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
      updateTotals();
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

  void updateTotals() {
    double totalPcs = 0;
    double totalGWt = 0;

    double totalNWt = 0;
    double totalLess = 0;
    double totalPurity = 0;

    double totalRate = 0;
    double totalAmount = 0;
    double totalRoundOff = 0;

    for (var row in controllers) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gross_wtt.text) ?? 0;

      totalNWt += double.tryParse(row.net_wtt.text) ?? 0;
      totalLess += double.tryParse(row.less.text) ?? 0;
      totalPurity += double.tryParse(row.purity.text) ?? 0;
      totalRate += double.tryParse(row.rate.text) ?? 0;
      totalRoundOff += double.tryParse(row.round_off.text) ?? 0;

      totalAmount += double.tryParse(row.total_amount.text)?.ceil() ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      totalPcs.toStringAsFixed(2),
      totalGWt.toStringAsFixed(2),
      totalLess.toStringAsFixed(2),
      totalNWt.toStringAsFixed(2),
      totalPurity.toStringAsFixed(2),
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
      final purity = double.tryParse(row.purity.text) ?? 100;
      final rate = double.tryParse(row.rate.text) ?? 0;

      // Calculate amount using the new formula: NETWT*(PURITY/100) * RATE
      final amount = netWt * (purity / 100) * rate;
      row.amount.text = amount.toStringAsFixed(2);

      // Calculate total amount including round off
      final roundOff = double.tryParse(row.round_off.text) ?? 0;
      final totalAmount = amount + roundOff;
      row.total_amount.text = totalAmount.ceil().toStringAsFixed(2);

      updateTotals();
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
      log("Error calculating net weight: $e");
    }
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
    controllers[index].purity.text = "100";

    // Reset to default purity type and rate
    controllers[index].selectedPurityType = "22k"; // ADDED

    // Get rate for default 22k gold
    GoldRateController rateController = Get.find<GoldRateController>();
    controllers[index].rate.text = rateController.getRateForPurity("22k");

    controllers[index].amount.clear();
    controllers[index].round_off.text = "0";
    controllers[index].total_amount.clear();

    // Reset ornament-related data
    controllers[index].ornamentId = null;
    controllers[index].ornamentName = null;
    controllers[index].selectedMetalType = null; // ADDED

    controllers[index].id = originalId;

    controllers[index].tableFocusNodes[0].requestFocus();
    currentColIndex.value = 0;

    updateTotals();
    controllers.refresh();
    update();
  }
}
