import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EditWeightGroupController extends GetxController {
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
    if (rows.isEmpty) {
      addRow();
    }
  }

  void setWeightType(bool isNettWt) {
    isNettWtSelected.value = isNettWt;
  }

  void addRow() {
    if (rows.isEmpty) {
      rows.add(_createRowWithZeros());
      return;
    }

    final String previousMaxWeight = rows.last.maxWeight.text;

    if (previousMaxWeight.isEmpty) {
      rows.add(_createRowWithZeros());
      return;
    }

    final String? nextMinWeight = _calculateNextMinWeight(previousMaxWeight);

    rows.add(_createRowWithMinWeight(nextMinWeight ?? "0"));
  }

  // Creates a new row with zero values
  WeightGroupRow _createRowWithZeros() {
    return WeightGroupRow(
      code: TextEditingController(),
      name: TextEditingController(),
      minWeight: TextEditingController(text: "0"),
      maxWeight: TextEditingController(text: ""),
    );
  }

  // Creates a new row with a specific min weight value
  WeightGroupRow _createRowWithMinWeight(String minWeightValue) {
    return WeightGroupRow(
      code: TextEditingController(),
      name: TextEditingController(),
      minWeight: TextEditingController(text: minWeightValue),
      maxWeight: TextEditingController(text: "0"),
    );
  }

  // Calculates the next minimum weight based on previous max weight
  String? _calculateNextMinWeight(String previousMaxWeight) {
    try {
      if (previousMaxWeight == "0") return "0";

      final double lastMax = double.parse(previousMaxWeight);
      return (lastMax + 0.01).toStringAsFixed(2);
    } catch (e) {
      return "0";
    }
  }

  void removeLastRow() {
    if (rows.length > 1) {
      rows.removeLast();
    } else {
      showErrorToast(message: "Cannot remove the last row");
    }
  }

  void removeCurrentRow(int index) {
    if (rows.length > 1) {
      rows.removeAt(index);
    } else {
      showErrorToast(message: "Cannot remove the last row");
    }
  }

  void toggleRequired() {
    isRequired.toggle();
  }

  void validateAndAddRow() {
    // Only validate filled rows
    bool hasEmptyRow = rows.any(
      (row) =>
          row.code.text.isEmpty &&
          row.name.text.isEmpty &&
          row.minWeight.text.isEmpty &&
          row.maxWeight.text.isEmpty,
    );

    if (!hasEmptyRow) {
      addRow();
    } else {
      showErrorToast(message: "Please fill current row before adding new");
    }
  }

  void initializeCodeAvailability() {
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].id != null) {
        // This is an existing row
        codeAvailability['$i'] = true; // Pre-validate existing codes
      }
    }
  }

  bool validateWeightGroupTable() {
    if (formKey.currentState!.validate() && validateAllCodes()) {
      return true;
    } else {
      return false;
    }
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

  // Method to validate all codes before submission
  bool validateAllCodes() {
    bool allCodesValid = true;

    // Check each row's code except the last one (which may be new and empty)
    for (int i = 0; i < rows.length - 1; i++) {
      String code = rows[i].code.text;
      if (code.isEmpty ||
          codeAvailability['$i'] != true ||
          !isCodeUniqueLocally(code, i)) {
        allCodesValid = false;
        break;
      }
    }

    // For the last row, only validate if it has any data
    if (rows.isNotEmpty) {
      final lastRow = rows.last;
      if (lastRow.code.text.isNotEmpty ||
          lastRow.name.text.isNotEmpty ||
          lastRow.minWeight.text.isNotEmpty ||
          lastRow.maxWeight.text.isNotEmpty) {
        String code = lastRow.code.text;
        if (code.isEmpty ||
            codeAvailability['${rows.length - 1}'] != true ||
            !isCodeUniqueLocally(code, rows.length - 1)) {
          allCodesValid = false;
        }
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
}

class WeightGroupRow {
  final TextEditingController code;
  final TextEditingController name;
  final TextEditingController minWeight;
  final TextEditingController maxWeight;
  final List<FocusNode> focusNodes;
  String? id; // Add ID field for existing records

  WeightGroupRow({
    required this.code,
    required this.name,
    required this.minWeight,
    required this.maxWeight,
    this.id,
  }) : focusNodes = List.generate(4, (_) => FocusNode());

  void resetFields() {
    code.clear();
    name.clear();
    minWeight.clear();
    maxWeight.clear();
  }
}
