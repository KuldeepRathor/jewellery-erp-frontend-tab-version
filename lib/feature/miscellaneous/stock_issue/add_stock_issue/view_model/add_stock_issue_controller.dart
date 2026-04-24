import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/model/stock_issue_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/stock_issue_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/stock_issue_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AddStockIssueController extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final StockIssueDetailsController _issueDetailsController = Get.find();
  final StockIssueItemDetailsController _itemDetailsController = Get.put(
    StockIssueItemDetailsController(),
  );

  final employeeSearchController = TextEditingController().obs;
  final selectedEmployee = Rx<GetEmployeesValue?>(null);
  final getEmployeesResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );

  final Rx<StockIssueRecordRequest?> submittedStockIssue =
      Rx<StockIssueRecordRequest?>(null);

  final debounce = Debouncer(milliseconds: 500);

  final RxBool isSubmitting = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  final submitStockIssueResponse = Rx<ApiResponse<StockIssueRecordRequest>>(
    ApiResponse.initial("Initial"),
  );

  final employeeFocusNode = FocusNode();
  final RxList<GetEmployeesValue> employeeOptions = <GetEmployeesValue>[].obs;

  final RxString remarks = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchEmployees('');
  }

  void onSearchChanged(String value) {
    debounce.run(() => searchEmployees(value));
  }

  Future<void> submitStockIssueRecord() async {
    try {
      isSubmitting.value = true;
      errorMessage.value = null;

      final lineItems =
          _itemDetailsController.controllers
              .where((item) => item.id.isNotEmpty)
              .map(
                (item) => LineItem(
                  taggingLineItem: item.id,
                  pieces: int.tryParse(item.pcs.text),
                  grossWeight: double.tryParse(item.gwt.text),
                  netWeight: double.tryParse(item.nwt.text),
                  value: double.parse(item.salesAmount.text),
                ),
              )
              .toList();

      if (lineItems.isEmpty) {
        throw Exception('No valid line items found');
      }

      // Format the date as YYYY-MM-DD
      final formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(_issueDetailsController.selectedDate.value ?? DateTime.now());

      final request = StockIssueRecordRequest(
        issueDate: formattedDate,
        issuedBy: selectedEmployee.value!.id,
        reason: _issueDetailsController.selectedReason.value,
        remarks: remarks.value,
        lineItems: lineItems,
        // ornamentId: "",
      );

      await _inventoryRepository.submitStockIssueRecord(request);

      // Handle successful response
      _issueDetailsController.clearControllers();
      _itemDetailsController.clearControllers();
      _issueDetailsController.fetchStockIssueNumber();
      clearControllers();
      SidebarController sidebarController = Get.find();
      sidebarController.popBackSelectedWidget();
      showSuccessToast(message: 'Stock issue record submitted successfully');
    } catch (e) {
      errorMessage.value =
          'Failed to submit stock issue record: ${e.toString()}';
      showErrorToast(message: errorMessage.value!);
      log("$e");
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void dispose() {
    clearControllers();
    employeeFocusNode.dispose();
    super.dispose();
  }

  void clearControllers() {
    selectedEmployee.value = null;
    employeeSearchController.value.clear();
    _issueDetailsController.clearControllers();
    _itemDetailsController.clearControllers();
    submitStockIssueResponse.value = ApiResponse.initial("Initial");
  }

  Future<void> searchEmployees(String query) async {
    try {
      getEmployeesResponse.value = ApiResponse.loading("Searching employees");
      final response = await _organizationRepository.getEmployees(query: query);
      employeeOptions.value = (response.values ?? []);
      employeeOptions.refresh();
      getEmployeesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getEmployeesResponse.value = ApiResponse.error(e.toString());
    }
  }

  void setSelectedEmployee(GetEmployeesValue employee) {
    selectedEmployee.value = employee;
    employeeSearchController.value.text =
        '${employee.firstName} ${employee.lastName}';
    // _issueDetailsController.reasonFocusNode.requestFocus();
  }

  void clearSubmission() {
    submittedStockIssue.value = null;
  }

  @override
  void onClose() {
    employeeSearchController.value.dispose();
    super.onClose();
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
