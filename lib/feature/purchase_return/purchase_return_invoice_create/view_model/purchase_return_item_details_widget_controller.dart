// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/widgets/stone_details_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ItemDetailsTableData {
  String sn;
  TextEditingController code;
  String codeId;
  String ornament_name;
  String hsn_sac;
  String hsn_sac_type;
  String ornament_metal_type;
  TextEditingController item_description;
  String gst;
  TextEditingController pcs;
  TextEditingController gwt;
  TextEditingController less;
  TextEditingController nwt;
  TextEditingController wst;
  TextEditingController mc;
  TextEditingController stone;
  TextEditingController rate;
  TextEditingController amount;

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

  ItemDetailsTableData({
    required this.sn,
    required this.code,
    required this.item_description,
    required this.hsn_sac,
    required this.hsn_sac_type,
    required this.ornament_metal_type,
    required this.pcs,
    required this.gwt,
    required this.less,
    required this.nwt,
    required this.wst,
    required this.mc,
    required this.stone,
    required this.rate,
    required this.amount,
    this.gst = "0",
    required this.codeId,
    required this.ornament_name,
  }) : tableFocusNodes = List.generate(10, (_) => FocusNode()) {
    tableFocusNodes[9].addListener(_onAmountFocus);
  }
  void _onAmountFocus() {
    if (tableFocusNodes[9].hasFocus) {
      amount.selection = TextSelection(
        baseOffset: 0,
        extentOffset: amount.text.length,
      );
    }
  }

  void dispose() {
    tableFocusNodes[9].removeListener(_onAmountFocus);
    for (var node in tableFocusNodes) {
      node.dispose();
    }
  }

  Map<String, dynamic> toJsonValue() {
    return {
      'sn': sn,
      'code': code.text,
      'codeId': codeId,
      'ornament_name': ornament_name,
      'item_description': item_description.text,
      "hsc_sac": hsn_sac,
      'hsn_sac_type': hsn_sac_type,
      'ornament_metal_type': ornament_metal_type,
      'pcs': pcs.text,
      'gwt': gwt.text,
      'less': less.text,
      'nwt': nwt.text,
      'wst': wst.text,
      'mc': mc.text,
      'stone': stone.text,
      'rate': rate.text,
      'amount': amount.text,
      'wst_unit': wst_unit,
      'stone_details':
          stoneDetailsTableData.map((stone) => stone.toJsonValue()).toList(),
    };
  }
}

class PurchaseReturnItemDetailsController extends GetxController {
  final headers = [
    'Sn',
    'Ornament',
    // 'Ornament Type',
    'Pcs',
    'G.Wt. (gm)',
    'Less',
    'N.Wt. (gm)',
    'WST/Tch',
    'MC (₹)',
    'Stone (₹)',
    'Rate (₹)',
    'Amount (₹)',
    '',
  ];

  final columnWidths = [
    0.1,
    1.035,
    // 0.73,
    0.2,
    0.3,
    0.3,
    0.3,
    0.3,
    0.2,
    0.3,
    0.3,
    0.3,
    0.1,
  ];

  final totalColumnWidths = [
    1.14,
    0.2,
    0.3,
    0.3,
    0.3,
    0.3,
    0.2,
    0.3,
    0.3,
    0.3,
    0.1,
  ];

  List<String> popUpValues = ["Payment", "Return", "Edit", "Delete"];
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<ItemDetailsTableData> controllers = <ItemDetailsTableData>[].obs;
  final RxList<String> totalHeadersValue = <String>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final InventoryViewmodel _inventoryViewmodel = Get.put(InventoryViewmodel());

  @override
  void onInit() {
    super.onInit();
    getCodeList();
    addRow();
    updateTotals();
  }

  Future<void> getCodeList() async {
    await _inventoryViewmodel.getAllOrnaments(isService: false);

    codeList.assignAll(
      _inventoryViewmodel.getAllOrnamentsResponse.value.data?.values ?? [],
    );
  }

