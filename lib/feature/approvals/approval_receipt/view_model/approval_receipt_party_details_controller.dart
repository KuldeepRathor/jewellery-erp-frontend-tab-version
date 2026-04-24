import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/model/get_approval_issue_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view_model/approval_receipt_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/party_details_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ApprovalReceiptPartyDetailsController extends GetxController {
  final PartyDetailsRepository partyDetailsRepository =
      PartyDetailsRepository();

  final InventoryRepository _inventoryRepository = InventoryRepository();
  late final ApprovalReceiptItemDetailsController itemDetailsController;

  final searchController = TextEditingController().obs;
  final approvalNumberController = TextEditingController();
  final selectedParty = Rx<dynamic>(null);
  final partyDetails = <dynamic>[].obs;

  RxBool isLoading = false.obs;
  final errorMessage = RxString('');
  final lastSearchQuery = RxString('');
  final RxString approvalReceiptNumber = ''.obs;

  final _debouncer = CustomDebouncer(milliseconds: 500);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final approvalDateController = TextEditingController();

  // New properties for approval issue number dropdown
  final approvalIssueSearchController = TextEditingController().obs;
  final selectedApprovalIssue = Rx<GetApprovalIssueNumberValue?>(null);
  final FocusNode approvalIssueFocusNode = FocusNode();
  final RxList<GetApprovalIssueNumberValue> approvalIssueOptions =
      <GetApprovalIssueNumberValue>[].obs;
  final getApprovalIssueResponse =
      Rx<ApiResponse<GetApprovalIssueNumberResponse>>(
        ApiResponse.initial("Initial"),
      );

  @override
  void onInit() {
    super.onInit();
    itemDetailsController = Get.put<ApprovalReceiptItemDetailsController>(
      ApprovalReceiptItemDetailsController(),
    );
    searchController.value.addListener(_onSearchChanged);
    fetchApprovalReceiptNumber();
    setDefaultDate();
  }

  // New method to search approval issue numbers
  Future<void> searchApprovalIssueNumbers(String query) async {
    try {
      getApprovalIssueResponse.value = ApiResponse.loading(
        "Searching approval issues",
      );
      final response = await _inventoryRepository.getApprovalIssueNumber(
        query: query,
      );
      approvalIssueOptions.value = (response.values ?? []);
      approvalIssueOptions.refresh();
      getApprovalIssueResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getApprovalIssueResponse.value = ApiResponse.error(e.toString());
    }
  }

  // New method to set selected approval issue
  void setSelectedApprovalIssue(GetApprovalIssueNumberValue approvalIssue) {
    selectedApprovalIssue.value = approvalIssue;
    approvalIssueSearchController.value.text =
        approvalIssue.approvalIssueNumber ?? '';
    approvalNumberController.text = approvalIssue.approvalIssueNumber ?? '';
    fetchApprovalRecord();
  }

  void setDefaultDate() {
    final today = DateTime.now();
    selectedDate.value = today;
    // Format as YYYY-MM-DD to match API expectations
    approvalDateController.text =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
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
      selectedDate.value = pickedDate;
      // Format as YYYY-MM-DD to match API expectations
      controller.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> fetchApprovalRecord() async {
    if (approvalNumberController.text.isEmpty) {
      showErrorToast(message: "Please enter an approval number");
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _inventoryRepository
          .getApprovalRecordByApprovalNumber(approvalNumberController.text);

      if (response.partyType?.toLowerCase() == 'customer') {
        final customer = CustomerSearchValue(
          id: response.partyId,
          name: response.partyDetails?.name,
          phoneNumber: response.partyDetails?.phoneNumber,
          gstNumber: response.partyDetails?.gstNumber,
          panNumber: response.partyDetails?.panNumber,
          gender: response.partyDetails?.gender,
          dateOfBirth: response.partyDetails?.dateOfBirth,
          address: response.partyDetails?.address,
        );
        updateWithNewCustomer(customer);
      } else {
        final vendor = VendorSearchValue(
          id: response.partyId,
          name: response.partyDetails?.name,
          phoneNumber: response.partyDetails?.phoneNumber,
          gstNumber: response.partyDetails?.gstNumber,
          panNumber: response.partyDetails?.panNumber,
          address: response.partyDetails?.address,
        );
        updateWithNewVendor(vendor);
      }

      // Clear all existing rows first
      itemDetailsController.controllers.clear();

      // Populate data from the API response
      if (response.lineItems != null && response.lineItems!.isNotEmpty) {
        for (var i = 0; i < response.lineItems!.length; i++) {
          var item = response.lineItems![i];
          var pcsController = TextEditingController(
            text: item.pieces?.toString() ?? "",
          );
          pcsController.addListener(() {
            if (pcsController.text.isNotEmpty) {
              double? currentPcs = double.tryParse(pcsController.text);
              double? originalPcs = item.pieces?.toDouble();

              if (currentPcs != null &&
                  originalPcs != null &&
                  currentPcs > originalPcs) {
                pcsController.text = originalPcs.toString();
                showErrorToast(
                  message:
                      "Pieces cannot exceed the original quantity: $originalPcs",
                );
              }
            }
          });
          itemDetailsController.controllers.add(
            ApprovalItemDetailsTableData(
              id: item.id ?? "",
              tagging_id: item.taggingId ?? "",
              sn: (i + 1).toString(),
              item_code: TextEditingController(text: item.code ?? ""),
              tag_no: TextEditingController(text: item.tag ?? ""),
              description: TextEditingController(text: item.description ?? ""),
              pcs: pcsController,
              gwt: TextEditingController(text: item.grossWeight ?? ""),
              nwt: TextEditingController(text: item.netWeight ?? ""),
              va: TextEditingController(
                text: item.finalVa ?? item.taggingVa ?? "",
              ),
              mc: TextEditingController(
                text: item.finalMc ?? item.taggingMc ?? "",
              ),
              stone: TextEditingController(text: item.stoneCost ?? ""),
              hall_mark: TextEditingController(text: item.hallMark ?? ""),
              originalPcs: item.pieces?.toDouble(),
            ),
          );
        }
      }

      // If no items were added (empty response), add one empty row
      if (itemDetailsController.controllers.isEmpty) {
        itemDetailsController.addRow();
      }

      itemDetailsController.updateTotals();

      if (itemDetailsController.controllers.isNotEmpty) {
        // Request focus on the first item code field
        itemDetailsController.currentRowIndex.value = 0;
        itemDetailsController.currentColIndex.value = 0;

        // Wait for the UI to update before requesting focus
        await Future.delayed(const Duration(milliseconds: 100));
        itemDetailsController.controllers[0].tableFocusNodes[0].requestFocus();
      }
      showSuccessToast(message: "Approval issue fetched successfully");
    } catch (e) {
      errorMessage.value = 'Error fetching approval record: $e';
      log('Error fetching approval record: $e');
      showErrorToast(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchApprovalReceiptNumber() async {
    try {
      final recordNumber = await _inventoryRepository.approvalReceiptNumber();
      approvalReceiptNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching tagging record number: $e');
      approvalReceiptNumber.value = 'Error';
    }
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

  void setSelectedContact(dynamic contact) {
    log("Setting Value : ${contact.toJson()}");
    selectedParty.value = contact;
  }

  void updateWithNewCustomer(CustomerSearchValue newCustomer) {
    // If party details include address information from the API
    if (newCustomer.address == null &&
        selectedParty.value is CustomerSearchValue &&
        (selectedParty.value as CustomerSearchValue).id == newCustomer.id) {
      // Keep existing address info if any
      newCustomer = CustomerSearchValue(
        id: newCustomer.id,
        name: newCustomer.name,
        phoneNumber: newCustomer.phoneNumber,
        gstNumber: newCustomer.gstNumber,
        panNumber: newCustomer.panNumber,
        gender: newCustomer.gender,
        dateOfBirth: newCustomer.dateOfBirth,
        address: (selectedParty.value as CustomerSearchValue).address,
      );
    }

    selectedParty.value = newCustomer;

    if (!partyDetails.any(
      (party) => party is CustomerSearchValue && party.id == newCustomer.id,
    )) {
      partyDetails.add(newCustomer);
    }

    searchController.value.text = newCustomer.name ?? '';
  }

  void updateWithNewVendor(VendorSearchValue newVendor) {
    // If party details include address information from the API
    if (newVendor.address == null &&
        selectedParty.value is VendorSearchValue &&
        (selectedParty.value as VendorSearchValue).id == newVendor.id) {
      // Keep existing address info if any
      newVendor = VendorSearchValue(
        id: newVendor.id,
        name: newVendor.name,
        phoneNumber: newVendor.phoneNumber,
        gstNumber: newVendor.gstNumber,
        panNumber: newVendor.panNumber,
        address: (selectedParty.value as VendorSearchValue).address,
      );
    }

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
    approvalDateController.dispose();
    approvalIssueSearchController.value.dispose();
    approvalIssueFocusNode.dispose();
    super.onClose();
  }

  void clearControllers() {
    searchController.value.clear();
    approvalNumberController.clear();
    approvalIssueSearchController.value.clear();
    selectedParty.value = null;
    selectedApprovalIssue.value = null;
    partyDetails.clear();
    isLoading.value = false;
    errorMessage.value = '';
    lastSearchQuery.value = '';
    setDefaultDate();
  }
}
