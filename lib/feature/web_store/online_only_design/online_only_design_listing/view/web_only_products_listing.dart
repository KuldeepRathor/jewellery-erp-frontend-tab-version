import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view/add_online_only_design.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/online_only_design_listing/model/webstore_stock_reponse.dart'
    hide Image;
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/online_only_design_listing/view_model/web_only_products_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class WebOnlyProductsListingPage extends StatefulWidget {
  const WebOnlyProductsListingPage({super.key});

  @override
  State<WebOnlyProductsListingPage> createState() =>
      _WebOnlyProductsListingPageState();
}

class _WebOnlyProductsListingPageState
    extends State<WebOnlyProductsListingPage> {
  final controller = Get.put<WebOnlyProductsListingController>(
    WebOnlyProductsListingController(),
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
            'Web only Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
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
        // When navigating to AddOnlineOnlyDesign
        CustomButton2(
          onTap: () async {
            // final result = await Get.to(() => const AddOnlineOnlyDesign());
            // Refresh when returning
            // if (result == true) {
            //   controller.getProductListingDetails(resetList: true);
            // }
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
              _buildFilterChip('Category'),
              _buildFilterChip('Metal Type'),
              _buildFilterChip('Weight'),
              _buildFilterChip('Purity'),
              _buildFilterChip('Size'),
              _buildFilterChip('Stock Status'),
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
          _buildHeaderCell('Product Title', flex: 3),
          _buildHeaderCell('Stock Head'),
          _buildHeaderCell('Category'),
          // _buildHeaderCell('Purity'),
          _buildHeaderCell('Total Pcs'),

          _buildHeaderCell('Available'),

          _buildHeaderCell('Weight/pc'),
          _buildHeaderCell('Size'),

          _buildHeaderCell('Amount/pc'),
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

  Widget _buildProductRow(WebstoreStockValue product) {
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
                    value: controller.selectedProductIds.contains(product.id),
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
                      product.images?.isNotEmpty == true
                          ? InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return GlobalImageView(
                                    imagePath:
                                        product.images!.first.presignedUrl ??
                                        '',
                                  );
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                product.images!.first.presignedUrl ?? '',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                          : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (product.description != null)
                              Text(
                                product.description!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Text(product.stockHead?.name ?? 'N/A')),
                // Category column
                Expanded(
                  child: Text(
                    product.stockHead?.category?.categoryName ?? 'N/A',
                  ),
                ),

                // // Purity column
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       if (product.lineItems?.isNotEmpty == true)
                //         ...product.lineItems!.map((item) => Text(
                //               item.purity ?? 'N/A',
                //               style: const TextStyle(fontSize: 13),
                //             ))
                //       else
                //         const Text('N/A'),
                //     ],
                //   ),
                // ),
                // Total column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.lineItems?.isNotEmpty == true)
                        ...product.lineItems!.map(
                          (item) => Text(
                            item.totalPieces.toString(),
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       if (product.lineItems?.isNotEmpty == true)
                //         Text(
                //           '${product.lineItems!.fold(0, (sum, item) => sum + (item.currentPieces ?? 0))} pcs',
                //           style: TextStyle(
                //             color: (product.lineItems!.fold(
                //                         0,
                //                         (sum, item) =>
                //                             sum + (item.currentPieces ?? 0)) >
                //                     0)
                //                 ? Colors.green
                //                 : Colors.red,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         )
                //       else
                //         const Text('0 pcs'),
                //     ],
                //   ),
                // ),
                // Avaialble column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.lineItems?.isNotEmpty == true)
                        ...product.lineItems!.map(
                          (item) => Text(
                            item.currentPieces.toString(),
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),

                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       if (product.lineItems?.isNotEmpty == true)
                //         Text(
                //           '${product.lineItems!.fold(0, (sum, item) => sum + (item.currentPieces ?? 0))} pcs',
                //           style: TextStyle(
                //             color: (product.lineItems!.fold(
                //                         0,
                //                         (sum, item) =>
                //                             sum + (item.currentPieces ?? 0)) >
                //                     0)
                //                 ? Colors.green
                //                 : Colors.red,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         )
                //       else
                //         const Text('0 pcs'),
                //     ],
                //   ),
                // ),

                // Weight column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.lineItems?.isNotEmpty == true)
                        ...product.lineItems!.map(
                          (item) => Text(
                            item.weight != null ? item.weight.toString() : '-',
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       if (product.lineItems?.isNotEmpty == true)
                //         ...product.lineItems!.take(2).map((item) => Text(
                //               item.weight ?? 'N/A',
                //               style: const TextStyle(fontSize: 12),
                //             ))
                //       else
                //         const Text('N/A'),
                //     ],
                //   ),
                // ),
                // Size column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.lineItems?.isNotEmpty == true)
                        ...product.lineItems!.map(
                          (item) => Text(
                            item.size != null ? item.size.toString() : "-",
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       if (product.lineItems?.isNotEmpty == true)
                //         ...product.lineItems!.take(2).map((item) => Text(
                //               item.size ?? 'N/A',
                //               style: const TextStyle(fontSize: 12),
                //             ))
                //       else
                //         const Text('N/A'),
                //     ],
                //   ),
                // ),

                // Price column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.lineItems?.isNotEmpty == true)
                        ...product.lineItems!.map(
                          (item) => Text(
                            '₹${item.amount ?? 'N/A'}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                      else
                        const Text('N/A'),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       if (product.lineItems?.isNotEmpty == true)
                //         ...product.lineItems!.take(2).map((item) => Text(
                //               '₹${item.amount ?? 'N/A'}',
                //               style: const TextStyle(fontSize: 12),
                //             ))
                //       else
                //         const Text('N/A'),
                //     ],
                //   ),
                // ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       if (product.lineItems?.isNotEmpty == true &&
                //           product.lineItems!.first.amount != null)
                //         Text('₹${product.lineItems!.first.amount}')
                //       else
                //         const Text('N/A'),
                //     ],
                //   ),
                // ),
                // Actions column
                SizedBox(width: 48, child: _buildActionMenu(product)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionMenu(WebstoreStockValue product) {
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
              controller.onEdit(product);
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
            width: 120,
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
