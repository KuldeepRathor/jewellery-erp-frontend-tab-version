import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelBookingController extends GetxController {
  final cancelDateController = TextEditingController();
  final paymentDateController = TextEditingController();

  @override
  void onClose() {
    cancelDateController.dispose();
    paymentDateController.dispose();
    super.onClose();
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  void clearControllers() {
    cancelDateController.text = "";
    paymentDateController.text = "";
  }
}
