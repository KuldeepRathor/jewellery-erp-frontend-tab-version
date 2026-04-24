import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/model/get_stock_issue_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/view_model/view_stock_issue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ViewStockIssueItemDetailsWidget extends StatelessWidget {
  final GetStockIssueByIdResponse data;

  ViewStockIssueItemDetailsWidget({super.key, required this.data});

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

  final totalColumnWidths = [1.43, 0.3, 0.3, 0.6];

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
    final taggingItem = item.taggingLineItem;

    return TableRow(
      children: [
        _buildCell(text: (index + 1).toString(), index: index),
        _buildCell(text: taggingItem?.code ?? '-', index: index),
        _buildCell(
          text: taggingItem?.tagNumber?.toString() ?? '-',
          index: index,
        ),
        _buildCell(text: taggingItem?.design?.name ?? '-', index: index),
        _buildCell(text: item.pieces?.toString() ?? '-', index: index),
        _buildCell(text: item.grossWeight?.toString() ?? '-', index: index),
        _buildCell(text: item.netWeight?.toString() ?? '-', index: index),
        _buildCell(text: taggingItem?.va ?? '-', index: index),
        _buildCell(text: taggingItem?.mc ?? '-', index: index),
        _buildCell(
          text: '-',
          index: index,
        ), // Stone cost is not available in the API response
        _buildCell(text: taggingItem?.huid ?? '-', index: index),
        _buildCell(
          text: '',
          index: index,
        ), // Empty cell for consistency with add page
      ],
    );
  }

  Widget _buildCell({required String text, required int index}) {
    final ViewApprovalIssueController stockIssueController = Get.put(
      ViewApprovalIssueController(),
    );
    return GestureDetector(
      onTap: () => stockIssueController.showItemDetails(index),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: CustomText(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  List<String> _calculateTotals() {
    double totalPcs = 0;
    double totalGWt = 0;
    double totalNWt = 0;

    for (var item in data.lineItems ?? []) {
      totalPcs += item.pieces ?? 0;
      totalGWt += double.tryParse(item.grossWeight ?? '0') ?? 0;
      totalNWt += double.tryParse(item.netWeight ?? '0') ?? 0;
    }

    return [
      "Total",
      totalPcs.toStringAsFixed(0),
      totalGWt.toStringAsFixed(3),
      totalNWt.toStringAsFixed(3),
      "",
    ];
  }
}
