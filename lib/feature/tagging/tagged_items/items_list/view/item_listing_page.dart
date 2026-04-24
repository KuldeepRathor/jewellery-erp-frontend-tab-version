import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/view/edit_tagged_items.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_limited_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view/widgets/drop_down_with_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view/widgets/item_list_media_upload_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view/widgets/item_list_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view/widgets/item_list_animated_item_report_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/collection_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/enhance_media_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/item_list_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/metal_color_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';
import 'package:svg_flutter/svg.dart';

class ItemListingPage extends StatefulWidget {
  const ItemListingPage({super.key, this.id});
  final String? id;

  @override
  State<ItemListingPage> createState() => _ItemListingPageState();
}

class _ItemListingPageState extends State<ItemListingPage> {
  final ItemListViewModel taggedItemsReportViewModel = Get.put(
    ItemListViewModel(),
  );
  EnhancedTaggedItemMediaUploadController
  enhancedTaggedItemMediaUploadController = Get.put(
    EnhancedTaggedItemMediaUploadController(),
  );
  final MetalColorViewModel metalColorViewModel = Get.put(
    MetalColorViewModel(),
  );
  final CollectionViewModel collectionViewModel = Get.put(
    CollectionViewModel(),
  );

  final FocusNode _tableFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    taggedItemsReportViewModel.setInitialConditions(isSearch: false);

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tableFocusNode.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      taggedItemsReportViewModel.loadMoreItems();
    }
  }

  void _scrollToSelectedItem() {
    final selectedIndex = taggedItemsReportViewModel.selectedItemIndex.value;
    if (selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 48.0; // Approximate height of ListTile
      final scrollPosition = selectedIndex * itemHeight;

      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final currentIndex = taggedItemsReportViewModel.selectedItemIndex.value;
      final itemCount =
          taggedItemsReportViewModel
              .getTaggedItemListingResponse
              .value
              .data
              ?.values
              ?.length ??
          0;
      if (currentIndex == itemCount - 3) {
        taggedItemsReportViewModel.loadMoreItems();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp && currentIndex > 0) {
        taggedItemsReportViewModel.showItemDetails(index: currentIndex - 1);
        _scrollToSelectedItem();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
          currentIndex < itemCount - 1) {
        taggedItemsReportViewModel.showItemDetails(index: currentIndex + 1);
        _scrollToSelectedItem();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        autofocus: true,
        child: Focus(
          focusNode: _tableFocusNode,
          // autofocus: true,
          onKeyEvent: _handleKeyEvent,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(header: "Item List"),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildActionBar(context),
                          const SizedBox(height: 16),
                          _buildCustomTable(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Obx(
                  () => ItemListAnimatedItemDetailsWidget(
                    isVisible:
                        taggedItemsReportViewModel
                            .isItemDetailsVisible
                            .value, // Always visible
                    onClose: () => taggedItemsReportViewModel.hideItemDetails(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTableHeader(),
              Expanded(child: _buildTableContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children:
            taggedItemsReportViewModel.headers
                .asMap()
                .entries
                .map(
                  (entry) => Expanded(
                    flex:
                        (taggedItemsReportViewModel.columnWidths[entry.key] *
                                100)
                            .toInt(),
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildTableContent() {
    return Obx(() {
      final apiStatus =
          taggedItemsReportViewModel.getTaggedItemListingResponse.value.status;
      final selectedIndex = taggedItemsReportViewModel.selectedItemIndex.value;

      if (apiStatus == Status.COMPLETED) {
        final dataList =
            taggedItemsReportViewModel
                .getTaggedItemListingResponse
                .value
                .data
                ?.values ??
            [];

        if (dataList.isEmpty) {
          return Center(
            child: SvgPicture.asset('assets/svgs/error/no_records_found.svg'),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            return Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap:
                      () => taggedItemsReportViewModel.showItemDetails(
                        index: index,
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xffE6E8FF) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildTableRow(index, dataList[index]),
                  ),
                ),
                if (taggedItemsReportViewModel.hasMorePages.value &&
                    index == dataList.length - 1)
                  const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                if (index == dataList.length - 1)
                  SizedBox(height: MediaQuery.of(context).size.height * 0.33),
              ],
            );
          },
        );
      } else if (apiStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Center(
          child: Text(
            taggedItemsReportViewModel
                    .getTaggedItemListingResponse
                    .value
                    .message ??
                'Error loading data',
          ),
        );
      }
    });
  }

  Widget _buildTableRow(int index, GetTaggedItemsReportLimitedValue item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: CustomText(
              text: (index + 1).toString(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 20,
            child: CustomText(
              text: item.code ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 20,
            child: CustomText(
              text: item.tagNumber?.toString() ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 20,
            child: CustomText(
              text: item.tagBarcode ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 20,
            child: CustomText(
              text: item.purity ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 80,
            child: CustomText(
              text:
                  item.itemDescription ?? '-', // Changed from item.design?.name
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 25,
            child: CustomText(
              text: item.pieces?.toString() ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 35,
            child: CustomText(
              text: item.netWeight ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 35,
            child: CustomText(
              text: item.grossWeight ?? '-',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // Expanded(
          //   flex: 35,
          //   child: CustomText(
          //     text: item.counterName ??
          //         '-', // Changed from item.counter?.counterName
          //     fontSize: 16,
          //     fontWeight: FontWeight.w500,
          //     color: Colors.black,
          //   ),
          // ),
          Expanded(
            flex: 35,
            child: CustomText(
              text:
                  item.totalLineStone ??
                  '-', // Changed from _calculateLineStonesTotal
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Obx(() {
            final metalColors =
                metalColorViewModel.metalColorOptions
                    .map((e) => e.colourName ?? '')
                    .where((name) => name.isNotEmpty)
                    .toList();
            return Expanded(
              flex: 35,
              child: DropDownWithTextField(
                items: metalColors,
                showSearch: true,
                initialValue: metalColorViewModel.getItemMetalColor(
                  item.id ?? '',
                ),
                onChanged: (value) {
                  if (value != null) {
                    metalColorViewModel.setItemMetalColor(item.id ?? '', value);

                    final selected = metalColorViewModel.metalColorOptions
                        .firstWhereOrNull((e) => e.colourName == value);

                    if (selected?.id != null) {
                      metalColorViewModel.updateMetalColorApi(
                        itemId: item.id ?? '',
                        colorId: selected!.id!,
                      );
                    }
                  }
                },
              ),
            );
          }),
          Expanded(
            flex: 35,
            child: DropDownWithTextField(
              items: GenderEnum.values.map((e) => e.label).toList(),
              initialValue:
                  GenderEnum.fromValue(
                    taggedItemsReportViewModel.getItemGender(item.id ?? ''),
                  )?.label,
              onChanged: (label) {
                if (label != null) {
                  final selected = GenderEnum.values.firstWhere(
                    (e) => e.label == label,
                  );
                  taggedItemsReportViewModel.setItemGender(
                    item.id ?? '',
                    selected.value,
                  );
                  taggedItemsReportViewModel.updateGenderApi(
                    itemId: item.id ?? '',
                    gender: selected.value,
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 35,
            child: DropDownWithTextField(
              items:
                  collectionViewModel.collectionOptions
                      .map((collection) => collection.collectionName ?? '')
                      .toList(),
              showSearch: true,
              initialValue: collectionViewModel.getItemCollection(
                item.id ?? '',
              ),
              onChanged: (value) {
                if (value != null) {
                  collectionViewModel.setItemCollection(item.id ?? '', value);

                  final selected = collectionViewModel.collectionOptions
                      .firstWhereOrNull((c) => c.collectionName == value);

                  if (selected?.id != null) {
                    collectionViewModel.updateCollectionApi(
                      itemId: item.id ?? '',
                      collectionId: selected!.id!,
                    );
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(child: _buildImageActionButton(item, index)),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Obx(() {
                final isLoading =
                    taggedItemsReportViewModel
                        .isUpdatingWebstoreStatus[item.id ?? ''] ??
                    false;

                return isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : CustomToggleSwitch(
                      value: taggedItemsReportViewModel
                          .getWebstoreListingStatus(item.id ?? ''),
                      onChanged: (value) {
                        taggedItemsReportViewModel.toggleWebstoreListing(
                          item.id ?? '',
                          value,
                        );
                      },
                      canRequestFocus: false,
                    );
              }),
            ),
          ),
          Expanded(
            flex: 10,
            child: Column(
              children: [
                Theme(
                  data: ThemeData(
                    focusColor: greyTextColor,
                    tooltipTheme: const TooltipThemeData(
                      decoration: BoxDecoration(color: Colors.transparent),
                    ),
                  ),
                  child: CustomPopupMenuButtonWidget<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder:
                        (BuildContext context) => <PopupMenuEntry<String>>[
                          ...taggedItemsReportViewModel.popUpValues.map((
                            element,
                          ) {
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
                          }),
                        ],
                    onSelected: (String value) async {
                      switch (value) {
                        case 'View Item':
                          taggedItemsReportViewModel.showItemDetails(
                            index: index,
                          );
                          break;

                        case 'Edit':
                          final result = await Get.to(
                            () => EditTaggedItems(id: item.id),
                          );
                          if (result == true) {
                            taggedItemsReportViewModel
                                .getTaggedItemsReportDetails(resetList: true);
                          }
                          break;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageActionButton(
    GetTaggedItemsReportLimitedValue item,
    int index,
  ) {
    final hasImages = (item.imagesCount ?? 0) > 0;

    return Tooltip(
      message:
          hasImages
              ? 'View ${item.imagesCount} image${item.imagesCount! > 1 ? 's' : ''}'
              : 'Upload images',
      child: InkWell(
        onTap: () {
          // For image viewing/uploading, we'll need the full item data
          // This will be loaded when showing the dialog
          if (hasImages) {
            _showViewImagesDialog(item, index);
          } else {
            _showUploadImagesDialog(item, index);
          }
        },
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child:
              hasImages
                  ? const CustomText(
                    text: "View",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor,
                  )
                  : const Icon(
                    Icons.file_upload_outlined,
                    color: secondaryColor,
                    size: 20,
                  ),
        ),
      ),
    );
  }

  void _showUploadImagesDialog(
    GetTaggedItemsReportLimitedValue item,
    int index,
  ) {
    // We need to fetch full details before showing the dialog
    if (item.id != null) {
      taggedItemsReportViewModel.fetchTaggedItemDetails(item.id!).then((_) {
        final fullDetails =
            taggedItemsReportViewModel.taggedItemDetailsResponse.value.data;
        if (fullDetails != null) {
          Get.dialog(
            ItemListMediaUploadDialog(
              item: _convertToFullResponse(
                fullDetails,
              ), // Convert to expected type
              itemIndex: index,
              isViewMode: false,
            ),
          ).then((result) {
            if (result != null && result is List<ImageData>) {
              log('Images to upload: ${result.length}');
            }
          });
        }
      });
    }
  }

  void _showViewImagesDialog(GetTaggedItemsReportLimitedValue item, int index) {
    if (item.id != null) {
      taggedItemsReportViewModel.fetchTaggedItemDetails(item.id!).then((_) {
        final fullDetails =
            taggedItemsReportViewModel.taggedItemDetailsResponse.value.data;
        if (fullDetails != null) {
          Get.dialog(
            ItemListMediaUploadDialog(
              item: _convertToFullResponse(fullDetails),
              itemIndex: index,
              isViewMode: true,
            ),
          );
        }
      });
    }
  }

  TaggedItemReportValueResponse _convertToFullResponse(
    GetTaggingLineItemResponse details,
  ) {
    return TaggedItemReportValueResponse(
      id: details.id,
      code: details.code,
      tagBarcode: details.tagBarcode,
      tagNumber: details.tagNumber,
      purity: details.purity,
      pieces: details.pieces,
      grossWeight: details.grossWeight,
      netWeight: details.netWeight,
      images:
          details.images
              ?.map(
                (img) => TaggedItemReportImageResponse(
                  id: img.id,
                  fileName: img.fileName,
                  fileType: img.fileType,
                  s3Key: img.s3Key,
                  presignedUrl: img.presignedUrl,
                ),
              )
              .toList(),
      // Map other needed fields
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 2, child: _buildSearchField()),
        const ItemListFilterWidget(),
        const Spacer(),
        CustomButton2(
          // backgroundColor: grey1,
          // textColor: primaryBtnColor,
          onTap: () async {
            await PermissionGuardUtil.withActionPermissionAsync(5054, () async {
              await taggedItemsReportViewModel.downloadReport();
            });
          },
          image: 'assets/svgs/download.svg',
          buttonName: 'Download',
        ),
      ],
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
        onChanged: taggedItemsReportViewModel.setSearchQuery,
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
}
