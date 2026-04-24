import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view_model/order_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EstimateDeliveryController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  // Text controller for the date field
  final deliveryDateController = TextEditingController();
  // Focus node for the date field
  final FocusNode dateFocusNode = FocusNode();

  // Selected date as an observable
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Set focus to date field when dialog opens
    dateFocusNode.requestFocus();
  }

  @override
  void onClose() {
    deliveryDateController.dispose();
    dateFocusNode.dispose();
    super.onClose();
  }

  // Initialize with existing date if available
  void initWithDate(String? estimateDate) {
    if (estimateDate != null && estimateDate != "-") {
      try {
        // Parse the date string and set it as the selected date
        // Assuming the format is yyyy-MM-dd
        final DateTime parsedDate = DateTime.parse(estimateDate);
        selectedDate.value = parsedDate;
        deliveryDateController.text = formatDateForDisplay(parsedDate);
      } catch (e) {
        log("Error parsing date: $e");
        // If date parsing fails, leave the field empty
        deliveryDateController.clear();
      }
    } else {
      // Set today's date as default if no date is provided
      selectedDate.value = DateTime.now();
      deliveryDateController.text = formatDateForDisplay(DateTime.now());
    }
  }

  // Format date for display in text field
  String formatDateForDisplay(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Open date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? now,
      firstDate: now, // Can't select dates in the past for delivery estimate
      lastDate: DateTime(
        now.year + 2,
      ), // Allow selection up to 2 years in the future
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      deliveryDateController.text = formatDateForDisplay(picked);
    }
  }

  // Update the estimated delivery date
  Future<void> updateEstimatedDelivery(String orderId) async {
    if (selectedDate.value == null) {
      showErrorToast(message: 'Please select a delivery date');
      return;
    }

    isLoading.value = true;
    try {
      // Call the API to update the estimated delivery date
      await estimationRepository.updateOrderEstimationDate(
        id: orderId,
        estimation_date: formatDateForDisplay(selectedDate.value!),
      );

      showSuccessToast(message: 'Estimated delivery date updated successfully');
      OrderListingViewModel orderListingViewModel = Get.find();
      orderListingViewModel.getOrdersListing(resetList: true);
      Get.back();
    } catch (e) {
      log("Error updating estimated delivery date: $e");
      showErrorToast(
        message: 'Failed to update estimated delivery date: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
