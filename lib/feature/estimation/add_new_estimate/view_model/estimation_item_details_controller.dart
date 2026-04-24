// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/sales_person_selection_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/calculator/estimation_calculator.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

import 'estimation_payment_details_controller.dart';

class EstimationItemDetailsTableData {
  String sn;
  TextEditingController code;
  TextEditingController tagNo;
  String gst;
  TextEditingController item_description;
  TextEditingController pcs;
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

  String wst_unit = "%"; // will be either "%" or "gm";
  List<StoneDetailsTableData> stoneDetailsTableData = [];

  GetTaggingLineItemCodeTagResponse? itemResponse;

  GetEmployeesValue? employeeDetails;
  String barcode;
  TextEditingController rate;
  List<FocusNode> tableFocusNodes = List.generate(8, (index) => FocusNode());

  EstimationItemDetailsTableData({
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
    this.gst = "0",
    this.images = const [],
    required this.originalMc,
    required this.originalVa,
    this.itemResponse,
    required this.barcode,
    required this.rate,
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

class EstimationItemDetailsController extends GetxController {
  bool isProgrammaticFocus = false;

  final InventoryRepository _inventoryRepository = InventoryRepository();
  // final EstimationViewModel estimationViewModel =
  //     Get.find<EstimationViewModel>();

  // Update headers list to include rate
  final headers = [
    'Sn',
    'G.Wt',
    'N.Wt',
    'VA',
    'MC',
    'Stone',
    'Amount',
    'Total',
    '',
  ];

  // Update column widths to include new column
  final columnWidths = [
    0.08, // Sn
    0.5, // G.Wt.
    0.5, // N.Wt.
    0.5, // VA
    0.4, // MC
    0.5, // Stone Cost
    0.5, // Sales Amount
    0.5, // Total
    0.1, // Empty (for actions)
  ];

  final totalColumnWidthsOldGold = [0.8, 0.2, 0.3, 2.0, 0.3, 0.1];

  List<String> popUpValues = ["View", "Return", "Edit", "Delete"];
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<EstimationItemDetailsTableData> controllers =
      <EstimationItemDetailsTableData>[].obs;
  final RxList<String> totalHeadersValue = <String>["Total"].obs;
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

  bool hasInvalidRates() {
    return controllers.any((controller) {
      final rateValue = double.tryParse(controller.rate.text) ?? 0;
      return rateValue <= 0;
    });
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
      EstimationItemDetailsTableData(
        sn: (controllers.length + 1).toString(),
        code: TextEditingController(),
        tagNo: TextEditingController(),
        item_description: TextEditingController(text: ""),
        pcs: TextEditingController(text: "1"),
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
        barcode: "",
        rate: TextEditingController(text: "0"),
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

  void updateTotals() {
    // double totalPcs = 0;
    // double totalGWt = 0;

    // double totalNWt = 0;
    // ignore: unused_local_variable
    double totalVATch = 0;
    double totalMC = 0;
    double totalStone = 0;
    // double hallMark = 0;
    // double rate = 0;
    // double costDiscount = 0;
    double salesAmount = 0;
    double totalAmount = 0;

    for (var row in controllers) {
      // totalPcs += double.tryParse(row.pcs.text) ?? 0;
      // totalGWt += double.tryParse(row.gwt.text) ?? 0;

      // totalNWt += double.tryParse(row.nwt.text) ?? 0;
      totalVATch += double.tryParse(row.va.text) ?? 0;

      final mcRate = double.tryParse(row.mc.text) ?? 0;
      final makingChargesType =
          row.itemResponse?.designLineItem?.makingChargesType?.toLowerCase();

      double mcTotal = 0;
      if (makingChargesType == "gwt") {
        // Multiply by gross weight
        final gwt = double.tryParse(row.gwt.text) ?? 0;
        mcTotal = mcRate * gwt;
      } else if (makingChargesType == "nwt") {
        // Multiply by net weight
        final nwt = double.tryParse(row.nwt.text) ?? 0;
        mcTotal = mcRate * nwt;
      } else {
        mcTotal = mcRate;
      }

      totalMC += mcTotal;

      totalStone += double.tryParse(row.stone.text) ?? 0;
      // hallMark += double.tryParse(row.hallMark.text) ?? 0;

      // costDiscount += double.tryParse(row.costDiscount.text) ?? 0;
      salesAmount += double.tryParse(row.salesAmount) ?? 0;
      totalAmount += double.tryParse(row.total) ?? 0;
    }

    totalHeadersValue.value = [
      "", // Sn
      "Total", // G.wt
      "", // N.wt
      "", // VA (if needed)
      totalMC.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      salesAmount.toStringAsFixed(2),
      totalAmount.toStringAsFixed(2),
      "",
    ];
    update();
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
      getLatestRowInFocus();
      updateTotals();
    }
  }

  void getLatestRowInFocus() {
    if (controllers.isEmpty) return;

    isProgrammaticFocus = true;

    currentRowIndex.value = controllers.length - 1;
    currentColIndex.value = 0;

    controllers.last.tableFocusNodes[0].requestFocus();

    Future.delayed(const Duration(milliseconds: 50), () {
      isProgrammaticFocus = false;
    });
  }

  bool validateRow() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
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
    if (controllers.isEmpty) return;

    // 🔥 Dispose BEFORE removing
    final item = controllers[index];

    item.code.dispose();
    item.tagNo.dispose();
    item.item_description.dispose();
    item.pcs.dispose();
    item.gwt.dispose();
    item.nwt.dispose();
    item.va.dispose();
    item.mc.dispose();
    item.stone.dispose();
    item.hallMark.dispose();
    item.costDiscount.dispose();
    item.rate.dispose();

    for (var node in item.tableFocusNodes) {
      node.dispose();
    }

    if (controllers.length == 1) {
      controllers[index] = _createEmptyRow(item.sn);
    } else {
      controllers.removeAt(index);

      for (int i = 0; i < controllers.length; i++) {
        controllers[i].sn = (i + 1).toString();
      }

      currentRowIndex.value = index > 0 ? index - 1 : 0;
    }

    updateTotals();
    controllers.refresh();
    update();
  }

  EstimationItemDetailsTableData _createEmptyRow(String sn) {
    return EstimationItemDetailsTableData(
      sn: sn,
      code: TextEditingController(),
      tagNo: TextEditingController(),
      item_description: TextEditingController(text: ""),
      pcs: TextEditingController(text: "1"),
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
      barcode: "",
      rate: TextEditingController(text: "0"),
    );
  }

  void clearControllers() {
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.clear();
    // _debouncers.clear();
    addRow();
    updateTotals();
  }

  Future<void> fetchTaggingLineItemCodeTag(int index) async {
    final EstimationViewModel estimationViewModel =
        Get.find<EstimationViewModel>();
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
          metal_type_id: estimationViewModel.selectedMetalType.value,
        );

        controllers[index].itemResponse = response;
        controllers[index].barcode = response.tagBarcode ?? "";
        controllers[index].code.text = response.code ?? "";
        controllers[index].tagNo.text =
            response.tagNumber != null ? response.tagNumber.toString() : "";
        controllers[index].costDiscount.text = "0";

        controllers[index].item_description.text = response.design?.name ?? '';
        controllers[index].pcs.text = response.pieces?.toString() ?? '0';
        controllers[index].gwt.text = response.grossWeight ?? '0';
        controllers[index].nwt.text = response.netWeight ?? '0';
        controllers[index].va.text = response.va ?? '0';
        controllers[index].originalVa = double.tryParse(response.va ?? "") ?? 0;
        controllers[index].mc.text = response.mc ?? '0';
        controllers[index].originalMc = double.tryParse(response.mc ?? "") ?? 0;
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

        List<String> combinedImages = [
          ...(response.images?.map((image) => image.presignedUrl ?? '') ?? []),
          ...(response.design?.images?.map(
                (image) => image.presignedUrl ?? '',
              ) ??
              []),
        ];
        controllers[index].images =
            combinedImages.where((element) => element.isNotEmpty).toList();
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

        log(
          "The images fetched are ${response.design?.images?.map((image) => image.presignedUrl ?? '').toList() ?? []}",
        );
        log("The images fetched are $combinedImages");
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

        // VALIDATION BLOCK
        final rateValue = controllers[index].rate.text.trim();

        bool isRateInvalid =
            rateValue.isEmpty ||
            rateValue == "0" ||
            rateValue == "null" ||
            rateValue == "-";

        if (isRateInvalid) {
          showErrorToast(message: "Please update the rates");
        }

        calculateSalesAndTotalAmountFromFetchedItems(index: index);
        updateTotals();
        update();

        controllers.refresh();
        // Show sales person dialog after successfully fetching item data

        final GlobalSettingsViewModel globalSettingsViewModel =
            Get.find<GlobalSettingsViewModel>();

        final askSalesPersonDetails =
            globalSettingsViewModel
                .getGlobalSettingsResponse
                .value
                .data
                ?.estimatePreference
                ?.askSalesPersonDetails ??
            false;

        if (askSalesPersonDetails) {
          // Show sales person dialog only if enabled in global settings
          SalesPersonDialog.show(
            context: Get.context!,
            rowIndex: index,
            title: 'Select Sales Person for ${response.code}',
          );
        }
        showSuccessToast(message: "Fetched successfully!");

        // Check if we're in correction mode (not fast mode)
        if (!estimationViewModel.isFastMode.value) {
          // In correction mode, focus on GWT field (index 4) of the same row
          controllers[index].tableFocusNodes[4].requestFocus();
          currentColIndex.value = 4; // Update the column index to GWT
        } else {
          // In fast mode, continue with existing behavior
          moveNextFocus();
          if (currentRowIndex.value == controllers.length - 1) {
            validateAndAddRow();
          }
        }
      } catch (e, s) {
        log("Error fetching item $e ");
        log("Error fetching item $s ");
        // Reset values in the existing controller instead of creating new instance
        controllers[index].itemResponse = null;
        controllers[index].code.text = itemCode;
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

        controllers[index].images = [];
        controllers[index].stoneDetailsTableData = [];
        controllers.refresh();
        showErrorToast(message: "Item not found");
      }
    }
  }

