// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response_v2.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class MakingChargesTableData {
  final String? id;
  final TextEditingController purity;
  GetPurityValue? purityValue;
  final TextEditingController weightRangeMin;
  final TextEditingController weightRangeMax;
  final TextEditingController va;
  final TextEditingController mc;
  final TextEditingController minVa;
  final TextEditingController minMc;
  final TextEditingController ornamentType;
  String? ornamentId;
  String vaUnit;
  String mcUnit;
  List<FocusNode> tableFocusNodes;

  MakingChargesTableData({
    this.id,
    required this.purity,
    this.purityValue,
    required this.weightRangeMin,
    required this.weightRangeMax,
    required this.va,
    required this.mc,
    required this.minVa,
    required this.minMc,
    required this.ornamentType,
    this.mcUnit = "nwt",
    this.vaUnit = "%",
    this.ornamentId,
    required MakingChargesOption option,
  }) : tableFocusNodes = _createFocusNodes(option);

  static List<FocusNode> _createFocusNodes(MakingChargesOption option) {
    switch (option) {
      case MakingChargesOption.VaMc:
        return List.generate(8, (_) => FocusNode());
      case MakingChargesOption.WeightRate:
      case MakingChargesOption.WeightPcRate:
        return List.generate(
          4,
          (_) => FocusNode(),
        ); // For Purity, Ornament, Weight Range
      case MakingChargesOption.PcRate:
        return List.generate(2, (_) => FocusNode()); // For  Purity, Ornament
    }
  }

  void dispose() {
    for (var node in tableFocusNodes) {
      node.dispose();
    }
  }
}

