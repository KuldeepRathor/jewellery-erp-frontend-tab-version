import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/get_tagging_and_catalogue_items_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/view_model/add_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/view_model/tagging_items_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';

class TaggingItemsListingPage extends StatelessWidget {
  const TaggingItemsListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaggingItemsController controller = Get.put(TaggingItemsController());
    final AddCollectionController addCollectionController =
        Get.find<AddCollectionController>();
    final SidebarController sidebarController = Get.find<SidebarController>();

    return Scaffold(
      backgroundColor: secondaryColor.withOpacity(0.15),
      body: Column(
        children: [
          // Header
          HeaderWidget(
            header: "Choose Items",
            wantBackButton: true,
            onBackButtonTap: () {
              sidebarController.popBackSelectedWidget();
            },
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left panel - Item selection
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Search field
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: secondaryColor,
                                        ),
                                      ),
                                      child: TextField(
                                        controller: controller.searchController,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          hintText: 'Search',
                                          hintStyle: TextStyle(color: grey2),
                                          border: InputBorder.none,
                                          suffixIcon: Icon(
                                            Icons.search,
                                            color: grey2,
                                          ),
                                        ),
                                        onChanged: controller.onSearchChanged,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  CustomButton2(
                                    onTap: controller.applyFilter,
                                    image: 'assets/svgs/filter.svg',
                                    buttonName: 'Filter',
                                  ),
                                  const SizedBox(width: 16),
                                  Obx(
                                    () => TextButton(
                                      onPressed:
                                          controller.toggleSelectAllItems,
                                      child: Text(
                                        controller.isAllItemsSelected
                                            ? 'Deselect All'
                                            : 'Select All',
                                        style: const TextStyle(
                                          color: secondaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),

                            // Items list
                            Expanded(
                              child: Obx(() {
                                if (addCollectionController
                                        .catalogItemsResponse
                                        .value
                                        .status ==
                                    Status.LOADING) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (addCollectionController
                                    .catalogItems
                                    .isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'No items found for the selected categories and designs',
                                    ),
                                  );
                                }

                                final itemsToShow =
                                    controller.searchQuery.value.isEmpty
                                        ? addCollectionController.catalogItems
                                        : controller.filteredCatalogItems;

                                return ListView.separated(
                                  controller: controller.scrollController,
                                  itemCount: itemsToShow.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          CustomDashedLineWidget(
                                            width: Get.width,
                                          ),
                                  itemBuilder: (context, index) {
                                    final item = itemsToShow[index];
                                    return _buildItemCard(
                                      item,
                                      addCollectionController,
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right panel - Selected items
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.white,
                              padding: const EdgeInsets.all(16),
                              child: const Text(
                                'Selected Items',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () =>
                                    addCollectionController
                                            .selectedCatalogItems
                                            .isEmpty
                                        ? const Center(
                                          child: Text('No items selected'),
                                        )
                                        : _buildSelectedItemsList(
                                          controller.categories,
                                          controller.categorizedItems,
                                          addCollectionController,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom action bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Selected items count
                Obx(
                  () => Text(
                    "${addCollectionController.selectedCatalogItems.length} items selected",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // API status indicator
                Obx(() {
                  if (addCollectionController
                          .createCollectionResponse
                          .value
                          .status ==
                      Status.LOADING) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Create collection button
                CustomInkButton(
                  width: Get.width * 0.15,
                  onPressed: controller.handleSaveCollection,
                  text: "Create Collection",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedItemsList(
    RxList<String> categories,
    RxMap<String, List<GetTaggingAndCatalogItem>> categorizedItems,
    AddCollectionController addCollectionController,
  ) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final items = categorizedItems[category] ?? [];

        // Skip empty categories
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Container(
              width: double.infinity,
              color: grey1,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: primaryColor,
                ),
              ),
            ),

            // Category items
            ...items.map(
              (item) => _buildSelectedItemCard(
                item,
                category,
                addCollectionController,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedItemCard(
    GetTaggingAndCatalogItem item,
    String category,
    AddCollectionController addCollectionController,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child:
                  item.images?.isNotEmpty == true &&
                          item.images?.first.presignedUrl != null
                      ? Image.network(
                        item.images!.first.presignedUrl!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 16),
                          );
                        },
                      )
                      : Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 16),
                      ),
            ),
            const SizedBox(width: 12),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  // Weight and stone details
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gross weight:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              item.grossWeight ?? '4 gram',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Net weight:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              item.netWeight ?? '4.3 gram',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Stone:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              item.stoneAvailable == true ? 'Yes' : 'No',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete button
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: primaryColor,
                size: 20,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              constraints: const BoxConstraints(),
              onPressed: () {
                addCollectionController.toggleCatalogItemSelection(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(
    GetTaggingAndCatalogItem item,
    AddCollectionController addCollectionController,
  ) {
    return InkWell(
      onTap: () => addCollectionController.toggleCatalogItemSelection(item),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Obx(
              () => Checkbox(
                value: addCollectionController.isCatalogItemSelected(item),
                onChanged:
                    (value) => addCollectionController
                        .toggleCatalogItemSelection(item),
                activeColor: primaryColor,
              ),
            ),
            const SizedBox(width: 8),

            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child:
                  item.images?.isNotEmpty == true &&
                          item.images?.first.presignedUrl != null
                      ? Image.network(
                        item.images!.first.presignedUrl!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          );
                        },
                      )
                      : Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
            ),
            const SizedBox(width: 16),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name label
                  const Text(
                    "Name:",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Name value
                  Text(
                    item.name ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  item.weightRange != null
                      ? _buildWeightRangePuritySection(item)
                      : _buildGrossNetWeightSection(item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightRangePuritySection(GetTaggingAndCatalogItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weight range column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Weight range:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                item.weightRange ?? 'N/A',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),

        // Purity column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Purity:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              if (item.purity?.isNotEmpty == true)
                ...item.purity!.map(
                  (p) => Text(p, style: const TextStyle(fontSize: 16)),
                )
              else
                const Text('N/A', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),

        // Gemstone column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Gemstone:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              if (item.gemstones?.isNotEmpty == true)
                ...item.gemstones!.map(
                  (g) => Text(g, style: const TextStyle(fontSize: 16)),
                )
              else
                const Text('N/A', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),

        // Metal column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Metal:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              if (item.metalColours?.isNotEmpty == true)
                ...item.metalColours!.map(
                  (m) => Text(m, style: const TextStyle(fontSize: 16)),
                )
              else
                const Text('N/A', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Barcode",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              if (item.barcode?.isNotEmpty == true)
                Text(
                  item.barcode ?? 'N/A',
                  style: const TextStyle(fontSize: 16),
                )
              else
                const Text('N/A', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrossNetWeightSection(GetTaggingAndCatalogItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gross weight column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Gross weight:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                item.grossWeight ?? 'N/A',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),

        // Net weight column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Net weight:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                item.netWeight ?? 'N/A',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),

        // Stone column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Stone:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                item.stoneAvailable == true ? 'Yes' : 'No',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),

        // Empty column for alignment
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
