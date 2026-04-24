import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_collection_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/collection_listing/model/get_collections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class CollectionViewModel extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  // All collections fetched once from API
  final RxList<GetAllCollectionsValue> collectionOptions =
      <GetAllCollectionsValue>[].obs;

  // Filtered list for search — shown in dropdown
  final RxList<GetAllCollectionsValue> filteredCollectionOptions =
      <GetAllCollectionsValue>[].obs;

  final TextEditingController collectionSearchController =
      TextEditingController();

  final FocusNode collectionFocusNode = FocusNode();

  final Rx<GetAllCollectionsValue?> selectedCollection =
      Rx<GetAllCollectionsValue?>(null);

  final RxBool isCollectionDropdownOpen = false.obs;

  // Per-item collection map: itemId -> collectionName
  final RxMap<String, String> itemCollectionMap = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCollections();
  }

  @override
  void onClose() {
    collectionSearchController.dispose();
    collectionFocusNode.dispose();
    super.onClose();
  }

  // Fetch all collections once — mirrors MetalColorViewModel.fetchMetalColors()
  Future<void> fetchCollections() async {
    try {
      final response = await _inventoryRepository.getCollection();
      collectionOptions.value = response.values ?? [];
      filteredCollectionOptions.value = collectionOptions;
    } catch (e) {
      log('Error fetching collections: $e');
    }
  }

  // Filter locally
  void searchCollections(String query) {
    if (query.isEmpty) {
      filteredCollectionOptions.value = collectionOptions;
    } else {
      filteredCollectionOptions.value =
          collectionOptions
              .where(
                (collection) =>
                    collection.collectionName?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false,
              )
              .toList();
    }
  }

  void toggleDropdown() {
    isCollectionDropdownOpen.value = !isCollectionDropdownOpen.value;
    if (isCollectionDropdownOpen.value) {
      filteredCollectionOptions.value = collectionOptions;
    }
  }

  void setSelectedCollection(GetAllCollectionsValue? collection) {
    selectedCollection.value = collection;
  }

  // Per-item setters — mirrors MetalColorViewModel.setItemMetalColor()
  void setItemCollection(String itemId, String collectionName) {
    itemCollectionMap[itemId] = collectionName;
  }

  String? getItemCollection(String itemId) {
    return itemCollectionMap[itemId];
  }

  void clear() {
    selectedCollection.value = null;
    collectionSearchController.clear();
    filteredCollectionOptions.value = collectionOptions;
    isCollectionDropdownOpen.value = false;
  }

  Future<void> updateCollectionApi({
    required String itemId,
    required String collectionId,
  }) async {
    try {
      await _inventoryRepository.updateCollection(
        request: UpdateCollectionRequest(
          taggingLineItemId: itemId,
          collection: collectionId,
        ),
      );
    } catch (e) {
      log("Error updating collection: $e");
    }
  }
}
