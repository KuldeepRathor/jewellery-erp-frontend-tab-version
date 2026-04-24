import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view_model/tagged_items_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view_model/tagged_items_image_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';

class AnimatedItemDetailsWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const AnimatedItemDetailsWidget({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  AnimatedItemDetailsWidgetState createState() =>
      AnimatedItemDetailsWidgetState();
}

class AnimatedItemDetailsWidgetState extends State<AnimatedItemDetailsWidget> {
  final TaggedItemDetailsImageUploadController
  taggedItemDetailsImageUploadController =
      Get.find<TaggedItemDetailsImageUploadController>();
  final TaggedItemsDetailsController taggedItemDetailsController =
      Get.find<TaggedItemsDetailsController>();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => _buildItemDetails()),
                            const SizedBox(height: 20),

                            SizedBox(
                              height: 180,
                              child: Obx(() {
                                return _buildImageGalleryForTaggedItems(
                                  taggedItemDetailsImageUploadController,
                                );
                              }),
                            ),

                            // Expanded(
                            //   child: Container(
                            //     // height: 100,
                            //     // width: 100,
                            //     color: Colors.blue,
                            //     child: Row(
                            //       children: [
                            //         Container(
                            //           height: 100,
                            //           width: 100,
                            //           color: Colors.green,
                            //         ),
                            //         Expanded(
                            //           child: Container(
                            //             color: Colors.red,
                            //             child: ListView.builder(
                            //               scrollDirection: Axis.horizontal,
                            //               itemBuilder: (context, index) => Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Container(
                            //                   height: 100,
                            //                   width: 100,
                            //                   color: Colors.yellow,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 40),
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
            // CustomFooterTaggedBy(onDiscardPressed: () {}, taggedByText: "")
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedContainer(
      duration: Durations.short3,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      color: const Color(0xFF28328B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Item Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
    final index = taggedItemDetailsController.selectedItemIndex.value;
    final itemData = taggedItemDetailsController
        .getOrnamentTypeListingResponse
        .value
        .data
        ?.lineItems
        ?.elementAt(index);
    final listOfDesignLineItems = itemData?.design?.lineItems ?? [];

    // taggedItemDetailsImageUploadController.populateWithFetchedData(itemData!);
    // final responseData =
    //     taggedItemDetailsController.getOrnamentTypeListingResponse.value.data;
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
            _buildDetailRow('ID', itemData?.design?.code ?? '-'),
            _buildDetailRow('Item Name/ Design', itemData?.design?.name ?? '-'),
            _buildDetailRow('Size', itemData?.sizeGroup?.size ?? 'NONE'),

            _buildDetailRow('Grade', '-'), // Add grade info if available
            _buildDetailRow('Rate', itemData?.rate ?? '-'),
            _buildDetailRow(
              'Mc',
              listOfDesignLineItems.firstOrNull?.makingCharges ?? '-',
            ),
            _buildDetailRow(
              'Wastage',
              listOfDesignLineItems.firstOrNull?.wastage ?? "-",
            ), // Calculate wastage if needed
            _buildDetailRow('HUID', itemData?.huid ?? '-'),
            _buildDetailRow('Barcode No.', itemData?.tagBarcode ?? '-'),
            _buildDetailRow(
              'Tagged By',
              "${taggedItemDetailsController.getOrnamentTypeListingResponse.value.data?.employeeDetails?.firstName} ${taggedItemDetailsController.getOrnamentTypeListingResponse.value.data?.employeeDetails?.lastName}",
            ),
          ],
        ),
      ],
    );
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
    final index = taggedItemDetailsController.selectedItemIndex.value;
    final lineStones =
        taggedItemDetailsController
            .getOrnamentTypeListingResponse
            .value
            .data
            ?.lineItems
            ?.elementAt(index)
            .lineStones ??
        [];
    log("the line stones are ${lineStones.firstOrNull?.toJson()}");
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
                0: FixedColumnWidth(200 - 20),
                1: FixedColumnWidth(50 - 20),
                2: FixedColumnWidth(120 - 20),
                3: FixedColumnWidth(120 - 20),
                4: FixedColumnWidth(120 - 20),
              },
              children: [
                _buildTableRow([
                  'Stone Name',
                  'Pcs',
                  'Weight',
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
                      stone.weight ?? stone.carat ?? '-',
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
              )
              .toList(),
    );
  }

  Widget _buildUploadButton(TaggedItemDetailsImageUploadController controller) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 126,
        maxHeight: 200,
        minWidth: 163,
        maxWidth: 163,
      ),
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFFE6E8FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.pickImage(),
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.file_upload_outlined, color: Color(0xFF28328B)),
                SizedBox(height: 16),
                Text(
                  'Upload Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF28328B),
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGalleryForTaggedItems(
    TaggedItemDetailsImageUploadController controller,
  ) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUploadButton(controller),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.imagePaths.length,
                  itemBuilder: (context, index) {
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
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildImageCard(
    int index,
    TaggedItemDetailsImageUploadController controller,
  ) {
    final imageData = controller.imagePaths[index];
    return Stack(
      children: [
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return GlobalImageView(imagePath: imageData.path);
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
                    imageData.isFile
                        ? FileImage(File(imageData.path)) as ImageProvider
                        : NetworkImage(imageData.path),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: GestureDetector(
            onTap: () => controller.removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: const Color(0x19FC3A20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Icon(Icons.delete, color: Colors.red, size: 24),
            ),
          ),
        ),
      ],
    );
  }
}
