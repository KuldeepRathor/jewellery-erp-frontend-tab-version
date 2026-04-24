// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/sales_sales_person_selection_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';

import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/calculator/estimation_calculator.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CreateSalesItemDetailsTableData {
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
  String? salesAmountWithoutRoundoff;
  String? salesAmountRoundoffDiff;
  String total;
  String? totalAmountWithoutRoundoff;
  String? totalAmountRoundoffDiff;
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
  String? purity;
  List<FocusNode> tableFocusNodes = List.generate(
    13,
    (index) => FocusNode(),
  ); // Increased from 7 to 15
  GetEmployeesValue? employeeDetails;
  CreateSalesItemDetailsTableData({
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
    required this.purity,
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

class CreateSalesItemDetailsController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final headers = [
    'Sn',
    'Item Code',
    'Tag No',
    "Description",
    'Pcs',
    'G.Wt. (gm)',
    'N.Wt. (gm)',
    'VA%',
    'MC Total (₹)',
    'Stone Cost(₹)',
    'Hall Mark',
    // 'Rate', // Added new column
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
    0.3, // Stone Cost
    0.3, // Hall Mark
    // 0.3, // Rate (new)
    0.3, // Cost Discount
    0.3, // Sales Amount
    0.3, // Total
    0.1, // Empty (for actions)
  ];

  final totalColumnWidthsOldGold = [0.8, 0.2, 0.3, 2.0, 0.3, 0.1];

  List<String> popUpValues = ["View", "Return", "Edit", "Delete"];
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<CreateSalesItemDetailsTableData> controllers =
      <CreateSalesItemDetailsTableData>[].obs;
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
      CreateSalesItemDetailsTableData(
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
        purity: null,
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

  final CustomDebouncer debouncer = CustomDebouncer(milliseconds: 500);

  void updateTotals() {
    double totalPcs = 0;
    double totalGWt = 0;

    double totalNWt = 0;
    // ignore: unused_local_variable
    double totalVATch = 0;
    double totalMC = 0;
    double totalStone = 0;
    double hallMark = 0;
    // double rate = 0;
    double costDiscount = 0;
    double salesAmount = 0;
    double totalAmount = 0;

    for (var row in controllers) {
      totalPcs += double.tryParse(row.pcs.text) ?? 0;
      totalGWt += double.tryParse(row.gwt.text) ?? 0;

      totalNWt += double.tryParse(row.nwt.text) ?? 0;
      totalVATch += double.tryParse(row.va.text) ?? 0;

      final mcRate = double.tryParse(row.mc.text) ?? 0;
      final makingChargesType = row.makingChargesType?.toLowerCase();

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
        final pcs = double.tryParse(row.pcs.text) ?? 0;
        mcTotal = mcRate * pcs;
      }
      totalMC += mcTotal;

      totalStone += double.tryParse(row.stone.text) ?? 0;
      hallMark += double.tryParse(row.hallMark.text) ?? 0;
      // rate += double.tryParse(row.rate.text) ?? 0;
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
      totalGWt.toStringAsFixed(3),
      totalNWt.toStringAsFixed(3), "",
      // totalVATch.toStringAsFixed(2),
      totalMC.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      hallMark.toStringAsFixed(2),
      // rate.toStringAsFixed(2),
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
      getLatestRowInFocus();
      updateTotals();
    }
  }

  void getLatestRowInFocus() {
    controllers.last.tableFocusNodes.first.requestFocus();
    currentRowIndex.value = controllers.length - 1;
    currentColIndex.value = 0;
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

    final CreateSalesEstimationSearchPartyController partyController =
        Get.find<CreateSalesEstimationSearchPartyController>();
    final CreateSalesViewModel createSalesEstimationController =
        Get.find<CreateSalesViewModel>();

    String? customerId;
    if (partyController.selectedParty.value != null) {
      if (partyController.selectedParty.value is CustomerSearchValue) {
        customerId = partyController.selectedParty.value.id;
      }
    }

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
        final response = await _inventoryRepository
            .getTaggingLineItemCodeTagSales(
              itemCode,
              tagNumber,
              customer_id: customerId,
              metal_type_id:
                  createSalesEstimationController.selectedMetalType.value,
            );

        if (response.status?.toLowerCase() == "in approval") {
          showErrorToast(message: "Remove the item from approval for billing");
          controllers[index].code.text = '';
          controllers[index].tagNo.text = '';
          return;
        }

        if (response.status?.toLowerCase() != "available") {
          showErrorToast(message: "The item is not available");
          controllers[index].code.text = '';
          controllers[index].tagNo.text = '';
          return;
        }

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
        // controllers[index].makingChargesType =
        //     response.designLineItem?.makingChargesType ?? "";

        controllers[index].makingChargesType =
            response.designMakingChargesType ?? "";

        // controllers[index].minVa =
        //     double.tryParse(response.designLineItem?.minVa ?? "q");
        controllers[index].minVa = double.tryParse(response.designMinVa ?? "q");
        // controllers[index].minMC =
        //     double.tryParse(response.designLineItem?.minMc ?? "q");
        controllers[index].minMC = double.tryParse(response.designMinMc ?? "q");

        // controllers[index].wastageType = response.designLineItem?.wastageType;

        controllers[index].wastageType = response.designWastageType ?? "";

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
        controllers[index].purity = purity;
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

        calculateSalesAndTotalAmountforFetchedItems(index: index);
        updateTotals();
        update();
        controllers.refresh();

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
        // Show sales person dialog after successfully fetching item data
        if (askSalesPersonDetails) {
          CreateSalesSalesPersonDialog.show(
            context: Get.context!,
            rowIndex: index,
            title: 'Select Sales Person for ${response.code}',
          );
        }
        showSuccessToast(message: "Fetched successfully!");

        // Get the create sales view model to check the mode
        final CreateSalesViewModel createSalesViewModel =
            Get.find<CreateSalesViewModel>();

        // Check if we're in correction mode (not fast mode)
        if (!createSalesViewModel.isFastMode.value) {
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
        controllers[index].purity = null;
        controllers[index].employeeDetails = null;

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
        if (response.status?.toLowerCase() != "available") {
          showErrorToast(message: "The item is not available");
          controllers[index].barcode = '';
          return;
        }
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
        controllers[index].purity = purity;
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
        // Calculate and update
        calculateSalesAndTotalAmountforFetchedItems(index: index);
        updateTotals();
        update();

        controllers.refresh();

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
          CreateSalesSalesPersonDialog.show(
            context: Get.context!,
            rowIndex: index,
            title: 'Select Sales Person for ${response.code}',
          );
        }

        showSuccessToast(message: "Fetched successfully!");
        // Get the create sales view model to check the mode
        final CreateSalesViewModel createSalesViewModel =
            Get.find<CreateSalesViewModel>();

        // Check if we're in correction mode (not fast mode)
        if (!createSalesViewModel.isFastMode.value) {
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
        controllers[index].purity = null;
        controllers[index].employeeDetails = null;

        controllers.refresh();
        showErrorToast(message: 'Failed to fetch item details');
      }
    }
  }

  void addToControllersFromEstimateNumberApi({
    required GetSaleByEstimateResponse response,
  }) {
    List<CreateSalesItemDetailsTableData> dataList = [];
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
      CreateSalesItemDetailsTableData data = CreateSalesItemDetailsTableData(
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
        originalMc: double.tryParse(element.taggingDetails?.mc ?? "0") ?? 0,
        originalVa: double.tryParse(element.taggingDetails?.va ?? "0") ?? 0,
        isHandOver: true,
        makingChargesType:
            element.taggingDetails?.designMakingChargesType ?? "",
        minVa: double.tryParse(element.taggingDetails?.designMinVa ?? "0"),
        minMC: double.tryParse(element.taggingDetails?.designMinMc ?? "0"),
        wastageType: element.taggingDetails?.designWastageType,
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
        purity: element.taggingDetails?.purity,
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
      data.employeeDetails = element.salesPerson;
      dataList.add(data);
      index++;
    }

    // Assuming you want to update the controllers list
    controllers.clear();
    controllers.assignAll(dataList);
    for (var i = 0; i < controllers.length; i++) {
      addSalesAndTotalAmount(index: i);
    }
    controllers.refresh();
    updateTotals();
    update();
  }

  List<CreateSalesItemDetailsTableData> getSortedEstimationList({
    required String sortBy,
  }) {
    // Create a copy of the list to avoid modifying the original
    final sortedList = List<CreateSalesItemDetailsTableData>.from(controllers);

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

  void calculateSalesAndTotalAmountforFetchedItems({required int index}) {
    final item = controllers[index];
    String? wastageType = item.wastageType;

    // Set the VA value according to the wastage type
    if (wastageType?.toLowerCase() == "%") {
      item.va.text = item.originalVa.toStringAsFixed(3);
      item.wastageType = "%";
    } else {
      item.va.text = item.originalVa.toStringAsFixed(3);
      item.wastageType = "gm";
    }

    // Set the MC value
    item.mc.text = item.originalMc.toStringAsFixed(2);

    // Use the jewelry calculator for total calculations
    JewelryCalculationReport report = calculateJewelryPricing(index);

    // Get the payment controller to check if jeweller discount is applied
    final SalesPaymentDetailsController paymentController =
        Get.find<SalesPaymentDetailsController>();

    bool hasJewellerDiscount = paymentController.isJewellerDiscountApplied();

    double rawSalesAmount = report.calculations.subTotal;
    double rawTotal = report.calculations.total;

    // Update the controllers with calculated values
    if (hasJewellerDiscount) {
      // Keep precise calculations when jeweller discount is applied
      item.salesAmount = rawSalesAmount.toStringAsFixed(2);
      item.salesAmountWithoutRoundoff = null;
      item.salesAmountRoundoffDiff = null;

      item.total = rawTotal.toStringAsFixed(2);
      item.totalAmountWithoutRoundoff = null;
      item.totalAmountRoundoffDiff = null;
    } else {
      // Apply rounding when NO jeweller discount is applied
      double roundedSalesAmount = rawSalesAmount.roundToDouble();
      double roundedTotal = rawTotal.roundToDouble();

      item.salesAmount = roundedSalesAmount.toStringAsFixed(2);
      item.total = roundedTotal.toStringAsFixed(2);

      item.salesAmountWithoutRoundoff = rawSalesAmount.toStringAsFixed(2);
      item.salesAmountRoundoffDiff = (roundedSalesAmount - rawSalesAmount)
          .toStringAsFixed(2);

      item.totalAmountWithoutRoundoff = rawTotal.toStringAsFixed(2);
      item.totalAmountRoundoffDiff = (roundedTotal - rawTotal).toStringAsFixed(
        2,
      );
    }

    updateTotals();
    controllers.refresh();
  }

  void addSalesAndTotalAmount({required int index}) {
    JewelryCalculationReport report = calculateJewelryPricing(index);

    final SalesPaymentDetailsController paymentController =
        Get.find<SalesPaymentDetailsController>();

    // Check if jeweller discount is being used
    bool hasJewellerDiscount = paymentController.isJewellerDiscountApplied();

    double rawSalesAmount = report.calculations.subTotal;
    double rawTotal = report.calculations.total;

    if (hasJewellerDiscount) {
      // Keep precise calculations when jeweller discount is applied
      controllers[index].salesAmount = rawSalesAmount.toStringAsFixed(2);
      controllers[index].salesAmountWithoutRoundoff = null;
      controllers[index].salesAmountRoundoffDiff = null;

      controllers[index].total = rawTotal.toStringAsFixed(2);
      controllers[index].totalAmountWithoutRoundoff = null;
      controllers[index].totalAmountRoundoffDiff = null;
    } else {
      // Apply rounding when NO jeweller discount is applied
      double roundedSalesAmount = rawSalesAmount.roundToDouble();
      double roundedTotal = rawTotal.roundToDouble();

      controllers[index].salesAmount = roundedSalesAmount.toStringAsFixed(2);
      controllers[index].total = roundedTotal.toStringAsFixed(2);

      controllers[index].salesAmountWithoutRoundoff = rawSalesAmount
          .toStringAsFixed(2);
      controllers[index].salesAmountRoundoffDiff =
          (roundedSalesAmount - rawSalesAmount).toStringAsFixed(2);

      controllers[index].totalAmountWithoutRoundoff = rawTotal.toStringAsFixed(
        2,
      );
      controllers[index].totalAmountRoundoffDiff = (roundedTotal - rawTotal)
          .toStringAsFixed(2);
    }

    updateTotals();
    update();
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

          final tableData = CreateSalesItemDetailsTableData(
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
            mc: TextEditingController(text: lineItem.finalMc),
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
            purity: lineItem.taggingDetails?.purity,
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

          tableData.employeeDetails = lineItem.salesPerson;
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

  void onRateChanged(double rate, String carat) {
    controllers.where((item) => item.purity == carat).forEach((item) {
      item.rate.text = rate.toString();
      calculateSalesAndTotalAmountforFetchedItems(
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
    controllers[index].barcode = "";
    controllers[index].originalGwt = "";
    controllers[index].originalNwt = "";

    // Reset nullable strings
    controllers[index].designMakingChargesTypeId = null;
    controllers[index].makingChargesType = null;
    controllers[index].wastageType = null;
    controllers[index].ornamentId = null;
    controllers[index].shopId = null;
    controllers[index].taggingId = null;
    controllers[index].tagNumber = null;
    controllers[index].status = null;
    controllers[index].designCode = null;
    controllers[index].counter = null;
    controllers[index].stockHead = null;
    controllers[index].ornamentCode = null;
    controllers[index].ornamentName = null;
    controllers[index].purity = null;

    // Reset nullable doubles
    controllers[index].minVa = null;
    controllers[index].minMC = null;

    // Reset boolean
    controllers[index].isHandOver = false;

    // Clear lists
    controllers[index].images.clear();
    controllers[index].stoneDetailsTableData.clear();

    // Restore the original serial number
    controllers[index].sn = originalSn;

    controllers[index].employeeDetails = null;

    // Update UI
    updateTotals();
    controllers.refresh();
    update();
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
    String? wastageType = item.wastageType;
    VAType vaType = getVAType(wastageType);

    // The VA value depends on the type - use what's in the text field, which should be either percentage or grams
    double vaValue = double.tryParse(item.va.text) ?? 0;

    // Determine MC type and value
    String? mcType = item.makingChargesType;
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
      stoneCost:
          stoneCost +
          hallMarkCost, // Combining stone cost and hallmark as "additional costs"
      isGstApplicable: isGstApplicable,
      gstPercentage: gstPercentage,
      printGstInVA: false, // Adjust as needed
      costDiscount: costDiscount,
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
    log("Total: hbsak bkc${totalHeadersValue.toString()}");
    final length = totalHeadersValue.length;
    double total = double.parse(totalHeadersValue[length - 2]);

    // Validate the input - early return if discount is negative
    if (jewellerDiscount < 0) {
      showErrorToast(message: 'Discount amount cannot be negative');
      SalesPaymentDetailsController estimationViewModel =
          Get.find<SalesPaymentDetailsController>();
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
      SalesPaymentDetailsController estimationViewModel =
          Get.find<SalesPaymentDetailsController>();
      double difference = 0;
      estimationViewModel.setAdditionalLess(value: difference);
      return;
    }

    // Calculate maximum possible discount across all items
    double maxPossibleDiscount = _calculateMaxPossibleDiscount();

    if (jewellerDiscount > maxPossibleDiscount) {
      showErrorToast(
        message: 'Maximum possible amount is ${total - maxPossibleDiscount}',
      );
      showErrorToast(
        message:
            " Amount exceeded by ${(jewellerDiscount - maxPossibleDiscount).toStringAsFixed(2)}",
      );
      // showErrorToast(
      //   message:
      //       " Minimum amount possible is ${(jewellerDiscount - maxPossibleDiscount).toStringAsFixed(2)}",
      // );
      // SalesPaymentDetailsController estimationViewModel =
      //     Get.find<SalesPaymentDetailsController>();
      // double difference = jewellerDiscount - maxPossibleDiscount;
      // estimationViewModel.setAdditionalLess(
      //     value: difference + difference * (gstPercent / 100));
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
      String? wastageType = lineItem.wastageType;
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
    CreateSalesItemDetailsTableData lineItem,
  ) {
    // Create calculators for VA
    JewelryCalculator vaCalculator = JewelryCalculator(
      nettWeight: double.tryParse(lineItem.nwt.text) ?? 0,
      vaType: getVAType(lineItem.wastageType),
      vaValue: lineItem.originalVa,
      metalRate: double.tryParse(lineItem.rate.text) ?? 0,
      grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
    );

    JewelryCalculator minVaCalculator = JewelryCalculator(
      nettWeight: double.tryParse(lineItem.nwt.text) ?? 0,
      vaType: getVAType(lineItem.wastageType),
      vaValue: lineItem.minVa ?? 0,
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
      mcType: getMCType(lineItem.makingChargesType),
      mcValue: lineItem.originalMc,
      grossWeight: double.tryParse(lineItem.gwt.text) ?? 0,
      metalRate: double.tryParse(lineItem.rate.text) ?? 0,
    );

    JewelryCalculator minMcCalculator = JewelryCalculator(
      nettWeight: double.tryParse(lineItem.nwt.text) ?? 0,
      mcType: getMCType(lineItem.makingChargesType),
      mcValue: (lineItem.minMC) ?? 0,
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
    CreateSalesItemDetailsTableData lineItem,
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
    CreateSalesItemDetailsTableData lineItem,
    double vaDiscount,
  ) {
    String? wastageType = lineItem.wastageType;

    if (wastageType?.toLowerCase() == "%") {
      // For percentage VA
      double originalVaPercentage = lineItem.originalVa;
      double minVaPercentage = (lineItem.minVa) ?? 0;
      double netWeight = double.tryParse(lineItem.nwt.text) ?? 0;
      double currentRate = double.tryParse(lineItem.rate.text) ?? 0;

      // Calculate discount percentage points proportional to the monetary discount
      double vaPerDiscount = (vaDiscount / (netWeight * currentRate / 100));

      // Calculate new VA percentage (ensure it's not below minimum)
      double newVaPercentage = math.max(
        originalVaPercentage - vaPerDiscount,
        minVaPercentage,
      );
      lineItem.va.text = newVaPercentage.toStringAsFixed(2);
      if (newVaPercentage > minVaPercentage) {
        lineItem.va.text = ((newVaPercentage * 100).ceil() / 100)
            .toStringAsFixed(2);
        lineItem.costDiscount.text = ((((newVaPercentage * 100).ceil() / 100) -
                    newVaPercentage) *
                currentRate /
                netWeight)
            .toStringAsFixed(2);
        log("New Va Percentage ${lineItem.costDiscount.text}");
      } // Update VA value
    } else {
      // For gram-based VA
      double originalVaGrams = lineItem.originalVa;
      double minVaGrams = (lineItem.minVa) ?? 0;
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
    CreateSalesItemDetailsTableData lineItem,
    double mcDiscount,
  ) {
    String? mcType = lineItem.makingChargesType;

    if (mcType?.toLowerCase() == "gwt") {
      // Per gram on gross weight
      double originalMcRate = lineItem.originalMc;
      double minMcRate = (lineItem.minMC) ?? 0;
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
      double minMcRate = (lineItem.minMC) ?? 0;
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
      double minMcAmount = (lineItem.minMC) ?? 0;

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

  bool validateVAMCChanges({
    required int index,
    required String field, // 'va' or 'mc'
    required String newValue,
  }) {
    try {
      double inputValue = double.tryParse(newValue) ?? 0;

      if (field == 'va') {
        // Get minimum VA
        double minVa = (controllers[index].minVa) ?? 0;

        String? wastageType = controllers[index].wastageType;

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
        double minMc = (controllers[index].minMC) ?? 0;

        String? mcType = controllers[index].makingChargesType;

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

  bool hasNoSalesPerson() {
    return controllers.any((controller) => controller.employeeDetails == null);
  }

  void onEmployeeSelected({
    required int rowIndex,
    required GetEmployeesValue employee,
  }) {
    controllers.elementAt(rowIndex).employeeDetails = employee;
    controllers.refresh();
    log("here is the employee");
    update();
  }
}
