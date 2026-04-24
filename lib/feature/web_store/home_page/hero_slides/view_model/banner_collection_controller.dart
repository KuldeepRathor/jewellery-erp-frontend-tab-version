import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/collection_listing/model/get_collections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/hero_slides_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class CollectionController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  // Collection related variables
  final RxList<GetAllCollectionsValue> collectionOptions =
      <GetAllCollectionsValue>[].obs;

  // Map to store TextEditingControllers and FocusNodes for each slide
  final RxMap<String, TextEditingController> collectionControllers =
      <String, TextEditingController>{}.obs;
  final RxMap<String, FocusNode> collectionFocusNodes =
      <String, FocusNode>{}.obs;

  // Map to store selected collection for each slide
  final RxMap<String, GetAllCollectionsValue?> selectedCollections =
      <String, GetAllCollectionsValue?>{}.obs;

  @override
  void onClose() {
    // Dispose all controllers and focus nodes
    for (var controller in collectionControllers.values) {
      controller.dispose();
    }
    for (var focusNode in collectionFocusNodes.values) {
      focusNode.dispose();
    }
    super.onClose();
  }

  // Get or create controller for a specific slide
  TextEditingController getControllerForSlide(String slideId) {
    if (!collectionControllers.containsKey(slideId)) {
      collectionControllers[slideId] = TextEditingController();
    }
    return collectionControllers[slideId]!;
  }

  // Get or create focus node for a specific slide
  FocusNode getFocusNodeForSlide(String slideId) {
    if (!collectionFocusNodes.containsKey(slideId)) {
      collectionFocusNodes[slideId] = FocusNode();
    }
    return collectionFocusNodes[slideId]!;
  }

  Future<void> searchCollections(String query) async {
    try {
      final response = await _inventoryRepository.getCollection();
      // Filter collections based on the search query if provided
      if (query.isNotEmpty) {
        collectionOptions.value =
            response.values
                ?.where(
                  (collection) =>
                      collection.collectionName?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false,
                )
                .toList() ??
            [];
      } else {
        collectionOptions.value = response.values ?? [];
      }
      collectionOptions.refresh();
    } catch (e) {
      log('Error searching collections: $e');
    }
  }

  void setSelectedCollection(
    String slideId,
    GetAllCollectionsValue? collection,
  ) {
    selectedCollections[slideId] = collection;
    if (collection != null && collectionControllers.containsKey(slideId)) {
      collectionControllers[slideId]!.text = collection.collectionName ?? '';
    }
    final heroController = Get.find<HeroSlidesController>();
    heroController.updateTarget(slideId, collection?.id ?? '');
  }

  void clearSelection(String slideId) {
    selectedCollections[slideId] = null;
    if (collectionControllers.containsKey(slideId)) {
      collectionControllers[slideId]!.text = '';
    }
  }

  void clearAllSelections() {
    for (var slideId in selectedCollections.keys) {
      clearSelection(slideId);
    }
  }

  String? getSelectedCollectionId(String slideId) {
    return selectedCollections[slideId]?.id;
  }

  void preSelectCollection(String slideId, String collectionId) {
    // Find the collection in options and select it
    searchCollections('').then((_) {
      final collection = collectionOptions.firstWhere(
        (col) => col.id == collectionId,
        orElse: () => GetAllCollectionsValue(),
      );

      if (collection.id != null) {
        selectedCollections[slideId] = collection;

        // Create controller if it doesn't exist
        if (!collectionControllers.containsKey(slideId)) {
          collectionControllers[slideId] = TextEditingController();
        }

        collectionControllers[slideId]!.text = collection.collectionName ?? '';
      }
    });
  }

  // Clean up resources for a specific slide (when removed)
  void disposeSlideResources(String slideId) {
    if (collectionControllers.containsKey(slideId)) {
      collectionControllers[slideId]!.dispose();
      collectionControllers.remove(slideId);
    }

    if (collectionFocusNodes.containsKey(slideId)) {
      collectionFocusNodes[slideId]!.dispose();
      collectionFocusNodes.remove(slideId);
    }

    selectedCollections.remove(slideId);
  }
}
