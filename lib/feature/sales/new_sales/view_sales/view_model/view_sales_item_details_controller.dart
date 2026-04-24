// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewSalesItemDetailsTableData {
  String sn;
  TextEditingController code;
  TextEditingController tagNo;
  String gst;
  TextEditingController item_description;

  TextEditingController pcs;
  String originalGwt;
  String originalNwt;
  TextEditingController gwt;
  TextEditingController nwt;
  TextEditingController va;
  double originalVa;
  TextEditingController mc;
  double originalMc;
  TextEditingController stone;
  TextEditingController hallMark;
  TextEditingController costDiscount;
  String salesAmount;
  String total;
  List<String> images = [];

  List<StoneDetailsTableData> stoneDetailsTableData = [];

  // GetTaggingLineItemCodeTagResponse? itemResponse;

  bool isHandOver;

  String? designMakingChargesTypeId;
  String? makingChargesType;
  double? minVa;
  double? minMC;
  String? wastageType;

  String? ornamentId;
  String? shopId;
  String? taggingId;
  String? tagNumber;
  String? status;
  String? designCode;
  String? counter;
  String? stockHead;
  String? ornamentCode;
  String? ornamentName;

  String barcode;
  TextEditingController rate;
  List<FocusNode> tableFocusNodes = List.generate(
    15,
    (index) => FocusNode(),
  ); // Increased from 7 to 15

  ViewSalesItemDetailsTableData({
    required this.sn,
    required this.code,
    required this.tagNo,
    required this.item_description,
    required this.pcs,
    required this.gwt,
    required this.nwt,
    required this.va,
    required this.mc,
    required this.stone,
    required this.hallMark,
    required this.costDiscount,
    required this.salesAmount,
    required this.total,
    required this.originalMc,
    required this.originalVa,
    this.gst = "0",
    this.images = const [],
    // this.itemResponse,
    required this.isHandOver,
    required this.makingChargesType,
    required this.minVa,
    required this.minMC,
    required this.wastageType,
    required this.ornamentId,
    required this.shopId,
    required this.taggingId,
    required this.tagNumber,
    required this.status,
    required this.designCode,
    required this.counter,
    required this.stockHead,
    required this.ornamentCode,
    required this.ornamentName,
    required this.originalGwt,
    required this.originalNwt,
    required this.barcode,
    required this.rate,
    required this.designMakingChargesTypeId,
  });
  Map<String, dynamic> toJsonValue() {
    return {
      "sn": sn,
      "code": code,
      "tagNo": tagNo,
      "item_description": item_description,
      "pcs": pcs,
      "gwt": gwt,
      "nwt": nwt,
      "va": va,
      "mc": mc,
      "stone": stone,
      "hallMark": hallMark,
      "costDiscount": costDiscount.text,
      "salesAmount": salesAmount,
      "total": total,
      'stone_details':
          stoneDetailsTableData.map((stone) => stone.toJsonValue()).toList(),
    };
  }
}

