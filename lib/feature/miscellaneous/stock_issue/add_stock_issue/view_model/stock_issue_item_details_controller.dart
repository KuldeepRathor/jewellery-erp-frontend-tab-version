// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/widgets/stone_details_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class StockIssueItemDetailsTableData {
  String id;
  String sn;
  TextEditingController item_code;
  String ornamentId;
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

  double originalVa;
  double originalMc;
  TextEditingController costDiscount;
  TextEditingController rate;
  TextEditingController salesAmount;
  String total;

  String wst_unit = "%"; // will be either "%" or "gm";
  List<StoneDetailsTableData> stoneDetailsTableData = [];

  GetTaggingLineItemCodeTagResponse? itemResponse;
  List<FocusNode> tableFocusNodes = List.generate(11, (index) => FocusNode());

  StockIssueItemDetailsTableData({
    required this.id,
    required this.sn,
    required this.item_code,
    required this.ornamentId,
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
    this.originalVa = 0.0,
    this.originalMc = 0.0,
    required this.costDiscount,
    required this.rate,
    required this.salesAmount,
    this.total = "0",
    this.itemResponse,
  });
  Map<String, dynamic> toJsonValue() {
    return {
      'sn': sn,
      'item_code': item_code.text,
      'ornamentId': ornamentId,
      'tag_no': tag_no.text,
      'description': description.text,
      'pcs': pcs.text,
      'gwt': gwt.text,
      'nwt': nwt.text,
      'va': va.text,
      'mc': mc.text,
      'stone': stone.text,
      'hall_mark': hall_mark.text,
      'sales_amount': salesAmount.text,
      'cost_discount': costDiscount.text,
      'rate': rate.text,
      'total': total,
      'stone_details':
          stoneDetailsTableData.map((stone) => stone.toJsonValue()).toList(),
    };
  }
}

