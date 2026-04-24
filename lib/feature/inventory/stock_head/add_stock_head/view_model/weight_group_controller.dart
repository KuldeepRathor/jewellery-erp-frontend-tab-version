import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class WeightGroupController extends GetxController {
  final headers = ["Code", "Name", "Weight (gm)", ""].obs;
  final columnWidths = [0.4, 1.16, 0.4, 0.15];
  final RxList<WeightGroupRow> rows = <WeightGroupRow>[].obs;
  final RxBool isRequired = true.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxInt currentRowIndex = 0.obs;
  final RxInt currentColIndex = 0.obs;

  final RxBool isNettWtSelected = true.obs;
  void toggleWeightType(bool isNettWt) {
    isNettWtSelected.value = isNettWt;
  }

  final RxMap<String, bool> codeAvailability = <String, bool>{}.obs;
  final RxMap<String, bool> isCheckingCode = <String, bool>{}.obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);
  final InventoryRepository inventoryRepository = InventoryRepository();

  @override
  void onInit() {
    super.onInit();

    addRow(isFirst: true);
  }

  @override
  void onClose() {
    for (var row in rows) {
      row.dispose();
    }
    super.onClose();
  }

  // Creates a new row with zero values
  WeightGroupRow _createRowWithZeros({bool isFirstRow = false}) {
    return WeightGroupRow(
      code: TextEditingController(),
      name: TextEditingController(),
      minWeight: TextEditingController(text: isFirstRow ? "0.001" : "0"),
      maxWeight: TextEditingController(text: "0"),
      isMinWeightFixed: isFirstRow,
    );
  }

  // Creates a new row with a specific min weight value
  WeightGroupRow _createRowWithMinWeight(String minWeightValue) {
    return WeightGroupRow(
      code: TextEditingController(),
      name: TextEditingController(),
      minWeight: TextEditingController(text: minWeightValue),
      maxWeight: TextEditingController(text: "0.001"),
    );
  }

  // Calculates the next minimum weight based on previous max weight
  String? _calculateNextMinWeight(String previousMaxWeight) {
    try {
      if (previousMaxWeight == "0") return "0";

      final double lastMax = double.parse(previousMaxWeight);
      return (lastMax + 0.001).toStringAsFixed(3);
    } catch (e) {
      return "0";
    }
  }

  void addRow({bool isFirst = false}) {
    // If this is the first row, create one with zeros
    if (rows.isEmpty) {
      rows.add(_createRowWithZeros(isFirstRow: isFirst));
      return;
    }

    // Get the last row's max weight
    final String previousMaxWeight = rows.last.maxWeight.text;

    // If previous row's max weight is empty or zero, add row with zeros
    if (previousMaxWeight.isEmpty) {
      rows.add(_createRowWithZeros());
      return;
    }

    // Calculate next min weight
    final String? nextMinWeight = _calculateNextMinWeight(previousMaxWeight);

    // Add new row with calculated min weight or zeros if calculation failed
    rows.add(_createRowWithMinWeight(nextMinWeight ?? "0"));
  }

  void removeLastRow() {
    if (rows.length > 1) {
      rows.last.dispose();
      rows.removeLast();

      currentRowIndex.value = currentRowIndex.value - 1;
    } else {
      showErrorToast(message: "Cannot remove the last row");
    }
  }

  void removeCurrentRow(int index) {
    if (rows.length > 1) {
      rows[index].dispose();
      rows.removeAt(index);
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      rows[currentRowIndex.value].focusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      showErrorToast(message: "Cannot remove the last row");
    }
  }

  void toggleRequired() {
    isRequired.toggle();
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate() && validateAllCodes()) {
      addRow();
    }
  }

  bool validateWeightGroupTable() {
    if (!formKey.currentState!.validate()) return false;
    if (!validateAllCodes()) return false;

    // Additional validation for weight ranges
    for (int i = 0; i < rows.length; i++) {
      final minValue = rows[i].minWeight.text;
      final maxValue = rows[i].maxWeight.text;

      if (validateWeightRange(minValue, maxValue, i) != null) {
        return false;
      }
    }

    return true;
  }

  void resetFields() {
    for (var row in rows) {
      row.resetFields();
    }
    isRequired.value = true;
    isNettWtSelected.value = true;
    currentRowIndex.value = 0;
    currentColIndex.value = 0;

    // Clear all rows except the first one
    if (rows.length > 1) {
      rows.removeRange(1, rows.length);
    }
  }

  // Check if code is unique among rows
  bool isCodeUniqueLocally(String code, int currentRowIndex) {
    return !rows.asMap().entries.any(
      (entry) =>
          entry.key != currentRowIndex &&
          entry.value.code.text.toUpperCase() == code.toUpperCase(),
    );
  }

  // Check code availability with server and local rows
  void checkCodeAvailability(String code, int rowIndex) {
    if (code.isEmpty) {
      codeAvailability['$rowIndex'] = true;
      isCheckingCode['$rowIndex'] = false;
      return;
    }

    // First check local uniqueness
    if (!isCodeUniqueLocally(code, rowIndex)) {
      codeAvailability['$rowIndex'] = false;
      return;
    }

    isCheckingCode['$rowIndex'] = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await inventoryRepository.validateCode(
          code,
          "weight_group",
        );
        codeAvailability['$rowIndex'] = isAvailable;
      } catch (e) {
        showErrorToast(message: "Failed to check code availability");
      } finally {
        isCheckingCode['$rowIndex'] = false;
      }
    });
  }

  bool isRowEmpty(WeightGroupRow row) {
    return row.code.text.isEmpty && row.name.text.isEmpty;
    //  &&
    // (row.minWeight.text.isEmpty || row.minWeight.text == "0") &&
    // (row.maxWeight.text.isEmpty || row.maxWeight.text == "0");
  }

  // Method to validate all codes before submission
  bool validateAllCodes() {
    bool allCodesValid = true;

    // Check each row's code
    for (int i = 0; i < rows.length; i++) {
      if (isRowEmpty(rows[i])) {
        continue;
      }
      String code = rows[i].code.text;
      if (code.isEmpty ||
          codeAvailability['$i'] != true ||
          !isCodeUniqueLocally(code, i)) {
        allCodesValid = false;
        break;
      }
    }

    return allCodesValid;
  }

  void moveNextFocus() {
    if (currentColIndex < rows[currentRowIndex.value].focusNodes.length - 1) {
      currentColIndex.value++;
      rows[currentRowIndex.value].focusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex.value < rows.length - 1) {
      currentRowIndex.value++;
      currentColIndex.value = 0;
      rows[currentRowIndex.value].focusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      validateAndAddRow();
      if (rows.length > currentRowIndex.value + 1) {
        currentRowIndex.value++;
        currentColIndex.value = 0;
        rows[currentRowIndex.value].focusNodes[currentColIndex.value]
            .requestFocus();
      }
    }
  }

  void movePreviousFocus(FocusNode node) {
    if (currentColIndex.value > 0) {
      currentColIndex.value--;
      rows[currentRowIndex.value].focusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex.value > 0) {
      currentRowIndex.value--;
      currentColIndex.value = rows[currentRowIndex.value].focusNodes.length - 1;
      rows[currentRowIndex.value].focusNodes[currentColIndex.value]
          .requestFocus();
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
      if (currentRowIndex.value < rows.length - 1) {
        currentRowIndex.value++;
      } else {
        nextFocusNode.requestFocus();
        return KeyEventResult.handled;
      }
    }
    rows[currentRowIndex.value].focusNodes[currentColIndex.value]
        .requestFocus();
    return result;
  }

  // Check if a range overlaps with existing ranges
  bool isWeightRangeOverlapping(double min, double max, int currentRowIndex) {
    log("Checking overlap for range: $min - $max (Row: $currentRowIndex)");

    return rows.asMap().entries.any((entry) {
      final rowIndex = entry.key;
      final row = entry.value;

      log(
        "Comparing with Row $rowIndex: Min=${row.minWeight.text}, Max=${row.maxWeight.text}",
      );

      // Skip current row and empty rows
      if (rowIndex == currentRowIndex) {
        log("Skipping current row $rowIndex");
        return false;
      }

      if (row.minWeight.text.isEmpty || row.maxWeight.text.isEmpty) {
        log("Skipping row $rowIndex due to empty values");
        return false;
      }

      final otherMin = double.tryParse(row.minWeight.text);
      final otherMax = double.tryParse(row.maxWeight.text);

      if (otherMin == null || otherMax == null) {
        log("Skipping row $rowIndex due to invalid number format");
        return false;
      }

      log("Checking if range $min-$max overlaps with $otherMin-$otherMax");
      final isOverlapping = (min <= otherMax && max >= otherMin);

      if (isOverlapping) {
        log("OVERLAP DETECTED: $min-$max overlaps with $otherMin-$otherMax");
      } else {
        log("No overlap between $min-$max and $otherMin-$otherMax");
      }

      return isOverlapping;
    });
  }

  // Validate weight range for a specific row
  String? validateWeightRange(
    String? minValue,
    String? maxValue,
    int rowIndex,
  ) {
    if (minValue == null ||
        maxValue == null ||
        minValue.isEmpty ||
        maxValue.isEmpty) {
      return null;
    }

    final double? min = double.tryParse(minValue);
    final double? max = double.tryParse(maxValue);

    if (min == null || max == null) {
      return 'Invalid number';
    }

    if (min >= max) {
      return 'Min must be less than Max';
    }

    if (isWeightRangeOverlapping(min, max, rowIndex)) {
      log("'Weight range overlaps with another group': $rowIndex");
      return 'Weight range overlaps with another group';
    }

    return null;
  }

  void resetRow(int index) {
    // Reset all text controllers to empty
    rows[index].code.clear();
    rows[index].name.clear();
    rows[index].minWeight.clear();
    rows[index].maxWeight.clear();

    // Update UI
    update();
  }
}

