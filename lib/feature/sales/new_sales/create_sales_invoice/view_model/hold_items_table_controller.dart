// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

// import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class HoldItemDetailsTableData {
  String sn;
  String code;

  String item_description;
  String nwt;
  String totalAmount;
  CreateSalesItemDetailsTableData createSalesItemDetailsTableData;

  // GetTaggingLineItemCodeTagResponse? itemResponse;
  bool isSelected;
  List<FocusNode> tableFocusNodes = [];

  HoldItemDetailsTableData({
    required this.sn,
    required this.code,
    required this.item_description,
    required this.nwt,
    required this.totalAmount,
    // required this.itemResponse,
    required this.isSelected,
    required this.createSalesItemDetailsTableData,
  });
  Map<String, dynamic> toJsonValue() {
    return {
      "sn": sn,
      "code": code,
      "item_description": item_description,
      "nwt": nwt,
      "salesAmount": totalAmount,
    };
  }
}

class AddMoreItemClass {
  final String itemDescription;
  final String netWeight;

  AddMoreItemClass({required this.itemDescription, required this.netWeight});
}

class HoldItemDetailsController extends GetxController {
  // final InventoryRepository _inventoryRepository = InventoryRepository();
  final headers = [
    "Select",
    'Sn',
    'Item Code',
    // 'Tag No',
    "Description",
    // 'Pcs',
    // 'G.Wt. (gm)',
    'N.Wt. (gm)',
    // 'VA',
    // 'MC (₹)',
    // 'Stone Cost(₹)',
    // 'Hall Mark',
    // 'Cost Discount',
    'Total Amount',
    // 'Total',
    '',
  ];

  final columnWidths = [0.2, 0.2, 0.4, 0.8, 0.8, 1.0, 0.2];

  final totalColumnWidths = [1.6, 0.8, 1.0, 0.2];

  List<String> popUpValues = ["View", "Return", "Edit", "Delete"];
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<HoldItemDetailsTableData> controllers =
      <HoldItemDetailsTableData>[].obs;
  final RxList<String> totalHeadersValue = <String>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isItemDetailsVisible = false.obs;
  void showItemDetails({required int index}) {
    currentRowIndex.value = index;
    isItemDetailsVisible.value = true;
  }

  void hideItemDetails() {
    isItemDetailsVisible.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    // fetchTaggingLineItemCodeTag();
    // addRow();
    updateTotals();
  }

  void initializeValues() {
    CreateSalesItemDetailsController createSalesItemDetailsController =
        Get.find<CreateSalesItemDetailsController>();
    log(
      "Initializing controller values ${createSalesItemDetailsController.controllers}",
    );

    controllers.clear();
    for (var element in createSalesItemDetailsController.controllers) {
      log("The element is ${element.toJsonValue()}");
      controllers.add(
        HoldItemDetailsTableData(
          sn: element.sn,
          code: "${element.code.text} - ${element.tagNo.text}",
          item_description: element.item_description.text,
          nwt: element.nwt.text,
          totalAmount: element.total,
          isSelected: false,
          createSalesItemDetailsTableData: element,
          // itemResponse: element.itemResponse,
        ),
      );
    }

    controllers.refresh();
    updateTotals();
    log("Initializing controller values $controllers");
  }

  // void addRow() {
  //   controllers.add(HoldItemDetailsTableData(
  //     sn: (controllers.length + 1).toString(),
  //     code: TextEditingController(),
  //     item_description: "",
  //     pcs: "",
  //     gwt: "",
  //     nwt: "",
  //     va: TextEditingController(),
  //     mc: TextEditingController(),
  //     stone: "",
  //     hallMark: "",
  //     costDiscount: TextEditingController(text: "0"),
  //     salesAmount: "",
  //     total: "",
  //     originalMc: 0,
  //     originalVa: 0,
  //   ));
  //   updateTotals();
  // }

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
    double totalNWt = 0;

    for (var row in controllers) {
      totalNWt += double.tryParse(row.nwt) ?? 0;

      totalAmount += double.tryParse(row.totalAmount) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      totalNWt.toStringAsFixed(2),
      totalAmount.toStringAsFixed(2),
      "",
    ];
    update();
  }

  void updateRowAmount(int index) {
    double amount = calculateAmount(index);
    controllers[index].totalAmount = amount.toStringAsFixed(2);
    log("updating row amount : $amount");
    updateTotals();
  }

  double calculateAmount(int index) {
    // double pcs = double.tryParse(controllers[index].pcs.text) ?? 0;
    // double nWt = double.tryParse(controllers[index].nwt.text) ?? 0;
    // double rate = double.tryParse(controllers[index].rate.text) ?? 0;
    // double wst = double.tryParse(controllers[index].wst.text) ?? 100;
    // double mc = double.tryParse(controllers[index].mc.text) ?? 0;
    // double stone = double.tryParse(controllers[index].stone.text) ?? 0;
    // log("the values are : $nWt $rate $wst $mc $stone");
    // if (controllers[index].wst_unit == "%") {
    //   return (nWt * (wst / 100) * rate) + mc + stone;
    // } else {
    //   return ((nWt + (wst)) * rate) + mc + stone;
    // }
    return 0;
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      // addRow();
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

  void clearControllers() {
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.clear();
    holdItems.clear();
    itemDescriptionController.clear();
    netWeightController.clear();
    // addRow();
    updateTotals();
  }

  Future<void> submitHoldingData({required bool isHeld}) async {
    SalesPaymentDetailsController salesPaymentDetailsController =
        Get.find<SalesPaymentDetailsController>();

    try {
      await salesPaymentDetailsController.postAddSaleWithHoldings(
        holdItemsTableDataControllers: controllers.toList(),
        addMoreItems: holdItems.toList(),
        isHeld: isHeld,
      );
      clearControllers();
      // SidebarController sidebarController = Get.find<SidebarController>();
      // sidebarController.popBackSelectedWidget();
      Get.back();
    } catch (e, s) {
      showErrorToast(message: e.toString());
      log("Submit Holding Data Error : $e $s");
    }
  }

  // Add properties for dialog
  final itemDescriptionController = TextEditingController();
  final netWeightController = TextEditingController();
  final holdItems = <AddMoreItemClass>[].obs;
  final dialogFormKey = GlobalKey<FormState>();

  // Add methods for dialog
  void addHoldItem() {
    if (dialogFormKey.currentState!.validate()) {
      holdItems.add(
        AddMoreItemClass(
          itemDescription: itemDescriptionController.text,
          netWeight: netWeightController.text,
        ),
      );

      // Clear the text fields
      itemDescriptionController.clear();
      netWeightController.clear();
    }
  }

  void removeHoldItem(int index) {
    holdItems.removeAt(index);
  }

  void clearHoldItems() {
    holdItems.clear();
    itemDescriptionController.clear();
    netWeightController.clear();
  }

  @override
  void onClose() {
    itemDescriptionController.dispose();
    netWeightController.dispose();
    super.onClose();
  }
}
