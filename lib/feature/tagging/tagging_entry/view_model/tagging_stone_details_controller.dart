// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class TaggingStoneDetailsController extends GetxController {
  final RxList<StoneDetailsTableData> controllers =
      <StoneDetailsTableData>[].obs;
  final RxList<String> totalHeadersValue = <String>[].obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  final stoneHeaders = [
    'Sn',
    'Stone Code',
    'Stone Name',
    'Pcs',
    'Carat/gm',
    'Rate (₹)',
    'Total (₹)',
    '',
  ];
  final stoneColumnWidths = [0.1, 0.4, 0.6, 0.2, 0.4, 0.4, 0.4, 0.2];
  final totalColumnWidths = [1.1, 0.2, 0.4, 0.4, 0.4, 0.2];

  final List<String> weightUnits = ['CT', 'GM'];
  @override
  void onInit() {
    super.onInit();

    if (controllers.isEmpty) {
      addRow();
    }
  }

  void initializeControllers(List<StoneDetailsTableData> initialStoneValue) {
    // controllers.clear();

    if (initialStoneValue.isNotEmpty) {
      log("The initial values are : $initialStoneValue");
      controllers.assignAll(initialStoneValue);
    } else {
      if (controllers.isEmpty) {
        addRow();
      }
    }
    updateTotals();
  }

  void setWeightOrCarat({required int index}) {
    if (controllers[index].weightUnit == "CT") {
      controllers[index].weightUnit = "GM";
    } else {
      controllers[index].weightUnit = "CT";
    }
    update();
  }

  void setStonename({required int index, required String newValue}) {
    final codeList = getStoneRatesResponse.value.data?.values ?? [];

    GetStoneRatesValue value = codeList.firstWhere(
      (item) => item.id == newValue,
    );
    controllers[index].name.text = value.name ?? "";
    controllers[index].stone_code.text = value.code ?? "";

    controllers[index].rate.text = value.rate ?? "";
    controllers[index].weightUnitFromBackend = value.rateType ?? "";
    controllers[index].id = value.id;
    controllers[index].isOtherStone = value.isOther ?? false;

    updateRowAmount(index);

    log(
      "The stone values are ${value.name} : ${value.rate} : ${value.rateType} : ${value.id}",
    );
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
    }
  }

  void addRow() {
    controllers.add(
      StoneDetailsTableData(
        carat_weight: TextEditingController(),
        name: TextEditingController(),
        stone_code: TextEditingController(),
        total: TextEditingController(),
        pcs: TextEditingController(text: "1"),
        rate: TextEditingController(),
        previousUnitBeforePC: null,
        id: null,
      ),
    );
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    });
    // FocusScope.of(Get.context!).requestFocus(controllers.last.nameFocus);
  }

  void removeLastRow() {
    if (controllers.isNotEmpty) {
      controllers.removeLast();
      updateTotals();
      currentRowIndex.value = currentRowIndex.value - 1;
    } else {
      // Get.snackbar(
      //   'Cannot Remove',
      //   'Cannot remove ',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      showErrorToast(message: "Cannot remove the last row.");
      currentRowIndex.value = 0;
    }
    controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
        .requestFocus();
  }

  void removeCurrentRow(int index) {
    if (controllers.isNotEmpty) {
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
      // Get.snackbar(
      //   'Cannot Remove',
      //   'Cannot remove',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  void updateRowAmount(int index) {
    double amount = calculateAmount(index);
    log("Updating amoung : $amount");
    controllers[index].total.text = amount.toStringAsFixed(2);

    updateTotals();
  }

  double calculateAmount(int index) {
    final row = controllers[index];
    double pcs = double.tryParse(row.pcs.text) ?? 0;
    double rate = double.tryParse(row.rate.text) ?? 0;
    double caratWeight = double.tryParse(row.carat_weight.text) ?? 0;

    // Special case: if rate unit is PC, multiply rate by number of pieces
    if (row.weightUnitFromBackend == "PC") {
      return pcs * rate;
    }

    // If carat weight is not provided, calculate based on pieces
    if (row.carat_weight.text.isEmpty || caratWeight <= 0) {
      return pcs * rate;
    }

    // Calculate based on weight
    double weightToUse;

    if (row.weightUnitFromBackend == "CT") {
      // Backend weight is in carats
      if (row.weightUnit == "CT") {
        weightToUse = caratWeight; // Already in carats
      } else if (row.weightUnit == "GM") {
        weightToUse = getGramsConvertedToCarat(row); // Convert grams to carats
      } else {
        weightToUse = pcs;
      }
    } else if (row.weightUnitFromBackend == "GM") {
      // Backend weight is in grams
      if (row.weightUnit == "CT") {
        weightToUse = getCaratConvertedToGrams(row); // Convert carats to grams
      } else if (row.weightUnit == "GM") {
        weightToUse = caratWeight; // Already in grams
      } else {
        weightToUse = pcs;
      }
    } else {
      weightToUse = pcs;
    }

    return weightToUse * rate;
  }

  double getCaratConvertedToGramsForTotal(StoneDetailsTableData row) {
    if (row.weightUnit == "CT") {
      return (double.tryParse(row.carat_weight.text) ?? 0) * 0.2;
    } else {
      return (double.tryParse(row.carat_weight.text) ?? 0);
    }
  }

  double getGramsConvertedToCarat(StoneDetailsTableData row) {
    return (double.tryParse(row.carat_weight.text) ?? 0) / 0.2;
  }

  double getCaratConvertedToGrams(StoneDetailsTableData row) {
    return (double.tryParse(row.carat_weight.text) ?? 0) * 0.2;
  }

  // void updateTotals() {
  //   double totalPcs = 0;
  //   double totalCarat = 0;
  //   // double totalRate = 0;
  //   double totalAmount = 0;

  //   for (var row in controllers) {
  //     totalPcs += double.tryParse(row.pcs.text) ?? 0;
  //     totalCarat += getCaratConvertedToGramsForTotal(row);
  //     // totalRate += double.tryParse(row.rate.text) ?? 0;
  //     totalAmount += double.tryParse(row.total.text) ?? 0;
  //   }

  //   totalHeadersValue.value = [
  //     "Total",
  //     totalPcs.toStringAsFixed(2),
  //     totalCarat.toStringAsFixed(3), "",
  //     // totalRate.toStringAsFixed(2),
  //     totalAmount.toStringAsFixed(2),
  //     ""
  //   ];
  // }

  void updateTotals() {
    double totalPcs = 0;
    double totalWeightInGrams = 0;
    double totalAmount = 0;

    for (var row in controllers) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalWeightInGrams += getCaratConvertedToGramsForTotal(row);
      totalAmount += double.tryParse(row.total.text) ?? 0;
    }

    // Convert grams back to carats for display
    double totalCarats = totalWeightInGrams / 0.2;

    // Format as "carats (grams)"
    String caratGramDisplay =
        "${totalCarats.toStringAsFixed(3)} (${totalWeightInGrams.toStringAsFixed(3)})";

    totalHeadersValue.value = [
      "Total",
      totalPcs.toStringAsFixed(0),
      caratGramDisplay, // Changed to show both carat and gram
      "",
      totalAmount.toStringAsFixed(2),
      "",
    ];
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
      "moving focus movePreviousFocus to $currentRowIndex : $currentColIndex  ${controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]}",
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
    log(
      "moving focus moveNextFocusto $currentRowIndex : $currentColIndex  ${controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]}",
    );
  }

  KeyEventResult moveFocus(
    KeyEventResult result,
    LogicalKeyboardKey keyboard, {
    required FocusNode addButtonFocusNode,
    required FocusNode nextButtonFocusNode,
  }) {
    if (keyboard == LogicalKeyboardKey.arrowUp) {
      if (currentRowIndex > 0) {
        currentRowIndex.value--;
        log("moving focus move focus to $currentRowIndex : $currentColIndex");
      } else {
        print("inside else");
        addButtonFocusNode.requestFocus();
        // node.previousFocus();
        log("moving focus move focus to $currentRowIndex : $currentColIndex");
        return KeyEventResult.handled;
      }
    } else if (keyboard == LogicalKeyboardKey.arrowDown) {
      if (currentRowIndex.value < controllers.length - 1) {
        currentRowIndex.value++;
      } else {
        nextButtonFocusNode.requestFocus();
        // node.nextFocus();
        return KeyEventResult.handled;
      }
    }
    controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
        .requestFocus();
    log("moving focus move focus to $currentRowIndex : $currentColIndex");
    return result;
  }

  final getStoneRatesResponse = Rx<ApiResponse<GetStoneRatesResponse>>(
    ApiResponse.initial("Initial"),
  );

  final InventoryRepository _inventoryRepository = InventoryRepository();

  Future<void> getStoneRatesDetails({String? searchQuery}) async {
    getStoneRatesResponse.value = ApiResponse.loading("Loading");
    if (controllers.last.stone_code.text.isEmpty) {
      controllers.last.stone_code.text = " ";
    }
    try {
      final response = await _inventoryRepository.getStoneRates(
        limit: 1000,
        query: searchQuery ?? "",
      );
      response.values?.insert(
        0,
        GetStoneRatesValue(name: ADD_NEW, code: ADD_NEW),
      );
      // bool othExists =
      //     response.values?.any((element) => element.code == OTH_CODE) ?? false;
      // if (!othExists) {
      //   response.values?.insert(
      //       1,
      //       GetStoneRatesValue(
      //           name: "Other",
      //           code: OTH_CODE,
      //           rateType: "CT",
      //           rate: "",
      //           id: ""));
      // }

      log("The data is ${response.values?.map((e) => e.toJson())}");
      getStoneRatesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getStoneRatesResponse.value = ApiResponse.error(e.toString());
    }
    if (controllers.last.stone_code.text == " ") {
      controllers.last.stone_code.text = "";
    }
  }

  void toggleRateUnit(int index) {
    // Cycle through CT -> GM -> PC -> CT
    if (controllers[index].weightUnitFromBackend == "CT") {
      controllers[index].weightUnitFromBackend = "GM";

      // Convert rate from CT to GM (multiply by 5 as 1 GM = 5 CT)
      double currentRate = double.tryParse(controllers[index].rate.text) ?? 0;
      controllers[index].rate.text = (currentRate * 5).toStringAsFixed(2);
    } else if (controllers[index].weightUnitFromBackend == "GM") {
      controllers[index].weightUnitFromBackend = "PC";

      // Convert rate from GM to PC - here you can define your conversion logic
      // For simplicity, we'll just keep the same rate when switching to PC
    } else {
      // PC to CT
      controllers[index].weightUnitFromBackend = "CT";

      // Convert rate from PC to CT
      // If we switched from GM to PC without changing the value,
      // we need to convert back from GM to CT when going to CT
      double currentRate = double.tryParse(controllers[index].rate.text) ?? 0;
      if (controllers[index].previousUnitBeforePC == "GM") {
        controllers[index].rate.text = (currentRate / 5).toStringAsFixed(2);
      }
    }

    // Store the previous unit before switching to PC for reference when switching back
    if (controllers[index].weightUnitFromBackend == "PC") {
      if (controllers[index].previousUnitBeforePC == null ||
          controllers[index].previousUnitBeforePC == "PC") {
        controllers[index].previousUnitBeforePC =
            "CT"; // Default if we don't know
      }
    } else {
      controllers[index].previousUnitBeforePC =
          controllers[index].weightUnitFromBackend;
    }

    update();
  }

  void resetRow(int index) {
    // Reset all TextEditingControllers
    controllers[index].name.clear();

    controllers[index].stone_code.clear();
    controllers[index].carat_weight.clear();
    controllers[index].pcs.text = "1";
    controllers[index].rate.clear();
    controllers[index].total.clear();

    // Reset to default values
    controllers[index].weightUnit = 'CT';
    controllers[index].weightUnitFromBackend = 'CT';

    controllers[index].previousUnitBeforePC = null;
    controllers[index].id = null;

    // Update UI
    update();
  }
}
