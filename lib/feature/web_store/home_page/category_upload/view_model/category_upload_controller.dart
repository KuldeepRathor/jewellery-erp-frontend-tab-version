import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/image_cropper_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/model/category_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/model/get_all_categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/model/update_category_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CategoryImageData {
  final String path;
  final bool isLocal;

  CategoryImageData({required this.path, required this.isLocal});
}

class CategoryUploadController extends GetxController {
  final WebstoreRepository _webstoreRepository = WebstoreRepository();
  final webstoreCategoriesResponse = Rx<ApiResponse<GetAllCategoriesResponse>>(
    ApiResponse.initial("Initial"),
  );
  final RxList<GetAllCategoriesValue> categoriesForGrid =
      <GetAllCategoriesValue>[].obs;
  final dropdownCategoriesResponse = Rx<ApiResponse<GetAllCategoriesResponse>>(
    ApiResponse.initial("Initial"),
  );
  final dropdownCategories = <GetAllCategoriesValue>[].obs;
  final categoryControllers = <String, TextEditingController>{};
  final categoryFocusNodes = <String, FocusNode>{};
  final selectedDropdownCategories = <String, GetAllCategoriesValue>{}.obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final localCategoryImages = RxMap<String, List<CategoryImageData>>();
  final categoryWebstoreStatus = RxMap<String, bool>();
  final uploadedImages = RxMap<String, List<UpdateCategoryImage>>();
  final clearedApiImages = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesForDropdown().then((_) {
      fetchAllCategoriesForGrid();
    });
  }

  void _initControllersForCategories() {
    for (final controller in categoryControllers.values) {
      controller.dispose();
    }
    for (final node in categoryFocusNodes.values) {
      node.dispose();
    }
    categoryControllers.clear();
    categoryFocusNodes.clear();
    selectedDropdownCategories.clear();

    for (final category in categoriesForGrid) {
      if (category.id != null) {
        categoryControllers[category.id!] = TextEditingController();
        categoryFocusNodes[category.id!] = FocusNode();

        final exactMatch = dropdownCategories.firstWhere(
          (dropdownCategory) => dropdownCategory.id == category.id,
          orElse: () => GetAllCategoriesValue(),
        );

        if (exactMatch.id != null) {
          selectedDropdownCategories[category.id!] = exactMatch;
          categoryControllers[category.id!]!.text =
              exactMatch.categoryName ?? '';
          log(
            "Pre-selected category with exact ID match: ${exactMatch.categoryName} (ID: ${exactMatch.id})",
          );
        } else if (category.categoryName != null &&
            category.categoryName!.isNotEmpty) {
          final nameMatch = dropdownCategories.firstWhere(
            (dropdownCategory) =>
                dropdownCategory.categoryName == category.categoryName,
            orElse: () => GetAllCategoriesValue(),
          );

          if (nameMatch.id != null) {
            selectedDropdownCategories[category.id!] = nameMatch;
            categoryControllers[category.id!]!.text =
                nameMatch.categoryName ?? '';
            log(
              "Pre-selected category with name match: ${nameMatch.categoryName} (ID: ${nameMatch.id})",
            );
          } else {
            categoryControllers[category.id!]!.text =
                category.categoryName ?? '';
            log(
              "No match found for category: ${category.categoryName} (ID: ${category.id})",
            );
          }
        }
      }
    }
  }

  TextEditingController getCategoryController(String categoryId) {
    if (!categoryControllers.containsKey(categoryId)) {
      categoryControllers[categoryId] = TextEditingController();
    }
    return categoryControllers[categoryId]!;
  }

  FocusNode getCategoryFocusNode(String categoryId) {
    if (!categoryFocusNodes.containsKey(categoryId)) {
      categoryFocusNodes[categoryId] = FocusNode();
    }
    return categoryFocusNodes[categoryId]!;
  }

  void setSelectedCategory(
    String categoryId,
    GetAllCategoriesValue selectedCategory,
  ) {
    if (selectedCategory.id != null) {
      selectedDropdownCategories[categoryId] = selectedCategory;

      final controller = categoryControllers[categoryId];
      if (controller != null) {
        controller.text = selectedCategory.categoryName ?? '';
      }

      if (categoryId.startsWith('temp_')) {
        log(
          "Updating temporary category $categoryId to use ID from selected category: ${selectedCategory.id}",
        );

        final index = categoriesForGrid.indexWhere(
          (cat) => cat.id == categoryId,
        );
        if (index >= 0) {
          final updatedCategory = GetAllCategoriesValue(
            id: selectedCategory.id,
            categoryName: selectedCategory.categoryName,
            isWebstore: categoryWebstoreStatus[categoryId] ?? true,
            images: [],
          );

          categoriesForGrid[index] = updatedCategory;

          categoryControllers[selectedCategory.id!] =
              categoryControllers[categoryId]!;
          categoryFocusNodes[selectedCategory.id!] =
              categoryFocusNodes[categoryId]!;
          categoryControllers.remove(categoryId);
          categoryFocusNodes.remove(categoryId);

          categoryWebstoreStatus[selectedCategory.id!] =
              categoryWebstoreStatus[categoryId]!;
          categoryWebstoreStatus.remove(categoryId);

          if (localCategoryImages.containsKey(categoryId)) {
            localCategoryImages[selectedCategory.id!] =
                localCategoryImages[categoryId]!;
            localCategoryImages.remove(categoryId);
          }

          selectedDropdownCategories[selectedCategory.id!] = selectedCategory;
          selectedDropdownCategories.remove(categoryId);

          if (clearedApiImages.contains(categoryId)) {
            clearedApiImages.remove(categoryId);
            clearedApiImages.add(selectedCategory.id!);
          }

          if (uploadedImages.containsKey(categoryId)) {
            uploadedImages[selectedCategory.id!] = uploadedImages[categoryId]!;
            uploadedImages.remove(categoryId);
          }

          log(
            "Successfully updated temporary category ID $categoryId to ${selectedCategory.id}",
          );

          categoriesForGrid.refresh();
          categoryWebstoreStatus.refresh();
          localCategoryImages.refresh();
          selectedDropdownCategories.refresh();
          if (uploadedImages.isNotEmpty) uploadedImages.refresh();
        }
      } else {
        log(
          "Selected category: ${selectedCategory.categoryName} (ID: ${selectedCategory.id}) for grid item: $categoryId",
        );
      }
    }
  }

  Future<void> fetchAllCategoriesForGrid() async {
    try {
      isLoading.value = true;
      webstoreCategoriesResponse.value = ApiResponse.loading(
        "Loading categories...",
      );
      log(
        'Starting to fetch categories. Status: ${webstoreCategoriesResponse.value.status}',
      );

      final response = await _webstoreRepository.getAllCategories(
        is_webstore: true,
      );
      log(
        'Received API response for categories. Data present: ${response.values != null}',
      );
      log('Number of categories: ${response.values?.length ?? 0}');

      if (response.values != null) {
        categoriesForGrid.value = response.values!;

        for (var category in response.values!) {
          if (category.id != null) {
            categoryWebstoreStatus[category.id!] = category.isWebstore ?? false;
          }
        }

        _initControllersForCategories();
        log('Successfully processed ${categoriesForGrid.length} categories');
      } else {
        categoriesForGrid.value = [];
        log('API returned empty values, setting empty categories list');
      }

      webstoreCategoriesResponse.value = ApiResponse.completed(response);
      log('Set categories response to COMPLETED status');
    } catch (e, stack) {
      log('Error fetching webstore categories: $e $stack');
      webstoreCategoriesResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch webstore categories");
      log('Set categories response to ERROR status');
    } finally {
      isLoading.value = false;
      log('Loading state set to false');
    }
  }

  Future<void> fetchCategoriesForDropdown() async {
    try {
      dropdownCategoriesResponse.value = ApiResponse.loading(
        "Fetching dropdown categories",
      );

      final response = await _webstoreRepository.getAllCategories();

      if (response.values != null) {
        dropdownCategories.value = response.values!;
        log("Loaded ${response.values!.length} dropdown categories");
      } else {
        dropdownCategories.clear();
        log("No dropdown categories found");
      }

      dropdownCategoriesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching dropdown categories: $e');
      showErrorToast(message: "Failed to fetch dropdown categories");
      dropdownCategoriesResponse.value = ApiResponse.error(e.toString());
      dropdownCategories.clear();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<GetAllCategoriesValue> get filteredCategories {
    if (searchQuery.value.isEmpty) {
      return categoriesForGrid;
    }

    return categoriesForGrid.where((category) {
      return category.categoryName?.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ??
          false;
    }).toList();
  }

  List<CategoryImageData> getCategoryImages(String categoryId) {
    final List<CategoryImageData> allImages = [];

    final category = categoriesForGrid.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => GetAllCategoriesValue(),
    );

    if (category.images != null) {
      for (var image in category.images!) {
        if (image.presignedUrl != null &&
            image.presignedUrl.toString().isNotEmpty) {
          allImages.add(
            CategoryImageData(
              path: image.presignedUrl.toString(),
              isLocal: false,
            ),
          );
        }
      }
    }

    if (localCategoryImages.containsKey(categoryId)) {
      allImages.addAll(localCategoryImages[categoryId]!);
    }

    return allImages;
  }

  Future<void> pickAndCropImage(String categoryId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.first.path;

        if (filePath != null) {
          final croppedPath = await Get.dialog(
            ImageCropDialog(
              imagePath: filePath,
              onCropped: (path) => Get.back(result: path),
            ),
            barrierDismissible: false,
          );

          if (croppedPath != null) {
            File file = File(croppedPath);
            int fileSize = await file.length();
            double maxSizeInBytes = 5 * 1024 * 1024;

            if (fileSize <= maxSizeInBytes) {
              if (!localCategoryImages.containsKey(categoryId)) {
                localCategoryImages[categoryId] = [];
              }

              localCategoryImages[categoryId]!.clear();
              localCategoryImages[categoryId]!.add(
                CategoryImageData(path: croppedPath, isLocal: true),
              );
              localCategoryImages.refresh();
            } else {
              showErrorToast(message: "Image size should be less than 5MB");
            }
          }
        }
      }
    } catch (e) {
      log("Error picking/cropping image: $e");
      showErrorToast(message: "Failed to process image");
    }
  }

  void clearCategoryImage(String categoryId) {
    // Remove any local images
    if (localCategoryImages.containsKey(categoryId)) {
      localCategoryImages[categoryId]!.clear();
      localCategoryImages.refresh();
    }

    // Check if this category has API images before marking as cleared
    final category = categoriesForGrid.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => GetAllCategoriesValue(),
    );

    if (category.images != null && category.images!.isNotEmpty) {
      // Only mark as cleared if it actually has API images to clear
      clearedApiImages.add(categoryId);
      log("Marked API images as cleared for category $categoryId");
    }

    // Clear any uploaded images for this category
    if (uploadedImages.containsKey(categoryId)) {
      uploadedImages[categoryId]!.clear();
      uploadedImages.refresh();
    }

    log("Cleared images for category $categoryId");
  }

  bool isApiImageCleared(String categoryId) {
    return clearedApiImages.contains(categoryId);
  }

  void toggleWebstoreStatus(String categoryId) {
    if (categoryWebstoreStatus.containsKey(categoryId)) {
      categoryWebstoreStatus[categoryId] = !categoryWebstoreStatus[categoryId]!;
    } else {
      final category = categoriesForGrid.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => GetAllCategoriesValue(isWebstore: false),
      );

      categoryWebstoreStatus[categoryId] = !(category.isWebstore ?? false);
    }

    categoryWebstoreStatus.refresh();
    log(
      "Toggled webstore status for category $categoryId to: ${categoryWebstoreStatus[categoryId]}",
    );
  }

  bool getCategoryWebstoreStatus(String categoryId) {
    if (categoryWebstoreStatus.containsKey(categoryId)) {
      return categoryWebstoreStatus[categoryId]!;
    }

    final category = categoriesForGrid.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => GetAllCategoriesValue(),
    );

    return category.isWebstore ?? false;
  }

  Future<void> uploadCategoryImages() async {
    try {
      uploadedImages.clear();

      for (var entry in localCategoryImages.entries) {
        final categoryId = entry.key;
        final images = entry.value;

        if (images.isNotEmpty) {
          final localImage = images[0];
          final imagePath = localImage.path;
          final extension = path.extension(imagePath).replaceAll(".", "");
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final filename = "${categoryId}_$timestamp.$extension";

          final presignedUrlRequest = CategoryImagesPresignedUrlRequest(
            images: [
              CategoryImagesPresignedUrlImage(
                fileName: filename,
                fileType: extension,
              ),
            ],
          );

          final presignedUrlResponse = await _webstoreRepository
              .categoryImagePresignedUrl(presignedUrlRequest);

          if (presignedUrlResponse.images != null &&
              presignedUrlResponse.images!.isNotEmpty) {
            final imageData = presignedUrlResponse.images![0];

            await _webstoreRepository.putCategoryImages(
              putUrl: imageData.presignedUrl ?? "",
              imagePath: imagePath,
            );

            if (!uploadedImages.containsKey(categoryId)) {
              uploadedImages[categoryId] = [];
            }

            final updatedImage = UpdateCategoryImage(
              fileName: imageData.fileName,
              fileType: imageData.fileType,
              s3Key: imageData.s3Key,
            );

            uploadedImages[categoryId]!.add(updatedImage);

            log("Successfully uploaded image for category: $categoryId");
            log(
              "Image details: ${imageData.fileName}, ${imageData.s3Key}, extension: $extension",
            );
          }
        }
      }
    } catch (e) {
      log("Error uploading images: $e");
      rethrow;
    }
  }

  Future<void> updateCategoryDetails() async {
    try {
      final tempCategories =
          categoriesForGrid
              .where((cat) => cat.id != null && cat.id!.startsWith('temp_'))
              .toList();
      if (tempCategories.isNotEmpty) {
        log(
          "Warning: Found ${tempCategories.length} temporary categories without selected dropdown categories",
        );
      }

      List<UpdateCategoryRequest> updateRequests = [];

      for (var category in categoriesForGrid) {
        final categoryId = category.id;

        if (categoryId == null || categoryId.startsWith('temp_')) continue;

        // Check for various types of changes
        final hasWebstoreStatusChanged =
            categoryWebstoreStatus.containsKey(categoryId) &&
            categoryWebstoreStatus[categoryId] != category.isWebstore;

        final hasDropdownCategoryChanged =
            selectedDropdownCategories.containsKey(categoryId) &&
            selectedDropdownCategories[categoryId]!.categoryName !=
                category.categoryName;

        final hasNewImage =
            uploadedImages.containsKey(categoryId) &&
            uploadedImages[categoryId]!.isNotEmpty;

        final isImageCleared = clearedApiImages.contains(categoryId);

        // Only update categories that have been modified in some way
        if (!hasWebstoreStatusChanged &&
            !hasDropdownCategoryChanged &&
            !hasNewImage &&
            !isImageCleared) {
          log("No changes detected for category $categoryId, skipping update");
          continue;
        }

        List<UpdateCategoryImage> updatedImages = [];

        if (hasNewImage) {
          // Use newly uploaded images
          updatedImages = uploadedImages[categoryId]!;
          log(
            "Including ${updatedImages.length} new image(s) for category $categoryId",
          );
        } else if (isImageCleared) {
          // User explicitly cleared images, so send empty array
          updatedImages = [];
          log("Sending empty image array for cleared category $categoryId");
        } else if (category.images != null && category.images!.isNotEmpty) {
          // Preserve existing images if no new upload and no explicit clearing
          updatedImages =
              category.images!
                  .map(
                    (img) => UpdateCategoryImage(
                      id: img.id,
                      fileName: img.fileName,
                      fileType: img.fileType,
                      s3Key: img.s3Key,
                      presignedUrl: img.presignedUrl,
                    ),
                  )
                  .toList();
          log(
            "Preserving ${updatedImages.length} existing image(s) for category $categoryId",
          );
        }

        String? categoryName = category.categoryName;

        if (selectedDropdownCategories.containsKey(categoryId)) {
          final selectedCategory = selectedDropdownCategories[categoryId]!;
          categoryName = selectedCategory.categoryName;
          log(
            "Using selected dropdown category: $categoryName (ID: ${selectedCategory.id}) for grid item $categoryId",
          );
        }

        final updateRequest = UpdateCategoryRequest(
          id: categoryId,
          categoryName: categoryName,
          isWebstore:
              categoryWebstoreStatus.containsKey(categoryId)
                  ? categoryWebstoreStatus[categoryId]
                  : category.isWebstore,
          images: updatedImages,
        );

        updateRequests.add(updateRequest);
        log(
          "Prepared update request for category $categoryId with name $categoryName and ${updateRequest.images?.length ?? 0} image(s)",
        );
      }

      if (updateRequests.isNotEmpty) {
        await _webstoreRepository.updateCategories(updateRequests);
        log("Updated ${updateRequests.length} categories");
      } else {
        log("No categories to update");
      }
    } catch (e) {
      log("Error updating category details: $e");
      rethrow;
    }
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;
      await uploadCategoryImages();
      await updateCategoryDetails();
      localCategoryImages.clear();
      uploadedImages.clear();
      clearedApiImages.clear();
      showSuccessToast(message: "All changes saved successfully");
      await fetchAllCategoriesForGrid();
    } catch (e) {
      log("Error saving changes: $e");
      showErrorToast(message: "Failed to save changes");
    } finally {
      isLoading.value = false;
    }
  }

  void addNewCategory() {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final newCategory = GetAllCategoriesValue(
      id: tempId,
      categoryName: 'Select a category',
      isWebstore: true,
      images: [],
    );

    categoriesForGrid.add(newCategory);
    categoryControllers[tempId] = TextEditingController(text: '');
    categoryFocusNodes[tempId] = FocusNode();
    categoryWebstoreStatus[tempId] = true;
    localCategoryImages[tempId] = [];
    categoriesForGrid.refresh();

    Future.delayed(const Duration(milliseconds: 100), () {
      categoryFocusNodes[tempId]?.requestFocus();
    });

    log("Added new category with temporary ID: $tempId");
  }

  @override
  void onClose() {
    for (final controller in categoryControllers.values) {
      controller.dispose();
    }

    for (final focusNode in categoryFocusNodes.values) {
      focusNode.dispose();
    }

    super.onClose();
  }
}
