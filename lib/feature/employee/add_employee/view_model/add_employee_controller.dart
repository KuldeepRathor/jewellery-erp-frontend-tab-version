import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/employee/add_employee/model/add_employees_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/employee/employee_listing/view_model/employee_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AddEmployeeController extends GetxController {
  final VendorRepository addVendorRepository = VendorRepository();
  final OrganizationRepository organizationRepository =
      OrganizationRepository();
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();

  // Observable variables for UI state
  final isLoading = false.obs;
  final detailsFetched = false.obs;
  final RxBool isPhoneAvailable = true.obs;
  final RxBool isCheckingPhone = false.obs;

  // API Response observable
  final addEmployeeResponse = Rx<ApiResponse<AddEmployeesRequest>>(
    ApiResponse.initial("Initial"),
  );

  // Validation patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(r'^\d{10}$');

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  Future<void> submitEmployeeDetails() async {
    try {
      if (!formKey.currentState!.validate()) {
        showErrorToast(message: "Please check the data");
        return;
      }

      addEmployeeResponse.value = ApiResponse.loading("Adding employee...");

      final AddEmployeesRequest employeeDataRequest = AddEmployeesRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email:
            emailAddressController.text.isEmpty
                ? null
                : emailAddressController.text,
        phoneNumber:
            phoneNumberController.text.isEmpty
                ? null
                : phoneNumberController.text,
        phoneCountryCode: "+91",
      );

      final response = await organizationRepository.addEmployee(
        employeeDataRequest,
      );
      addEmployeeResponse.value = ApiResponse.completed(response);

      // Close the dialog and show success message
      Get.back();
      showSuccessToast(message: "Employee added successfully");
      EmployeeListingController employeeListingController = Get.find();
      employeeListingController.getEmployeeListingDetails(resetList: true);

      // Reset the form
      resetFields();
    } catch (e) {
      log('Error adding employee: $e');
      addEmployeeResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to add employee");
    }
  }

  void resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    phoneNumberController.clear();
    emailAddressController.clear();
    addEmployeeResponse.value = ApiResponse.initial("Initial");
  }

  @override
  void onClose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    emailAddressController.dispose();
    super.onClose();
  }
}