class ViewSalesItemDetailsController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final headers = [
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
    'Rate', // Added new column
    'Cost Discount',
    'Sales Amount',
    'Total',
    '',
  ];

  // Update column widths to include new column
  final columnWidths = [
    0.08, // Sn
    0.2, // Item Code
    0.2, // Tag No
    0.3, // Description
    0.2, // Pcs
    0.3, // G.Wt.
    0.3, // N.Wt.
    0.3, // VA
    0.2, // MC
    0.2, // Stone Cost
    0.2, // Hall Mark
    0.3, // Rate (new)
    0.2, // Cost Discount
    0.3, // Sales Amount
    0.3, // Total
    0.1, // Empty (for actions)
  ];

  final totalColumnWidthsOldGold = [0.8, 0.2, 0.3, 2.0, 0.3, 0.1];

  List<String> popUpValues = ["View", "Return", "Edit", "Delete"];
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<ViewSalesItemDetailsTableData> controllers =
      <ViewSalesItemDetailsTableData>[].obs;
  final RxList<String> totalHeadersValue =
      <String>[
        "",
        "Total",
        "",
        "",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "",
      ].obs;
  final RxList<String> totalHeadersValueOldGold =
      <String>["Old Gold Total", "0", "0", "", "0", ""].obs;

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
    // ever(
    //   controllers,
    //   (callback) {
    //     final SalesPaymentDetailsController salesPaymentDetailsController =
    //         Get.find<SalesPaymentDetailsController>();
    //     salesPaymentDetailsController.calculateGstvalues();
    //   },
    // );
  }

  void addRow() {
    controllers.add(
      ViewSalesItemDetailsTableData(
        sn: (controllers.length + 1).toString(),
        code: TextEditingController(),
        tagNo: TextEditingController(),
        item_description: TextEditingController(text: ""),
        pcs: TextEditingController(text: "0"),
        gwt: TextEditingController(),
        nwt: TextEditingController(),
        va: TextEditingController(),
        mc: TextEditingController(),
        stone: TextEditingController(text: "0"),
        hallMark: TextEditingController(text: "0"),
        costDiscount: TextEditingController(text: "0"),
        salesAmount: "0",
        total: "0",
        originalMc: 0,
        originalVa: 0,
        isHandOver: true,
        makingChargesType: null,
        minMC: null,
        minVa: null,
        ornamentId: null,
        shopId: null,
        tagNumber: null,
        taggingId: null,
        wastageType: null,
        status: "Available",
        designCode: null,
        counter: null,
        stockHead: null,
        ornamentCode: null,
        ornamentName: null,
        originalGwt: "0",
        originalNwt: "0",
        rate: TextEditingController(text: "0"),
        barcode: "",
        designMakingChargesTypeId: null,
      ),
    );
    updateTotals();
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      currentRowIndex.value = currentRowIndex.value - 1;
      controllers.removeLast();
      updateTotals();
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
  }

  void updateTotalsFromLineItems(
    List<GetSalesRecordByIdAggregateResponseLineItem> lineItems,
  ) {
    double totalPcs = 0;
    double totalGWt = 0;
    double totalNWt = 0;
    double totalVA = 0;
    double totalMC = 0;
    double totalStone = 0;
    double totalHallMark = 0;
    double totalRate = 0;
    double totalDiscount = 0;
    double totalSalesAmount = 0;
    double totalFinalAmount = 0;

    for (var item in lineItems) {
      totalPcs += double.tryParse(item.finalPieces?.toString() ?? '0') ?? 0;
      totalGWt += double.tryParse(item.finalGrossWeight ?? '0') ?? 0;
      totalNWt += double.tryParse(item.finalNetWeight ?? '0') ?? 0;
      totalVA += double.tryParse(item.finalVa ?? '0') ?? 0;
      totalMC += double.tryParse(item.finalMc ?? '0') ?? 0;
      totalStone += double.tryParse(item.stoneCost ?? '0') ?? 0;
      totalHallMark += double.tryParse(item.hallMark ?? '0') ?? 0;
      totalRate += double.tryParse(item.rate ?? '0') ?? 0;
      totalDiscount += double.tryParse(item.discount ?? '0') ?? 0;
      totalSalesAmount += double.tryParse(item.salesAmount ?? '0') ?? 0;
      totalFinalAmount += double.tryParse(item.totalAmount ?? '0') ?? 0;
    }

    totalHeadersValue.value = [
      "", // Sn
      "Total", // Item Code
      "", // Tag No
      "", // Description
      totalPcs.toStringAsFixed(2), // Pcs
      totalGWt.toStringAsFixed(3), // G.Wt
      totalNWt.toStringAsFixed(3), // N.Wt
      totalVA.toStringAsFixed(2), // VA
      totalMC.toStringAsFixed(2), // MC
      totalStone.toStringAsFixed(2), // Stone Cost
      totalHallMark.toStringAsFixed(2), // Hall Mark
      totalRate.toStringAsFixed(2), // Rate
      totalDiscount.toStringAsFixed(2), // Discount
      totalSalesAmount.toStringAsFixed(2), // Sales Amount
      totalFinalAmount.toStringAsFixed(2), // Total
      "", // Actions
    ];

    update();
    totalHeadersValue.refresh();
  }

  void updateTotals() {
    double totalPcs = 0;
    double totalGWt = 0;

    double totalNWt = 0;
    double totalVATch = 0;
    double totalMC = 0;
    double totalStone = 0;
    double hallMark = 0;
    double rate = 0;
    double costDiscount = 0;
    double salesAmount = 0;
    double totalAmount = 0;

    for (var row in controllers) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gwt.text) ?? 0;

      totalNWt += double.tryParse(row.nwt.text) ?? 0;
      totalVATch += double.tryParse(row.va.text) ?? 0;
      totalMC += double.tryParse(row.mc.text) ?? 0;
      totalStone += double.tryParse(row.stone.text) ?? 0;
      hallMark += double.tryParse(row.hallMark.text) ?? 0;
      rate += double.tryParse(row.rate.text) ?? 0;
      costDiscount += double.tryParse(row.costDiscount.text) ?? 0;
      salesAmount += double.tryParse(row.salesAmount) ?? 0;
      totalAmount += double.tryParse(row.total) ?? 0;
    }

    totalHeadersValue.value = [
      "",
      "Total",
      "",
      "",
      totalPcs.toStringAsFixed(2),
      totalGWt.toStringAsFixed(2),
      totalNWt.toStringAsFixed(2),
      totalVATch.toStringAsFixed(2),
      totalMC.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      hallMark.toStringAsFixed(2),
      rate.toStringAsFixed(2),
      costDiscount.toStringAsFixed(2),
      salesAmount.toStringAsFixed(2),
      totalAmount.toStringAsFixed(2),
      "",
    ];
    update();
    totalHeadersValue.refresh();
  }

  void updateRowAmount(int index) {
    double amount = calculateAmount(index);
    controllers[index].salesAmount = amount.toStringAsFixed(2);
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
      addRow();
      controllers.last.tableFocusNodes.first.requestFocus();
      currentRowIndex.value = controllers.length - 1;
      currentColIndex.value = 0;
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
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
      updateTotals();
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
    totalHeadersValue.value = [
      "",
      "Total",
      "",
      "",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "",
    ];
    addRow();
    updateTotals();
  }

  Future<void> fetchTaggingLineItemCodeTag(int index) async {
    final itemCode = controllers[index].code.text;
    final tagNumber = int.tryParse(controllers[index].tagNo.text);

    // if (itemCode.isNotEmpty && tagNumber != null)
    if (itemCode.isNotEmpty) {
      bool isDuplicate = controllers.asMap().entries.any(
        (entry) =>
            entry.key != index && // Skip current row
            entry.value.code.text == itemCode &&
            entry.value.tagNo.text == tagNumber.toString(),
      );

      if (isDuplicate) {
        showErrorToast(
          message: 'Item with same code and tag number already exists',
        );
        // Clear the code and tag number
        controllers[index].code.text = '';
        controllers[index].tagNo.text = '';
        return;
      }
      try {
        final response = await _inventoryRepository.getTaggingLineItemCodeTag(
          itemCode,
          tagNumber,
        );

        controllers[index].code.text = response.code ?? "";
        controllers[index].tagNo.text =
            response.tagNumber != null ? response.tagNumber.toString() : "";
        controllers[index].item_description.text = response.design?.name ?? '';
        controllers[index].pcs.text = response.pieces?.toString() ?? '0';
        controllers[index].gwt.text = response.grossWeight ?? "0";
        controllers[index].nwt.text = response.netWeight ?? "0";
        controllers[index].va.text = response.va ?? "0";
        controllers[index].mc.text = response.mc ?? "0";
        controllers[index].stone.text =
            response.lineStones
                ?.fold<double>(
                  0,
                  (sum, stone) =>
                      sum + (double.tryParse(stone.total ?? '0') ?? 0),
                )
                .toString() ??
            '0';

        controllers[index].hallMark.text =
            response.design?.stockHead?.hallmarkExtraCharge ?? '0';
        controllers[index].costDiscount.text = "0";
        controllers[index].salesAmount = "0";
        controllers[index].total = "0";
        controllers[index].originalMc =
            double.tryParse(response.mc ?? "q") ?? 0;
        controllers[index].originalVa =
            double.tryParse(response.va ?? "q") ?? 0;

        controllers[index].isHandOver = true;
        controllers[index].makingChargesType =
            response.designLineItem?.makingChargesType ?? "";
        controllers[index].minVa = double.tryParse(
          response.designLineItem?.minVa ?? "q",
        );
        controllers[index].minMC = double.tryParse(
          response.designLineItem?.minMc ?? "q",
        );
        controllers[index].wastageType = response.designLineItem?.wastageType;
        controllers[index].ornamentId = response.designLineItem?.ornament?.id;
        controllers[index].shopId = response.shopId;
        controllers[index].taggingId = response.id;
        controllers[index].tagNumber = response.tagNumber.toString();

        controllers[index].gst = response.designLineItem?.ornament?.gst ?? "0";
        controllers[index].status = response.status ?? "Sold";
        controllers[index].stoneDetailsTableData =
            response.lineStones
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
                    weightUnitFromBackend: e.carat == null ? "GM" : "CT",
                  ),
                )
                .toList() ??
            [];
        List<String> combinedImages = [
          ...(response.images?.map((image) => image.presignedUrl ?? '') ?? []),
          ...(response.design?.images?.map(
                (image) => image.presignedUrl ?? '',
              ) ??
              []),
        ];
        controllers[index].images =
            combinedImages.where((element) => element.isNotEmpty).toList();
        controllers[index].designCode = response.design?.code;
        controllers[index].counter = response.counter?.id;
        controllers[index].stockHead = response.design?.stockHead?.id;
        controllers[index].ornamentCode =
            response.designLineItem?.ornament?.code;
        controllers[index].ornamentName = response.design?.stockHead?.name;

        controllers[index].originalNwt = response.netWeight ?? "0";
        controllers[index].originalGwt = response.grossWeight ?? "0";
        controllers[index].barcode = response.tagBarcode ?? "";
        controllers[index].designMakingChargesTypeId =
            response.design?.makingChargeType?.id;
        final RateCaratInputController rateController =
            Get.find<RateCaratInputController>();
        final purity = response.purity;
        final String rate;
        if (response.design?.makingChargeType?.id == "1") {
          rate = rateController.getRateForPurity(purity ?? "22k");
        } else {
          rate = response.rate ?? "0";
        }
        controllers[index].rate.text = rate;

        calculateSalesAndTotalAmountforFetchedItems(index: index);
        updateTotals();
        update();
        controllers.refresh();
      } catch (e) {
        // Keep existing code and tagNo controllers but reset their values
        // final existingCode = controllers[index].code;
        // final existingTagNo = controllers[index].tagNo;

        // Reset all values in the existing controller
        controllers[index].tagNo.text =
            tagNumber != null ? tagNumber.toString() : "";
        controllers[index].item_description.text = "";
        controllers[index].pcs.text = "0";
        controllers[index].gwt.text = "0";
        controllers[index].nwt.text = "0";
        controllers[index].va.text = "";
        controllers[index].mc.text = "";
        controllers[index].stone.text = "0";
        controllers[index].hallMark.text = "0";
        controllers[index].costDiscount.text = "0";
        controllers[index].salesAmount = "0";
        controllers[index].total = "0";
        controllers[index].originalMc = 0;
        controllers[index].originalVa = 0;
        controllers[index].isHandOver = true;
        controllers[index].makingChargesType = null;
        controllers[index].minMC = null;
        controllers[index].minVa = null;
        controllers[index].ornamentId = null;
        controllers[index].shopId = null;
        controllers[index].tagNumber = null;
        controllers[index].taggingId = null;
        controllers[index].wastageType = null;
        controllers[index].status = "Available";
        controllers[index].designCode = null;
        controllers[index].counter = null;
        controllers[index].stockHead = null;
        controllers[index].ornamentCode = null;
        controllers[index].ornamentName = null;
        controllers[index].images = [];
        controllers[index].stoneDetailsTableData = [];
        controllers[index].gst = "0";
        controllers[index].originalNwt = "0";
        controllers[index].originalGwt = "0";
        controllers[index].barcode = "";
        controllers[index].rate.text = "0";
        controllers[index].designMakingChargesTypeId = null;

        controllers.refresh();
        showErrorToast(message: 'Failed to fetch item details');
      }
    }
  }

  Future<void> fetchTaggingLineItemByBarcode(int index, String barcode) async {
    // final barcode = controllers[index].barcode.text;

    if (barcode.isNotEmpty) {
      bool isDuplicate = controllers.asMap().entries.any(
        (entry) =>
            entry.key != index && // Skip current row
            entry.value.barcode == barcode,
      );

      if (isDuplicate) {
        showErrorToast(message: 'Item with same barcode already exists');
        controllers[index].barcode = '';
        return;
      }

      try {
        final response = await _inventoryRepository.getTaggingLineItemByBarcode(
          barcode,
        );

        // Basic details
        controllers[index].code.text = response.code ?? "";
        controllers[index].tagNo.text =
            response.tagNumber != null ? response.tagNumber.toString() : "";
        controllers[index].item_description.text = response.design?.name ?? '';
        controllers[index].pcs.text = response.pieces?.toString() ?? '0';
        controllers[index].gwt.text = response.grossWeight ?? "0";
        controllers[index].nwt.text = response.netWeight ?? "0";
        controllers[index].va.text = response.va ?? "0";
        controllers[index].mc.text = response.mc ?? "0";
        controllers[index].stone.text =
            response.lineStones
                ?.fold<double>(
                  0,
                  (sum, stone) =>
                      sum + (double.tryParse(stone.total ?? '0') ?? 0),
                )
                .toString() ??
            '0';

        // Additional details
        controllers[index].hallMark.text =
            response.design?.stockHead?.hallmarkExtraCharge ?? '0';
        controllers[index].costDiscount.text = "0";
        controllers[index].salesAmount = "0";
        controllers[index].total = "0";
        controllers[index].originalMc =
            double.tryParse(response.mc ?? "q") ?? 0;
        controllers[index].originalVa =
            double.tryParse(response.va ?? "q") ?? 0;

        // Status and metadata
        controllers[index].isHandOver = true;
        controllers[index].makingChargesType =
            response.designLineItem?.makingChargesType ?? "";
        controllers[index].minVa = double.tryParse(
          response.designLineItem?.minVa ?? "q",
        );
        controllers[index].minMC = double.tryParse(
          response.designLineItem?.minMc ?? "q",
        );
        controllers[index].wastageType = response.designLineItem?.wastageType;
        controllers[index].ornamentId = response.designLineItem?.ornament?.id;
        controllers[index].shopId = response.shopId;
        controllers[index].taggingId = response.id;
        controllers[index].tagNumber = response.tagNumber.toString();

        // Additional properties
        controllers[index].gst = response.designLineItem?.ornament?.gst ?? "0";
        controllers[index].status = response.status ?? "Sold";

        // Stone details
        controllers[index].stoneDetailsTableData =
            response.lineStones
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
                    weightUnitFromBackend: e.carat == null ? "GM" : "CT",
                  ),
                )
                .toList() ??
            [];

        // Images
        List<String> combinedImages = [
          ...(response.images?.map((image) => image.presignedUrl ?? '') ?? []),
          ...(response.design?.images?.map(
                (image) => image.presignedUrl ?? '',
              ) ??
              []),
        ];
        controllers[index].images =
            combinedImages.where((element) => element.isNotEmpty).toList();

        // Design and reference details
        controllers[index].designCode = response.design?.code;
        controllers[index].counter = response.counter?.id;
        controllers[index].stockHead = response.design?.stockHead?.id;
        controllers[index].ornamentCode =
            response.designLineItem?.ornament?.code;
        controllers[index].ornamentName = response.design?.stockHead?.name;

        // Original weights
        controllers[index].originalNwt = response.netWeight ?? "0";
        controllers[index].originalGwt = response.grossWeight ?? "0";
        controllers[index].barcode = response.tagBarcode ?? "";
        controllers[index].designMakingChargesTypeId =
            response.design?.makingChargeType?.id;
        final RateCaratInputController rateController =
            Get.find<RateCaratInputController>();
        final purity = response.purity;
        final String rate;
        if (response.design?.makingChargeType?.id == "1") {
          rate = rateController.getRateForPurity(purity ?? "22k");
        } else {
          rate = response.rate ?? "0";
        }
        controllers[index].rate.text = rate;
        // Calculate and update
        calculateSalesAndTotalAmountforFetchedItems(index: index);
        updateTotals();
        update();
        controllers.refresh();
      } catch (e) {
        // Reset all values in the controller
        controllers[index].item_description.text = "";
        controllers[index].pcs.text = "0";
        controllers[index].gwt.text = "0";
        controllers[index].nwt.text = "0";
        controllers[index].va.text = "";
        controllers[index].mc.text = "";
        controllers[index].stone.text = "0";
        controllers[index].hallMark.text = "0";
        controllers[index].costDiscount.text = "0";
        controllers[index].salesAmount = "0";
        controllers[index].total = "0";
        controllers[index].originalMc = 0;
        controllers[index].originalVa = 0;
        controllers[index].isHandOver = true;
        controllers[index].makingChargesType = null;
        controllers[index].minMC = null;
        controllers[index].minVa = null;
        controllers[index].ornamentId = null;
        controllers[index].shopId = null;
        controllers[index].tagNumber = null;
        controllers[index].taggingId = null;
        controllers[index].wastageType = null;
        controllers[index].status = "Available";
        controllers[index].designCode = null;
        controllers[index].counter = null;
        controllers[index].stockHead = null;
        controllers[index].ornamentCode = null;
        controllers[index].ornamentName = null;
        controllers[index].images = [];
        controllers[index].stoneDetailsTableData = [];
        controllers[index].gst = "0";
        controllers[index].originalNwt = "0";
        controllers[index].originalGwt = "0";
        controllers[index].barcode = "";
        controllers[index].rate.text = "0";
        controllers[index].designMakingChargesTypeId = null;

        controllers.refresh();
        showErrorToast(message: 'Failed to fetch item details');
      }
    }
  }

  void addToControllersFromEstimateNumberApi({
    required GetSaleByEstimateResponse response,
  }) {
    List<ViewSalesItemDetailsTableData> dataList = [];
    int index = 0;
    Set<String> uniqueItems = {}; // Track unique combinations

    for (GetSaleByEstimateResponseLineItem element
        in response.lineItems ?? []) {
      final itemCode = element.code ?? "";
      final tagNumber = element.tag?.toString() ?? "";
      final key = "$itemCode-$tagNumber";

      // Skip if this combination already exists in current controllers or dataList
      bool isDuplicate =
          controllers.any(
            (controller) =>
                controller.code.text == itemCode &&
                controller.tagNo.text == tagNumber,
          ) ||
          !uniqueItems.add(key);

      if (isDuplicate) {
        showErrorToast(
          message: 'Skipping duplicate item: Code $itemCode, Tag $tagNumber',
        );
        continue;
      }
      List<String> combinedImages = [
        ...(element.taggingDetails?.images?.map(
              (image) => image.presignedUrl ?? '',
            ) ??
            []),
        ...(element.taggingDetails?.design?.images?.map(
              (image) => image.presignedUrl ?? '',
            ) ??
            []),
      ];
      ViewSalesItemDetailsTableData data = ViewSalesItemDetailsTableData(
        sn: index.toString(),
        code: TextEditingController(text: element.code ?? ""),
        tagNo: TextEditingController(text: element.tag?.toString() ?? ""),
        item_description: TextEditingController(
          text: element.taggingDetails?.design?.name ?? "",
        ),
        pcs: TextEditingController(text: element.finalPieces?.toString() ?? ""),
        gwt: TextEditingController(text: element.finalGrossWeight ?? ""),
        nwt: TextEditingController(text: element.finalNetWeight ?? ""),
        va: TextEditingController(text: element.finalVa ?? ""),
        mc: TextEditingController(text: element.finalMc ?? ""),
        stone: TextEditingController(
          text:
              element.taggingDetails?.lineStones
                  ?.fold<double>(
                    0,
                    (sum, stone) =>
                        sum + (double.tryParse(stone.total ?? '0') ?? 0),
                  )
                  .toString() ??
              '0',
        ),
        hallMark: TextEditingController(
          text:
              element.taggingDetails?.design?.stockHead?.hallmarkExtraCharge ??
              '0',
        ),
        costDiscount: TextEditingController(text: element.discount),
        salesAmount: element.salesAmount ?? "0",
        total: element.totalAmount ?? "0",
        originalMc: double.tryParse(element.finalMc ?? "0") ?? 0,
        originalVa: double.tryParse(element.finalVa ?? "0") ?? 0,
        isHandOver: true,
        makingChargesType:
            element.taggingDetails?.designLineItem?.makingChargesType ?? "",
        minVa: double.tryParse(
          element.taggingDetails?.designLineItem?.minVa ?? "0",
        ),
        minMC: double.tryParse(
          element.taggingDetails?.designLineItem?.minMc ?? "0",
        ),
        wastageType: element.taggingDetails?.designLineItem?.wastageType,
        ornamentId: element.taggingDetails?.designLineItem?.ornament?.id,
        shopId: element.taggingDetails?.shopId,
        taggingId: element.taggingId,
        tagNumber: element.tag?.toString() ?? "",
        gst: element.taggingDetails?.designLineItem?.ornament?.gst ?? "0",
        status: element.taggingDetails?.status,
        images: combinedImages.where((element) => element.isNotEmpty).toList(),
        designCode: element.taggingDetails?.design?.code,
        counter: element.taggingDetails?.counter?.id,
        stockHead: element.taggingDetails?.design?.stockHead?.id,
        ornamentCode: element.taggingDetails?.designLineItem?.ornament?.code,
        ornamentName: element.taggingDetails?.designLineItem?.ornament?.name,
        originalGwt: element.taggingGrossWeight ?? "0",
        originalNwt: element.taggingNetWeight ?? "0",
        rate: TextEditingController(text: element.rate),
        barcode: element.taggingDetails?.tagBarcode ?? "",
        designMakingChargesTypeId:
            element.taggingDetails?.design?.makingChargeType?.id,
      );
      data.stoneDetailsTableData =
          element.taggingDetails?.lineStones
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
                  weightUnitFromBackend: e.carat == null ? "GM" : "CT",
                ),
              )
              .toList() ??
          [];
      dataList.add(data);
      index++;
    }

    // Assuming you want to update the controllers list
    controllers.clear();
    controllers.assignAll(dataList);
    for (var i = 0; i < controllers.length; i++) {
      calculateSalesAndTotalAmountforFetchedItems(index: i);
    }
    controllers.refresh();
    updateTotals();
    update();
  }

  List<ViewSalesItemDetailsTableData> getSortedEstimationList({
    required String sortBy,
  }) {
    // Create a copy of the list to avoid modifying the original
    final sortedList = List<ViewSalesItemDetailsTableData>.from(controllers);

    switch (sortBy.toLowerCase()) {
      case 'va':
        sortedList.sort((a, b) {
          final double aValue = a.originalVa;
          final double bValue = b.originalVa;
          // Sort in descending order (b compared to a)
          return bValue.compareTo(aValue);
        });
        return sortedList;

      case 'mc':
        sortedList.sort((a, b) {
          final double aValue = a.originalMc;
          final double bValue = b.originalMc;
          // Sort in descending order (b compared to a)
          return bValue.compareTo(aValue);
        });
        return sortedList;

      default:
        print('Warning: Invalid sort parameter. Use either "va" or "mc"');
        return sortedList;
    }
  }

  // Base calculation functions
  double calculateNetWeightAmount({
    required double netWeight,
    required double currentRate,
    required String designMakingChargeTypeId,
  }) {
    switch (designMakingChargeTypeId) {
      case "1":
        return netWeight * currentRate;

      case "2":
        return netWeight * currentRate;

      case "3":
        return currentRate;

      case "4":
        return currentRate;
      default:
        return netWeight * currentRate;
    }
  }

  double calculateVAAmount({
    required double netWeight,
    required double originalVa,
    required String wastageType,
    required double currentRate,
    required double discount,
  }) {
    if (wastageType == "%") {
      double vaWeight = netWeight * (originalVa / 100);
      double weight = vaWeight;
      double amount = weight * currentRate;
      return amount - discount;
    } else {
      double vaWeight = originalVa;
      double weight = vaWeight;
      double amount = weight * currentRate;
      return amount - discount;
    }
  }

  double calculateMCAmount({
    required String mcType,
    required double grossWeight,
    required double netWeight,
    required double originalMc,
    required double discount,
  }) {
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

  double calculateMaxVADiscount({
    required double netWeight,
    required double originalVa,
    required double minVa,
    required String wastageType,
    required double currentRate,
  }) {
    if (wastageType == "%") {
      double minVaWeight = netWeight * (minVa / 100);
      double currentVaWeight = netWeight * (originalVa / 100);
      double weightDiff = currentVaWeight - minVaWeight;
      return weightDiff * currentRate;
    } else {
      double weightDiff = originalVa - minVa;
      return weightDiff * currentRate;
    }
  }

  double calculateMaxMCDiscount({
    required String mcType,
    required double grossWeight,
    required double netWeight,
    required double originalMc,
    required double minMc,
  }) {
    switch (mcType) {
      case "gwt":
        double currentAmount = grossWeight * originalMc;
        double minAmount = grossWeight * minMc;
        return currentAmount - minAmount;

      case "nwt":
        double currentAmount = netWeight * originalMc;
        double minAmount = netWeight * minMc;
        return currentAmount - minAmount;

      default:
        return originalMc - minMc;
    }
  }

  // Updated controller methods using decoupled calculations
  void calculateSalesAndTotalAmountforFetchedItems({required int index}) {
    double currentRate =
        double.tryParse(controllers.elementAt(index).rate.text) ?? 0;
    double costDiscount =
        double.tryParse(controllers.elementAt(index).costDiscount.text) ?? 0;
    double netWeightAmount = calculateNetWeightAmount(
      netWeight: double.tryParse(controllers.elementAt(index).nwt.text) ?? 0,
      currentRate: currentRate,
      designMakingChargeTypeId:
          controllers.elementAt(index).designMakingChargesTypeId ?? "",
    );
    double vaAmount = calculateVAAmount(
      netWeight: double.tryParse(controllers[index].nwt.text) ?? 0,
      originalVa: controllers[index].originalVa,
      wastageType: controllers[index].wastageType ?? "",
      currentRate: currentRate,
      discount: 0,
    );

    double mcAmount = calculateMCAmount(
      mcType: controllers[index].makingChargesType ?? "",
      grossWeight: double.tryParse(controllers[index].gwt.text) ?? 0,
      netWeight: double.tryParse(controllers[index].nwt.text) ?? 0,
      originalMc: controllers[index].originalMc,
      discount: 0,
    );

    double stoneAmount = double.tryParse(controllers[index].stone.text) ?? 0;
    double salesAmount =
        netWeightAmount + vaAmount + mcAmount + stoneAmount - (costDiscount);

    if (vaAmount < 0 || mcAmount < 0) {
      showErrorToast(message: "Invalid Discount");
      return;
    }

    double gst = (double.tryParse(controllers[index].gst) ?? 0) / 100;
    controllers[index].salesAmount = salesAmount.toStringAsFixed(2);
    controllers[index].total = (salesAmount + (salesAmount * gst))
        .toStringAsFixed(2);
    controllers[index].va.text = vaAmount.toStringAsFixed(2);
    controllers[index].mc.text = mcAmount.toStringAsFixed(2);
    // controllers[index].currentRateSet = currentRate.toStringAsFixed(2);

    updateTotals();
    update();
    controllers.refresh();
  }

  void calculateSalesAndTotalAmount({required int index}) {
    double currentRate =
        double.tryParse(controllers.elementAt(index).rate.text) ?? 0;
    double costDiscount =
        double.tryParse(controllers.elementAt(index).costDiscount.text) ?? 0;
    double netWeightAmount = calculateNetWeightAmount(
      netWeight: double.tryParse(controllers.elementAt(index).nwt.text) ?? 0,
      currentRate: currentRate,
      designMakingChargeTypeId:
          controllers.elementAt(index).designMakingChargesTypeId ?? "",
    );
    double vaAmount = calculateVAAmount(
      netWeight: double.tryParse(controllers[index].nwt.text) ?? 0,
      originalVa: controllers[index].originalVa,
      wastageType: controllers[index].wastageType ?? "",
      currentRate: currentRate,
      discount: costDiscount,
    );

    double mcAmount = calculateMCAmount(
      mcType: controllers[index].makingChargesType ?? "",
      grossWeight: double.tryParse(controllers[index].gwt.text) ?? 0,
      netWeight: double.tryParse(controllers[index].nwt.text) ?? 0,
      originalMc: controllers[index].originalMc,
      discount: costDiscount,
    );

    double stoneAmount = double.tryParse(controllers[index].stone.text) ?? 0;
    double salesAmount =
        netWeightAmount + vaAmount + mcAmount + stoneAmount - (costDiscount);

    if (vaAmount < 0 || mcAmount < 0) {
      showErrorToast(message: "Invalid Discount");
      return;
    }

    double gst = (double.tryParse(controllers[index].gst) ?? 0) / 100;
    controllers[index].salesAmount = salesAmount.toStringAsFixed(2);
    controllers[index].total = (salesAmount + (salesAmount * gst))
        .toStringAsFixed(2);
    controllers[index].va.text = vaAmount.toStringAsFixed(2);
    controllers[index].mc.text = mcAmount.toStringAsFixed(2);
    // controllers[index].currentRateSet = currentRate.toStringAsFixed(2);

    updateTotals();
    update();
    controllers.refresh();
  }

  void distributeJewellerDiscount({
    required double jewellerDiscount,
    bool vaFirst = true,
  }) {
    double remainingDiscount = jewellerDiscount;
    // Reset VA and MC to original values first
    for (int i = 0; i < controllers.length; i++) {
      var lineItem = controllers[i];
      double netWeight = double.tryParse(lineItem.nwt.text) ?? 0;
      double currentRate =
          double.tryParse(controllers.elementAt(i).rate.text) ?? 0;

      // Reset VA to original value
      double originalVaAmount = calculateVAAmount(
        netWeight: netWeight,
        originalVa: lineItem.originalVa,
        wastageType: lineItem.wastageType ?? "",
        currentRate: currentRate,
        discount: 0,
      );
      lineItem.va.text = originalVaAmount.toStringAsFixed(2);

      // Reset MC to original value
      double originalMcAmount = calculateMCAmount(
        mcType: lineItem.makingChargesType ?? "",
        grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
        netWeight: netWeight,
        originalMc: lineItem.originalMc,
        discount: 0,
      );
      lineItem.mc.text = originalMcAmount.toStringAsFixed(2);
    }

    // If discount is 0, just update totals and return
    if (jewellerDiscount == 0) {
      for (int i = 0; i < controllers.length; i++) {
        calculateCostDisountedSalesAndTotalAmount(index: i);
      }
      updateTotals();
      return;
    }
    double maxPossibleDiscount = controllers.fold<double>(0, (sum, lineItem) {
      double vaRoom = calculateMaxVADiscount(
        netWeight: double.tryParse(lineItem.nwt.text) ?? 0,
        originalVa: lineItem.originalVa,
        minVa: lineItem.minVa ?? 0,
        wastageType: lineItem.wastageType ?? "",
        currentRate: double.tryParse(lineItem.rate.text) ?? 0,
      );

      double mcRoom = calculateMaxMCDiscount(
        mcType: lineItem.makingChargesType ?? "",
        grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
        netWeight: double.tryParse(lineItem.nwt.text) ?? 0,
        originalMc: lineItem.originalMc,
        minMc: lineItem.minMC ?? 0,
      );

      print("the rooms are $vaRoom + $mcRoom");
      return sum + vaRoom + mcRoom;
    });

    if (jewellerDiscount > maxPossibleDiscount) {
      showErrorToast(
        message:
            'Maximum possible discount is ${maxPossibleDiscount.toStringAsFixed(2)}',
      );
      return;
    }

    // Process each line item
    for (int i = 0; i < controllers.length && remainingDiscount > 0; i++) {
      var lineItem = controllers[i];
      // double existingDiscount =
      //     double.tryParse(lineItem.costDiscount.text) ?? 0;
      double maxVADiscount = calculateMaxVADiscount(
        netWeight: double.tryParse(lineItem.nwt.text) ?? 0,
        originalVa: lineItem.originalVa,
        minVa: lineItem.minVa ?? 0,
        wastageType: lineItem.wastageType ?? "",
        currentRate: double.tryParse(lineItem.rate.text) ?? 0,
      );

      double maxMCDiscount = calculateMaxMCDiscount(
        mcType: lineItem.makingChargesType ?? "",
        grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
        netWeight: double.tryParse(lineItem.nwt.text) ?? 0,
        originalMc: lineItem.originalMc,
        minMc: lineItem.minMC ?? 0,
      );

      double vaDiscount = 0;
      double mcDiscount = 0;
      log("the rooms The max discounts are $maxMCDiscount, $maxVADiscount");

      if (vaFirst) {
        // Apply to VA first, then MC
        vaDiscount =
            remainingDiscount > maxVADiscount
                ? maxVADiscount
                : remainingDiscount;
        double remainingAfterVA = remainingDiscount - vaDiscount;
        print("The rooms remaining va discount $remainingAfterVA $vaDiscount");

        if (remainingAfterVA > 0) {
          mcDiscount =
              remainingAfterVA > maxMCDiscount
                  ? maxMCDiscount
                  : remainingAfterVA;
        }
      } else {
        // Apply to MC first, then VA
        mcDiscount =
            remainingDiscount > maxMCDiscount
                ? maxMCDiscount
                : remainingDiscount;
        double remainingAfterMC = remainingDiscount - mcDiscount;

        if (remainingAfterMC > 0) {
          vaDiscount =
              remainingAfterMC > maxVADiscount
                  ? maxVADiscount
                  : remainingAfterMC;
        }
      }

      // Apply discounts
      double totalDiscount = vaDiscount + mcDiscount;
      // lineItem.costDiscount.text =
      //     (totalDiscount + existingDiscount).toStringAsFixed(2);
      log("The va discount is $vaDiscount $mcDiscount");

      // Calculate new VA and MC amounts instead of modifying original values
      double newVaAmount = calculateVAAmount(
        netWeight: double.tryParse(lineItem.nwt.text) ?? 0,
        originalVa: lineItem.originalVa,
        wastageType: lineItem.wastageType ?? "",
        currentRate: double.tryParse(lineItem.rate.text) ?? 0,
        discount: vaDiscount,
      );

      double newMcAmount = calculateMCAmount(
        mcType: lineItem.makingChargesType ?? "",
        grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
        netWeight: double.tryParse(lineItem.nwt.text) ?? 0,
        originalMc: lineItem.originalMc,
        discount: mcDiscount,
      );
      log("The va NEW discount is $newVaAmount $newMcAmount");

      lineItem.va.text = newVaAmount.toStringAsFixed(2);
      lineItem.mc.text = newMcAmount.toStringAsFixed(2);

      remainingDiscount -= totalDiscount;
    }

    // Update all totals
    for (int i = 0; i < controllers.length; i++) {
      calculateCostDisountedSalesAndTotalAmount(index: i);
    }
    updateTotals();
  }

  void calculateCostDisountedSalesAndTotalAmount({required int index}) {
    double costDiscount =
        double.tryParse(controllers.elementAt(index).costDiscount.text) ?? 0;

    // Get required values from controllers
    double netWeight = double.tryParse(controllers[index].nwt.text) ?? 0;
    double va =
        double.tryParse(controllers[index].va.text) ??
        controllers[index].originalVa;
    double mc =
        double.tryParse(controllers[index].mc.text) ??
        controllers[index].originalMc;

    double currentRate =
        double.tryParse(controllers.elementAt(index).rate.text) ?? 0;

    // Calculate net weight amount
    double netWeightAmount = netWeight * currentRate;

    // Calculate total before discount
    double stoneAmount = double.tryParse(controllers[index].stone.text) ?? 0;
    double salesAmountBeforeDiscount = netWeightAmount + va + mc + stoneAmount;

    // Apply discount directly to sales amount
    double salesAmount = salesAmountBeforeDiscount - costDiscount;

    // Calculate total with GST
    double gst = (double.tryParse(controllers[index].gst) ?? 0) / 100;
    double total = salesAmount + (salesAmount * gst);

    // Update controllers
    controllers[index].salesAmount = salesAmount.toStringAsFixed(2);
    controllers[index].total = total.toStringAsFixed(2);
    // controllers[index].currentRateSet = currentRate.toStringAsFixed(2);

    controllers.refresh();
  }

  bool hasSoldItems() {
    return controllers.any(
      (controller) => controller.status?.toLowerCase() == 'sold',
    );
  }

  // Add this method to CreateSalesItemDetailsController
  void handleQuickEstimateDone({
    required List<GetSaleByEstimateResponseLineItem> lineItems,
    required Set<int> selectedItems,
    required Function isItemAvailable,
  }) {
    if (lineItems.isNotEmpty && selectedItems.isNotEmpty) {
      // Add only selected AND available items to the controllers
      Set<String> duplicateItems = {};
      for (var index in selectedItems) {
        final lineItem = lineItems[index];
        if (isItemAvailable(index)) {
          final itemCode = lineItem.code ?? "";
          final tagNumber = lineItem.tag ?? "";

          // Check if this combination already exists
          bool isDuplicate = controllers.any(
            (controller) =>
                controller.code.text == itemCode &&
                controller.tagNo.text == tagNumber,
          );

          if (isDuplicate) {
            duplicateItems.add("Code: $itemCode, Tag: $tagNumber");
            continue;
          }

          List<String> combinedImages = [
            ...(lineItem.taggingDetails?.images?.map(
                  (image) => image.presignedUrl ?? '',
                ) ??
                []),
            ...(lineItem.taggingDetails?.design?.images?.map(
                  (image) => image.presignedUrl ?? '',
                ) ??
                []),
          ];

          final vaAmount = calculateVAAmount(
            netWeight: double.tryParse(lineItem.finalNetWeight ?? '0') ?? 0,
            originalVa: double.tryParse(lineItem.finalVa ?? '0') ?? 0,
            wastageType:
                lineItem.taggingDetails?.designLineItem?.wastageType ?? '',
            currentRate: double.tryParse(lineItem.rate ?? "") ?? 0,
            discount: 0,
          );

          final mcAmount = calculateMCAmount(
            mcType:
                lineItem.taggingDetails?.designLineItem?.makingChargesType ??
                '',
            grossWeight: double.tryParse(lineItem.finalGrossWeight ?? '0') ?? 0,
            netWeight: double.tryParse(lineItem.finalNetWeight ?? '0') ?? 0,
            originalMc: double.tryParse(lineItem.finalMc ?? '0') ?? 0,
            discount: 0,
          );

          final tableData = ViewSalesItemDetailsTableData(
            sn: (controllers.length + 1).toString(),
            code: TextEditingController(text: lineItem.code ?? ""),
            tagNo: TextEditingController(text: lineItem.tag ?? ""),
            item_description: TextEditingController(
              text: lineItem.description ?? "",
            ),
            pcs: TextEditingController(
              text: lineItem.finalPieces?.toString() ?? '',
            ),
            gwt: TextEditingController(text: lineItem.finalGrossWeight ?? ''),
            nwt: TextEditingController(text: lineItem.finalNetWeight ?? ''),
            va: TextEditingController(text: vaAmount.toStringAsFixed(2)),
            mc: TextEditingController(text: mcAmount.toStringAsFixed(2)),
            stone: TextEditingController(text: lineItem.stoneCost ?? '0'),
            hallMark: TextEditingController(text: lineItem.hallMark ?? ''),
            costDiscount: TextEditingController(text: lineItem.discount ?? "0"),
            salesAmount: lineItem.salesAmount ?? "",
            total: lineItem.totalAmount ?? "",
            gst: lineItem.taggingDetails?.designLineItem?.ornament?.gst ?? "0",
            originalMc: double.tryParse(lineItem.taggingMc ?? "0") ?? 0,
            originalVa: double.tryParse(lineItem.taggingVa ?? "0") ?? 0,
            isHandOver: false,
            makingChargesType:
                lineItem.taggingDetails?.designLineItem?.makingChargesType ??
                "",
            minVa: double.tryParse(
              lineItem.taggingDetails?.designLineItem?.minVa ?? "0",
            ),
            minMC: double.tryParse(
              lineItem.taggingDetails?.designLineItem?.minMc ?? "0",
            ),
            wastageType:
                lineItem.taggingDetails?.designLineItem?.wastageType ?? "",
            ornamentId: lineItem.taggingDetails?.designLineItem?.ornament?.id,
            shopId: lineItem.taggingDetails?.shopId,
            taggingId: lineItem.taggingDetails?.id,
            tagNumber: lineItem.tag,
            status: lineItem.taggingDetails?.status ?? "Available",
            images:
                combinedImages.where((element) => element.isNotEmpty).toList(),
            designCode: lineItem.taggingDetails?.design?.code,
            counter: lineItem.taggingDetails?.counter?.id,
            stockHead: lineItem.taggingDetails?.design?.stockHead?.id,
            ornamentCode:
                lineItem.taggingDetails?.designLineItem?.ornament?.code,
            ornamentName:
                lineItem.taggingDetails?.designLineItem?.ornament?.name,
            originalGwt: lineItem.taggingGrossWeight ?? "0",
            originalNwt: lineItem.taggingNetWeight ?? "0",
            rate: TextEditingController(text: lineItem.rate),
            barcode: lineItem.taggingDetails?.tagBarcode ?? "",
            designMakingChargesTypeId:
                lineItem.taggingDetails?.design?.makingChargeType?.id,
          );

          if (lineItem.taggingDetails?.lineStones != null) {
            tableData.stoneDetailsTableData =
                lineItem.taggingDetails!.lineStones!
                    .map(
                      (e) => StoneDetailsTableData(
                        id: e.id,
                        name: TextEditingController(text: e.name),
                        carat_weight: TextEditingController(
                          text: e.carat ?? e.weight,
                        ),
                        pcs: TextEditingController(text: e.pieces.toString()),
                        rate: TextEditingController(text: e.rate),
                        total: TextEditingController(text: e.total),
                        weightUnitFromBackend: e.carat == null ? "GM" : "CT",
                      ),
                    )
                    .toList();
          }

          controllers.insert(0, tableData);
        }
      }

      if (duplicateItems.isNotEmpty) {
        showErrorToast(
          message: 'Skipped duplicate items:\n${duplicateItems.join("\n")}',
        );
      }

      updateTotals();
      controllers.refresh();
    }
  }
}
