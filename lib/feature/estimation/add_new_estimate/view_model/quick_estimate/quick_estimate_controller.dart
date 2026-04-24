import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/old_gold/old_gold_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class QuickEstimateController extends GetxController {
  final EstimationRepository _estimationRepository = EstimationRepository();
  final GlobalKey<FormState> quickEstimateFormKey = GlobalKey<FormState>();
  final estimateNumberTextController = TextEditingController();
  final getEstimateByEstimationNumberResponse =
      Rx<ApiResponse<GetSaleByEstimateResponse>>(
        ApiResponse.initial('Empty data'),
      );

  void clearControllers() {
    estimateNumberTextController.text = "";
    getEstimateByEstimationNumberResponse.value = ApiResponse.initial(
      "Empty Data",
    );
    clearSelection();
  }

  void handleQuickEstimateDoneWithOldGold() {
    final EstimationItemDetailsController controller =
        Get.find<EstimationItemDetailsController>();
    final OldGoldController oldGoldController = Get.find<OldGoldController>();

    if (quickEstimateFormKey.currentState!.validate()) {
      final response = getEstimateByEstimationNumberResponse.value;
      if (response.data != null) {
        // Handle line items
        if (response.data!.lineItems != null && selectedItems.isNotEmpty) {
          controller.handleQuickEstimateDone(
            lineItems: response.data!.lineItems!,
            selectedItems: selectedItems,
            isItemAvailable: isItemAvailable,
          );
        }

        // Handle old gold data
        if (response.data!.oldGolds != null &&
            response.data!.oldGolds!.isNotEmpty) {
          populateOldGoldData(oldGoldController, response.data!.oldGolds!);
        }

        // Clear selection and close dialog
        clearSelection();
        clearControllers();
        Get.back();
      }
    }
  }

  void populateOldGoldData(
    OldGoldController oldGoldController,
    List<OldGold> oldGolds,
  ) {
    // Clear existing old gold entries
    oldGoldController.clearTextController();

    // Add each old gold item
    for (var oldGold in oldGolds) {
      // Add a new row if needed
      if (oldGoldController.controllers.isEmpty ||
          oldGoldController.controllers.last.code.text.isNotEmpty) {
        oldGoldController.addRow();
      }

      final currentIndex = oldGoldController.controllers.length - 1;
      final controller = oldGoldController.controllers[currentIndex];

      // Populate the controller with old gold data
      controller.code.text = oldGold.code ?? '';
      controller.description.text = oldGold.description ?? '';
      controller.pcs.text = oldGold.pieces?.toString() ?? '';
      controller.gross_wtt.text = oldGold.grossWeight ?? '';
      controller.net_wtt.text = oldGold.netWeight ?? '';
      controller.less.text = oldGold.less ?? '0';
      controller.purity.text = oldGold.purityType ?? '100';
      controller.ornamentId = oldGold.ornamentId;
      controller.rate.text = oldGold.rate ?? '';
      controller.amount.text = oldGold.amount ?? '';
      controller.round_off.text = oldGold.roundOff ?? '0';
      controller.total_amount.text = oldGold.total ?? '0';

      // Set ornament name if available
      if (oldGold.ornamentName != null) {
        // You may need to set this in a dropdown or text field depending on your UI
        // controller.ornamentName = oldGold.ornamentName;
      }
    }

    // Update totals
    oldGoldController.updateTotals();
  }

  Future<void> fetchEstimateByEstimateNumber() async {
    final estimateNumber = estimateNumberTextController.text;

    if (estimateNumber.isEmpty) {
      getEstimateByEstimationNumberResponse.value = ApiResponse.error(
        "Please enter a valid estimate number",
      );
      showErrorToast(message: "Please enter a valid estimate number");
      return;
    }

    try {
      getEstimateByEstimationNumberResponse.value = ApiResponse.loading(
        "Loading",
      );

      final response = await _estimationRepository.getSaleByEstimationNumber(
        estimateNumber: estimateNumber,
      );

      getEstimateByEstimationNumberResponse.value = ApiResponse.completed(
        response,
      );

      // Automatically populate the data after successful fetch
      _autoPopulateEstimateData(response);
    } catch (e, s) {
      log("Error in fetchEstimateByEstimateNumber: $e\n$s");
      getEstimateByEstimationNumberResponse.value = ApiResponse.error(
        e.toString(),
      );
      showErrorToast(message: "Failed to fetch estimate details");
    }
  }

  // New method to automatically populate estimate data
  void _autoPopulateEstimateData(GetSaleByEstimateResponse response) {
    final EstimationItemDetailsController controller =
        Get.find<EstimationItemDetailsController>();
    final OldGoldController oldGoldController = Get.find<OldGoldController>();

    // Auto-select all available items
    if (response.lineItems != null && response.lineItems!.isNotEmpty) {
      selectedItems.clear();
      response.lineItems!.asMap().forEach((index, item) {
        if (item.taggingDetails?.status?.toLowerCase() == "available") {
          selectedItems.add(index);
        }
      });

      // Populate line items if any are available
      if (selectedItems.isNotEmpty) {
        controller.handleQuickEstimateDone(
          lineItems: response.lineItems!,
          selectedItems: selectedItems,
          isItemAvailable: isItemAvailable,
        );
        showSuccessToast(message: "Estimate items populated successfully!");
      } else {
        showErrorToast(message: "No available items found in the estimate");
      }
    }

    // Handle old gold data
    if (response.oldGolds != null && response.oldGolds!.isNotEmpty) {
      populateOldGoldData(oldGoldController, response.oldGolds!);
    }

    // Clear and close dialog
    clearSelection();
    clearControllers();
    Get.back();
  }

  final RxSet<int> selectedItems = <int>{}.obs;

  void selectAllItems() {
    final response = getEstimateByEstimationNumberResponse.value;
    if (response.data?.lineItems != null) {
      selectedItems.clear();

      // Only select items with "Available" status
      response.data!.lineItems!.asMap().forEach((index, item) {
        if (item.taggingDetails?.status?.toLowerCase() == "available") {
          selectedItems.add(index);
        }
      });

      // Refresh the UI
      selectedItems.refresh();
    }
  }

  void clearSelection() {
    selectedItems.clear();
    // Refresh the UI
    selectedItems.refresh();
  }

  void toggleItemSelection(int index) {
    final response = getEstimateByEstimationNumberResponse.value;
    if (response.data?.lineItems != null) {
      final item = response.data!.lineItems![index];
      // Only allow toggling if the item is available
      if (item.taggingDetails?.status?.toLowerCase() == "available") {
        if (selectedItems.contains(index)) {
          selectedItems.remove(index);
        } else {
          selectedItems.add(index);
        }
        // Refresh the UI
        selectedItems.refresh();
      }
    }
  }

  bool isItemSelected(int index) {
    return selectedItems.contains(index);
  }

  bool isItemAvailable(int index) {
    final response = getEstimateByEstimationNumberResponse.value;
    if (response.data?.lineItems != null &&
        index < response.data!.lineItems!.length) {
      final item = response.data!.lineItems![index];
      return item.taggingDetails?.status?.toLowerCase() == "available";
    }
    return false;
  }

  void handleQuickEstimateDone() {
    final EstimationItemDetailsController controller =
        Get.find<EstimationItemDetailsController>();

    if (quickEstimateFormKey.currentState!.validate()) {
      final response = getEstimateByEstimationNumberResponse.value;
      if (response.data?.lineItems != null && selectedItems.isNotEmpty) {
        controller.handleQuickEstimateDone(
          lineItems: response.data!.lineItems!,
          selectedItems: selectedItems,
          isItemAvailable: isItemAvailable,
        );

        // Clear selection and close dialog
        clearSelection();

        clearControllers();
        Get.back();
      }
    }
  }
}
