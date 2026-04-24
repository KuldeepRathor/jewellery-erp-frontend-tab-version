import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/view_approval_receipt/model/get_approval_receipt_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ViewApprovalReceiptItemDetailsWidget extends StatelessWidget {
  final GetApprovalReceiptByIdResponse data;

  ViewApprovalReceiptItemDetailsWidget({super.key, required this.data});

  final headers = [
    'Sn',
    'Item Code',
    'Tag No.',
    'Description',
    'Pcs',
    'G.Wt. (gm)',
    'N.Wt. (gm)',
    'VA',
    'MC (₹)',
    'Stone (₹)',
    'Hall Mark (₹)',
    '',
  ];

  final columnWidths = [
    0.1,
    0.3,
    0.3,
    0.75,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.3,
    0.1,
  ];

  final totalColumnWidths = [1.45, 0.3, 0.3, 0.6];

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
                columnWidths: columnWidths,
                rows: _buildRows(),
                addSizedBox: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ItemListHeaderTable(
                headers: _calculateTotals(),
                columnWidthsCustom: getColumnWidths(
                  columnWidths: totalColumnWidths,
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
              ],
            );
          }).toList(),
    );
  }

  List<TableRow> _buildRows() {
    return List.generate(
      data.lineItems?.length ?? 0,
      (index) => _buildTableRow(index),
    );
  }

  TableRow _buildTableRow(int index) {
    final item = data.lineItems![index];

    return TableRow(
      children: [
        _buildCell(text: (index + 1).toString()),
        _buildCell(text: item.code ?? '-'),
        _buildCell(text: item.tag ?? '-'),
        _buildCell(text: item.description ?? '-'),
        _buildCell(text: item.pieces?.toString() ?? '-'),
        _buildCell(text: item.grossWeight ?? '-'),
        _buildCell(text: item.netWeight ?? '-'),
        _buildCell(text: item.finalVa ?? item.taggingVa ?? '-'),
        _buildCell(text: item.finalMc ?? item.taggingMc ?? '-'),
        _buildCell(text: item.stoneCost ?? '-'),
        _buildCell(text: item.hallMark ?? '-'),
        _buildCell(text: ''), // Empty cell for consistency
      ],
    );
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

  List<String> _calculateTotals() {
    num totalPcs = 0;
    double totalGWt = 0;
    double totalNWt = 0;

    for (var item in data.lineItems ?? []) {
      totalPcs += item.pieces ?? 0;
      totalGWt += double.tryParse(item.grossWeight ?? '0') ?? 0;
      totalNWt += double.tryParse(item.netWeight ?? '0') ?? 0;
    }

    return [
      "Total",
      totalPcs.toString(),
      totalGWt.toStringAsFixed(2),
      totalNWt.toStringAsFixed(2),
      "",
    ];
  }
}
