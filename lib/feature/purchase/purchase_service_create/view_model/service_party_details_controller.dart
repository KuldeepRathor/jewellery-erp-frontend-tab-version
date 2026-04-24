import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/party_details_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';

class ServicePartyDetailsController extends GetxController {
  final PartyDetailsRepository partyDetailsRepository =
      PartyDetailsRepository();

  final searchController = TextEditingController().obs;
  final selectedParty = Rx<dynamic>(null);
  final partyDetails = <dynamic>[].obs;

  RxBool isLoading = false.obs;
  final errorMessage = RxString('');
  final lastSearchQuery = RxString('');

  final _debouncer = CustomDebouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    searchController.value.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      searchParties(searchController.value.text);
    });
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
      final vendorResponse = await partyDetailsRepository.searchVendor(query);

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

      if (vendorResponse.values != null) {
        partDetailsCombined.addAll(
          vendorResponse.values!
              .where(
                (vendor) =>
                    _matchesSearch(vendor.name, query) ||
                    _matchesSearch(vendor.code, query),
              )
              .map((vendor) => vendor),
        );
      }

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

  Future<void> setSelectedContact(dynamic contact) async {
    log("Setting Value : ${contact.toJson()}");
    selectedParty.value = contact;
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
  }
}
