import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/create_vendor_poc_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_paginated_vedor_poc_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/order_assign_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view_model/order_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AssignedToController extends GetxController {
  final VendorRepository _vendorRepository = VendorRepository();
  final AggregateRepository _aggregateRepository = AggregateRepository();

  // Changed from GetVendorByIdResponse to GetPaginatedVendorPocValue
  final selectedVendors = <GetPaginatedVendorPocValue>[].obs;
  final vendorSearchController = TextEditingController().obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Store current order details
  String? currentOrderLineItemId;
  String? currentOrderNumber;
  String? currentOrnamentName;
  double? currentGrossWeight;
  double? currentNetWeight;
  double? currentPieces;

  // Updated to use the new response type
  final getVendorListingDetailsResponse =
      Rx<ApiResponse<GetPaginatedVendorPocResponse>>(
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

  // Loading state for adding vendor
  final isAddingVendor = false.obs;

  // Updated to use GetPaginatedVendorPocValue
  void setSelectedVendors(List<GetPaginatedVendorPocValue> vendors) {
    selectedVendors.value = vendors;
    // Changed from name to fullName
    vendorSearchController.value.text = vendors
        .map((v) => v.fullName ?? '')
        .join(', ');
  }

  void setOrderDetails({
    required String orderLineItemId,
    required String orderNumber,
    required String ornamentName,
    required double grossWeight,
    required double netWeight,
    required double pieces,
  }) {
    currentOrderLineItemId = orderLineItemId;
    currentOrderNumber = orderNumber;
    currentOrnamentName = ornamentName;
    currentGrossWeight = grossWeight;
    currentNetWeight = netWeight;
    currentPieces = pieces;
  }

  Future<bool> assignOrderToVendors() async {
    if (selectedVendors.isEmpty || currentOrderLineItemId == null) {
      showErrorToast(
        message: "Please select vendors and ensure order details are available",
      );
      return false;
    }

    isAssigning.value = true;

    try {
      final request = OrderAssignRequest(
        orderLineItemId: currentOrderLineItemId,
        assignedUserId: selectedVendors.map((vendor) => vendor.id!).toList(),
        orderNumber: currentOrderNumber,
        ornamentName: currentOrnamentName,
        grossWeight: currentGrossWeight,
        netWeight: currentNetWeight,
        pieces: currentPieces,
      );

      await _aggregateRepository.assignOrderToVendor(
        order_assign_request: request,
        order_line_item_id: currentOrderLineItemId!,
      );

      showSuccessToast(message: "Order successfully assigned to vendors");
      OrderListingViewModel orderListingViewModel = Get.find();
      orderListingViewModel.getOrdersListing(resetList: true);
      Get.back();

      return true;
    } catch (e) {
      showErrorToast(message: e.toString());
      return false;
    } finally {
      isAssigning.value = false;
    }
  }

  // Add new vendor method
  Future<void> addNewVendor(CreateVendorPocRequest vendorDataPoc) async {
    isAddingVendor.value = true;

    try {
      // Create vendor request object
      // Note: You'll need to adjust this based on your actual API requirements
      final vendorData = CreateVendorPocRequest(
        phoneNumber: vendorDataPoc.phoneNumber,
        fullName: vendorDataPoc.fullName,
        vendorPocCode: vendorDataPoc.vendorPocCode,
        vendorPocEmail: vendorDataPoc.vendorPocEmail,
      );

      await _vendorRepository.createVendorPoc(vendorData);

      showSuccessToast(message: "Vendor added successfully");

      // Close the add vendor dialog
      Get.back();

      // Refresh the vendor list to include the new vendor
      await getVendorListingDetails(resetList: true);
    } catch (e) {
      showErrorToast(message: "Failed to add vendor: ${e.toString()}");
    } finally {
      isAddingVendor.value = false;
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
      final response = await _vendorRepository.getVendorListingPoc(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getVendorListingDetailsResponse.value = ApiResponse.completed(response);
      } else {
        final currentData =
            getVendorListingDetailsResponse.value.data?.values ?? [];
        List<GetPaginatedVendorPocValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getVendorListingDetailsResponse.value = ApiResponse.completed(response);
      }

      // Updated pagination logic to use 'next' field
      // hasMorePages.value = response.pagination?.next != null;
      // if (hasMorePages.value && response.values?.isNotEmpty == true) {
      //   if (response.pagination?.next != null) {
      //     lastOffsetId = response.pagination?.next;
      //   }
      // }
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
