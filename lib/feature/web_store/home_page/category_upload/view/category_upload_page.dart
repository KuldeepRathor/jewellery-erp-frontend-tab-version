import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/booking_listing/view/booking_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/model/get_all_categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/view_model/category_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
import 'package:svg_flutter/svg.dart';

class CategoryUploadPage extends StatefulWidget {
  const CategoryUploadPage({super.key});

  @override
  State<CategoryUploadPage> createState() => _CategoryUploadPageState();
}

class _CategoryUploadPageState extends State<CategoryUploadPage> {
  late final CategoryUploadController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(CategoryUploadController());
  }

  @override
  void dispose() {
    Get.delete<CategoryUploadController>();
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
                      // Check both the webstoreCategoriesResponse (grid data) and dropdownCategoriesResponse
                      final gridApiResponse =
                          controller.webstoreCategoriesResponse.value;
                      final dropdownApiResponse =
                          controller.dropdownCategoriesResponse.value;

                      // If either request is loading, show loading indicator
                      if (gridApiResponse.status == Status.LOADING ||
                          dropdownApiResponse.status == Status.LOADING ||
                          // Important: Also consider the initial state as loading
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
                                      controller.fetchAllCategoriesForGrid,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Only show content when both APIs have completed loading
                        return _buildCategoryGrid();
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

  Widget _buildCategoryGrid() {
    return Obx(() {
      final filteredCategories = controller.filteredCategories;

      // Even if no categories are found, we'll show at least the "Add Category" card
      if (filteredCategories.isEmpty &&
          controller.searchQuery.value.isNotEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No categories found',
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
          // Add +1 to include the "Add Category" card
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            // If it's the last item, show the "Add Category" card
            // if (index == filteredCategories.length) {
            //   return _buildAddCategoryCard(context);
            // }
            // Otherwise, show a regular category card
            return _buildCategoryCard(context, filteredCategories[index]);
          },
        ),
      );
    });
  }

  Widget _buildCategoryCard(
    BuildContext context,
    GetAllCategoriesValue category,
  ) {
    final categoryId = category.id ?? '';

    return Obx(() {
      final hasApiImages =
          category.images != null && category.images!.isNotEmpty;
      final hasLocalImages =
          controller.localCategoryImages.containsKey(categoryId) &&
          controller.localCategoryImages[categoryId]!.isNotEmpty;
      final isApiImageCleared = controller.isApiImageCleared(categoryId);

      // Determine if there are any valid images to display
      // If API images are cleared, don't count them
      final hasValidImages =
          hasLocalImages || (hasApiImages && !isApiImageCleared);

      final isWebstore = controller.getCategoryWebstoreStatus(categoryId);

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
                          : () => controller.pickAndCropImage(categoryId),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: grey1,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child:
                        hasValidImages
                            ? _buildImagePreview(categoryId, category)
                            : _buildEmptyImageState(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomText(
                text: category.categoryName ?? "Unknown Category",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Pass the categoryId to CategoryDropdownWidget
            // CategoryDropdownWidget(categoryId: categoryId),
            const SizedBox(height: 12),
            Center(
              child: _buildClearButton(categoryId, isWebstore, hasValidImages),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildImagePreview(String categoryId, GetAllCategoriesValue category) {
    final hasLocalImages =
        controller.localCategoryImages.containsKey(categoryId) &&
        controller.localCategoryImages[categoryId]!.isNotEmpty;

    final isApiImageCleared = controller.isApiImageCleared(categoryId);

    // If API images are cleared and there are no local images, show empty state
    if (isApiImageCleared && !hasLocalImages) {
      return _buildEmptyImageState();
    }

    // If there is a local image, show it first
    if (hasLocalImages) {
      final imagePath = controller.localCategoryImages[categoryId]![0].path;
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
                onTap: () => controller.pickAndCropImage(categoryId),
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
        category.images != null &&
        category.images!.isNotEmpty) {
      // Try to get the first image with a valid presigned URL
      final apiImage = category.images!.firstWhere(
        (image) =>
            image.presignedUrl != null &&
            image.presignedUrl.toString().isNotEmpty,
        orElse: () => GetAllCategoriesImage(),
      );

      if (apiImage.presignedUrl != null &&
          apiImage.presignedUrl.toString().isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  apiImage.presignedUrl.toString(),
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
                  onTap: () => controller.pickAndCropImage(categoryId),
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

  Widget _buildClearButton(String categoryId, bool isWebstore, bool hasImages) {
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
                onTap: () => controller.toggleWebstoreStatus(categoryId),
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
                        ? () => controller.clearCategoryImage(categoryId)
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
}

class CategoryDropdownWidget extends StatelessWidget {
  final String categoryId;

  const CategoryDropdownWidget({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryUploadController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Choose Category",
            color: primaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: Get.height * 0.0125),
          Obx(() {
            final apiStatus =
                controller.dropdownCategoriesResponse.value.status;

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
                    "Failed to load categories",
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                  ),
                ),
              );
            }

            final textController = controller.getCategoryController(categoryId);
            final focusNode = controller.getCategoryFocusNode(categoryId);

            if (controller.selectedDropdownCategories.containsKey(
              categoryId,
            )) {}

            return SizedBox(
              width: double.infinity,
              child: GenericAutocompleteDropdown<GetAllCategoriesValue>(
                controller: textController,
                focusNode: focusNode,
                items: controller.dropdownCategories,
                getDisplayValue:
                    (category) => category.categoryName ?? 'Unknown Category',
                onSelected: (value) {
                  controller.setSelectedCategory(categoryId, value);
                },
                customOptionsBuilder: (textEditingValue) async {
                  // Filter categories based on text input
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) {
                    return controller.dropdownCategories;
                  }

                  return controller.dropdownCategories.where((category) {
                    return category.categoryName?.toLowerCase().contains(
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