  Future<void> fetchTaggingLineItemByBarcode(int index, String barcode) async {
    // final barcode = controllers[index].barcode.text;
    log("fetching barcode $barcode");
    if (barcode.isNotEmpty) {
      bool isDuplicate = controllers.asMap().entries.any(
        (entry) =>
            entry.key != index && // Skip current row
            entry.value.barcode == barcode,
      );

      if (isDuplicate) {
        showErrorToast(message: 'Item with same barcode already exists');
        // Clear the barcode
        controllers[index].barcode = '';
        return;
      }

      try {
        final response = await _inventoryRepository.getTaggingLineItemByBarcode(
          barcode,
        );
        if (response.status?.toLowerCase() != "available") {
          showErrorToast(message: "Item not found!");
          throw Exception("Item status is ${response.status}");
        }
        controllers[index].itemResponse = response;

        // Fill in the data from response
        controllers[index].code.text = response.code ?? "";
        controllers[index].tagNo.text =
            response.tagNumber != null ? response.tagNumber.toString() : "";
        controllers[index].costDiscount.text = "0";
        controllers[index].item_description.text = response.design?.name ?? '';
        controllers[index].pcs.text = response.pieces?.toString() ?? '0';
        controllers[index].gwt.text = response.grossWeight ?? '0';
        controllers[index].nwt.text = response.netWeight ?? '0';
        controllers[index].va.text = response.va ?? '0';
        controllers[index].originalVa = double.tryParse(response.va ?? "") ?? 0;
        controllers[index].mc.text = response.mc ?? '0';
        controllers[index].originalMc = double.tryParse(response.mc ?? "") ?? 0;
        controllers[index].barcode = response.tagBarcode ?? "";

        // Calculate stone total
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

        // Combine and process images
        List<String> combinedImages = [
          ...(response.images?.map((image) => image.presignedUrl ?? '') ?? []),
          ...(response.design?.images?.map(
                (image) => image.presignedUrl ?? '',
              ) ??
              []),
        ];

        controllers[index].images =
            combinedImages.where((element) => element.isNotEmpty).toList();

        // Process stone details
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
                    weightUnitFromBackend: e.carat == null ? "gm" : "CT",
                  ),
                )
                .toList() ??
            [];
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
        // VALIDATION BLOCK

        final rateValue = controllers[index].rate.text.trim();

        bool isRateInvalid =
            rateValue.isEmpty ||
            rateValue == "0" ||
            rateValue == "null" ||
            rateValue == "-";

        if (isRateInvalid) {
          showErrorToast(message: "Please update the rates");
        }
        // Calculate amounts and update
        calculateSalesAndTotalAmountFromFetchedItems(index: index);
        updateTotals();
        update();
        controllers.refresh();
        // Show sales person dialog after successfully fetching item data

        final GlobalSettingsViewModel globalSettingsViewModel =
            Get.find<GlobalSettingsViewModel>();
        final askSalesPersonDetails =
            globalSettingsViewModel
                .getGlobalSettingsResponse
                .value
                .data
                ?.estimatePreference
                ?.askSalesPersonDetails ??
            false;

        if (askSalesPersonDetails) {
          SalesPersonDialog.show(
            context: Get.context!,
            rowIndex: index,
            title: 'Select Sales Person for ${response.code}',
          );
        }
        showSuccessToast(message: "Fetched successfully!");
        final EstimationViewModel estimationViewModel =
            Get.find<EstimationViewModel>();

        // Check if we're in correction mode (not fast mode)
        if (!estimationViewModel.isFastMode.value) {
          // In correction mode, focus on GWT field (index 4) of the same row
          controllers[index].tableFocusNodes[4].requestFocus();
          currentColIndex.value = 4; // Update the column index to GWT
        } else {
          // In fast mode, continue with existing behavior
          moveNextFocus();
          if (currentRowIndex.value == controllers.length - 1) {
            validateAndAddRow();
          }
        }
      } catch (e, s) {
        log("Error fetching item $e");
        log("Error fetching item $s");

        // Reset all values
        controllers[index].itemResponse = null;
        controllers[index].barcode = "";
        // controllers[index].code.text = "";
        controllers[index].tagNo.text = "";
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

        controllers[index].images = [];
        controllers[index].stoneDetailsTableData = [];

        controllers.refresh();
        showErrorToast(message: "Item not found");
      }
    }
  }

  List<EstimationItemDetailsTableData> getSortedEstimationList({
    required String sortBy,
  }) {
    // Create a copy of the list to avoid modifying the original
    final sortedList = List<EstimationItemDetailsTableData>.from(controllers);

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

  Future<void> addSalesAndTotalAmount({required int index}) async {
    JewelryCalculationReport report = await calculateJewelryPricing(index);
    // Update the controllers with calculated values
    controllers[index].salesAmount = report.calculations.subTotal
        .toStringAsFixed(2);
    print(
      "Value is changing ${report.calculations.subTotal.toStringAsFixed(2)}",
    );
    controllers[index].total = report.calculations.total.toStringAsFixed(2);

    updateTotals();
    update();
    controllers.refresh();
  }

  // Example of how to use in the original controller functions:
  Future<void> calculateSalesAndTotalAmountFromFetchedItems({
    required int index,
  }) async {
    final item = controllers[index];
    String? wastageType = item.itemResponse?.designLineItem?.wastageType;

    // Set the VA value according to the wastage type
    if (wastageType?.toLowerCase() == "%") {
      // For percentage, store the percentage value
      item.va.text = item.originalVa.toStringAsFixed(3);
      item.wst_unit = "%"; // Update the unit for display
    } else {
      // For weight-based, store the weight in grams
      item.va.text = item.originalVa.toStringAsFixed(
        3,
      ); // 3 decimal places for weight
      item.wst_unit = "gm"; // Update the unit for display
    }

    // Set the MC value based on making charges type
    // String? mcType = item.itemResponse?.designLineItem?.makingChargesType;
    item.mc.text = item.originalMc.toStringAsFixed(2);

    // Use the jewelry calculator for total calculations
    JewelryCalculationReport report = await calculateJewelryPricing(index);

    // Update the controllers with calculated values
    item.salesAmount = report.calculations.subTotal.ceil().toStringAsFixed(2);
    item.total = report.calculations.total.ceil().toStringAsFixed(2);

    updateTotals();
    controllers.refresh();
  }

  // Add new validation method for VA and MC changes
  bool validateVAMCChanges({
    required int index,
    required String field, // 'va' or 'mc'
    required String newValue,
  }) {
    try {
      double inputValue = double.tryParse(newValue) ?? 0;

      if (field == 'va') {
        // Get minimum VA
        double minVa =
            double.tryParse(
              controllers[index].itemResponse?.designLineItem?.minVa ?? "0",
            ) ??
            0;

        String? wastageType =
            controllers[index].itemResponse?.designLineItem?.wastageType;

        // Direct comparison of values
        if (inputValue < minVa) {
          if (wastageType?.toLowerCase() == "%") {
            showErrorToast(message: "VA cannot be less than minimum: $minVa%");
          } else {
            showErrorToast(
              message: "VA cannot be less than minimum: $minVa gm",
            );
          }
          return false;
        }
      } else if (field == 'mc') {
        // Get minimum MC
        double minMc =
            double.tryParse(
              controllers[index].itemResponse?.designLineItem?.minMc ?? "0",
            ) ??
            0;

        String? mcType =
            controllers[index].itemResponse?.designLineItem?.makingChargesType;

        // For MC, the comparison depends on the type
        if (mcType?.toLowerCase() == "gwt" || mcType?.toLowerCase() == "nwt") {
          // Per gram rate should be compared directly
          if (inputValue < minMc) {
            showErrorToast(
              message: "MC rate cannot be less than minimum: $minMc per gram",
            );
            return false;
          }
        } else {
          // Per piece
          if (inputValue < minMc) {
            showErrorToast(message: "MC cannot be less than minimum: $minMc");
            return false;
          }
        }
      }

      return true;
    } catch (e) {
      showErrorToast(message: "Invalid value entered");
      return false;
    }
  }

  bool hasSoldItems() {
    return controllers.any(
      (controller) => controller.itemResponse?.status?.toLowerCase() == 'sold',
    );
  }

  bool hasNoSalesPerson() {
    return controllers.any((controller) => controller.employeeDetails == null);
  }

  bool validateNoSoldItems() {
    if (hasSoldItems()) {
      showErrorToast(message: "Estimation contains sold items");
      return false;
    }
    return true;
  }

  final CustomDebouncer debouncer = CustomDebouncer(milliseconds: 500);

  void onEmployeeSelected({
    required int rowIndex,
    required GetEmployeesValue employee,
  }) {
    controllers.elementAt(rowIndex).employeeDetails = employee;
    controllers.refresh();
    log("here is the employee");
    update();
  }

  // Add this method to EstimationItemDetailsController
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
            // Track duplicate item for showing in toast
            duplicateItems.add("Code: $itemCode, Tag: $tagNumber");
            continue; // Skip this item
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

          final itemResponse = GetTaggingLineItemCodeTagResponse(
            id: lineItem.taggingId,
            organizationId: lineItem.taggingDetails?.organizationId,
            shopId: lineItem.taggingDetails?.organizationId,
            code: lineItem.code,
            tagNumber: int.tryParse(lineItem.tag ?? ""),
            pieces: (lineItem.taggingDetails?.pieces),
            grossWeight: lineItem.finalGrossWeight,
            netWeight: lineItem.finalNetWeight,
            va: lineItem.taggingVa,
            mc: lineItem.taggingMc,
            design: lineItem.taggingDetails?.design,
            tagBarcode: lineItem.taggingDetails?.tagBarcode,
            designLineItem: lineItem.taggingDetails?.designLineItem,
          );

          final tableData = EstimationItemDetailsTableData(
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
            va: TextEditingController(text: lineItem.finalVa),
            mc: TextEditingController(text: (lineItem.finalMc ?? "0")),
            stone: TextEditingController(text: lineItem.stoneCost ?? '0'),
            hallMark: TextEditingController(text: lineItem.hallMark ?? ''),
            costDiscount: TextEditingController(text: lineItem.discount ?? "0"),
            salesAmount: lineItem.salesAmount ?? "",
            total: lineItem.totalAmount ?? "",
            gst: lineItem.taggingDetails?.designLineItem?.ornament?.gst ?? "0",
            originalMc: double.tryParse(lineItem.taggingMc ?? "0") ?? 0,
            originalVa: double.tryParse(lineItem.taggingVa ?? "0") ?? 0,
            rate: TextEditingController(text: lineItem.rate),
            itemResponse: itemResponse,
            images:
                combinedImages.where((element) => element.isNotEmpty).toList(),
            barcode: lineItem.taggingDetails?.tagBarcode ?? "",
            // wst_unit: wstUnit, // Set the appropriate unit for display
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
                        weightUnitFromBackend: e.carat == null ? "gm" : "CT",
                      ),
                    )
                    .toList();
          }
          tableData.employeeDetails = lineItem.salesPerson;

          controllers.insert(0, tableData);
        }
      }
      if (duplicateItems.isNotEmpty) {
        showErrorToast(
          message: 'Skipped duplicate items:\n${duplicateItems.join("\n")}',
        );
      }

      // Update UI
      updateTotals();
      controllers.refresh();
    }
  }

  void onRateChanged(double rate, String carat) {
    // Debug logging to identify the issue
    log("onRateChanged called with rate: $rate, carat: $carat");

    // Log all item purities for debugging
    for (var item in controllers) {
      log("Item purity: ${item.itemResponse?.purity}, comparing with: $carat");
    }

    // Fix: Use lowercase comparison and handle the purity format properly
    controllers
        .where((item) {
          final itemPurity = (item.itemResponse?.purity ?? "22k").toLowerCase();
          final targetPurity = carat.toLowerCase();

          // Handle different purity formats (e.g., "22k" vs "22K" vs "22 K")
          final normalizedItemPurity = itemPurity.replaceAll(' ', '');
          final normalizedTargetPurity = targetPurity.replaceAll(' ', '');

          log(
            "Comparing normalized purities: $normalizedItemPurity vs $normalizedTargetPurity",
          );

          return normalizedItemPurity == normalizedTargetPurity;
        })
        .forEach((item) {
          log("Updating rate for item ${item.code.text} to $rate");
          item.rate.text = rate.toString();
          calculateSalesAndTotalAmountFromFetchedItems(
            index: controllers.indexOf(item),
          );
        });

    updateTotals();
  }

  void resetRow(int index) {
    // Store the original serial number
    String originalSn = controllers[index].sn;

    // Reset all TextEditingControllers
    controllers[index].code.clear();
    controllers[index].tagNo.clear();
    controllers[index].item_description.clear();
    controllers[index].pcs.clear();
    controllers[index].gwt.clear();
    controllers[index].nwt.clear();
    controllers[index].va.clear();
    controllers[index].mc.clear();
    controllers[index].stone.clear();
    controllers[index].hallMark.clear();
    controllers[index].costDiscount.clear();
    controllers[index].rate.clear();

    // Reset numeric values
    controllers[index].originalVa = 0.0;
    controllers[index].originalMc = 0.0;

    // Reset string values
    controllers[index].gst = "0";
    controllers[index].salesAmount = "";
    controllers[index].total = "";
    controllers[index].wst_unit = "%";
    controllers[index].barcode = "";

    // Clear lists
    controllers[index].images.clear();
    controllers[index].stoneDetailsTableData.clear();

    // Reset references
    controllers[index].itemResponse = null;
    controllers[index].employeeDetails = null;

    // Restore the original serial number
    controllers[index].sn = originalSn;

    // Update UI
    updateTotals();
    controllers.refresh();
    update();
  }

  Future<JewelryCalculationReport> calculateJewelryPricing(int index) async {
    double? metalRate;
    final item = controllers[index];
    // Get values from the controllers
    double nettWeight = double.tryParse(item.nwt.text) ?? 0;
    double grossWeight = double.tryParse(item.gwt.text) ?? 0;

    // if (item.itemResponse?.design?.makingChargeType?.id == "1") {
    //   final rated = await _inventoryRepository.getLatestDailyRate();

    //   final silver925Value = rated
    //       .toJson()
    //       .entries
    //       .firstWhere(
    //           (entry) => entry.key.contains(item.itemResponse?.purity ?? ""),
    //           orElse: () => const MapEntry('', null))
    //       .value;
    //   metalRate = double.tryParse("${silver925Value ?? "0"}") ?? 0;
    // } else {
    //   metalRate = double.tryParse(item.rate.text) ?? 0;
    // }

    metalRate = double.tryParse(item.rate.text) ?? 0;
    double stoneCost = double.tryParse(item.stone.text) ?? 0;
    double hallMarkCost = double.tryParse(item.hallMark.text) ?? 0;
    double costDiscount = double.tryParse(item.costDiscount.text) ?? 0;

    // Determine VA type and value
    String? wastageType = item.itemResponse?.designLineItem?.wastageType;
    VAType vaType = getVAType(wastageType);

    // The VA value depends on the type - use what's in the text field, which should be either percentage or grams
    double vaValue = double.tryParse(item.va.text) ?? 0;

    // Determine MC type and value
    String? mcType = item.itemResponse?.designLineItem?.makingChargesType;
    MCType mcTypeEnum = getMCType(mcType);
    double mcValue = double.tryParse(item.mc.text) ?? 0;

    // Get GST information
    bool isGstApplicable =
        true; // You may need to adjust this based on your business logic
    double gstPercentage =
        (double.tryParse(
              item.itemResponse?.designLineItem?.ornament?.gst ?? "0",
            ) ??
            0);

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
      isWeightPcRate: item.itemResponse?.design?.makingChargeType?.id == "3",
      isPcRateOnly: item.itemResponse?.design?.makingChargeType?.id == "4",
    );

    // Generate the calculation report
    return calculator.generateReport();
  }

  // Add this function to the EstimationItemDetailsController class

  void distributeJewellerDiscount({
    required double jewellerDiscount,
    bool vaFirst = true,
    required double gstPercent,
  }) {
    // Validate the input - early return if discount is negative
    if (jewellerDiscount < 0) {
      showErrorToast(message: 'Discount amount cannot be negative');
      EstimationPaymentDetailsController estimationViewModel =
          Get.find<EstimationPaymentDetailsController>();
      double difference = 0;
      estimationViewModel.setAdditionalLess(value: difference);
      return;
    }

    double remainingDiscount = jewellerDiscount;

    // Reset VA and MC to original values first - using helper method for clarity
    _resetVAAndMCToOriginalValues();

    // If discount is 0, just update totals and return
    if (jewellerDiscount == 0) {
      _recalculateAllTotals();
      EstimationPaymentDetailsController estimationViewModel =
          Get.find<EstimationPaymentDetailsController>();
      double difference = 0;
      estimationViewModel.setAdditionalLess(value: difference);
      return;
    }

    // Calculate maximum possible discount across all items
    double maxPossibleDiscount = _calculateMaxPossibleDiscount();
    log("Max possible discount : $maxPossibleDiscount");

    if (jewellerDiscount > maxPossibleDiscount) {
      showErrorToast(
        message:
            'Maximum possible discount is ${maxPossibleDiscount.toStringAsFixed(2)}',
      );
      EstimationPaymentDetailsController estimationViewModel =
          Get.find<EstimationPaymentDetailsController>();
      double difference = jewellerDiscount - maxPossibleDiscount;
      estimationViewModel.setAdditionalLess(
        value: difference + difference * (gstPercent / 100),
      );
    }

    // Process each line item
    for (int i = 0; i < controllers.length && remainingDiscount > 0; i++) {
      var lineItem = controllers[i];

      // Calculate maximum discounts for this line item
      var maxDiscounts = _calculateMaxDiscountsForLineItem(lineItem);
      double maxVADiscount = maxDiscounts['va'] ?? 0;
      double maxMCDiscount = maxDiscounts['mc'] ?? 0;

      // Log for debugging
      log(
        "Line item ${i + 1}: Max discounts VA=$maxVADiscount, MC=$maxMCDiscount",
      );

      // Determine discount distribution based on priority
      Map<String, double> discounts = _distributeDiscountByPriority(
        remainingDiscount: remainingDiscount,
        maxVADiscount: maxVADiscount,
        maxMCDiscount: maxMCDiscount,
        vaFirst: vaFirst,
      );

      double vaDiscount = discounts['va'] ?? 0;
      double mcDiscount = discounts['mc'] ?? 0;

      // Apply the calculated discounts
      _applyDiscounts(lineItem, vaDiscount, mcDiscount);

      // Update remaining discount
      double totalAppliedDiscount = vaDiscount + mcDiscount;
      remainingDiscount -= totalAppliedDiscount;

      log(
        "Applied discounts: VA=$vaDiscount, MC=$mcDiscount, Remaining=$remainingDiscount",
      );
    }

    // Update all totals
    _recalculateAllTotals();
  }

  // Helper method to reset all VA and MC values to their original state
  void _resetVAAndMCToOriginalValues() {
    for (int i = 0; i < controllers.length; i++) {
      var lineItem = controllers[i];

      // Set VA to original value based on type
      String? wastageType = lineItem.itemResponse?.designLineItem?.wastageType;
      if (wastageType?.toLowerCase() == "%") {
        lineItem.va.text = lineItem.originalVa.toStringAsFixed(2);
      } else {
        lineItem.va.text = lineItem.originalVa.toStringAsFixed(3);
      }

      // Set MC to original value
      lineItem.mc.text = lineItem.originalMc.toStringAsFixed(2);
    }
  }

  // Helper method to calculate the maximum possible discount across all items
  double _calculateMaxPossibleDiscount() {
    return controllers.fold<double>(0, (sum, lineItem) {
      // Calculate maximum discounts for this line item
      var maxDiscounts = _calculateMaxDiscountsForLineItem(lineItem);
      double vaRoom = maxDiscounts['va'] ?? 0;
      double mcRoom = maxDiscounts['mc'] ?? 0;

      log(
        "Item ${lineItem.code.text}: VA discount room=$vaRoom, MC discount room=$mcRoom",
      );
      return sum + vaRoom + mcRoom;
    });
  }

  // Helper method to calculate max VA and MC discounts for a single line item
  Map<String, double> _calculateMaxDiscountsForLineItem(
    EstimationItemDetailsTableData lineItem,
  ) {
    // Create calculators for VA
    JewelryCalculator vaCalculator = JewelryCalculator(
      nettWeight: double.tryParse(lineItem.nwt.text) ?? 0,
      vaType: getVAType(lineItem.itemResponse?.designLineItem?.wastageType),
      vaValue: lineItem.originalVa,
      metalRate: double.tryParse(lineItem.rate.text) ?? 0,
      grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
    );

    JewelryCalculator minVaCalculator = JewelryCalculator(
      nettWeight: double.tryParse(lineItem.nwt.text) ?? 0,
      vaType: getVAType(lineItem.itemResponse?.designLineItem?.wastageType),
      vaValue:
          double.tryParse(
            lineItem.itemResponse?.designLineItem?.minVa ?? "0",
          ) ??
          0,
      metalRate: double.tryParse(lineItem.rate.text) ?? 0,
      grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
    );

    // Calculate maximum VA discount
    double vaRoom =
        vaCalculator.calculateMetalCost() -
        minVaCalculator.calculateMetalCost();

    // Create calculators for MC
    JewelryCalculator mcCalculator = JewelryCalculator(
      nettWeight: double.tryParse(lineItem.nwt.text) ?? 0,
      mcType: getMCType(
        lineItem.itemResponse?.designLineItem?.makingChargesType,
      ),
      mcValue: lineItem.originalMc,
      grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
      metalRate: double.tryParse(lineItem.rate.text) ?? 0,
    );

    JewelryCalculator minMcCalculator = JewelryCalculator(
      nettWeight: double.tryParse(lineItem.nwt.text) ?? 0,
      mcType: getMCType(
        lineItem.itemResponse?.designLineItem?.makingChargesType,
      ),
      mcValue:
          double.tryParse(
            lineItem.itemResponse?.designLineItem?.minMc ?? "0",
          ) ??
          0,
      grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
      metalRate: double.tryParse(lineItem.rate.text) ?? 0,
    );

    // Calculate maximum MC discount
    double mcRoom =
        mcCalculator.calculateMakingCharge() -
        minMcCalculator.calculateMakingCharge();

    // Return both maximum discounts
    return {'va': vaRoom, 'mc': mcRoom};
  }

  // Helper method to distribute discount based on priority (VA first or MC first)
  Map<String, double> _distributeDiscountByPriority({
    required double remainingDiscount,
    required double maxVADiscount,
    required double maxMCDiscount,
    required bool vaFirst,
  }) {
    double vaDiscount = 0;
    double mcDiscount = 0;

    if (vaFirst) {
      // Apply to VA first, then MC
      vaDiscount =
          remainingDiscount > maxVADiscount ? maxVADiscount : remainingDiscount;
      double remainingAfterVA = remainingDiscount - vaDiscount;

      if (remainingAfterVA > 0) {
        mcDiscount =
            remainingAfterVA > maxMCDiscount ? maxMCDiscount : remainingAfterVA;
      }
    } else {
      // Apply to MC first, then VA
      mcDiscount =
          remainingDiscount > maxMCDiscount ? maxMCDiscount : remainingDiscount;
      double remainingAfterMC = remainingDiscount - mcDiscount;

      if (remainingAfterMC > 0) {
        vaDiscount =
            remainingAfterMC > maxVADiscount ? maxVADiscount : remainingAfterMC;
      }
    }

    return {'va': vaDiscount, 'mc': mcDiscount};
  }

  // Helper method to apply the calculated discounts to a line item
  void _applyDiscounts(
    EstimationItemDetailsTableData lineItem,
    double vaDiscount,
    double mcDiscount,
  ) {
    // Handle VA discount
    _applyVADiscount(lineItem, vaDiscount);

    // Handle MC discount
    _applyMCDiscount(lineItem, mcDiscount);
  }

  // Helper method to apply VA discount based on type
  void _applyVADiscount(
    EstimationItemDetailsTableData lineItem,
    double vaDiscount,
  ) {
    String? wastageType = lineItem.itemResponse?.designLineItem?.wastageType;

    if (wastageType?.toLowerCase() == "%") {
      // For percentage VA
      double originalVaPercentage = lineItem.originalVa;
      double minVaPercentage =
          double.tryParse(
            lineItem.itemResponse?.designLineItem?.minVa ?? "0",
          ) ??
          0;
      double netWeight = double.tryParse(lineItem.nwt.text) ?? 0;
      double currentRate = double.tryParse(lineItem.rate.text) ?? 0;

      // Calculate discount percentage points proportional to the monetary discount
      double vaPerDiscount = (vaDiscount / (netWeight * currentRate / 100));

      // Calculate new VA percentage (ensure it's not below minimum)
      double newVaPercentage = math.max(
        originalVaPercentage - vaPerDiscount,
        minVaPercentage,
      );

      // Update VA value
      lineItem.va.text = newVaPercentage.toStringAsFixed(2);
    } else {
      // For gram-based VA
      double originalVaGrams = lineItem.originalVa;
      double minVaGrams =
          double.tryParse(
            lineItem.itemResponse?.designLineItem?.minVa ?? "0",
          ) ??
          0;
      double currentRate = double.tryParse(lineItem.rate.text) ?? 0;

      // Calculate the discount in grams
      double vaGramsDiscount = vaDiscount / currentRate;

      // Calculate new VA grams (ensure it's not below minimum)
      double newVaGrams = math.max(
        originalVaGrams - vaGramsDiscount,
        minVaGrams,
      );

      // Update VA value
      lineItem.va.text = newVaGrams.toStringAsFixed(3);
    }
  }

  // Helper method to apply MC discount based on type
  void _applyMCDiscount(
    EstimationItemDetailsTableData lineItem,
    double mcDiscount,
  ) {
    String? mcType = lineItem.itemResponse?.designLineItem?.makingChargesType;

    if (mcType?.toLowerCase() == "gwt") {
      // Per gram on gross weight
      double originalMcRate = lineItem.originalMc;
      double minMcRate =
          double.tryParse(
            lineItem.itemResponse?.designLineItem?.minMc ?? "0",
          ) ??
          0;
      double grossWeight = double.tryParse(lineItem.gwt.text) ?? 0;

      // Calculate the discount in rate
      double mcRateDiscount = mcDiscount / grossWeight;

      // Calculate new MC rate (ensure it's not below minimum)
      double newMcRate = math.max(originalMcRate - mcRateDiscount, minMcRate);

      // Update MC value
      lineItem.mc.text = newMcRate.toStringAsFixed(2);
    } else if (mcType?.toLowerCase() == "nwt") {
      // Per gram on net weight
      double originalMcRate = lineItem.originalMc;
      double minMcRate =
          double.tryParse(
            lineItem.itemResponse?.designLineItem?.minMc ?? "0",
          ) ??
          0;
      double netWeight = double.tryParse(lineItem.nwt.text) ?? 0;

      // Calculate the discount in rate
      double mcRateDiscount = mcDiscount / netWeight;

      // Calculate new MC rate (ensure it's not below minimum)
      double newMcRate = math.max(originalMcRate - mcRateDiscount, minMcRate);

      // Update MC value
      lineItem.mc.text = newMcRate.toStringAsFixed(2);
    } else {
      // Per piece
      double originalMcAmount = lineItem.originalMc;
      double minMcAmount =
          double.tryParse(
            lineItem.itemResponse?.designLineItem?.minMc ?? "0",
          ) ??
          0;

      // Calculate new MC amount (ensure it's not below minimum)
      double newMcAmount = math.max(originalMcAmount - mcDiscount, minMcAmount);

      // Update MC value
      lineItem.mc.text = newMcAmount.toStringAsFixed(2);
    }
  }

  // Helper method to recalculate all totals
  void _recalculateAllTotals() {
    for (int i = 0; i < controllers.length; i++) {
      addSalesAndTotalAmount(index: i);
    }
    updateTotals();
  }
}
