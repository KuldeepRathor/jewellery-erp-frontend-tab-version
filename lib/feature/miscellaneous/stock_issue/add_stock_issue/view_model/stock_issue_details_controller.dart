import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/stock_issue_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';

class StockIssueDetailsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final employeeSearchController = TextEditingController().obs;
  final selectedEmployee = Rx<GetEmployeesValue?>(null);

  final RxString stockIssueNumber = ''.obs;
  final approvalDateController = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxList<String> reasonItems =
      <String>['Job Work', 'Repair', "Other", 'Melting'].obs;
  final selectedReason = Rx<String>('');

  final getEmployeesResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );

  void onReasonChanged(String? value) {
    if (value != null) {
      selectedReason.value = value;
    }
  }

  final reasonSearchController = TextEditingController().obs;
  final reasonFocusNode = FocusNode();
  final RxList<String> reasonOptions = <String>[].obs;
  final StockIssueItemDetailsController itemDetailsController =
      Get.put<StockIssueItemDetailsController>(
        StockIssueItemDetailsController(),
      );
  void moveToItemDetails() {
    // Request focus on the item code field (index 1) in item details
    if (itemDetailsController.controllers.isNotEmpty) {
      itemDetailsController.controllers.first.tableFocusNodes[0].requestFocus();
      itemDetailsController.currentRowIndex.value = 0;
      itemDetailsController.currentColIndex.value =
          0; // Changed to 1 for item code field
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchStockIssueNumber();
    setDefaultDate();
    reasonOptions.value = reasonItems;
    reasonSearchController.value.text = selectedReason.value;
  }

  void setDefaultDate() {
    final today = DateTime.now();
    approvalDateController.text = "${today.day}-${today.month}-${today.year}";
  }

  Future<List<String>> searchReasons(String query) async {
    if (query.isEmpty) {
      return reasonItems;
    }
    return reasonItems
        .where((reason) => reason.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void setSelectedReason(String reason) async {
    selectedReason.value = reason;

    reasonSearchController.value.text = reason;

    await Future.delayed(const Duration(milliseconds: 150));
    moveToItemDetails();
  }

  Future<void> searchEmployees(String query) async {
    try {
      getEmployeesResponse.value = ApiResponse.loading("Searching employees");
      final response = await _organizationRepository.getEmployees(query: query);
      getEmployeesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getEmployeesResponse.value = ApiResponse.error(e.toString());
    }
  }

  void setSelectedEmployee(GetEmployeesValue employee) {
    selectedEmployee.value = employee;
    employeeSearchController.value.text =
        '${employee.firstName} ${employee.lastName}';
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

  Future<void> fetchStockIssueNumber() async {
    try {
      final recordNumber = await _inventoryRepository.stockIssueNumber();
      stockIssueNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching tagging record number: $e');
      stockIssueNumber.value = 'Error';
    }
  }

  bool validateBillDetails() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    approvalDateController.dispose();
    employeeSearchController.value.dispose();
    reasonSearchController.value.dispose();
    reasonFocusNode.dispose();
    super.onClose();
  }

  void clearControllers() {
    approvalDateController.text = "";
    reasonSearchController.value.text = "";
    stockIssueNumber.value = "";
    setDefaultDate();
  }
}
