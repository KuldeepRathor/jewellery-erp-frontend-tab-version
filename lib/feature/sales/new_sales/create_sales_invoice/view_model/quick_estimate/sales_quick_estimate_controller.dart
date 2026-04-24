import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesQuickEstimateController extends GetxController {
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
    } catch (e, s) {
      log("Error in fetchEstimateByEstimateNumber: $e\n$s");
      getEstimateByEstimationNumberResponse.value = ApiResponse.error(
        e.toString(),
      );
      showErrorToast(message: "Failed to fetch estimate details");
    }
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
    final CreateSalesItemDetailsController controller =
        Get.find<CreateSalesItemDetailsController>();

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
        Get.back();
      }
    }
  }
}
