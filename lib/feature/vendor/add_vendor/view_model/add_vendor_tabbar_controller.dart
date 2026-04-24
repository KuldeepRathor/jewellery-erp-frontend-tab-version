// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/add_vendor_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/bank_account_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_types_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/gst_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_listing/view_model/vendor_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AddVendorTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final VendorRepository addVendorRepository = Get.find();
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  late TabController _tabController;
  TabController get tabController => _tabController;

  final RxInt currentIndex = 0.obs;

  final formKey = GlobalKey<FormState>();
  final gstFieldKey = GlobalKey<FormState>();

  // Text editing controllers
  final gstController = TextEditingController();
  final codeController = TextEditingController();
  final storeNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final panController = TextEditingController();
  final percentageController = TextEditingController();
  final ledgerController = TextEditingController();

  final phoneNumberController = TextEditingController();

  // Observable variables for GST Details
  final RxList<VendorType> selectedVendorTypes = <VendorType>[].obs;
  final Rx<AccountMapping?> selectedLedgers = Rx<AccountMapping?>(null);
  final selectedDeduction = 'TDS'.obs;
  final fetchedGstType = ''.obs;

  // Lists for dropdown items
  // final vendorTypes = ['Gold', 'Silver', 'Platinum'];
  // final ledgerItems = [
  //   'Item 1',
  //   'Item 2',
  //   'Item 3',
  //   'Item 4',
  //   'Item 5',
  //   'Item 6',
  //   'Item 7'
  // ];
  final deductionItems = ['TCS', 'TDS', 'None'];

  // Observable variables for UI state
  final isLoading = false.obs;
  final detailsFetched = false.obs;

  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;
  final RxBool isCheckingPinCode = false.obs;
  final RxBool isPinCodeValid = true.obs;

  final _debouncer = CustomDebouncer(milliseconds: 500);

  // New fields for BalanceDetailsWidget
  final balanceFormKey = GlobalKey<FormState>();
  final openingBalanceCreditController = TextEditingController();
  final openingBalanceDebitController = TextEditingController();
  final openingWeightCreditController = TextEditingController();
  final openingWeightDebitController = TextEditingController();
  final closingBalanceCreditController = TextEditingController();
  final closingWeightDebitController = TextEditingController();

  // New fields for BankDetailsWidget
  final bankFormKey = GlobalKey<FormState>();
  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();

  final RxBool isGSTAvailable = true.obs;
  final RxBool isCheckingGST = false.obs;

  final RxBool isPhoneAvailable = true.obs;
  final RxBool isCheckingPhone = false.obs;

  final FocusNode phoneNoFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    fetchVendorTypes();
    fetchLedgerItems();
  }

  void _handleTabSelection() {
    currentIndex.value = _tabController.index;
    print("Logging Changing step");
  }

  void checkGSTAvailability(String gst) {
    if (gst.isEmpty) {
      isGSTAvailable.value = true;
      isCheckingGST.value = false;
      return;
    }

    isCheckingGST.value = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await addVendorRepository
            .gst_phone_number_availability(gst, 'gst');
        isGSTAvailable.value = isAvailable;
      } catch (e, stack) {
        print('Error checking GST availability: $e, $stack');
        showErrorToast(message: "Failed to check GST availability");
      } finally {
        isCheckingGST.value = false;
      }
    });
  }

  void checkPhoneAvailability(String phone) {
    if (phone.isEmpty) {
      isPhoneAvailable.value = true;
      isCheckingPhone.value = false;
      return;
    }

    isCheckingPhone.value = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await addVendorRepository
            .gst_phone_number_availability(phone, 'phone number');
        isPhoneAvailable.value = isAvailable;
      } catch (e, stack) {
        print('Error checking phone availability: $e, $stack');
        showErrorToast(message: "Failed to check phone number availability");
      } finally {
        isCheckingPhone.value = false;
      }
    });
  }

  void checkCodeAvailability(String code) {
    if (code.isEmpty) {
      isCodeAvailable.value = true;
      isCheckingCode.value = false;
      return;
    }

    isCheckingCode.value = true;
    _debouncer.run(() async {
      // Simulating API call
      try {
        final isAvailable = await addVendorRepository.validateCode(code);
        isCodeAvailable.value = isAvailable;
      } catch (e, stack) {
        print('Error checking code availability: $e, $stack');
        // Get.snackbar('Error', 'Failed to check code availability');
        showErrorToast(message: "Failed to check code availability");
      } finally {
        isCheckingCode.value = false;
      }
    });
  }

  void checkPinCodeAndSetCity(String pinCode) {
    if (pinCode.length != 6) {
      isPinCodeValid.value = false;
      cityController.text = '';
      stateController.text = '';
      return;
    }

    isCheckingPinCode.value = true;
    _debouncer.run(() async {
      try {
        final pincodeResponse = await addVendorRepository.getCityFromPincode(
          pinCode,
        );
        if (pincodeResponse != null) {
          cityController.text = pincodeResponse.city ?? '';
          stateController.text = pincodeResponse.state ?? '';
          isPinCodeValid.value = true;
          phoneNoFocusNode.requestFocus();
        } else {
          cityController.text = '';
          stateController.text = '';
          isPinCodeValid.value = false;
        }
      } catch (e) {
        print('Error checking pincode: $e');
        showErrorToast(message: "Failed to validate pincode");
        isPinCodeValid.value = false;
        cityController.text = '';
        stateController.text = '';
      } finally {
        isCheckingPinCode.value = false;
      }
    });
  }

  bool checkAppropriateValidation() {
    if (currentIndex.value == 0) {
      // Add state validation to the first tab
      if (!validateGSTStateMatch()) {
        showErrorToast(message: "states are different for gst and pincode");
        return false;
      }
      return formKey.currentState!.validate();
    } else if (currentIndex.value == 1) {
      return balanceFormKey.currentState!.validate();
    } else {
      return bankFormKey.currentState!.validate();
    }
  }

  void nextTab(String? vendorId) {
    log("Logging nextTab step $currentIndex : ${tabController.index}");
    if (currentIndex.value < 2) {
      if (checkAppropriateValidation()) {
        _tabController.animateTo(currentIndex.value + 1);
      }
    } else {
      if (vendorId == null) {
        if (addVendorResponse.value.status != Status.LOADING) {
          addVendor();
        }
      } else {
        if (updateVendorResponse.value.status != Status.LOADING) {
          updateVendor(vendorId);
        }
      }
    }
  }

  // Dropdown change handlers
  void updateSelectedVendorTypes(List<VendorType> newSelection) {
    selectedVendorTypes.value = newSelection;
  }

  void onLedgerChanged(AccountMapping newSelection) {
    log("The new selection is ${newSelection.toJson()}");
    selectedLedgers.value = newSelection;
  }

  void onDeductionChanged(String? newValue) {
    if (newValue != null) {
      selectedDeduction.value = newValue;
    }
  }

  // Method to fetch GST details
  final gstDetailsResponse = Rx<ApiResponse<GstDetailsResponse>>(
    ApiResponse.initial("Initial"),
  );

  bool validateGSTStateMatch() {
    // Get state from GST details
    final gstState = gstDetailsResponse.value.data?.state;
    // Get state from PIN code
    final pinCodeState = stateController.text;

    // If GST details haven't been fetched yet or PIN code state isn't set, return true
    if (gstState == null || gstState.isEmpty || pinCodeState.isEmpty) {
      return true;
    }

    // Compare states (case-insensitive)
    return gstState.toLowerCase().trim() == pinCodeState.toLowerCase().trim();
  }

  String? getStateValidationMessage() {
    if (!validateGSTStateMatch()) {
      final gstState = gstDetailsResponse.value.data?.state;
      final pinCodeState = stateController.text;
      return 'State mismatch: GST shows $gstState but PIN code shows $pinCodeState';
    }
    return null;
  }

  String extractPANFromGST(String gstNumber) {
    if (gstNumber.length >= 15) {
      return gstNumber.substring(2, 12);
    }
    return '';
  }

  String? validatePANWithGST(String? value, String gstNumber) {
    if (value == null || value.isEmpty) {
      return 'PAN number is required';
    }
    if (!isValidPAN(value)) {
      return 'Invalid PAN number format';
    }
    // Check if PAN matches GST
    final extractedPAN = extractPANFromGST(gstNumber);
    if (extractedPAN.isNotEmpty && value != extractedPAN) {
      return 'PAN number does not match GST number';
    }
    return null;
  }

  Future<void> fetchGSTDetails() async {
    // var data = gstFieldKey.currentState?.validate();
    // log("Data L ${data}");

    fetchedGstType.value = "";
    print("Fetch gst }");

    if (!gstFieldKey.currentState!.validate()) {
      // Get.snackbar('Error', 'Please enter GST number');
      // print("Fetch gst Details return ${}");
      return;
    }
    gstDetailsResponse.value = ApiResponse.loading("Loading..");
    print("Fetch gst Details start");
    try {
      final gstNumber = gstController.text.trim();
      final panNumber = extractPANFromGST(gstNumber);
      panController.text = panNumber;
      final response = await addVendorRepository.fetchGSTDetails(
        gstController.text.trim(),
      );
      print("Data L $response");
      // fetchedGstType.value = response.gstType ?? "";
      print("Data L $fetchedGstType");
      gstDetailsResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "GST details fetched successfully");
      // Get.snackbar('Success', 'GST details fetched successfully');
    } catch (e) {
      // Get.snackbar('Error', 'Failed to fetch GST details');
      print("Fetch gst Details error : ${e.toString()}");
      gstDetailsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch GST details");
    }
  }

  // Method to validate and submit the form
  void submitForm() {
    if (formKey.currentState!.validate()) {
      // Process the form data
      print('Form is valid. Submitting the data.');
      // Add your logic here to submit the form data
    }
  }

  void validateForm() {
    formKey.currentState!.validate();
  }

  void saveBalanceDetails() {
    if (balanceFormKey.currentState!.validate()) {
      // Process the balance details
      print('Balance details are valid. Saving...');
      // Add your logic to save the balance details
    }
  }

  void saveBankDetails() {
    if (bankFormKey.currentState!.validate()) {
      print('Bank details are valid. Saving...');
    }
  }

  final RxList<BankAccount> savedAccounts = <BankAccount>[].obs;

  void addAccount() {
    final newAccount = BankAccount(
      holder_name: accountNameController.text,
      account_number: accountNumberController.text,
      ifsc_code: ifscController.text,
    );
    savedAccounts.insert(0, newAccount);
    clearAccountFields();
  }

  void selectAccount(int index) {
    final selectedAccount = savedAccounts[index];
    accountNameController.text = selectedAccount.holder_name ?? "";
    accountNumberController.text = selectedAccount.account_number ?? "";
    ifscController.text = selectedAccount.ifsc_code ?? "";
  }

  void deleteAccount(int index) {
    savedAccounts.removeAt(index);
  }

  void clearAccountFields() {
    accountNameController.clear();
    accountNumberController.clear();
    ifscController.clear();
  }

  final vendorTypesResponse = Rx<ApiResponse<VendorTypesResponse>>(
    ApiResponse.initial("Initial"),
  );
  final ledgerListResponse = Rx<ApiResponse<GetAccountMappingResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> fetchVendorTypes() async {
    try {
      vendorTypesResponse.value = ApiResponse.loading('Loading..');
      final types = await addVendorRepository.getVendorTypes();
      vendorTypesResponse.value = ApiResponse.completed(types);
    } catch (e, stack) {
      print('Error fetching vendor types: $e $stack');
      vendorTypesResponse.value = ApiResponse.error(e.toString());
      // Get.snackbar('Error', 'Failed to load vendor types');
      showErrorToast(message: "Failed to load vendor types");
    }
  }

  Future<void> fetchLedgerItems() async {
    try {
      ledgerListResponse.value = ApiResponse.loading('Loading..');
      final items = await _purchaseRepository.getAccountMappings();
      ledgerListResponse.value = ApiResponse.completed(items);
    } catch (e, stack) {
      print('Error fetching Ledger list: $e $stack');
      ledgerListResponse.value = ApiResponse.error(e.toString());
      // Get.snackbar('Error', 'Failed to load Ledger list');
      showErrorToast(message: "Failed to load Ledger types");
    }
  }

  final addVendorResponse = Rx<ApiResponse<AddVendorRequestResponse>>(
    ApiResponse.initial("Initial"),
  );
  final updateVendorResponse = Rx<ApiResponse<AddVendorRequestResponse>>(
    ApiResponse.initial("Initial"),
  );

  // Future<void> submitVendorDetails(String? vendorId) async {
  //   try {
  //     addVendorResponse.value = ApiResponse.loading('Loading..');
  //     final AddVendorRequestResponse vendorDataRequest =
  //         AddVendorRequestResponse(
  //       gstNumber: gstController.text,
  //       code: codeController.text,
  //       organization_id: "0b458682-2fb1-4a23-babd-e3851a39c86d",
  //       name: storeNameController.text,
  //       address: [
  //         Address(
  //           // id: vendorId != null ? getVendorResponseById.value.data?.address?.id : null,
  //           type: "string",
  //           city: cityController.text,
  //           pincode: pinCodeController.text,
  //           addressLine1: address1Controller.text,
  //           addressLine2: address2Controller.text,
  //         )
  //       ],
  //       panNumber: panController.text,
  //       deductionPercent: percentageController.text,
  //       vendorTypes: selectedVendorTypes,
  //       ledgerItems: selectedLedgers,
  //       deductionType: selectedDeduction.value,
  //       bankDetails: savedAccounts.toList(),
  //     );
  //     final AddVendorRequestResponse response;
  //     if (vendorId == null) {
  //       response = await addVendorRepository.addVendor(vendorDataRequest);
  //     } else {
  //       response =
  //           await addVendorRepository.putVendor(vendorId, vendorDataRequest);
  //     }
  //     addVendorResponse.value = ApiResponse.completed(response);

  //     Get.back(closeOverlays: true);
  //     showSuccessToast(
  //       message: vendorId == null
  //           ? 'Vendor added successfully'
  //           : 'Vendor updated successfully',
  //     );
  //   } catch (e, s) {
  //     print('Error adding vendor: $e $s');
  //     Get.snackbar('Error', 'Failed to add vendor');
  //     addVendorResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  //adding vendor
  Future<void> addVendor() async {
    try {
      addVendorResponse.value = ApiResponse.loading('Loading..');
      final AddVendorRequestResponse vendorDataRequest =
          AddVendorRequestResponse(
            gstNumber: gstController.text,
            code: codeController.text,
            organization_id: "0b458682-2fb1-4a23-babd-e3851a39c86d",
            name: storeNameController.text,
            ledgerId: selectedLedgers.value?.id,
            address: [
              Address(
                isDefault: true,
                isJlAddress: false,
                type: "string",
                city: cityController.text,
                pincode: pinCodeController.text,
                addressLine1: address1Controller.text,
                addressLine2: address2Controller.text,
                state: stateController.text,
                phoneNumber: phoneNumberController.text,
              ),
            ],
            panNumber: panController.text,
            vendorTypes: selectedVendorTypes,
            ledgerItems: [],
            deductionPercent:
                (percentageController.text.trim().isEmpty)
                    ? "0"
                    : percentageController.text.trim(),
            deductionType:
                selectedDeduction.value.toLowerCase() == 'none'
                    ? null
                    : selectedDeduction.value,
            bankDetails: savedAccounts.toList(),
          );
      final response = await addVendorRepository.addVendor(vendorDataRequest);
      addVendorResponse.value = ApiResponse.completed(response);

      final VendorSearchValue vendorSearchValue = VendorSearchValue(
        // id: response.,
        name: response.name,
        code: response.code,
        organizationId: response.organization_id,
        // addressId: response.address?.isNotEmpty == true
        //     ? response.address![0].id
        //     : null,
        address: response.address,
        panNumber: response.panNumber,
        gstNumber: response.gstNumber,
        deductionType: response.deductionType,
        deductionPercent: response.deductionPercent,
        // bankDetails: response.bankDetails,
        vendorTypes: response.vendorTypes,
        ledgerItems: response.ledgerItems,
      );

      final PartyDetailsController partyDetailsController =
          Get.put<PartyDetailsController>(PartyDetailsController());
      partyDetailsController.updateWithNewVendor(vendorSearchValue);
      if (Get.isRegistered<EstimationSearchPartyController>()) {
        final controller = Get.find<EstimationSearchPartyController>();
        controller.updateWithNewVendor(vendorSearchValue);
      }
      if (Get.isRegistered<CreateSalesEstimationSearchPartyController>()) {
        final controller =
            Get.find<CreateSalesEstimationSearchPartyController>();
        controller.updateWithNewVendor(vendorSearchValue);
      }
      VendorListingViewmodel vendorListingViewmodel = Get.put(
        VendorListingViewmodel(),
      );
      vendorListingViewmodel.getVendorListingDetails(
        resetList: true,
        isSearch: false,
      );
      Get.back();
      Get.back();
      showSuccessToast(message: 'Vendor added successfully');
    } catch (e, s) {
      print('Error adding vendor: $e $s');
      // Get.snackbar('Error', 'Failed to add vendor');
      showErrorToast(message: "Failed to add vendor $e");
      addVendorResponse.value = ApiResponse.error(e.toString());
    }
  }

  // updating vendor code
  Future<void> updateVendor(String vendorId) async {
    try {
      updateVendorResponse.value = ApiResponse.loading('Loading..');

      List<Address> addressList = [];
      if (getVendorResponseById.value.data?.address != null &&
          getVendorResponseById.value.data!.address!.isNotEmpty) {
        addressList = [
          Address(
            isDefault: true,
            isJlAddress: false,
            id: getVendorResponseById.value.data!.address![0].id,
            type: "string",
            city: cityController.text,
            pincode: pinCodeController.text,
            addressLine1: address1Controller.text,
            addressLine2: address2Controller.text,
            state: stateController.text,
            phoneNumber: phoneNumberController.text,
          ),
        ];
      }

      List<BankAccount> bankDetailsList =
          savedAccounts.map((account) {
            return BankAccount(
              id: account.id,
              holder_name: account.holder_name,
              account_number: account.account_number,
              ifsc_code: account.ifsc_code,
            );
          }).toList();

      final AddVendorRequestResponse vendorDataRequest =
          AddVendorRequestResponse(
            gstNumber: gstController.text,
            code: codeController.text,
            organization_id: "0b458682-2fb1-4a23-babd-e3851a39c86d",
            name: storeNameController.text,
            address: addressList,
            panNumber: panController.text,
            vendorTypes: selectedVendorTypes,
            ledgerItems: [],
            deductionPercent:
                (percentageController.text.trim().isEmpty)
                    ? "0"
                    : percentageController.text.trim(),
            deductionType:
                selectedDeduction.value.toLowerCase() == 'none'
                    ? null
                    : selectedDeduction.value,
            bankDetails: bankDetailsList,
            ledgerId: selectedLedgers.value?.id,
          );

      final response = await addVendorRepository.putVendor(
        vendorId,
        vendorDataRequest,
      );
      updateVendorResponse.value = ApiResponse.completed(response);

      final VendorSearchValue vendorSearchValue = VendorSearchValue(
        // id: response.id,
        name: response.name,
        code: response.code,
        organizationId: response.organization_id,
        // addressId: response.address?.isNotEmpty == true
        //     ? response.address![0].id
        //     : null,
        address: addressList,
        panNumber: response.panNumber,
        gstNumber: response.gstNumber,
        deductionType: response.deductionType,
        deductionPercent: response.deductionPercent,
        // bankDetails: response.bankDetails,
        vendorTypes: response.vendorTypes,
        ledgerItems: response.ledgerItems,
      );

      final PartyDetailsController partyDetailsController =
          Get.put<PartyDetailsController>(PartyDetailsController());
      partyDetailsController.updateWithNewVendor(vendorSearchValue);

      final VendorListingViewmodel customerListingViewmodel =
          Get.put<VendorListingViewmodel>(VendorListingViewmodel());
      customerListingViewmodel.getVendorListingDetails(resetList: true);

      Get.back();
      showSuccessToast(message: 'Vendor updated successfully');
    } catch (e, s) {
      print('Error updating vendor: $e $s');

      Get.back();
      // Get.snackbar('Error', 'Failed to update vendor');
      showErrorToast(message: "Failed to update vendor");
      updateVendorResponse.value = ApiResponse.error(e.toString());
    }
  }

  // final getVendorResponse =
  //     Rx<ApiResponse<AddVendorRequestResponse>>(ApiResponse.initial("Initial"));
  // Future<void> getVendor(String vendorId) async {
  //   try {
  //     getVendorResponse.value = ApiResponse.loading('Loading..');
  //     await Future.delayed(const Duration(seconds: 1));
  //     final response = await addVendorRepository.getVendor(vendorId);
  //     // setVendorData(response);
  //     getVendorResponse.value = ApiResponse.completed(response);
  //   } catch (e, stack) {
  //     print('Error fetching Ledger list: $e $stack');
  //     getVendorResponse.value = ApiResponse.error(e.toString());
  //     Get.snackbar('Error', 'Failed to load Ledger list');
  //   }
  // }

  //Getting vendor data by id
  final getVendorResponseById = Rx<ApiResponse<GetVendorByIdResponse>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> getVendorById(String vendorId) async {
    try {
      getVendorResponseById.value = ApiResponse.loading('Loading..');
      await Future.delayed(const Duration(seconds: 1));
      final response = await addVendorRepository.getVendorById(vendorId);
      setVendorData(response);
      getVendorResponseById.value = ApiResponse.completed(response);
    } catch (e, stack) {
      print('Error fetching Ledger list: $e $stack');
      getVendorResponseById.value = ApiResponse.error(e.toString());
      // Get.snackbar('Error', 'Failed to load Ledger list');
      showErrorToast(message: "Failed to load Ledger list");
    }
  }

  //Setting vendor data function
  void setVendorData(GetVendorByIdResponse? vendorData) {
    gstController.text = vendorData?.gstNumber ?? '';
    codeController.text = vendorData?.code ?? '';
    storeNameController.text = vendorData?.name ?? '';
    panController.text = vendorData?.panNumber ?? '';
    percentageController.text = vendorData?.deductionPercent ?? '';

    selectedVendorTypes.assignAll(vendorData?.vendorTypes ?? []);
    // selectedLedgers.assignAll(vendorData?.ledgerItems ?? []);
    selectedLedgers.value = (vendorData?.ledger);
    ledgerController.text = vendorData?.ledger?.groupName ?? '';
    selectedDeduction.value = vendorData?.deductionType ?? deductionItems.last;

    savedAccounts.assignAll((vendorData?.bankDetails ?? []));

    if (vendorData?.address != null && vendorData!.address!.isNotEmpty) {
      final address = vendorData.address![0];
      address1Controller.text = address.addressLine1 ?? '';
      address2Controller.text = address.addressLine2 ?? '';
      cityController.text = address.city ?? '';
      pinCodeController.text = address.pincode ?? '';
      stateController.text = address.state ?? '';
      phoneNumberController.text = address.phoneNumber ?? "";
    }
  }

  @override
  void onClose() {
    gstController.dispose();
    codeController.dispose();
    storeNameController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    pinCodeController.dispose();
    panController.dispose();
    percentageController.dispose();
    ledgerController.dispose();
    phoneNumberController.dispose();

    openingBalanceCreditController.dispose();
    openingBalanceDebitController.dispose();
    openingWeightCreditController.dispose();
    openingWeightDebitController.dispose();
    closingBalanceCreditController.dispose();
    closingWeightDebitController.dispose();

    accountNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();

    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.onClose();
  }
}
