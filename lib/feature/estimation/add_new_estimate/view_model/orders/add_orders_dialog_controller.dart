import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_orders_by_order_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AddOrdersDialogController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final EstimationRepository _estimationRepository = EstimationRepository();
  final orderNumberController = TextEditingController();

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isFetchingDetails = false.obs;

  // Track total advance paid across all bookings
  final totalAdvancePaid = 0.0.obs;

  // Store multiple advance bookings
  final selectedOrders = <OrdersByOrderNumberResponse>[].obs;
  final getOrdersByOrderNumberResponse =
      Rx<ApiResponse<OrdersByOrderNumberResponse>>(
        ApiResponse.initial("Initial"),
      );

  @override
  void onClose() {
    orderNumberController.dispose();
    super.onClose();
  }

  void clearOrderDetails() {
    getOrdersByOrderNumberResponse.value = ApiResponse.initial("Initial");
    orderNumberController.clear();
  }

  Future<void> fetchOrdersByOrderNumber() async {
    final searchText = orderNumberController.text.trim();
    if (searchText.isEmpty) return;

    try {
      isFetchingDetails.value = true;
      getOrdersByOrderNumberResponse.value = ApiResponse.loading("Loading");

      final response = await _estimationRepository.getOrderByOrderNumber(
        searchText,
      );

      // if (response. ?? true) {
      //   getOrdersByOrderNumberResponse.value =
      //       ApiResponse.error("No booking details found");
      //   showErrorToast(message: "No booking details found");
      //   return;
      // }

      // Check if booking is already selected
      if (selectedOrders.any((booking) => booking.id == response.id)) {
        showErrorToast(message: "This booking is already added");
        return;
      }

      getOrdersByOrderNumberResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Booking details fetched successfully");
    } catch (e) {
      log('Error fetching booking details: $e');
      getOrdersByOrderNumberResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch booking details");
    } finally {
      isFetchingDetails.value = false;
    }
  }

  void addOrder() {
    if (getOrdersByOrderNumberResponse.value.status != Status.COMPLETED) return;

    final booking = getOrdersByOrderNumberResponse.value.data;
    if (booking == null) return;

    selectedOrders.add(booking);
    updateTotalAdvancePaid();

    // Clear the search field and response
    orderNumberController.clear();
    getOrdersByOrderNumberResponse.value = ApiResponse.initial("Initial");
  }

  void removeAdvanceBooking(OrdersByOrderNumberResponse booking) {
    selectedOrders.remove(booking);
    updateTotalAdvancePaid();
  }

  void updateTotalAdvancePaid() {
    double total = 0;
    for (var booking in selectedOrders) {
      double? amount = double.tryParse(
        booking.paymentDetails?.firstOrNull?.receivedAmount ?? "0",
      );
      total += amount ?? 0;
    }
    totalAdvancePaid.value = total;
  }

  Future<void> submitOrder() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedOrders.isEmpty) {
      showErrorToast(message: "Please add at least one booking");
      return;
    }

    try {
      isLoading.value = true;
      Get.back();
      showSuccessToast(message: "Bookings added successfully");
    } catch (e) {
      log('Error submitting booking: $e');
      showErrorToast(message: "Failed to save booking");
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    selectedOrders.clear();
    getOrdersByOrderNumberResponse.value = ApiResponse.initial("initial");
    orderNumberController.clear();
    totalAdvancePaid.value = 0;
    update();
  }
}
