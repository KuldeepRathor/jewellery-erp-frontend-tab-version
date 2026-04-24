import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/catalogue_listing/model/get_catalog_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class OrderToMakeListingController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final products = <GetCatalogueListingValue>[].obs;
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

  // In CatalogueListingController class
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

      final response = await _inventoryRepository.getCatalogueListing(
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
    for (var product in products) {
      if (product.id != null) {
        product.isSelected = selectedProductIds.contains(product.id);
      }
    }
  }

  // Get list of selected product IDs
  List<String> getSelectedProductIds() {
    return selectedProductIds.toList();
  }

  void onProductTap(GetCatalogueListingValue product) {
    // Implement product tap functionality
    // This can be used for navigation or showing details
  }

  Future<void> onEdit(GetCatalogueListingValue product) async {
    editProductId.value = product.id ?? "";

    // await Get.dialog<bool>(
    //   Container(
    //       height: Get.height * .95,
    //       width: Get.width * .7,
    //       child: const EditCatalogueWidget()),
    // );
    update();
  }

  Future<void> onDeleteProduct(String id) async {
    if (id.isEmpty) return;

    try {
      final confirmed = await Get.dialog<bool>(
        CancelPaymentDialog(
          subtitle: 'Are you sure you want to delete this product?',
          onYesPressed: () async {
            await _inventoryRepository.deleteCatalogue(id);
          },
        ),
      );

      if (confirmed == true) {
        showSuccessToast(message: "Successfully deleted product");
        // Refresh the product listing
        getProductListingDetails(resetList: true);
      }
    } catch (e) {
      log("Error deleting product: $e");
      showErrorToast(message: 'Failed to delete product: ${e.toString()}');
    }
  }

  Future<void> deleteSelectedProducts() async {
    // if (selectedProductIds.isEmpty) {
    //   showInfoToast(message: "No products selected for deletion");
    //   return;
    // }

    try {
      final confirmed = await Get.dialog<bool>(
        CancelPaymentDialog(
          subtitle:
              'Are you sure you want to delete ${selectedProductIds.length} selected products?',
          onYesPressed: () async {
            await _inventoryRepository.deleteCatalogues(
              selectedProductIds.toList(),
            );
          },
        ),
      );

      if (confirmed == true) {
        showSuccessToast(
          message: "Successfully deleted ${selectedProductIds.length} products",
        );
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
