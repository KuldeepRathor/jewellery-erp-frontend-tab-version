import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/calculator/estimation_calculator.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesReturnItemDetailsTableData {
  bool isSelected;
  String sn;
  TextEditingController code;
  TextEditingController tagNo;
  TextEditingController item_description; // Changed to TextEditingController

  TextEditingController pcs; // Changed to TextEditingController
  TextEditingController gwt; // Changed to TextEditingController
  TextEditingController nwt; // Changed to TextEditingController
  TextEditingController va;
  double originalVa;
  TextEditingController mc;
  double originalMc;
  TextEditingController stone; // Changed to TextEditingController
  TextEditingController hallMark; // Changed to TextEditingController
  TextEditingController costDiscount;
  TextEditingController salesAmount; // Changed to TextEditingController
  TextEditingController total; // Changed to TextEditingController
  String gst;
  List<String> images = [];

  double originalGwt;
  double originalNwt;

  String wst_unit = "%"; // will be either "%" or "gm";
  List<StoneDetailsTableData> stoneDetailsTableData = [];

  GetSalesRecordByIdAggregateResponseLineItem? itemResponse;

  List<FocusNode> tableFocusNodes = [
    FocusNode(), // For Item Code
    FocusNode(), // For Tag No
    FocusNode(), // For VA
    FocusNode(), // For MC
    FocusNode(), // For Cost Discount
    FocusNode(), // For Pcs
    FocusNode(), // For G.Wt
    FocusNode(), // For N.Wt
    FocusNode(), // For Stone
    FocusNode(), // For Hall Mark
    FocusNode(), // For Sales Amount
    FocusNode(), // For Total
  ];

  SalesReturnItemDetailsTableData({
    required this.isSelected,
    required this.sn,
    required this.code,
    required this.tagNo,
    required String item_description,
    required String pcs,
    required String gwt,
    required String nwt,
    required this.va,
    required this.mc,
    required String stone,
    required String hallMark,
    required this.costDiscount,
    required String salesAmount,
    required String total,
    required this.originalMc,
    required this.originalVa,
    required this.originalGwt,
    required this.originalNwt,
    this.gst = "0",
    this.images = const [],
    this.itemResponse,
  }) : item_description = TextEditingController(text: item_description),
       pcs = TextEditingController(text: pcs),
       gwt = TextEditingController(text: gwt),
       nwt = TextEditingController(text: nwt),
       stone = TextEditingController(text: stone),
       hallMark = TextEditingController(text: hallMark),
       salesAmount = TextEditingController(text: salesAmount),
       total = TextEditingController(text: total);

  Map<String, dynamic> toJsonValue() {
    return {
      "sn": sn,
      "code": code.text,
      "tagNo": tagNo.text,
      "item_description": item_description.text,
      "pcs": pcs.text,
      "gwt": gwt.text,
      "nwt": nwt.text,
      "va": va.text,
      "mc": mc.text,
      "stone": stone.text,
      "hallMark": hallMark.text,
      "costDiscount": costDiscount.text,
      "salesAmount": salesAmount.text,
      "total": total.text,
      'stone_details':
          stoneDetailsTableData.map((stone) => stone.toJsonValue()).toList(),
    };
  }
}

class SalesReturnItemDetailsController extends GetxController {
  // final InventoryRepository _inventoryRepository = InventoryRepository();
  final headers = [
    "Select",
    'Sn',
    'Item Code',
    'Tag No',
    "Description",
    'Pcs',
    'G.Wt. (gm)',
    'N.Wt. (gm)',
    'VA',
    'MC (₹)',
    'Stone Cost(₹)',
    'Hall Mark',
    'Cost Discount',
    'Sales Amount',
    'Total',
    '',
  ];

  final columnWidths = [
    0.2,
    0.1,
    0.2,
    0.2,
    0.2,
    0.2,
    0.3,
    0.3,
    0.3,
    0.2,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.1,
  ];

  final totalColumnWidths = [
    0.9,
    0.2,
    0.3,
    0.3,
    0.3,
    0.2,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.1,
  ];

