import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_advance_booking_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/otp_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesAdvanceBookingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final EstimationRepository _estimationRepository = EstimationRepository();
  final bookingDetailsController = TextEditingController();

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isFetchingDetails = false.obs;

  // Track total advance paid across all bookings
  final totalAdvancePaid = 0.0.obs;

  // Store multiple advance bookings
  final selectedAdvanceBookings = <AdvanceBookingResult>[].obs;
  final getAdvanceBookingResponse = Rx<ApiResponse<GetAdvanceBookingResponse>>(
    ApiResponse.initial("Initial"),
  );
  // @override
  // void onInit() {
  //   super.onInit();

  //   ever(
  //     selectedAdvanceBookings,
  //     (callback) {
  //       final SalesPaymentDetailsController salesPaymentDetailsController =
  //           Get.find<SalesPaymentDetailsController>();
  //       salesPaymentDetailsController.calculateGstvalues();
  //     },
  //   );
  // }

  @override
  void onClose() {
    bookingDetailsController.dispose();
    super.onClose();
  }

  void clearBookingDetails() {
    getAdvanceBookingResponse.value = ApiResponse.initial("Initial");
    bookingDetailsController.clear();
  }

  Future<void> fetchCustomerDetails({String? query}) async {
    final searchText = query ?? bookingDetailsController.text.trim();
    log("The search text will be $searchText");
    if (searchText.isEmpty) return;

    try {
      isFetchingDetails.value = true;
      getAdvanceBookingResponse.value = ApiResponse.loading("Loading");

      final response = await _estimationRepository.getAdvanceBooking(
        code: searchText.toUpperCase().startsWith('ADV') ? searchText : null,
        mobileNumber:
            !searchText.toUpperCase().startsWith('ADV') ? searchText : null,
      );

      if (response.results?.isEmpty ?? true) {
        getAdvanceBookingResponse.value = ApiResponse.error(
          "No booking details found",
        );
        showErrorToast(message: "No booking details found");
        return;
      }

      // Check if booking is already selected
      if (selectedAdvanceBookings.any(
        (booking) => booking.bookingId == response.results?.first.bookingId,
      )) {
        showErrorToast(message: "This booking is already added");
        return;
      }

      getAdvanceBookingResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Booking details fetched successfully");
    } catch (e) {
      log('Error fetching booking details: $e');
      getAdvanceBookingResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch booking details $searchText");
    } finally {
      isFetchingDetails.value = false;
    }
  }

  void addAdvanceBooking() {
    if (getAdvanceBookingResponse.value.status != Status.COMPLETED) return;

    final booking = getAdvanceBookingResponse.value.data?.results?.first;
    if (booking == null) return;

    selectedAdvanceBookings.add(booking);
    updateTotalAdvancePaid();

    // Clear the search field and response
    bookingDetailsController.clear();
    getAdvanceBookingResponse.value = ApiResponse.initial("Initial");
  }

  void removeAdvanceBooking(AdvanceBookingResult booking) {
    selectedAdvanceBookings.remove(booking);
    updateTotalAdvancePaid();
  }

  void updateTotalAdvancePaid() {
    double total = 0;
    for (var booking in selectedAdvanceBookings) {
      total += booking.cost ?? 0;
    }
    totalAdvancePaid.value = total;
  }

  Future<void> submitBooking() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedAdvanceBookings.isEmpty) {
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
    selectedAdvanceBookings.clear();
    getAdvanceBookingResponse.value = ApiResponse.initial("initial");
    bookingDetailsController.clear();
    totalAdvancePaid.value = 0;
    update();
  }

  Future<void> prefillAdvanceBookingDetails({
    required List<AdvanceBookingDetail>? advanceBookingDetails,
  }) async {
    for (var element in advanceBookingDetails ?? <AdvanceBookingDetail>[]) {
      if (element.bookingId != null) {
        await fetchCustomerDetails(query: element.bookingId);
        addAdvanceBooking();
      }
    }
  }

  Future<void> showCustomReusableOtpDialog({
    required AdvanceBookingResult booking,
  }) async {
    // Send Otp
    Get.dialog(
      CustomReusableOtpDialog(
        otpLength: 4,
        title: 'Enter OTP',
        message:
            'Please enter the verification code sent to your mobile number',
        onResendOtp: () {
          // Send Otp
        },
        onSubmit: (otpValue) {
          booking.otp = otpValue;
          Get.back();
        },
        showResendButton: true,
        resendAfter: const Duration(seconds: 60),
      ),
      barrierDismissible: false,
    );
  }
}
