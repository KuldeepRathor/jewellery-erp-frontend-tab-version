import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/models/get_reorder_line_items_by_design_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/models/post_reorder_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view/widgets/supllier_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view_model/reorder_level_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ReorderItem {
  String? id;
  String weightGroupId;
  String weightGroupCode;
  String weightGroupName;
  String sizeGroupId;
  String sizeGroupCode;
  String sizeGroupName;
  String purity;
  MinMaxControllers controllers;
  String quantityType;
  VendorSearchValue? vendorDetails;

  ReorderItem({
    required this.weightGroupId,
    required this.weightGroupCode,
    required this.weightGroupName,
    required this.sizeGroupId,
    required this.sizeGroupCode,
    required this.sizeGroupName,
    required this.purity,
    required this.controllers,
    required this.quantityType,
    required this.vendorDetails,
    required this.id,
  });
}

class ReorderDetailsController extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final saveReorderResponse = Rx<ApiResponse<void>>(
    ApiResponse.initial("Initial"),
  );
  // Observable lists
  final items = <ReorderItem>[].obs;
  final purityTypes = <String>[].obs;

  final isLoading = true.obs;
  final hasError = false.obs;
  String? errorMessage;

  @override
  void onClose() {
    // Dispose controllers
    for (var item in items) {
      item.controllers.dispose();
    }
    //   _dio.close();
    super.onClose();
  }

  Future<void> loadReorderData(String designId) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage = null;

    try {
      final response = await _aggregateRepository.getReorderLineItemsByDesignId(
        designId: designId,
      );

      _processApiData(response);
    } on DioException catch (e) {
      hasError.value = true;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Connection timeout. Please try again.';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Server error: ${e.response?.statusCode}';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'No internet connection';
          break;
        default:
          errorMessage = 'Error loading data: ${e.message}';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _processApiData(GetReorderLineItemsResponse data) {
    final List<GetReorderLineItemsResponseValues> values = data.values ?? [];
    final Set<String> uniquePurities = {};
    final List<ReorderItem> newItems = [];

    // Create items directly from API data
    for (var value in values) {
      final controllers = MinMaxControllers();
      controllers.minController.text = value.min ?? '0.00';
      controllers.maxController.text = value.max ?? '0.00';

      newItems.add(
        ReorderItem(
          id: value.id,
          weightGroupId: value.weightGroup ?? '',
          weightGroupCode: value.weightGroupCode ?? '',
          weightGroupName: value.weightGroupName ?? '',
          sizeGroupId: value.sizeGroup ?? '',
          sizeGroupCode: value.sizeGroupCode ?? '',
          sizeGroupName: value.sizeGroupName ?? '',
          purity: value.purity ?? '',
          controllers: controllers,
          quantityType: value.quantityType ?? "net_weight",
          vendorDetails: value.vendorDetails,
        ),
      );

      if (value.purity != null) {
        uniquePurities.add(value.purity!);
      }
    }

    // Update observable lists
    items.value = newItems;
    purityTypes.value = uniquePurities.toList()..sort();
  }

  String getPurityDisplay(String purity) {
    switch (purity.toLowerCase()) {
      case '18k':
        return '18K';
      case '20k':
        return '20K';
      case 'silver_999':
        return 'Silver 999';
      case 'plain':
        return 'Plain';
      default:
        return purity.toUpperCase();
    }
  }

  // Quantity type cycling
  final List<String> quantityTypes = ['net_weight', 'gross_weight', 'pieces'];
  void cycleQuantityType() {
    // Get the currently focused text field's item
    final focusedItem = _getFocusedItem();
    if (focusedItem != null) {
      final currentIndex = quantityTypes.indexOf(focusedItem.quantityType);
      final nextIndex = (currentIndex + 1) % quantityTypes.length;
      focusedItem.quantityType = quantityTypes[nextIndex];
    }
  }

  void openSupplierDialog() {
    final focusedItem = _getFocusedItem();
    if (focusedItem != null) {
      Get.dialog(
        // SupplierSelectionDialog(
        //   onSelectForOne: (supplier) {
        //     focusedItem.supplier.value = supplier;
        //     Get.back();
        //   },
        //   onSelectForAll: (supplier) {
        //     for (var item in items) {
        //       item.supplier.value = supplier;
        //     }
        //     Get.back();
        //   },
        // ),
        SupplierDialog(
          onSelectForOne: (supplier) {
            focusedItem.vendorDetails = supplier;
            items.refresh();
            Get.back();
          },
          onSelectForAll: (supplier) {
            for (var item in items) {
              item.vendorDetails = supplier;
            }
            items.refresh();
            Get.back();
          },
          currentSupplierCode: focusedItem.vendorDetails?.code,
        ),
      );
    }
  }

  ReorderItem? _getFocusedItem() {
    final focusScope = FocusScope.of(Get.context!);
    if (!focusScope.hasFocus) return null;

    // Find which item contains the focused text field
    return items.firstWhereOrNull(
      (item) =>
          item.controllers.minFocusNode.hasFocus == true ||
          item.controllers.maxFocusNode.hasFocus == true,
    );
  }

  Future<void> saveReorderItems() async {
    if (!validateInputs()) return;

    try {
      saveReorderResponse.value = ApiResponse.loading("Saving reorder levels");

      final request = PostReorderRequest(
        designId: Get.find<ReorderLevelController>().selectedDesign.value?.id,
        stockHeadId:
            Get.find<ReorderLevelController>().selectedStockHead.value?.id,
        values:
            items
                .map(
                  (item) => PostReorderRequestLineItems(
                    weightGroupId: item.weightGroupId,
                    sizeGroupId: item.sizeGroupId,
                    purity: item.purity,
                    min: item.controllers.minController.text,
                    max: item.controllers.maxController.text,
                    quantityType: item.quantityType,
                    vendorId: item.vendorDetails?.id,
                    id: item.id,
                  ),
                )
                .toList(),
      );

      await _aggregateRepository.postReorder(postReorderRequest: request);
      saveReorderResponse.value = ApiResponse.completed(null);
      showSuccessToast(message: "Reorder levels saved successfully");
      SidebarController sidebarController = Get.find();
      sidebarController.popBackSelectedWidget();
    } catch (e) {
      final errorMessage = 'Failed to save reorder levels: $e';
      showErrorToast(message: errorMessage);
      saveReorderResponse.value = ApiResponse.error(errorMessage);
    }
  }

  final formKey = GlobalKey<FormState>();

  bool validateInputs() {
    // First validate the form
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validate vendor selection and min-max relationships
    for (var item in items) {
      // Check vendor
      if (item.vendorDetails == null || item.vendorDetails?.id == null) {
        showErrorToast(
          message:
              "Please select supplier for ${item.weightGroupName} - ${item.sizeGroupName} - ${getPurityDisplay(item.purity)}",
        );
        // Focus the min field of the item missing vendor
        item.controllers.minFocusNode.requestFocus();
        return false;
      }

      // Check min-max relationship
      final min = double.tryParse(item.controllers.minController.text);
      final max = double.tryParse(item.controllers.maxController.text);

      if (min! > max!) {
        showErrorToast(
          message:
              "Minimum value cannot be greater than maximum value for ${item.weightGroupName} - ${item.sizeGroupName} - ${getPurityDisplay(item.purity)}",
        );
        item.controllers.minFocusNode.requestFocus();
        return false;
      }
    }
    return true;
  }

  String? validateMin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Min value is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < 0) {
      return 'Value cannot be negative';
    }
    return null;
  }

  String? validateMax(String? value) {
    if (value == null || value.isEmpty) {
      return 'Max value is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < 0) {
      return 'Value cannot be negative';
    }
    return null;
  }
}

class MinMaxControllers {
  final TextEditingController minController;
  final TextEditingController maxController;
  final FocusNode minFocusNode;
  final FocusNode maxFocusNode;

  MinMaxControllers()
    : minController = TextEditingController(),
      maxController = TextEditingController(),
      minFocusNode = FocusNode(),
      maxFocusNode = FocusNode();

  void dispose() {
    minController.dispose();
    maxController.dispose();
    minFocusNode.dispose();
    maxFocusNode.dispose();
  }
}
