import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/create_catalogue_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/catalogue_image_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/gemstones_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/metal_color_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/metal_purity_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/catalogue_listing/view_model/order_to_make_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/collection_listing/model/get_collections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class EditCatalogueController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  GemstonesController gemStonesController = Get.put(GemstonesController());

  MetalColorController metalController = Get.put(MetalColorController());

  final ImageUploadController imageUploadController = Get.put(
    ImageUploadController(),
  );

  final RxBool isUploading = false.obs;

  final TextEditingController designNameController = TextEditingController();
  final TextEditingController stoneWeightController = TextEditingController();
  final TextEditingController minWeightController = TextEditingController();
  final TextEditingController maxWeightController = TextEditingController();

  final RxList<GetAllCollectionsValue> collectionOptions =
      <GetAllCollectionsValue>[].obs;
  final collectionSearchController = TextEditingController().obs;
  final collectionFocusNode = FocusNode();
  final Rx<GetAllCollectionsValue?> selectedCollection =
      Rx<GetAllCollectionsValue?>(null);
  final RxBool isCollectionDropdownOpen = false.obs;

  final RxString designType = ''.obs;
  final RxString purity = ''.obs;
  final RxString collection = ''.obs;
  final RxBool isMandatoryDescription = false.obs;

  final getDesignListingResponse =
      Rx<ApiResponse<PaginatedDesignListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  int? nextPageDesign;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 1000;

  final Rx<GetDesignResponseModel?> selectedDesign =
      Rx<GetDesignResponseModel?>(null);
  final designSearchController = TextEditingController().obs;
  final designFocusNode = FocusNode();
  final RxList<GetDesignResponseModel> designOptions =
      <GetDesignResponseModel>[].obs;

  final RxString stoneRateType = 'ct'.obs;

  @override
  void onInit() {
    super.onInit();
    stoneRateType.value = 'ct';
    getDesignListing(resetList: true);
    searchDesigns('');
    searchCollections('');
  }

  @override
  void onClose() {
    designNameController.dispose();
    stoneWeightController.dispose();
    minWeightController.dispose();
    maxWeightController.dispose();
    designSearchController.value.dispose();
    designFocusNode.dispose();
    collectionSearchController.value.dispose();
    collectionFocusNode.dispose();
    super.onClose();
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

  void setSelectedCollection(GetAllCollectionsValue? collection) {
    selectedCollection.value = collection;
    // if (collection != null) {
    //   collection.value = collection.collectionName ?? '';
    // }
  }

  Future<void> searchDesigns(String query) async {
    try {
      setSearchQuery(query);
      final response = await _inventoryRepository.getPaginatedDesign(
        query: query,
        limit: itemsPerPage,
      );
      designOptions.value = response.values ?? [];
      designOptions.refresh();
    } catch (e) {
      log('Error searching designs: $e');
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    getDesignListing(resetList: true, isSearch: true);
  }

  void setInitialConditions({required bool isSearch}) {
    nextPageDesign = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getDesignListing({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getDesignListingResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _inventoryRepository.getPaginatedDesign(
        query: searchQuery.value,
        limit: itemsPerPage,
        nextPage: nextPageDesign,
      );

      if (resetList) {
        getDesignListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getDesignListingResponse.value.data?.values ?? [];
        List<GetDesignResponseModel> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getDesignListingResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.nextPage != null;

      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        nextPageDesign = response.pagination?.nextPage;
      }
    } catch (e) {
      if (resetList) {
        getDesignListingResponse.value = ApiResponse.error(e.toString());
      }
      log('Error fetching design listing: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getDesignListing();
    }
  }

  void setSelectedDesign(GetDesignResponseModel? design) {
    selectedDesign.value = design;
    if (design != null) {
      designType.value = design.name ?? '';
    }
  }

  void toggleMandatoryDescription(bool? value) {
    if (value != null) {
      isMandatoryDescription.value = value;
    }
  }

  Future<void> saveCatalogue() async {
    try {
      if (designNameController.text.isEmpty) {
        showErrorToast(message: "Please enter a design name");
        return;
      }

      if (selectedDesign.value == null) {
        showErrorToast(message: "Please select a design");
        return;
      }

      // Try to parse weight ranges
      double? minWeightValue;
      double? maxWeightValue;
      double? stoneWeightValue;

      try {
        if (minWeightController.text.isNotEmpty) {
          minWeightValue = double.parse(minWeightController.text);
        }
        if (maxWeightController.text.isNotEmpty) {
          maxWeightValue = double.parse(maxWeightController.text);
        }
        if (stoneWeightController.text.isNotEmpty) {
          stoneWeightValue = double.parse(stoneWeightController.text);
        }
      } catch (e) {
        showErrorToast(message: "Please enter valid numbers for weights");
        return;
      }

      if (minWeightValue != null && maxWeightValue != null) {
        if (maxWeightValue < minWeightValue) {
          showErrorToast(
            message: "Maximum weight cannot be less than minimum weight",
          );
          return;
        }
      }

      // Continue with save operation
      isUploading.value = true;

      // Upload images first if any are selected
      List<CreateCatalogueImage> uploadedImages = [];
      if (imageUploadController.imagePaths.isNotEmpty) {
        uploadedImages = await imageUploadController.uploadImages(
          catalogId: selectedDesign.value?.id ?? '',
        );
      }

      // Prepare metal colors
      List<MetalColour> metalColours = [];
      if (metalController.selectedMetalColors.isNotEmpty) {
        metalColours =
            metalController.selectedMetalColors
                .map((color) => MetalColour(colourId: color.id))
                .toList();
      }

      // Prepare purities
      List<Purity> purities = [];
      try {
        final metalPurityController = Get.find<MetalPurityFilterController>();
        if (metalPurityController.selectedPurities.isNotEmpty) {
          purities =
              metalPurityController.selectedPurities.map((purityStr) {
                final purityParts = purityStr.split(' ');

                final purityValue =
                    purityParts.length > 1 ? purityParts[1] : purityStr;

                return Purity(purityType: purityValue);
              }).toList();
        }
      } catch (e) {
        log('MetalPurityFilterController not available: $e');
      }

      // Prepare gemstones
      List<Gemstone> gemstones = [];
      if (gemStonesController.selectedGemstones.isNotEmpty) {
        gemstones =
            gemStonesController.selectedGemstones
                .map((stone) => Gemstone(gemstoneId: stone.id))
                .toList();
      }
      //Collections
      List<Collection> collections = [];
      if (selectedCollection.value != null &&
          selectedCollection.value!.id != null) {
        collections.add(
          Collection(collectionId: selectedCollection.value!.id!),
        );
      }

      String finalStoneRateType;
      switch (stoneRateType.value) {
        case 'ct':
          finalStoneRateType = 'carat';
          break;
        case 'gm':
          finalStoneRateType = 'gram';
          break;
        case 'pcs':
          finalStoneRateType = 'pieces';
          break;
        default:
          finalStoneRateType = 'carat';
          break;
      }
      // Create the request
      final createCatalogueRequest = CreateCatalogueRequest(
        designName: designNameController.text,
        design: selectedDesign.value?.id,
        minWeight: minWeightValue,
        maxWeight: maxWeightValue,
        metalColour: metalColours,
        purity: purities,
        stoneWeight: stoneWeightValue,
        stoneRateType: finalStoneRateType,
        isWebstore: true,
        gemstones: gemstones,
        images: uploadedImages,
        collections: collections,
      );

      log('Sending catalogue request: ${createCatalogueRequest.toRawJson()}');

      try {
        final response = await _inventoryRepository.createCatalogue(
          createCatalogueRequest,
        );
        log(response.toString());

        showSuccessToast(message: "Catalogue saved successfully");
        discard();

        OrderToMakeListingController catalogueListingController = Get.find();
        catalogueListingController.getProductListingDetails(resetList: true);
      } catch (e) {
        log('API response error: $e');
        showErrorToast(message: "Error processing response: ${e.toString()}");
      }
    } catch (e) {
      log('Error saving catalogue: $e');
      showErrorToast(message: "Failed to save catalogue: ${e.toString()}");
    } finally {
      isUploading.value = false;
    }
  }

  void discard() {
    // Reset form fields
    imageUploadController.clearImages();

    designNameController.clear();
    stoneWeightController.clear();
    minWeightController.clear();
    maxWeightController.clear();

    stoneRateType.value = 'ct';

    designType.value = '';
    purity.value = '';
    collection.value = '';
    isMandatoryDescription.value = false;

    // Reset selected design
    selectedDesign.value = null;
    designSearchController.value.text = '';

    // Reset selections in child controllers
    try {
      // Reset gemstones selections
      gemStonesController.selectedGemstones.clear();
      gemStonesController.gemstoneSearchController.value.text = '';
      gemStonesController.gemstones.value = '';

      // Reset metal color selections
      metalController.selectedMetalColors.clear();
      metalController.selectedMetalColor.value = null;
      metalController.metalColorSearchController.value.text = '';
      metalController.metalColor.value = '';

      // Reset metal purity selections
      final metalPurityController = Get.find<MetalPurityFilterController>();
      metalPurityController.selectedMetals.clear();
      metalPurityController.selectedPurities.clear();
    } catch (e) {
      log('Error resetting controller values: $e');
    }

    // Close any open dropdowns
    gemStonesController.isGemstoneDropdownOpen.value = false;
    metalController.isMetalColorDropdownOpen.value = false;

    selectedCollection.value = null;
    collectionSearchController.value.text = '';
    collection.value = '';
    isCollectionDropdownOpen.value = false;
  }
}
