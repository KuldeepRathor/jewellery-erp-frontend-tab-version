import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/get_deisgn_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_vendor_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_default_counter_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_lot_entries_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/design_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/lot_entry_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/purity_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/setting_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/size_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/lot_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/printer_setting_class.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/get_catalogue_metal_color_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/counter/counter_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';
import 'dart:typed_data';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class TaggingController extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final VendorRepository _vendorRepository = VendorRepository();
  final RxString taggingRecordNumber = RxString('');
  final RxBool isFirstTime = RxBool(true);
  final TaggingItemDetailsController itemDetailsController = Get.put(
    TaggingItemDetailsController(),
  );

  final getVendorDropdownResponse = Rx<ApiResponse<GetVendorDropdownResponse>>(
    ApiResponse.initial("Initial"),
  );
  int? currentPageVendor;

  final GlobalSettingsViewModel globalSettingsViewModel =
      Get.find<GlobalSettingsViewModel>();
  final RxBool isLotBasedTaggingOnly = false.obs;

  // final getVendorListingDetailsResponse =
  //     Rx<ApiResponse<PaginatedGetVendorListingDetailsResponse>>(
  //   ApiResponse.initial("Initial"),
  // );

  final getDesignListingResponse =
      Rx<ApiResponse<PaginatedDesignListingResponse>>(
        ApiResponse.initial("Initial"),
      );
  // final getPurityResponse = Rx<ApiResponse<GetPurityResponse>>(
  //   ApiResponse.initial("Initial"),
  // );

  final RxList<String> purityList = RxList<String>();
  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 20;
  int? nextPageDesign;

  final RxBool isAutoWeightInput = true.obs; // true = auto : false = Manual
  void toggleWeightInput() {
    isAutoWeightInput.toggle();
  }

  final RxBool isprintTag = true.obs;
  void togglePrintTag() {
    isprintTag.toggle();
  }

  final Rx<String?> selectedVendorId = Rx<String?>(null);
  final Rx<String?> selectedVendorCode = Rx<String?>(null);

  final getDesignDropdownResponse = Rx<ApiResponse<GetDesignDropdownResponse>>(
    ApiResponse.initial("Initial"),
  );
  final Rx<GetDesignResponseModel?> selectedDesign =
      Rx<GetDesignResponseModel?>(null);

  int? currentPageDesign;

  final Rx<String?> selectedSizeId = Rx<String?>(null);
  final Rx<String?> selectedSizeName = Rx<String?>(null);

  final RxList<SizeGroup> availableSizes = RxList<SizeGroup>([]);
  final RxString sizeSearchQuery = ''.obs;

  final Rx<String?> selectedPurity = Rx<String?>(null);
  final RxString puritySearchQuery = RxString('');
  final RxList<String> filteredPurities = RxList<String>([]);

  // RxBool isWeightInputManual = true.obs;
  // RxBool isHuidEnabled = true.obs;
  final RxBool isQcyDropdownOpened = false.obs;
  final RxBool isCounterDefault = true.obs;
  final Rx<GenderEnum?> selectedGender = Rx<GenderEnum?>(null);
  final Rx<GetCatalogMetalColorResponse?> selectedMetalColor =
      Rx<GetCatalogMetalColorResponse?>(null);
  final RxList<CounterValue> counter = <CounterValue>[].obs;
  final Rx<CounterValue?> selectedCounter = Rx<CounterValue?>(null);
  final Rx<String?> selectedCounterId = Rx<String?>(null);

  final Rx<TextEditingController> printTagController =
      TextEditingController(text: '1').obs;
  final Rx<TextEditingController> printerNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> scalePortController =
      TextEditingController().obs;

  // void updateWeightInput(bool value) => isWeightInputManual.value = value;
  // void updateHuid(bool value) => isHuidEnabled.value = value;
  void updateCounter(bool value) => isCounterDefault.value = value;

  final Rx<GetDefaultCounterResponse?> defaultCounter =
      Rx<GetDefaultCounterResponse?>(null);
  Uint8List? pdf;

  final RxBool isHuidRequired = false.obs;
  final RxBool isRateEnabled = true.obs;

  final PrinterSettings printerSettings = PrinterSettings();
  @override
  void onInit() {
    super.onInit();
    printerSettings.loadSettings();
    getVendorListingDetails(resetList: true);
    getDesignListing(resetList: true);
    // getPurityDetails();
    fetchTaggingRecordNumber();
    getCounterDetails(resetList: true);
    fetchDefaultCounter();
    ever(selectedDesign, (design) => handleDesignChange(design));

    checkLotBasedTaggingSetting();
  }

  void toggleHuidRequired() {
    isHuidRequired.toggle();
    update();
  }

  Future<void> checkLotBasedTaggingSetting() async {
    try {
      // Check if global settings are already loaded, if not fetch them
      if (globalSettingsViewModel.getGlobalSettingsResponse.value.status !=
          Status.COMPLETED) {
        await globalSettingsViewModel.getGlobalSettings();
      }

      final tagPreference =
          globalSettingsViewModel
              .getGlobalSettingsResponse
              .value
              .data
              ?.tagPreference;

      isLotBasedTaggingOnly.value = tagPreference?.lotBasedTaggingOnly ?? false;

      // If lot-based tagging is required and this is the first time
      if (isLotBasedTaggingOnly.value && isFirstTime.value) {
        // Open lot dialog immediately on page load
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Small delay for UI to settle
        await openLotDialogInitial();
      }
    } catch (e) {
      log('Error checking lot-based tagging setting: $e');
      // Continue with normal flow if there's an error
    }
  }

  Future<void> openLotDialogInitial() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 50));

    await Get.dialog(
      LotEntryDropdownDialog(
        onLotSelected: (GetLotEntriesDropdownValue? lotNo) {
          setSelectedLotNumber(lotNo);
          Get.back();
          // After lot selection, focus on employee dropdown
          Future.delayed(const Duration(milliseconds: 100), () {
            employeeFocusNode.requestFocus();
          });
        },
      ),
    );
  }

  void handleDesignChange(GetDesignResponseModel? design) {
    if (design == null) return;

    bool hasStoneRequired = design.stoneRequired ?? false;
    String? makingChargeTypeId = design.makingChargeType?.id;

    // Handle stone requirement
    if (hasStoneRequired) {
      if (itemDetailsController.controllers.isNotEmpty) {
        var currentRow =
            itemDetailsController.controllers[itemDetailsController
                .currentRowIndex
                .value];
        // Keep existing stone value if any
        if (currentRow.stone.text.isEmpty) {
          currentRow.stone.text = "0";
        }
      }
    } else {
      // Set stone value to 0 if stone not required
      if (itemDetailsController.controllers.isNotEmpty) {
        var currentRow =
            itemDetailsController.controllers[itemDetailsController
                .currentRowIndex
                .value];
        currentRow.stone.text = "0";
      }
    }

    // Handle rate field based on making charge type
    if (makingChargeTypeId == "1") {
      if (itemDetailsController.controllers.isNotEmpty) {
        var currentRow =
            itemDetailsController.controllers[itemDetailsController
                .currentRowIndex
                .value];
        currentRow.rate.text = "0";
      }
      isRateEnabled.value = false;
    } else {
      isRateEnabled.value = true;
    }

    update();
  }

  void fetchAllRequiredApis() {
    // taken from onInit
    getVendorListingDetails(resetList: true);
    getDesignListing(resetList: true);
    // getPurityDetails();
    fetchTaggingRecordNumber();
    getCounterDetails(resetList: true);
    fetchDefaultCounter();
    searchEmployees("");
  }

  Future<void> fetchDefaultCounter() async {
    try {
      final response = await _inventoryRepository.getDefaultCounter();
      defaultCounter.value = response;

      // If counter is set to default, update the selected counter with default values
      if (isCounterDefault.value) {
        selectedCounterId.value = defaultCounter.value?.id;
        if (itemDetailsController.controllers.isNotEmpty) {
          final currentIndex = itemDetailsController.currentRowIndex.value;
          itemDetailsController.controllers[currentIndex].counterId =
              defaultCounter.value?.id;
          itemDetailsController.controllers[currentIndex].counterName =
              defaultCounter.value?.counterName;
        }
      }
    } catch (e) {
      log('Error fetching default counter: $e');
    }
  }

  void setIsCounterDefault(bool value) {
    isCounterDefault.value = value;
    if (value) {
      selectedCounter.value = null;
      selectedCounterId.value = defaultCounter.value?.id;

      if (itemDetailsController.controllers.isNotEmpty) {
        final currentIndex = itemDetailsController.currentRowIndex.value;
        itemDetailsController.controllers[currentIndex].isCounterDefault = true;
        itemDetailsController.controllers[currentIndex].counterId =
            defaultCounter.value?.id;
        itemDetailsController.controllers[currentIndex].counterName =
            defaultCounter.value?.counterName;
      }
    } else if (selectedCounter.value == null && counter.isNotEmpty) {
      selectedCounter.value = counter.first;
      selectedCounterId.value = counter.first.id;

      if (itemDetailsController.controllers.isNotEmpty) {
        final currentIndex = itemDetailsController.currentRowIndex.value;
        itemDetailsController.controllers[currentIndex].isCounterDefault =
            false;
        itemDetailsController.controllers[currentIndex].counterId =
            counter.first.id;
        itemDetailsController.controllers[currentIndex].counterName =
            counter.first.counterName;
      }
    }
    update(['counter_selection']);
  }

  String? getSelectedCounterId() {
    if (isCounterDefault.value) {
      return defaultCounter.value?.id;
    } else {
      return selectedCounter.value?.id;
    }
  }

  final getCounterResponse = Rx<ApiResponse<CounterResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getCounterDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getCounterResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _inventoryRepository.getCounterListing(
        offsetId: lastOffsetId,
        limit: 300,
        query: searchQuery.value,
      );
      setSelectedCounter(
        response.values?.firstWhereOrNull(
          (element) => element.isDefault == true,
        ),
      );
      if (resetList) {
        getCounterResponse.value = ApiResponse.completed(response);
        counter.assignAll(response.values ?? []);
        if (counter.isNotEmpty &&
            selectedCounter.value == null &&
            !isCounterDefault.value) {
          selectedCounter.value = counter.first;
        }
      } else {
        final currentData = getCounterResponse.value.data?.values ?? [];
        List<CounterValue> newData = [...currentData, ...response.values ?? []];
        response.values = newData;
        getCounterResponse.value = ApiResponse.completed(response);
        counter.assignAll(newData);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      getCounterResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSelectedVendor(String id, String code) {
    // Validate against the selected lot
    if (selectedLotNumber.value != null &&
        selectedLotNumber.value?.vendorId != null &&
        id != selectedLotNumber.value?.vendorId) {
      showErrorToast(message: "This vendor does not match the lot's vendor");
      return; // Don't update if validation fails
    }
    selectedVendorId.value = id;
    selectedVendorCode.value = code;
    // Only set for the current row if it exists
    if (itemDetailsController.controllers.isNotEmpty) {
      final currentIndex = itemDetailsController.currentRowIndex.value;
      itemDetailsController.controllers[currentIndex].vendorId = id;
      itemDetailsController.controllers[currentIndex].vendorCode = code;
    }
  }

  void setSelectedDesign(GetDesignResponseModel? design) {
    selectedDesign.value = design;
  }

  void setSelectedSize(String? id, String? name) {
    selectedSizeId.value = id;
    selectedSizeName.value = name;
    if (itemDetailsController.controllers.isNotEmpty) {
      final currentIndex = itemDetailsController.currentRowIndex.value;
      itemDetailsController.controllers[currentIndex].sizeId = id ?? '';
      itemDetailsController.controllers[currentIndex].sizeName = name ?? '';
    }
  }

  void setSelectedPurity(String? purity) {
    // Validate against the selected lot
    if (selectedLotNumber.value != null &&
        selectedLotNumber.value?.purityTypes != null &&
        purity != null &&
        selectedLotNumber.value!.purityTypes!.isNotEmpty &&
        !selectedLotNumber.value!.purityTypes!.contains(purity)) {
      showErrorToast(
        message: 'This purity is not available in the selected lot',
      );
      return; // Don't update if validation fails
    }
    selectedPurity.value = purity;
    if (itemDetailsController.controllers.isNotEmpty) {
      final currentIndex = itemDetailsController.currentRowIndex.value;
      itemDetailsController.controllers[currentIndex].purityText = purity ?? '';
      itemDetailsController.controllers[currentIndex].purity.text =
          purity ?? '';
    }
  }

  void setSelectedCounter(CounterValue? value) {
    if (value != null) {
      selectedCounter.value = value;
      selectedCounterId.value = value.id;
      isCounterDefault.value = false;

      if (itemDetailsController.controllers.isNotEmpty) {
        final currentIndex = itemDetailsController.currentRowIndex.value;
        itemDetailsController.controllers[currentIndex].isCounterDefault =
            false;
        itemDetailsController.controllers[currentIndex].counterId = value.id;
        itemDetailsController.controllers[currentIndex].counterName =
            value.counterName;
      }
    } else {
      selectedCounter.value = null;
      selectedCounterId.value = null;
      isCounterDefault.value = true;

      if (itemDetailsController.controllers.isNotEmpty) {
        final currentIndex = itemDetailsController.currentRowIndex.value;
        itemDetailsController.controllers[currentIndex].isCounterDefault = true;
        itemDetailsController.controllers[currentIndex].counterId = null;
        itemDetailsController.controllers[currentIndex].counterName = null;
      }
    }
    update(['counter_selection']);
  }

  void setPuritySearchQuery(String query) {
    puritySearchQuery.value = query;
    _filterPurities();
  }

  void saveSettings() {
    // Save the settings to your backend or local storage
    // log('Weight Input: ${isWeightInputManual.value ? 'Manual' : 'Auto'}');
    // log('HUID: ${isHuidEnabled.value ? 'Yes' : 'No'}');

    if (!isCounterDefault.value && selectedCounter.value == null) {
      showErrorToast(message: 'Please select a counter to proceed');
      return;
    }
    log('Counter: ${isCounterDefault.value ? 'Default' : 'Not Default'}');
    log('No of Print Tag: ${printTagController.value}');
    printerSettings.saveSettings();
    update(['counter_selection']);
    Get.back();
  }

  void _filterPurities() {
    final allPurities = purityList.toList();
    if (puritySearchQuery.value.isEmpty) {
      filteredPurities.value = allPurities;
    } else {
      filteredPurities.value =
          allPurities
              .where(
                (purity) => purity.toLowerCase().contains(
                  puritySearchQuery.value.toLowerCase(),
                ),
              )
              .toList();
    }
  }

  // Future<void> getPurityDetails() async {
  //   try {
  //     getPurityResponse.value = ApiResponse.loading("Loading Purity");
  //     final response = await _inventoryRepository.getSelectedPurity();
  //     getPurityResponse.value = ApiResponse.completed(response);
  //     _filterPurities(); // Initialize filtered purities
  //   } catch (e) {
  //     getPurityResponse.value = ApiResponse.error(e.toString());
  //   }
  // }

  void updateAvailableSizes() {
    final selectedDesignData = selectedDesign.value;
    selectedSizeId.value = null;
    selectedSizeName.value = null;
    if (selectedDesignData?.stockHead?.sizeGroups != null) {
      availableSizes.value = selectedDesignData!.stockHead!.sizeGroups!;
    } else {
      availableSizes.clear();
    }
    log("Available sizes: ${availableSizes.length}");
  }

  void updateAvailablePurities() {
    final selectedDesignData = selectedDesign.value;
    final lineItems = selectedDesignData?.lineItems ?? [];
    // Create a Set to store unique purities
    final Set<String> uniquePurities = {};

    // Iterate through line items and add non-null purities to the set
    for (final lineItem in lineItems) {
      if (lineItem.purity != null && lineItem.purity!.isNotEmpty) {
        uniquePurities.add(lineItem.purity!);
      }
    }
    selectedPurity.value = null;
    purityList.clear();
    purityList.assignAll(uniquePurities.toList());
    _filterPurities();
    log("Available sizes: ${purityList.toList()}");
  }

  List<SizeGroup> getFilteredSizes() {
    if (sizeSearchQuery.value.isEmpty) {
      return availableSizes;
    }
    return availableSizes
        .where(
          (size) =>
              (size.size?.toLowerCase().contains(
                    sizeSearchQuery.value.toLowerCase(),
                  ) ??
                  false) ||
              (size.code?.toLowerCase().contains(
                    sizeSearchQuery.value.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  void setSizeSearchQuery(String query) {
    sizeSearchQuery.value = query;
  }

  Future<void> fetchTaggingRecordNumber() async {
    try {
      final recordNumber = await _inventoryRepository.taggingRecordNumber();
      taggingRecordNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching tagging record number: $e');
      taggingRecordNumber.value = 'Error';
    }
  }

  // Future<void> taggingRecord() async {

  // }
  // void setInitialConditions({required bool isSearch}) {
  //   lastOffsetId = null;
  //   hasMorePages.value = true;
  //   if (isSearch == false) {
  //     searchQuery.value = '';
  //   }
  // }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    getVendorListingDetails(resetList: true, isSearch: true);
    _searchDebouncer.run(() {
      getDesignListing(resetList: true, isSearch: true);
    });
  }

  Future<void> getVendorListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getVendorDropdownResponse.value = ApiResponse.loading("loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _vendorRepository.getVendorDropdown(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: resetList ? null : currentPageVendor?.toString(),
      );

      if (resetList) {
        // Add null vendor at start for reset case
        final nullVendor = GetVendorDropdownValue(
          id: '',
          code: NOVENDOR,
          name: NOVENDOR,
        );
        response.values = [nullVendor, ...response.values ?? []];
        getVendorDropdownResponse.value = ApiResponse.completed(response);
        currentPageVendor = 1;
      } else {
        final currentData = getVendorDropdownResponse.value.data?.values ?? [];
        List<GetVendorDropdownValue> newData = [
          // For pagination, preserve the null vendor at start if it exists
          if (currentData.isNotEmpty && currentData.first.id?.isEmpty == true)
            currentData.first,
          ...currentData.skip(
            currentData.isNotEmpty && currentData.first.id?.isEmpty == true
                ? 1
                : 0,
          ),
          ...response.values ?? [],
        ];

        final updatedResponse = GetVendorDropdownResponse(
          values: newData,
          pagination: response.pagination,
        );

        getVendorDropdownResponse.value = ApiResponse.completed(
          updatedResponse,
        );
      }

      // Update pagination state
      hasMorePages.value = response.pagination?.nextPage != null;
      if (hasMorePages.value) {
        currentPageVendor = response.pagination?.nextPage;
      }
    } catch (e) {
      if (resetList) {
        getVendorDropdownResponse.value = ApiResponse.error(e.toString());
      }
      log('Error fetching vendor dropdown: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> getDesignListing({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getDesignDropdownResponse.value = ApiResponse.loading("LOADING");
    } else {
      if (isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      final response = await _inventoryRepository.getDesignDropdown(
        query: searchQuery.value,
        limit: itemsPerPage,
        page: resetList ? 1 : currentPageDesign,
      );

      if (resetList) {
        getDesignDropdownResponse.value = ApiResponse.completed(response);
        currentPageDesign = 1;
      } else {
        final currentData = getDesignDropdownResponse.value.data?.values ?? [];
        List<GetDesignDropdownValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        final updatedResponse = GetDesignDropdownResponse(
          values: newData,
          pagination: response.pagination,
        );

        getDesignDropdownResponse.value = ApiResponse.completed(
          updatedResponse,
        );
      }

      // Update pagination state
      hasMorePages.value = response.pagination?.nextPage != null;
      if (hasMorePages.value) {
        currentPageDesign = response.pagination?.nextPage;
      }
    } catch (e) {
      if (resetList) {
        getDesignDropdownResponse.value = ApiResponse.error(e.toString());
      }
      log('Error fetching design dropdown: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<GetDesignResponseModel?> fetchDesignDetails(String designId) async {
    try {
      final response = await _inventoryRepository.getDesignById(id: designId);
      return response;
    } catch (e) {
      log('Error fetching design details: $e');
      showErrorToast(message: 'Failed to fetch design details');
      return null;
    }
  }

  // Updated setInitialConditions method
  void setInitialConditions({required bool isSearch}) {
    currentPageDesign = null;
    currentPageVendor = null;
    hasMorePages.value = true;
    isLoadingMore.value = false;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  // Updated setSearchQuery method with debouncing
  final _searchDebouncer = CustomDebouncer(milliseconds: 500);

  // Optional: Method to manually trigger loading more designs
  Future<void> loadMoreDesigns() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getDesignListing(resetList: false, isSearch: false);
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getVendorListingDetails();
      await getDesignListing();
      await getCounterDetails();
    }
  }

  void resetFields() {
    selectedVendorId.value = null;
    selectedVendorCode.value = null;
    selectedDesign.value = null;
    selectedSizeId.value = null;
    selectedSizeName.value = null;
    selectedPurity.value = null;
    selectedGender.value = null;
    selectedMetalColor.value = null;
    printTagController.value.text = '1';
    isCounterDefault.value = true;
    selectedCounter.value = null;
    selectedCounterId.value = defaultCounter.value?.id; // Update this line
    itemDetailsController.clearControllers();
    selectedEmployee.value = null;
    employeeSearchController.value.text = "";
    selectedQcyEmployees.clear();
    qcySearchController.value.text = "";
    qcyEmployeeOptions.clear();
    getCounterDetails(resetList: true);
    fetchDefaultCounter();
    fetchTaggingRecordNumber();
    update(['counter_selection']);
    final LotController lotController = Get.find<LotController>();
    lotController.setInitialConditions(isSearch: false);
    selectedLotNumber.value = null;
  }

  final selectedEmployee = Rx<GetEmployeesValue?>(null);
  final employeeSearchController = TextEditingController().obs;
  final employeeFocusNode = FocusNode();

  // Safe Focusnode
  final FocusNode safeFocusNode = FocusNode();

  // For QCY
  final selectedQcyEmployees = RxList<GetEmployeesValue>([]);
  final qcySearchController = TextEditingController().obs;
  final qcyFocusNode = FocusNode();
  final qcyEmployeeOptions = RxList<GetEmployeesValue>([]);
  final RxList<GetEmployeesValue> employeeOptions = <GetEmployeesValue>[].obs;
  final CustomDebouncer debouncer = CustomDebouncer(milliseconds: 500);
  final getEmployeesResponse = Rx<ApiResponse<GetEmployeesResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> searchQcyEmployees(String query) async {
    try {
      final response = await _organizationRepository.getEmployees(query: query);
      final newList = response.values ?? [];

      final map = {for (var e in newList) e.id: e};

      selectedQcyEmployees.value =
          selectedQcyEmployees
              .where((e) => map.containsKey(e.id))
              .map((e) => map[e.id]!)
              .toList();

      qcyEmployeeOptions.value = map.values.toList();
      qcyEmployeeOptions.refresh();
    } catch (e) {
      log('Error searching QCY employees: $e');
    }
  }

  void addQcyEmployee(GetEmployeesValue employee) {
    if (!selectedQcyEmployees.any((e) => e.id == employee.id)) {
      selectedQcyEmployees.add(employee);
    }
  }

  void removeQcyEmployee(GetEmployeesValue employee) {
    selectedQcyEmployees.removeWhere((e) => e.id == employee.id);
  }

  Future<void> onQcySelectionDone() async {
    if (selectedQcyEmployees.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));

    if (isLotBasedTaggingOnly.value && selectedLotNumber.value == null) {
      await openLotDialogInitial();
    } else {
      await openVendorDialog();
    }
  }

  Future<void> searchEmployees(String query) async {
    try {
      getEmployeesResponse.value = ApiResponse.loading("Searching");
      final response = await _organizationRepository.getEmployees(query: query);
      employeeOptions.value = (response.values ?? []);
      employeeOptions.refresh();
      getEmployeesResponse.value = ApiResponse.completed(response);
      employeeFocusNode.requestFocus();
    } catch (e) {
      getEmployeesResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> setSelectedEmployee(GetEmployeesValue employee) async {
    selectedEmployee.value = employee;
    employeeSearchController.value.text =
        '${employee.firstName} ${employee.lastName}';

    // Unfocus immediately
    employeeFocusNode.unfocus();

    // Force unfocus from context if available
    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }

    // Add a small delay to ensure the unfocus takes effect
    await Future.delayed(const Duration(milliseconds: 100));

    if (isFirstTime.value) {
      // Check if lot-based tagging is required and lot is not selected
      if (isLotBasedTaggingOnly.value && selectedLotNumber.value == null) {
        // Open lot dialog first
        await openLotDialogInitial();
      } else {
        await openVendorDialog();
      }
    }
  }

  Future<void> openVendorDialog() async {
    if (isLotBasedTaggingOnly.value && selectedLotNumber.value == null) {
      showErrorToast(message: "Please select a lot first");
      await openLotDialogInitial();
      return;
    }
    employeeFocusNode.unfocus();
    qcyFocusNode.unfocus();
    // Force unfocus any current focus
    FocusManager.instance.primaryFocus?.unfocus();

    // Add a slight delay before showing dialog

    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }

    await Future.delayed(const Duration(milliseconds: 200));
    log("50 delay");
    await Get.dialog(
      VendorDialog(
        onVendorSelected: (String vendorId, String vendorCode) {
          setSelectedVendor(vendorId, vendorCode);
          log("Setting vendor values");
          Get.back();
        },
      ),
    );
    if (isFirstTime.value) {
      await openDesignDialog();
    }
    getLatestRowInFocus();
  }

  Future<void> openDesignDialog() async {
    await Get.dialog(
      DesignDialog(
        onDesignSelected: (GetDesignResponseModel selectedDesign) {
          setSelectedDesign(selectedDesign);
          int index = itemDetailsController.controllers.length - 1;
          itemDetailsController.setDesignId(index, selectedDesign.code ?? "");

          updateAvailableSizes();
          updateAvailablePurities();
          Get.back();
        },
      ),
    );

    await handleSizeSelection();
    getLatestRowInFocus();
  }

  Future<void> openSizeDialog() async {
    if (selectedDesign.value != null) {
      // Unfocus any current focus
      FocusManager.instance.primaryFocus?.unfocus();
      if (Get.context != null) {
        FocusScope.of(Get.context!).unfocus();
      }

      // Add delay before showing dialog
      await Future.delayed(const Duration(milliseconds: 200));

      await Get.dialog(
        SizeDialog(
          onSizeSelected: (String sizeId, String sizeName) {
            setSelectedSize(sizeId, sizeName);
            Get.back();
          },
        ),
      );
    } else {
      Get.snackbar('Error', 'Please select a design first');
    }
    await handlePuritySelection();
    getLatestRowInFocus();
  }

  Future<void> openPurityDialog() async {
    await Get.dialog(
      PurityDialog(
        onPuritySelected: (String selectedPurity) {
          setSelectedPurity(selectedPurity);
          Get.back();
        },
      ),
    );
    if (isFirstTime.value) {
      await openSettingsDialog();
    }
    getLatestRowInFocus();
  }

  // Helper method to handle size selection logic
  Future<void> handleSizeSelection() async {
    // If no sizes available, skip this step
    if (availableSizes.isEmpty) {
      log("Skipped size selection (Empty)");
      await handlePuritySelection();
      return;
    }

    // If there's exactly one size, select it automatically
    if (availableSizes.length == 1) {
      final singleSize = availableSizes.first;
      setSelectedSize(singleSize.id, singleSize.size);
      log("Auto-selected single size: ${singleSize.size}");
      await handlePuritySelection();
      return;
    }

    // Otherwise, show the size dialog (only on first time)
    if (isFirstTime.value) {
      await openSizeDialog();
    } else {
      // For non-first time, continue to purity selection
      await handlePuritySelection();
    }
  }

  // Helper method to handle purity selection logic
  Future<void> handlePuritySelection() async {
    // If no purities available, skip this step
    if (purityList.isEmpty) {
      if (isFirstTime.value) {
        await openSettingsDialog();
      }

      log("Skipped purity selection (Empty)");
      getLatestRowInFocus();
      return;
    }

    // If there's exactly one purity, select it automatically
    if (purityList.length == 1) {
      final singlePurity = purityList.first;
      setSelectedPurity(singlePurity);
      log("Auto-selected single purity: $singlePurity");
      if (isFirstTime.value) {
        await openSettingsDialog();
      }
      getLatestRowInFocus();
      return;
    }

    // Otherwise, show the purity dialog (only on first time)
    if (isFirstTime.value) {
      await openPurityDialog();
    } else {
      getLatestRowInFocus();
    }
  }

  void getLatestRowInFocus() {
    int length = itemDetailsController.controllers.length;
    itemDetailsController.controllers
        .elementAt(length - 1)
        .tableFocusNodes[2]
        .requestFocus();
    itemDetailsController.currentColIndex.value = 2;
  }

  Future<void> openSettingsDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }

    await Future.delayed(const Duration(milliseconds: 200));
    await Get.dialog(const SettingsDialog(), barrierDismissible: false);
    isFirstTime.value = false;
    await Future.delayed(const Duration(milliseconds: 100));

    getLatestRowInFocus();
  }

  final Rx<GetLotEntriesDropdownValue?> selectedLotNumber =
      Rx<GetLotEntriesDropdownValue?>(null);

  void setSelectedLotNumber(GetLotEntriesDropdownValue? lotNo) {
    selectedLotNumber.value = lotNo;
    // If a lot is selected with vendor information, automatically set the vendor
    if (lotNo != null && lotNo.vendorId != null) {
      // Check if current vendor doesn't match lot vendor
      if (selectedVendorId.value != lotNo.vendorId) {
        // Find vendor in vendor list

        setSelectedVendor(lotNo.vendorId!, lotNo.vendorCode ?? '');
        showSuccessToast(message: 'Vendor set to match the selected lot');
      }

      // Reset purity if it's not in the lot's purity types
      if (selectedPurity.value != null &&
          lotNo.purityTypes != null &&
          lotNo.purityTypes!.isNotEmpty &&
          !lotNo.purityTypes!.contains(selectedPurity.value)) {
        selectedPurity.value = null;
        showErrorToast(message: 'Previous purity is not available in this lot');
      }
    }
  }

  Future<void> openLotDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 50));

    await Get.dialog(
      LotEntryDropdownDialog(
        onLotSelected: (GetLotEntriesDropdownValue? lotNo) {
          setSelectedLotNumber(lotNo);
          Get.back();
        },
      ),
    );
    getLatestRowInFocus();
  }

  bool validateAgainstSelectedLot() {
    if (selectedLotNumber.value == null) {
      return true; // No lot selected, no validation needed
    }

    List<String> errors = [];

    // Validate vendor
    if (selectedVendorId.value != null &&
        selectedLotNumber.value?.vendorId != null &&
        selectedVendorId.value != selectedLotNumber.value?.vendorId) {
      errors.add('Selected vendor does not match the lot\'s vendor');
    }

    // Validate purity
    if (selectedPurity.value != null &&
        selectedLotNumber.value?.purityTypes != null &&
        selectedLotNumber.value!.purityTypes!.isNotEmpty &&
        !selectedLotNumber.value!.purityTypes!.contains(selectedPurity.value)) {
      errors.add('Selected purity is not available in the lot');
    }

    if (errors.isNotEmpty) {
      for (var error in errors) {
        showErrorToast(message: error);
      }
      return false;
    }

    return true;
  }
}
