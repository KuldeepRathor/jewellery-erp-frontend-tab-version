import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/talker_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/get_deisgn_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_all_designs_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/post_tagging_line_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/post_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/tagging_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/tagging_stone_details_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/barcode_template/model/barcode_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/vinayak_godex_printer/label_printer_class_stub.dart'
    if (dart.library.io) 'package:jewellery_erp_frontend_tab_version/utils/vinayak_godex_printer/label_printer_class.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/vinayak_godex_printer/weight_scale_integration.dart';

class TaggingItemDetailsTableData {
  String sn;
  RxString code;
  RxString codeType;
  RxString tag;
  TextEditingController design;
  String designId;
  String vendorId;
  String vendorCode;
  String sizeId;
  String sizeName;
  String purityText;
  bool isCounterDefault;
  String? counterId;
  String? counterName;
  TextEditingController purity;
  TextEditingController pcs;
  TextEditingController gwt;
  TextEditingController nwt;
  TextEditingController va;
  TextEditingController mc;
  TextEditingController stone;
  TextEditingController rate;
  TextEditingController huid;
  String wst_unit;
  List<StoneDetailsTableData> stoneDetailsTableData;
  List<FocusNode> tableFocusNodes;
  String codeId;
  GetDesignResponseModel? selectedDesign;
  String? lineItemId;
  TaggingItemDetailsTableData({
    required this.sn,
    String code = "-",
    String codeType = "",
    String tag = "-",
    required this.design,
    this.designId = '',
    this.vendorId = '',
    this.vendorCode = '',
    this.sizeId = '',
    this.sizeName = '',
    this.purityText = '',
    this.isCounterDefault = true,
    this.counterId,
    this.counterName,
    required this.purity,
    required this.pcs,
    required this.gwt,
    required this.nwt,
    required this.va,
    required this.mc,
    required this.stone,
    required this.rate,
    required this.huid,
    this.wst_unit = "%",
    List<StoneDetailsTableData>? stoneDetailsTableData,
    List<FocusNode>? tableFocusNodes,
    required this.codeId,
    this.selectedDesign,
    this.lineItemId,
  }) : code = code.obs,
       tag = tag.obs,
       codeType = codeType.obs,
       stoneDetailsTableData = stoneDetailsTableData ?? [],
       tableFocusNodes =
           tableFocusNodes ?? List.generate(10, (_) => FocusNode());

  Map<String, dynamic> toJsonValue() {
    return {
      'sn': sn,
      'code': code.value,
      'tag': tag.value,
      'pcs': pcs.text,
      'gwt': gwt.text,
      'design': design.text,
      'designId': designId,
      'vendorId': vendorId,
      'sizeId': sizeId,
      'counter': counterId,
      'nwt': nwt.text,
      "purityText": purityText,
      'purity': purity.text,
      'mc': mc.text,
      'stone': stone.text,
      'rate': rate.text,
      'va': va.text,
      'huid': huid.text,
      'stone_details':
          stoneDetailsTableData.map((stone) => stone.toJsonValue()).toList(),
    };
  }

  void handleDesignChange(GetDesignResponseModel? design) {
    selectedDesign = design;
    designId = design?.id ?? '';
    this.design.text = design?.name ?? '';

    // Handle stone requirement
    if (design?.stoneRequired == true) {
      if (stone.text.isEmpty) {
        stone.text = "0";
      }
    } else {
      stone.text = "0";
      stoneDetailsTableData.clear();
    }

    // Handle rate field based on making charge type
    if (design?.makingChargeType?.id == "1") {
      rate.text = "0";
    }

    // Set VA and MC if available from design line items
    if (design?.lineItems != null && design!.lineItems!.isNotEmpty) {
      final lineItem = design.lineItems!.firstWhereOrNull(
        (element) => element.purity == purity.text,
      );
      va.text = lineItem?.wastage ?? '';
      mc.text = lineItem?.makingCharges ?? '';
    }
  }

  bool get isStoneRequired => selectedDesign?.stoneRequired ?? false;
  bool get isRateRequired => selectedDesign?.makingChargeType?.id != "1";
  bool get isPcRate => selectedDesign?.makingChargeType?.id == "4";
  bool shouldGwtEqualNwt() {
    // If there are no stones or stone is not required, gwt should equal nwt

    return isStoneRequired == false;
  }

  // Helper to get numeric values
  double get gwtValue => double.tryParse(gwt.text) ?? 0.0;
  double get nwtValue => double.tryParse(nwt.text) ?? 0.0;
}

// TaggingItemDetailsController
class TaggingItemDetailsController extends GetxController {
  Uint8List? pdf;
  final headers =
      [
        'Sn',
        'Code',
        "Tag",
        'Design',
        "Purity",
        'Pcs',
        'G.Wt. (gm)',
        'N.Wt. (gm)',
        "VA",
        'MC (₹)',
        'Stone (₹)',
        'Rate (₹)',
        "HUID",
        '',
      ].obs;

  final columnWidths =
      [
        0.1,
        0.175,
        0.175,
        0.65,
        0.25,
        0.175,
        0.3,
        0.3,
        0.3,
        0.3,
        0.3,
        0.3,
        0.3,
        0.1,
      ].obs;
  final totalColumnWidths =
      [
        1.35,
        0.175,
        0.3,
        0.6,
        0.3,
        1.0,
        // 0.2,
        // 0.3,
        // 0.3,
        // 0.3,
        // 0.1,
      ].obs;

  final popUpValues = ["Delete"];
  final RxList<GetAllDesignsValue> designList = <GetAllDesignsValue>[].obs;

  final RxList<TaggingItemDetailsTableData> controllers =
      <TaggingItemDetailsTableData>[].obs;

  final RxList<String> totalHeadersValue = <String>[].obs;
  final RxString taggingRecordNumber = RxString('');

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final InventoryRepository _inventoryRepository = InventoryRepository();

  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;

  final _debouncer = CustomDebouncer(milliseconds: 1500);

