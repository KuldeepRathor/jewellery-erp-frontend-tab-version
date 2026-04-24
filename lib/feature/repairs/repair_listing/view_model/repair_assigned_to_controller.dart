import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/repair_assign_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_listing/models/pagination_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class RepairAssignedToController extends GetxController {
  final VendorRepository _vendorRepository = VendorRepository();
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final selectedVendors = <GetVendorByIdResponse>[].obs;
  final vendorSearchController = TextEditingController().obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Store current repair details
  String? currentRepairLineItemId;
  String? currentOrderNumber;
  String? currentOrnamentName;
  double? currentGrossWeight;
  double? currentNetWeight;
  double? currentPieces;

  final getVendorListingDetailsResponse =
      Rx<ApiResponse<PaginatedGetVendorListingDetailsResponse>>(
        ApiResponse.initial("Initial"),
      );

  // Pagination variables
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  final searchQuery = ''.obs;

  // Loading state for assign operation
  final isAssigning = false.obs;

  void setSelectedVendors(List<GetVendorByIdResponse> vendors) {
    selectedVendors.value = vendors;
    vendorSearchController.value.text = vendors
        .map((v) => v.name ?? '')
        .join(', ');
  }

  void setRepairDetails({
    required String repairLineItemId,
    required String repairNumber,
    required String ornamentName,
    required double grossWeight,
    required double netWeight,
    required double pieces,
  }) {
    currentRepairLineItemId = repairLineItemId;
    currentOrderNumber = repairNumber;
    currentOrnamentName = ornamentName;
    currentGrossWeight = grossWeight;
    currentNetWeight = netWeight;
    currentPieces = pieces;
  }

  Future<bool> assignOrderToVendors() async {
    if (selectedVendors.isEmpty || currentRepairLineItemId == null) {
      Get.snackbar(
        'Error',
        'Please select vendors and ensure repair details are available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isAssigning.value = true;

    try {
      final request = RepairAssignRequest(
        repairLineItemId: currentRepairLineItemId,
        assignedUserId: selectedVendors.map((vendor) => vendor.id!).toList(),
        repairNumber: currentOrderNumber,
        ornamentName: currentOrnamentName,
        grossWeight: currentGrossWeight,
        netWeight: currentNetWeight,
        pieces: currentPieces,
      );

      await _aggregateRepository.assignRepairToVendor(
        repair_assign_request: request,
        repair_line_item_id: currentRepairLineItemId!,
      );
      showSuccessToast(message: "Order successfully assigned to vendors");
      Get.back();

      return true;
    } catch (e) {
      showErrorToast(message: e.toString());

      return false;
    } finally {
      isAssigning.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getVendorListingDetails(resetList: true);
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getVendorListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getVendorListingDetailsResponse.value = ApiResponse.loading("loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _vendorRepository.getVendorListingDetails(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getVendorListingDetailsResponse.value = ApiResponse.completed(response);
      } else {
        final currentData =
            getVendorListingDetailsResponse.value.data?.values ?? [];
        List<GetVendorByIdResponse> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getVendorListingDetailsResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        getVendorListingDetailsResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getVendorListingDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getVendorListingDetails(resetList: true, isSearch: true);
    });
  }

  @override
  void onClose() {
    vendorSearchController.value.dispose();
    super.onClose();
  }
}
