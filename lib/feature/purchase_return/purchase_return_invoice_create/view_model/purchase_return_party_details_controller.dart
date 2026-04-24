import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/get_purchase_record_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/party_details_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';

class PurchaseReturnPartyDetailsController extends GetxController {
  final PartyDetailsRepository partyDetailsRepository =
      PartyDetailsRepository();
  final PurchaseInvoiceRepository purchaseInvoiceRepository =
      PurchaseInvoiceRepository();

  final invoiceList = <String>[].obs;
  final invoiceDataList = <GetPurchaseRecordDropdownValue>[].obs;
  final selectedInvoiceNumber = RxString('');
  final invoiceController = TextEditingController().obs;

  final searchController = TextEditingController().obs;
  final selectedParty = Rx<dynamic>(null);
  final partyDetails = <dynamic>[].obs;

  RxBool isLoading = false.obs;
  final errorMessage = RxString('');
  final lastSearchQuery = RxString('');

  final _debouncer = CustomDebouncer(milliseconds: 500);

  // For invoice dropdown
  final invoiceSearchController = TextEditingController().obs;
  final selectedInvoice = Rx<GetPurchaseRecordDropdownValue?>(null);
  final invoiceFocusNode = FocusNode();
  final RxList<GetPurchaseRecordDropdownValue> invoiceOptions =
      <GetPurchaseRecordDropdownValue>[].obs;
  final getPurchaseRecordResponse =
      Rx<ApiResponse<GetPurchaseRecordDropdownResponse>>(
        ApiResponse.initial("Initial"),
      );

  String? get selectedPurchaseRecordId => selectedInvoice.value?.id;

  @override
  void onInit() {
    super.onInit();
    searchController.value.addListener(_onSearchChanged);
    fetchInvoicesForParty();
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      searchParties(searchController.value.text);
    });
  }

  Future<void> fetchInvoicesForParty() async {
    String? partyId;

    if (selectedParty.value != null) {
      if (selectedParty.value is CustomerSearchValue) {
        partyId = (selectedParty.value as CustomerSearchValue).id;
        log('Customer ID: $partyId');
      } else if (selectedParty.value is VendorSearchValue) {
        partyId = (selectedParty.value as VendorSearchValue).id;
        log('Vendor ID: $partyId');
      }
    }

    if (partyId == null) {
      log('No party selected, cannot fetch invoices');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Clear previous invoice data
      invoiceDataList.clear();
      invoiceOptions.clear();
      selectedInvoice.value = null;
      invoiceSearchController.value.clear();

      log('Fetching invoices for party ID: $partyId');

      final response = await purchaseInvoiceRepository
          .getPurchaseRecordDropdown(party_id: partyId);

      if (response.values != null && response.values!.isNotEmpty) {
        log(
          "Fetched ${response.values!.length} invoices for party ID: $partyId",
        );
        invoiceDataList.value = response.values!;
        invoiceOptions.value = response.values!;
        invoiceOptions.refresh();
      } else {
        log("No invoices found for party ID: $partyId");
        errorMessage.value = 'No invoices found for this party';
      }
    } catch (e) {
      log('Error fetching invoices: $e');
      errorMessage.value = 'Error fetching invoices: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchInvoices(String query) async {
    if (query.isEmpty) {
      invoiceOptions.value = invoiceDataList;
      invoiceOptions.refresh();
      return;
    }

    try {
      // Filter invoices locally based on query
      final filteredInvoices =
          invoiceDataList
              .where(
                (invoice) =>
                    (invoice.invoiceNumber != null &&
                        invoice.invoiceNumber!.toLowerCase().contains(
                          query.toLowerCase(),
                        )) ||
                    (invoice.partyName != null &&
                        invoice.partyName!.toLowerCase().contains(
                          query.toLowerCase(),
                        )),
              )
              .toList();

      invoiceOptions.value = filteredInvoices;
      invoiceOptions.refresh();
    } catch (e) {
      log('Error filtering invoices: $e');
    }
  }

  void setSelectedInvoice(GetPurchaseRecordDropdownValue invoice) {
    selectedInvoice.value = invoice;
    invoiceSearchController.value.text = invoice.invoiceNumber ?? '';
    log("Selected invoice: ${invoice.toJson()}");
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

  void setSelectedParty(dynamic party) {
    log('Setting selected party: ${party.toString()}');
    selectedParty.value = party;

    // Clear invoice selection when party changes
    selectedInvoice.value = null;
    invoiceSearchController.value.clear();

    // Fetch invoices for the selected party
    fetchInvoicesForParty();
  }

  void updateWithNewCustomer(CustomerSearchValue newCustomer) {
    selectedParty.value = newCustomer;

    if (!partyDetails.any(
      (party) => party is CustomerSearchValue && party.id == newCustomer.id,
    )) {
      partyDetails.add(newCustomer);
    }

    searchController.value.text = newCustomer.name ?? '';

    // Fetch invoices for the selected customer
    fetchInvoicesForParty();
  }

  void updateWithNewVendor(VendorSearchValue newVendor) {
    selectedParty.value = newVendor;

    if (!partyDetails.any(
      (party) => party is VendorSearchValue && party.id == newVendor.id,
    )) {
      partyDetails.add(newVendor);
    }

    searchController.value.text = newVendor.name ?? '';

    // Fetch invoices for the selected vendor
    fetchInvoicesForParty();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    invoiceController.value.dispose();
    invoiceSearchController.value.dispose();
    invoiceFocusNode.dispose();
    super.onClose();
  }

  void clearControllers() {
    searchController.value.clear();
    selectedParty.value = null;
    partyDetails.clear();
    isLoading.value = false;
    errorMessage.value = '';
    lastSearchQuery.value = '';
    invoiceList.clear();
    invoiceDataList.clear();
    selectedInvoiceNumber.value = '';
    invoiceController.value.clear();
    invoiceSearchController.value.clear();
    selectedInvoice.value = null;
  }
}
