// ignore_for_file: library_prefixes

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/counter_drop_down_model.dart'
    as Counter;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_by_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_to_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/branch_report_repository.dart';

abstract class BaseBranchTransferViewModel extends GetxController {
  final BranchReportRepository branchReportServices = BranchReportRepository();
  final formKey = GlobalKey<FormState>();

  final headers = [
    'Sn',
    'Existing Tag Number',
    'Counter Number',
    'Description',
    'Gross Wt (gm)',
    'Net Wt (gm)',
    'Stone Cost(₹)',
    'Total Cost (₹)',
    ' ',
  ];

  final columnWidths = [0.2, 0.5, 0.5, 0.7, 0.5, 0.5, 0.44, 0.4, 0.2].obs;

  final controllers = <RowController>[].obs;
  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;
  final RxList<String> totalHeadersValue = <String>[].obs;

  String branchTransferToUUID = '';
  String branchTransferByUUID = '';

  TextEditingController branchTransferFrom = TextEditingController();
  TextEditingController branchTransferBy = TextEditingController();

  final Rx<ApiResponse<TransferToDropDownModel>> transferToDroopDownList = Rx(
    ApiResponse.initial("initial"),
  );
  final Rx<ApiResponse<TransferByDropDownModel>> transferByDroopDownList = Rx(
    ApiResponse.initial("initial"),
  );
  final Rx<ApiResponse<TransferByDropDownModel>> counterListDropdown = Rx(
    ApiResponse.initial("initial"),
  );
  final RxList<Counter.Value> counterList = <Counter.Value>[].obs;

  Counter.Value? defaultCounter;

  GetTaggingLineItemCodeTagResponse? getTaggingLineItemCodeTagResponse;

  final RxBool showItemPreview = false.obs;
  final Rx<dynamic> currentItemDetails = Rx<dynamic>(null);
  final RxList<dynamic> selectedLineItems = RxList<dynamic>([]);

  @override
  void onInit() {
    initializeData();
    super.onInit();
  }

  void initializeData() {
    fetchDropDownData();
    addRow();
  }

  void fetchDropDownData() async {
    await Future.wait([
      getCounterList(),
      getAllTransferBy(),
      getAllTransferTo(),
    ]);
  }

  void addRow() {
    controllers.add(RowController());
    if (defaultCounter != null) {
      controllers.last.counterId.text = defaultCounter!.id ?? '';
    }
    updateTotals();
    update();
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
    }
  }

  void removeCurrentRow(int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      updateTotals();
      update();
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    }
  }

  void updateTotals() {
    try {
      double totalGWt = 0.0;
      double totalNWt = 0.0;
      double totalStoneCost = 0.0;
      double totalCost = 0.0;

      for (var row in controllers) {
        totalGWt += double.tryParse(row.grossWt.text.trim()) ?? 0.0;
        totalNWt += double.tryParse(row.netWt.text.trim()) ?? 0.0;
        totalStoneCost += double.tryParse(row.stoneCost.text.trim()) ?? 0.0;
        totalCost += double.tryParse(row.totalCost.text.trim()) ?? 0.0;
      }

      totalHeadersValue.value = [
        "Total",
        "",
        "",
        "",
        totalGWt.toStringAsFixed(3),
        totalNWt.toStringAsFixed(3),
        totalStoneCost.toStringAsFixed(2),
        totalCost.toStringAsFixed(2),
        "",
      ];
    } catch (e) {
      log("Error updating totals: $e");
      totalHeadersValue.value = [
        "Total",
        "",
        "",
        "",
        "0.000",
        "0.000",
        "0.00",
        "0.00",
        "",
      ];
    }
    update();
  }

  void moveFocusToNextCell(int rowIndex, int colIndex) {
    final isLastColumn = colIndex == headers.length - 2;
    final isLastRow = rowIndex == controllers.length - 1;

    if (isLastColumn) {
      if (isLastRow) {
        addRow();
      }
      currentRowIndex.value = isLastRow ? controllers.length - 1 : rowIndex + 1;
      currentColIndex.value = 0;
    } else {
      currentColIndex.value = colIndex + 1;
    }

    final nextFocusNode = controllers[currentRowIndex.value].getFocusNode(
      currentColIndex.value,
    );
    nextFocusNode.requestFocus();
  }

  KeyEventResult handleTableKeyEvent(
    FocusNode node,
    KeyEvent event,
    int rowIndex,
    int colIndex,
  ) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      moveFocusToNextCell(rowIndex, colIndex);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> getAllTransferTo() async {
    try {
      transferToDroopDownList.value = ApiResponse.loading("loading");
      final response = await branchReportServices.getAllTransferTo();
      transferToDroopDownList.value = ApiResponse.completed(response);
      update();
    } catch (e) {
      transferToDroopDownList.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getAllTransferBy() async {
    try {
      transferByDroopDownList.value = ApiResponse.loading("loading");
      final response = await branchReportServices.getAllTransferBy();
      transferByDroopDownList.value = ApiResponse.completed(response);
      update();
    } catch (e) {
      transferByDroopDownList.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getCounterList() async {
    try {
      final response = await branchReportServices.getCounterList();
      counterList.assignAll(response.values ?? []);
      defaultCounter = counterList.firstWhereOrNull(
        (counter) => counter.isDefault == true,
      );
    } catch (e) {
      log('Error fetching counter List: $e');
    }
  }

  /// Subclasses must implement their submit logic.
  Future<void> submit();

  List<dynamic> getPreviewItems() {
    return selectedLineItems;
  }

  void clearItemPreview() {
    showItemPreview.value = false;
    currentItemDetails.value = null;
    selectedLineItems.clear();
    update();
  }

  void discardAndReset() {
    controllers.clear();
    addRow();
    update();
  }

  @override
  void onClose() {
    clearItemPreview();
    super.onClose();
  }
}

class RowController {
  final TextEditingController snController = TextEditingController();
  final TextEditingController extistingTagNumber = TextEditingController();
  final TextEditingController counterId = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController grossWt = TextEditingController();
  final TextEditingController netWt = TextEditingController();
  final TextEditingController stoneCost = TextEditingController();
  final TextEditingController totalCost = TextEditingController();
  final TextEditingController action = TextEditingController();
  final TextEditingController pieces = TextEditingController();

  final List<FocusNode> tableFocusNodes = List.generate(9, (_) => FocusNode());

  TextEditingController getController(int colIndex) {
    return [
      snController,
      extistingTagNumber,
      counterId,
      description,
      grossWt,
      netWt,
      stoneCost,
      totalCost,
      action,
      pieces,
    ][colIndex];
  }

  FocusNode getFocusNode(int colIndex) {
    return tableFocusNodes[colIndex];
  }

  void dispose() {
    snController.clear();
    extistingTagNumber.dispose();
    counterId.dispose();
    description.dispose();
    grossWt.dispose();
    netWt.dispose();
    stoneCost.dispose();
    totalCost.dispose();
    pieces.dispose();
    for (var focusNode in tableFocusNodes) {
      focusNode.dispose();
    }
  }
}
