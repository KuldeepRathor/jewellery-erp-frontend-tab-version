import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view/add_new_stock_head.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/stock_issue_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';
import 'package:svg_flutter/svg.dart';

class AnimatedStockIssueItemDetailsWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const AnimatedStockIssueItemDetailsWidget({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  AnimatedStockIssueItemDetailsWidgetState createState() =>
      AnimatedStockIssueItemDetailsWidgetState();
}

class AnimatedStockIssueItemDetailsWidgetState
    extends State<AnimatedStockIssueItemDetailsWidget> {
  final StockIssueItemDetailsController approvalItemDetailsController =
      Get.find<StockIssueItemDetailsController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      height: widget.isVisible ? MediaQuery.of(context).size.height * 0.5 : 0,
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
                            SizedBox(height: 126, child: _buildImageGallery()),
                            const SizedBox(height: 20),
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
            FooterWidget(),
            // CustomFooterTaggedBy(onDiscardPressed: () {}, taggedByText: "")
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedContainer(
      duration: Durations.short3,
      padding: const EdgeInsets.all(16),
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
    return Obx(() {
      final index = approvalItemDetailsController.currentRowIndex.value;
      final itemData = approvalItemDetailsController.controllers[index];

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
              _buildDetailRow('ID', itemData.item_code.text),
              _buildDetailRow('Item Name/ Design', itemData.description.text),
              _buildDetailRow('Size', '-'),
              _buildDetailRow('Dealer', '-'),
              _buildDetailRow('Grade', '-'),
              _buildDetailRow('Rate', '-'),
              _buildDetailRow('Mc', itemData.mc.text),
              _buildDetailRow('Wastage', '-'),
              _buildDetailRow('HUID', itemData.hall_mark.text),
              _buildDetailRow('Pcs', itemData.pcs.text),
              _buildDetailRow('G.Wt. (gm)', itemData.gwt.text),
              _buildDetailRow('N.Wt. (gm)', itemData.nwt.text),
              _buildDetailRow('VA', itemData.va.text),
              _buildDetailRow('Stone Cost (₹)', itemData.stone.text),
            ],
          ),
        ],
      );
    });
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
    return Obx(() {
      final index = approvalItemDetailsController.currentRowIndex.value;
      final stoneDetails =
          approvalItemDetailsController
              .controllers[index]
              .stoneDetailsTableData;

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
                  0: FixedColumnWidth(200),
                  1: FixedColumnWidth(50),
                  2: FixedColumnWidth(120),
                  3: FixedColumnWidth(120),
                  4: FixedColumnWidth(120),
                },
                children: [
                  _buildTableRow([
                    'Stone Name',
                    'Pcs',
                    'Weight',
                    'Rate',
                    'Value',
                  ], isHeader: true),
                  if (stoneDetails.isEmpty)
                    _buildTableRow(['-', '-', '-', '-', '-'])
                  else
                    ...stoneDetails.map(
                      (stone) => _buildTableRow([
                        stone.name.text,
                        stone.pcs.text,
                        stone.weightUnit,
                        stone.rate.text,
                        stone.total.text,
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

  Widget _buildImageGallery() {
    return Obx(() {
      final index = approvalItemDetailsController.currentRowIndex.value;
      final images = approvalItemDetailsController.controllers[index].images;

      if (images.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/svgs/error/no_image_found.svg'),
          ),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, imageIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildImageCard(images[imageIndex]),
          );
        },
      );
    });
  }

  Widget _buildImageCard(String imageUrl) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return GlobalImageView(imagePath: imageUrl);
          },
        );
      },
      child: Container(
        width: 163,
        height: 126,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
