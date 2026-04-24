import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_quick_old_gold_by_estimate_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/old_gold/old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/old_gold/old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class QuickOldGoldController extends GetxController {
  final EstimationRepository _estimationRepository = EstimationRepository();

  final GlobalKey<FormState> quickOldGoldFormKey = GlobalKey<FormState>();
  final estimateNumberController = TextEditingController();

  final getQuickOldGoldResponse =
      Rx<ApiResponse<GetQuickOldGoldByEstimateNumberResponse>>(
        ApiResponse.initial('Empty data'),
      );

  final selectedItems = <int>{}.obs;

  @override
  void onClose() {
    estimateNumberController.dispose();
    super.onClose();
  }

  void clearControllers() {
    estimateNumberController.text = "";
    getQuickOldGoldResponse.value = ApiResponse.initial("Empty Data");
    clearSelection();
  }

  Future<void> fetchQuickOldGold() async {
    final estimateNumber = estimateNumberController.text;

    if (estimateNumber.isEmpty) {
      getQuickOldGoldResponse.value = ApiResponse.error(
        "Please enter a valid estimate number",
      );
      showErrorToast(message: "Please enter a valid estimate number");
      return;
    }

    try {
      getQuickOldGoldResponse.value = ApiResponse.loading("Loading");

      final response = await _estimationRepository
          .getQuickOldGoldByEstimateNumber(estimateNumber: estimateNumber);

      getQuickOldGoldResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getQuickOldGoldResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch old gold details");
    }
  } // Status Check Helper Methods

  bool isItemReceived(int index) {
    final response = getQuickOldGoldResponse.value;

    if (response.data?.values != null &&
        index < response.data!.values!.length) {
      final item = response.data!.values![index];
      return item.isReceived == false;
    }

    return true;
  }

  void selectAllItems() {
    final response = getQuickOldGoldResponse.value;
    if (response.data?.values != null) {
      selectedItems.clear();
      // Only select items that are received
      response.data!.values!.asMap().forEach((index, item) {
        if (item.isReceived == false) {
          selectedItems.add(index);
        }
      });
      selectedItems.refresh();
    }
  }

  void clearSelection() {
    selectedItems.clear();
    selectedItems.refresh();
  }

  void toggleItemSelection(int index) {
    if (!isItemReceived(index)) {
      return; // Don't allow selection if item is not received
    }

    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
    selectedItems.refresh();
  }

  bool isItemSelected(int index) {
    return selectedItems.contains(index);
  }

  void handleDone() {
    if (quickOldGoldFormKey.currentState!.validate()) {
      final response = getQuickOldGoldResponse.value;
      if (response.data?.values != null && selectedItems.isNotEmpty) {
        final OldGoldController oldGoldController =
            Get.find<OldGoldController>();

        // Add only selected AND received items to the controller
        for (var index in selectedItems) {
          if (!isItemReceived(index)) continue;

          final oldGold = response.data!.values![index];
          final tableData = OldGoldDetailsTableData(
            // sn: (oldGoldController.controllers.length + 1).toString(),
            id: oldGold.id,
            code: TextEditingController(text: oldGold.code ?? ""),
            ornamentId: oldGold.ornamentId,
            description: TextEditingController(text: oldGold.description ?? ""),
            pcs: TextEditingController(text: oldGold.pieces?.toString() ?? ""),
            gross_wtt: TextEditingController(text: oldGold.grossWeight ?? ""),
            net_wtt: TextEditingController(text: oldGold.netWeight ?? ""),
            less: TextEditingController(text: oldGold.less ?? ""),
            purity: TextEditingController(text: oldGold.purityType ?? ""),
            rate: TextEditingController(text: oldGold.rate ?? ""),
            amount: TextEditingController(text: oldGold.amount ?? ""),
            round_off: TextEditingController(text: oldGold.roundOff ?? ""),
            total_amount: TextEditingController(text: oldGold.total ?? ""),
          );

          oldGoldController.controllers.insert(0, tableData);
        }

        // Update UI
        oldGoldController.updateTotals();
        oldGoldController.controllers.refresh();

        // Clear selection and close dialog
        clearSelection();
        Get.back();
      }
    }
  }
}
