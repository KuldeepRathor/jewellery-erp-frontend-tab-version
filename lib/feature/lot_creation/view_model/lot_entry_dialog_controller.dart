import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/create_lot_entry_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_transaction_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/material_in_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response.dart';

import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/party_details_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class LotEntryController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final PartyDetailsRepository _partyDetailsRepository =
      PartyDetailsRepository();
  final InventoryRepository inventoryRepository = InventoryRepository();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Data for edit mode
  final isEditMode = false.obs;
  final currentLotId = ''.obs;

  // Text controllers
  final transactionTypeController = TextEditingController();
  final invoiceNoController = TextEditingController();
  final supplierController = TextEditingController();
  final pcsController = TextEditingController();
  final grossWtController = TextEditingController();
  final netWtController = TextEditingController();

  // Focus nodes
  final transactionTypeFocusNode = FocusNode();
  final invoiceNoFocusNode = FocusNode();
  final supplierFocusNode = FocusNode();
  final pcsFocusNode = FocusNode();
  final grossWtFocusNode = FocusNode();
  final netWtFocusNode = FocusNode();
  final purityFocusNode = FocusNode();

  // Vendor selection
  final selectedVendor = Rx<VendorSearchValue?>(null);
  final isVendorLoading = false.obs;
  final vendorSearchError = ''.obs;
  final vendors = <VendorSearchValue>[].obs;

  // Transaction type selection
  final selectedTransactionType = Rx<LotTransactionTypesResponse?>(null);

  // Invoice Numbers state
  final invoiceNumbersResponse = Rx<ApiResponse<dynamic>>(
    ApiResponse.initial("Initial"),
  );
  final invoiceNumbers = <String>[].obs;
  final selectedInvoiceId = RxString('');
  int? invoiceNumbersNextPage;
  final isLoadingMoreInvoiceNumbers = false.obs;
  final hasMoreInvoiceNumberPages = true.obs;
  final invoiceNumbersItemsPerPage = 100;

  // Purities
  final purities = <String>[].obs;

  // Selected values
  final selectedPurities = <String>[].obs;

  // API response states
  final createLotEntryResponse = Rx<ApiResponse<GetLotEntriesValue>>(
    ApiResponse.initial("Initial"),
  );

  final updateLotEntryResponse = Rx<ApiResponse<GetLotEntriesValue>>(
    ApiResponse.initial("Initial"),
  );

  // Purity response state
  final getPurityResponse = Rx<ApiResponse<GetPurityResponse>>(
    ApiResponse.initial("Initial"),
  );

  final lotTransactionTypesResponse =
      Rx<ApiResponse<List<LotTransactionTypesResponse>>>(
        ApiResponse.initial("Initial"),
      );
  final lotTransactionTypes = <LotTransactionTypesResponse>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialVendors();
    getSelectedPurity();
    fetchLotTransactionTypes();
    netWtFocusNode.addListener(() {
      if (netWtFocusNode.hasFocus) {
        Future.delayed(Duration.zero, () {
          netWtController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: netWtController.text.length,
          );
        });
      }
    });
  }

  void updateNetWeight(String grossWeight) {
    netWtController.text = grossWeight;
  }

  // Load purities from API
  Future<void> getSelectedPurity() async {
    try {
      getPurityResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getSelectedPurity();
      getPurityResponse.value = ApiResponse.completed(response);

      // Update purities list if response contains values
      if (response.values != null && response.values!.isNotEmpty) {
        purities.assignAll(response.values!);
      }
    } catch (e) {
      getPurityResponse.value = ApiResponse.error(e.toString());
      log('Error fetching metal types: $e');
    }
  }

  // Fetch transaction types from API
  Future<void> fetchLotTransactionTypes() async {
    try {
      lotTransactionTypesResponse.value = ApiResponse.loading(
        "Loading transaction types",
      );

      final response = await _inventoryRepository.fetchLotTransactionTypes();

      lotTransactionTypes.value = response;
      lotTransactionTypes.refresh();

      lotTransactionTypesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      lotTransactionTypesResponse.value = ApiResponse.error(e.toString());
      log('Error fetching transaction types: $e');
    }
  }

  void onTransactionTypeSelected({required LotTransactionTypesResponse item}) {
    selectedTransactionType.value = item;
    transactionTypeController.text = item.transactionType ?? "";
    invoiceNoController.text = "";
    selectedInvoiceId.value = "";
    fetchInvoiceNumbers(
      transactionType: item.transactionType ?? "",
      resetList: true,
    );
  }

  // Fetch invoice numbers based on transaction type
  Future<void> fetchInvoiceNumbers({
    required String transactionType,
    bool resetList = true,
    String? query,
  }) async {
    if (resetList) {
      invoiceNumbersNextPage = null;
      hasMoreInvoiceNumberPages.value = true;
      invoiceNumbersResponse.value = ApiResponse.loading(
        "Loading invoice numbers",
      );
      invoiceNumbers.clear();
    } else {
      isLoadingMoreInvoiceNumbers.value = true;
    }

    try {
      // Different API calls based on transaction type
      InvoiceNumberResponse? response;

      switch (transactionType) {
        case "Material IN":
          response = await _inventoryRepository.fetchMaterialDropdown(
            query: query ?? "",
            page: invoiceNumbersNextPage ?? 1,
            limit: invoiceNumbersItemsPerPage,
          );
          break;
        case "Purchase":
          response = await _inventoryRepository.fetchPurchaseRecordDropdown(
            query: query ?? "",
            page: invoiceNumbersNextPage ?? 1,
            limit: invoiceNumbersItemsPerPage,
          );
          break;
        default:
      }

      // Process response
      List<String> numbers = [];
      Map<String, String> idMap = {}; // To store id to number mapping

      if (response?.values != null) {
        for (var item in response!.values!) {
          if (item.invoiceNumber != null && item.invoiceNumber!.isNotEmpty) {
            numbers.add(item.invoiceNumber!);

            // Store the ID mapping for later use
            if (item.id != null) {
              idMap[item.invoiceNumber!] = item.id!;
            }
          }
        }
      }

      if (resetList) {
        invoiceNumbers.assignAll(numbers);
      } else {
        invoiceNumbers.addAll(numbers);
      }

      // Store the id-to-number mappings for later use when submitting the form
      _storeInvoiceIdMappings(idMap);

      // Update pagination
      hasMoreInvoiceNumberPages.value = response?.pagination?.nextPage != null;
      if (hasMoreInvoiceNumberPages.value) {
        invoiceNumbersNextPage = response?.pagination?.nextPage;
      }
      // Add more transaction types here as needed

      invoiceNumbersResponse.value = ApiResponse.completed("Success");
    } catch (e) {
      invoiceNumbersResponse.value = ApiResponse.error(e.toString());
      log('Error fetching invoice numbers: $e');
    } finally {
      isLoadingMoreInvoiceNumbers.value = false;
    }
  }

  // Map to store invoice number -> id mappings
  final Map<String, String> _invoiceIdMappings = {};

  // Store invoice id mappings
  void _storeInvoiceIdMappings(Map<String, String> idMap) {
    _invoiceIdMappings.addAll(idMap);
  }

  // Set selected invoice with its ID
  void setSelectedInvoice(String invoiceNumber) {
    invoiceNoController.text = invoiceNumber;
    // Find and set the ID
    final id = _invoiceIdMappings[invoiceNumber];
    if (id != null) {
      selectedInvoiceId.value = id;
    }
  }

  // Load more invoice numbers
  Future<void> loadMoreInvoiceNumbers() async {
    if (!isLoadingMoreInvoiceNumbers.value &&
        hasMoreInvoiceNumberPages.value &&
        selectedTransactionType.value?.transactionType != null) {
      await fetchInvoiceNumbers(
        transactionType: selectedTransactionType.value!.transactionType!,
        resetList: false,
      );
    }
  }

  // Load initial vendors when the controller is initialized
  Future<void> loadInitialVendors() async {
    try {
      isVendorLoading.value = true;
      vendorSearchError.value = '';

      // Query with empty string to get default/recent vendors
      final vendorResponse = await _partyDetailsRepository.searchVendor("");

      if (vendorResponse.values != null) {
        vendors.value = vendorResponse.values!;
      }
      log('Loaded ${vendors.length} initial vendors');
    } catch (e) {
      vendorSearchError.value = 'Error loading vendors: $e';
    } finally {
      isVendorLoading.value = false;
    }
  }

  // Method to search vendors
  Future<List<VendorSearchValue>> searchVendors(String query) async {
    if (query.isEmpty) {
      // Return preloaded vendors if query is empty
      return vendors;
    }

    try {
      isVendorLoading.value = true;
      vendorSearchError.value = '';

      final vendorResponse = await _partyDetailsRepository.searchVendor(query);

      if (vendorResponse.values != null) {
        // Update the vendors list with the search results
        final searchResults =
            vendorResponse.values!
                .where(
                  (vendor) =>
                      _matchesSearch(vendor.name, query) ||
                      _matchesSearch(vendor.code, query),
                )
                .toList();

        // Only update if we got results
        if (searchResults.isNotEmpty) {
          vendors.value = searchResults;
        }

        return searchResults;
      }

      // Return existing vendors if no results found
      return vendors;
    } catch (e) {
      vendorSearchError.value = 'Error searching vendors: $e';
      return vendors; // Return existing vendors in case of error
    } finally {
      isVendorLoading.value = false;
    }
  }

  bool _matchesSearch(String? value, String query) {
    return value != null && value.toLowerCase().contains(query.toLowerCase());
  }

  void setSelectedVendor(VendorSearchValue vendor) {
    selectedVendor.value = vendor;
    supplierController.text = vendor.name ?? '';
  }

  // Set controller for edit mode with existing data
  void setForEdit(GetLotEntriesByIdResponse lotData) {
    isEditMode.value = true;
    currentLotId.value = lotData.id ?? '';

    // Populate text controllers with existing data
    transactionTypeController.text = lotData.transactionType ?? '';
    selectedTransactionType.value = LotTransactionTypesResponse(
      transactionType: lotData.transactionType,
    );

    // If we have a transaction type, fetch the invoice numbers
    if (lotData.transactionType != null &&
        lotData.transactionType!.isNotEmpty) {
      fetchInvoiceNumbers(transactionType: lotData.transactionType!).then((_) {
        // Now set the invoice number
        invoiceNoController.text = lotData.invoiceNumber ?? '';
      });
    } else {
      invoiceNoController.text = lotData.invoiceNumber ?? '';
    }

    // Setting Vendor
    final fetchedVendor = VendorSearchValue(
      id: lotData.vendorId,
      name: lotData.vendorName,
    );
    setSelectedVendor(fetchedVendor);

    pcsController.text = lotData.pieces?.toString() ?? '';
    grossWtController.text = lotData.grossWeight?.toString() ?? '';
    netWtController.text = lotData.netWeight?.toString() ?? '';

    // Set selected purities
    selectedPurities.clear();
    if (lotData.lotPurity != null) {
      selectedPurities.addAll(
        lotData.lotPurity!.map((p) => p.purityType ?? '').toList(),
      );
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    transactionTypeController.dispose();
    invoiceNoController.dispose();
    supplierController.dispose();
    pcsController.dispose();
    grossWtController.dispose();
    netWtController.dispose();

    // Dispose focus nodes
    transactionTypeFocusNode.dispose();
    invoiceNoFocusNode.dispose();
    supplierFocusNode.dispose();
    pcsFocusNode.dispose();
    grossWtFocusNode.dispose();
    netWtFocusNode.dispose();
    purityFocusNode.dispose();

    super.onClose();
  }

  // Form field validation functions - these will be used by the form field validators
  String? validateTransactionType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Transaction Type is required';
    }
    return null;
  }

  String? validateInvoiceNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invoice Number is required';
    }
    return null;
  }

  String? validateSupplier(String? value) {
    if (value == null || value.isEmpty) {
      return 'Supplier is required';
    }
    return null;
  }

  String? validatePieces(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pieces is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validateGrossWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gross Weight is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validateNetWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Net Weight is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validatePurities(List<String>? values) {
    if (values == null || values.isEmpty) {
      return 'At least one Purity must be selected';
    }
    return null;
  }

  // Submission logic
  void submitForm() {
    if (formKey.currentState!.validate()) {
      if (isEditMode.value) {
        updateLotEntry(id: currentLotId.value);
      } else {
        createLotEntry();
      }
    }
  }

  // Prepare request object from form data
  CreateLotEntryRequest _prepareRequest() {
    // Convert purity list to proper format
    List<LotPurityRequest> lotPurityList =
        selectedPurities
            .map((purity) => LotPurityRequest(purityType: purity))
            .toList();

    return CreateLotEntryRequest(
      vendorId: selectedVendor.value?.id, // Use the selected vendor's ID
      pieces: int.tryParse(pcsController.text),
      netWeight: double.tryParse(netWtController.text),
      grossWeight: double.tryParse(grossWtController.text),
      transactionType:
          transactionTypeController.text.isNotEmpty
              ? selectedTransactionType.value?.transactionType
              : null,
      invoiceNumber: invoiceNoController.text,
      lotPurity: lotPurityList,
    );
  }

  // Create a new lot entry
  Future<void> createLotEntry() async {
    try {
      CreateLotEntryRequest request = _prepareRequest();
      createLotEntryResponse.value = ApiResponse.loading("Creating lot entry");

      final response = await _inventoryRepository.createLotEntry(request);
      createLotEntryResponse.value = ApiResponse.completed(response);

      Get.back(result: true); // Close dialog with success result
      showSuccessToast(message: 'Lot entry created successfully');
    } catch (e) {
      createLotEntryResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to create lot entry: ${e.toString()}');
    }
  }

  // Update an existing lot entry
  Future<void> updateLotEntry({required String id}) async {
    try {
      CreateLotEntryRequest request = _prepareRequest();
      updateLotEntryResponse.value = ApiResponse.loading("Updating lot entry");

      final response = await _inventoryRepository.updateLotEntry(
        id: id,
        request: request,
      );
      updateLotEntryResponse.value = ApiResponse.completed(response);

      Get.back(result: true); // Close dialog with success result
      showSuccessToast(message: 'Lot entry updated successfully');
    } catch (e) {
      updateLotEntryResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to update lot entry: ${e.toString()}');
    }
  }

  final lotEntryDetailResponse = Rx<ApiResponse<GetLotEntriesByIdResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Fetch lot entry by ID
  Future<void> fetchLotEntryById(String lotEntryId) async {
    try {
      lotEntryDetailResponse.value = ApiResponse.loading("Loading");
      final response = await _inventoryRepository.fetchLotEntryById(
        lotEntryId: lotEntryId,
      );
      setForEdit(response);
      lotEntryDetailResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log(e.toString());
      lotEntryDetailResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Reset the form
  void resetForm() {
    formKey.currentState?.reset();
    isEditMode.value = false;
    currentLotId.value = '';

    transactionTypeController.clear();
    selectedTransactionType.value = null;
    invoiceNoController.clear();
    selectedInvoiceId.value = '';
    supplierController.clear();
    pcsController.clear();
    grossWtController.clear();
    netWtController.clear();

    selectedPurities.clear();
    selectedVendor.value = null;

    // Clear invoice list and mappings
    invoiceNumbers.clear();
    _invoiceIdMappings.clear();
  }

  // Handle keyboard shortcut for save
  void handleSaveShortcut() {
    submitForm();
  }

  // Get loading status
  bool get isLoading {
    return createLotEntryResponse.value.status == Status.LOADING ||
        updateLotEntryResponse.value.status == Status.LOADING;
  }

  // Get error status and message
  bool get hasError {
    return createLotEntryResponse.value.status == Status.ERROR ||
        updateLotEntryResponse.value.status == Status.ERROR;
  }

  String get errorMessage {
    if (isEditMode.value &&
        updateLotEntryResponse.value.status == Status.ERROR) {
      return updateLotEntryResponse.value.message ?? 'Unknown error';
    } else if (createLotEntryResponse.value.status == Status.ERROR) {
      return createLotEntryResponse.value.message ?? 'Unknown error';
    }
    return '';
  }
}
