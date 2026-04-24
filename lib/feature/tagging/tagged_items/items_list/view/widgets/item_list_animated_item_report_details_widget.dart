import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view/widgets/item_list_media_upload_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/enhance_media_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/item_list_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

class ItemListAnimatedItemDetailsWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const ItemListAnimatedItemDetailsWidget({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  ItemListAnimatedItemDetailsWidgetState createState() =>
      ItemListAnimatedItemDetailsWidgetState();
}

class ItemListAnimatedItemDetailsWidgetState
    extends State<ItemListAnimatedItemDetailsWidget> {
  final EnhancedTaggedItemMediaUploadController
  taggedItemDetailsImageUploadController =
      Get.find<EnhancedTaggedItemMediaUploadController>();
  final ItemListViewModel taggedItemDetailsController =
      Get.find<ItemListViewModel>();
  final VendorRepository vendorRepository = VendorRepository();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      height: widget.isVisible ? MediaQuery.of(context).size.height * 0.33 : 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildItemDetails(),
                            const SizedBox(height: 20),
                            // Fixed: Remove Flexible, use SizedBox instead
                            SizedBox(
                              height: 200,
                              child: Obx(() {
                                return InkWell(
                                  onTap: () {
                                    // Get the current item details from the controller
                                    final itemDetails =
                                        taggedItemDetailsController
                                            .taggedItemDetailsResponse
                                            .value
                                            .data;

                                    if (itemDetails != null) {
                                      // Convert to TaggedItemReportValueResponse
                                      final item =
                                          _convertToTaggedItemReportValueResponse(
                                            itemDetails,
                                          );

                                      showDialog(
                                        context: context,
                                        builder:
                                            (
                                              context,
                                            ) => ItemListMediaUploadDialog(
                                              item: item,
                                              itemIndex:
                                                  taggedItemDetailsController
                                                      .selectedItemIndex
                                                      .value,
                                              isViewMode:
                                                  true, // Set to true if you want to view/edit, false for upload only
                                            ),
                                      ).then((result) {
                                        // Refresh the item details after dialog closes if media was updated
                                        if (result == true) {
                                          taggedItemDetailsController
                                              .getTaggedItemsReportDetails(
                                                resetList: true,
                                              );
                                        }
                                      });
                                    }
                                  },
                                  child: _buildImageGalleryForTaggedItems(
                                    taggedItemDetailsImageUploadController,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const VerticalDivider(color: secondaryColor, thickness: 3),
                    const SizedBox(width: 24),
                    Expanded(flex: 3, child: _buildStoneDetails()),
                  ],
                ),
              ),
            ),
            Obx(() {
              final detailsData =
                  taggedItemDetailsController
                      .taggedItemDetailsResponse
                      .value
                      .data;

              String taggedByName = '-';
              if (detailsData?.employeeDetails != null) {
                final firstName = detailsData!.employeeDetails!.firstName ?? '';
                final lastName = detailsData.employeeDetails!.lastName ?? '';
                taggedByName = '$firstName $lastName'.trim();
                if (taggedByName.isEmpty) {
                  taggedByName = '-';
                }
              }

              return SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    const CustomText(
                      text: 'Tagged By : ',
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      text: taggedByName,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Add this method to ItemListAnimatedItemDetailsWidgetState class
  TaggedItemReportValueResponse _convertToTaggedItemReportValueResponse(
    GetTaggingLineItemResponse details,
  ) {
    return TaggedItemReportValueResponse(
      id: details.id,
      design:
          details.design != null
              ? TaggedItemReportDesignResponse(
                id: details.design!.id,
                name: details.design!.name,
                code: details.design!.code,
                images:
                    details.design!.images
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
              )
              : null,
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
    );
  }

  Widget _buildHeader() {
    return AnimatedContainer(
      duration: Durations.short3,
      padding: const EdgeInsets.all(4),
      color: const Color(0xFF28328B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'Item Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails() {
    final controller = taggedItemDetailsController;

    return Obx(() {
      final detailsStatus = controller.taggedItemDetailsResponse.value.status;

      if (detailsStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      if (detailsStatus == Status.ERROR) {
        return Center(
          child: Text(
            'Error loading details: ${controller.taggedItemDetailsResponse.value.message}',
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (detailsStatus == Status.COMPLETED) {
        final itemData = controller.taggedItemDetailsResponse.value.data;

        if (itemData == null) {
          return const Text('No details available');
        }

        // // Handle sizeGroup as a Map
        // String sizeValue = 'NONE';
        // if (itemData.sizeGroup != null) {
        //   if (itemData.sizeGroup is Map) {
        //     sizeValue = itemData.sizeGroup['size'] ?? 'NONE';
        //   } else if (itemData.sizeGroup is String) {
        //     sizeValue = itemData.sizeGroup;
        //   }
        // }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Item Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildDetailRow(
                  'Barcode ID',
                  itemData.tagBarcode?.toString() ?? '-',
                ),
                _buildDetailRow(
                  'Item Name/ Design',
                  itemData.design?.name ?? '-',
                ),
                _buildDetailRow('Size', itemData.sizeGroup?.size ?? "-"),
                _buildDetailRow('Rate', itemData.rate ?? '-'),
                _buildDetailRow('Vendor Code', itemData.vendorCode ?? '-'),
                _buildDetailRow('Purity', itemData.purity ?? '-'),
                _buildDetailRow('HUID', itemData.huid ?? '-'),
                _buildDetailRow(
                  'Stock Head',
                  itemData.design?.stockHead?.name ?? '-',
                ),
                _buildDetailRow(
                  'Category',
                  itemData.design?.stockHead?.category?.categoryName ?? '-',
                ),
                _buildDetailRow('VA', itemData.va ?? '-'),
                _buildDetailRow(
                  'MC ',
                  _getMcDetails(
                    itemData.mc ?? '-',
                    itemData.designWastageType ?? '-',
                    itemData.designMakingChargesType ?? '-',
                  ),
                ),
                _buildDetailRow('MC Total ', itemData.mcTotal ?? '-'),
                _buildDetailRow(
                  'Stone Tot',
                  _calculateStoneTotalFromData(itemData.lineStones),
                ),
                _buildDetailRow(
                  'Last Scanned At',
                  _formatDate(itemData.lastScannedAt),
                ),
                _buildDetailRow(
                  'Counter',
                  itemData.counter?.counterName ?? '_',
                ),
              ],
            ),
          ],
        );
      }

      final index = controller.selectedItemIndex.value;
      if (index == -1) {
        return const SizedBox.shrink();
      }

      final limitedData = controller
          .getTaggedItemListingResponse
          .value
          .data
          ?.values
          ?.elementAt(index);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Loading full details for: ${limitedData?.itemDescription ?? '-'}',
          ),
        ],
      );
    });
  }

  String _calculateStoneTotalFromData(
    List<GetTaggingLineItemLineStone>? stoneData,
  ) {
    if (stoneData == null || stoneData.isEmpty) return '-';

    double total = 0;
    for (var stone in stoneData) {
      if (stone.total != null) {
        total += double.tryParse(stone.total!) ?? 0;
      }
    }

    return total > 0 ? total.toStringAsFixed(2) : '-';
  }

  String _getMcDetails(
    String mc,
    String designWastageType,
    String designMakingChargesType,
  ) {
    final String type = designMakingChargesType.trim().toLowerCase();

    if (type == 'n.wt' || type == 'g.wt') {
      return "$mc/g ($designMakingChargesType)";
    } else if (type == '%') {
      return "$mc/Pc";
    } else {
      return "$mc/g ($designMakingChargesType)";
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}-${date.month}-${date.year}';
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 160, minWidth: 80),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 160, minWidth: 80),
            child: Tooltip(
              message: value,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoneDetails() {
    final controller = taggedItemDetailsController;

    return Obx(() {
      final detailsStatus = controller.taggedItemDetailsResponse.value.status;

      if (detailsStatus != Status.COMPLETED) {
        return const Center(child: Text('Loading stone details...'));
      }

      final lineStones =
          controller.taggedItemDetailsResponse.value.data?.lineStones ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stone Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(180 - 20),
                  1: FixedColumnWidth(80 - 20),
                  2: FixedColumnWidth(120 - 20),
                  3: FixedColumnWidth(120 - 20),
                  4: FixedColumnWidth(120 - 20),
                },
                children: [
                  _buildTableRow([
                    'Stone Name',
                    'Pcs',
                    'Weight(cts)',
                    'Rate',
                    'Value',
                  ], isHeader: true),
                  if (lineStones.isEmpty)
                    _buildTableRow(['-', '-', '-', '-', '-'])
                  else
                    ...lineStones.map(
                      (stone) => _buildTableRow([
                        stone.name ?? '-',
                        stone.pieces?.toString() ?? '-',
                        stone.carat ?? stone.weight ?? '-',
                        stone.rate ?? '-',
                        stone.total ?? '-',
                      ]),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
  return TableRow(
    children:
        cells
            .map(
              (cell) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Tooltip(
                  message: cell,
                  child: Text(
                    cell,
                    style: TextStyle(
                      color: isHeader ? const Color(0xFF28328B) : Colors.black,
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal,
                      fontSize: isHeader ? 12 : 14,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
  );
}

Widget _buildImageGalleryForTaggedItems(
  EnhancedTaggedItemMediaUploadController controller,
) {
  return Column(
    children: [
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // _buildUploadButton(controller),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    controller.mediaPaths.isEmpty
                        ? 1
                        : controller.mediaPaths.length,
                itemBuilder: (context, index) {
                  if (controller.mediaPaths.isEmpty) {
                    return SizedBox(
                      // color: Colors.black,
                      // constraints: const BoxConstraints(
                      //     minWidth: 226, maxWidth: 200),
                      width: 226,
                      height: 226,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/svgs/error/no_image_found.svg',
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: _buildImageCard(index, controller),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // const SizedBox(
      //   height: 40,
      // ),
    ],
  );
}

Widget _buildImageCard(
  int index,
  EnhancedTaggedItemMediaUploadController controller,
) {
  final mediaData = controller.mediaPaths[index];

  // Check if it's a video
  if (mediaData.isVideo) {
    return _buildVideoThumbnail(mediaData);
  }

  // For images, keep the existing implementation
  return Stack(
    children: [
      InkWell(
        onTap: () {
          showDialog(
            context: Get.context!,
            builder: (context) {
              return GlobalImageView(imagePath: mediaData.path);
            },
          );
        },
        child: Container(
          constraints: const BoxConstraints(minWidth: 163, maxWidth: 200),
          width: 163,
          height: 163,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image:
                  mediaData.isFile
                      ? FileImage(File(mediaData.path)) as ImageProvider
                      : NetworkImage(mediaData.path),
              fit: BoxFit.cover,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildVideoThumbnail(MediaData mediaData) {
  return Container(
    constraints: const BoxConstraints(minWidth: 163, maxWidth: 200),
    width: 163,
    height: 163,
    decoration: ShapeDecoration(
      color: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Video icon background
        Icon(
          Icons.video_library,
          size: 60,
          color: Colors.white.withOpacity(0.3),
        ),
        // Play button overlay
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.play_arrow,
            color: Color(0xFF28328B),
            size: 30,
          ),
        ),
        // Video duration or filename (optional)
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              mediaData.fileName ?? 'Video',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
