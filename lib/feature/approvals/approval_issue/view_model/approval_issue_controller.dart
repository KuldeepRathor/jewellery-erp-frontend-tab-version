import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/approval_issue_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view_model/approval_issue_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view_model/approval_issue_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ApprovalIssueController extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final selectedEmployee = Rx<GetEmployeesValue?>(null);
  final employeeFocusNode = FocusNode();
  final RxList<GetEmployeesValue> employeeOptions = <GetEmployeesValue>[].obs;

  final InventoryRepository _inventoryRepository = InventoryRepository();
  final PartyDetailsController _partyDetailsController = Get.find();
  final ApprovalIssueDetailsController _issueDetailsController = Get.find();
  final ApprovalIssueItemDetailsController _itemDetailsController = Get.put(
    ApprovalIssueItemDetailsController(),
  );

  final getEmployeesResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );

  final approverDropdownFocusNode = FocusNode();

  final debounce = Debouncer(milliseconds: 500);

  final employeeSearchController = TextEditingController().obs;

  final RxString remarks = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchEmployees('');
  }

  void onSearchChanged(String value) {
    debounce.run(() => searchEmployees(value));
  }

  final submitApprovalIssueResponse =
      Rx<ApiResponse<ApprovalIssueRecordRequest>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> submitApprovalIssueRecord() async {
    try {
      // Validate and clean up rows first
      bool isValid = await validateItemDetails();

      // Check if we have a valid party
      bool partySelected = _partyDetailsController.selectedParty.value != null;

      // Check if we have a valid approver
      bool approverSelected = selectedEmployee.value != null;

      if (!isValid) {
        showErrorToast(message: "Please add at least one valid item");
        return;
      }

      if (!partySelected) {
        showErrorToast(message: "Please select a party");
        return;
      }

      if (!approverSelected) {
        showErrorToast(message: "Please select an approver");
        return;
      }

      final approvalIssueRecordRequest = ApprovalIssueRecordRequest(
        partyId: _getPartyId(),
        partyType: _getPartyType(),
        approverId: selectedEmployee.value?.id,
        approvalDate:
            _issueDetailsController.selectedDate.value ?? DateTime.now(),
        approvalIssueNumber: _issueDetailsController.approvalIssueNumber.value,
        remarks: remarks.value,
        lineItems: _getLineItems(),
      );

      await _inventoryRepository.submitApprovalIssueRecord(
        approvalIssueRecordRequest,
      );

      await _issueDetailsController.fetchApprovalIssueNumber();

      _partyDetailsController.clearControllers();
      _issueDetailsController.clearControllers();

      _itemDetailsController.clearControllers();
      clearControllers();

      showSuccessToast(message: 'Approval issue record submitted successfully');
    } catch (e) {
      showErrorToast(message: 'Failed to submit approval issue record: $e');
      log("$e");
    }
  }

  Future<bool> validateItemDetails() async {
    try {
      // Get the controllers list
      final controllers = _itemDetailsController.controllers;

      // Remove rows where both item_code and tag_no are empty (or all fields are empty)
      controllers.removeWhere(
        (element) =>
            element.item_code.text.isEmpty &&
            element.tag_no.text.isEmpty &&
            element.description.text.isEmpty &&
            element.pcs.text.isEmpty &&
            element.gwt.text.isEmpty &&
            element.nwt.text.isEmpty &&
            element.va.text.isEmpty &&
            element.mc.text.isEmpty &&
            element.stone.text.isEmpty &&
            element.hall_mark.text.isEmpty,
      );

      // Reset current indices to safe values
      _itemDetailsController.currentRowIndex.value =
          controllers.isEmpty ? 0 : controllers.length - 1;
      _itemDetailsController.currentColIndex.value = 0;

      // If no valid rows remain, show error and return false
      if (controllers.isEmpty) {
        return false;
      }

      // Quick validation of required fields in each row
      for (var row in controllers) {
        if (row.item_code.text.isEmpty || row.tag_no.text.isEmpty) {
          showErrorToast(message: "Item Code and Tag No. are required");
          return false;
        }
      }

      _itemDetailsController.updateTotals();
      return true;
    } catch (e, s) {
      log("Error in validateItemDetails: $e\n$s");
      showErrorToast(message: "An error occurred while validating the form");
      return false;
    }
  }

  String _getPartyId() {
    final selectedParty = _partyDetailsController.selectedParty.value;
    return selectedParty?.id ?? '';
  }

  String _getPartyType() {
    final selectedParty = _partyDetailsController.selectedParty.value;
    if (selectedParty is CustomerSearchValue) {
      return 'customer';
    } else if (selectedParty is VendorSearchValue) {
      return 'vendor';
    }
    return '';
  }

  List<LineItem> _getLineItems() {
    return _itemDetailsController.controllers.map((item) {
      return LineItem(
        taggingId: item.tagging_id,
        code: item.item_code.text,
        status: 'Pending', // Set appropriate status
        tag: item.tag_no.text,
        description: item.description.text,
        pieces: int.tryParse(item.pcs.text) ?? 0,
        grossWeight: item.gwt.text,
        netWeight: item.nwt.text,
        taggingVa: item.va.text,
        finalVa: item.va.text,
        taggingMc: item.mc.text,
        finalMc: item.mc.text,
        stoneCost: item.stone.text,
        hallMark:
            item.hall_mark.text.trim().isEmpty
                ? null
                : item.hall_mark.text.trim(),
        salesAmount: "0.0",
        totalAmount: "0.0",
        discount: "0.0",
      );
    }).toList();
  }

  void clearControllers() {
    selectedEmployee.value = null;
    employeeSearchController.value.clear();
    _partyDetailsController.clearControllers();
    _issueDetailsController.clearControllers();
    _itemDetailsController.clearControllers();
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
  }

  @override
  void onClose() {
    approverDropdownFocusNode.dispose();
    employeeSearchController.value.dispose();
    employeeFocusNode.dispose();
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
