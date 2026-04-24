import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/get_tagging_and_catalogue_items_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/view_model/add_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class TaggingItemsController extends GetxController {
  final AddCollectionController addCollectionController =
      Get.find<AddCollectionController>();
  final SidebarController sidebarController = Get.find<SidebarController>();

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxMap<String, List<GetTaggingAndCatalogItem>> categorizedItems =
      <String, List<GetTaggingAndCatalogItem>>{}.obs;
  final RxList<String> categories = <String>[].obs;

  final RxString searchQuery = ''.obs;
  final RxList<GetTaggingAndCatalogItem> filteredCatalogItems =
      <GetTaggingAndCatalogItem>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (addCollectionController.catalogItems.isEmpty &&
        addCollectionController.catalogItemsResponse.value.status !=
            Status.LOADING) {
      addCollectionController.fetchCatalogItems();
    }

    ever(
      addCollectionController.selectedCatalogItems,
      (_) => updateCategorizedItems(),
    );

    filteredCatalogItems.value = addCollectionController.catalogItems;

    ever(searchQuery, (_) => filterCatalogItems());
  }

  // Items Select All Logic
  bool get isAllItemsSelected =>
      addCollectionController.catalogItems.isNotEmpty &&
      addCollectionController.selectedCatalogItems.length ==
          addCollectionController.catalogItems.length;

  void toggleSelectAllItems() {
    if (isAllItemsSelected) {
      // Deselect all
      addCollectionController.selectedCatalogItems.clear();
    } else {
      // Select all
      addCollectionController.selectedCatalogItems.assignAll(
        addCollectionController.catalogItems,
      );
    }
  }

  void updateCategorizedItems() {
    categorizedItems.clear();
    categories.clear();

    if (addCollectionController.selectedCatalogItems.isEmpty) {
      return;
    }

    final Map<String, List<GetTaggingAndCatalogItem>> groupedItems = {};

    // Group items by their type or other logical grouping
    // Since we don't have category/design info in the item response,
    // we'll group by a simpler logic

    for (var item in addCollectionController.selectedCatalogItems) {
      String categoryKey;

      // Determine category key based on item properties
      // You can adjust this logic based on your needs
      if (item.name != null) {
        // Extract category from item name if it contains category info
        // For example, if items are named like "Ring - Item Name"
        if (item.name!.contains(' - ')) {
          final parts = item.name!.split(' - ');
          categoryKey = parts[0];
        } else {
          // Use item type as fallback
          categoryKey = _getCategoryByType(item.type);
        }
      } else {
        categoryKey = _getCategoryByType(item.type);
      }

      // Add item to its category
      if (!groupedItems.containsKey(categoryKey)) {
        groupedItems[categoryKey] = [];
      }
      groupedItems[categoryKey]!.add(item);
    }

    // If no logical grouping found, create a default group
    if (groupedItems.isEmpty &&
        addCollectionController.selectedCatalogItems.isNotEmpty) {
      groupedItems["Selected Items"] =
          addCollectionController.selectedCatalogItems.toList();
    }

    // Update the observable collections
    categories.value = groupedItems.keys.toList();
    categorizedItems.value = groupedItems;
  }

  // Helper method to get category name by type
  String _getCategoryByType(String? type) {
    switch (type?.toLowerCase()) {
      case 'catalog':
        return 'Catalog Items';
      case 'tagging':
        return 'Tagging Items';
      case 'webstore':
        return 'Webstore Items';
      default:
        return 'Other Items';
    }
  }

  void filterCatalogItems() {
    if (searchQuery.value.isEmpty) {
      filteredCatalogItems.value = addCollectionController.catalogItems;
      return;
    }

    final query = searchQuery.value.toLowerCase();
    filteredCatalogItems.value =
        addCollectionController.catalogItems.where((item) {
          final name = item.name?.toLowerCase() ?? '';
          return name.contains(query);
        }).toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void applyFilter() {
    log('Filter applied');
  }

  Future<void> handleSaveCollection() async {
    if (addCollectionController.selectedCatalogItems.isEmpty) {
      showErrorToast(message: "Please select at least one item");
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await addCollectionController.createCollection();

      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
