import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view_model/create_repair_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view_model/create_repair_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';

class CreateRepairViewModel extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();

  final CreateRepairPartyDetailsController _partyDetailsController =
      Get.put<CreateRepairPartyDetailsController>(
        CreateRepairPartyDetailsController(),
      );
  final CreateRepairItemDetailsController _itemDetailsController =
      Get.put<CreateRepairItemDetailsController>(
        CreateRepairItemDetailsController(),
      );

  final repairTakenByController = TextEditingController();
  final repairDateController = TextEditingController();
  final RxBool isVerified = false.obs;

  final employeeSearchController = TextEditingController().obs;
  final selectedEmployee = Rx<GetEmployeesValue?>(null);

  // Focus nodes
  final FocusNode partyDetailsFocusNode = FocusNode();
  final FocusNode commodityTypeFocusNode = FocusNode();
  final FocusNode repairDateFocusNode = FocusNode();
  final FocusNode employeeFocusNode = FocusNode();
  final FocusNode bookingTypeFocusNode = FocusNode();

  final selectedCommodity = 'Gold'.obs;
  final commodityTypes = ['Gold', 'Silver', 'Platinum'];
  void onCommodityChanged(String? newValue) {
    if (newValue != null) {
      selectedCommodity.value = newValue;
      repairDateFocusNode.requestFocus();
    }
  }

  final selectedBooking = 'Rate Fix'.obs;
  final bookingTypes = ['Rate Fix', 'Rate Unfix'];
  void onBookingChanged(String? newValue) {
    if (newValue != null) {
      selectedBooking.value = newValue;
      if (Get.isRegistered<CreateRepairItemDetailsController>()) {
        final itemDetailsController =
            Get.find<CreateRepairItemDetailsController>();
        itemDetailsController.requestFirstFocus();
      }
    }
  }

  final getEmployeesResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Add RxList for employee options
  final RxList<GetEmployeesValue> employeeOptions = <GetEmployeesValue>[].obs;

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
    bookingTypeFocusNode.requestFocus();
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      employeeFocusNode.requestFocus();
    }
  }

  @override
  void onInit() {
    log("Commodity Type Listing");
    searchEmployees('');
    setDefaultDate();
    super.onInit();
  }

  void setDefaultDate() {
    final today = DateTime.now();
    repairDateController.text = "${today.year}-${today.month}-${today.day}";
  }

  @override
  void dispose() {
    repairTakenByController.dispose();
    // Dispose focus nodes
    partyDetailsFocusNode.dispose();
    commodityTypeFocusNode.dispose();
    repairDateFocusNode.dispose();
    employeeFocusNode.dispose();
    bookingTypeFocusNode.dispose();
    super.dispose();
  }

  void clearAllControllers() {
    // Clear this controller's fields
    repairTakenByController.clear();
    repairDateController.clear();
    selectedEmployee.value = null;
    selectedCommodity.value = 'Gold';
    selectedBooking.value = 'Rate Fix';
    employeeSearchController.value.clear();
    isVerified.value = false;

    // Clear party details
    _partyDetailsController.clearControllers();

    // Clear item details
    _itemDetailsController.clearControllers();

    // Reset date
    setDefaultDate();
  }
}
