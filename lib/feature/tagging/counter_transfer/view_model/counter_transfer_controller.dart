import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view_model/approval_issue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/counter/counter_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';

class CounterTransferController extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();

  final InventoryRepository inventoryRepository = InventoryRepository();
  final employeeSearchController = TextEditingController().obs;
  final selectedEmployee = Rx<GetEmployeesValue?>(null);
  final getEmployeesResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );

  // New counter-related variables
  final counterSearchController = TextEditingController().obs;
  final selectedCounter = Rx<CounterValue?>(null);
  final getCountersResponse = Rx<ApiResponse<CounterResponse>>(
    ApiResponse.initial("Initial"),
  );

  final FocusNode transerToFocusNode = FocusNode();
  final FocusNode transerByFocusNode = FocusNode();

  final debounce = Debouncer(milliseconds: 500);
  @override
  void onInit() {
    super.onInit();
    searchEmployees('');
    searchCounters('');
  }

  void onSearchChanged(String value) {
    debounce.run(() => searchEmployees(value));
  }

  void onCounterSearchChanged(String value) {
    debounce.run(() => searchCounters(value));
  }

  Future<void> searchCounters(String query) async {
    try {
      getCountersResponse.value = ApiResponse.loading("Searching counters");
      final response = await inventoryRepository.getCounterListing(
        query: query,
        limit: 1000,
      );
      getCountersResponse.value = ApiResponse.completed(response);
      update();

      transerToFocusNode.requestFocus();
      update();
    } catch (e) {
      getCountersResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> searchEmployees(String query) async {
    try {
      getEmployeesResponse.value = ApiResponse.loading("Searching employees");
      final response = await _organizationRepository.getEmployees(
        query: query,
        limit: 1000,
      );
      getEmployeesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getEmployeesResponse.value = ApiResponse.error(e.toString());
    }
  }

  void setSelectedCounter(CounterValue counter) {
    selectedCounter.value = counter;
    counterSearchController.value.text = counter.counterName ?? '';
  }

  void setSelectedEmployee(GetEmployeesValue employee) {
    selectedEmployee.value = employee;
    employeeSearchController.value.text =
        '${employee.firstName} ${employee.lastName}';
  }

  void resetValues() {
    // Reset text controllers
    employeeSearchController.value.clear();
    counterSearchController.value.clear();

    // Reset selected values
    selectedEmployee.value = null;
    selectedCounter.value = null;

    // // Reset API responses to initial state
    // getEmployeesResponse.value = ApiResponse.initial("Initial");
    // getCountersResponse.value = ApiResponse.initial("Initial");

    // // Re-fetch initial data
    // searchEmployees('');
    // searchCounters('');
  }
}
