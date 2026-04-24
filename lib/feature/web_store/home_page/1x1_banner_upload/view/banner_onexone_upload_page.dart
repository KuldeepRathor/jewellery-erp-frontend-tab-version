import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/banner_slide_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/view_model/banner_onexone_upload_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view/category_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view/collection_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view/page_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_categories_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_page_link_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';

class BannerOneXOneUploadPage extends StatefulWidget {
  const BannerOneXOneUploadPage({super.key});

  @override
  State<BannerOneXOneUploadPage> createState() =>
      _BannerOneXOneUploadPageState();
}

class _BannerOneXOneUploadPageState extends State<BannerOneXOneUploadPage> {
  late final BannerOneXOneUploadController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BannerOneXOneUploadController());
  }

  @override
  void dispose() {
    Get.delete<BannerOneXOneUploadController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionController = Get.find<CollectionController>();
    final categoryController = Get.find<CategoryController>();
    final pageLinkController = Get.find<PageLinkController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final apiResponse = controller.bannersResponse.value;

                if (apiResponse.status == Status.LOADING ||
                    apiResponse.status == Status.INITIAL) {
                  // Show loading indicator while fetching data
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Loading 1x1 banner slides..."),
                      ],
                    ),
                  );
                } else if (apiResponse.status == Status.ERROR) {
                  // Show error state if data loading failed
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load 1x1 banners',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Error: ${apiResponse.message}'),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: controller.fetchBanners,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Show content when API has completed loading
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Static slide cards (3)
                        Obx(() {
                          return Column(
                            children: [
                              // Slide 1 - Home Page(At 50%)
                              _buildSlideCard(
                                context,
                                controller,
                                controller.slides[0],
                                collectionController,
                                categoryController,
                                pageLinkController,
                                0,
                              ),

                              // Slide 2 - Home Page(At 70%)
                              _buildSlideCard(
                                context,
                                controller,
                                controller.slides[1],
                                collectionController,
                                categoryController,
                                pageLinkController,
                                1,
                              ),

                              // Slide 3 - Listing Page(Top)
                              _buildSlideCard(
                                context,
                                controller,
                                controller.slides[2],
                                collectionController,
                                categoryController,
                                pageLinkController,
                                2,
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  );
                }
              }),
            ),
            _buildSaveButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideCard(
    BuildContext context,
    BannerOneXOneUploadController controller,
    BannerSlideItem slide,
    CollectionController collectionController,
    CategoryController categoryController,
    PageLinkController pageLinkController,
    int slideIndex,
  ) {
    // Get position components from controller
    final positionLabel = controller.getPositionLabel(slideIndex);
    final positionSubtext = controller.getPositionSubtext(slideIndex);
    final size = controller.getBannerSize(slideIndex);

    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Position, Size, and Action row
            const SizedBox(height: 16),

            // Image uploader
            _buildImageUploader(context, controller, slide, size),

            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Position column
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Position:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        positionLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        positionSubtext,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF636363),
                        ),
                      ),
                    ],
                  ),
                ),

                // Size column
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Size',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        size,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action column
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Action:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Obx(
                            () => Radio<ActionType>(
                              value: ActionType.page,
                              groupValue:
                                  controller.slides
                                      .firstWhere((item) => item.id == slide.id)
                                      .actionType,
                              onChanged:
                                  (value) => controller.updateActionType(
                                    slide.id,
                                    ActionType.page,
                                  ),
                            ),
                          ),
                          const Text('Page'),
                          const SizedBox(width: 16),
                          Obx(
                            () => Radio<ActionType>(
                              value: ActionType.category,
                              groupValue:
                                  controller.slides
                                      .firstWhere((item) => item.id == slide.id)
                                      .actionType,
                              onChanged:
                                  (value) => controller.updateActionType(
                                    slide.id,
                                    ActionType.category,
                                  ),
                            ),
                          ),
                          const Text('Category'),
                          const SizedBox(width: 16),
                          Obx(
                            () => Radio<ActionType>(
                              value: ActionType.collection,
                              groupValue:
                                  controller.slides
                                      .firstWhere((item) => item.id == slide.id)
                                      .actionType,
                              onChanged:
                                  (value) => controller.updateActionType(
                                    slide.id,
                                    ActionType.collection,
                                  ),
                            ),
                          ),
                          const Text('Collection'),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildTargetSelector(
                  controller,
                  slide,
                  collectionController,
                  categoryController,
                  pageLinkController,
                ),
                const Spacer(),
                _buildVisibilityToggle(controller, slide.id),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader(
    BuildContext context,
    BannerOneXOneUploadController controller,
    BannerSlideItem slide,
    String size,
  ) {
    return Obx(() {
      final selectedFile = controller.selectedFiles[slide.id];
      final hasSelectedFile = selectedFile != null;
      final hasImageUrl = slide.imageUrl.isNotEmpty;

      return GestureDetector(
        onTap: () => controller.uploadImage(slide.id),
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child:
              (!hasSelectedFile && !hasImageUrl)
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.file_upload_outlined,
                          color: primaryColor,
                          size: 40,
                        ),
                        onPressed: () => controller.uploadImage(slide.id),
                      ),
                      const Text(
                        'Upload Banner',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Size - $size',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        'Supported formats are JPEG, PNG & SVG',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(
                        'Recommended Size: Up to 5MB',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  )
                  : Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasSelectedFile)
                        Image.file(selectedFile, fit: BoxFit.cover)
                      else if (hasImageUrl &&
                          slide.imageUrl.startsWith('file://'))
                        Image.file(
                          File(slide.imageUrl.replaceFirst('file://', '')),
                          fit: BoxFit.cover,
                        )
                      else if (hasImageUrl)
                        Image.network(
                          slide.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
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
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Error loading image: ${error.toString()}',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () => controller.clearImage(slide.id),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                      if (hasSelectedFile)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Selected (Unsaved)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
        ),
      );
    });
  }

  Widget _buildTargetSelector(
    BannerOneXOneUploadController controller,
    BannerSlideItem slide,
    CollectionController collectionController,
    CategoryController categoryController,
    PageLinkController pageLinkController,
  ) {
    String dropdownLabel = '';
    Widget dropdownWidget;

    switch (slide.actionType) {
      case ActionType.page:
        dropdownLabel = 'Choose Page:';
        dropdownWidget = PageDropdownWidget(
          pageLinkController: pageLinkController,
          slideId: slide.id,
        );
        break;
      case ActionType.category:
        dropdownLabel = 'Choose Category:';
        dropdownWidget = CategoryDropdownWidget(
          categoryController: categoryController,
          slideId: slide.id,
        );
        break;
      case ActionType.collection:
        dropdownLabel = 'Choose Collection:';
        dropdownWidget = CollectionDropdownWidget(
          collectionController: collectionController,
          slideId: slide.id,
        );
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Target dropdown
        SizedBox(
          width: Get.width * 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dropdownLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              dropdownWidget,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityToggle(
    BannerOneXOneUploadController controller,
    String slideId,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 40,
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => controller.toggleVisibility(slideId),
                        child: Container(
                          color:
                              controller.isVisibilityActive(slideId)
                                  ? primaryColor // Blue if active
                                  : Colors.grey, // Grey if inactive
                          child: const Center(
                            child: Icon(
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
                      onTap: () => controller.clearImage(slideId),
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Clear",
                            style: TextStyle(
                              color:
                                  controller.isVisibilityActive(slideId)
                                      ? Colors
                                          .red // Red if active
                                      : Colors.grey, // Grey if inactive
                              fontSize: 16,
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
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BannerOneXOneUploadController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Spacer(),
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                color: Colors.white,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ||
                                controller.isUploading.value
                            ? null
                            : controller.saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child:
                        controller.isLoading.value ||
                                controller.isUploading.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Save'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Ctrl',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'S',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
