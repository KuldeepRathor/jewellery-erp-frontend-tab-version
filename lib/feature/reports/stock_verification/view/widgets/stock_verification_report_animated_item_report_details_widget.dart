import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view_model/stock_verification_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view_model/stock_verification_upload_image_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';
import 'package:svg_flutter/svg.dart';

class StockVerificationReportAnimatedItemDetailsWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const StockVerificationReportAnimatedItemDetailsWidget({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  StockVerificationReportAnimatedItemDetailsWidgetState createState() =>
      StockVerificationReportAnimatedItemDetailsWidgetState();
}

class StockVerificationReportAnimatedItemDetailsWidgetState
    extends State<StockVerificationReportAnimatedItemDetailsWidget> {
  final StockVerificationImageUploadController imageUploadController =
      Get.find<StockVerificationImageUploadController>();
  final StockVerificationReportViewModel viewModel =
      Get.find<StockVerificationReportViewModel>();
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
                            Obx(() => _buildItemDetails()),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: Obx(() {
                                return _buildImageGallery(
                                  imageUploadController,
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
                    Expanded(flex: 3, child: Obx(() => _buildStoneDetails())),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
  } // Update stock_verification_report_animated_item_details_widget.dart

  // In stock_verification_report_animated_item_details_widget.dart

  Widget _buildItemDetails() {
    final index = viewModel.selectedItemIndex.value;
    if (index == -1 || viewModel.stockVerificationList.value.data == null) {
      return const SizedBox.shrink();
    }

    final basicItem = viewModel.stockVerificationList.value.data![index];

    return Obx(() {
      final detailsStatus = viewModel.taggingDetailsResponse.value.status;
      final details = viewModel.taggingDetailsResponse.value.data;

      if (detailsStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      // Now we access fields directly from details, not from lineItems array
      final design = details?.design;
      final sizeGroup = details?.sizeGroup;
      final designLineItem = details?.designLineItem;

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
              _buildDetailRow('ID', design?.code ?? basicItem.code ?? '-'),
              _buildDetailRow(
                'Item Name/ Design',
                design?.name ?? basicItem.design?.name ?? '-',
              ),
              _buildDetailRow('Size', sizeGroup?.size ?? 'NONE'),
              _buildDetailRow('Dealer', details?.vendorCode ?? '-'),
              _buildDetailRow('Grade', '-'),
              _buildDetailRow('Rate', details?.rate ?? '-'),
              _buildDetailRow('Purity', details?.purity ?? '-'),
              _buildDetailRow(
                "MC",
                _getMcDetails(
                  details?.mc ?? '-',
                  details?.designWastageType ?? '-',
                  details?.designMakingChargesType ?? '-',
                ),
              ),
              _buildDetailRow('Wastage', designLineItem?.wastage ?? '-'),
              _buildDetailRow('HUID', details?.huid ?? '-'),
              _buildDetailRow(
                'Status',
                details?.status ?? basicItem.status ?? 'Available',
              ),
              _buildDetailRow(
                'Scanned',
                basicItem.isScanned == true ? 'Yes' : 'No',
              ),
              _buildDetailRow('Created Date', _formatDate(basicItem.createdAt)),
              _buildDetailRow(
                'Last Scanned',
                _formatDate(details?.lastScannedAt),
              ),
            ],
          ),
        ],
      );
    });
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

  Widget _buildStoneDetails() {
    final index = viewModel.selectedItemIndex.value;
    if (index == -1 || viewModel.stockVerificationList.value.data == null) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final detailsStatus = viewModel.taggingDetailsResponse.value.status;
      final details = viewModel.taggingDetailsResponse.value.data;

      if (detailsStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      // Get line stones directly from details
      final lineStones = details?.lineStones ?? [];

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
    });
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

  Widget _buildImageGallery(StockVerificationImageUploadController controller) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      controller.imagePaths.isEmpty
                          ? 1
                          : controller.imagePaths.length,
                  itemBuilder: (context, index) {
                    if (controller.imagePaths.isEmpty) {
                      return SizedBox(
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
      ],
    );
  }

  Widget _buildImageCard(
    int index,
    StockVerificationImageUploadController controller,
  ) {
    final imageData = controller.imagePaths[index];
    return Stack(
      children: [
        GestureDetector(
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
}
