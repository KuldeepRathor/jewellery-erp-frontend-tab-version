import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/get_deisgn_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/widgets/stone_details_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/calculator/estimation_calculator.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';

class CreateOrderItemDetailsTableData {
  String sn;
  TextEditingController item_description;
  String? designId;
  TextEditingController size;
  TextEditingController rate;
  TextEditingController purity;
  TextEditingController nwt;
  TextEditingController gwt; // Add this
  TextEditingController va;
  TextEditingController mc;
  TextEditingController stone;
  TextEditingController gst;
  TextEditingController amount;
  TextEditingController hallMark; // Add this
  TextEditingController costDiscount; // Add this

  // Add these properties
  String? wastageType;
  String? makingChargesType;
  double? minVa;
  double? minMC;
  String salesAmount; // Add this
  String total; // Add this

  List<StoneDetailsTableData> stoneDetailsTableData = [];
  List<FocusNode> tableFocusNodes = List.generate(9, (index) => FocusNode());

  CreateOrderItemDetailsTableData({
    required this.sn,
    required this.item_description,
    this.designId,
    required this.size,
    required this.rate,
    required this.purity,
    required this.nwt,
    required this.gwt,
    required this.va,
    required this.mc,
    required this.stone,
    required this.gst,
    required this.amount,
    required this.hallMark,
    required this.costDiscount,
    this.wastageType = "%", // Default to percentage
    this.makingChargesType = "pcs", // Default to per piece
    this.minVa = 0,
    this.minMC = 0,
    this.salesAmount = "0",
    this.total = "0",
  });

  Map<String, dynamic> toJsonValue() {
    return {
      'sn': sn,
      'item_description': item_description.text,
      'rate': rate.text,
      'design_id': designId,
      'size': size.text,
      'purity': purity.text,
      'nwt': nwt.text,
      'gwt': gwt.text,
      'va': va.text,
      'mc': mc.text,
      'stone': stone.text,
      'gst': gst.text,
      'amount': amount.text,
      'hallMark': hallMark.text,
      'costDiscount': costDiscount.text,
      'stone_details':
          stoneDetailsTableData.map((stone) => stone.toJsonValue()).toList(),
    };
  }
}

class CreateOrderItemDetailsController extends GetxController {
  final headers = [
    'Sn',
    'Item Description',
    'Size',
    'Purity',
    'N.Wt. (gm)',
    'VA %',
    'MC',
    'Stone',
    'GST %',
    'Total Amount (₹)',
    '',
  ];

  final columnWidths = [
    0.1, // Sn
    0.7, // Item Description
    0.35, // Size
    0.35, // Purity
    0.35, // N.Wt. (gm)
    0.35, // VA %
    0.35, // MC
    0.35, // Stone
    0.35, // GST %
    0.4, // Total Amount (₹)
    0.1, // Actions
  ];

  final totalColumnWidths = [
    1.55, // "Total" label
    0.55, // N.Wt total
    1.2, // Empty space
    0.50, // Total Amount
  ];

  final RxList<String> totalHeadersValueOldGold = <String>[].obs;

  final totalColumnWidthsOldGold = [
    0.80, // "Old Gold Total" label
    0.80, // Pieces total
    0.80, // Gross weight total
    0.90, // Empty space
    0.30, // Total Amount
  ];
  List<String> popUpValues = ["Payment", "Return", "Edit", "Delete"];

  final InventoryRepository _inventoryRepository = InventoryRepository();

  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<CreateOrderItemDetailsTableData> controllers =
      <CreateOrderItemDetailsTableData>[].obs;

  final getPurityResponse = Rx<ApiResponse<GetPurityResponse>>(
    ApiResponse.initial("Initial"),
  );

  final getDesignResponse = Rx<ApiResponse<GetDesignDropdownResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxList<String> totalHeadersValue = <String>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final InventoryViewmodel _inventoryViewmodel = Get.put(InventoryViewmodel());