  RxBool isHUIDtrue = false.obs;
  void toggleHUID() => isHUIDtrue.toggle();
  final RxBool isHuidRequired = true.obs;
  final RxBool isRateEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    getDesignList();
    // addInitialRow();
    updateTotals();
    log("Design list length: ${designList.length}");
  }

  Future<void> getDesignList() async {
    try {
      final response = await _inventoryRepository.getAllDesigns();
      designList.assignAll(response.values ?? []);
    } catch (e) {
      log('Error fetching designs: $e');
    }
  }

  void validateHuid(String value) {
    if (isHuidRequired.value) {
      if (value.isEmpty) {
        throw 'HUID is required';
      }
      if (!RegExp(r'^[A-Za-z0-9]{6}$').hasMatch(value)) {
        throw 'HUID must be 6 alphanumeric characters';
      }
    }
  }

  void setDesignId(int index, String code) async {
    final taggingController = Get.find<TaggingController>();

    // Find design from dropdown response
    final designDropdownValue = taggingController
        .getDesignDropdownResponse
        .value
        .data
        ?.values
        ?.firstWhere(
          (design) => design.code == code,
          orElse: () => GetDesignDropdownValue(),
        );

    if (designDropdownValue?.id != null) {
      // Fetch full design details
      final fullDesign = await taggingController.fetchDesignDetails(
        designDropdownValue!.id!,
      );

      if (fullDesign != null) {
        // Update the row with full design details
        final controller = controllers[index];
        controller.handleDesignChange(fullDesign);

        currentColIndex.value = 2;
        currentRowIndex.value = index;
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
        checkAndFetchTagAndCode(index);
        updateTotals();
        update();
      }
    }
  }

  void checkAndFetchTagAndCode(int index) {
    log("checkAndFetchTagAndCode called for index: $index");
    log("Design ID: '${controllers[index].designId}'");
    log("Design Text: '${controllers[index].design.text}'");
    log("GWT: '${controllers[index].gwt.text}'");
    log("NWT: '${controllers[index].nwt.text}'");

    _debouncer.run(() async {
      if (controllers[index].designId.isNotEmpty &&
          controllers[index].gwt.text.isNotEmpty &&
          controllers[index].nwt.text.isNotEmpty) {
        log("All conditions met. Calling fetchTagAndCode after debounce.");
        fetchTagAndCode(index);
      } else {
        log("Conditions not met after debounce. Not calling fetchTagAndCode.");
        if (controllers[index].designId.isEmpty) log("Design ID is empty");
        if (controllers[index].gwt.text.isEmpty) log("GWT is empty");
        if (controllers[index].nwt.text.isEmpty) log("NWT is empty");
      }
    });
  }

  void addRow() {
    log("Callin here 2");
    final taggingController = Get.find<TaggingController>();
    final requiredLineItem = taggingController.selectedDesign.value?.lineItems
        ?.firstWhereOrNull(
          (element) => element.purity == taggingController.selectedPurity.value,
        );
    final newRow = TaggingItemDetailsTableData(
      sn: (controllers.length + 1).toString(),
      code: "-",
      tag: "-",
      codeId: "-",
      designId: taggingController.selectedDesign.value?.id ?? "",
      selectedDesign: taggingController.selectedDesign.value,
      design: TextEditingController(
        text: taggingController.selectedDesign.value?.name ?? "",
      ),
      purityText: taggingController.selectedPurity.value ?? '',
      vendorId: taggingController.selectedVendorId.value ?? '',
      vendorCode: taggingController.selectedVendorCode.value ?? '',
      sizeId: taggingController.selectedSizeId.value ?? '',
      sizeName: taggingController.selectedSizeName.value ?? '',
      isCounterDefault: taggingController.isCounterDefault.value,
      counterId:
          taggingController.isCounterDefault.value
              ? taggingController.defaultCounter.value?.id
              : taggingController.selectedCounter.value?.id,
      counterName:
          taggingController.isCounterDefault.value
              ? taggingController.defaultCounter.value?.counterName
              : taggingController.selectedCounter.value?.counterName,
      purity: TextEditingController(
        text: taggingController.selectedPurity.value ?? '',
      ),
      pcs: TextEditingController(text: "1"),
      gwt: TextEditingController(),
      nwt: TextEditingController(),
      va: TextEditingController(text: requiredLineItem?.wastage ?? ""),
      mc: TextEditingController(text: requiredLineItem?.makingCharges ?? ""),
      stone: TextEditingController(text: "0"),
      rate: TextEditingController(text: "0"),
      huid: TextEditingController(),
    );

    controllers.add(newRow);
    // currentColIndex.value = 3;
    // controllers[currentRowIndex.value]
    //     .tableFocusNodes[currentColIndex.value]
    //     .requestFocus();
    updateTotals();
  }

  void addInitialRow() {
    log("Callin here 2");
    final taggingController = Get.find<TaggingController>();

    final newRow = TaggingItemDetailsTableData(
      sn: (controllers.length + 1).toString(),
      code: "-",
      tag: "-",
      codeId: "-",
      designId: taggingController.selectedDesign.value?.id ?? "",
      selectedDesign: taggingController.selectedDesign.value,
      design: TextEditingController(
        text: taggingController.selectedDesign.value?.name ?? "",
      ),
      purityText: taggingController.selectedPurity.value ?? '',
      vendorId: taggingController.selectedVendorId.value ?? '',
      vendorCode: taggingController.selectedVendorCode.value ?? '',
      sizeId: taggingController.selectedSizeId.value ?? '',
      sizeName: taggingController.selectedSizeName.value ?? '',
      isCounterDefault: taggingController.isCounterDefault.value,
      counterId:
          taggingController.isCounterDefault.value
              ? taggingController.defaultCounter.value?.id
              : taggingController.selectedCounter.value?.id,
      counterName:
          taggingController.isCounterDefault.value
              ? taggingController.defaultCounter.value?.counterName
              : taggingController.selectedCounter.value?.counterName,
      purity: TextEditingController(
        text: taggingController.selectedPurity.value ?? '',
      ),
      pcs: TextEditingController(text: "1"),
      gwt: TextEditingController(),
      nwt: TextEditingController(),
      va: TextEditingController(
        text:
            taggingController
                .selectedDesign
                .value
                ?.lineItems
                ?.firstOrNull
                ?.wastage ??
            "",
      ),
      mc: TextEditingController(
        text:
            taggingController
                .selectedDesign
                .value
                ?.lineItems
                ?.firstOrNull
                ?.makingCharges ??
            "",
      ),
      stone: TextEditingController(),
      rate: TextEditingController(),
      huid: TextEditingController(),
    );

    if (controllers.isEmpty) {
      controllers.add(newRow);
    }

    updateTotals();
  }

  Future<void> fetchTagAndCode(int rowIndex) async {
    final row = controllers[rowIndex];
    try {
      final designId = row.designId;
      final gwt = double.tryParse(row.gwt.text) ?? 0.0;
      final nwt = double.tryParse(row.nwt.text) ?? 0.0;

      log(
        "Fetching tag and code: Design ID = $designId, GWT = $gwt, NWT = $nwt",
      );

      if (designId.isEmpty) {
        log("Design ID is empty. Skipping API call.");
        resetCodeValues(row);
        return;
      }
      if (!isWeightInValidRange(row)) {
        validateWeight(rowIndex);
        // resetCodeValues(row);
        log("Weight out of range, skipping tag/code fetch.");
        return;
      }

      final response = await _inventoryRepository.getTagAndCode(
        designId,
        gwt,
        nwt,
      );

      row.code.value = response.itemCode ?? '';
      row.codeType.value = response.codeType ?? '';
      row.tag.value = response.tag?.toString() ?? '';
      row.codeId = response.itemId ?? "";

      // Set VA and MC from matching line item in design that matches both purity and weight range
      if (row.selectedDesign?.lineItems != null) {
        final matchingLineItem = row.selectedDesign!.lineItems!
            .firstWhereOrNull((item) {
              if (item.purity != row.purity.text) return false;

              final minWeight = double.tryParse(item.minWeight ?? '') ?? 0;
              final maxWeight =
                  double.tryParse(item.maxWeight ?? '') ?? double.infinity;
              final nwtValue = double.tryParse(row.nwt.text) ?? 0;

              return nwtValue >= minWeight && nwtValue <= maxWeight;
            });

        if (matchingLineItem != null) {
          row.va.text = matchingLineItem.wastage ?? '';
          row.mc.text = matchingLineItem.makingCharges ?? '';
        }
      }

      log(
        "Received response: Code = ${row.code.value}, Tag = ${row.tag.value}, CodeId = ${row.codeId} ",
      );

      update();
    } catch (e) {
      log("Error in fetchTagAndCode: $e");
      resetCodeValues(row);
      showErrorToast(message: 'Failed to fetch tag and code: $e');
    }
  }

  void resetCodeValues(TaggingItemDetailsTableData row) {
    row.code.value = '-';
    row.codeType.value = '';
    row.tag.value = '-';
    row.codeId = "";
    row.va.clear();
    row.mc.clear();
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
      currentRowIndex.value = currentRowIndex.value - 1;
      updateTotals();
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
  }

  void updateTotals() {
    double totalPcs = 0;
    double totalGWt = 0;
    double totalNWt = 0;
    double totalMC = 0;
    double totalStone = 0;

    for (var row in controllers) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gwt.text) ?? 0;
      totalNWt += double.tryParse(row.nwt.text) ?? 0;
      totalMC += double.tryParse(row.mc.text) ?? 0;
      totalStone += double.tryParse(row.stone.text) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      (totalPcs - 1).toStringAsFixed(2),
      totalGWt.toStringAsFixed(3),
      totalNWt.toStringAsFixed(3),
      totalMC.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      "",
    ];
    update();
  }

  Future<void> validateAndAddRow() async {
    if (formKey.currentState!.validate()) {
      final taggingController = Get.find<TaggingController>();

      if (taggingController.isLotBasedTaggingOnly.value &&
          taggingController.selectedLotNumber.value == null) {
        showErrorToast(message: 'Please select a lot to continue');
        taggingController.openLotDialogInitial();
        return;
      }
      if (!taggingController.validateAgainstSelectedLot()) {
        return; // Don't proceed if validation fails
      }
      if (controllers.isNotEmpty) {
        final currentRow = controllers.last;

        if (taggingController.availableSizes.isNotEmpty &&
            currentRow.sizeId.isEmpty) {
          showErrorToast(message: 'Please select a size');
          return;
        }
        if (taggingLineItemResponse.value.status == Status.LOADING) {
          showErrorToast(message: "Printing earlier data...");
          return;
        }
        try {
          // 1. Fetch tag and code
          await fetchTagAndCode(controllers.length - 1);

          // 2. Create and submit tagging line item
          final response = await createTaggingLineItem(controllers.last);

          if (response != null) {
            // 3. Generate barcodes
            await generateBarcodesForLineItems(response);

            // 4. Add new row
            log("Callin here");
            addRow();

            updateTotals();
          }
        } catch (e) {
          log('Error in validateAndAddRow: $e');
          showErrorToast(message: 'Failed to process line item: $e');
        }
      } else {
        addRow();
        updateTotals();
      }
      if (controllers.length > currentRowIndex.value + 1) {
        currentRowIndex.value++;
        currentColIndex.value = 2;
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
      }
    }
  }

  bool validateRow() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }
  // double calculateAmount(int index) {
  //   double pcs = double.tryParse(controllers[index].pcs.text) ?? 0;
  //   double nWt = double.tryParse(controllers[index].nwt.text) ?? 0;
  //   double rate = double.tryParse(controllers[index].rate.text) ?? 0;
  //   double wst = double.tryParse(controllers[index].wst.text) ?? 100;
  //   double mc = double.tryParse(controllers[index].mc.text) ?? 0;
  //   double stone = double.tryParse(controllers[index].stone.text) ?? 0;
  //   log("the values are : $nWt $rate $wst $mc $stone");
  //   if (controllers[index].wst_unit == "%") {
  //     return (nWt * (wst / 100) * rate) + mc + stone;
  //   } else {
  //     return ((nWt + (wst)) * rate) + mc + stone;
  //   }
  // }

  double getCaratConvertedToGramsForTotal(StoneDetailsTableData row) {
    if (row.weightUnit == "CT") {
      return (double.tryParse(row.carat_weight.text) ?? 0) * 0.2;
    } else {
      return (double.tryParse(row.carat_weight.text) ?? 0);
    }
  }

  void showStoneDialog(int rowIndex) {
    List<StoneDetailsTableData> currentValue =
        controllers[rowIndex].stoneDetailsTableData;
    // log("The current values are : ${currentValue.first.toJsonValue()}");

    final currentRow = controllers[rowIndex];
    final designName = currentRow.design.text;
    final grossWeight = currentRow.gwt.text;
    final netWeight = currentRow.nwt.text;

    Get.dialog(
      TaggingStoneDetailsDialog(
        designName: designName,
        grossWeight: grossWeight,
        netWeight: netWeight,
        initialStoneValue: currentValue,
        onSave: (totalValue, stoneDetailsValue) {
          log("Total values $totalValue");
          double totalWeightInGms = 0;
          for (var element in stoneDetailsValue) {
            totalWeightInGms += getCaratConvertedToGramsForTotal(element);
          }
          double netWeight = controllers.elementAt(rowIndex).nwtValue;
          double grossWeight = controllers.elementAt(rowIndex).gwtValue;

          double expectedStoneWeight = grossWeight - netWeight;

          double roundedExpectedWeight = double.parse(
            expectedStoneWeight.toStringAsFixed(3),
          );
          double roundedTotalWeight = double.parse(
            totalWeightInGms.toStringAsFixed(3),
          );

          if (roundedExpectedWeight != roundedTotalWeight) {
            log(
              "The expected stone weight is : $roundedExpectedWeight"
              " and the total stone weight is : $roundedTotalWeight",
            );
            showErrorToast(
              message:
                  "Warning: Stone weight (${roundedTotalWeight.toStringAsFixed(3)}) differs from expected (${roundedExpectedWeight.toStringAsFixed(3)})",
            );
          }

          controllers[rowIndex].stone.text = totalValue.toStringAsFixed(2);
          controllers[rowIndex].stoneDetailsTableData = stoneDetailsValue;
          log("The Details will be : ${controllers[rowIndex].toJsonValue()}");
        },
      ),
    );

    update();
  }

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

  Future<void> moveNextFocus({required KeyEvent event}) async {
    final currentRow = controllers[currentRowIndex.value];
    final makingChargeType = currentRow.selectedDesign?.makingChargeType?.id;
    final isStoneRequired = currentRow.isStoneRequired;
    final isHuidRequired = Get.find<TaggingController>().isHuidRequired.value;

    // Helper function to handle stone and HUID navigation
    Future<void> handleStoneAndHuid() async {
      if (isStoneRequired) {
        currentColIndex.value = 7; // Stone column
        showStoneDialog(currentRowIndex.value);
      } else if (isHuidRequired) {
        currentColIndex.value = 9; // HUID column
      } else {
        if (currentRowIndex < controllers.length - 1) {
          currentRowIndex.value++;
          currentColIndex.value = 2;
        } else {
          await validateAndAddRow();
          currentColIndex.value = 2;
          return;
        }
      }
    }

    bool isGrossWeightCell = currentColIndex.value == 3;

    if (isGrossWeightCell) {
      currentRow.nwt.selection = TextSelection(
        baseOffset: 0,
        extentOffset: currentRow.nwt.text.length,
      );
    }
    // Handle different navigation patterns based on makingChargeType
    if (HardwareKeyboard.instance.isShiftPressed ||
        event.logicalKey == LogicalKeyboardKey.tab) {
      // Normal tab traversal
      if (currentColIndex <
          controllers[currentRowIndex.value].tableFocusNodes.length - 1) {
        currentColIndex.value++;
      } else if (currentRowIndex < controllers.length - 1) {
        currentRowIndex.value++;
        currentColIndex.value = 2;
      } else {
        await validateAndAddRow();
        return;
      }
    } else {
      // Enter key navigation
      switch (makingChargeType) {
        case "1": // Va MC Design
          // Navigate through GWT, NWT, VA, MC, Stone (if required), HUID (if required)
          switch (currentColIndex.value) {
            case 2: // From Pcs
              currentColIndex.value = 3;
            case 3: // From GWT to NWT
              // if (isStoneRequired) {
              currentColIndex.value = 4; // NWT
              // } else if (isHuidRequired) {
              //   currentColIndex.value = 9;
              // } else {
              //   await validateAndAddRow();
              // }
              break;
            case 4: // From NWT to VA
              // currentColIndex.value = 5; // VA
              handleStoneAndHuid(); // Stone
              break;
            case 5: // From VA to MC
              currentColIndex.value = 6; // MC
              currentRow.rate.text = "0"; // Set rate to 0
              break;
            case 6: // From MC
              handleStoneAndHuid();
              break;
            default:
              if (currentColIndex.value >= 7) {
                if (currentRowIndex < controllers.length - 1) {
                  currentRowIndex.value++;
                  currentColIndex.value = 2;
                } else {
                  await validateAndAddRow();
                  currentColIndex.value = 2;
                  return;
                }
              }
          }
          break;

        case "3" || "2": // Weight rate/gm and Weight pc rate
          // Set other fields to 0
          currentRow.va.text = "0";
          currentRow.mc.text = "0";
          // Navigate through GWT, Stone (if required), Rate, HUID (if required)
          switch (currentColIndex.value) {
            // case 3: // From Design to GWT
            //   currentColIndex.value = 3; // GWT
            //   break;
            case 2: // From Pcs
              currentColIndex.value = 3;
            case 3: // From GWT
              if (isStoneRequired) {
                currentColIndex.value = 4; // NWT
              } else {
                currentColIndex.value = 8; // Rate
              }
              break;
            case 4:
              if (isStoneRequired) {
                currentColIndex.value = 7; // Stone
                showStoneDialog(currentRowIndex.value);
              } else {
                currentColIndex.value = 8; // Rate
              }
              break;
            case 7: // From Stone to Rate
              currentColIndex.value = 8; // Rate
              break;
            case 8: // From Rate
              if (isHuidRequired) {
                currentColIndex.value = 9; // HUID
              } else {
                if (currentRowIndex < controllers.length - 1) {
                  currentRowIndex.value++;
                  currentColIndex.value = 2;
                } else {
                  await validateAndAddRow();
                  currentColIndex.value = 2;
                  return;
                }
              }
              break;
            default:
              if (currentColIndex.value >= 9) {
                if (currentRowIndex < controllers.length - 1) {
                  currentRowIndex.value++;
                  currentColIndex.value = 2;
                } else {
                  await validateAndAddRow();
                  currentColIndex.value = 2;
                  return;
                }
              }
          }

          break;

        case "4": // Pc Rate
          // Set other fields to 0
          currentRow.va.text = "0";
          currentRow.mc.text = "0";
          currentRow.gwt.text = "0";
          currentRow.nwt.text = "0";
          // Navigate directly to Stone (if required), Rate, HUID (if required)
          switch (currentColIndex.value) {
            case 2: // From Pcs
              currentColIndex.value = 3;
            case 3: // From Design
              if (isStoneRequired) {
                currentColIndex.value = 7; // Stone
                showStoneDialog(currentRowIndex.value);
              } else {
                currentColIndex.value = 8; // Rate
              }
              break;
            case 7: // From Stone to Rate
              currentColIndex.value = 8; // Rate
              break;
            case 8: // From Rate
              if (isHuidRequired) {
                currentColIndex.value = 9; // HUID
              } else {
                if (currentRowIndex < controllers.length - 1) {
                  currentRowIndex.value++;
                  currentColIndex.value = 2;
                } else {
                  await validateAndAddRow();
                  currentColIndex.value = 2;
                  return;
                }
              }
              break;
            default:
              if (currentColIndex.value >= 9) {
                if (currentRowIndex < controllers.length - 1) {
                  currentRowIndex.value++;
                  currentColIndex.value = 2;
                } else {
                  await validateAndAddRow();
                  currentColIndex.value = 2;
                  return;
                }
              }
          }

          break;

        default:
          // Default navigation behavior
          if (currentColIndex <
              controllers[currentRowIndex.value].tableFocusNodes.length - 1) {
            currentColIndex.value++;
          } else if (currentRowIndex < controllers.length - 1) {
            currentRowIndex.value++;
            currentColIndex.value = 2;
          } else {
            validateAndAddRow();
            currentColIndex.value = 2;
            return;
          }
      }
    }

    // Request focus for the new position
    controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
        .requestFocus();

    log("Moving focus to row: $currentRowIndex, column: $currentColIndex");
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
        // print("inside else");
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

  Future<bool> deleteTaggingLineItems({required String id}) async {
    try {
      final value = await _inventoryRepository.deleteTaggingLineItems(
        ids: [id],
      );

      showSuccessToast(message: "Item deleted successfully!");
      return value;
    } catch (e) {
      showErrorToast(message: "Failed to delete item");

      return false;
    }
  }

  Future<bool> deleteTaggingRecords({required List<String> recordIds}) async {
    try {
      final value = await _inventoryRepository.deleteTaggingRecords(
        recordIds: recordIds,
      );

      showSuccessToast(message: "Record deleted successfully!");
      return value;
      // Optionally refresh your list here
      // await fetchTaggingRecords();
    } catch (e) {
      showErrorToast(message: "Failed to delete record");
      return false;
    }
  }

  Future<void> discardController() async {
    final TaggingController taggingController = Get.find<TaggingController>();
    bool value = false;
    if (currentLineItemId != null) {
      value = await deleteTaggingRecords(recordIds: [currentLineItemId!]);
    } else {
      taggingController.resetFields();
    }
    if (value) {
      taggingController.resetFields();
    }
  }

  void removeCurrentRow(int index) async {
    if (controllers.length > 1) {
      // Show confirmation dialog
      bool? shouldDelete = await Get.dialog<bool>(
        CancelPaymentDialog(
          subtitle: 'Are you sure you want to delete this row?',
          onYesPressed: () async {
            // Return true to indicate deletion should proceed
            String? id = controllers.elementAt(index).lineItemId;

            if (id != null) {
              await deleteTaggingLineItems(id: id);
            }
            return Future.value();
          },
        ),
      );

      // Only proceed with deletion if user confirmed
      if (shouldDelete == true) {
        controllers.removeAt(index);
        if (index == 0) {
          currentRowIndex.value = 0;
        } else {
          currentRowIndex.value = currentRowIndex.value - 1;
        }
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
        updateTotals();
        controllers.refresh();
      }
    } else {
      Get.snackbar(
        'Cannot Remove',
        'Cannot remove the last row.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearControllers() {
    controllers.clear();
    currentColIndex.value = 2;
    currentRowIndex.value = 0;
    currentLineItemId = null;
    totalHeadersValue.clear();
    addRow();
    updateTotals();
  }

  Future<void> generateBarcodesForLineItems(
    PostTaggingLineItemResponse item,
  ) async {
    final taggingController = Get.find<TaggingController>();

    log("Called Barcode printer ${item.toJson()}");
    BarcodeModel barcodeData = BarcodeModel(
      weight: item.lineItems?.lastOrNull?.netWeight,
      itemCode:
          '${item.lineItems?.lastOrNull?.code} ${item.lineItems?.lastOrNull?.tagNumber}',
      itemName: item.lineItems?.lastOrNull?.design?.name,
      purity: item.lineItems?.lastOrNull?.purity,
      barCode: item.lineItems?.lastOrNull?.tagBarcode ?? '',
      weightGroup: item.lineItems?.lastOrNull?.code,
      showNumber: true,
      fontFamily: 'Roboto',
      count: int.tryParse(taggingController.printTagController.value.text) ?? 0,
    );
    try {
      log("Printing barcode ${taggingController.isprintTag.value}");
      if (taggingController.isprintTag.value) {
        log("Printing barcode inside ${taggingController.isprintTag.value}");
        pdf = await _inventoryRepository.getBarCodePrint(detail: barcodeData);
        log("Printing barcode done ${taggingController.isprintTag.value}");
        // await Printing.layoutPdf(
        //   // outputType: OutputType.photo,
        //   usePrinterSettings: false,
        //   forceCustomPrintPaper: true,
        //   onLayout: (PdfPageFormat format) async => pdf!,
        //   format: const PdfPageFormat(
        //     70 * PdfPageFormat.mm,
        //     10 * PdfPageFormat.mm,
        //   ),
        // );

        final talker = Get.find<TalkerController>().talker;
        final printer = GodexG500Printer(
          logger: talker,
          selectedPrinter: taggingController.printerSettings.printerName,
        );
        final itemValue = item.lineItems?.lastOrNull;
        final labelConfig = LabelConfig(
          weight: itemValue?.netWeight ?? "",
          tagNumber: '${itemValue?.code}-${itemValue?.tagNumber}',
          grossWeight: "GWT : ${itemValue?.grossWeight ?? ""}",
          purity: itemValue?.purity ?? "",
          size: itemValue?.sizeGroup?.size ?? "",
          qrCode1: barcodeData.barCode,
          qrCode2: barcodeData.barCode,
          vendorId: itemValue?.vendorCode ?? "",
        );

        try {
          await printer.printLabel(labelConfig);
        } catch (e) {
          talker.error(
            'Error printing label with printer ${taggingController.printerSettings.printerName}: $e',
          );
          rethrow;
        }

        log("Called Barcode printer after  ${item.toJson()}");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  String? currentLineItemId;

  // Add state for API response handling
  final Rx<ApiResponse<PostTaggingLineItemResponse>> taggingLineItemResponse =
      Rx<ApiResponse<PostTaggingLineItemResponse>>(
        ApiResponse.initial("Initial"),
      );
  Future<PostTaggingLineItemResponse?> createTaggingLineItem(
    TaggingItemDetailsTableData currentRow,
  ) async {
    try {
      final TaggingItemDetailsController itemDetailsController = Get.find();
      final TaggingController taggingController = Get.find();
      List<String> errors = [];
      if (taggingController.isLotBasedTaggingOnly.value &&
          taggingController.selectedLotNumber.value == null) {
        errors.add('Lot selection is required for tagging');
      }
      // Add lot validation
      if (taggingController.selectedLotNumber.value != null) {
        // Check vendor compatibility
        if (taggingController.selectedLotNumber.value?.vendorId != null &&
            currentRow.vendorId !=
                taggingController.selectedLotNumber.value?.vendorId) {
          errors.add('Vendor does not match the lot\'s vendor');
        }

        // Check purity compatibility
        if (taggingController.selectedLotNumber.value?.purityTypes != null &&
            taggingController
                .selectedLotNumber
                .value!
                .purityTypes!
                .isNotEmpty &&
            !taggingController.selectedLotNumber.value!.purityTypes!.contains(
              currentRow.purity.text,
            )) {
          errors.add('Purity is not available in the selected lot');
        }
      }
      if (taggingController.selectedEmployee.value == null) {
        errors.add("Select Tagged By");
      }

      if (itemDetailsController.controllers.isEmpty) {
        errors.add('No tagging records to submit');
      }

      final controller = currentRow;
      // final rowNum = i + 1;

      // if (controller.vendorId.isEmpty) {
      //   errors.add('Vendor is required');
      // }
      // if (controller.sizeId.isEmpty) {
      //   errors.add('size is required');
      // }
      if (controller.designId.isEmpty) {
        errors.add('Design is required');
      }

      if (taggingController.availableSizes.isNotEmpty &&
          controller.sizeId.isEmpty) {
        errors.add('Please select a size');
      }
      if (controller.purity.text.isEmpty) {
        errors.add('Purity is required');
      }
      if (controller.pcs.text.isEmpty ||
          int.tryParse(controller.pcs.text) == 0) {
        errors.add('Valid pieces count is required');
      }
      if (controller.gwt.text.isEmpty ||
          (!controller.isPcRate && double.tryParse(controller.gwt.text) == 0)) {
        errors.add('Valid gross weight is required');
      }
      if (controller.nwt.text.isEmpty ||
          (!controller.isPcRate && double.tryParse(controller.nwt.text) == 0)) {
        errors.add('Valid  ${controller.isPcRate}net weight is required');
      }

      // Weight validation using existing function
      String? makingChargeTypeId =
          currentRow.selectedDesign?.makingChargeType?.id;
      // if (["1", "2", "3"].contains(makingChargeTypeId) &&
      //     !isWeightInValidRange(currentRow)) {
      //   // Get all line items for the selected purity
      //   final lineItems = currentRow.selectedDesign?.lineItems
      //       ?.where((item) => item.purity == currentRow.purity.text)
      //       .toList();
      //   if (lineItems == null || lineItems.isEmpty) {
      //     errors.add('Weight doesn\'t exist for the selected purity');
      //   } else {
      //     // List<String> weightRanges = lineItems.map((item) {
      //     //   return '${item.minWeight}-${item.maxWeight}';
      //     // }).toList();

      //     // errors.add(
      //     //     'Weight must be within one of these ranges: ${weightRanges.join(", ")} for selected purity');
      //     errors.add("Weight doesn't exits in the weight grp");
      //     errors.add("Adjust weight in design first");
      //   }
      // }

      if (["1", "2", "3"].contains(makingChargeTypeId) &&
          !isWeightInValidRange(currentRow)) {
        showErrorToast(
          message:
              "Warning: Weight is outside the defined range for this design",
        );
      }
      if (currentRow.shouldGwtEqualNwt() &&
          currentRow.gwtValue != currentRow.nwtValue) {
        errors.add(
          'Net weight must equal gross weight when there are no stones',
        );
      }
      // Add HUID validation
      if (taggingController.isHuidRequired.value) {
        if (currentRow.huid.text.isEmpty) {
          errors.add('HUID is required');
        } else if (!RegExp(
          r'^[a-zA-Z0-9]{6}$',
        ).hasMatch(currentRow.huid.text)) {
          errors.add('HUID must be 6 alphanumeric characters');
        }
      }

      // Add Rate validation
      if (currentRow.isRateRequired &&
          (currentRow.rate.text.isEmpty ||
              double.tryParse(currentRow.rate.text) == 0)) {
        errors.add('Valid rate is required');
      }

      // Add Stone validation
      // if (currentRow.isStoneRequired) {
      //   if (currentRow.stone.text.isEmpty) {
      //     errors.add('Stone details are required');
      //   }
      //   if (currentRow.stoneDetailsTableData.isEmpty) {
      //     errors.add('Stone details are required');
      //   }
      // }

      // Validate stone details if present
      if (controller.stoneDetailsTableData.isNotEmpty) {
        for (int j = 0; j < controller.stoneDetailsTableData.length; j++) {
          final stone = controller.stoneDetailsTableData[j];
          final stoneNum = j + 1;

          if (stone.name.text.isEmpty) {
            errors.add('Stone $stoneNum: Stone name is required');
          }
          if (stone.pcs.text.isEmpty || int.tryParse(stone.pcs.text) == 0) {
            errors.add('Stone $stoneNum: Valid stone pieces count is required');
          }

          if (!stone.isOtherStone &&
              (stone.carat_weight.text.isEmpty ||
                  (double.tryParse(stone.carat_weight.text) ?? 0) == 0)) {
            errors.add('Stone $stoneNum: Valid weight is required');
          }

          if (stone.rate.text.isEmpty) {
            errors.add('Stone $stoneNum: Valid rate is required');
          }
        }
      }

      if (itemDetailsController.formKey.currentState!.validate() == false) {
        errors.add("Please check items");
      }
      if (errors.isNotEmpty) {
        // Show errors in a dialog
        for (var err in errors) {
          showErrorToast(message: err);
        }
        return null;
      }

      // Create the line stones
      final lineStones =
          currentRow.stoneDetailsTableData.map((stone) {
            final caratWeightRaw = stone.carat_weight.text.trim();
            final caratWeightOrNull =
                caratWeightRaw.isEmpty ? null : caratWeightRaw;

            return LineStone(
              referenceStoneId: stone.id,
              name: stone.name.text,
              pieces: int.tryParse(stone.pcs.text) ?? 0,
              carat: stone.weightUnit == "CT" ? caratWeightOrNull : null,
              weight: stone.weightUnit != "CT" ? caratWeightOrNull : null,
              rate: stone.rate.text,
              total: stone.total.text,
            );
          }).toList();

      // Create the request
      final request = PostTaggingLineItemRequest(
        id: currentLineItemId,
        taggedById: taggingController.selectedEmployee.value?.id,
        lotEntryId: taggingController.selectedLotNumber.value?.id,
        lineItems: TaggingLineItem(
          vendorId:
              currentRow.vendorId.trim().isEmpty ? null : currentRow.vendorId,
          code: currentRow.code.value,
          codeId: currentRow.codeId,
          codeType: currentRow.codeType.value,
          tagBarcode: currentRow.tag.value,
          pieces: int.tryParse(currentRow.pcs.text) ?? 0,
          grossWeight: currentRow.gwt.text,
          netWeight: currentRow.nwt.text,
          va: currentRow.va.text.isEmpty ? "0" : currentRow.va.text,
          mc: currentRow.mc.text.isEmpty ? "0" : currentRow.mc.text,
          rate: currentRow.rate.text,
          huid: currentRow.huid.text,
          purity: currentRow.purity.text,
          design: Design(id: currentRow.designId),
          sizeGroup:
              currentRow.sizeId.isEmpty ? null : Design(id: currentRow.sizeId),
          counter: Design(id: currentRow.counterId),
          metalColorId: taggingController.selectedMetalColor.value?.id,
          gender: taggingController.selectedGender.value?.value,
          qcEmployeeIds:
              taggingController.selectedQcyEmployees
                  .map((e) => e.id ?? "")
                  .where((id) => id.isNotEmpty)
                  .toList(),
          lineStones: lineStones,
          images: [],
          vendorCode:
              currentRow.vendorCode == NOVENDOR ? null : currentRow.vendorCode,
        ),
      );

      log('Sending tagging line item request: ${request.toRawJson()}');
      taggingLineItemResponse.value = ApiResponse.loading(
        "Creating line item...",
      );
      // Make the API call

      final response = await _inventoryRepository.postTaggingLineItem(request);
      taggingLineItemResponse.value = ApiResponse.completed(response);

      // Get lineitem id
      currentRow.lineItemId = response.lineItems?.lastOrNull?.id;
      // Extract and store the line tagging ID from response
      if (response.id != null) {
        currentLineItemId = response.id;
        log('Received line item ID: $currentLineItemId');
        return response;
      } else {
        log('Failed to get line item ID from response');
        taggingLineItemResponse.value = ApiResponse.error(
          "Failed to get line item ID",
        );
        return null;
      }
    } catch (e, s) {
      log('Error $s creating tagging line item: $e $s');
      taggingLineItemResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to create tagging line item: $e');
      return null;
    }
  }

  bool isWeightInValidRange(TaggingItemDetailsTableData row) {
    if (row.selectedDesign == null) return true;

    // Only validate for making charge types 1, 2, or 3
    String? makingChargeTypeId = row.selectedDesign?.makingChargeType?.id;
    if (!["1", "2", "3"].contains(makingChargeTypeId)) return true;

    // Get all line items for the selected purity
    final lineItems =
        row.selectedDesign?.lineItems
            ?.where((item) => item.purity == row.purity.text)
            .toList();

    if (lineItems == null || lineItems.isEmpty) return false;

    double netWeight = double.tryParse(row.nwt.text) ?? 0;

    // Check if the weight falls within any of the valid ranges
    for (var lineItem in lineItems) {
      double minWeight = double.tryParse(lineItem.minWeight ?? '') ?? 0;
      double maxWeight =
          double.tryParse(lineItem.maxWeight ?? '') ?? double.infinity;

      if (netWeight >= minWeight && netWeight <= maxWeight) {
        return true;
      }
    }

    return false; // Weight doesn't fall within any valid range
  }

  // void validateWeight(int rowIndex) {
  //   final row = controllers[rowIndex];
  //   if (!isWeightInValidRange(row)) {
  //     // Get all line items for the selected purity
  //     final lineItems = row.selectedDesign?.lineItems
  //         ?.where((item) => item.purity == row.purity.text)
  //         .toList();

  //     if (lineItems == null || lineItems.isEmpty) {
  //       showErrorToast(
  //           message: 'Weight doesn\'t exist for the selected purity');
  //       return;
  //     }

  //     // Format weight ranges for error message
  //     List<String> weightRanges = lineItems.map((item) {
  //       return '${item.minWeight}-${item.maxWeight}';
  //     }).toList();

  //     showErrorToast(
  //         message:
  //             'Weight must be within one of these ranges: ${weightRanges.join(", ")} for selected purity');
  //     showErrorToast(message: 'Adjust weight in design first');
  //   }
  // }

  bool validateWeight(int rowIndex) {
    final row = controllers[rowIndex];
    if (!isWeightInValidRange(row)) {
      // Get all line items for the selected purity
      final lineItems =
          row.selectedDesign?.lineItems
              ?.where((item) => item.purity == row.purity.text)
              .toList();

      if (lineItems == null || lineItems.isEmpty) {
        showErrorToast(
          message: 'Weight doesn\'t exist for the selected purity',
        );
        return false;
      }

      // Format weight ranges for error message
      List<String> weightRanges =
          lineItems.map((item) {
            return '${item.minWeight}-${item.maxWeight}';
          }).toList();

      showErrorToast(
        message:
            'Weight must be within one of these ranges: ${weightRanges.join(", ")} for selected purity',
      );
      showErrorToast(message: 'Adjust weight in design first');
      return false;
    }
    return true;
  }

  void resetRow(int index) {
    // Store the original serial number
    String originalSn = controllers[index].sn;

    // // Reset Rx values
    // controllers[index].code.value = "-";
    // controllers[index].codeType.value = "";
    // controllers[index].tag.value = "-";

    // Reset TextEditingControllers
    // controllers[index].design.clear();
    // controllers[index].purity.clear();
    // controllers[index].pcs.clear();
    controllers[index].gwt.clear();
    controllers[index].nwt.clear();
    // controllers[index].va.clear();
    // controllers[index].mc.clear();
    controllers[index].stone.clear();
    controllers[index].rate.clear();
    controllers[index].huid.clear();

    // // Reset string properties
    // controllers[index].designId = '';
    // controllers[index].vendorId = '';
    // controllers[index].vendorName = '';
    // controllers[index].sizeId = '';
    // controllers[index].sizeName = '';
    // controllers[index].purityText = '';
    // controllers[index].codeId = '';
    // controllers[index].wst_unit = "%";

    // // Reset nullable properties
    // controllers[index].counterId = null;
    // controllers[index].counterName = null;
    // controllers[index].selectedDesign = null;
    // controllers[index].lineItemId = null;

    // // Reset boolean property
    // controllers[index].isCounterDefault = true;

    // Clear stone details
    controllers[index].stoneDetailsTableData.clear();

    // Restore the original serial number
    controllers[index].sn = originalSn;

    // Update UI
    update();
  }

  Future<void> readWeightFromScale(int rowIndex) async {
    final taggingController = Get.find<TaggingController>();

    // Check if weight scale is supported on this platform
    if (!WeightScaleManager.isSupported) {
      showErrorToast(
        message: "Weight scale not supported on web. Use desktop/mobile app.",
      );
      return;
    }

    if (taggingController.isAutoWeightInput.value == false) {
      showErrorToast(message: "Auto Weight Input Disabled");
      return;
    }

    try {
      // Show loading dialog
      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Reading weight from scale on port ${taggingController.printerSettings.scalePort}...',
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Get weight from scale
      final String? weight = await WeightScaleManager().getWeightFromScale(
        scalePort: taggingController.printerSettings.scalePort,
      );

      // Close dialog
      if (Get.isDialogOpen!) {
        Get.back();
      }

      if (weight != null) {
        // Update gross weight field
        controllers[rowIndex].gwt.text = weight;

        // Always update net weight with the same value
        controllers[rowIndex].nwt.text = weight;

        // Select all text in the net weight field
        controllers[rowIndex].nwt.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controllers[rowIndex].nwt.text.length,
        );

        // Request focus on net weight field (index 4 in tableFocusNodes)
        controllers[rowIndex].tableFocusNodes[4].requestFocus();

        // Update current row and column index
        currentRowIndex.value = rowIndex;
        currentColIndex.value = 4; // Net weight column

        // Update calculations
        updateTotals();

        // Fetch tag and code if design is selected
        if (controllers[rowIndex].designId.isNotEmpty) {
          checkAndFetchTagAndCode(rowIndex);
        }

        showSuccessToast(message: 'Weight captured: $weight g');
      } else {
        showErrorToast(
          message:
              'Failed to get stable weight reading from scale on port ${taggingController.printerSettings.scalePort}',
        );
      }
    } catch (e) {
      log('Error in readWeightFromScale: $e');
      if (Get.isDialogOpen!) {
        Get.back();
      }
      showErrorToast(message: 'Scale error: $e');
    }
  }
}