class TableMakingChargesController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final Rx<MakingChargesOption> selectedOption = MakingChargesOption.VaMc.obs;
  final RxList<MakingChargesTableData> controllers =
      <MakingChargesTableData>[].obs;
  final RxList<String> totalHeadersValue = <String>[].obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  final headers = [
    "Sr",
    'Purity',
    'Ornament Type', // Moved here
    'Weight Range (gm)',
    'VA',
    'MC',
    'Min VA',
    'Min MC',
    '',
  ];

  final columnWidths = [
    0.1, // Sr
    0.4, // Purity
    0.4, // Ornament Type
    0.7, // Weight Range
    0.3, // VA
    0.3, // MC
    0.3, // Min VA
    0.3, // Min MC
    0.1, // Delete
  ];

  // @override
  // void onInit() {
  //   super.onInit();
  //   getPurityDetails();
  //   // addRow();
  // }

  void setSelectedOption(MakingChargesOption option) {
    log("Selected option is ${option.name}");
    // Dispose existing focus nodes before clearing controllers
    for (var controller in controllers) {
      for (var node in controller.tableFocusNodes) {
        node.dispose();
      }
    }
    selectedOption.value = option;
    controllers.clear();
    addRow();
  }

  @override
  void onClose() {
    // Clean up focus nodes
    for (var controller in controllers) {
      for (var node in controller.tableFocusNodes) {
        node.dispose();
      }
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
      MakingChargesTableData(
        purity: TextEditingController(),
        weightRangeMin: TextEditingController(),
        weightRangeMax: TextEditingController(),
        va: TextEditingController(),
        mc: TextEditingController(),
        minVa: TextEditingController(),
        minMc: TextEditingController(),
        ornamentType: TextEditingController(),
        option: selectedOption.value, // Pass the current option
      ),
    );
    updateTotals();
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
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
    // Implement total calculation logic here
    totalHeadersValue.value = ['Total', '', '', '', '', '', ''];
  }

  void setVaUnit({required int index}) {
    // Get the current unit's index in the list
    int currentIndex = vaUnits.indexOf(controllers[index].vaUnit);

    // Move to the next unit in the cycle
    int nextIndex = (currentIndex + 1) % vaUnits.length;

    // Set the new unit
    controllers[index].vaUnit = vaUnits[nextIndex];

    update();
  }

  void setMcUnit({required int index}) {
    // Get the current unit's index in the list
    int currentIndex = mcUnits.indexOf(controllers[index].mcUnit);

    // Move to the next unit in the cycle
    int nextIndex = (currentIndex + 1) % mcUnits.length;

    // Set the new unit
    controllers[index].mcUnit = mcUnits[nextIndex];

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
      if (controllers.length > currentRowIndex.value + 1) {
        currentRowIndex.value++;
        currentColIndex.value = 0;
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();
      }
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

  void clearControllers({bool shouldAddRow = true}) {
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.clear();
    selectedOption.value = MakingChargesOption.VaMc;
    if (shouldAddRow) {
      addRow();
      updateTotals();
    }
  }

  final getPurityResponse = Rx<ApiResponse<GetPurityResponseV2>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getPurityDetails() async {
    try {
      getPurityResponse.value = ApiResponse.loading("Loading Purity");

      // await Future.delayed(Durations.extralong4);
      final response = await _inventoryRepository.getSelectedPurityv2();
      getPurityResponse.value = ApiResponse.completed(response);
    } catch (e) {
      if (e is ApiException) {
        showErrorToast(message: e.toStringPrefix());
      }
      getPurityResponse.value = ApiResponse.error(e.toString());
    }
  }

  void populateWithFetchedData(GetDesignResponseModel data) {
    // Clear existing data
    clearControllers(shouldAddRow: false);

    // Set the making charge type
    if (data.makingChargeType != null) {
      selectedOption.value = MakingChargesOption.values.firstWhere(
        (option) => option.id == data.makingChargeType!.id,
        orElse: () => MakingChargesOption.VaMc,
      );
    }

    // Populate line items
    log("populating table : ${data.lineItems}");
    if (data.lineItems != null && data.lineItems!.isNotEmpty) {
      for (var lineItem in data.lineItems!) {
        GetPurityValue? matchingPurity;
        if (getPurityResponse.value.data != null && lineItem.purity != null) {
          final allPurities = getPurityResponse.value.data!.values ?? [];
          matchingPurity = allPurities.firstWhereOrNull(
            (purityValue) => purityValue.purityType == lineItem.purity,
          );
        }
        controllers.add(
          MakingChargesTableData(
            id: lineItem.id,
            purity: TextEditingController(text: lineItem.purity),
            purityValue: matchingPurity,
            weightRangeMin: TextEditingController(text: lineItem.minWeight),
            weightRangeMax: TextEditingController(text: lineItem.maxWeight),
            va: TextEditingController(text: lineItem.wastage),
            mc: TextEditingController(text: lineItem.makingCharges),
            minVa: TextEditingController(text: lineItem.minVa),
            minMc: TextEditingController(text: lineItem.minMc),
            vaUnit: lineItem.wastageType ?? "%",
            mcUnit:
                lineItem.makingChargesType ??
                "gwt", // Assuming default value, adjust if needed
            ornamentType: TextEditingController(text: lineItem.ornament?.name),
            option: selectedOption.value,
            ornamentId: lineItem.ornament?.id,
          ),
        );
      }
    }

    // If no line items were added (perhaps due to null data), ensure at least one row exists
    // if (controllers.isEmpty) {
    //   addRow( );
    // }

    updateTotals();
  }

  final ornamentsResponse = Rx<ApiResponse<GetAllOrnamentsResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> fetchOrnaments() async {
    try {
      ornamentsResponse.value = ApiResponse.loading("Fetching ornaments");
      final response = await _inventoryRepository.getAllOrnaments();

      ornamentsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      ornamentsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to fetch ornaments');
    }
  }

  setOrnament({
    required int index,
    required GetAllOrnamentsResponseValue value,
  }) {
    controllers[index].ornamentType.text = value.name ?? "";
    controllers[index].ornamentId = value.id ?? "";
  }

  void resetRow(int index) {
    // Reset all text controllers
    controllers[index].purity.clear();
    controllers[index].purityValue = null;
    controllers[index].weightRangeMin.clear();
    controllers[index].weightRangeMax.clear();
    controllers[index].va.clear();
    controllers[index].mc.clear();
    controllers[index].minVa.clear();
    controllers[index].minMc.clear();
    controllers[index].ornamentType.clear();

    // Reset other properties to default values
    controllers[index].ornamentId = null;
    controllers[index].vaUnit = vaUnits[0];
    controllers[index].mcUnit = mcUnits[0];

    // Update totals and UI
    updateTotals();
    update();
  }
}
