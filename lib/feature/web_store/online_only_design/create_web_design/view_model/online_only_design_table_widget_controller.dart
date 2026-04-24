import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class OnlineOnlyTableData {
  final String id;
  final TextEditingController pcs;
  final TextEditingController weightPc;
  final TextEditingController size;
  final TextEditingController amountPc;
  final TextEditingController undiscountedAmount;
  List<FocusNode> tableFocusNodes;

  OnlineOnlyTableData({
    this.id = "",
    required this.pcs,
    required this.weightPc,
    required this.size,
    required this.amountPc,
    required this.undiscountedAmount,
  }) : tableFocusNodes = List.generate(5, (_) => FocusNode());

  void dispose() {
    for (var node in tableFocusNodes) {
      node.dispose();
    }
  }
}

class OnlineOnlyTableController extends GetxController {
  // final InventoryRepository _inventoryRepository = InventoryRepository();

  final RxList<OnlineOnlyTableData> controllers = <OnlineOnlyTableData>[].obs;
  final RxList<String> totalHeadersValue = <String>[].obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  final headers = [
    "Pcs*",
    'Weight/pc',
    'Size',
    'Amount/pc*',
    'Undiscounted Amount',
    '',
  ];

  final columnWidths = [
    0.45, // Pcs
    0.45, // Weight/pc
    0.45, // Size
    0.45, // Amount/pc
    0.5, // Undiscounted Amount
    0.1, // Delete
  ];

  @override
  void onInit() {
    super.onInit();
    addRow();
  }

  @override
  void onClose() {
    // Clean up focus nodes
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
    }
  }

  void addRow() {
    log("Calling add row");
    controllers.add(
      OnlineOnlyTableData(
        pcs: TextEditingController(),
        weightPc: TextEditingController(),
        size: TextEditingController(),
        amountPc: TextEditingController(),
        undiscountedAmount: TextEditingController(),
      ),
    );
    updateTotals();

    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void removeRow({required int index}) {
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
    }
  }

  void removeCurrentRow(int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      updateTotals();
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

  void updateTotals() {
    // Calculate totals for each column
    double totalPcs = 0;
    double totalWeight = 0;
    double totalAmount = 0;
    double totalUndiscountedAmount = 0;

    for (var controller in controllers) {
      totalPcs += double.tryParse(controller.pcs.text) ?? 0;
      totalWeight +=
          (double.tryParse(controller.pcs.text) ?? 0) *
          (double.tryParse(controller.weightPc.text) ?? 0);
      totalAmount +=
          (double.tryParse(controller.pcs.text) ?? 0) *
          (double.tryParse(controller.amountPc.text) ?? 0);
      totalUndiscountedAmount +=
          (double.tryParse(controller.pcs.text) ?? 0) *
          (double.tryParse(controller.undiscountedAmount.text) ?? 0);
    }

    totalHeadersValue.value = [
      totalPcs.toString(),
      totalWeight.toStringAsFixed(3),
      '', // Size column - no total
      totalAmount.toStringAsFixed(2),
      totalUndiscountedAmount.toStringAsFixed(2),
      '',
    ];
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
    log("moving focus moveNextFocus to $currentRowIndex : $currentColIndex");
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
        log("inside else");
        previousFocusNode.requestFocus();
        log("moving focus move focus to $currentRowIndex : $currentColIndex");
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
    log("moving focus move focus to $currentRowIndex : $currentColIndex");
    return result;
  }

  void clearControllers({bool shouldAddRow = true}) {
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.clear();
    if (shouldAddRow) {
      addRow();
      updateTotals();
    }
  }

  void resetRow(int index) {
    // Reset all text controllers
    controllers[index].pcs.clear();
    controllers[index].weightPc.clear();
    controllers[index].size.clear();
    controllers[index].amountPc.clear();
    controllers[index].undiscountedAmount.clear();

    // Update totals and UI
    updateTotals();
    update();
  }

  void focusFirstField() {
    if (controllers.isNotEmpty && controllers[0].tableFocusNodes.isNotEmpty) {
      currentRowIndex.value = 0;
      currentColIndex.value = 0;
      controllers[0].tableFocusNodes[0].requestFocus();
    }
  }

  void populateWithFetchedData(dynamic data) {
    // Clear existing controllers
    clearControllers(shouldAddRow: false);

    // Add logic to populate controllers based on fetched data
    // This is a placeholder - implement based on your data structure
    addRow();
  }
}
