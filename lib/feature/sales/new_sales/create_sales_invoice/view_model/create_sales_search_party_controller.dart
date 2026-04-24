import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_party_balance_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/party_details_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';

class CreateSalesEstimationSearchPartyController extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final PartyDetailsRepository partyDetailsRepository =
      PartyDetailsRepository();

  final EstimationRepository estimationRepository = EstimationRepository();
  final searchController = TextEditingController().obs;
  final selectedParty = Rx<dynamic>(null);
  final partyDetails = <dynamic>[].obs;

  RxBool isLoading = false.obs;
  final errorMessage = RxString('');
  final lastSearchQuery = RxString('');
  final RxString estimationNumber = ''.obs;

  final _debouncer = CustomDebouncer(milliseconds: 500);
  FocusNode partySearchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    searchController.value.addListener(_onSearchChanged);
    fetchestimationNumber();
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      searchParties(searchController.value.text);
    });
  }

  Future<void> fetchestimationNumber() async {
    try {
      final recordNumber = await estimationRepository.estimationNumber();
      estimationNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching tagging record number: $e');
      estimationNumber.value = 'Error';
    }
  }

  final getPartyBalanceResponse = Rx<ApiResponse<PartyBalanceResponse>>(
    ApiResponse.initial('Empty data'),
  );

  Future<void> getPartyBalance({required String partyId}) async {
    try {
      if (partyId.isEmpty) {
        return;
      }
      getPartyBalanceResponse.value = ApiResponse.loading("Loading");
      List<String> partyNames = [partyId];
      final response = await estimationRepository.getPartyBalance(
        partyNames: partyNames,
      );
      getPartyBalanceResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getPartyBalanceResponse.value = ApiResponse.error(
        "Party Balance Error : $e",
      );
      log('Error Party Balance Error : $e');
    }
  }

  Future<void> searchParties(String query) async {
    if (query.isEmpty) {
      partyDetails.clear();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final customerResponse = await partyDetailsRepository.searchCustomer(
        query,
      );
      // final vendorResponse = await partyDetailsRepository.searchVendor(query);

      List<dynamic> partDetailsCombined = [];

      if (customerResponse.values != null) {
        partDetailsCombined.addAll(
          customerResponse.values!
              .where(
                (customer) =>
                    _matchesSearch(customer.name, query) ||
                    _matchesSearch(customer.phoneNumber, query),
              )
              .map((customer) => customer),
        );
      }

      // if (vendorResponse.values != null) {
      //   partDetailsCombined.addAll(vendorResponse.values!
      //       .where((vendor) =>
      //           _matchesSearch(vendor.name, query) ||
      //           _matchesSearch(vendor.code, query))
      //       .map((vendor) => vendor));
      // }

      partyDetails.value = partDetailsCombined;

      if (partDetailsCombined.isEmpty) {
        errorMessage.value = 'No results found';
      }
    } catch (e) {
      errorMessage.value = 'Error searching parties: $e';
      log('Error searching parties: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _matchesSearch(String? value, String query) {
    return value != null && value.toLowerCase().contains(query.toLowerCase());
  }

  void setSelectedContact(dynamic contact, {FocusNode? nextFocusNode}) {
    log("Setting Value : ${contact.toJson()}");
    selectedParty.value = contact;
    getPartyBalance(partyId: contact.id);

    if (nextFocusNode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nextFocusNode.requestFocus();
      });
    }
  }

  void updateWithNewCustomer(CustomerSearchValue newCustomer) {
    selectedParty.value = newCustomer;

    if (!partyDetails.any(
      (party) => party is CustomerSearchValue && party.id == newCustomer.id,
    )) {
      partyDetails.add(newCustomer);
    }

    searchController.value.text = newCustomer.name ?? '';
  }

  void updateWithNewVendor(VendorSearchValue newVendor) {
    selectedParty.value = newVendor;

    if (!partyDetails.any(
      (party) => party is VendorSearchValue && party.id == newVendor.id,
    )) {
      partyDetails.add(newVendor);
    }

    searchController.value.text = newVendor.name ?? '';
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  void clearControllers() {
    searchController.value.clear();
    selectedParty.value = null;
    partyDetails.clear();
    isLoading.value = false;
    errorMessage.value = '';
    lastSearchQuery.value = '';
    selectedEmployee.value = null;
    employeeSearchController.value.text = "";
    getPartyBalanceResponse.value = ApiResponse.initial("initial");
  }

  final getEmployeesResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );
  final selectedEmployee = Rx<GetEmployeesValue?>(null);
  final employeeSearchController = TextEditingController().obs;

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
}
