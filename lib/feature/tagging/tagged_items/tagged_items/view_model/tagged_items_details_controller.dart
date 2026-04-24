import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_images_upload_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_detailed_tagging_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_tagged_item_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/update_tagged_item_by_id_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/widget/detail_view_widgets/stone_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/widget/detail_view_widgets/tagged_item_details_bottom_sheet_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view_model/tagged_items_image_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class TaggedItemsDetailsController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  // Add BaseFilterController
  final BaseFilterController filterController = Get.put(BaseFilterController());

  // Store the current record ID
  String currentRecordId = '';

  final headers =
      [
        "Sn",
        "Code",
        "Tag No.",
        "Barcode No.",
        "Purity",
        "Item",
        "Pcs",
        "N.Wt (gm)",
        "G.Wt (gm)",
        "Stone Wt(gm)",
        "Counter",
        "Images",
        "",
      ].obs;

  final columnWidths = [
    0.1,
    0.2,
    0.2,
    0.3,
    0.3,
    0.8,
    0.25,
    0.35,
    0.35,
    0.35,
    0.35,
    0.25,
    0.1,
  ];

  final totalHeadersValue =
      ["", "", "Total", "", "", "", "0", "0", "0", "0", "", "", ""].obs;

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getOrnamentTypeListingResponse =
      Rx<ApiResponse<GetTaggedItemsByIdResponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  final selectedItemIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // filterController.resetAllFilters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize filter controller with required filter types
      filterController.fetchAllDropdownData(
        filterTypes: [
          'metalType',
          'ornament',
          'weightGroup',
          'stockHead',
          'design',
          'purity',
          'counter',
          'vendor',
        ],
      );
    });
  }

  void updateTotalHeadersValue() {
    if (getOrnamentTypeListingResponse.value.data?.lineItems == null) {
      return;
    }

    double totalPcs = 0;
    double totalNwt = 0;
    double totalGwt = 0;
    double totalStoneWt = 0;

    for (var item in getOrnamentTypeListingResponse.value.data!.lineItems!) {
      // Sum pieces
      totalPcs += item.pieces?.toDouble() ?? 0;

      // Sum net weight
      totalNwt += double.tryParse(item.netWeight ?? '0') ?? 0;

      // Sum gross weight
      totalGwt += double.tryParse(item.grossWeight ?? '0') ?? 0;

      // Sum stone weight
      if (item.lineStones != null) {
        for (var stone in item.lineStones!) {
          if (stone.carat != null) {
            totalStoneWt += double.tryParse(stone.carat ?? '0') ?? 0;
          } else if (stone.weight != null) {
            // Convert weight to carat (1 carat = 0.2 grams)
            double caratInGms = (double.tryParse(stone.weight ?? '0') ?? 0) * 5;
            totalStoneWt += caratInGms;
          }
        }
      }
    }

    // Update totalHeadersValue with calculated totals
    totalHeadersValue.value = [
      "", // Sr
      "", // Code
      "Total", // Tag No
      "", // Barcode
      "", // Purity
      "", // Item
      totalPcs.toStringAsFixed(2), // Pcs
      totalNwt.toStringAsFixed(3), // N.Wt
      totalGwt.toStringAsFixed(3), // G.Wt
      getOrnamentTypeListingResponse.value.data?.stoneData?.isNotEmpty == true
          ? "${totalStoneWt.toStringAsFixed(3)} "
          : totalStoneWt.toStringAsFixed(3), // Stone Wt
      "", // Counter
      "", // Images
      "", // Empty for actions
    ];
  }

  void showStoneDetailsDialog() {
    final stoneData = getOrnamentTypeListingResponse.value.data?.stoneData;

    Get.dialog(
      StoneDetailsDialog(stoneData: stoneData),
      barrierDismissible: true,
    );
  }

  final RxInt selectedRowIndex = (-1).obs;

  void selectPreviousRow() {
    final currentItems =
        getOrnamentTypeListingResponse.value.data?.lineItems?.length ?? 0;
    if (currentItems == 0) return;

    if (selectedRowIndex.value > 0) {
      showItemDetails(index: selectedRowIndex.value - 1);
    } else if (selectedRowIndex.value == -1 && currentItems > 0) {
      showItemDetails(index: 0);
    }
  }

  void selectNextRow() {
    final currentItems =
        getOrnamentTypeListingResponse.value.data?.lineItems?.length ?? 0;
    if (currentItems == 0) return;

    final maxIndex = currentItems - 1;
    if (selectedRowIndex.value < maxIndex) {
      showItemDetails(index: selectedRowIndex.value + 1);
    } else if (selectedRowIndex.value == -1 && currentItems > 0) {
      showItemDetails(index: 0);
    }
  }

  // Create request body from filters - UPDATED for multi-select
  GetDetailedTaggingItemRequest? createRequestBodyFromFilters() {
    bool hasFilters = false;
    final request = GetDetailedTaggingItemRequest();

    // Metal Type filter - using multi-select list
    if (filterController.selectedMetalTypes.isNotEmpty) {
      request.metalTypeIds =
          filterController.selectedMetalTypes
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Ornament filter - using multi-select list
    if (filterController.selectedOrnaments.isNotEmpty) {
      request.ornamentIds =
          filterController.selectedOrnaments
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Weight Group filter - using multi-select list
    if (filterController.selectedWeightGroups.isNotEmpty) {
      request.weightGroupIds =
          filterController.selectedWeightGroups
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Stock Head filter - using multi-select list
    if (filterController.selectedStockHeads.isNotEmpty) {
      request.stockHeadIds =
          filterController.selectedStockHeads
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Design filter - using multi-select list
    if (filterController.selectedDesigns.isNotEmpty) {
      request.designIds =
          filterController.selectedDesigns
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Purity filter - using multi-select list
    if (filterController.selectedPurities.isNotEmpty) {
      request.purities =
          filterController.selectedPurities
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Counter filter - using multi-select list
    if (filterController.selectedCounters.isNotEmpty) {
      request.counterIds =
          filterController.selectedCounters
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Vendor filter - using multi-select list
    if (filterController.selectedVendors.isNotEmpty) {
      request.vendorIds =
          filterController.selectedVendors
              .where((item) => item.id != null)
              .map((item) => item.id!)
              .toList();
      hasFilters = true;
    }

    // Gross weight range filter
    if (filterController.minGrossWeight.value != null ||
        filterController.maxGrossWeight.value != null) {
      request.grossWeightRange = WeightRange(
        rangeFrom: filterController.minGrossWeight.value,
        rangeTo: filterController.maxGrossWeight.value,
      );
      hasFilters = true;
    }

    // Net weight range filter
    if (filterController.minNetWeight.value != null ||
        filterController.maxNetWeight.value != null) {
      request.nettWeightRange = WeightRange(
        rangeFrom: filterController.minNetWeight.value,
        rangeTo: filterController.maxNetWeight.value,
      );
      hasFilters = true;
    }

    // Log the request for debugging
    if (hasFilters) {
      log("Filter request body: ${request.toJson()}");
    }

    return hasFilters ? request : null;
  }

  // Apply filters method
  void applyFilters() {
    if (currentRecordId.isNotEmpty) {
      getTaggedItemsById(id: currentRecordId);
    }
  }

  // Clear filters method
  void clearFilters() {
    filterController.resetAllFilters();
    if (currentRecordId.isNotEmpty) {
      getTaggedItemsById(id: currentRecordId);
    }
  }

  Future<void> getTaggedItemsById({required String id}) async {
    currentRecordId = id; // Store the ID for filter refresh
    getOrnamentTypeListingResponse.value = ApiResponse.loading("LOADING");

    try {
      // Create request body from filters
      final requestBody = createRequestBodyFromFilters();

      // Use the appropriate API based on whether filters are applied
      final response = await inventoryRepository.getDetailedTaggedItems(
        id: id,
        requestBody: requestBody,
      );

      getOrnamentTypeListingResponse.value = ApiResponse.completed(response);
      updateTotalHeadersValue();

      var list = response.lineItems ?? [];
      if (list.isNotEmpty) {
        selectedRowIndex.value = 0;
      } else {
        selectedRowIndex.value = -1;
      }
    } catch (e) {
      getOrnamentTypeListingResponse.value = ApiResponse.error(e.toString());
      selectedRowIndex.value = -1;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      // Search logic can be implemented here if needed
    });
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  final RxBool isItemDetailsVisible = false.obs;

  void showItemDetails({required int index}) {
    selectedItemIndex.value = index;
    selectedRowIndex.value = index;

    TaggedItemDetailsImageUploadController
    taggedItemDetailsImageUploadController =
        Get.find<TaggedItemDetailsImageUploadController>();

    final data = getOrnamentTypeListingResponse.value.data?.lineItems
        ?.elementAt(index);
    if (data != null && data.id != null) {
      taggedItemDetailsImageUploadController.populateWithFetchedData(data);
    }
    isItemDetailsVisible.value = true;
  }

  void hideItemDetails() {
    isItemDetailsVisible.value = false;
  }

  // Keep all other existing methods unchanged...
  void showPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: getDeviceWidth(context),
        minWidth: getDeviceWidth(context),
      ),
      builder: (BuildContext context) {
        return const TaggedItemDetailsBottomSheetWidget();
      },
    );
  }

  final postTaggedItemImagesResponse = Rx<ApiResponse<ImagesUploadResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<List<ImageRequestModel>> uploadImages({
    required String lineItemId,
    required List<ImageData> images,
  }) async {
    postTaggedItemImagesResponse.value = ApiResponse.loading(
      "uploading images",
    );
    try {
      List<ImageRequestModel> imageRequests =
          images.map((imageData) {
            final filePath = imageData.path;
            final extension = path.extension(filePath).replaceAll(".", "");
            final fileName = path
                .basenameWithoutExtension(filePath)
                .replaceAll(" ", "_");

            return ImageRequestModel(
              fileName: fileName,
              fileType: extension,
              s3_key: "",
            );
          }).toList();

      if (imageRequests.isEmpty) {
        return [];
      }

      final response = await inventoryRepository.addTaggedItemsImages(
        images: imageRequests,
      );

      int index = 0;
      for (var element in response.images ?? <ImageResponseModel>[]) {
        try {
          final image = images[index];
          final res = await inventoryRepository.putDesignImages(
            putUrl: element.presignedUrl ?? "",
            imagePath: image.path,
          );
          index++;
          log("Put response: $res");
        } catch (e) {
          log("Error in uploading put images : $e");
          rethrow;
        }
      }

      final list = response.images ?? [];
      postTaggedItemImagesResponse.value = ApiResponse.completed(response);

      return list
          .map(
            (e) => ImageRequestModel(
              fileName: e.fileName,
              fileType: e.fileType,
              s3_key: e.s3Key,
            ),
          )
          .toList();
    } catch (e, s) {
      log("Error in uploading images : $e, \n $s");
      postTaggedItemImagesResponse.value = ApiResponse.error(e.toString());
      rethrow;
    }
  }

  final postDesignResponse = Rx<ApiResponse<GetTaggedItemsByIdResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> updateTaggedItems({
    required String id,
    required TaggedItemDetailsImageUploadController
    taggedItemDetailsImageUploadController,
  }) async {
    try {
      postDesignResponse.value = ApiResponse.loading("Loading...");

      final listOfLineItems =
          getOrnamentTypeListingResponse.value.data?.lineItems ?? [];
      List<UpdateTaggedItemsByIdRequestLineItem> updatedLineItems = [];

      for (var element in listOfLineItems) {
        if (element.id == null) continue;

        List<ImageData> lineItemImagesList =
            taggedItemDetailsImageUploadController.getImagesForLineItem(
              element.id!,
            );

        List<ImageData> newImages =
            lineItemImagesList.where((img) => img.isFile).toList();

        List<ImageRequestModel> oldUploadedImages =
            lineItemImagesList
                .where((img) => !img.isFile)
                .map(
                  (e) => ImageRequestModel(
                    fileName: e.fileName,
                    fileType: e.fileType,
                    s3_key: e.s3Key,
                  ),
                )
                .toList();

        List<ImageRequestModel> newUploadedImages = [];
        if (newImages.isNotEmpty) {
          newUploadedImages = await uploadImages(
            lineItemId: element.id!,
            images: newImages,
          );
        }

        final images = [...newUploadedImages, ...oldUploadedImages];

        updatedLineItems.add(
          UpdateTaggedItemsByIdRequestLineItem(
            id: element.id,
            vendorId: element.vendorId,
            code: element.code,
            codeId: element.codeId,
            tagBarcode: element.tagBarcode,
            pieces: element.pieces?.toDouble(),
            grossWeight: double.tryParse(element.grossWeight ?? "-"),
            netWeight: double.tryParse(element.netWeight ?? '-'),
            va: double.tryParse(element.va ?? "-"),
            mc: double.tryParse(element.mc ?? "-"),
            rate: double.tryParse(element.rate ?? "-"),
            huid: element.huid,
            purity: element.purity,
            design: ObjectWithOnlyId(id: element.design?.id),
            sizeGroup: ObjectWithOnlyId(id: element.sizeGroup?.id),
            counter: ObjectWithOnlyId(id: element.counter?.id),
            images: images,
            lineStones: element.lineStones,
          ),
        );
      }

      UpdateTaggedItemsByIdRequest updateRequest = UpdateTaggedItemsByIdRequest(
        id: getOrnamentTypeListingResponse.value.data?.id,
        organizationId:
            getOrnamentTypeListingResponse.value.data?.organizationId,
        shopId: listOfLineItems.first.shopId,
        recordNumber: getOrnamentTypeListingResponse.value.data?.recordNumber,
        taggedById: getOrnamentTypeListingResponse.value.data?.taggedById,
        lineItems: updatedLineItems,
      );

      final response = await inventoryRepository.updateTaggedItems(
        updateTaggedItemsByIdRequest: updateRequest,
        id: id,
      );

      postDesignResponse.value = ApiResponse.completed(response);
      taggedItemDetailsImageUploadController.clearControllers();
      showSuccessToast(message: "Item updated successfully!");
      SidebarController sidebarController = Get.find();
      sidebarController.popBackSelectedWidget();
    } catch (e) {
      log("Error update design $e");
      if (e is ApiException) {
        if (e.toStringPrefix() == "Bad Request Exception") {
          final handledError = handleDTOResponseErrors(e);
          showErrorToast(
            message: handledError.message ?? "Something went wrong",
          );
          postDesignResponse.value = ApiResponse.error(handledError.message);
        } else {
          showErrorToast(message: e.toStringPrefix());
          postDesignResponse.value = ApiResponse.error(e.toStringPrefix());
        }
      }
    }
  }
}
