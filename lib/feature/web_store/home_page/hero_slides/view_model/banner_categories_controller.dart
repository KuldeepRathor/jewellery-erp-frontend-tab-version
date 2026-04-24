import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/hero_slides_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';

class CategoryController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  // Category related variables
  final RxList<CategoriesResponse> categoryOptions = <CategoriesResponse>[].obs;

  // Map to store TextEditingControllers and FocusNodes for each slide
  final RxMap<String, TextEditingController> categoryControllers =
      <String, TextEditingController>{}.obs;
  final RxMap<String, FocusNode> categoryFocusNodes = <String, FocusNode>{}.obs;

  // Map to store selected category for each slide
  final RxMap<String, CategoriesResponse?> selectedCategories =
      <String, CategoriesResponse?>{}.obs;

  @override
  void onClose() {
    // Dispose all controllers and focus nodes
    for (var controller in categoryControllers.values) {
      controller.dispose();
    }
    for (var focusNode in categoryFocusNodes.values) {
      focusNode.dispose();
    }
    super.onClose();
  }

  // Get or create controller for a specific slide
  TextEditingController getControllerForSlide(String slideId) {
    if (!categoryControllers.containsKey(slideId)) {
      categoryControllers[slideId] = TextEditingController();
    }
    return categoryControllers[slideId]!;
  }

  // Get or create focus node for a specific slide
  FocusNode getFocusNodeForSlide(String slideId) {
    if (!categoryFocusNodes.containsKey(slideId)) {
      categoryFocusNodes[slideId] = FocusNode();
    }
    return categoryFocusNodes[slideId]!;
  }

  Future<void> searchCategories(String query) async {
    try {
      final response = await _inventoryRepository.getCategories();

      // Filter categories based on the search query if provided
      if (query.isNotEmpty) {
        categoryOptions.value =
            response
                .where(
                  (category) =>
                      category.categoryName?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false,
                )
                .toList();
      } else {
        categoryOptions.value = response;
      }
      categoryOptions.refresh();
    } catch (e) {
      log('Error searching categories: $e');
    }
  }

  void setSelectedCategory(String slideId, CategoriesResponse? category) {
    selectedCategories[slideId] = category;
    if (category != null && categoryControllers.containsKey(slideId)) {
      categoryControllers[slideId]!.text = category.categoryName ?? '';
    }
    final heroController = Get.find<HeroSlidesController>();
    heroController.updateTarget(slideId, category?.id ?? '');
  }

  void clearSelection(String slideId) {
    selectedCategories[slideId] = null;
    if (categoryControllers.containsKey(slideId)) {
      categoryControllers[slideId]!.text = '';
    }
  }

  void clearAllSelections() {
    for (var slideId in selectedCategories.keys) {
      clearSelection(slideId);
    }
  }

  String? getSelectedCategoryId(String slideId) {
    return selectedCategories[slideId]?.id;
  }

  void preSelectCategory(String slideId, String categoryId) {
    // Find the category in options and select it
    searchCategories('').then((_) {
      final category = categoryOptions.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => CategoriesResponse(),
      );

      if (category.id != null) {
        selectedCategories[slideId] = category;

        // Create controller if it doesn't exist
        if (!categoryControllers.containsKey(slideId)) {
          categoryControllers[slideId] = TextEditingController();
        }

        categoryControllers[slideId]!.text = category.categoryName ?? '';
      }
    });
  }

  // Clean up resources for a specific slide (when removed)
  void disposeSlideResources(String slideId) {
    if (categoryControllers.containsKey(slideId)) {
      categoryControllers[slideId]!.dispose();
      categoryControllers.remove(slideId);
    }

    if (categoryFocusNodes.containsKey(slideId)) {
      categoryFocusNodes[slideId]!.dispose();
      categoryFocusNodes.remove(slideId);
    }

    selectedCategories.remove(slideId);
  }
}
