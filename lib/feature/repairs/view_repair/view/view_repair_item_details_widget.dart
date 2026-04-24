import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/model/get_repair_details_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ViewRepairItemDetailsWidget extends StatelessWidget {
  final GetRepairDetailsByIdResponse repairData;

  const ViewRepairItemDetailsWidget({super.key, required this.repairData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Item Details',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTableWidget(
                headers: [_buildTableHeaders()],
                columnWidths: _getColumnWidths(),
                rows: _buildRows(),
                addSizedBox: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ItemListHeaderTable(
                headers: _getTotalHeadersValue(),
                columnWidthsCustom: getColumnWidths(
                  columnWidths: _getTotalColumnWidths(),
                  context: context,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: totalGreenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeaders() {
    final headers = [
      'Sn',
      'Item Description',
      'Size',
      'Purity',
      'No. of Pieces',
      'Amount (₹)',
      'Status',
    ];

    return TableRow(
      children:
          headers.map((header) {
            return Row(
              children: [
                if (header != "Sn") const SizedBox(width: 4),
                Flexible(
                  child: CustomText(
                    text: header,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Visibility(
                  visible: header == 'WST/Tch' || header == 'Stone (₹)',
                  child: Tooltip(
                    message: "Info about $header",
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: toolTipBgColor,
                    ),
                    triggerMode: TooltipTriggerMode.tap,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  List<double> _getColumnWidths() {
    return [
      0.1, // Sn
      0.75, // Item Description
      0.3, // Size
      0.3, // Purity
      0.3, // No. of Pieces
      0.3, // Amount
      0.3, // Status
    ];
  }

  List<TableRow> _buildRows() {
    final lineItems = repairData.lineItems ?? [];

    if (lineItems.isEmpty) {
      return [
        TableRow(children: List.generate(7, (_) => _buildCell(text: "N/A"))),
      ];
    }

    return List.generate(lineItems.length, (index) {
      final item = lineItems[index];

      return TableRow(
        children: [
          _buildCell(text: (index + 1).toString()),
          _buildCell(text: item.itemDescription ?? 'N/A'),
          _buildCell(text: item.size?.toString() ?? 'N/A'),
          _buildCell(text: item.purity ?? 'N/A'),
          _buildCell(text: item.noOfPieces?.toString() ?? 'N/A'),
          _buildCell(text: item.amount?.toString() ?? 'N/A'),
          _buildStatusCell(item.status ?? 'N/A'),
        ],
      );
    });
  }

  Widget _buildCell({required String text}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: CustomText(
        text: text,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    Color statusColor;

    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'in progress':
        statusColor = Colors.orange;
        break;
      case 'pending':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: CustomText(
        text: status,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: statusColor,
      ),
    );
  }

  List<String> _getTotalHeadersValue() {
    // Calculate totals
    int totalPieces = 0;
    double totalAmount = 0;

    for (var item in repairData.lineItems ?? []) {
      // Make sure to handle parsing errors with null or empty values
      if (item.noOfPieces != null) {
        // Convert the noOfPieces value to int with safe parsing
        totalPieces += int.tryParse(item.noOfPieces.toString()) ?? 0;
      }

      if (item.amount != null) {
        totalAmount += double.tryParse(item.amount.toString()) ?? 0;
      }
    }

    return ["Total", totalPieces.toString(), totalAmount.toStringAsFixed(2)];
  }

  List<double> _getTotalColumnWidths() {
    return [
      1.43, // Title
      0.3, // Pieces
      0.6, // Amount
    ];
  }
}
