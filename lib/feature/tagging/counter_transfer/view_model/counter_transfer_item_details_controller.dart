// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/model/create_counter_transfer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view_model/counter_transfer_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CounterTransferItemDetailsTableData {
  String sn;
  String? itemId;
  TextEditingController existingTagNumber;
  TextEditingController counterNumber;
  TextEditingController description;
  TextEditingController gwt;
  TextEditingController nwt;
  TextEditingController stoneCost;
  TextEditingController totalCost;
  String wst_unit;
  List<StoneDetailsTableData> stoneDetailsTableData;
  List<FocusNode> tableFocusNodes;

  CounterTransferItemDetailsTableData({
    required this.sn,
    required this.existingTagNumber,
    required this.counterNumber,
    required this.description,
    required this.gwt,
    required this.nwt,
    required this.stoneCost,
    required this.totalCost,
    this.wst_unit = "%",
    List<StoneDetailsTableData>? stoneDetailsTableData,
    List<FocusNode>? tableFocusNodes,
  }) : stoneDetailsTableData = stoneDetailsTableData ?? [],
       tableFocusNodes =
           tableFocusNodes ?? List.generate(6, (_) => FocusNode());

  Map<String, dynamic> toJsonValue() {
    return {
      'sn': sn,
      'existingTagNumber': existingTagNumber.text,
      'counterNumber': counterNumber.text,
      'description': description.text,
      'gwt': gwt.text,
      'nwt': nwt.text,
      'stoneCost': stoneCost.text,
      'totalCost': totalCost.text,
      'stone_details':
          stoneDetailsTableData.map((stone) => stone.toJsonValue()).toList(),
    };
  }
}

// TaggingItemDetailsController
class CounterTransferItemDetailsController extends GetxController {
  final headers =
      [
        'Sn',
        'Existing Tag Number',
        // "Counter Number",
        'Description',
        'G.Wt. (gm)',
        'N.Wt. (gm)',
        "Stone Cost",
        'Total Cost',
        '',
      ].obs;

  final columnWidths =
      [
        0.1,
        0.6,
        // 0.5,
        0.9,
        0.5,
        0.5,
        0.5,
        0.5,
        0.05,
      ].obs;
  final totalColumnWidths =
      [
        1.8,
        // 0.175,
        0.6,
        0.4,
        0.4,
        0.4,
        // 0.2,
        // 0.3,
        // 0.3,
        // 0.3,
        // 0.1,
      ].obs;
  final _debouncer = CustomDebouncer(milliseconds: 1000);

  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;
  final RxList<CounterTransferItemDetailsTableData> controllers =
      <CounterTransferItemDetailsTableData>[].obs;

  final CounterTransferController headerController =
      Get.put<CounterTransferController>(CounterTransferController());
  final RxList<String> totalHeadersValue = <String>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final InventoryViewmodel _inventoryViewmodel = Get.put(InventoryViewmodel());

  final InventoryRepository inventoryRepository = InventoryRepository();
  final ScrollController scrollController = ScrollController();

  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;

  RxBool isHUIDtrue = false.obs;
  void toggleHUID() => isHUIDtrue.toggle();

  @override
  void onInit() {
    super.onInit();
    getCodeList();
    addRow();
    updateTotals();
  }

  Future<void> getCodeList() async {
    await _inventoryViewmodel.getAllOrnaments();
    codeList.assignAll(
      _inventoryViewmodel.getAllOrnamentsResponse.value.data?.values ?? [],
    );
  }

