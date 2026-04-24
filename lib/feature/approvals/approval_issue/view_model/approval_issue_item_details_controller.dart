// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/widgets/stone_details_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ApprovalItemDetailsTableData {
  String sn;
  String tagging_id;
  TextEditingController item_code;
  TextEditingController tag_no;
  String gst;

  TextEditingController description;
  TextEditingController pcs;
  TextEditingController gwt;
  TextEditingController nwt;
  TextEditingController va;
  TextEditingController mc;
  TextEditingController stone;
  TextEditingController hall_mark;
  List<String> images = [];

  String wst_unit = "%"; // will be either "%" or "gm";
  List<StoneDetailsTableData> stoneDetailsTableData = [];

  List<FocusNode> tableFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  ApprovalItemDetailsTableData({
    required this.sn,
    required this.tagging_id,
    required this.item_code,
    required this.tag_no,
    required this.description,
    required this.pcs,
    required this.gwt,
    required this.nwt,
    required this.va,
    required this.mc,
    required this.stone,
    required this.hall_mark,
    this.gst = "0",
    this.images = const [],
  });
  Map<String, dynamic> toJsonValue() {
    return {
      'sn': sn,
      "tagging_id": tagging_id,
      'item_code': item_code.text,
      'tag_no': tag_no.text,
      'description': description.text,
      'pcs': pcs.text,
      'gwt': gwt.text,
      'nwt': nwt.text,
      'va': va.text,
      'mc': mc.text,
      'stone': stone.text,
      'hall_mark': hall_mark.text,
      'stone_details':
          stoneDetailsTableData.map((stone) => stone.toJsonValue()).toList(),
    };
  }

  bool isEmpty() {
    return item_code.text.isEmpty &&
        tag_no.text.isEmpty &&
        description.text.isEmpty &&
        pcs.text.isEmpty &&
        gwt.text.isEmpty &&
        nwt.text.isEmpty &&
        va.text.isEmpty &&
        mc.text.isEmpty &&
        stone.text.isEmpty &&
        hall_mark.text.isEmpty;
  }
}

class ApprovalIssueItemDetailsController extends GetxController {
  final headers = [
    'Sn',
    'Item Code',
    'Tag No.',
    "Description",
    'Pcs',
    'G.Wt. (gm)',
    'N.Wt. (gm)',
    'VA',
    'MC (₹)',
    'Stone Cost (₹)',
    'Hall Mark (₹)',
    '',
  ];

  final columnWidths = [
    0.1,
    0.3,
    0.3,
    0.75,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.1,
  ];

  final totalColumnWidths = [1.45, 0.3, 0.3, 0.6];

  List<String> popUpValues = ["View"];
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<ApprovalItemDetailsTableData> controllers =
      <ApprovalItemDetailsTableData>[].obs;
  final RxList<String> totalHeadersValue = <String>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // final InventoryViewmodel _inventoryViewmodel = Get.put(InventoryViewmodel());
  final InventoryRepository _inventoryRepository = Get.put<InventoryRepository>(
    InventoryRepository(),
  );

  final isItemDetailsVisible = false.obs;

  void showItemDetails({required int index}) {
    currentRowIndex.value = index;
    isItemDetailsVisible.value = true;
  }

  void hideItemDetails() {
    isItemDetailsVisible.value = false;
  }

  void toggleItemDetails({required int index}) {
    currentRowIndex.value = index;
    isItemDetailsVisible.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    addRow();
    updateTotals();
  }

  Future<void> fetchTaggingLineItemCodeTag(int index) async {
    log("=== START fetchTaggingLineItemCodeTag for row $index ===");

    final itemCode = controllers[index].item_code.text;
    final tagNumber = int.tryParse(controllers[index].tag_no.text);
    log("Fetching item with code: $itemCode, tag: $tagNumber");

    if (itemCode.isNotEmpty && tagNumber != null) {
      try {
        final response = await _inventoryRepository.getTaggingLineItemCodeTag(
          itemCode,
          tagNumber,
        );
        log(
          "Fetch response received: ${response.id != null ? "Success" : "Failed"}",
        );

        if (response.status?.toLowerCase() != "available") {
          showErrorToast(message: "This Item is not available");
          log("Item not available, status: ${response.status}");
          return;
        }

        controllers[index].tagging_id = response.id ?? '';
        controllers[index].description.text = response.design?.name ?? '';
        controllers[index].pcs.text = response.pieces?.toString() ?? '';
        controllers[index].gwt.text = response.grossWeight ?? '';
        controllers[index].nwt.text = response.netWeight ?? '';
        controllers[index].va.text = response.va ?? '';
        controllers[index].mc.text = response.mc ?? '';

        // Log stone details
        log("Line stones count: ${response.lineStones?.length ?? 0}");
        double stoneTotal =
            response.lineStones?.fold<double>(
              0,
              (sum, stone) => sum + (double.tryParse(stone.total ?? '0') ?? 0),
            ) ??
            0;
        log("Total stone amount: $stoneTotal");

        controllers[index].stone.text = stoneTotal.toString();
        controllers[index].hall_mark.text =
            response.design?.stockHead?.hallmarkExtraCharge ?? "";

        List<String> combinedImages = [
          ...(response.images?.map((image) => image.presignedUrl ?? '') ?? []),
          ...(response.design?.images?.map(
                (image) => image.presignedUrl ?? '',
              ) ??
              []),
        ];
        controllers[index].images =
            combinedImages.where((element) => element.isNotEmpty).toList();

        log("All fields populated from response");

        // Check if this is the last row
        if (index == controllers.length - 1) {
          // Add a new row
          addRow();
        }

        // Move focus to the next row's first column
        currentRowIndex.value = index + 1;
        currentColIndex.value = 0;

        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();

        updateTotals();
        update();
        log("=== END fetchTaggingLineItemCodeTag with successful fetch ===");
      } catch (e) {
        showErrorToast(message: "Item not found");
        log("Error in fetchTaggingLineItemCodeTag: $e");
      }
    } else {
      log("Not attempting fetch: itemCode empty or tagNumber null");
    }
  }

