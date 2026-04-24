import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class ApprovalIssueDetailsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final RxString approvalIssueNumber = ''.obs;
  final approvalDateController = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchApprovalIssueNumber();
    setDefaultDate();
  }

  @override
  void onClose() {
    approvalDateController.dispose(); // Dispose controller when done
    super.onClose();
  }

  void setDefaultDate() {
    final today = DateTime.now();
    approvalDateController.text = "${today.day}-${today.month}-${today.year}";
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

  Future<void> fetchApprovalIssueNumber() async {
    try {
      final recordNumber = await _inventoryRepository.approvalIssueNumber();
      approvalIssueNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching tagging record number: $e');
      approvalIssueNumber.value = 'Error';
    }
  }

  bool validateBillDetails() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  void clearControllers() {
    setDefaultDate();
    fetchApprovalIssueNumber();
  }
}
