import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view_model/webstore_orders_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class DeliveryDialogController extends GetxController {
  // Text controllers for form fields
  final TextEditingController deliveryDateController = TextEditingController();

  final FocusNode deliveryDateFocusNode = FocusNode();

  // Form validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Set default dates to today
    final today = DateFormat('dd / MM / yyyy').format(DateTime.now());
    deliveryDateController.text = today;
  }

  @override
  void onClose() {
    deliveryDateController.dispose();
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
  String? validateReturnDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter return date';
    }
    return null;
  }

  // Save function
  Future<void> saveReturnDetails({String? selectedOrderId}) async {
    final WebStoreOrdersViewModel webStoreOrdersViewModel =
        Get.put<WebStoreOrdersViewModel>(WebStoreOrdersViewModel());
    if (formKey.currentState!.validate()) {
      // Implement save logic - API call would go here
      final result = await webStoreOrdersViewModel.onWebStoreStatusChange(
        selectedOrderId: selectedOrderId,
        status: "3",
        deliveredData: {
          "time": convertToFormattedDate(deliveryDateController.text),
        },
      );
      // For now, just close the dialog and show success message
      if (result != null && result) {
        Get.back();
        Get.snackbar(
          'Success',
          'Delivery processed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    }
  }
}