  void setItemDescription(int index, String code) {
    GetAllOrnamentsResponseValue value = codeList.firstWhere(
      (item) => item.code == code,
    );
    controllers[index].item_description.text = value.name ?? "";
    controllers[index].gst = value.gst ?? "0";
    controllers[index].codeId = value.id ?? "";
    controllers[index].ornament_name = value.name ?? "";
    controllers[index].hsn_sac = value.hsnSac ?? "";
    controllers[index].hsn_sac_type = value.metalType?.codeType ?? "";
    controllers[index].ornament_metal_type = value.metalType?.typeName ?? "";
    update();
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
      ItemDetailsTableData(
        sn: (controllers.length + 1).toString(),
        code: TextEditingController(),
        codeId: "",
        ornament_name: "",
        item_description: TextEditingController(),
        hsn_sac: "",
        hsn_sac_type: "",
        ornament_metal_type: "",
        pcs: TextEditingController(),
        gwt: TextEditingController(),
        less: TextEditingController(),
        nwt: TextEditingController(),
        wst: TextEditingController(),
        mc: TextEditingController(),
        stone: TextEditingController(),
        rate: TextEditingController(),
        amount: TextEditingController(),
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
    double totalLess = 0;
    double totalNWt = 0;
    double totalVATch = 0;
    double totalMC = 0;
    double totalStone = 0;
    double totalRate = 0;
    double totalAmount = 0;

    for (var row in controllers) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gwt.text) ?? 0;
      totalLess += double.tryParse(row.less.text) ?? 0;
      totalNWt += double.tryParse(row.nwt.text) ?? 0;
      totalVATch += double.tryParse(row.wst.text) ?? 0;
      totalMC += double.tryParse(row.mc.text) ?? 0;
      totalStone += double.tryParse(row.stone.text) ?? 0;
      totalRate += double.tryParse(row.rate.text) ?? 0;
      totalAmount += double.tryParse(row.amount.text) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      totalPcs.toStringAsFixed(3),
      totalGWt.toStringAsFixed(3),
      totalLess.toStringAsFixed(3),
      totalNWt.toStringAsFixed(3),
      totalVATch.toStringAsFixed(3),
      totalMC.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      totalRate.toStringAsFixed(2),
      totalAmount.toStringAsFixed(2),
      "",
    ];
    update();
  }

  void updateRowAmount(int index) {
    double amount = calculateAmount(index);
    controllers[index].amount.text = amount.toStringAsFixed(2);
    log("updating row amount : $amount");
    updateTotals();
  }

  double calculateAmount(int index) {
    // double pcs = double.tryParse(controllers[index].pcs.text) ?? 0;
    double nWt = double.tryParse(controllers[index].nwt.text) ?? 0;
    double rate = double.tryParse(controllers[index].rate.text) ?? 0;
    double wst = double.tryParse(controllers[index].wst.text) ?? 100;
    double mc = double.tryParse(controllers[index].mc.text) ?? 0;
    double stone = double.tryParse(controllers[index].stone.text) ?? 0;
    log("the values are : $nWt $rate $wst $mc $stone");
    if (controllers[index].wst_unit == "%") {
      return (nWt * (wst / 100) * rate) + mc + stone;
    } else {
      return ((nWt + (wst)) * rate) + mc + stone;
    }
  }

  void calculateNetWeight(int index) {
    double gwt = double.tryParse(controllers[index].gwt.text) ?? 0;
    double less = double.tryParse(controllers[index].less.text) ?? 0;

    if (less > gwt) {
      controllers[index].less.text = gwt.toStringAsFixed(3);
      less = gwt;
      showErrorToast(message: 'Less value cannot be greater than Gross Weight');
    }

    double netWeight = gwt - less;
    controllers[index].nwt.text = netWeight.toStringAsFixed(3);
    updateRowAmount(index);
    updateTotals();
  }

  void calculateLess(int index) {
    double gwt = double.tryParse(controllers[index].gwt.text) ?? 0;
    double nwt = double.tryParse(controllers[index].nwt.text) ?? 0;

    if (nwt > gwt) {
      controllers[index].nwt.text = gwt.toStringAsFixed(3);
      nwt = gwt;
      showErrorToast(message: 'Net Weight cannot be greater than Gross Weight');
    }

    double less = gwt - nwt;
    controllers[index].less.text = less.toStringAsFixed(3);
    updateRowAmount(index);
    updateTotals();
  }

  void calculateRateFromAmount(int index) {
    double amount = double.tryParse(controllers[index].amount.text) ?? 0;
    double nWt = double.tryParse(controllers[index].nwt.text) ?? 0;
    double wst = double.tryParse(controllers[index].wst.text) ?? 100;
    double mc = double.tryParse(controllers[index].mc.text) ?? 0;
    double stone = double.tryParse(controllers[index].stone.text) ?? 0;

    if (nWt <= 0) {
      return; // Can't calculate rate without weight
    }

    double rate;
    if (controllers[index].wst_unit == "%") {
      // Rearranging the formula: amount = (nWt * (wst/100) * rate) + mc + stone
      // So: rate = (amount - mc - stone) / (nWt * (wst/100))
      double wstMultiplier = wst / 100;
      rate = (amount - mc - stone) / (nWt * wstMultiplier);
    } else {
      // Rearranging the formula: amount = ((nWt + wst) * rate) + mc + stone
      // So: rate = (amount - mc - stone) / (nWt + wst)
      rate = (amount - mc - stone) / (nWt + wst);
    }

    // Update rate field if calculation is valid
    if (rate.isFinite && rate > 0) {
      controllers[index].rate.text = rate.toStringAsFixed(2);
    }

    update();
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
      updateTotals();
    }
  }

  Future<bool> validateRow() async {
    try {
      // Remove rows where essential fields are empty
      controllers.removeWhere(
        (element) =>
            element.code.text.isEmpty ||
            (element.pcs.text.isEmpty &&
                element.gwt.text.isEmpty &&
                element.less.text.isEmpty &&
                element.nwt.text.isEmpty &&
                element.wst.text.isEmpty &&
                element.mc.text.isEmpty &&
                element.stone.text.isEmpty &&
                element.rate.text.isEmpty &&
                element.amount.text.isEmpty),
      );

      // Reset current indices to safe values
      currentRowIndex.value = controllers.isEmpty ? 0 : controllers.length - 1;
      currentColIndex.value = 0;

      // Focus on the current row and column if controllers exist
      if (controllers.isNotEmpty) {
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
      }

      // If no valid rows remain, show error and add a new row
      if (controllers.isEmpty) {
        showErrorToast(message: "At least one row with values is required");
        addRow();
        return false;
      }

      // Wait for the next frame to ensure widget has rebuilt
      await Future.delayed(const Duration(milliseconds: 100));

      // Validate the form
      if (formKey.currentState!.validate() == false) {
        showErrorToast(message: "Please fill all required fields");
        return false;
      }

      updateTotals();
      return true;
    } catch (e, s) {
      log("Error in validateRow: $e\n$s");
      showErrorToast(message: "An error occurred while validating the form");
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
      barrierDismissible: false,
      StoneDetailsDialog(
        initialStoneValue: currentValue,
        onSave: (totalValue, stoneDetailsValue) {
          controllers[rowIndex].stone.text = totalValue.toStringAsFixed(2);
          controllers[rowIndex].stoneDetailsTableData = stoneDetailsValue;
          log("The Details will be : ${controllers[rowIndex].toJsonValue()}");
          updateRowAmount(rowIndex);
          calculateAmount(rowIndex);
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
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
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

  void clearControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.clear();
    addRow();
    updateTotals();
  }

  void resetRow(int index) {
    // Keep the original serial number
    String originalSn = controllers[index].sn;

    // Reset all text controllers
    controllers[index].code.clear();
    controllers[index].item_description.clear();
    controllers[index].pcs.clear();
    controllers[index].gwt.clear();
    controllers[index].less.clear();
    controllers[index].nwt.clear();
    controllers[index].wst.clear();
    controllers[index].mc.clear();
    controllers[index].stone.clear();
    controllers[index].rate.clear();
    controllers[index].amount.clear();

    // Reset other properties to initial values
    controllers[index].codeId = "";
    controllers[index].ornament_name = "";
    controllers[index].hsn_sac = "";
    controllers[index].hsn_sac_type = "";
    controllers[index].ornament_metal_type = "";
    controllers[index].gst = "0";
    controllers[index].wst_unit = "%";

    // Clear stone details
    controllers[index].stoneDetailsTableData.clear();

    // Keep the original serial number
    controllers[index].sn = originalSn;

    // Update totals since we've reset values
    updateTotals();
    update();
  }
}
