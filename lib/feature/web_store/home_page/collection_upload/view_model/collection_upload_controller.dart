import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/image_cropper_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/model/get_all_collection_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/model/update_collection_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/model/collection_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CollectionImageData {
  final String path;
  final bool isLocal;

  CollectionImageData({required this.path, required this.isLocal});
}

class CollectionUploadController extends GetxController {
  final WebstoreRepository _webstoreRepository = WebstoreRepository();

  final webstoreCollectionsResponse = Rx<ApiResponse<GetAllCollectionResponse>>(
    ApiResponse.initial("Initial"),
  );
  final RxList<GetAllCollectionValue> collectionsForGrid =
      <GetAllCollectionValue>[].obs;

  final dropdownCollectionsResponse = Rx<ApiResponse<GetAllCollectionResponse>>(
    ApiResponse.initial("Initial"),
  );

  final dropdownCollections = <GetAllCollectionValue>[].obs;
  final collectionControllers = <String, TextEditingController>{};
  final collectionFocusNodes = <String, FocusNode>{};
  final selectedDropdownCollections = <String, GetAllCollectionValue>{}.obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final localCollectionImages = RxMap<String, List<CollectionImageData>>();
  final collectionWebstoreStatus = RxMap<String, bool>();
  final uploadedImages = RxMap<String, List<UpdateCollectionImage>>();
  final clearedApiImages = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCollectionsForDropdown().then((_) {
      fetchAllCollectionForGrid();
    });
  }

  void _initControllersForCollections() {
    for (final controller in collectionControllers.values) {
      controller.dispose();
    }
    for (final node in collectionFocusNodes.values) {
      node.dispose();
    }
    collectionControllers.clear();
    collectionFocusNodes.clear();
    selectedDropdownCollections.clear();

    for (final collection in collectionsForGrid) {
      if (collection.id != null) {
        collectionControllers[collection.id!] = TextEditingController();
        collectionFocusNodes[collection.id!] = FocusNode();

        final exactMatch = dropdownCollections.firstWhere(
          (dropdownCollection) => dropdownCollection.id == collection.id,
          orElse: () => GetAllCollectionValue(),
        );

        if (exactMatch.id != null) {
          selectedDropdownCollections[collection.id!] = exactMatch;
          collectionControllers[collection.id!]!.text =
              exactMatch.collectionName ?? '';
          log(
            "Pre-selected collection with exact ID match: ${exactMatch.collectionName} (ID: ${exactMatch.id})",
          );
        } else if (collection.collectionName != null &&
            collection.collectionName!.isNotEmpty) {
          final nameMatch = dropdownCollections.firstWhere(
            (dropdownCollection) =>
                dropdownCollection.collectionName == collection.collectionName,
            orElse: () => GetAllCollectionValue(),
          );

          if (nameMatch.id != null) {
            selectedDropdownCollections[collection.id!] = nameMatch;
            collectionControllers[collection.id!]!.text =
                nameMatch.collectionName ?? '';
            log(
              "Pre-selected collection with name match: ${nameMatch.collectionName} (ID: ${nameMatch.id})",
            );
          } else {
            collectionControllers[collection.id!]!.text =
                collection.collectionName ?? '';
            log(
              "No match found for collection: ${collection.collectionName} (ID: ${collection.id})",
            );
          }
        }
      }
    }
  }

  TextEditingController getCollectionController(String collectionId) {
    if (!collectionControllers.containsKey(collectionId)) {
      collectionControllers[collectionId] = TextEditingController();
    }
    return collectionControllers[collectionId]!;
  }

  FocusNode getCollectionFocusNode(String collectionId) {
    if (!collectionFocusNodes.containsKey(collectionId)) {
      collectionFocusNodes[collectionId] = FocusNode();
    }
    return collectionFocusNodes[collectionId]!;
  }

  void setSelectedCollection(
    String collectionId,
    GetAllCollectionValue selectedCollection,
  ) {
    if (selectedCollection.id != null) {
      selectedDropdownCollections[collectionId] = selectedCollection;

      final controller = collectionControllers[collectionId];
      if (controller != null) {
        controller.text = selectedCollection.collectionName ?? '';
      }

      if (collectionId.startsWith('temp_')) {
        log(
          "Updating temporary collection $collectionId to use ID from selected collection: ${selectedCollection.id}",
        );

        final index = collectionsForGrid.indexWhere(
          (col) => col.id == collectionId,
        );
        if (index >= 0) {
          final updatedCollection = GetAllCollectionValue(
            id: selectedCollection.id,
            collectionName: selectedCollection.collectionName,
            isWebstore: collectionWebstoreStatus[collectionId] ?? true,
            images: [],
          );

          collectionsForGrid[index] = updatedCollection;

          collectionControllers[selectedCollection.id!] =
              collectionControllers[collectionId]!;
          collectionFocusNodes[selectedCollection.id!] =
              collectionFocusNodes[collectionId]!;
          collectionControllers.remove(collectionId);
          collectionFocusNodes.remove(collectionId);

          collectionWebstoreStatus[selectedCollection.id!] =
              collectionWebstoreStatus[collectionId]!;
          collectionWebstoreStatus.remove(collectionId);

          if (localCollectionImages.containsKey(collectionId)) {
            localCollectionImages[selectedCollection.id!] =
                localCollectionImages[collectionId]!;
            localCollectionImages.remove(collectionId);
          }

          selectedDropdownCollections[selectedCollection.id!] =
              selectedCollection;
          selectedDropdownCollections.remove(collectionId);

          if (clearedApiImages.contains(collectionId)) {
            clearedApiImages.remove(collectionId);
            clearedApiImages.add(selectedCollection.id!);
          }

          if (uploadedImages.containsKey(collectionId)) {
            uploadedImages[selectedCollection.id!] =
                uploadedImages[collectionId]!;
            uploadedImages.remove(collectionId);
          }

          log(
            "Successfully updated temporary collection ID $collectionId to ${selectedCollection.id}",
          );

          collectionsForGrid.refresh();
          collectionWebstoreStatus.refresh();
          localCollectionImages.refresh();
          selectedDropdownCollections.refresh();
          if (uploadedImages.isNotEmpty) uploadedImages.refresh();
        }
      } else {
        log(
          "Selected collection: ${selectedCollection.collectionName} (ID: ${selectedCollection.id}) for grid item: $collectionId",
        );
      }
    }
  }

  Future<void> fetchAllCollectionForGrid() async {
    try {
      isLoading.value = true;
      webstoreCollectionsResponse.value = ApiResponse.loading(
        "Loading collections...",
      );
      log(
        'Starting to fetch collections. Status: ${webstoreCollectionsResponse.value.status}',
      );

      final response = await _webstoreRepository.getAllCollections(
        is_webstore: true,
      );
      log(
        'Received API response for collections. Data present: ${response.values != null}',
      );
      log('Number of collections: ${response.values?.length ?? 0}');

      if (response.values != null) {
        collectionsForGrid.value = response.values!;

        for (var collection in response.values!) {
          if (collection.id != null) {
            collectionWebstoreStatus[collection.id!] =
                collection.isWebstore ?? false;
          }
        }

        _initControllersForCollections();
        log('Successfully processed ${collectionsForGrid.length} collections');
      } else {
        collectionsForGrid.value = [];
        log('API returned empty values, setting empty collections list');
      }

      webstoreCollectionsResponse.value = ApiResponse.completed(response);
      log('Set collections response to COMPLETED status');
    } catch (e, stack) {
      log('Error fetching webstore collections: $e $stack');
      webstoreCollectionsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch webstore collections");
      log('Set collections response to ERROR status');
    } finally {
      isLoading.value = false;
      log('Loading state set to false');
    }
  }

  Future<void> fetchCollectionsForDropdown() async {
    try {
      dropdownCollectionsResponse.value = ApiResponse.loading(
        "Fetching dropdown collections",
      );

      final response = await _webstoreRepository.getAllCollections();

      if (response.values != null) {
        dropdownCollections.value = response.values!;
        log("Loaded ${response.values!.length} dropdown collections");
      } else {
        dropdownCollections.clear();
        log("No dropdown collections found");
      }

      dropdownCollectionsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching dropdown collections: $e');
      showErrorToast(message: "Failed to fetch dropdown collections");
      dropdownCollectionsResponse.value = ApiResponse.error(e.toString());
      dropdownCollections.clear();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<GetAllCollectionValue> get filteredCollections {
    if (searchQuery.value.isEmpty) {
      return collectionsForGrid;
    }

    return collectionsForGrid.where((collection) {
      return collection.collectionName?.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ??
          false;
    }).toList();
  }

  List<CollectionImageData> getCollectionImages(String collectionId) {
    final List<CollectionImageData> allImages = [];

    final collection = collectionsForGrid.firstWhere(
      (col) => col.id == collectionId,
      orElse: () => GetAllCollectionValue(),
    );

    if (collection.images != null) {
      for (var image in collection.images!) {
        if (image.presignedUrl != null &&
            image.presignedUrl.toString().isNotEmpty) {
          allImages.add(
            CollectionImageData(
              path: image.presignedUrl.toString(),
              isLocal: false,
            ),
          );
        }
      }
    }

    if (localCollectionImages.containsKey(collectionId)) {
      allImages.addAll(localCollectionImages[collectionId]!);
    }

    return allImages;
  }

  Future<void> pickAndCropImage(String collectionId) async {
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
              if (!localCollectionImages.containsKey(collectionId)) {
                localCollectionImages[collectionId] = [];
              }

              localCollectionImages[collectionId]!.clear();
              localCollectionImages[collectionId]!.add(
                CollectionImageData(path: croppedPath, isLocal: true),
              );
              localCollectionImages.refresh();
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

  void clearCollectionImage(String collectionId) {
    // Remove any local images
    if (localCollectionImages.containsKey(collectionId)) {
      localCollectionImages[collectionId]!.clear();
      localCollectionImages.refresh();
    }

    // Check if this collection has API images before marking as cleared
    final collection = collectionsForGrid.firstWhere(
      (col) => col.id == collectionId,
      orElse: () => GetAllCollectionValue(),
    );

    if (collection.images != null && collection.images!.isNotEmpty) {
      // Only mark as cleared if it actually has API images to clear
      clearedApiImages.add(collectionId);
      log("Marked API images as cleared for collection $collectionId");
    }

    // Clear any uploaded images for this collection
    if (uploadedImages.containsKey(collectionId)) {
      uploadedImages[collectionId]!.clear();
      uploadedImages.refresh();
    }

    log("Cleared images for collection $collectionId");
  }

  bool isApiImageCleared(String collectionId) {
    return clearedApiImages.contains(collectionId);
  }

  void toggleWebstoreStatus(String collectionId) {
    if (collectionWebstoreStatus.containsKey(collectionId)) {
      collectionWebstoreStatus[collectionId] =
          !collectionWebstoreStatus[collectionId]!;
    } else {
      final collection = collectionsForGrid.firstWhere(
        (col) => col.id == collectionId,
        orElse: () => GetAllCollectionValue(isWebstore: false),
      );

      collectionWebstoreStatus[collectionId] =
          !(collection.isWebstore ?? false);
    }

    collectionWebstoreStatus.refresh();
    log(
      "Toggled webstore status for collection $collectionId to: ${collectionWebstoreStatus[collectionId]}",
    );
  }

  bool getCollectionWebstoreStatus(String collectionId) {
    if (collectionWebstoreStatus.containsKey(collectionId)) {
      return collectionWebstoreStatus[collectionId]!;
    }

    final collection = collectionsForGrid.firstWhere(
      (col) => col.id == collectionId,
      orElse: () => GetAllCollectionValue(),
    );

    return collection.isWebstore ?? false;
  }

  Future<void> uploadCollectionImages() async {
    try {
      uploadedImages.clear();

      for (var entry in localCollectionImages.entries) {
        final collectionId = entry.key;
        final images = entry.value;

        if (images.isNotEmpty) {
          final localImage = images[0];
          final imagePath = localImage.path;
          final extension = path.extension(imagePath).replaceAll(".", "");
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final filename = "${collectionId}_$timestamp.$extension";

          final presignedUrlRequest = CollectionImagesPresignedUrlRequest(
            images: [
              CollectionImagesPresignedUrlImage(
                fileName: filename,
                fileType: extension,
              ),
            ],
          );

          final presignedUrlResponse = await _webstoreRepository
              .collectionImagePresignedUrl(presignedUrlRequest);

          if (presignedUrlResponse.images != null &&
              presignedUrlResponse.images!.isNotEmpty) {
            final imageData = presignedUrlResponse.images![0];

            await _webstoreRepository.putCollectionImages(
              putUrl: imageData.presignedUrl ?? "",
              imagePath: imagePath,
            );

            if (!uploadedImages.containsKey(collectionId)) {
              uploadedImages[collectionId] = [];
            }

            final updatedImage = UpdateCollectionImage(
              fileName: imageData.fileName,
              fileType: imageData.fileType,
              s3Key: imageData.s3Key,
            );

            uploadedImages[collectionId]!.add(updatedImage);

            log("Successfully uploaded image for collection: $collectionId");
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

  Future<void> updateCollectionDetails() async {
    try {
      final tempCollections =
          collectionsForGrid
              .where((col) => col.id != null && col.id!.startsWith('temp_'))
              .toList();
      if (tempCollections.isNotEmpty) {
        log(
          "Warning: Found ${tempCollections.length} temporary collections without selected dropdown collections",
        );
      }

      List<UpdateCollectionRequest> updateRequests = [];

      for (var collection in collectionsForGrid) {
        final collectionId = collection.id;

        if (collectionId == null || collectionId.startsWith('temp_')) continue;

        // Check for various types of changes
        final hasWebstoreStatusChanged =
            collectionWebstoreStatus.containsKey(collectionId) &&
            collectionWebstoreStatus[collectionId] != collection.isWebstore;

        final hasDropdownCollectionChanged =
            selectedDropdownCollections.containsKey(collectionId) &&
            selectedDropdownCollections[collectionId]!.collectionName !=
                collection.collectionName;

        final hasNewImage =
            uploadedImages.containsKey(collectionId) &&
            uploadedImages[collectionId]!.isNotEmpty;

        final isImageCleared = clearedApiImages.contains(collectionId);

        // Only update collections that have been modified in some way
        if (!hasWebstoreStatusChanged &&
            !hasDropdownCollectionChanged &&
            !hasNewImage &&
            !isImageCleared) {
          log(
            "No changes detected for collection $collectionId, skipping update",
          );
          continue;
        }

        List<UpdateCollectionImage> updatedImages = [];

        if (hasNewImage) {
          // Use newly uploaded images
          updatedImages = uploadedImages[collectionId]!;
          log(
            "Including ${updatedImages.length} new image(s) for collection $collectionId",
          );
        } else if (isImageCleared) {
          // User explicitly cleared images, so send empty array
          updatedImages = [];
          log("Sending empty image array for cleared collection $collectionId");
        } else if (collection.images != null && collection.images!.isNotEmpty) {
          // Preserve existing images if no new upload and no explicit clearing
          updatedImages =
              collection.images!
                  .map(
                    (img) => UpdateCollectionImage(
                      id: img.id,
                      fileName: img.fileName,
                      fileType: img.fileType,
                      s3Key: img.s3Key,
                      presignedUrl: img.presignedUrl,
                    ),
                  )
                  .toList();
          log(
            "Preserving ${updatedImages.length} existing image(s) for collection $collectionId",
          );
        }

        String? collectionName = collection.collectionName;

        if (selectedDropdownCollections.containsKey(collectionId)) {
          final selectedCollection = selectedDropdownCollections[collectionId]!;
          collectionName = selectedCollection.collectionName;
          log(
            "Using selected dropdown collection: $collectionName (ID: ${selectedCollection.id}) for grid item $collectionId",
          );
        }

        final updateRequest = UpdateCollectionRequest(
          id: collectionId,
          collectionName: collectionName,
          isWebstore:
              collectionWebstoreStatus.containsKey(collectionId)
                  ? collectionWebstoreStatus[collectionId]
                  : collection.isWebstore,
          images: updatedImages,
        );

        updateRequests.add(updateRequest);
        log(
          "Prepared update request for collection $collectionId with name $collectionName and ${updateRequest.images?.length ?? 0} image(s)",
        );
      }

      if (updateRequests.isNotEmpty) {
        await _webstoreRepository.updateCollection(updateRequests);
        log("Updated ${updateRequests.length} collections");
      } else {
        log("No collections to update");
      }
    } catch (e) {
      log("Error updating collection details: $e");
      rethrow;
    }
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;
      await uploadCollectionImages();
      await updateCollectionDetails();
      localCollectionImages.clear();
      uploadedImages.clear();
      clearedApiImages.clear();
      showSuccessToast(message: "All changes saved successfully");
      await fetchAllCollectionForGrid();
    } catch (e) {
      log("Error saving changes: $e");
      showErrorToast(message: "Failed to save changes");
    } finally {
      isLoading.value = false;
    }
  }

  void addNewCollection() {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final newCollection = GetAllCollectionValue(
      id: tempId,
      collectionName: 'Select a collection',
      isWebstore: true,
      images: [],
    );

    collectionsForGrid.add(newCollection);
    collectionControllers[tempId] = TextEditingController(text: '');
    collectionFocusNodes[tempId] = FocusNode();
    collectionWebstoreStatus[tempId] = true;
    localCollectionImages[tempId] = [];
    collectionsForGrid.refresh();

    Future.delayed(const Duration(milliseconds: 100), () {
      collectionFocusNodes[tempId]?.requestFocus();
    });

    log("Added new collection with temporary ID: $tempId");
  }

  @override
  void onClose() {
    for (final controller in collectionControllers.values) {
      controller.dispose();
    }

    for (final focusNode in collectionFocusNodes.values) {
      focusNode.dispose();
    }

    super.onClose();
  }
}
