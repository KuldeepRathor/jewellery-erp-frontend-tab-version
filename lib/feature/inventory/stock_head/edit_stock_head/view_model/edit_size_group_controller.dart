import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EditSizeGroupController extends GetxController {
  final headers =
      [
        "Code",
        // "Name",
        "Size (mm)",
        "",
      ].obs;
  final columnWidths = [
    0.98,
    // 1.16,
    0.98,
    0.15,
  ];
  final RxList<SizeGroupRow> rows = <SizeGroupRow>[].obs;
  final RxBool isRequired = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxInt currentRowIndex = 0.obs;
  final RxInt currentColIndex = 0.obs;

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

  void addRow() {
    rows.add(
      SizeGroupRow(
        code: TextEditingController(),
        size: TextEditingController(),
      ),
    );
  }

  void setSizeRequired(bool required) {
    isRequired.value = required;
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

  void resetFields() {
    for (var row in rows) {
      row.resetFields();
    }
    isRequired.value = false;
    currentRowIndex.value = 0;
    currentColIndex.value = 0;

    // Clear all rows except the first one
    if (rows.length > 1) {
      rows.removeRange(1, rows.length);
    }
  }

  // Add these new methods
  bool isCodeUniqueLocally(String code, int currentRowIndex) {
    return !rows.asMap().entries.any(
      (entry) =>
          entry.key != currentRowIndex &&
          entry.value.code.text.toUpperCase() == code.toUpperCase(),
    );
  }

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
          "size_group",
        );
        codeAvailability['$rowIndex'] = isAvailable;
      } catch (e) {
        showErrorToast(message: "Failed to check code availability");
      } finally {
        isCheckingCode['$rowIndex'] = false;
      }
    });
  }

  bool validateAllCodes() {
    bool allCodesValid = true;

    // Check each row's code except the last one
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
      if (lastRow.code.text.isNotEmpty || lastRow.size.text.isNotEmpty) {
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

  void initializeCodeAvailability() {
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].id != null) {
        // This is an existing row
        codeAvailability['$i'] = true; // Pre-validate existing codes
      }
    }
  }

  void validateAndAddRow() {
    // Only validate filled rows
    bool hasEmptyRow = rows.any(
      (row) => row.code.text.isEmpty && row.size.text.isEmpty,
    );

    if (!hasEmptyRow) {
      addRow();
    } else {
      showErrorToast(message: "Please fill current row before adding new");
    }
  }

  bool validateSizeGroupTable() {
    if (formKey.currentState!.validate() && validateAllCodes()) {
      return true;
    } else {
      return false;
    }
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

class SizeGroupRow {
  final TextEditingController code;
  final TextEditingController size;
  final List<FocusNode> focusNodes;
  String? id; // Add ID field for existing records

  SizeGroupRow({required this.code, required this.size, this.id})
    : focusNodes = List.generate(3, (_) => FocusNode());

  void resetFields() {
    code.clear();
    size.clear();
  }
}
