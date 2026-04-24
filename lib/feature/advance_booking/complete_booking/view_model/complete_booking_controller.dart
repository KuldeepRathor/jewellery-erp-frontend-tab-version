// booking_completion_controller.dart
import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/complete_booking/model/complete_booking_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CompleteBookingController extends GetxController {
  final TextEditingController completionDateController =
      TextEditingController();
  final TextEditingController invoiceController = TextEditingController();
  final JewelleryPlanRepository _repository = JewelleryPlanRepository();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final String bookingId;
  CompleteBookingController({required this.bookingId});
  @override
  void onInit() {
    super.onInit();
    log("Initialized with bookingId: $bookingId");
  }

  @override
  void onClose() {
    completionDateController.dispose();
    invoiceController.dispose();
    super.onClose();
  }

  Future<void> saveBookingCompletion() async {
    try {
      if (!_validateInputs()) {
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      // Create request object
      final request = CompleteBookingRequest(
        bookingId: int.parse(bookingId),
        completionDate: DateTime.parse(completionDateController.text),
        invoice: invoiceController.text,
      );

      // Make API call
      await _repository.completeBooking(request);

      Get.back(); // Close the popup
      showSuccessToast(message: "Booking has been completed successfully");
      // _showSuccessDialog();
    } catch (e) {
      showErrorToast(message: e.toString());
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (completionDateController.text.isEmpty) {
      errorMessage.value = 'Please enter completion date';
      return false;
    }
    if (invoiceController.text.isEmpty) {
      errorMessage.value = 'Please enter invoice number';
      return false;
    }
    return true;
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      completionDateController.text = picked.toString().split(' ')[0];
    }
  }

  // void _showSuccessDialog() {
  //   Get.dialog(
  //     Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  //       child: Container(
  //         padding: const EdgeInsets.all(15),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8),
  //           color: Colors.white,
  //         ),
  //         width: Get.width * 0.3,
  //         child: const Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(
  //               Icons.check_circle_outline,
  //               color: Colors.green,
  //               size: 50,
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               'Booking has been completed successfully',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //               maxLines: 2,
  //             ),
  //             SizedBox(height: 20),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
