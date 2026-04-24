import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view_model/webstore_orders_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class WebstoreOrdersCancelledDialogController extends GetxController {
  // Text controllers for form fields
  final TextEditingController cancelDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController refundAmountController = TextEditingController();
  final TextEditingController refundIdController = TextEditingController();
  final TextEditingController refundDateController = TextEditingController();

  final FocusNode cancelDateFocusNode = FocusNode();

  // Form validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Set default dates to today
    final today = DateFormat('dd / MM / yyyy').format(DateTime.now());
    cancelDateController.text = today;
    refundDateController.text = today;
  }

  @override
  void onClose() {
    cancelDateController.dispose();
    reasonController.dispose();
    refundAmountController.dispose();
    refundIdController.dispose();
    refundDateController.dispose();
    super.onClose();
  }

  // Date picker function
  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF28328B), // primaryColor
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('dd / MM / yyyy').format(picked);
    }
  }

  // Form validation methods
  String? validateCancelDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter cancel date';
    }
    return null;
  }

  String? validateReason(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter reason';
    }
    return null;
  }

  String? validateRefundAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter refund amount';
    }

    // Check if it's a valid number
    if (double.tryParse(value) == null) {
      return 'Please enter a valid amount';
    }

    return null;
  }

  String? validateRefundId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter refund ID';
    }
    return null;
  }

  String? validateRefundDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter refund date';
    }
    return null;
  }

  // Save function
  Future<void> saveCancelDetails({String? selectedOrderId}) async {
    final WebStoreOrdersViewModel webStoreOrdersViewModel =
        Get.put<WebStoreOrdersViewModel>(WebStoreOrdersViewModel());
    if (formKey.currentState!.validate()) {
      // Implement save logic - API call would go here
      final result = await webStoreOrdersViewModel.onWebStoreStatusChange(
        selectedOrderId: selectedOrderId,
        status: "5",
        cancelData: {
          "cancel_time": convertToFormattedDate(cancelDateController.text),
          "refund_time": convertToFormattedDate(refundDateController.text),
          "refund_amount": refundAmountController.text,
          "refund_id": refundIdController.text,
          "reason": reasonController.text,
        },
      );
      // For now, just close the dialog and show success message
      if (result != null && result) {
        Get.back();
        Get.snackbar(
          'Success',
          'Cancellation processed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    }
  }
}