  void addRow() {
    controllers.add(
      CounterTransferItemDetailsTableData(
        sn: (controllers.length + 1).toString(),
        existingTagNumber: TextEditingController(),
        counterNumber: TextEditingController(),
        description: TextEditingController(),
        gwt: TextEditingController(),
        nwt: TextEditingController(),
        stoneCost: TextEditingController(),
        totalCost: TextEditingController(),
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

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
      focusOnNewRow();
    }
  }

  void updateTotals() {
    double totalGWt = 0;
    double totalNWt = 0;
    double totalStoneCost = 0;
    double totalCost = 0;

    for (var row in controllers) {
      totalGWt += double.tryParse(row.gwt.text) ?? 0;
      totalNWt += double.tryParse(row.nwt.text) ?? 0;
      totalStoneCost += double.tryParse(row.stoneCost.text) ?? 0;
      totalCost += double.tryParse(row.totalCost.text) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      totalGWt.toStringAsFixed(3),
      totalNWt.toStringAsFixed(3),
      totalStoneCost.toStringAsFixed(2),
      totalCost.toStringAsFixed(2),
      "",
    ];
    update();
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

  void movePreviousFocus() {
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
    }
  }

  void moveNextFocus() {
    if (currentColIndex.value <
        controllers[currentRowIndex.value].tableFocusNodes.length - 1) {
      currentColIndex.value++;
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex.value < controllers.length - 1) {
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
        // log("moving focus move focus to $currentRowIndex : $currentColIndex");
      } else {
        // print("inside else");
        previousFocusNode.requestFocus();
        // node.previousFocus();
        // log("moving focus move focus to $currentRowIndex : $currentColIndex");
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
    // log("moving focus move focus to $currentRowIndex : $currentColIndex");
    return result;
  }

  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.tab) {
        // if (event.isShiftPressed) {
        movePreviousFocus();
        // } else {
        // moveNextFocus();
        // }
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        moveNextFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Future<void> fetchAndPopulateData(int rowIndex) async {
    try {
      String tagNumber = controllers[rowIndex].existingTagNumber.text.trim();
      if (tagNumber.isEmpty) return;

      // Show loading indicator
      // Get.dialog(
      //   const Center(
      //     child: CircularProgressIndicator(),
      //   ),
      //   barrierDismissible: false,
      // );

      _debouncer.run(() async {
        final response = await inventoryRepository.getByExistingTag(tagNumber);

        // Close loading indicator
        // if (Get.isDialogOpen ?? false) {
        Get.back();
        // }

        if (response != null) {
          // Populate the fields

          controllers[rowIndex].itemId = response.id;
          controllers[rowIndex].description.text = response.design?.name ?? '';
          controllers[rowIndex].gwt.text = response.grossWeight ?? '';
          controllers[rowIndex].nwt.text = response.netWeight ?? '';

          // Calculate stone cost from line stones
          double totalStoneCost = 0;
          if (response.lineStones != null) {
            for (var stone in response.lineStones!) {
              totalStoneCost += double.tryParse(stone.total ?? '0') ?? 0;
            }
          }
          controllers[rowIndex].stoneCost.text = totalStoneCost.toString();

          // Calculate total cost
          double grossWeight =
              double.tryParse(response.grossWeight ?? '0') ?? 0;
          double rate = double.tryParse(response.rate ?? '0') ?? 0;
          double totalCost = (grossWeight * rate) + totalStoneCost;
          controllers[rowIndex].totalCost.text = totalCost.toString();

          // Update totals
          updateTotals();

          // Add a new row if this is the last row
          if (rowIndex == controllers.length - 1) {
            addRow();
            focusOnNewRow();
          }
        } else {
          // Handle case when no data is found
          showErrorToast(message: "No item found with tag number: $tagNumber");
        }
      });
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      showErrorToast(message: "Failed to fetch item details: ${e.toString()}");
    }
  }

  Future<void> submitCounterTransfer() async {
    try {
      // Validate header data
      if (headerController.selectedCounter.value == null) {
        throw Exception('Please select transfer to counter');
      }
      if (headerController.selectedEmployee.value == null) {
        throw Exception('Please select transfer by employee');
      }

      // Validate line items
      if (controllers.isEmpty) {
        throw Exception('Please add at least one item');
      }

      // Collect item IDs from the fetched responses
      List<String> itemIds = [];
      for (var controller in controllers) {
        if (controller.itemId == null) {
          throw Exception(
            'Item in row ${controller.sn} was not resolved. '
            'Please re-enter the tag number.',
          );
        }
        itemIds.add(controller.itemId!);
      }

      // Create request model
      final request = CreateCounterTransferRequest(
        counterToId: headerController.selectedCounter.value!.id,
        itemIds: itemIds,
        employeeId: headerController.selectedEmployee.value!.id,
      );

      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Make API call
      await inventoryRepository.createCounterTransfer(request);

      // Close loading dialog
      Get.back();

      // Show success message
      showSuccessToast(message: 'Counter transfer created successfully');

      clearForm();
      // Clear form and reset
      // _clearForm();
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      // Show error message
      showErrorToast(message: e.toString());
    }
  }

  void clearForm() {
    // Clear controllers
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.clear();

    // Reset header selections
    headerController.selectedCounter.value = null;
    headerController.selectedEmployee.value = null;

    // Add initial empty row
    addRow();
    updateTotals();
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
    // Reset all text controllers for the specified row

    controllers[index].itemId = null;
    controllers[index].existingTagNumber.clear();
    controllers[index].counterNumber.clear();
    controllers[index].description.clear();
    controllers[index].gwt.clear();
    controllers[index].nwt.clear();
    controllers[index].stoneCost.clear();
    controllers[index].totalCost.clear();

    // Reset stone details if any exist
    controllers[index].stoneDetailsTableData.clear();

    // Reset to default unit
    controllers[index].wst_unit = "%";

    // Update totals and refresh UI
    updateTotals();
    update();
  }

  void focusOnNewRow() {
    if (controllers.isEmpty) return;

    currentRowIndex.value = controllers.length - 1;
    currentColIndex.value = 0;

    // Use Future.delayed to ensure the UI has updated
    Future.delayed(const Duration(milliseconds: 100), () {
      if (controllers.isNotEmpty &&
          currentRowIndex.value < controllers.length &&
          controllers[currentRowIndex.value].tableFocusNodes.isNotEmpty) {
        controllers[currentRowIndex.value]
            .tableFocusNodes[currentColIndex.value]
            .requestFocus();

        // Scroll to make the new row visible
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          );
        }
      }
    });
  }
}
