import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/branch_transfer_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class BranchTransferItemPreview
    extends GetView<BranchTransferItemDetailsController> {
  const BranchTransferItemPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.getPreviewItems();
      if (items.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        width: Get.width / 1.4,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              item.design?.images != null &&
                                      item.design.images.isNotEmpty
                                  ? item.design.images.first.presignedUrl
                                  : 'https://via.placeholder.com/100',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: _buildItemDetails(item)),
                        ],
                      ),
                      CustomDashedLineWidget(width: Get.width),
                      const SizedBox(height: 8),
                      if (item.lineStones != null && item.lineStones.isNotEmpty)
                        _buildStoneDetails(item.lineStones),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildItemDetails(dynamic item) {
    final details = [
      {"title": "Item Name / Design", "value": item.design?.name ?? "-"},
      {"title": "PCs", "value": item.pieces?.toString() ?? "-"},
      {"title": "Size", "value": item.sizeGroup?.size ?? "-"},
      {"title": "Wast", "value": item.design?.lineItems?.first?.wastage ?? "-"},
      {"title": "Mc", "value": item.mc?.toString() ?? "-"},
      {"title": "Stock", "value": item.status ?? "-"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          details.map((detail) {
            return Column(
              children: [
                const SizedBox(height: 4),
                Text(
                  detail["title"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detail["value"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4758EC),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildStoneDetails(List<dynamic> stones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Stone Details",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...stones.map((stone) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStoneColumn("Stone Name", stone.name),
                _buildStoneColumn("Pcs", "${stone.pieces}"),
                _buildStoneColumn("Carat / Weight", "${stone.carat}"),
                _buildStoneColumn("Size", ""),
                _buildStoneColumn("Rate", stone.rate),
                _buildStoneColumn("Total", stone.total),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStoneColumn(String title, String value) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4758EC),
          ),
        ),
      ],
    );
  }
}