  List<String> popUpValues = ["View", "Return", "Edit", "Delete"];
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<SalesReturnItemDetailsTableData> controllers =
      <SalesReturnItemDetailsTableData>[].obs;
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
    addRow();
    updateTotals();
  }

  void addRow() {
    controllers.add(
      SalesReturnItemDetailsTableData(
        isSelected: false,
        sn: (controllers.length + 1).toString(),
        code: TextEditingController(),
        tagNo: TextEditingController(),
        item_description: "",
        pcs: "0",
        gwt: "0",
        nwt: "0",
        va: TextEditingController(text: "0"),
        mc: TextEditingController(text: "0"),
        stone: "0",
        hallMark: "0",
        costDiscount: TextEditingController(text: "0"),
        salesAmount: "0",
        total: "0",
        originalMc: 0,
        originalVa: 0,
        originalGwt: 0,
        originalNwt: 0,
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

  bool hasNoSalesPerson() {
    // Check only selected items
    return controllers
        .where((controller) => controller.isSelected)
        .any((controller) => controller.itemResponse?.salesPerson == null);
  }

  void getLatestRowInFocus() {
    controllers.last.tableFocusNodes.first.requestFocus();
    currentRowIndex.value = controllers.length - 1;
    currentColIndex.value = 0;
  }

  void updateTotals() {
    double totalPcs = 0;
    double totalGWt = 0;
    double totalNWt = 0;
    double totalVATch = 0;
    double totalMC = 0;
    double totalStone = 0;
    double hallMark = 0;
    double costDiscount = 0;
    double salesAmount = 0;
    double totalAmount = 0;

    for (var row in controllers.where((element) => element.isSelected)) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gwt.text) ?? 0;
      totalNWt += double.tryParse(row.nwt.text) ?? 0;
      totalVATch += double.tryParse(row.va.text) ?? 0;
      totalMC += double.tryParse(row.mc.text) ?? 0;
      totalStone += double.tryParse(row.stone.text) ?? 0;
      hallMark += double.tryParse(row.hallMark.text) ?? 0;
      costDiscount += double.tryParse(row.costDiscount.text) ?? 0;
      salesAmount += double.tryParse(row.salesAmount.text) ?? 0;
      totalAmount += double.tryParse(row.total.text) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      totalPcs.toStringAsFixed(2),
      totalGWt.toStringAsFixed(2),
      totalNWt.toStringAsFixed(2),
      totalVATch.toStringAsFixed(2),
      totalMC.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      hallMark.toStringAsFixed(2),
      costDiscount.toStringAsFixed(2),
      salesAmount.toStringAsFixed(2),
      totalAmount.toStringAsFixed(2),
      "",
    ];
    // SalesReturnSearchPartyController salesReturnSearchPartyController =
    //     Get.find<SalesReturnSearchPartyController>();

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
      // validateAndAddRow();
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
    addRow();
    // updateTotals();
  }

  // Calculate sales amount and total based on other values
  void calculateSalesAndTotalAmount({required int index}) {
    final row = controllers[index];

    // Get all necessary values for calculation
    double va = double.tryParse(row.va.text) ?? 0;
    double mc = double.tryParse(row.mc.text) ?? 0;
    double stone = double.tryParse(row.stone.text) ?? 0;
    double hallMark = double.tryParse(row.hallMark.text) ?? 0;
    double costDiscount = double.tryParse(row.costDiscount.text) ?? 0;

    // Calculate sales amount (sum of VA, MC, Stone Cost, and Hall Mark)
    double salesAmount = va + mc + stone + hallMark;

    // Calculate total (sales amount minus cost discount)
    double total = salesAmount - costDiscount;

    // Update the text controllers
    row.salesAmount.text = salesAmount.toStringAsFixed(2);
    row.total.text = total.toStringAsFixed(2);

    // Update the UI
    controllers.refresh();
    updateTotals();
  }

  void addToControllersFromEstimateNumberApi({
    required GetSalesRecordByIdAggregateResponse response,
  }) {
    List<SalesReturnItemDetailsTableData> dataList = [];
    int index = 0;

    for (GetSalesRecordByIdAggregateResponseLineItem element
        in response.lineItems ?? []) {
      List<String> combinedImages = [
        ...(element.taggingRecord?.images?.map(
              (image) => image.presignedUrl ?? '',
            ) ??
            []),
        ...(element.taggingRecord?.design?.images?.map(
              (image) => image.presignedUrl ?? '',
            ) ??
            []),
      ];

      double originalGwtValue =
          double.tryParse(element.taggingGrossWeight ?? "0") ?? 0;
      double originalNwtValue =
          double.tryParse(element.taggingNetWeight ?? "0") ?? 0;
      double originalVaValue = double.tryParse(element.finalVa ?? "0") ?? 0;
      double originalMcValue = double.tryParse(element.finalMc ?? "0") ?? 0;

      SalesReturnItemDetailsTableData data = SalesReturnItemDetailsTableData(
        sn: index.toString(),
        isSelected: false,
        code: TextEditingController(text: element.code ?? ""),
        tagNo: TextEditingController(text: element.tag?.toString() ?? ""),
        item_description: element.taggingRecord?.design?.name ?? "",
        pcs: element.taggingPieces?.toString() ?? "0",
        gwt: element.taggingGrossWeight ?? "0",
        nwt: element.taggingNetWeight ?? "0",
        va: TextEditingController(text: element.finalVa ?? "0"),
        mc: TextEditingController(text: element.finalMc ?? "0"),
        stone:
            element.taggingRecord?.lineStones
                ?.fold<double>(
                  0,
                  (sum, stone) =>
                      sum + (double.tryParse(stone.total ?? '0') ?? 0),
                )
                .toString() ??
            '0',
        hallMark:
            element.taggingRecord?.design?.stockHead?.hallmarkExtraCharge ??
            '0',
        costDiscount: TextEditingController(text: element.discount),
        salesAmount: element.salesAmount ?? "0",
        total: element.totalAmount ?? "0",
        originalMc: originalMcValue,
        originalVa: originalVaValue,
        originalGwt: originalGwtValue,
        originalNwt: originalNwtValue,
        gst: element.taggingRecord?.designLineItem?.ornament?.gst ?? "0",
        itemResponse: element,
        images: combinedImages,
      );
      data.stoneDetailsTableData =
          element.taggingRecord?.lineStones
              ?.map(
                (e) => StoneDetailsTableData(
                  id: e.id,
                  name: TextEditingController(text: e.name),
                  carat_weight: TextEditingController(
                    text: e.carat ?? e.weight,
                  ),
                  pcs: TextEditingController(text: e.pieces.toString()),
                  rate: TextEditingController(text: e.rate),
                  total: TextEditingController(text: e.total),
                  weightUnitFromBackend: e.carat == null ? "gm" : "CT",
                ),
              )
              .toList() ??
          [];
      dataList.add(data);
      index++;
    }

    // Assuming you want to update the controllers list
    controllers.clear();
    controllers.addAll(dataList);
    controllers.refresh();
    updateTotals();
    update();
    getLatestRowInFocus();
  }

  bool validateCorrectionModeValue(String? header, String value, int rowIndex) {
    final SalesReturnViewmodel salesReturnViewmodel =
        Get.find<SalesReturnViewmodel>();

    // Only validate in correction mode (when isFastMode is false)
    if (salesReturnViewmodel.isFastMode.value) {
      return true;
    }

    if (value.isEmpty) return true;

    double? enteredValue = double.tryParse(value);
    if (enteredValue == null) return false;

    final rowData = controllers[rowIndex];

    switch (header) {
      case 'G.Wt. (gm)':
        return enteredValue <= rowData.originalGwt;
      case 'N.Wt. (gm)':
        return enteredValue <= rowData.originalNwt;
      case 'VA':
        return enteredValue <= rowData.originalVa;
      case 'MC (₹)':
        return enteredValue <= rowData.originalMc;
      default:
        return true;
    }
  }

  String? getCorrectionModeErrorMessage(
    String? header,
    String value,
    int rowIndex,
  ) {
    final SalesReturnViewmodel salesReturnViewmodel =
        Get.find<SalesReturnViewmodel>();

    // Only show error in correction mode
    if (salesReturnViewmodel.isFastMode.value) {
      return null;
    }

    if (value.isEmpty) return null;

    double? enteredValue = double.tryParse(value);
    if (enteredValue == null) return 'Please enter a valid number';

    final rowData = controllers[rowIndex];

    switch (header) {
      case 'G.Wt. (gm)':
        if (enteredValue > rowData.originalGwt) {
          return 'Cannot exceed original value: ${rowData.originalGwt}';
        }
        break;
      case 'N.Wt. (gm)':
        if (enteredValue > rowData.originalNwt) {
          return 'Cannot exceed original value: ${rowData.originalNwt}';
        }
        break;
      case 'VA':
        if (enteredValue > rowData.originalVa) {
          return 'Cannot exceed original value: ${rowData.originalVa}';
        }
        break;
      case 'MC (₹)':
        if (enteredValue > rowData.originalMc) {
          return 'Cannot exceed original value: ${rowData.originalMc}';
        }
        break;
    }

    return null;
  }

  JewelryCalculationReport calculateJewelryPricing(int index) {
    final item = controllers[index];

    // Get values from the controllers
    double nettWeight = double.tryParse(item.nwt.text) ?? 0;
    double grossWeight = double.tryParse(item.gwt.text) ?? 0;
    double metalRate = double.tryParse(item.itemResponse?.rate ?? "") ?? 0;
    double stoneCost = double.tryParse(item.stone.text) ?? 0;
    double hallMarkCost = double.tryParse(item.hallMark.text) ?? 0;
    double costDiscount = double.tryParse(item.costDiscount.text) ?? 0;

    // Determine VA type and value
    String? wastageType =
        item.itemResponse?.taggingRecord?.designLineItem?.wastageType;
    VAType vaType = getVAType(wastageType);

    // The VA value depends on the type - use what's in the text field, which should be either percentage or grams
    double vaValue = double.tryParse(item.va.text) ?? 0;

    // Determine MC type and value
    String? mcType =
        item.itemResponse?.taggingRecord?.designLineItem?.makingChargesType;
    MCType mcTypeEnum = getMCType(mcType);
    double mcValue = double.tryParse(item.mc.text) ?? 0;

    // Get GST information
    bool isGstApplicable =
        true; // You may need to adjust this based on your business logic
    double gstPercentage = (double.tryParse(item.gst) ?? 0);

    // Create calculator instance
    JewelryCalculator calculator = JewelryCalculator(
      nettWeight: nettWeight,
      vaType: vaType,
      vaValue: vaValue,
      metalRate: metalRate,
      grossWeight: grossWeight,
      mcType: mcTypeEnum,
      mcValue: mcValue,
      stoneCost: stoneCost + hallMarkCost,
      // Combining stone cost and hallmark as "additional costs"
      isGstApplicable: isGstApplicable,
      gstPercentage: gstPercentage,
      printGstInVA: false,
      // Adjust as needed
      costDiscount: costDiscount,
    );

    // Generate the calculation report
    return calculator.generateReport();
  }
}
