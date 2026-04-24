import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view/add_online_only_design.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/online_only_design_listing/model/webstore_stock_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class WebOnlyProductsListingController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final products = <WebstoreStockValue>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final allSelected = false.obs;
  final searchQuery = ''.obs;
  final selectedProductIds = <String>[].obs;
  int? nextPage;
  final editProductId = ''.obs;

  String? lastOffsetId;
  final itemsPerPage = 10;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final RxList<String> popUpValues = <String>['Edit', 'Delete'].obs;

  final isAddWidgetVisible = true.obs;
  void toggleAddWidgetVisibility() {
    isAddWidgetVisible.value = !isAddWidgetVisible.value;
  }

  void setInitialConditions({required bool isSearch}) {
    products.clear();
    lastOffsetId = null;
    nextPage = null;
    hasMorePages.value = true;
    allSelected.value = false;
    selectedProductIds.clear();
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> getProductListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    try {
      if (resetList) {
        setInitialConditions(isSearch: isSearch);
        isLoading.value = true;
      } else {
        if (!hasMorePages.value) return;
        isLoadingMore.value = true;
      }

      final response = await _inventoryRepository.getOnlineDesignListing(
        nextPage: nextPage,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        products.value = response.values ?? [];
      } else {
        products.addAll(response.values ?? []);
      }

      // Update selection states based on selectedProductIds
      _updateProductSelectionStates();

      hasMorePages.value = response.pagination?.nextPage != null;
      log("hasMorePages: ${hasMorePages.value}");

      // Update nextPage for the next API call
      if (hasMorePages.value) {
        nextPage = response.pagination?.nextPage;
        log("Next Page: $nextPage");
      } else {
        log("No more pages to load");
      }
    } catch (e) {
      log('Error loading products: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> onDeleteProduct(String id) async {
    if (id.isEmpty) return;

    try {
      final confirmed = await Get.dialog<bool>(
        CancelPaymentDialog(
          subtitle: 'Are you sure you want to delete this product?',
          onYesPressed: () async {},
        ),
      );

      if (confirmed == true) {
        // Call delete API for webstore stock
        await _inventoryRepository.deleteWebstoreStock(id);

        showSuccessToast(message: "Successfully deleted product");

        // Remove from selected items if it was selected
        selectedProductIds.remove(id);

        // Refresh the product listing
        getProductListingDetails(resetList: true);
      }
    } catch (e) {
      log("Error deleting product: $e");
      showErrorToast(message: 'Failed to delete product: ${e.toString()}');
    }
  }

  void loadMoreItems() {
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more items, nextPage: $nextPage");
      getProductListingDetails(resetList: false);
    } else {
      log(
        "Cannot load more: isLoadingMore=${isLoadingMore.value}, hasMorePages=${hasMorePages.value}",
      );
    }
  }

  void setSeachQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getProductListingDetails(resetList: true, isSearch: true);
    });
  }

  // Updated selection methods
  void toggleSelectAll() {
    allSelected.value = !allSelected.value;
    if (allSelected.value) {
      // Add all product IDs to selected list
      selectedProductIds.value =
          products.where((p) => p.id != null).map((p) => p.id!).toList();
    } else {
      // Clear all selections
      selectedProductIds.clear();
    }
    _updateProductSelectionStates();
    products.refresh();
  }

  void toggleProductSelection(String? id) {
    if (id == null) return;

    if (selectedProductIds.contains(id)) {
      selectedProductIds.remove(id);
    } else {
      selectedProductIds.add(id);
    }

    // Update allSelected state
    allSelected.value =
        products.isNotEmpty &&
        products.every(
          (p) => p.id != null && selectedProductIds.contains(p.id!),
        );

    _updateProductSelectionStates();
    products.refresh();
  }

  // Helper method to update product selection states
  void _updateProductSelectionStates() {
    // Since WebstoreStockValue doesn't have isSelected property,
    // we'll manage selection state separately using selectedProductIds
  }

  // Get list of selected product IDs
  List<String> getSelectedProductIds() {
    return selectedProductIds.toList();
  }

  void onProductTap(WebstoreStockValue product) {
    // Implement product tap functionality
    // This can be used for navigation or showing details
  }

  Future<void> onEdit(WebstoreStockValue product) async {
    editProductId.value = product.id ?? "";
    // Get.to(() => AddOnlineOnlyDesign(id: editProductId.value));
    update();
  }

  Future<void> deleteSelectedProducts() async {
    if (selectedProductIds.isEmpty) return;

    try {
      final confirmed = await Get.dialog<bool>(
        CancelPaymentDialog(
          subtitle:
              'Are you sure you want to delete ${selectedProductIds.length} selected products?',
          onYesPressed: () async {}, // Return true to confirm
        ),
      );

      if (confirmed == true) {
        // Show loading

        // Keep track of successful and failed deletions
        int successCount = 0;
        int failCount = 0;
        List<String> failedIds = [];

        // Delete each product individually
        for (String productId in selectedProductIds.toList()) {
          try {
            await _inventoryRepository.deleteWebstoreStock(productId);
            successCount++;
          } catch (e) {
            failCount++;
            failedIds.add(productId);
            log("Failed to delete product $productId: $e");
          }
        }

        // Show appropriate message
        if (failCount == 0) {
          showSuccessToast(
            message: "Successfully deleted $successCount products",
          );
        } else {
          showErrorToast(message: "Failed to delete all selected products");
        }

        // Clear selections and refresh the product listing
        selectedProductIds.clear();
        allSelected.value = false;
        getProductListingDetails(resetList: true);
      }
    } catch (e) {
      log("Error deleting products: $e");
      showErrorToast(message: 'Failed to delete products: ${e.toString()}');
    }
  }
}
