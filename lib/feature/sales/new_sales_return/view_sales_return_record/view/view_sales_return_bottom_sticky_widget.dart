// Updated view_sales_return_bottom_sticky_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/model/get_sales_return_record_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view_model/view_sales_return_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view_model/view_sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:svg_flutter/svg.dart';

class ViewSalesReturnBottomStickyWidget extends StatefulWidget {
  const ViewSalesReturnBottomStickyWidget({super.key});

  @override
  ViewSalesReturnBottomStickyWidgetState createState() =>
      ViewSalesReturnBottomStickyWidgetState();
}

class ViewSalesReturnBottomStickyWidgetState
    extends State<ViewSalesReturnBottomStickyWidget> {
  final ViewSalesReturnItemDetailsController controller =
      Get.find<ViewSalesReturnItemDetailsController>();
  final ViewSalesReturnRecordController viewSalesReturnController =
      Get.find<ViewSalesReturnRecordController>();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final response =
              viewSalesReturnController.getSalesReturnRecordByIdResponse.value;

          if (response.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (response.status == Status.ERROR) {
            return Center(child: Text('Error: ${response.message}'));
          }

          if (response.status == Status.COMPLETED && response.data != null) {
            final lineItems = response.data?.lineItems ?? [];
            final selectedLineItem =
                lineItems.isNotEmpty
                    ? lineItems[viewSalesReturnController
                        .currentSelectedItemIndex
                        .value]
                    : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  _buildItemDetails(selectedLineItem),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 100,
                                    child: _buildImageGallery(),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 24),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.assignment_return,
                                                  color: primaryColor,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Return Status: ',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Returned",
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(color: grey2, thickness: 3),
                        Expanded(flex: 3, child: _buildStoneDetails()),
                        const VerticalDivider(
                          color: primaryColor,
                          thickness: 3,
                        ),
                        Expanded(
                          flex: 3,
                          child: _buildReturnSummary(response.data),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        }),
      ),
    );
  }

  Widget _buildReturnSummary(GetSalesReturnRecordByIdResponse? data) {
    if (data == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Return Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildReturnSummaryRow('Return Number', data.saleReturnNumber ?? '-'),
          _buildReturnSummaryRow(
            'Return Date',
            data.createdAt?.toString().split(' ')[0] ?? '-',
          ),
          _buildReturnSummaryRow(
            'Original Sale',
            data.saleRecord?.saleNumber ?? '-',
          ),
          _buildReturnSummaryRow(
            'Total Items',
            data.lineItems?.length.toString() ?? '0',
          ),
          _buildReturnSummaryRow(
            'Total Amount',
            _calculateTotalReturnValue(data.lineItems ?? []),
            isTotal: true,
          ),
          if (data.remarks != null && data.remarks!.isNotEmpty)
            _buildReturnSummaryRow('Remarks', data.remarks!),
        ],
      ),
    );
  }

  Widget _buildReturnSummaryRow(
    String header,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            isTotal && value != '-' ? '₹ ${formatCurrency(value)}' : value,
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? primaryColor : null,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails(GetSalesReturnRecordByIdResponseLineItem? lineItem) {
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
            _buildDetailRow('ID', lineItem?.code ?? ''),
            _buildDetailRow('Item Name/ Design', lineItem?.description ?? ''),
            _buildDetailRow('MC', '${lineItem?.finalMc ?? "0"} ₹'),
            _buildDetailRow('Pcs', lineItem?.pieces?.toString() ?? '0'),
            _buildDetailRow('G.Wt. (gm)', lineItem?.grossWeight ?? '0'),
            _buildDetailRow('N.Wt. (gm)', lineItem?.netWeight ?? '0'),
            _buildDetailRow('VA', '${lineItem?.finalVa ?? "0"} ₹'),
            _buildDetailRow('Stone Cost (₹)', lineItem?.stoneCost ?? '0'),
            _buildDetailRow('Tag No', lineItem?.tag ?? '0'),
            _buildDetailRow('Hall Mark (₹)', lineItem?.hallMark ?? '0'),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: primaryColor, // Red theme for returns
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Item Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          VerticalDivider(color: Colors.transparent, thickness: 3),
          Expanded(flex: 3, child: SizedBox()),
          VerticalDivider(color: Colors.transparent, thickness: 3),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Return Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 160, minWidth: 80),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoneDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Stone Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(120 - 15),
                  1: FixedColumnWidth(50 - 20),
                  2: FixedColumnWidth(80 - 15),
                  3: FixedColumnWidth(80 - 20),
                  4: FixedColumnWidth(80 - 10),
                  5: FixedColumnWidth(80 - 10),
                },
                children: [
                  _buildTableRow([
                    'Stone Name',
                    'Pcs',
                    'Weight',
                    'Unit',
                    'Rate',
                    'Value',
                  ], isHeader: true),
                  // For now showing placeholder - in real implementation,
                  // you would get stone details from the API response
                  _buildTableRow(['-', '-', '-', '-', '-', '-']),
                ],
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
                      color: isHeader ? Colors.black : primaryColor,
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
    // Placeholder for image gallery
    // In real implementation, you would get images from the API response
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildImageCard(),
        );
      },
    );
  }

  Widget _buildImageCard({String? imageUrl}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 163, maxWidth: 200),
      width: 163,
      height: 226,
      decoration: ShapeDecoration(
        image:
            imageUrl != null
                ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )
                : null,
        color: imageUrl == null ? primaryColor : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child:
          imageUrl == null
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svgs/error/no_image_found.svg'),
              )
              : const SizedBox.shrink(),
    );
  }

  String _calculateTotalReturnValue(
    List<GetSalesReturnRecordByIdResponseLineItem> lineItems,
  ) {
    double total = 0;
    for (var item in lineItems) {
      total += double.tryParse(item.totalAmount ?? '0') ?? 0;
    }
    return total.toStringAsFixed(2);
  }
}
