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

class CreateOrderOldGoldController extends GetxController {
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

  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final getPurityResponse = Rx<ApiResponse<GetPurityResponse>>(
    ApiResponse.initial("Initial"),
  );

  @override
  void onInit() {
    super.onInit();
    updateTotals();
  }

  void initializeRow() {
    getCodeList();
    getPurityDetails();
    if (controllers.isEmpty) {
      addRow();
    }
  }

  Future<void> getCodeList() async {
    await _inventoryViewmodel.getAllOrnaments(isOldGold: true);
    codeList.assignAll(
      _inventoryViewmodel.getAllOrnamentsResponse.value.data?.values ?? [],
    );
    if (controllers.isNotEmpty) {
      controllers.last.tableFocusNodes[0].requestFocus();
    }
  }

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

  void setItemDescription(int index, String code) {
    GetAllOrnamentsResponseValue? value = codeList.firstWhereOrNull(
      (item) => item.code == code,
    );

    if (value != null) {
      controllers[index].code.text = value.code ?? "";
      controllers[index].ornamentId = value.id;
      controllers[index].ornamentName = value.name;
      controllers[index].description.text = value.name ?? "";
      controllers.refresh();
      update();
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
    );

    // Get current rate for 22k gold
    GoldRateController goldRateController = Get.find<GoldRateController>();
    newRow.rate.text = goldRateController.getRateForPurity("22k").toString();
    controllers.add(newRow);
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

  void handlePurityFocusLoss(int index) {
    final row = controllers[index];
    if (row.purity.text.trim().isEmpty) {
      row.purity.text = "100";
      calculateAmount(index);
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
      totalGWt.toStringAsFixed(3),
      totalLess.toStringAsFixed(2),
      totalNWt.toStringAsFixed(3),
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

  void calculateAmount(int index) {
    final row = controllers[index];

    try {
      final netWt = double.tryParse(row.net_wtt.text) ?? 0;
      final purityText = row.purity.text.trim();
      final rate = double.tryParse(row.rate.text) ?? 0;

      if (purityText.isEmpty) {
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
    } catch (e) {
      log("Error calculating amount: $e");
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
      removeButtonFocusNode.requestFocus();
    }
  }

  void moveNextFocus() {
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
      } else {
        previousFocusNode.requestFocus();
        return KeyEventResult.handled;
      }
    } else if (keyboard == LogicalKeyboardKey.arrowDown) {
      if (currentRowIndex.value < controllers.length - 1) {
        currentRowIndex.value++;
      } else {
        nextFocusNode.requestFocus();
        return KeyEventResult.handled;
      }
    }

    controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
        .requestFocus();
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
      updateTotals();
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  void resetRow(int index) {
    final String? originalId = controllers[index].id;

    controllers[index].code.clear();
    controllers[index].description.clear();
    controllers[index].pcs.text = "1";
    controllers[index].gross_wtt.clear();
    controllers[index].less.clear();
    controllers[index].net_wtt.clear();
    controllers[index].purity.clear();

    GoldRateController goldRateController = Get.find<GoldRateController>();
    controllers[index].rate.text =
        goldRateController.getRateForPurity("22k").toString();

    controllers[index].amount.clear();
    controllers[index].round_off.text = "0";
    controllers[index].total_amount.clear();
    controllers[index].ornamentId = null;
    controllers[index].ornamentName = null;
    controllers[index].id = originalId;

    controllers[index].tableFocusNodes[0].requestFocus();
    currentColIndex.value = 0;

    updateTotals();
    controllers.refresh();
    update();
  }

  void clearAllFields() {
    for (int i = 0; i < controllers.length; i++) {
      resetRow(i);
    }
    if (controllers.length > 1) {
      controllers.removeRange(1, controllers.length);
    }
    currentRowIndex.value = 0;
    currentColIndex.value = 0;
    controllers.first.tableFocusNodes[0].requestFocus();
    updateTotals();
    controllers.refresh();
    update();
  }

  Future<bool> validateAndSave() async {
    try {
      removeEmptyRows();
      await Future.delayed(const Duration(milliseconds: 100));

      List<String> validationErrors = validateAllRows();

      if (validationErrors.isNotEmpty) {
        for (String error in validationErrors) {
          showErrorToast(message: error);
        }
        return false;
      }

      return true;
    } catch (e) {
      showErrorToast(
        message: "An error occurred while validating: ${e.toString()}",
      );
      return false;
    }
  }

  void removeEmptyRows() {
    if (controllers.length > 1) {
      controllers.removeWhere(
        (element) =>
            element.code.text.isEmpty ||
            element.description.text.isEmpty ||
            (element.gross_wtt.text.isEmpty && element.net_wtt.text.isEmpty),
      );

      currentRowIndex.value = controllers.isEmpty ? 0 : controllers.length - 1;
      currentColIndex.value = 0;

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
}
