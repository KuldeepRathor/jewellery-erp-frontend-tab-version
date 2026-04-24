import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_repository.dart';

class ServiceVendorBillDetailsWidgetController extends GetxController {
  final invoiceNoController = TextEditingController();
  final invoiceCreatedController = TextEditingController();
  final invoiceReceivedController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode invoiceNumberFocusNode = FocusNode();
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  final RxString invoiceNumber = ''.obs;
  @override
  void onReady() {
    super.onReady();
    setDefaultDates();
  }

  @override
  void onClose() {
    invoiceNoController.dispose();
    invoiceCreatedController.dispose();
    invoiceReceivedController.dispose();
    invoiceNumberFocusNode.dispose();
    setDefaultDates();
    super.onClose();
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  void setDefaultDates() {
    final today = DateTime.now();
    final formattedDate = formatDate(today);
    invoiceCreatedController.text = formattedDate;
    invoiceReceivedController.text = formattedDate;
  }

  Future<void> fetchNextInvoiceNumber({required String invoiceType}) async {
    try {
      final nextInvoiceNumber = await _purchaseRepository.getNextInvoiceNumber(
        invoiceType: invoiceType,
      );
      invoiceNumber.value = nextInvoiceNumber;
      // invoiceNoController.text = nextInvoiceNumber;
    } catch (e) {
      log('Error fetching next invoice number: $e');
    }
  }

  bool validateBillDetails() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  void clearControllers() {
    invoiceNoController.text = "";
    invoiceCreatedController.text = "";
    invoiceReceivedController.text = "";
  }
}
