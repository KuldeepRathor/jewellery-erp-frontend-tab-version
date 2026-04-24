import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/models/get_sales_dropdown_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/base/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/models/post_sales_return_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SalesReturnViewmodel extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final TextEditingController salesNumberTextController =
      TextEditingController();
  final FocusNode salesNumberFocusNode = FocusNode();

  final TextEditingController salesInvoiceSearchController =
      TextEditingController();
  final FocusNode salesInvoiceFocusNode = FocusNode();
  // Observable list for invoice options
  final RxList<GetSalesDropdownValue> salesInvoiceOptions =
      <GetSalesDropdownValue>[].obs;

  // Selected invoice
  final Rx<GetSalesDropdownValue?> selectedSalesInvoice =
      Rx<GetSalesDropdownValue?>(null);

  final RxBool isFastMode = true.obs;
  final RxString salesNumber = ''.obs;

  final sequencesDropdownResponse =
      Rx<ApiResponse<GetSequencesDropdownResponse>>(
        ApiResponse.initial("INITIAL"),
      );
  final sequencesDropdownList = <GetSequencesDropdownValue>[].obs;
  final selectedSequence = Rx<GetSequencesDropdownValue?>(null);
  final sequencesDropdownController = TextEditingController();
  final sequencesDropdownFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    // fetchSalesReturnNumber();
    loadSequencesDropdown();
  }

  @override
  void onClose() {
    sequencesDropdownController.dispose();
    sequencesDropdownFocusNode.dispose();

    salesInvoiceSearchController.dispose();
    salesInvoiceFocusNode.dispose();
    super.onClose();
  }

  void toggleFastMode() => isFastMode.toggle();

  void clearControllers() {
    isFastMode.value = true;
    salesNumberTextController.clear();
    salesInvoiceSearchController.clear();
    salesInvoiceOptions.clear();
    selectedSalesInvoice.value = null;

    // Add this line to reset the API response
    getSaleBySalesNumberResponse.value = ApiResponse.initial('Empty data');

    // Fetch new sales return number
    fetchSalesReturnNumber();
    salesInvoiceSearchController.clear();
    salesInvoiceOptions.clear();
    selectedSalesInvoice.value = null;
  }

  Future<void> searchSalesInvoices(String query) async {
    try {
      if (query.isEmpty) {
        // Get all invoices if query is empty
        final response = await estimationRepository.getSalesDropdown();
        salesInvoiceOptions.value = response.values ?? [];
      } else {
        // Search with query parameter
        final response = await estimationRepository.getSalesDropdownWithQuery(
          query,
        );
        salesInvoiceOptions.value = response.values ?? [];
      }
    } catch (e) {
      showErrorToast(message: "Failed to load sales invoices");
      salesInvoiceOptions.clear();
    }
  }

  void setSelectedSalesInvoice(GetSalesDropdownValue invoice) {
    selectedSalesInvoice.value = invoice;
    salesInvoiceSearchController.text = invoice.saleNumber ?? '';

    // Trigger the fetch sales by number
    if (invoice.saleNumber != null) {
      getSaleBySalesNumber(saleNumber: invoice.saleNumber!);
    }
  }

  Future<void> loadSequencesDropdown({
    String? voucherType = "2",
    String? voucherSection = "10",
  }) async {
    try {
      sequencesDropdownResponse.value = ApiResponse.loading(
        "Loading sequences...",
      );

      final response = await estimationRepository.getSequencesDropdown(
        voucherType: voucherType,
        voucherSection: voucherSection,
      );

      if (response.values != null && response.values!.isNotEmpty) {
        sequencesDropdownList.assignAll(response.values!);
        sequencesDropdownResponse.value = ApiResponse.completed(response);

        final defaultSequence =
            response.values!.firstWhereOrNull((seq) => seq.isDefault == true) ??
            response.values!.first;
        setSelectedSequence(defaultSequence);
      } else {
        sequencesDropdownResponse.value = ApiResponse.completed(response);
        showErrorToast(message: 'No sequences available');
      }
    } catch (e) {
      log('Error loading sequences dropdown: $e');
      sequencesDropdownResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to load sequences');
    }
  }

  void setSelectedSequence(GetSequencesDropdownValue sequence) {
    selectedSequence.value = sequence;
    sequencesDropdownController.text = sequence.value ?? '';
    salesNumber.value = sequence.value ?? '';
  }

  Future<void> fetchSalesReturnNumber() async {
    try {
      final recordNumber = await estimationRepository.getNextInvoiceNumber(
        invoiceType: "sales_return_number",
      );
      salesNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching tagging record number: $e');
      salesNumber.value = 'Error';
    }
  }

  final postSalesResponse = Rx<ApiResponse<PostSalesReturnRequest>>(
    ApiResponse.initial('Empty data'),
  );

  Future<void> addSalesReturnInvoice({
    required PostSalesReturnRequest salesRequest,
  }) async {
    postSalesResponse.value = ApiResponse.loading("Loading");
    try {
      final response = await estimationRepository.addSalesReturnInvoice(
        salesRequest: salesRequest,
      );
      postSalesResponse.value = ApiResponse.completed(response);
    } catch (e, s) {
      log("Error in postPurchaseInvoice $e \n $s");
      final handledResponse = handleDTOResponseErrors(e);
      postSalesResponse.value = ApiResponse.error(handledResponse.message);
      // showErrorToast(
      //     message: handledResponse.message ?? "Something went wrong ");
      rethrow;
    }
  }

  final getSaleBySalesNumberResponse =
      Rx<ApiResponse<GetSalesRecordByIdAggregateResponse>>(
        ApiResponse.initial('Empty data'),
      );

  Future<void> getSaleBySalesNumber({required String saleNumber}) async {
    // if (saleNumber.length < 7) return;
    SalesReturnItemDetailsController salesReturnItemDetailsController =
        Get.find<SalesReturnItemDetailsController>();
    SalesReturnSearchPartyController partyController =
        Get.find<SalesReturnSearchPartyController>();

    getSaleBySalesNumberResponse.value = ApiResponse.loading("Loading");

    try {
      salesReturnItemDetailsController.clearControllers();
      final response = await estimationRepository.getSaleBySalesNumber(
        salesNumber: saleNumber,
      );

      salesReturnItemDetailsController.addToControllersFromEstimateNumberApi(
        response: response,
      );

      // Fix: Convert PartyDetails to appropriate type based on partyType
      if (response.partyDetails != null) {
        if (response.partyType == "customer") {
          // Convert PartyDetails to CustomerSearchValue
          final customerSearchValue = CustomerSearchValue(
            id: response.partyDetails!.id,
            readableId: response.partyDetails!.readableId,
            phoneNumber: response.partyDetails!.phoneNumber,
            name: response.partyDetails!.name,
            dateOfBirth: response.partyDetails!.dateOfBirth,
            panNumber: response.partyDetails!.panNumber,
            gstNumber: response.partyDetails!.gstNumber,
            deductionType: response.partyDetails!.deductionType,
            deductionPercent: response.partyDetails!.deductionPercent,
            organizationId: response.partyDetails!.organizationId,
            addressUuid: response.partyDetails!.addressUuid,
            gender: response.partyDetails!.gender,
          );
          partyController.selectedParty.value = customerSearchValue;
          partyController.searchController.value.text =
              customerSearchValue.name ?? "";
        } else if (response.partyType == "vendor") {
          // Convert PartyDetails to VendorSearchValue
          final vendorSearchValue = VendorSearchValue(
            id: response.partyDetails!.id,
            phoneNumber: response.partyDetails!.phoneNumber,
            name: response.partyDetails!.name,

            panNumber: response.partyDetails!.panNumber,

            gstNumber: response.partyDetails!.gstNumber,
            deductionType: response.partyDetails!.deductionType,
            deductionPercent: response.partyDetails!.deductionPercent,
            organizationId: response.partyDetails!.organizationId,

            code:
                response
                    .partyDetails!
                    .readableId, // or another appropriate field
          );
          partyController.selectedParty.value = vendorSearchValue;
          partyController.searchController.value.text =
              vendorSearchValue.name ?? "";
        }
      }

      if (partyController.selectedParty.value != null) {
        String partyId = "";
        if (partyController.selectedParty.value is CustomerSearchValue) {
          partyId =
              (partyController.selectedParty.value as CustomerSearchValue).id ??
              "";
        } else if (partyController.selectedParty.value is VendorSearchValue) {
          partyId =
              (partyController.selectedParty.value as VendorSearchValue).id ??
              "";
        }

        if (partyId.isNotEmpty) {
          partyController.getPartyBalance(partyId: partyId);
        }
      }

      getSaleBySalesNumberResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Sales fetched successfully!");
    } catch (e, s) {
      log("Error in getSaleBySalesNumber $e \n $s");
      getSaleBySalesNumberResponse.value = ApiResponse.error(e.toString());
      salesReturnItemDetailsController.clearControllers();
      showErrorToast(message: "Sales Not found ");
    }
  }
}