class WeightGroupRow {
  final TextEditingController code;
  final TextEditingController name;
  final TextEditingController minWeight;
  final TextEditingController maxWeight;
  final List<FocusNode> focusNodes;
  final bool isMinWeightFixed;

  WeightGroupRow({
    required this.code,
    required this.name,
    required this.minWeight,
    required this.maxWeight,
    this.isMinWeightFixed = false,
  }) : focusNodes = List.generate(4, (_) => FocusNode()) {
    // Add listeners to min and max weight focus nodes
    focusNodes[2].addListener(_onMinFocus);
    focusNodes[3].addListener(_onMaxFocus);
  }

  void _onMinFocus() {
    if (focusNodes[2].hasFocus) {
      minWeight.selection = TextSelection(
        baseOffset: 0,
        extentOffset: minWeight.text.length,
      );
    }
  }

  void _onMaxFocus() {
    if (focusNodes[3].hasFocus) {
      maxWeight.selection = TextSelection(
        baseOffset: 0,
        extentOffset: maxWeight.text.length,
      );
    }
  }

  void dispose() {
    focusNodes[2].removeListener(_onMinFocus);
    focusNodes[3].removeListener(_onMaxFocus);
    for (var node in focusNodes) {
      node.dispose();
    }
  }

  void resetFields() {
    code.clear();
    name.clear();
    if (!isMinWeightFixed) {
      minWeight.clear();
    } else {
      minWeight.text = "0.001";
    }
    maxWeight.clear();
  }
}
