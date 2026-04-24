import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/hero_slide_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view/category_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view/collection_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view/page_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_categories_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_page_link_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/hero_slides_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';

class HeroSlidesPage extends StatefulWidget {
  const HeroSlidesPage({super.key});

  @override
  State<HeroSlidesPage> createState() => _HeroSlidesPageState();
}

class _HeroSlidesPageState extends State<HeroSlidesPage> {
  late final HeroSlidesController heroController;

  @override
  void initState() {
    super.initState();
    heroController = Get.put(HeroSlidesController());
  }

  @override
  void dispose() {
    Get.delete<HeroSlidesController>();
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
                final apiResponse = heroController.bannersResponse.value;

                if (apiResponse.status == Status.LOADING ||
                    apiResponse.status == Status.INITIAL) {
                  // Show loading indicator while fetching data
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Loading banner slides..."),
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
                          'Failed to load banners',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Error: ${apiResponse.message}'),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: heroController.fetchBanners,
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
                        // Slide cards
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: heroController.slides.length,
                          itemBuilder: (context, index) {
                            final slide = heroController.slides[index];
                            return _buildSlideCard(
                              context,
                              heroController,
                              slide,
                              collectionController,
                              categoryController,
                              pageLinkController,
                            );
                          },
                        ),
                        _buildAddNewSlideButton(heroController),
                      ],
                    ),
                  );
                }
              }),
            ),
            _buildSaveButton(heroController),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideCard(
    BuildContext context,
    HeroSlidesController controller,
    HeroSlideItem slide,
    CollectionController collectionController,
    CategoryController categoryController,
    PageLinkController pageLinkController,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  slide.position,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => controller.removeSlide(slide.id),
                  tooltip: 'Remove slide',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildImageUploader(context, controller, slide),
            const SizedBox(height: 16),
            _buildActionSelector(
              controller,
              slide,
              collectionController,
              categoryController,
              pageLinkController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader(
    BuildContext context,
    HeroSlidesController controller,
    HeroSlideItem slide,
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
                        icon: const Icon(Icons.file_upload_outlined),
                        onPressed: () => controller.uploadImage(slide.id),
                      ),
                      const Text(
                        'Upload Banner',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
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

  Widget _buildAddNewSlideButton(HeroSlidesController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: controller.addNewSlide,
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Add New Slide',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionSelector(
    HeroSlidesController controller,
    HeroSlideItem slide,
    CollectionController collectionController,
    CategoryController categoryController,
    PageLinkController pageLinkController,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First column: Position
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Position:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(slide.position, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),

        const SizedBox(width: 48),

        // Second column: Action
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Action:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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

        const SizedBox(width: 48),

        // Third column: Choose(Dynamic)
        _dynamicDropdown(
          controller,
          slide,
          collectionController,
          categoryController,
          pageLinkController,
        ),
        const Spacer(),

        // Visibility/Clear Button
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            _buildClearButton(controller, slide.id),
          ],
        ),
      ],
    );
  }

  Widget _dynamicDropdown(
    HeroSlidesController controller,
    HeroSlideItem slide,
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

    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dropdownLabel,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          dropdownWidget,
        ],
      ),
    );
  }

  Widget _buildClearButton(HeroSlidesController controller, String slideId) {
    return GestureDetector(
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
    );
  }

  Widget _buildSaveButton(HeroSlidesController controller) {
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
