import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_payments_detail_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';

class CreateOrderViewModel extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();

  final EstimationRepository _invoiceRepository = EstimationRepository();

  late PartyDetailsController partyDetailsController = Get.put(
    PartyDetailsController(),
  );

  final orderTakenByController = TextEditingController();
  final orderDateController = TextEditingController();
  final RxBool isVerified = false.obs;

  final RxBool RateFixMode = true.obs;

  void toggleFastMode() => RateFixMode.toggle();

  final notesController = TextEditingController();
  final RxBool hasNotes = false.obs;

  final employeeSearchController = TextEditingController().obs;
  final selectedEmployee = Rx<GetEmployeesValue?>(null);

  final FocusNode partyDetailsFocusNode = FocusNode();
  final FocusNode commodityTypeFocusNode = FocusNode();
  final FocusNode orderDateFocusNode = FocusNode();
  final FocusNode employeeFocusNode = FocusNode();
  final FocusNode bookingTypeFocusNode = FocusNode();

  final selectedCommodity = 'Gold'.obs;
  final commodityTypes = ['Gold', 'Silver', 'Platinum'];

  final RxString invoiceNumber = ''.obs;

  void onCommodityChanged(String? newValue) {
    if (newValue != null) {
      selectedCommodity.value = newValue;
    }
  }

  final selectedBooking = 'Rate Fix'.obs;
  final bookingTypes = ['Rate Fix', 'Rate Unfix'];
  void onBookingChanged(String? newValue) {
    if (newValue != null) {
      selectedBooking.value = newValue;

      if (Get.isRegistered<CreateOrderItemDetailsController>()) {
        final itemDetailsController =
            Get.find<CreateOrderItemDetailsController>();
        itemDetailsController.requestFirstFocus();
      }
    }
  }

  @override
  void dispose() {
    partyDetailsFocusNode.dispose();
    commodityTypeFocusNode.dispose();
    orderDateFocusNode.dispose();
    employeeFocusNode.dispose();
    bookingTypeFocusNode.dispose();
    orderTakenByController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> fetchNextInvoiceNumber({required String invoiceType}) async {
    try {
      final nextInvoiceNumber = await _invoiceRepository.nextSequence(
        invoiceType: invoiceType,
      );
      invoiceNumber.value = nextInvoiceNumber;
      // invoiceNoController.text = nextInvoiceNumber;
    } catch (e) {
      log('Error fetching next invoice number: $e');
    }
  }

  final getEmployeesResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxList<GetEmployeesValue> employeeOptions = <GetEmployeesValue>[].obs;

  Future<void> searchEmployees(String query) async {
    try {
      getEmployeesResponse.value = ApiResponse.loading("Searching employees");
      final response = await _organizationRepository.getEmployees(query: query);
      employeeOptions.value = (response.values ?? []);
      employeeOptions.refresh();
      getEmployeesResponse.value = ApiResponse.completed(response);
      // employeeFocusNode.requestFocus();
    } catch (e) {
      getEmployeesResponse.value = ApiResponse.error(e.toString());
    }
  }

  void setSelectedEmployee(GetEmployeesValue employee) {
    selectedEmployee.value = employee;
    employeeSearchController.value.text =
        '${employee.firstName} ${employee.lastName}';

    if (Get.isRegistered<CreateOrderItemDetailsController>()) {
      final itemDetailsController =
          Get.find<CreateOrderItemDetailsController>();
      itemDetailsController.requestFirstFocus();
    }
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
          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
    }
  }

  @override
  void onInit() {
    log("Commodity Type Listing");

    searchEmployees('');

    setDefaultDate();
    fetchNextInvoiceNumber(invoiceType: "order_number");

    super.onInit();
  }

  void setDefaultDate() {
    final today = DateTime.now();
    orderDateController.text = "${today.year}-${today.month}-${today.day}";
  }

  void clearAllFields() {
    // Existing clearing code
    orderTakenByController.clear();
    orderDateController.clear();
    selectedEmployee.value = null;
    employeeSearchController.value.clear();
    selectedCommodity.value = 'Gold';
    selectedBooking.value = 'Rate Fix';
    invoiceNumber.value = '';
    notesController.clear();
    hasNotes.value = false;

    // Clear party details
    if (Get.isRegistered<CreateOrderPartyDetailsController>()) {
      final partyDetailsController =
          Get.find<CreateOrderPartyDetailsController>();
      partyDetailsController.clearControllers();
    }

    // Clear item details
    if (Get.isRegistered<CreateOrderItemDetailsController>()) {
      final itemDetailsController =
          Get.find<CreateOrderItemDetailsController>();
      itemDetailsController.clearControllers();
    }

    // Clear old gold details
    if (Get.isRegistered<CreateOrderOldGoldController>()) {
      final oldGoldController = Get.find<CreateOrderOldGoldController>();
      oldGoldController.clearTextController();
    }

    // Clear payment details if exists
    if (Get.isRegistered<CreateOrderPaymentDetailsController>()) {
      final paymentController = Get.find<CreateOrderPaymentDetailsController>();
      paymentController.clearTextController();
      paymentController.controllers.clear();
    }

    // Reset to defaults
    setDefaultDate();
    fetchNextInvoiceNumber(invoiceType: "order_number");
  }
}