  void changeWstUnit({required int index}) {
    if (controllers[index].wst_unit == "%") {
      controllers[index].wst_unit = "gm";
    } else {
      controllers[index].wst_unit = "%";
    }
    update();
  }

  void addRow() {
    controllers.add(
      ApprovalItemDetailsTableData(
        sn: (controllers.length + 1).toString(),
        tagging_id: "",
        item_code: TextEditingController(),
        tag_no: TextEditingController(),
        description: TextEditingController(),
        pcs: TextEditingController(),
        gwt: TextEditingController(),
        nwt: TextEditingController(),
        va: TextEditingController(),
        mc: TextEditingController(),
        stone: TextEditingController(),
        hall_mark: TextEditingController(),
      ),
    );
    updateTotals();
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
      updateTotals();
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
  }

  void updateTotals() {
    double totalPcs = 0;
    double totalGWt = 0;
    double totalNWt = 0;

    for (var row in controllers) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gwt.text) ?? 0;
      totalNWt += double.tryParse(row.nwt.text) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      totalPcs.toStringAsFixed(2),
      totalGWt.toStringAsFixed(3),
      totalNWt.toStringAsFixed(3),
      "",
    ];
    update();
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
      updateTotals();
    }
  }

  bool validateRow() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Future<bool> validateAndCleanRows() async {
    try {
      // Remove rows where essential fields are empty
      controllers.removeWhere((element) => element.isEmpty());

      // If no valid rows remain, show error and add a new row
      if (controllers.isEmpty) {
        addRow();
        return false;
      }

      // Update serial numbers
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].sn = (i + 1).toString();
      }

      // Reset current indices to safe values
      currentRowIndex.value = controllers.isEmpty ? 0 : controllers.length - 1;
      currentColIndex.value = 0;

      // Focus on the current row and column if controllers exist
      if (controllers.isNotEmpty) {
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
      }

      // Wait for the next frame to ensure widget has rebuilt
      await Future.delayed(const Duration(milliseconds: 100));

      // Additional validation of required fields
      for (var row in controllers) {
        if (row.item_code.text.isEmpty || row.tag_no.text.isEmpty) {
          return false;
        }
      }

      updateTotals();
      return true;
    } catch (e, s) {
      log("Error in validateAndCleanRows: $e\n$s");
      return false;
    }
  }

  void showMoreOptions(int rowIndex) {
    Get.dialog(
      AlertDialog(
        title: Text('Options for Row ${rowIndex + 1}'),
        content: const Text('Add your custom options here.'),
        actions: <Widget>[
          TextButton(child: const Text('Close'), onPressed: () => Get.back()),
        ],
      ),
    );
  }

  void showStoneDialog(int rowIndex) {
    List<StoneDetailsTableData> currentValue =
        (controllers[rowIndex].stoneDetailsTableData);
    // log("The current values are : ${currentValue.first.toJsonValue()}");
    Get.dialog(
      StoneDetailsDialog(
        initialStoneValue: currentValue,
        onSave: (totalValue, stoneDetailsValue) {
          controllers[rowIndex].stone.text = totalValue.toStringAsFixed(2);
          controllers[rowIndex].stoneDetailsTableData = stoneDetailsValue;
          log("The Details will be : ${controllers[rowIndex].toJsonValue()}");
          // updateRowAmount(rowIndex);
          // calculateAmount(rowIndex);
        },
      ),
    );

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
    if (currentColIndex.value <
        controllers[currentRowIndex.value].tableFocusNodes.length - 1) {
      currentColIndex.value++;
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex.value < controllers.length - 1) {
      currentRowIndex.value++;
      currentColIndex.value = 0;
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      // This is the last field of the last row, so add a new row
      addRow();

      // Now move focus to the first field of the new row
      currentRowIndex.value = controllers.length - 1;
      currentColIndex.value = 0;
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
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
      // Get.snackbar(
      //   'Cannot Remove',
      //   'Cannot remove the last row.',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
    controllers.refresh();
  }

  void resetRow(int index) {
    // Keep the original serial number
    String originalSn = controllers[index].sn;
    String originalTaggingId = controllers[index].tagging_id;

    // Reset all text controllers
    controllers[index].item_code.clear();
    controllers[index].tag_no.clear();
    controllers[index].description.clear();
    controllers[index].pcs.clear();
    controllers[index].gwt.clear();
    controllers[index].nwt.clear();
    controllers[index].va.clear();
    controllers[index].mc.clear();
    controllers[index].stone.clear();
    controllers[index].hall_mark.clear();

    // Reset other properties to initial values
    controllers[index].gst = "0";
    controllers[index].wst_unit = "%";
    controllers[index].images = [];

    // Clear stone details
    controllers[index].stoneDetailsTableData.clear();

    // Keep the original serial number and tagging_id
    controllers[index].sn = originalSn;
    controllers[index].tagging_id = originalTaggingId;

    // Update totals since we've reset values
    updateTotals();
    update();
  }

  void clearControllers() {
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.clear();
    addRow();
    updateTotals();
  }
}