  final RxBool isManuallyEditingAmount = false.obs;
  final RxInt manuallyEditingRowIndex = (-1).obs;
  @override
  void onInit() {
    super.onInit();
    getCodeList();
    getPurityDetails();
    addRow();
    updateTotals();

    // Listen for rate mode changes
    final CreateOrderViewModel createOrderViewModel =
        Get.find<CreateOrderViewModel>();
    ever(createOrderViewModel.RateFixMode, (_) {
      // When mode changes, update all totals
      updateTotals();
      // Refresh the UI
      controllers.refresh();
    });
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

  void updateOldGoldTotals() {
    final CreateOrderOldGoldController oldGoldController =
        Get.put<CreateOrderOldGoldController>(CreateOrderOldGoldController());

    final oldGoldTotals = oldGoldController.totalHeadersValue;

    totalHeadersValueOldGold.value = [
      "Old Gold Total",
      oldGoldTotals.length > 1 ? oldGoldTotals[1] : "0", // Pieces
      oldGoldTotals.length > 2 ? oldGoldTotals[2] : "0", // Gross weight
      "", // Empty
      oldGoldTotals.length > 8 ? oldGoldTotals[8] : "0", // Total amount
    ];
  }

  // Future<void> getDesignDetails() async {
  //   try {
  //     getDesignResponse.value = ApiResponse.loading("Loading Designs");
  //     final response = await _inventoryRepository.getDesignDropdown(
  //       limit: 10,
  //     );
  //     getDesignResponse.value = ApiResponse.completed(response);
  //   } catch (e) {
  //     if (e is ApiException) {
  //       showErrorToast(message: e.toStringPrefix());
  //     }
  //     getDesignResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  Future<void> getCodeList() async {
    await _inventoryViewmodel.getAllOrnaments();
    codeList.assignAll(
      _inventoryViewmodel.getAllOrnamentsResponse.value.data?.values ?? [],
    );
  }

  void addRow() {
    // Get the rate from RateCaratInputController
    final RateCaratInputController rateController =
        Get.find<RateCaratInputController>();

    controllers.add(
      CreateOrderItemDetailsTableData(
        sn: (controllers.length + 1).toString(),
        item_description: TextEditingController(),
        rate: TextEditingController(text: rateController.currentRate),
        size: TextEditingController(),
        purity: TextEditingController(),
        nwt: TextEditingController(),
        gwt: TextEditingController(), // Add this
        va: TextEditingController(),
        mc: TextEditingController(),
        stone: TextEditingController(),
        gst: TextEditingController(text: "3"),
        amount: TextEditingController(),
        hallMark: TextEditingController(text: "0"), // Add this
        costDiscount: TextEditingController(text: "0"), // Add this
      ),
    );
    updateTotals();
  }

