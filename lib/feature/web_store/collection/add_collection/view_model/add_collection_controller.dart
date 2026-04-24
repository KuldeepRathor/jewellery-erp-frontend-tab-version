import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/create_collection_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/get_designs_by_category_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/get_tagging_and_catalogue_items_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/view/widget/tagging_items_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AddCollectionController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  final SidebarController sidebarController = Get.find<SidebarController>();

  // API Response states
  final categoriesResponse = Rx<ApiResponse<List<CategoriesResponse>>>(
    ApiResponse.initial("Initial"),
  );
  final designsResponse = Rx<ApiResponse<GetDesignByCategoryResponse>>(
    ApiResponse.initial("Initial"),
  );

  final catalogItemsResponse =
      Rx<ApiResponse<GetTaggingAndCatalogItemsReponse>>(
        ApiResponse.initial("Initial"),
      );
  final createCollectionResponse = Rx<ApiResponse<dynamic>>(
    ApiResponse.initial("Initial"),
  );

  // Data lists
  final categories = <CategoriesResponse>[].obs;

  final designs = <GetDesignByCategoryValue>[].obs;
  final catalogItems = <GetTaggingAndCatalogItem>[].obs;

  // Selected values - lists to store multiple selected items
  final selectedCategories = <CategoriesResponse>[].obs;
  final selectedDesigns = <GetDesignByCategoryValue>[].obs;
  final selectedCatalogItems = <GetTaggingAndCatalogItem>[].obs;

  // Text editing controllers
  final categoryController = TextEditingController();
  final designController = TextEditingController();
  final collectionNameController = TextEditingController();

  // Debouncer for search
  final _debouncer = CustomDebouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void handleSaveShortcut() async {
    if (isFormValid()) {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        // Fetch catalog items before navigating
        await fetchCatalogItems();

        // Close loading dialog
        Get.back();

        // Navigate to tagging items listing page
        sidebarController.navigateToWidget(
          newChild: const TaggingItemsListingPage(),
        );
      } catch (e) {
        // Close loading dialog
        Get.back();

        showErrorToast(message: "Failed to fetch items: $e");
      }
    } else {
      final message =
          collectionNameController.text.trim().isEmpty
              ? "Please enter a collection name"
              : selectedCategories.isEmpty
              ? "Please select at least one category"
              : "Please select at least one design";

      showErrorToast(message: message);
    }
  }

  Future<void> createCollection() async {
    try {
      if (selectedCatalogItems.isEmpty) {
        showErrorToast(message: "Please select at least one item");
        return;
      }

      createCollectionResponse.value = ApiResponse.loading(
        "Creating collection",
      );

      // Filter items by type
      final taggingItems =
          selectedCatalogItems
              .where((item) => item.type?.toLowerCase() == 'tagging')
              .map((item) => item.id ?? "")
              .toList();

      final catalogItemsList =
          selectedCatalogItems
              .where((item) => item.type?.toLowerCase() == 'catalog')
              .map((item) => item.id ?? "")
              .toList();

      // Separate design IDs by type for the create collection request
      final List<String> designIds = [];
      final List<String> webstoreItemIds = [];

      for (var design in selectedDesigns) {
        if (design.type?.toLowerCase() == 'design') {
          designIds.add(design.id ?? "");
        } else if (design.type?.toLowerCase() == 'web_only_design') {
          webstoreItemIds.add(design.id ?? "");
        }
      }

      final request = CreateCollectionRequest(
        collectionName: collectionNameController.text.trim(),
        category: selectedCategories.map((cat) => cat.id ?? "").toList(),
        design: designIds,
        isWebstore: true,
        taggingItems: taggingItems,
        catalog: catalogItemsList,
        webstoreItems: webstoreItemIds,
      );

      final response = await _inventoryRepository.createCollection(request);
      createCollectionResponse.value = ApiResponse.completed(response);

      showSuccessToast(message: "Collection created successfully");

      sidebarController.popBackSelectedWidget();
    } catch (e) {
      log('Error creating collection: $e');
      showErrorToast(message: "Failed to create collection: $e");
      createCollectionResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> fetchCatalogItems() async {
    try {
      if (selectedCategories.isEmpty || selectedDesigns.isEmpty) {
        catalogItems.clear();
        selectedCatalogItems.clear();
        catalogItemsResponse.value = ApiResponse.initial("Initial");
        return;
      }

      catalogItemsResponse.value = ApiResponse.loading(
        "Fetching catalog items",
      );

      // Separate designs by type
      final List<String> designIds = [];
      final List<String> webOnlyStockIds = [];

      for (var design in selectedDesigns) {
        if (design.type?.toLowerCase() == 'design') {
          designIds.add(design.id ?? "");
        } else if (design.type?.toLowerCase() == 'web_only_design') {
          webOnlyStockIds.add(design.id ?? "");
        }
      }

      final response = await _inventoryRepository.getTaggingAndCatalogItems(
        designIds: designIds.isNotEmpty ? designIds : null,
        webOnlyStockIds: webOnlyStockIds.isNotEmpty ? webOnlyStockIds : null,
      );

      catalogItems.value = response.items ?? [];

      // Auto-select webstore items and previously selected items
      selectedCatalogItems.value =
          catalogItems.where((item) {
            // Auto-select if it's a webstore item OR if it was already selected
            return item.type?.toLowerCase() == 'webstore' ||
                item.isSelected == true;
          }).toList();

      catalogItemsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching catalog items: $e');
      showErrorToast(message: "Failed to fetch catalog items: $e");
      catalogItemsResponse.value = ApiResponse.error(e.toString());
      catalogItems.clear();
      selectedCatalogItems.clear();
    }
  }

  bool isCatalogItemSelected(GetTaggingAndCatalogItem item) {
    return selectedCatalogItems.any((selected) => selected.id == item.id);
  }

  void toggleCatalogItemSelection(GetTaggingAndCatalogItem item) {
    if (isCatalogItemSelected(item)) {
      selectedCatalogItems.removeWhere((selected) => selected.id == item.id);
    } else {
      selectedCatalogItems.add(item);
    }
  }

  //Fetch Catagories Api calls
  void fetchCategories() {
    _debouncer.run(() async {
      try {
        categoriesResponse.value = ApiResponse.loading("Fetching categories");
        final response = await _inventoryRepository.getCategories();
        categories.value = response;
        categoriesResponse.value = ApiResponse.completed(response);
      } catch (e) {
        log('Error fetching categories: $e');
        showErrorToast(message: "Failed to fetch categories: $e");
        categoriesResponse.value = ApiResponse.error(e.toString());
        categories.clear();
      }
    });
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      fetchCategories();
      return;
    }

    try {
      final filteredCategories =
          categories
              .where(
                (category) =>
                    category.categoryName?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false,
              )
              .toList();

      categories.value = filteredCategories;
    } catch (e) {
      log('Error filtering categories: $e');
      showErrorToast(message: "Failed to filter categories: $e");
    }
  }

  bool isCategorySelected(CategoriesResponse category) {
    return selectedCategories.any((selected) => selected.id == category.id);
  }

  void toggleCategorySelection(CategoriesResponse category) {
    if (isCategorySelected(category)) {
      selectedCategories.removeWhere((selected) => selected.id == category.id);
    } else {
      selectedCategories.add(category);
    }

    updateCategoryTextField();

    if (selectedCategories.isNotEmpty) {
      fetchDesignsByCategories();
      catalogItems.clear();
      selectedCatalogItems.clear();
      catalogItemsResponse.value = ApiResponse.initial("Initial");
    } else {
      designs.clear();
      designController.clear();
      selectedDesigns.clear();
      designsResponse.value = ApiResponse.initial("Initial");
      catalogItems.clear();
      selectedCatalogItems.clear();
      catalogItemsResponse.value = ApiResponse.initial("Initial");
    }
  }

  void updateCategoryTextField() {
    if (selectedCategories.isEmpty) {
      categoryController.text = "";
    } else if (selectedCategories.length == 1) {
      categoryController.text = selectedCategories.first.categoryName ?? "-";
    } else {
      categoryController.text =
          "${selectedCategories.length} categories selected";
    }
  }

  Future<void> fetchDesignsByCategories() async {
    try {
      if (selectedCategories.isEmpty) {
        return;
      }

      designsResponse.value = ApiResponse.loading("Fetching designs");
      designController.clear();
      selectedDesigns.clear();

      final categoryIds =
          selectedCategories.map((cat) => cat.id ?? "").toList();

      final response = await _inventoryRepository.getDesignsByCategories(
        categoryIds,
      );

      designs.value = response.values ?? [];
      designsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching designs: $e');
      showErrorToast(message: "Failed to fetch designs: $e");
      designsResponse.value = ApiResponse.error(e.toString());
      designs.clear();
    }
  }

  bool isDesignSelected(GetDesignByCategoryValue design) {
    return selectedDesigns.any((selected) => selected.id == design.id);
  }

  void toggleDesignSelection(GetDesignByCategoryValue design) {
    if (isDesignSelected(design)) {
      selectedDesigns.removeWhere((selected) => selected.id == design.id);
    } else {
      selectedDesigns.add(design);
    }

    updateDesignTextField();

    // if (selectedDesigns.isNotEmpty) {
    //   fetchCatalogItems();
    // } else {
    //   catalogItems.clear();
    //   selectedCatalogItems.clear();
    //   catalogItemsResponse.value = ApiResponse.initial("Initial");
    // }
  }

  // Category Select All Logic
  bool get isAllCategoriesSelected =>
      categories.isNotEmpty && selectedCategories.length == categories.length;

  void toggleSelectAllCategories() {
    if (isAllCategoriesSelected) {
      for (var category in categories) {
        selectedCategories.removeWhere((c) => c.id == category.id);
      }
    } else {
      selectedCategories.assignAll(categories);
    }

    updateCategoryTextField();

    if (selectedCategories.isNotEmpty) {
      fetchDesignsByCategories();
    } else {
      designs.clear();
      selectedDesigns.clear();
      designController.clear();
    }
  }

  // Design Select All Logic
  bool get isAllDesignsSelected =>
      designs.isNotEmpty && selectedDesigns.length == designs.length;

  void toggleSelectAllDesigns() {
    if (isAllDesignsSelected) {
      selectedDesigns.clear();
    } else {
      selectedDesigns.assignAll(designs);
    }
  }

  void updateDesignTextField() {
    if (selectedDesigns.isEmpty) {
      designController.text = "";
    } else if (selectedDesigns.length == 1) {
      final design = selectedDesigns.first;
      designController.text = '${design.code ?? "-"}   ${design.name ?? "-"}';
    } else {
      designController.text = "${selectedDesigns.length} designs selected";
    }
  }

  bool isFormValid() {
    return selectedCategories.isNotEmpty &&
        selectedDesigns.isNotEmpty &&
        collectionNameController.text.trim().isNotEmpty;
  }

  @override
  void onClose() {
    categoryController.dispose();
    designController.dispose();
    collectionNameController.dispose();
    super.onClose();
  }

  void clearControllers() {
    log("Clearing controller data");
    categoryController.clear();
    designController.clear();
    collectionNameController.clear();
    selectedDesigns.clear();
    selectedCategories.clear();
    categories.clear();
    designs.clear();
  }
}
