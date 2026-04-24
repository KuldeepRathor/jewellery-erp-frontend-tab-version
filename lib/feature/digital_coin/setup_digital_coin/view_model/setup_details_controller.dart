// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/get_commodities_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/setup_digital_coin/model/setup_digital_coin_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SetupDetailsTableData {
  TextEditingController commodity;
  TextEditingController item_description;
  TextEditingController hsn;
  TextEditingController va;
  TextEditingController invoice_prefix;
  RxBool isActive;

  List<FocusNode> tableFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  SetupDetailsTableData({
    required this.commodity,
    required this.item_description,
    required this.hsn,
    required this.va,
    required this.invoice_prefix,
    required this.isActive,
  });
  Map<String, dynamic> toJsonValue() {
    return {
      'commodity': commodity.text,
      'item_description': item_description.text,
      'hsn': hsn.text,
      'va': va.text,
      'invoice_prefix': invoice_prefix.text,
      'isActive': isActive.value,
    };
  }
}

class SetupDetailsController extends GetxController {
  final headers = [
    'Commodity',
    'Item Description',
    'HSN',
    'VA',
    'invoice_prefix',
    'action',
    // ''
  ];

  final columnWidths = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6];

  List<String> popUpValues = ["Payment", "Return", "Edit", "Delete"];

  final JewelleryPlanRepository _jewelleryPlanRepository =
      JewelleryPlanRepository();
  final RxList<GetAllOrnamentsResponseValue> codeList =
      <GetAllOrnamentsResponseValue>[].obs;

  final RxList<SetupDetailsTableData> controllers =
      <SetupDetailsTableData>[].obs;
  final RxList<String> totalHeadersValue = <String>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final getCommoditiesTypesResponse =
      Rx<ApiResponse<List<GetCommoditiesResponse>>>(
        ApiResponse.initial("Initial"),
      );
  final RxList<GetCommoditiesResponse> commodityTypes =
      <GetCommoditiesResponse>[].obs;

  final setupDigitalCoinResponse = Rx<ApiResponse<SetupDigitalCoinRequest>>(
    ApiResponse.initial("Initial"),
  );

  final RxSet<int> modifiedRows = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    addRow();
    getCommoditiesTypes();
  }

  void onToggleChanged(int index, bool value) {
    controllers[index].isActive.value = value;
    markRowAsModified(index);
  }

  void markRowAsModified(int index) {
    modifiedRows.add(index);
  }

  Future<void> saveAllChanges() async {
    try {
      List<String> errors = [];

      for (int index in modifiedRows) {
        if (index < commodityTypes.length) {
          try {
            final commodity = commodityTypes[index];
            // Parse VA value to int before sending
            int? vaValue = int.tryParse(controllers[index].va.text.trim());
            if (vaValue == null) {
              errors.add('Invalid VA value in row ${index + 1}');
              continue;
            }

            final request = SetupDigitalCoinRequest(
              status: controllers[index].isActive.value ? "ACTIVE" : "DISABLED",
              hsnCode: controllers[index].hsn.text,
              vaPercentage:
                  vaValue
                      .toString(), // Send as string but ensure it's a valid number
              invoicePrefix: controllers[index].invoice_prefix.text,
              description: controllers[index].item_description.text,
            );

            await _jewelleryPlanRepository.setupDigitalCoin(
              request,
              commodity.id!,
            );
          } catch (e) {
            errors.add('Error updating row ${index + 1}: ${e.toString()}');
            log(e.toString());
          }
        }
      }

      if (errors.isEmpty) {
        modifiedRows.clear();
        await getCommoditiesTypes();
        SidebarController sidebarController = Get.find();
        sidebarController.popBackSelectedWidget();
        showSuccessToast(message: "All changes saved successfully");
      } else {
        log("error");
        showErrorToast(message: errors.join('\n'));
      }
    } catch (e) {
      showErrorToast(message: e.toString());
    }
  }

  Future<void> getCommoditiesTypes() async {
    try {
      getCommoditiesTypesResponse.value = ApiResponse.loading("Loading");
      final response = await _jewelleryPlanRepository.getCommodities();
      getCommoditiesTypesResponse.value = ApiResponse.completed(response);
      commodityTypes.assignAll(response);

      // Clear existing controllers
      controllers.clear();

      // Populate rows from API response
      for (var commodity in response) {
        addRow(
          commodity: commodity.commodity ?? '',
          description: commodity.description ?? '',
          hsn: commodity.hsnCode ?? '',
          // Convert vaPercentage to string safely
          va: commodity.vaPercentage?.toString() ?? '',
          invoicePrefix: commodity.invoicePrefix ?? '',
          isActive: commodity.status == "ACTIVE",
        );
      }
    } catch (e) {
      getCommoditiesTypesResponse.value = ApiResponse.error(e.toString());
      log('Error fetching commodity types: $e');
    }
  }

  void addRow({
    String commodity = '',
    String description = '',
    String hsn = '',
    String va = '',
    String invoicePrefix = '',
    bool isActive = true,
  }) {
    controllers.add(
      SetupDetailsTableData(
        commodity: TextEditingController(text: commodity),
        item_description: TextEditingController(text: description),
        hsn: TextEditingController(text: hsn),
        va: TextEditingController(text: va),
        invoice_prefix: TextEditingController(text: invoicePrefix),
        isActive: isActive.obs,
      ),
    );

    // Add listeners to all controllers to track modifications
    final index = controllers.length - 1;
    controllers[index].commodity.addListener(() => markRowAsModified(index));
    controllers[index].item_description.addListener(
      () => markRowAsModified(index),
    );
    controllers[index].hsn.addListener(() => markRowAsModified(index));
    controllers[index].va.addListener(() => markRowAsModified(index));
    controllers[index].invoice_prefix.addListener(
      () => markRowAsModified(index),
    );

    // Add listener for isActive changes
    ever(controllers[index].isActive, (_) => markRowAsModified(index));
  }

  void addEmptyRow() {
    addRow();
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addEmptyRow();
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
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  void clearControllers() {
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.clear();
    addRow();
  }
}
