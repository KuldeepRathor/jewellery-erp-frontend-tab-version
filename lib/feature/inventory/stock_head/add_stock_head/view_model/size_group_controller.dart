import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SizeGroupController extends GetxController {
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
    addRow();
  }

  void addRow() {
    rows.add(
      SizeGroupRow(
        code: TextEditingController(),
        size: TextEditingController(),
      ),
    );
  }

  void removeLastRow() {
    if (rows.length > 1) {
      rows.removeLast();
    } else {
      // Get.snackbar(
      //   'Cannot Remove',
      //   'Cannot remove the last row.',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      showErrorToast(message: "Cannot remove the last row");
    }
  }

  void removeCurrentRow(int index) {
    if (rows.length > 1) {
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

  // void moveNextFocus() {
  //   if (currentColIndex < 2) {
  //     currentColIndex++;
  //   } else if (currentRowIndex < rows.length - 1) {
  //     currentRowIndex++;
  //     currentColIndex.value = 0;
  //   } else {
  //     validateAndAddRow();
  //   }
  // }

  // void movePreviousFocus() {
  //   if (currentColIndex > 0) {
  //     currentColIndex--;
  //   } else if (currentRowIndex > 0) {
  //     currentRowIndex--;
  //     currentColIndex.value = 2;
  //   }
  // }
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

  bool isRowEmpty(SizeGroupRow row) {
    return row.code.text.isEmpty && row.size.text.isEmpty;
  }

  bool validateAllCodes() {
    bool allCodesValid = true;

    for (int i = 0; i < rows.length; i++) {
      // Skip validation for empty rows
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

  // Update validateAndAddRow
  void validateAndAddRow() {
    if (formKey.currentState!.validate() && validateAllCodes()) {
      addRow();
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

  void resetRow(int index) {
    // Reset all text controllers to empty
    rows[index].code.clear();
    rows[index].size.clear();

    // Update UI
    update();
  }
}

class SizeGroupRow {
  final TextEditingController code;
  final TextEditingController size;
  final List<FocusNode> focusNodes;

  SizeGroupRow({required this.code, required this.size})
    : focusNodes = List.generate(2, (_) => FocusNode());

  void resetFields() {
    code.clear();
    size.clear();
  }
}
