// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CreateRepairItemDetailsTableData {
  String sn;

  TextEditingController item_description;
  TextEditingController size;
  TextEditingController purity;
  TextEditingController nwt;
  String gst;

  TextEditingController amount;

  List<FocusNode> tableFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  CreateRepairItemDetailsTableData({
    required this.sn,
    required this.item_description,
    required this.size,
    required this.purity,
    required this.nwt,
    required this.gst,
    required this.amount,
  });
  Map<String, dynamic> toJsonValue() {
    return {
      'sn': sn,
      'item_description': item_description.text,
      'size': size.text,
      'purity': purity.text,
      'nwt': nwt.text,
      'amount': amount.text,
    };
  }
}

class CreateRepairItemDetailsController extends GetxController {
  final headers = [
    'Sn',
    'Item Description',
    'Size',
    'Purity',
    'N.Wt. (gm)',
    'Amount (₹)',
    '',
  ];

  final columnWidths = [0.1, 0.7, 0.7, 0.7, 0.7, 0.7, 0.1];

  final totalColumnWidths = [
    //   1.14,
    //   0.2,
    //   0.3,
    //   0.3,
    //   0.3,
    //   0.3,
    //   0.2,
    //   0.3,
    //   0.3,
    2.9,
  ];

  List<String> popUpValues = ["Payment", "Return", "Edit", "Delete"];

  final InventoryRepository _inventoryRepository = InventoryRepository();

  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<CreateRepairItemDetailsTableData> controllers =
      <CreateRepairItemDetailsTableData>[].obs;

  final getPurityResponse = Rx<ApiResponse<GetPurityResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxList<String> totalHeadersValue = <String>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final InventoryViewmodel _inventoryViewmodel = Get.put(InventoryViewmodel());

  @override
  void onInit() {
    super.onInit();
    getCodeList();
    getPurityDetails();

    addRow();
    updateTotals();
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

  Future<void> getCodeList() async {
    await _inventoryViewmodel.getAllOrnaments();

    codeList.assignAll(
      _inventoryViewmodel.getAllOrnamentsResponse.value.data?.values ?? [],
    );
  }

  void addRow() {
    controllers.add(
      CreateRepairItemDetailsTableData(
        sn: (controllers.length + 1).toString(),
        item_description: TextEditingController(),
        size: TextEditingController(),
        purity: TextEditingController(),
        nwt: TextEditingController(),
        gst: "",
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
    double totalAmount = 0;

    for (var row in controllers) {
      totalAmount += double.tryParse(row.amount.text) ?? 0;
    }

    totalHeadersValue.value = ["Total", totalAmount.toStringAsFixed(2), ""];
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
      updateTotals();
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      Get.snackbar(
        'Cannot Remove',
        'Cannot remove the last row.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    controllers.refresh();
  }

  void requestFirstFocus() {
    if (controllers.isNotEmpty) {
      currentRowIndex.value = 0;
      currentColIndex.value = 0;
      controllers[0].tableFocusNodes[0].requestFocus();
    }
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
