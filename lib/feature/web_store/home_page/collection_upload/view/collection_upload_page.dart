import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/booking_listing/view/booking_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/model/get_all_collection_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/view_model/collection_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
import 'package:svg_flutter/svg.dart';

class CollectionUploadPage extends StatefulWidget {
  const CollectionUploadPage({super.key});

  @override
  State<CollectionUploadPage> createState() => _CollectionUploadPageState();
}

class _CollectionUploadPageState extends State<CollectionUploadPage> {
  late final CollectionUploadController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(CollectionUploadController());
  }

  @override
  void dispose() {
    Get.delete<CollectionUploadController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionBar(context),
                    Obx(() {
                      // Check both the webstoreCollectionsResponse (grid data) and dropdownCollectionsResponse
                      final gridApiResponse =
                          controller.webstoreCollectionsResponse.value;
                      final dropdownApiResponse =
                          controller.dropdownCollectionsResponse.value;

                      // If either request is loading or in initial state, show loading indicator
                      if (gridApiResponse.status == Status.LOADING ||
                          dropdownApiResponse.status == Status.LOADING ||
                          gridApiResponse.status == Status.INITIAL ||
                          dropdownApiResponse.status == Status.INITIAL) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (gridApiResponse.status == Status.ERROR) {
                        // Show error state if grid data loading failed
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text('Error: ${gridApiResponse.message}'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed:
                                      controller.fetchAllCollectionForGrid,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Only show content when both APIs have completed loading
                        return _buildCollectionGrid();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        autofocus: true,
        onChanged: controller.updateSearchQuery,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: _buildSearchField()),
          const SizedBox(width: 16),
          Material(
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: Theme(
              data: Theme.of(context).copyWith(
                focusColor: primaryColor.withBlue(190),
                tooltipTheme: const TooltipThemeData(
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
              child: PopupMenuButton(
                offset: const Offset(0, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                color: Colors.transparent,
                elevation: 4,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      enabled: false,
                      height: 0,
                      padding: const EdgeInsets.all(0),
                      child: AvailableFilterWidget(
                        onSelectionChanged: (selectedTypes) {},
                      ),
                    ),
                  ];
                },
                child: const CustomPopUpIcon(
                  buttonName: 'Filter',
                  image: 'assets/svgs/filter.svg',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.saveChanges,
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 38,
                width: 140,
                child: Center(
                  child: ButtonShortcutWidget(
                    buttonName: "Save",
                    shortcut: "Ctrl + S",
                    buttonsize: 16,
                    color: whiteColor,
                    shortcutButtonColor: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionGrid() {
    return Obx(() {
      final filteredCollections = controller.filteredCollections;

      // Even if no collections are found, we'll show at least the "Add Collection" card
      if (filteredCollections.isEmpty &&
          controller.searchQuery.value.isNotEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No collections found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // Add +1 to include the "Add Collection" card
          itemCount: filteredCollections.length + 1,
          itemBuilder: (context, index) {
            // If it's the last item, show the "Add Collection" card
            if (index == filteredCollections.length) {
              return _buildAddCollectionCard(context);
            }
            // Otherwise, show a regular collection card
            return _buildCollectionCard(context, filteredCollections[index]);
          },
        ),
      );
    });
  }

  Widget _buildCollectionCard(
    BuildContext context,
    GetAllCollectionValue collection,
  ) {
    final collectionId = collection.id ?? '';

    return Obx(() {
      final hasApiImages =
          collection.images != null && collection.images!.isNotEmpty;
      final hasLocalImages =
          controller.localCollectionImages.containsKey(collectionId) &&
          controller.localCollectionImages[collectionId]!.isNotEmpty;
      final isApiImageCleared = controller.isApiImageCleared(collectionId);

      // Determine if there are any valid images to display
      // If API images are cleared, don't count them
      final hasValidImages =
          hasLocalImages || (hasApiImages && !isApiImageCleared);

      final isWebstore = controller.getCollectionWebstoreStatus(collectionId);

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  // If the API image is cleared or there are no images, make it clickable for upload
                  onTap:
                      hasValidImages
                          ? null
                          : () => controller.pickAndCropImage(collectionId),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: grey1,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child:
                        hasValidImages
                            ? _buildImagePreview(collectionId, collection)
                            : _buildEmptyImageState(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomText(
                text: collection.collectionName ?? "Unknown Collection",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            CollectionDropdownWidget(collectionId: collectionId),
            const SizedBox(height: 12),
            Center(
              child: _buildClearButton(
                collectionId,
                isWebstore,
                hasValidImages,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildImagePreview(
    String collectionId,
    GetAllCollectionValue collection,
  ) {
    final hasLocalImages =
        controller.localCollectionImages.containsKey(collectionId) &&
        controller.localCollectionImages[collectionId]!.isNotEmpty;

    final isApiImageCleared = controller.isApiImageCleared(collectionId);

    // If API images are cleared and there are no local images, show empty state
    if (isApiImageCleared && !hasLocalImages) {
      return _buildEmptyImageState();
    }

    // If there is a local image, show it first
    if (hasLocalImages) {
      final imagePath = controller.localCollectionImages[collectionId]![0].path;
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => controller.pickAndCropImage(collectionId),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: primaryColor),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // If no local image but has API images with presigned URL and not cleared
    if (!isApiImageCleared &&
        collection.images != null &&
        collection.images!.isNotEmpty) {
      // Find an image with a valid presigned URL
      GetAllCollectionImage? validImage;

      for (var image in collection.images!) {
        if (image.presignedUrl != null && image.presignedUrl!.isNotEmpty) {
          validImage = image;
          break;
        }
      }

      if (validImage != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  validImage.presignedUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 30,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load image',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => controller.pickAndCropImage(collectionId),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    // If no valid images found, show empty state
    return _buildEmptyImageState();
  }

  Widget _buildEmptyImageState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svgs/upload.svg',
          color: primaryColor,
          width: 30,
          height: 30,
        ),
        SizedBox(height: Get.height * 0.0125),
        const Text(
          'Upload Thumbnail',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Supported formats are JPEG & PNG Recommended Size Upto 5mb',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildClearButton(
    String collectionId,
    bool isWebstore,
    bool hasImages,
  ) {
    return Container(
      height: 35,
      width: 134,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => controller.toggleWebstoreStatus(collectionId),
                child: Container(
                  color: isWebstore ? primaryColor : Colors.grey,
                  child: Center(
                    child: Tooltip(
                      message:
                          isWebstore
                              ? "Visible on Webstore"
                              : "Hidden on Webstore",
                      child: const Icon(
                        Icons.visibility,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap:
                    hasImages
                        ? () => controller.clearCollectionImage(collectionId)
                        : null,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: hasImages ? Colors.red : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCollectionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.addNewCollection(),
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: primaryColor, size: 36),
              ),
              const SizedBox(height: 16),
              const CustomText(
                text: "Add New Collection",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Create a new collection for your webstore",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CollectionDropdownWidget extends StatelessWidget {
  final String collectionId;

  const CollectionDropdownWidget({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollectionUploadController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Choose Collection",
            color: primaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: Get.height * 0.0125),
          Obx(() {
            final apiStatus =
                controller.dropdownCollectionsResponse.value.status;

            if (apiStatus == Status.LOADING) {
              return const SizedBox(
                height: 38,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            } else if (apiStatus == Status.ERROR) {
              return SizedBox(
                height: 38,
                child: Center(
                  child: Text(
                    "Failed to load collections",
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                  ),
                ),
              );
            }

            final textController = controller.getCollectionController(
              collectionId,
            );
            final focusNode = controller.getCollectionFocusNode(collectionId);

            if (controller.selectedDropdownCollections.containsKey(
              collectionId,
            )) {}

            return SizedBox(
              width: double.infinity,
              child: GenericAutocompleteDropdown<GetAllCollectionValue>(
                controller: textController,
                focusNode: focusNode,
                items: controller.dropdownCollections,
                getDisplayValue:
                    (collection) =>
                        collection.collectionName ?? 'Unknown Collection',
                onSelected: (value) {
                  controller.setSelectedCollection(collectionId, value);
                },
                customOptionsBuilder: (textEditingValue) async {
                  // Filter collections based on text input
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) {
                    return controller.dropdownCollections;
                  }

                  return controller.dropdownCollections.where((collection) {
                    return collection.collectionName?.toLowerCase().contains(
                          query,
                        ) ??
                        false;
                  }).toList();
                },
                borderColor: secondaryColor,
                isLastRow: true,
              ),
            );
          }),
        ],
      ),
    );
  }
}
