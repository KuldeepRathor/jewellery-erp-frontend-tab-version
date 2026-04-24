import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view/widgets/check_sales_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view/widgets/check_tagging_item_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view_model/order_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class StatusController extends GetxController {
  final String initialStatus;
  final String orderId;
  final String? taggingLineItemId;

  StatusController({
    required this.initialStatus,
    required this.orderId,
    this.taggingLineItemId,
  });

  final EstimationRepository _repository = EstimationRepository();
  final InventoryRepository inventoryRepository = InventoryRepository();

  final Rx<GetTaggingLineItemCodeTagResponse?> taggingDetails =
      Rx<GetTaggingLineItemCodeTagResponse?>(null);
  final getSaleBySalesNumberResponse =
      Rx<ApiResponse<GetSalesRecordByIdAggregateResponse>>(
        ApiResponse.initial('Empty data'),
      );
  //   final Rx<GetTaggingLineItemCodeTagResponse?> salesDetails =
  // Rx<GetTaggingLineItemCodeTagResponse?>(null);
  final isLoadingTagging = false.obs;
  final isLoading = false.obs;
  final selectedStatus = ''.obs;

  late final FocusNode codeFocusNode;
  late final FocusNode tagNoFocusNode;
  late final FocusNode fetchButtonFocusNode;

  static final List<String> _statusOptions = [
    'Unassigned',
    'Assigned',
    'Ready',
    'Delivered',
    'Cancelled',
  ];

  List<String> get statusList => _statusOptions;

  late final TextEditingController statusController;
  late final TextEditingController tagNoController;

  late final TextEditingController salesNoController;
  late final TextEditingController codeController;
  late final FocusNode statusFocusNode;
  void _initializeControllers() {
    statusController = TextEditingController();
    tagNoController = TextEditingController();
    salesNoController = TextEditingController();

    codeController = TextEditingController();
    statusFocusNode = FocusNode();
    codeFocusNode = FocusNode();
    tagNoFocusNode = FocusNode();
    fetchButtonFocusNode = FocusNode();
  }

  String _normalizeStatus(String status) {
    String normalizedStatus = status.toLowerCase();

    switch (normalizedStatus) {
      case 'unassigned':
      case 'pending':
        return 'Unassigned';
      case 'in_progress':
      case 'assigned':
        return 'Assigned';
      case 'ready':
        return 'Ready';
      case 'delivered':
      case 'completed':
        return 'Delivered';
      case 'cancelled':
      case 'canceled':
        return 'Cancelled';
      default:
        return _statusOptions[0];
    }
  }

  String _denormalizeStatus(String status) {
    String apiStatus = status.toLowerCase();
    switch (apiStatus) {
      case 'unassigned':
        return 'Unassigned';
      case 'assigned':
        return 'Assigned';
      case 'ready':
        return 'Ready';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return apiStatus;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();

    final normalizedStatus = _normalizeStatus(initialStatus);
    selectedStatus.value = normalizedStatus;
    statusController.text = normalizedStatus;
    log('Initialized status to: $normalizedStatus from $initialStatus');
  }

  void setStatus(String status) {
    selectedStatus.value = status;
    statusController.text = status;
  }

  Future<void> handleStatusUpdate() async {
    final apiStatus = _denormalizeStatus(selectedStatus.value);
    log('Handling status update to: $apiStatus for order: $orderId');

    if (apiStatus.toLowerCase() == 'ready') {
      Get.back(closeOverlays: true);

      tagNoController.clear();
      codeController.clear();
      taggingDetails.value = null;

      // Show tagging dialog
      await Get.dialog(
        CheckTaggingItemDialog(orderId: orderId, status: apiStatus),
        barrierDismissible: false,
      );
    } else if (apiStatus.toLowerCase() == 'delivered') {
      Get.back(closeOverlays: true);

      salesNoController.clear();

      await Get.dialog(
        CheckSalesDetailsDialog(orderId: orderId, status: apiStatus),
        barrierDismissible: false,
      );
    } else {
      await updateStatus();
    }
  }

  Future<void> fetchTaggingDetails() async {
    int code = int.parse(codeController.text);
    if (tagNoController.text.isEmpty) {
      showErrorToast(message: 'Please enter TagNo number');
      return;
    }

    try {
      isLoadingTagging.value = true;
      final response = await inventoryRepository.getTaggingLineItemCodeTag(
        tagNoController.text,
        code,
      );
      taggingDetails.value = response;
      showSuccessToast(message: 'Tagging details fetched successfully');
    } catch (e) {
      log('Error fetching tagging details: $e');
      showErrorToast(message: 'Failed to fetch tagging details: $e');
      taggingDetails.value = null;
    } finally {
      isLoadingTagging.value = false;
    }
  }

  Future<void> fetchSalesDetails() async {
    if (salesNoController.text.isEmpty) {
      showErrorToast(message: 'Please enter Sales number');
      return;
    }

    try {
      isLoadingTagging.value = true;
      final response = await _repository.getSaleBySalesNumber(
        salesNumber: salesNoController.text.trim(),
      );

      // Update the response value
      getSaleBySalesNumberResponse.value = ApiResponse.completed(response);

      // Check if the response data is valid
      if (response.id != null) {
        showSuccessToast(message: 'Sales details fetched successfully');
      } else {
        showErrorToast(message: 'No valid sales record found');
        getSaleBySalesNumberResponse.value = ApiResponse.error(
          "No valid sales record found",
        );
      }
    } catch (e) {
      log('Error fetching sales details: $e');
      showErrorToast(message: 'Failed to fetch sales details: $e');
      getSaleBySalesNumberResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingTagging.value = false;
    }
  }

  Future<void> updateStatusWithSalesId() async {
    try {
      isLoading.value = true;
      final apiStatus = _denormalizeStatus(selectedStatus.value);

      // Check if sales details are fetched
      if (getSaleBySalesNumberResponse.value.data == null ||
          getSaleBySalesNumberResponse.value.data?.id == null) {
        showErrorToast(message: 'Please fetch Sales details first');
        return;
      }

      await _repository.assignOrderStatus(
        id: orderId,
        status: apiStatus,
        sale_id: getSaleBySalesNumberResponse.value.data?.id ?? "",
      );

      showSuccessToast(message: 'Status updated successfully');
      OrderListingViewModel orderListingViewModel = Get.find();
      orderListingViewModel.getOrdersListing(resetList: true);
      Get.back(result: selectedStatus.value);
    } catch (e) {
      log('Error updating status: $e');
      showErrorToast(message: 'Failed to update status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus() async {
    try {
      isLoading.value = true;
      final apiStatus = _denormalizeStatus(selectedStatus.value);

      await _repository.assignOrderStatus(id: orderId, status: apiStatus);

      showSuccessToast(message: 'Status updated successfully');
      OrderListingViewModel orderListingViewModel = Get.find();
      orderListingViewModel.getOrdersListing(resetList: true);
      Get.back(result: selectedStatus.value);
    } catch (e) {
      log('Error updating status: $e');
      showErrorToast(message: 'Failed to update status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatusWithTagging() async {
    try {
      isLoading.value = true;
      final apiStatus = _denormalizeStatus(selectedStatus.value);

      if (taggingDetails.value?.id == null) {
        showErrorToast(message: 'Please fetch tagging details first');
        return;
      }

      await _repository.assignOrderStatus(
        id: orderId,
        status: apiStatus,
        tagging_line_item_id: taggingDetails.value?.id,
      );

      showSuccessToast(message: 'Status updated successfully');
      OrderListingViewModel orderListingViewModel = Get.find();
      orderListingViewModel.getOrdersListing(resetList: true);
      Get.back(result: selectedStatus.value);
    } catch (e) {
      log('Error updating status: $e');
      showErrorToast(message: 'Failed to update status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unlinkOrderItemAndTagging() async {
    try {
      isLoading.value = true;

      await _repository.unlinkOrderItemAndTagging(id: orderId);

      showSuccessToast(message: 'Status updated successfully');
      OrderListingViewModel orderListingViewModel = Get.find();
      orderListingViewModel.getOrdersListing(resetList: true);
      Get.back(result: selectedStatus.value);
    } catch (e) {
      log('Error updating status: $e');
      showErrorToast(message: 'Failed to update status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Only dispose if not transitioning to tagging dialog
    final isTransitioningToTagging =
        selectedStatus.value.toLowerCase() == 'ready';
    if (!isTransitioningToTagging) {
      _disposeControllers();
    }
    super.onClose();
  }

  void _disposeControllers() {
    statusController.dispose();
    tagNoController.dispose();
    codeController.dispose();
    statusFocusNode.dispose();
    codeFocusNode.dispose();
    tagNoFocusNode.dispose();
    fetchButtonFocusNode.dispose();
  }
}
