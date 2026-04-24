import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';

class DropdownItem {
  final String? id;
  final String? name;

  DropdownItem({this.id, this.name});
}

class BaseFilterController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final VendorRepository vendorRepository = VendorRepository();
  final OrganizationRepository organizationRepository =
      OrganizationRepository();

  // Common filter response data
  final Rx<ApiResponse<List<DropdownItem>>> metalTypeResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> ornamentResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> stockHeadResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> counterResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> purityResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> designResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> weightGroupResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> vendorResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> taggedByResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> branchResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> sizeResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  final Rx<ApiResponse<List<DropdownItem>>> statusResponse =
      Rx<ApiResponse<List<DropdownItem>>>(ApiResponse.initial("Initial"));
  List<DropdownItem> get itemStatusList =>
      ItemStatusEnum.values
          .map((e) => DropdownItem(id: e.value, name: e.value))
          .toList();

  List<DropdownItem> get paymentStatusList =>
      PaymentStatusEnum.values
          .map((e) => DropdownItem(id: e.value, name: e.value))
          .toList();

  List<DropdownItem> get invoiceStatusList =>
      InvoiceStatusEnum.values
          .map((e) => DropdownItem(id: e.value, name: e.value))
          .toList();

  List<DropdownItem> get transactionTypesList =>
      TransactionTypeEnum.values
          .map((e) => DropdownItem(id: e.value, name: e.value))
          .toList();

  List<DropdownItem> get otherList =>
      OtherEnum.values
          .map((e) => DropdownItem(id: e.value, name: "Hide Null"))
          .toList();

  // Changed from single selected values to lists for multi-select
  final RxList<DropdownItem> selectedMetalTypes = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedOrnaments = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedStockHeads = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedCounters = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedPurities = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedDesigns = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedWeightGroups = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedVendors = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedTaggedBys = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedBranches = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedSizes = <DropdownItem>[].obs;
  final RxList<DropdownItem> selectedStatuses = <DropdownItem>[].obs;

  List<DropdownItem> get selectedItemStatuses {
    final value = selectedItemStatus.value;
    if (value == null) return const [];
    return [DropdownItem(id: value.value, name: value.value)];
  }

  List<DropdownItem> get selectedPaymentStatuses {
    final value = selectedPaymentStatus.value;
    if (value == null) return const [];
    return [DropdownItem(id: value.value, name: value.value)];
  }

  List<DropdownItem> get selectedInvoiceStatuses {
    final value = selectedInvoiceStatus.value;
    if (value == null) return const [];
    return [DropdownItem(id: value.value, name: value.value)];
  }

  List<DropdownItem> get selectedTransactionTypeses {
    final value = selectedTransactionTypes.value;
    if (value == null) return const [];
    return [DropdownItem(id: value.value, name: value.value)];
  }

  List<DropdownItem> get selectedOthers {
    final value = selectedOther.value;
    if (value == null) return const [];
    return [DropdownItem(id: value.value, name: "Hide Null")];
  }

  // enum filters as
  final Rx<PaymentStatusEnum?> selectedPaymentStatus = Rx<PaymentStatusEnum?>(
    null,
  );
  final Rx<ItemStatusEnum?> selectedItemStatus = Rx<ItemStatusEnum?>(null);
  final Rx<InvoiceStatusEnum?> selectedInvoiceStatus = Rx<InvoiceStatusEnum?>(
    null,
  );
  final Rx<TransactionTypeEnum?> selectedTransactionTypes =
      Rx<TransactionTypeEnum?>(null);
  final Rx<OtherEnum?> selectedOther = Rx<OtherEnum?>(null);

  // Keep single value references for backward compatibility (will be deprecated)
  final Rx<DropdownItem?> selectedMetalType = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedOrnament = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedStockHead = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedCounter = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedPurity = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedDesign = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedWeightGroup = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedVendor = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedTaggedBy = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedBranch = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedSize = Rx<DropdownItem?>(null);
  final Rx<DropdownItem?> selectedStatus = Rx<DropdownItem?>(null);

  // Weight range values
  final Rx<int?> minGrossWeight = Rx<int?>(null);
  final Rx<int?> maxGrossWeight = Rx<int?>(null);
  final Rx<int?> minNetWeight = Rx<int?>(null);
  final Rx<int?> maxNetWeight = Rx<int?>(null);
  final Rx<String?> minPendingAmount = Rx<String?>(null);
  final Rx<String?> maxPendingAmount = Rx<String?>(null);
  final Rx<DateTime?> dateFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> dateTo = Rx<DateTime?>(null);

  final Rx<String?> minRecordNumber = Rx<String?>(null);
  final Rx<String?> maxRecordNumber = Rx<String?>(null);

  final Rx<String?> minLotNumber = Rx<String?>(null);
  final Rx<String?> maxLotNumber = Rx<String?>(null);

  final Rx<bool> inclusiveGrossWeight = Rx<bool>(false);
  final Rx<bool> inclusiveAmount = Rx<bool>(false);

  // Fetch methods for each filter type
  Future<void> fetchAllDropdownData({List<String>? filterTypes}) async {
    final filterSet = filterTypes?.toSet() ?? <String>{};

    // Only fetch data for specified filter types, or all if not specified
    if (filterTypes == null || filterSet.contains('metalType')) {
      await getMetalTypes();
    }
    if (filterTypes == null || filterSet.contains('ornament')) {
      await getOrnaments();
    }
    if (filterTypes == null || filterSet.contains('weightGroup')) {
      await getWeightGroups();
    }
    if (filterTypes == null || filterSet.contains('stockHead')) {
      await getStockHeads();
    }
    if (filterTypes == null || filterSet.contains('design')) {
      await getDesigns();
    }
    if (filterTypes == null || filterSet.contains('purity')) {
      await getPurities();
    }
    if (filterTypes == null || filterSet.contains('counter')) {
      await getCounters();
    }
    if (filterTypes == null || filterSet.contains('vendor')) {
      await getVendors();
    }
    if (filterTypes == null || filterSet.contains('taggedBy')) {
      await getTaggedByEmployees();
    }
    if (filterTypes == null || filterSet.contains('branch')) {
      await getBranches();
    }
    if (filterTypes == null || filterSet.contains('status')) {
      await getStatuses();
    }
  }

  // Multi-select toggle methods
  void toggleMetalType(DropdownItem item) {
    if (selectedMetalTypes.any((element) => element.id == item.id)) {
      selectedMetalTypes.removeWhere((element) => element.id == item.id);
    } else {
      selectedMetalTypes.add(item);
    }
    // Update single value for backward compatibility
    selectedMetalType.value =
        selectedMetalTypes.isNotEmpty ? selectedMetalTypes.first : null;
  }

  void toggleOrnament(DropdownItem item) {
    if (selectedOrnaments.any((element) => element.id == item.id)) {
      selectedOrnaments.removeWhere((element) => element.id == item.id);
    } else {
      selectedOrnaments.add(item);
    }
    selectedOrnament.value =
        selectedOrnaments.isNotEmpty ? selectedOrnaments.first : null;
  }

  void toggleStockHead(DropdownItem item) {
    if (selectedStockHeads.any((element) => element.id == item.id)) {
      selectedStockHeads.removeWhere((element) => element.id == item.id);
    } else {
      selectedStockHeads.add(item);
    }
    selectedStockHead.value =
        selectedStockHeads.isNotEmpty ? selectedStockHeads.first : null;
  }

  void toggleCounter(DropdownItem item) {
    if (selectedCounters.any((element) => element.id == item.id)) {
      selectedCounters.removeWhere((element) => element.id == item.id);
    } else {
      selectedCounters.add(item);
    }
    selectedCounter.value =
        selectedCounters.isNotEmpty ? selectedCounters.first : null;
  }

  void togglePurity(DropdownItem item) {
    if (selectedPurities.any((element) => element.id == item.id)) {
      selectedPurities.removeWhere((element) => element.id == item.id);
    } else {
      selectedPurities.add(item);
    }
    selectedPurity.value =
        selectedPurities.isNotEmpty ? selectedPurities.first : null;
  }

  void toggleDesign(DropdownItem item) {
    if (selectedDesigns.any((element) => element.id == item.id)) {
      selectedDesigns.removeWhere((element) => element.id == item.id);
    } else {
      selectedDesigns.add(item);
    }
    selectedDesign.value =
        selectedDesigns.isNotEmpty ? selectedDesigns.first : null;
  }

  void toggleWeightGroup(DropdownItem item) {
    if (selectedWeightGroups.any((element) => element.id == item.id)) {
      selectedWeightGroups.removeWhere((element) => element.id == item.id);
    } else {
      selectedWeightGroups.add(item);
    }
    selectedWeightGroup.value =
        selectedWeightGroups.isNotEmpty ? selectedWeightGroups.first : null;
  }

  void toggleVendor(DropdownItem item) {
    if (selectedVendors.any((element) => element.id == item.id)) {
      selectedVendors.removeWhere((element) => element.id == item.id);
    } else {
      selectedVendors.add(item);
    }
    selectedVendor.value =
        selectedVendors.isNotEmpty ? selectedVendors.first : null;
  }

  void toggleTaggedBy(DropdownItem item) {
    if (selectedTaggedBys.any((element) => element.id == item.id)) {
      selectedTaggedBys.removeWhere((element) => element.id == item.id);
    } else {
      selectedTaggedBys.add(item);
    }
    selectedTaggedBy.value =
        selectedTaggedBys.isNotEmpty ? selectedTaggedBys.first : null;
  }

  void toggleBranch(DropdownItem item) {
    if (selectedBranches.any((element) => element.id == item.id)) {
      selectedBranches.removeWhere((element) => element.id == item.id);
    } else {
      selectedBranches.add(item);
    }
    selectedBranch.value =
        selectedBranches.isNotEmpty ? selectedBranches.first : null;
  }

  void toggleSize(DropdownItem item) {
    if (selectedSizes.any((element) => element.id == item.id)) {
      selectedSizes.removeWhere((element) => element.id == item.id);
    } else {
      selectedSizes.add(item);
    }
    selectedSize.value = selectedSizes.isNotEmpty ? selectedSizes.first : null;
  }

  void toggleStatus(DropdownItem item) {
    if (selectedStatuses.any((element) => element.id == item.id)) {
      selectedStatuses.removeWhere((element) => element.id == item.id);
    } else {
      selectedStatuses.add(item);
    }
    selectedStatus.value =
        selectedStatuses.isNotEmpty ? selectedStatuses.first : null;
  }

  // Legacy setter methods for backward compatibility
  void setMetalType(String? value) {
    selectedMetalTypes.clear();
    if (value != null) {
      final item = metalTypeResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedMetalTypes.add(item!);
        selectedMetalType.value = item;
      }
    } else {
      selectedMetalType.value = null;
    }
  }

  void setOrnament(String? value) {
    selectedOrnaments.clear();
    if (value != null) {
      final item = ornamentResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedOrnaments.add(item!);
        selectedOrnament.value = item;
      }
    } else {
      selectedOrnament.value = null;
    }
  }

  void setWeightGroup(String? value) {
    selectedWeightGroups.clear();
    if (value != null) {
      final item = weightGroupResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedWeightGroups.add(item!);
        selectedWeightGroup.value = item;
      }
    } else {
      selectedWeightGroup.value = null;
    }
  }

  void setStockHead(String? value) {
    selectedStockHeads.clear();
    if (value != null) {
      final item = stockHeadResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedStockHeads.add(item!);
        selectedStockHead.value = item;
      }
    } else {
      selectedStockHead.value = null;
    }
  }

  void setDesign(String? value) {
    selectedDesigns.clear();
    if (value != null) {
      final item = designResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedDesigns.add(item!);
        selectedDesign.value = item;
      }
    } else {
      selectedDesign.value = null;
    }
  }

  void setPurity(String? value) {
    selectedPurities.clear();
    if (value != null) {
      final item = purityResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedPurities.add(item!);
        selectedPurity.value = item;
      }
    } else {
      selectedPurity.value = null;
    }
  }

  void setCounter(String? value) {
    selectedCounters.clear();
    if (value != null) {
      final item = counterResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedCounters.add(item!);
        selectedCounter.value = item;
      }
    } else {
      selectedCounter.value = null;
    }
  }

  void setVendor(String? value) {
    selectedVendors.clear();
    if (value != null) {
      final item = vendorResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedVendors.add(item!);
        selectedVendor.value = item;
      }
    } else {
      selectedVendor.value = null;
    }
  }

  void setTaggedBy(String? value) {
    selectedTaggedBys.clear();
    if (value != null) {
      final item = taggedByResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedTaggedBys.add(item!);
        selectedTaggedBy.value = item;
      }
    } else {
      selectedTaggedBy.value = null;
    }
  }

  void setBranch(String? value) {
    selectedBranches.clear();
    if (value != null) {
      final item = branchResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedBranches.add(item!);
        selectedBranch.value = item;
      }
    } else {
      selectedBranch.value = null;
    }
  }

  void setSize(String? value) {
    selectedSizes.clear();
    if (value != null) {
      final item = sizeResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedSizes.add(item!);
        selectedSize.value = item;
      }
    } else {
      selectedSize.value = null;
    }
  }

  void setStatus(String? value) {
    selectedStatuses.clear();
    if (value != null) {
      final item = statusResponse.value.data?.firstWhere(
        (item) => item.id == value,
        orElse: () => DropdownItem(),
      );
      if (item?.id != null) {
        selectedStatuses.add(item!);
        selectedStatus.value = item;
      }
    } else {
      selectedStatus.value = null;
    }
  }

  // Enum Filters - Single select with proper toggle
  void toggleItemStatus(String? value) {
    if (value == null) return;
    final status = ItemStatusEnum.fromValue(value);
    if (status == null) return;

    // If clicking the same value, deselect it. Otherwise select the new value
    if (selectedItemStatus.value?.value == value) {
      selectedItemStatus.value = null;
    } else {
      selectedItemStatus.value = status;
    }
    selectedItemStatus.refresh(); // Force notification to observers
    log("Toggled ItemStatus to: ${selectedItemStatus.value?.value}");
  }

  void togglePaymentStatus(String? value) {
    if (value == null) return;
    final status = PaymentStatusEnum.fromValue(value);
    if (status == null) return;

    if (selectedPaymentStatus.value?.value == value) {
      selectedPaymentStatus.value = null;
    } else {
      selectedPaymentStatus.value = status;
    }
    selectedPaymentStatus.refresh(); // Force notification to observers
    log("Toggled PaymentStatus to: ${selectedPaymentStatus.value?.value}");
  }

  void toggleInvoiceStatus(String? value) {
    if (value == null) return;
    final status = InvoiceStatusEnum.fromValue(value);
    if (status == null) return;

    if (selectedInvoiceStatus.value?.value == value) {
      selectedInvoiceStatus.value = null;
    } else {
      selectedInvoiceStatus.value = status;
    }
    selectedInvoiceStatus.refresh(); // Force notification to observers
    log("Toggled InvoiceStatus to: ${selectedInvoiceStatus.value?.value}");
  }

  void toggleTransactionTypes(String? value) {
    if (value == null) return;
    final status = TransactionTypeEnum.fromValue(value);
    if (status == null) return;

    if (selectedTransactionTypes.value?.value == value) {
      selectedTransactionTypes.value = null;
    } else {
      selectedTransactionTypes.value = status;
    }
    selectedTransactionTypes.refresh(); // Force notification to observers
    log("Toggled TransactionType to: ${selectedTransactionTypes.value?.value}");
  }

  void toggleOther(String? value) {
    if (value == null) return;

    final status = OtherEnum.fromValue(value);
    if (status == null) return;

    if (selectedOther.value?.value == value) {
      selectedOther.value = null;
    } else {
      selectedOther.value = status;
    }

    selectedOther.refresh();
    log("Toggled Other: ${selectedOther.value?.value}");
  }

  void setGrossWeightRange(int? min, int? max) {
    minGrossWeight.value = min;
    maxGrossWeight.value = max;
    log("Setting Gross Weight Range: min=$min, max=$max");
  }

  void setNetWeightRange(int? min, int? max) {
    minNetWeight.value = min;
    maxNetWeight.value = max;
    log("Setting Net Weight Range: min=$min, max=$max");
  }

  void setPendingAmountRange(String? min, String? max) {
    minPendingAmount.value = min;
    maxPendingAmount.value = max;
    log("Setting Gross Weight Range: min=$min, max=$max");
  }

  void setDateRange(DateTime? from, DateTime? to) {
    dateFrom.value = from;
    dateTo.value = to;
    log("Setting Date Range: from=$from, to=$to");
  }

  void setRecordNumberRange(String? min, String? max) {
    minRecordNumber.value = min;
    maxRecordNumber.value = max;
    log("Setting Record Number Range: min=$min, max=$max");
  }

  void setLotNumberRange(String? min, String? max) {
    minLotNumber.value = min;
    maxLotNumber.value = max;
    log("Setting Lot Number Range: min=$min, max=$max");
  }

  void setInclusiveGrossWeight(bool value) {
    inclusiveGrossWeight.value = value;
    log("Setting Inclusive Gross Weight: $value");
  }

  void setInclusiveAmount(bool value) {
    inclusiveAmount.value = value;
    log("Setting Inclusive Amount: $value");
  }

  void setItemStatus(String? value) {
    if (value == null) {
      selectedItemStatus.value = null;
    } else {
      selectedItemStatus.value = ItemStatusEnum.fromValue(value);
    }
    selectedItemStatus.refresh(); // Ensure value is broadcast to observers
    log("Set ItemStatus: ${selectedItemStatus.value?.value}");
  }

  void setPaymentStatus(String? value) {
    if (value == null) {
      selectedPaymentStatus.value = null;
    } else {
      selectedPaymentStatus.value = PaymentStatusEnum.fromValue(value);
    }
    selectedPaymentStatus.refresh(); // Ensure value is broadcast to observers
    log("Set PaymentStatus: ${selectedPaymentStatus.value?.value}");
  }

  void setInvoiceStatus(String? value) {
    if (value == null) {
      selectedInvoiceStatus.value = null;
    } else {
      selectedInvoiceStatus.value = InvoiceStatusEnum.fromValue(value);
    }
    selectedInvoiceStatus.refresh(); // Ensure value is broadcast to observers
    log("Set InvoiceStatus: ${selectedInvoiceStatus.value?.value}");
  }

  void setTransactionTypes(String? value) {
    if (value == null) {
      selectedTransactionTypes.value = null;
    } else {
      selectedTransactionTypes.value = TransactionTypeEnum.fromValue(value);
    }
    selectedTransactionTypes
        .refresh(); // Ensure value is broadcast to observers
    log("Set InvoiceStatus: ${selectedTransactionTypes.value?.value}");
  }

  void setOther(String? value) {
    if (value == null) {
      selectedOther.value = null;
    } else {
      selectedOther.value = OtherEnum.fromValue(value);
    }

    selectedOther.refresh();
    log("Set Other: ${selectedOther.value?.value}");
  }

  // Reset all filters
  void resetAllFilters() {
    // Clear all multi-select lists
    selectedMetalTypes.clear();
    selectedOrnaments.clear();
    selectedWeightGroups.clear();
    selectedStockHeads.clear();
    selectedDesigns.clear();
    selectedPurities.clear();
    selectedCounters.clear();
    selectedVendors.clear();
    selectedTaggedBys.clear();
    selectedBranches.clear();
    selectedSizes.clear();
    selectedStatuses.clear();

    // Clear single values
    selectedMetalType.value = null;
    selectedOrnament.value = null;
    selectedWeightGroup.value = null;
    selectedStockHead.value = null;
    selectedDesign.value = null;
    selectedPurity.value = null;
    selectedCounter.value = null;
    selectedVendor.value = null;
    selectedTaggedBy.value = null;
    selectedBranch.value = null;
    selectedSize.value = null;
    selectedStatus.value = null;
    selectedItemStatus.value = null;
    selectedInvoiceStatus.value = null;
    selectedPaymentStatus.value = null;
    selectedTransactionTypes.value = null;
    selectedOther.value = null;
    minGrossWeight.value = null;
    maxGrossWeight.value = null;
    minPendingAmount.value = null;
    maxPendingAmount.value = null;
    minNetWeight.value = null;
    maxNetWeight.value = null;
    dateFrom.value = null;
    dateTo.value = null;
    minRecordNumber.value = null;
    maxRecordNumber.value = null;
    minLotNumber.value = null;
    maxLotNumber.value = null;

    inclusiveGrossWeight.value = false;
    inclusiveAmount.value = false;
  }

  // Individual data fetching methods
  Future<void> getMetalTypes() async {
    try {
      metalTypeResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getStockHeadMetalTypes();
      final dropdownItems =
          response
              .map((item) => DropdownItem(id: item.id, name: item.typeName))
              .toList();
      // Remove the "All" option as we're now using multi-select
      metalTypeResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      metalTypeResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getOrnaments() async {
    try {
      ornamentResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getOrnamentDropdown(
        limit: 300,
      );
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map((item) => DropdownItem(id: item.id, name: item.name))
              .toList();
      // Remove the "All" option as we're now using multi-select
      ornamentResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      ornamentResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getWeightGroups() async {
    try {
      weightGroupResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getWeightGroupDropdown(
        limit: 300,
      );
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map(
                (item) => DropdownItem(
                  id: item.id,
                  name: "${item.code} - ${item.name}",
                ),
              )
              .toList();
      weightGroupResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      weightGroupResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getStockHeads() async {
    try {
      stockHeadResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getStockHeadsDropdown(
        limit: 300,
      );
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map((item) => DropdownItem(id: item.id, name: item.name))
              .toList();
      stockHeadResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      stockHeadResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getDesigns() async {
    try {
      designResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getDesignDropdown(limit: 300);
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map((item) => DropdownItem(id: item.id, name: item.name))
              .toList();
      designResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      designResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getPurities() async {
    try {
      purityResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getAllPurityTypes();
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map((item) => DropdownItem(id: item, name: item))
              .toList();
      purityResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      purityResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getCounters() async {
    try {
      counterResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getCounterListing(limit: 500);
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map((item) => DropdownItem(id: item.id, name: item.counterName))
              .toList();
      counterResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      counterResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getVendors() async {
    try {
      vendorResponse.value = ApiResponse.loading("Loading");
      final response = await vendorRepository.getVendorDropdown(limit: 300);
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map((item) => DropdownItem(id: item.id, name: item.name))
              .toList();
      vendorResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      vendorResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getTaggedByEmployees() async {
    try {
      taggedByResponse.value = ApiResponse.loading("Loading");
      final response = await organizationRepository.getEmployeeDropdown();
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map((item) => DropdownItem(id: item.id, name: item.name))
              .toList();
      taggedByResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      taggedByResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getBranches() async {
    try {
      branchResponse.value = ApiResponse.loading("Loading");
      final response = await organizationRepository.getBranchesDropdown();
      final listOfResponse = response.values ?? [];
      final dropdownItems =
          listOfResponse
              .map((item) => DropdownItem(id: item.id, name: item.branchName))
              .toList();
      branchResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      branchResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getStatuses() async {
    try {
      statusResponse.value = ApiResponse.loading("Loading");

      // Call the repository method to get actual status data from API
      final response = await inventoryRepository.getStatusDropdown();

      // Convert StatusItem list to DropdownItem list
      final dropdownItems =
          response
              .map(
                (item) => DropdownItem(
                  id: item.id,
                  name: item.status, // Using 'status' field as the display name
                ),
              )
              .toList();

      statusResponse.value = ApiResponse.completed(dropdownItems);
    } catch (e) {
      statusResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Helper method to get all loading states
  bool get isAnyFilterLoading {
    return metalTypeResponse.value.status == Status.LOADING ||
        ornamentResponse.value.status == Status.LOADING ||
        stockHeadResponse.value.status == Status.LOADING ||
        counterResponse.value.status == Status.LOADING ||
        purityResponse.value.status == Status.LOADING ||
        designResponse.value.status == Status.LOADING ||
        weightGroupResponse.value.status == Status.LOADING ||
        vendorResponse.value.status == Status.LOADING ||
        taggedByResponse.value.status == Status.LOADING ||
        branchResponse.value.status == Status.LOADING ||
        sizeResponse.value.status == Status.LOADING ||
        statusResponse.value.status == Status.LOADING;
  }

  // Helper methods to check if any item is selected in a category
  bool isMetalTypeSelected(String? id) {
    if (id == null) return false;
    return selectedMetalTypes.any((item) => item.id == id);
  }

  bool isOrnamentSelected(String? id) {
    if (id == null) return false;
    return selectedOrnaments.any((item) => item.id == id);
  }

  bool isStockHeadSelected(String? id) {
    if (id == null) return false;
    return selectedStockHeads.any((item) => item.id == id);
  }

  bool isCounterSelected(String? id) {
    if (id == null) return false;
    return selectedCounters.any((item) => item.id == id);
  }

  bool isPuritySelected(String? id) {
    if (id == null) return false;
    return selectedPurities.any((item) => item.id == id);
  }

  bool isDesignSelected(String? id) {
    if (id == null) return false;
    return selectedDesigns.any((item) => item.id == id);
  }

  bool isWeightGroupSelected(String? id) {
    if (id == null) return false;
    return selectedWeightGroups.any((item) => item.id == id);
  }

  bool isVendorSelected(String? id) {
    if (id == null) return false;
    return selectedVendors.any((item) => item.id == id);
  }

  bool isTaggedBySelected(String? id) {
    if (id == null) return false;
    return selectedTaggedBys.any((item) => item.id == id);
  }

  bool isBranchSelected(String? id) {
    if (id == null) return false;
    return selectedBranches.any((item) => item.id == id);
  }

  bool isSizeSelected(String? id) {
    if (id == null) return false;
    return selectedSizes.any((item) => item.id == id);
  }

  bool isStatusSelected(String? id) {
    if (id == null) return false;
    return selectedStatuses.any((item) => item.id == id);
  }

  // Helper methods for enum filters
  bool isItemStatusSelected(String? id) {
    if (id == null) return false;
    return selectedItemStatus.value?.value == id;
  }

  bool isPaymentStatusSelected(String? id) {
    if (id == null) return false;
    return selectedPaymentStatus.value?.value == id;
  }

  bool isInvoiceStatusSelected(String? id) {
    if (id == null) return false;
    return selectedInvoiceStatus.value?.value == id;
  }

  bool isTransactionTypesSelected(String? id) {
    if (id == null) return false;
    return selectedTransactionTypes.value?.value == id;
  }
}
