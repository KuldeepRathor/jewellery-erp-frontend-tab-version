import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view_model/outward_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AnimatedOutwardReportDetailsBottomWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const AnimatedOutwardReportDetailsBottomWidget({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  State<AnimatedOutwardReportDetailsBottomWidget> createState() =>
      _AnimatedOutwardReportDetailsBottomWidgetState();
}

class _AnimatedOutwardReportDetailsBottomWidgetState
    extends State<AnimatedOutwardReportDetailsBottomWidget> {
  final OutwardReportViewmodel controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      height: widget.isVisible ? MediaQuery.of(context).size.height * 0.4 : 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                final taggingStatus =
                    controller.taggingDetailsResponse.value.status;
                final taggingData =
                    controller.taggingDetailsResponse.value.data;
                final selectedItem = controller.selectedCode.value;
                final employeeDetails =
                    controller
                        .taggingDetailsResponse
                        .value
                        .data
                        ?.employeeDetails;

                if (taggingStatus == Status.LOADING) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (taggingStatus == Status.ERROR) {
                  return Center(
                    child: Text(
                      controller.taggingDetailsResponse.value.message ??
                          "Error loading details",
                      style: const TextStyle(color: redTextColor),
                    ),
                  );
                }

                if (taggingStatus == Status.COMPLETED && taggingData != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Item Details Section
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: _buildItemDetails(taggingData, selectedItem),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Vertical Divider
                        const VerticalDivider(
                          color: secondaryColor,
                          thickness: 2,
                        ),
                        const SizedBox(width: 16),

                        // Outward Details Section
                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: _buildOutwardDetails(
                              taggingData,
                              selectedItem,
                              employeeDetails,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Vertical Divider
                        const VerticalDivider(
                          color: secondaryColor,
                          thickness: 2,
                        ),
                        const SizedBox(width: 16),

                        // Stone Details Section
                        Expanded(
                          flex: 3,
                          child: _buildStoneDetails(taggingData),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(child: Text('No details available'));
              }),
            ),

            // Footer with Tagged By
            Obx(() => _buildFooter()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: primaryBtnColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'Item Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
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

  Widget _buildItemDetails(
    GetTaggingLineItemResponse taggingData,
    GetOutwardReportDetailsResponseValue? selectedItem,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _buildDetailField(
              'Barcode ID',
              taggingData.tagNumber?.toString() ?? '-',
            ),
            _buildDetailField(
              'Item Name/Design',
              taggingData.design?.name ?? '-',
            ),
            _buildDetailField('Size', taggingData.sizeGroup?.toString() ?? '-'),
            _buildDetailField('Vendor', taggingData.vendorDetails?.name ?? '-'),
            _buildDetailField('Purity', taggingData.purity ?? '-'),
            _buildDetailField('HUID', taggingData.huid ?? '-'),
            _buildDetailField(
              'Stock Head',
              taggingData.design?.stockHead?.name ?? '-',
            ),
            _buildDetailField(
              'Category',
              taggingData.design?.stockHead?.category?.categoryName ?? '-',
            ),
            _buildDetailField('Wastage', taggingData.va ?? '-'),
            _buildDetailField(
              'MC ',
              _getMcDetails(
                taggingData.mc ?? '-',
                taggingData.designWastageType ?? '-',
                taggingData.designMakingChargesType ?? '-',
              ),
            ),
            _buildDetailField('MC Total', taggingData.mcTotal ?? '-'),
            _buildDetailField(
              'Stone Tot',
              _calculateStoneTotalFromData(taggingData.lineStones),
            ),
            _buildDetailField('Rate', taggingData.rate ?? '-'),
            _buildImageGallery(taggingData.images),
          ],
        ),
      ],
    );
  }

  String _getMcDetails(
    String mc,
    String designWastageType,
    String designMakingChargesType,
  ) {
    // Normalize the type for comparison by making it lowercase and trimming whitespace
    final String type = designMakingChargesType.trim().toLowerCase();

    if (type == 'n.wt' || type == 'g.wt') {
      // For Net Weight (N.wt) or Gross Weight (G.wt), the format is value/g (Type)
      return "$mc/g ($designMakingChargesType)";
    } else if (type == '%') {
      // For Percentage type ('%'), the required format is value/Pc
      return "$mc/Pc";
    } else {
      // This is a fallback for any other unexpected types.
      // It maintains the original behavior.
      return "$mc/g ($designMakingChargesType)";
    }
  }

  Widget _buildOutwardDetails(
    GetTaggingLineItemResponse taggingData,
    GetOutwardReportDetailsResponseValue? selectedItem,
    EmployeeDetails? employeeDetails,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Outward Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          children: [
            _buildDetailField(
              'Date',
              selectedItem?.createdAt != null
                  ? convertDateTimeToString(selectedItem!.createdAt)
                  : '-',
            ),
            const SizedBox(height: 12),
            _buildDetailField(
              'Time',
              selectedItem?.createdAt != null
                  ? convertDateTimeToTimeString(selectedItem!.createdAt)
                  : '-',
            ),
            const SizedBox(height: 12),
            _buildDetailField('Role ID', employeeDetails?.code ?? '-'),
            const SizedBox(height: 12),
            _buildDetailField(
              'System',
              taggingData.counter?.counterName ?? '-',
            ),
            const SizedBox(height: 12),
            _buildDetailField('Status', taggingData.status ?? '-'),
            const SizedBox(height: 12),
            _buildDetailField('Voucher ID', selectedItem?.voucherNumber ?? '-'),
          ],
        ),
      ],
    );
  }

  Widget _buildStoneDetails(GetTaggingLineItemResponse taggingData) {
    final stoneDetails = taggingData.lineStones ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stone Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Header
              _buildStoneTableRow([
                'Stone Name',
                'Pcs',
                'Weight',
                'Rate',
                'Value',
              ], isHeader: true),
              // Stone rows
              if (stoneDetails.isEmpty)
                _buildStoneTableRow(['-', '-', '-', '-', '-'])
              else
                ...stoneDetails.map(
                  (stone) => _buildStoneTableRow([
                    stone.name ?? '-',
                    stone.pieces?.toString() ?? '-',
                    stone.carat ?? stone.weight ?? '-',
                    stone.rate ?? '-',
                    stone.total ?? '-',
                  ]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoneTableRow(List<String> cells, {bool isHeader = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: isHeader ? 2 : 1,
          ),
        ),
      ),
      child: Row(
        children:
            cells
                .asMap()
                .entries
                .map(
                  (entry) => Expanded(
                    flex: entry.key == 0 ? 2 : 1, // Stone name gets more space
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tooltip(
                        message: entry.value,
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: isHeader ? primaryColor : Colors.black87,
                            fontWeight:
                                isHeader ? FontWeight.bold : FontWeight.normal,
                            fontSize: isHeader ? 13 : 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildImageGallery(List<Image>? images) {
    if (images == null || images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'No images available',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final imageUrl = images[index].presignedUrl ?? images[index].s3Key;
          if (imageUrl == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    final taggingData = controller.taggingDetailsResponse.value.data;
    if (taggingData == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 8),
          Text(
            'Tagged By: ',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            taggingData.employeeDetails != null
                ? '${taggingData.employeeDetails!.firstName ?? ''} ${taggingData.employeeDetails!.lastName ?? ''}'
                    .trim()
                : taggingData.taggedById ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Tooltip(
            message: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
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
}