class StockIssueItemDetailsController extends GetxController {
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
    // 'Cost Discount',
    'Value',
    // 'Total',
    '',
  ];

  final columnWidths = [
    0.1,
    0.3,
    0.3,
    0.35,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    // 0.3,
    0.1,
  ];

  final totalColumnWidths = [1.05, 0.3, 0.3, 0.6, 0.3, 0.3, 0.3, 0.3];

  List<String> popUpValues = ["View", "Delete"];
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<StockIssueItemDetailsTableData> controllers =
      <StockIssueItemDetailsTableData>[].obs;

  final RateCaratInputController rateController =
      Get.put<RateCaratInputController>(RateCaratInputController());
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
    // getCodeList();
    addRow();
    updateTotals();
  }

  void changeWstUnit({required int index}) {
    if (controllers[index].wst_unit == "%") {
      controllers[index].wst_unit = "gm";
    } else {
      controllers[index].wst_unit = "%";
    }
    update();
  }

  double calculateNetWeightAmount({
    required double netWeight,
    required double currentRate,
    required String designMakingChargeTypeId,
  }) {
    double result;
    switch (designMakingChargeTypeId) {
      case "1":
        result = netWeight * currentRate;
        log("Case 1: netWeight * currentRate = $result");
        return result;
      case "2":
        result = netWeight * currentRate;
        log("Case 2: netWeight * currentRate = $result");
        return result;
      case "3":
        log("Case 3: fixed rate = $currentRate");
        return currentRate;
      case "4":
        log("Case 4: fixed rate = $currentRate");
        return currentRate;
      default:
        result = netWeight * currentRate;
        log("Default case: netWeight * currentRate = $result");
        return result;
    }
  }

  double calculateVAAmount({
    required double costDiscount,
    required double netWeight,
    required double originalVa,
    required String wastageType,
    required double currentRate,
  }) {
    double discount = costDiscount;
    if (wastageType == "%") {
      double vaWeight = netWeight * (originalVa / 100);
      double amount = vaWeight * currentRate;
      return amount - discount;
    } else {
      double vaWeight = originalVa;
      double amount = vaWeight * currentRate;
      return amount - discount;
    }
  }

  double calculateMCAmount({
    required double costDiscount,
    required String mcType,
    required double grossWeight,
    required double netWeight,
    required double originalMc,
  }) {
    double discount = costDiscount;

    if (mcType == "gwt") {
      double amount = grossWeight * originalMc;
      return amount - discount;
    } else if (mcType == "nwt") {
      double amount = netWeight * originalMc;
      return amount - discount;
    } else {
      return originalMc - discount;
    }
  }

  // 1. Add logging to addSalesAndTotalAmount method
  void addSalesAndTotalAmount({required int index}) {
    log("=== START addSalesAndTotalAmount for row $index ===");

    double currentRate = double.tryParse(controllers[index].rate.text) ?? 0;
    log("currentRate: $currentRate");

    // Get required values
    double netWeight = double.tryParse(controllers[index].nwt.text) ?? 0;
    double grossWeight = double.tryParse(controllers[index].gwt.text) ?? 0;
    log("netWeight: $netWeight, grossWeight: $grossWeight");

    // Default value for design making charge type id if not available
    String designMakingChargeTypeId =
        controllers[index].itemResponse?.design?.makingChargeType?.id ?? "1";
    log("designMakingChargeTypeId: $designMakingChargeTypeId");

    // Calculate net weight amount
    double netWeightAmount = calculateNetWeightAmount(
      netWeight: netWeight,
      currentRate: currentRate,
      designMakingChargeTypeId: designMakingChargeTypeId,
    );
    log("netWeightAmount: $netWeightAmount");

    // Get VA amount
    double vaAmount = double.tryParse(controllers[index].va.text) ?? 0;
    log("vaAmount: $vaAmount");

    // Get MC amount
    double mcAmount = double.tryParse(controllers[index].mc.text) ?? 0;
    log("mcAmount: $mcAmount");

    // Get stone amount
    double stoneAmount = double.tryParse(controllers[index].stone.text) ?? 0;
    log("stoneAmount: $stoneAmount");

    // Get hall mark amount
    double hallMarkAmount =
        double.tryParse(controllers[index].hall_mark.text) ?? 0;
    log("hallMarkAmount: $hallMarkAmount");

    // Calculate total before discount
    double subtotal =
        netWeightAmount + vaAmount + mcAmount + stoneAmount + hallMarkAmount;
    log("subtotal before discount: $subtotal");

    // Apply cost discount directly to sales amount
    double costDiscount =
        double.tryParse(controllers[index].costDiscount.text) ?? 0;
    log("costDiscount: $costDiscount");

    double salesAmount = subtotal - costDiscount;
    log("salesAmount after discount: $salesAmount");

    if (salesAmount < 0) {
      showErrorToast(message: "Invalid Discount Amount");
      controllers[index].costDiscount.text = "0";
      salesAmount = subtotal;
      log("salesAmount was negative, reset to: $salesAmount");
    }

    // Calculate GST
    double gst = (double.tryParse(controllers[index].gst) ?? 0) / 100;
    log("gst rate: $gst");

    // Update controllers
    controllers[index].salesAmount.text = salesAmount.toStringAsFixed(2);
    log(
      "controllers[$index].salesAmount set to: ${controllers[index].salesAmount}",
    );

    controllers[index].total = (salesAmount + (salesAmount * gst))
        .toStringAsFixed(2);
    log("controllers[$index].total set to: ${controllers[index].total}");

    log("=== END addSalesAndTotalAmount ===");

    updateTotals();
    update();
    controllers.refresh();
  }

  // 2. Add logging to calculateSalesAndTotalAmountFromFetchedItems method
  void calculateSalesAndTotalAmountFromFetchedItems({required int index}) {
    log(
      "=== START calculateSalesAndTotalAmountFromFetchedItems for row $index ===",
    );

    double currentRate = double.tryParse(controllers[index].rate.text) ?? 0;
    log("currentRate: $currentRate");

    // Get required values
    double netWeight = double.tryParse(controllers[index].nwt.text) ?? 0;
    double grossWeight = double.tryParse(controllers[index].gwt.text) ?? 0;
    log("netWeight: $netWeight, grossWeight: $grossWeight");

    // Calculate net weight amount
    String designMakingChargeTypeId =
        controllers[index].itemResponse?.design?.makingChargeType?.id ?? "1";
    log("designMakingChargeTypeId: $designMakingChargeTypeId");

    double netWeightAmount = calculateNetWeightAmount(
      netWeight: netWeight,
      currentRate: currentRate,
      designMakingChargeTypeId: designMakingChargeTypeId,
    );
    log("netWeightAmount: $netWeightAmount");

    // Calculate VA amount without discount
    String wastageType =
        controllers[index].itemResponse?.designLineItem?.wastageType ?? "%";
    log("wastageType: $wastageType");

    double originalVa = controllers[index].originalVa;
    log("originalVa: $originalVa");

    double vaAmount = calculateVAAmount(
      costDiscount: 0, // No discount applied here
      netWeight: netWeight,
      originalVa: originalVa,
      wastageType: wastageType,
      currentRate: currentRate,
    );
    log("calculated vaAmount: $vaAmount");

    // Calculate MC amount without discount
    String mcType =
        controllers[index].itemResponse?.designLineItem?.makingChargesType ??
        "";
    log("mcType: $mcType");

    double originalMc = controllers[index].originalMc;
    log("originalMc: $originalMc");

    double mcAmount = calculateMCAmount(
      costDiscount: 0, // No discount applied here
      mcType: mcType,
      grossWeight: grossWeight,
      netWeight: netWeight,
      originalMc: originalMc,
    );
    log("calculated mcAmount: $mcAmount");

    // Get stone amount
    double stoneAmount = double.tryParse(controllers[index].stone.text) ?? 0;
    log("stoneAmount: $stoneAmount");

    // Get hall mark amount
    double hallMarkAmount =
        double.tryParse(controllers[index].hall_mark.text) ?? 0;
    log("hallMarkAmount: $hallMarkAmount");

    // Calculate total before discount
    double subtotal =
        netWeightAmount + vaAmount + mcAmount + stoneAmount + hallMarkAmount;
    log("subtotal before discount: $subtotal");

    // Apply cost discount directly to sales amount
    double costDiscount =
        double.tryParse(controllers[index].costDiscount.text) ?? 0;
    log("costDiscount: $costDiscount");

    double salesAmount = subtotal - costDiscount;
    log("salesAmount after discount: $salesAmount");

    if (salesAmount < 0) {
      showErrorToast(message: "Invalid Discount Amount");
      controllers[index].costDiscount.text = "0";
      salesAmount = subtotal;
      log("salesAmount was negative, reset to: $salesAmount");
    }

    // Calculate GST
    double gst = (double.tryParse(controllers[index].gst) ?? 0) / 100;
    log("gst rate: $gst");

    // Update controllers
    controllers[index].va.text = vaAmount.toStringAsFixed(2);
    log(
      "controllers[$index].va.text updated to: ${controllers[index].va.text}",
    );

    controllers[index].mc.text = mcAmount.toStringAsFixed(2);
    log(
      "controllers[$index].mc.text updated to: ${controllers[index].mc.text}",
    );

    controllers[index].salesAmount.text = salesAmount.toStringAsFixed(2);
    log(
      "controllers[$index].salesAmount set to: ${controllers[index].salesAmount}",
    );

    controllers[index].total = (salesAmount + (salesAmount * gst))
        .toStringAsFixed(2);
    log("controllers[$index].total set to: ${controllers[index].total}");

    log("=== END calculateSalesAndTotalAmountFromFetchedItems ===");

    updateTotals();
    update();
    controllers.refresh();
  }

  void addRow() {
    log("=== Adding new row, current count: ${controllers.length} ===");

    controllers.add(
      StockIssueItemDetailsTableData(
        id: '',
        sn: (controllers.length + 1).toString(),
        item_code: TextEditingController(),
        ornamentId: "",
        tag_no: TextEditingController(),
        description: TextEditingController(),
        pcs: TextEditingController(text: "1"),
        gwt: TextEditingController(text: "0"),
        nwt: TextEditingController(text: "0"),
        va: TextEditingController(text: "0"),
        mc: TextEditingController(text: "0"),
        stone: TextEditingController(text: "0"),
        hall_mark: TextEditingController(text: "0"),
        costDiscount: TextEditingController(text: "0"),
        rate: TextEditingController(text: "0"),
        salesAmount: TextEditingController(text: "0"),
        total: "0",
        // No need to pass itemResponse as it's null by default
      ),
    );

    log(
      "New row added with index: ${controllers.length - 1}, initializing with default values",
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
    log("=== START updateTotals ===");

    double totalPcs = 0;
    double totalGWt = 0;
    double totalNWt = 0;
    double totalVa = 0;
    double totalMc = 0;
    double totalStone = 0;
    double totalHallMark = 0;
    double totalCostDiscount = 0;
    double totalSalesAmount = 0;
    double totalAmount = 0;

    log("Number of rows in controllers: ${controllers.length}");

    for (var i = 0; i < controllers.length; i++) {
      var row = controllers[i];
      double salesAmount = double.tryParse(row.salesAmount.text) ?? 0;
      double total = double.tryParse(row.total) ?? 0;

      log("Row $i - salesAmount: $salesAmount, total: $total");

      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gwt.text) ?? 0;
      totalNWt += double.tryParse(row.nwt.text) ?? 0;
      totalVa += double.tryParse(row.va.text) ?? 0;
      totalMc += double.tryParse(row.mc.text) ?? 0;
      totalStone += double.tryParse(row.stone.text) ?? 0;
      totalHallMark += double.tryParse(row.hall_mark.text) ?? 0;
      totalCostDiscount += double.tryParse(row.costDiscount.text) ?? 0;
      totalSalesAmount += salesAmount;
      totalAmount += total;
    }

    log(
      "Calculated totals - totalSalesAmount: $totalSalesAmount, totalAmount: $totalAmount",
    );

    totalHeadersValue.value = [
      "Total",
      totalPcs.toStringAsFixed(2),
      totalGWt.toStringAsFixed(3),
      totalNWt.toStringAsFixed(3),
      totalVa.toStringAsFixed(2),
      totalMc.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      totalHallMark.toStringAsFixed(2),
      totalCostDiscount.toStringAsFixed(2),
      totalSalesAmount.toStringAsFixed(2),
      totalAmount.toStringAsFixed(2),
      "",
    ];
    log("totalHeadersValue updated with totals");

    log("=== END updateTotals ===");

    update();
  }

  bool isItemAlreadyExists(String itemCode, String tagNo) {
    log(
      "=== Checking if item with code: $itemCode and tag: $tagNo already exists ===",
    );
    int counter = 0;
    // Loop through all controllers except the current one
    for (int i = 0; i < controllers.length; i++) {
      // Skip empty rows
      if (controllers[i].item_code.text.isEmpty ||
          controllers[i].tag_no.text.isEmpty) {
        continue;
      }

      // Check if the item code and tag number combination already exists
      if (controllers[i].item_code.text.toLowerCase() ==
              itemCode.toLowerCase() &&
          controllers[i].tag_no.text.toLowerCase() == tagNo.toLowerCase()) {
        log("Item already exists at row ${i + 1}");
        counter++;
      }
    }

    log("Item does not exist in the table $counter");
    if (counter <= 1) {
      return false;
    } else {
      return true;
    }
  }

  // Modify the fetchTaggingLineItemCodeTag method to check for duplicates before fetching
  Future<void> fetchTaggingLineItemCodeTag(int index) async {
    log("=== START fetchTaggingLineItemCodeTag for row $index ===");

    final itemCode = controllers[index].item_code.text;
    final tagNumber = int.tryParse(controllers[index].tag_no.text);
    log("Fetching item with code: $itemCode, tag: $tagNumber");

    if (itemCode.isNotEmpty && tagNumber != null) {
      // Check if this item is already in the table
      if (isItemAlreadyExists(itemCode, tagNumber.toString())) {
        showErrorToast(message: "Item already exists in the table");
        log("Fetch aborted: Item already exists in the table");

        // Reset the item code and tag number fields
        controllers[index].item_code.text = "";
        controllers[index].tag_no.text = "";

        currentColIndex.value = 0;

        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
        // Return without fetching
        return;
      }

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

        // Store the full response in the itemResponse field
        controllers[index].itemResponse = response;
        log("Stored response in controllers[$index].itemResponse");

        controllers[index].id = response.id ?? "";
        controllers[index].ornamentId = response.codeId?.toString() ?? "";
        controllers[index].description.text = response.design?.name ?? '';
        controllers[index].pcs.text = response.pieces?.toString() ?? '';
        controllers[index].gwt.text = response.grossWeight ?? '';
        controllers[index].nwt.text = response.netWeight ?? '';
        controllers[index].va.text = response.va ?? '';
        controllers[index].originalVa = double.tryParse(response.va ?? "") ?? 0;
        controllers[index].mc.text = response.mc ?? '';
        controllers[index].originalMc = double.tryParse(response.mc ?? "") ?? 0;

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

        try {
          final purity = response.purity;
          final String rate;
          if (response.design?.makingChargeType?.id == "1") {
            rate = rateController.getRateForPurity(purity ?? "22k");
            log(
              "Rate set from RateCaratInputController for purity $purity: $rate",
            );
          } else {
            rate = response.rate ?? "0";
            log("Rate set from response: $rate");
          }
          controllers[index].rate.text = rate;
        } catch (e) {
          // Fallback in case RateCaratInputController is not available
          log(
            "RateCaratInputController not found, using fallback: ${e.toString()}",
          );
          controllers[index].rate.text = response.rate ?? "0";
        }

        controllers[index].gst =
            response.design?.lineItems?.firstOrNull?.ornament?.gst ?? "0";
        log("GST set to: ${controllers[index].gst}");

        log("All fields populated from response, now calculating amounts...");

        // Calculate sales and total amounts - this is crucial!
        calculateSalesAndTotalAmountFromFetchedItems(index: index);

        log(
          "=== END fetchTaggingLineItemCodeTag with successful calculation ===",
        );

        // Rest of your existing code...
        updateTotals();
        update();

        // Check if this is the last row
        if (index == controllers.length - 1) {
          // Add a new row
          addRow();
        }
        currentRowIndex.value = index + 1;
        currentColIndex.value = 0;

        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();

        // showSuccessToast(message: "Fetched successfully!");
      } catch (e) {
        showErrorToast(message: "Item not found $e");
        log("Error in fetchTaggingLineItemCodeTag: $e");
      }
    } else {
      log("Not attempting fetch: itemCode empty or tagNumber null");
    }
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
      showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  void resetRow(int index) {
    // Keep the original serial number and ID
    String originalSn = controllers[index].sn;
    String originalId = controllers[index].id;

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
    controllers[index].rate.clear();
    controllers[index].costDiscount.clear();

    // Reset other properties to initial values
    controllers[index].ornamentId = "";
    controllers[index].gst = "0";
    controllers[index].wst_unit = "%";
    controllers[index].images = [];
    controllers[index].originalVa = 0.0;
    controllers[index].originalMc = 0.0;
    controllers[index].salesAmount.clear();
    controllers[index].total = "0";

    // Clear stone details
    controllers[index].stoneDetailsTableData.clear();

    // Keep the original serial number and ID
    controllers[index].sn = originalSn;
    controllers[index].id = originalId;

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
