import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/get_catalogue_metal_color_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/add_new_catalogue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/catalogue_image_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/gemstones_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/metal_color_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/metal_purity_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/catalogue_listing/model/get_catalog_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/catalogue_listing/view/product_image_advanced_zoom.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/catalogue_listing/view_model/order_to_make_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class OnlineDesignListingPage extends StatefulWidget {
  const OnlineDesignListingPage({super.key});

  @override
  State<OnlineDesignListingPage> createState() =>
      _OnlineDesignListingPageState();
}

class _OnlineDesignListingPageState extends State<OnlineDesignListingPage> {
  final controller = Get.put<OrderToMakeListingController>(
    OrderToMakeListingController(),
  );
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getProductListingDetails(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        children: [
          // Universal header
          _buildHeader(),

          // Main content area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Catalogue listing section
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildActionBar(),
                        SizedBox(height: Get.height * 0.025),
                        _buildProductTable(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Universal bottom bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: const Row(
        children: [
          Text(
            'Online Web Design Listing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        _buildSearchField(),
        const SizedBox(width: 8),
        _buildFilterButton(),
        const SizedBox(width: 8),
        const Spacer(),
        CustomButton2(
          onTap: () {
            // controller.toggleAddWidgetVisibility();
          },
          image: 'assets/svgs/upload.svg',
          buttonName: 'Upload',
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        onChanged: controller.setSeachQuery,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: primaryColor.withBlue(190)),
      child: PopupMenuButton(
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.white,
        elevation: 4,
        itemBuilder:
            (context) => [
              PopupMenuItem(
                enabled: false,
                height: 0,
                padding: EdgeInsets.zero,
                child: _buildFilterMenu(),
              ),
            ],
        child: CustomButton2(
          onTap: () {},
          image: 'assets/svgs/filter.svg',
          buttonName: 'Filter',
        ),
      ),
    );
  }

  Widget _buildFilterMenu() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: Get.height * 0.025),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('Design'),
              _buildFilterChip('Weight'),
              _buildFilterChip('Purity'),
              _buildFilterChip('Stone'),
              _buildFilterChip('Metal Color'),
              _buildFilterChip('Collection'),
              _buildFilterChip('Rate'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: false,
      onSelected: (bool selected) {},
    );
  }

  Widget _buildProductTable() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildTableHeader(), Expanded(child: _buildProductList())],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCheckbox(),
          _buildHeaderCell('Product', flex: 3),
          _buildHeaderCell('Design'),
          _buildHeaderCell('Weight'),
          _buildHeaderCell('Purity'),
          _buildHeaderCell('Stone'),
          _buildHeaderCell('Metal Color'),
          _buildHeaderCell('Collection'),
          _buildHeaderCell('Rate'),
          const SizedBox(width: 48), // Actions column
        ],
      ),
    );
  }

  Widget _buildHeaderCheckbox() {
    return SizedBox(
      width: 48,
      child: Obx(
        () => Checkbox(
          value: controller.allSelected.value,
          onChanged: (value) => controller.toggleSelectAll(),
          activeColor: primaryColor,
          // fillColor: const WidgetStatePropertyAll(secondaryColor),
          side: const BorderSide(
            color: Colors.white,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.products.isEmpty) {
        return const Center(child: Text('No products found'));
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount:
            controller.products.length +
            (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final product = controller.products[index];
          return _buildProductRow(product);
        },
      );
    });
  }

  Widget _buildProductRow(GetCatalogueListingValue product) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.onProductTap(product),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                SizedBox(
                  width: 48,
                  child: Checkbox(
                    value: product.isSelected ?? false,
                    onChanged:
                        (value) =>
                            controller.toggleProductSelection(product.id),
                    activeColor: secondaryColor,
                    side: const BorderSide(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
                ),
                // Product Image and Name
                Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      product.images?.isNotEmpty == true &&
                              product.images?.first.presignedUrl != null
                          ? ProductImageAdvancedZoom(
                            imageUrl: product.images!.first.presignedUrl!,
                            productName: product.designName,
                            width: 60,
                            height: 60,
                            zoomScale: 3.0,
                            onTap: () => controller.onProductTap(product),
                          )
                          : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          product.designName ?? 'N/A',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                // Design column
                Expanded(child: Text(product.design?.name ?? 'N/A')),
                // Weight column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.minWeight ?? 'N/A'),
                      if (product.maxWeight != null) Text(product.maxWeight!),
                    ],
                  ),
                ),
                // Purity column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.purity?.isNotEmpty == true)
                        ...product.purity!.map(
                          (p) => Text(p.purityType ?? 'N/A'),
                        )
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                // Stone column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.gemstones?.isNotEmpty == true)
                        ...product.gemstones!.map((g) => Text(g.name ?? 'N/A'))
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                // Metal Color column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.metalColours?.isNotEmpty == true)
                        ...product.metalColours!.map(
                          (m) => Text(m.colourName ?? 'N/A'),
                        )
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                // Collection column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.collectionNames?.isNotEmpty == true)
                        ...product.collectionNames!.map((m) => Text(m))
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.rate != null &&
                          product.rate!.isNotEmpty == true)
                        Text(product.rate ?? "")
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                // Actions column
                SizedBox(
                  width: 48,
                  child: _buildActionMenu(
                    product,
                  ), // This directly uses the returned widget
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionMenu(GetCatalogueListingValue product) {
    return Theme(
      data: ThemeData(
        focusColor: greyTextColor,
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: CustomPopupMenuButtonWidget<String>(
        icon: const Icon(Icons.more_vert),
        itemBuilder:
            (BuildContext context) =>
                controller.popUpValues.map((element) {
                  return PopupMenuItem<String>(
                    value: element,
                    height: 0,
                    child: SizedBox(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            element,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (element != "Delete")
                            CustomDashedLineWidget(width: Get.width),
                        ],
                      ),
                    ),
                  );
                }).toList(),
        onSelected: (String value) {
          switch (value) {
            case 'Edit':
              setState(() {
                controller.onEdit(product);
                final catalogueController = Get.put(
                  AddNewCatalogueController(),
                );
                catalogueController.designNameController.text =
                    product.designName ?? "";
                catalogueController.setSelectedDesign(
                  catalogueController.designOptions.firstWhere(
                    (v) => product.design!.id == v.id,
                  ),
                );

                catalogueController.maxWeightController.text =
                    product.maxWeight ?? "";
                catalogueController.minWeightController.text =
                    product.minWeight ?? "";
                final mtColorCtrl = Get.put(MetalColorController());
                final imageUploadController = Get.put(ImageUploadController());
                imageUploadController.populateWithFetchedData(
                  product.images?.map((v) => v.presignedUrl ?? "").toList() ??
                      [],
                );
                mtColorCtrl.selectedMetalColors.clear();
                product.metalColours?.forEach((v) {
                  mtColorCtrl.toggleSelection(
                    GetCatalogMetalColorResponse.fromJson(v.toJson()),
                  );
                });
                final gemstonesController = Get.put(GemstonesController());
                gemstonesController.selectedGemstones.clear();
                product.gemstones?.forEach((v) {
                  gemstonesController.toggleSelection(
                    GetStoneRatesValue.fromJson(v.toJson()),
                  );
                });

                catalogueController.rateController.text = product.rate ?? "";
                catalogueController.stoneWeightController.text =
                    product.stoneWeight ?? "";
                final metalPurityController =
                    Get.find<MetalPurityFilterController>();
                metalPurityController.selectedPurities.clear();
                product.purity?.forEach((v) {
                  metalPurityController.selectedPurities.add(
                    v.purityType ?? "",
                  );
                });
              });
              break;

            case 'Delete':
              controller.onDeleteProduct(product.id ?? "");
              break;
          }
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Select All button with outline border
          SizedBox(
            width: 120, // Fixed width to prevent infinite constraint
            child: OutlinedButton(
              onPressed: () => controller.toggleSelectAll(),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Text('Select All'),
            ),
          ),

          const SizedBox(width: 8),

          // Delete button - simple icon button with background
          Obx(() {
            bool hasSelection = controller.selectedProductIds.isNotEmpty;
            return Container(
              decoration: BoxDecoration(
                color: hasSelection ? primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.white,
                onPressed:
                    hasSelection
                        ? () => controller.deleteSelectedProducts()
                        : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}