  void onRateChanged(double rate, String carat) {
    // Get the rate mode
    final CreateOrderViewModel createOrderViewModel =
        Get.find<CreateOrderViewModel>();
    bool isRateFix = createOrderViewModel.RateFixMode.value;

    // Update rate for all items with matching purity
    for (var item in controllers) {
      if (item.purity.text == carat) {
        item.rate.text = rate.toString();

        // Only recalculate totals if in Rate Fix mode
        if (isRateFix) {
          int index = controllers.indexOf(item);
          calculateJewelryPricing(index);
        }
      }
    }
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
    double totalNwt = 0;
    double totalAmount = 0;

    // Get the create order view model to check the mode
    final CreateOrderViewModel createOrderViewModel =
        Get.find<CreateOrderViewModel>();
    bool isRateFix = createOrderViewModel.RateFixMode.value;

    for (int i = 0; i < controllers.length; i++) {
      // Calculate pricing only if Rate Fix mode is enabled
      // AND the user is not manually editing this specific row's amount
      if (isRateFix &&
          !(isManuallyEditingAmount.value &&
              manuallyEditingRowIndex.value == i)) {
        calculateJewelryPricing(i);
      }

      // Sum up totals
      totalNwt += double.tryParse(controllers[i].nwt.text) ?? 0;
      totalAmount += double.tryParse(controllers[i].amount.text) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      totalNwt.toStringAsFixed(3),
      "",
      totalAmount.toStringAsFixed(2),
      "",
    ];
    update();
    updateOldGoldTotals();
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
      // Focus on the first field of the new row
      if (controllers.isNotEmpty) {
        currentRowIndex.value = controllers.length - 1;
        currentColIndex.value = 0;
        controllers.last.tableFocusNodes[0].requestFocus();
      }
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
    log("moving focus moveNextFocus to $currentRowIndex : $currentColIndex");
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
        log("inside else");
        previousFocusNode.requestFocus();
        log("moving focus move focus to $currentRowIndex : $currentColIndex");
        return KeyEventResult.handled;
      }
    } else if (keyboard == LogicalKeyboardKey.arrowDown) {
      if (currentRowIndex.value < controllers.length - 1) {
        currentRowIndex.value++;
      } else {
        nextFocusNode.requestFocus();
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

  // Calculate total amount for a row
  void calculateRowTotal(int index) {
    if (index < 0 || index >= controllers.length) return;

    var row = controllers[index];
    double nwt = double.tryParse(row.nwt.text) ?? 0;
    double va = double.tryParse(row.va.text) ?? 0;
    double mc = double.tryParse(row.mc.text) ?? 0;
    double stone = double.tryParse(row.stone.text) ?? 0;
    double gst = double.tryParse(row.gst.text) ?? 0;

    // Simple calculation - you can adjust this based on your business logic
    double baseAmount = nwt * 5000; // Assuming a base rate
    double vaAmount = baseAmount * (va / 100);
    double totalBeforeGst = baseAmount + vaAmount + mc + stone;
    double gstAmount = totalBeforeGst * (gst / 100);
    double totalAmount = totalBeforeGst + gstAmount;

    row.amount.text = totalAmount.toStringAsFixed(2);
    updateTotals();
  }

  // In CreateOrderItemDetailsController
  void showStoneDialog(int rowIndex) {
    List<StoneDetailsTableData> currentValue =
        controllers[rowIndex].stoneDetailsTableData;

    Get.dialog(
      barrierDismissible: false,
      StoneDetailsDialog(
        initialStoneValue: currentValue,
        onSave: (totalValue, stoneDetailsValue) {
          controllers[rowIndex].stone.text = totalValue.toStringAsFixed(2);
          controllers[rowIndex].stoneDetailsTableData = stoneDetailsValue;
          updateTotals();
        },
      ),
    );
  }

  JewelryCalculationReport calculateJewelryPricing(int index) {
    final item = controllers[index];

    // Get values from the controllers
    double nettWeight = double.tryParse(item.nwt.text) ?? 0;
    double grossWeight = double.tryParse(item.gwt.text) ?? 0;
    double metalRate = double.tryParse(item.rate.text) ?? 0;
    double stoneCost = double.tryParse(item.stone.text) ?? 0;
    double hallMarkCost = double.tryParse(item.hallMark.text) ?? 0;
    double costDiscount = double.tryParse(item.costDiscount.text) ?? 0;

    // Determine VA type and value
    double vaValue = double.tryParse(item.va.text) ?? 0;
    VAType vaType = getVAType(item.wastageType);

    // Determine MC value
    double mcValue = double.tryParse(item.mc.text) ?? 0;
    MCType mcType = getMCType(item.makingChargesType);

    double gstPercentage = double.tryParse(item.gst.text) ?? 3;

    JewelryCalculator calculator = JewelryCalculator(
      nettWeight: nettWeight,
      vaType: vaType,
      vaValue: vaValue,
      metalRate: metalRate,
      grossWeight: grossWeight,
      mcType: mcType,
      mcValue: mcValue,
      stoneCost: stoneCost + hallMarkCost,
      isGstApplicable: true,
      gstPercentage: gstPercentage,
      printGstInVA: false,
      costDiscount: costDiscount,
    );

    JewelryCalculationReport report = calculator.generateReport();

    double calculatedTotal = report.calculations.total;
    double roundedTotal = calculatedTotal.roundToDouble();

    item.salesAmount = report.calculations.subTotal.toStringAsFixed(2);
    item.total = roundedTotal.toStringAsFixed(2);
    item.amount.text = roundedTotal.toStringAsFixed(2);

    return report;
  }
}
