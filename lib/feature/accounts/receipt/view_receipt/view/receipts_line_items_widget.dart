import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

import '../model/get_receipts_by_id_response.dart';

class ReceiptsLineItemsWidget extends StatelessWidget {
  final List<LineItem> lineItems;
  final PartyDetails? partyDetails;

  const ReceiptsLineItemsWidget({
    super.key,
    required this.lineItems,
    this.partyDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
                      text: 'Payment Line Items',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Total text label
                      const Expanded(
                        flex: 2,
                        child: CustomText(
                          text: "Total",
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Empty spacer that takes up appropriate width
                      const Spacer(flex: 5),
                      // Total amount text positioned to align with the Amount column
                      SizedBox(
                        width: 100,
                        // padding: EdgeInsets.only(right: 10), // Use a fixed width for the amount column
                        child: CustomText(
                          text: _calculateTotalAmount(),
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      // More spacer to fill the rest of the row
                      const Spacer(flex: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTotalAmount() {
    double totalAmount = 0;
    for (var item in lineItems) {
      totalAmount += double.tryParse(item.amount ?? '0') ?? 0;
    }
    return totalAmount.toStringAsFixed(2);
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
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  List<TableRow> _buildRows() {
    return lineItems.mapIndexed((index, item) {
      return TableRow(
        children:
            headers.asMap().entries.map((headerEntry) {
              int headerIndex = headerEntry.key;
              String value = _getCellValue(headerIndex, item, index);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomText(
                      text: value,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const CustomDashedLineWidget(width: double.maxFinite),
                ],
              );
            }).toList(),
      );
    }).toList();
  }

  String _getCellValue(int headerIndex, LineItem item, int rowIndex) {
    switch (headerIndex) {
      case 0:
        return (rowIndex + 1).toString();
      case 1:
        return partyDetails?.name ?? '-';
      case 2:
        return item.paymentReceiptNumber ?? '-';
      case 3:
        return item.amount ?? '-';
      case 4:
        return item.method ?? '-';
      case 5:
        return item.transactionType ?? '-';
      case 6:
        return item.transactionCode ?? '-';
      case 7:
        return item.invoiceNumber ?? '-';
      case 8:
        return item.invoiceType ?? '-';
      case 9:
        return item.remarks ?? '-';
      default:
        return '-';
    }
  }

  static const List<String> headers = [
    'Sn',
    'Party Name',
    'Payment No.',
    'Amount (₹)',
    'Method',
    'Account',
    'Ref No',
    'Invoice No.',
    'Invoice Type',
    'Remarks',
  ];

  static const List<double> columnWidths = [
    0.1, // Sn
    1.05, // Party Name
    0.4, // Payment Number
    0.3, // Amount
    0.3, // Method
    0.3, // Transaction Type
    0.3, // Transaction Code
    0.5, // Invoice Number
    0.3, // Invoice Type
    0.4, // Remarks
  ];

  static final Map<int, TableColumnWidth> totalColumnWidths = {
    0: const FlexColumnWidth(0.682), // Total label
    // 1: const FlexColumnWidth(0.2), // Party Name (empty)
    // 2: const FlexColumnWidth(0.4), // Payment Number (empty)
    // 3: const FlexColumnWidth(0.4), // Amount
    // 4: const FlexColumnWidth(0.3), // Method (empty)
    // 5: const FlexColumnWidth(0.3), // Transaction Type (empty)
    // 6: const FlexColumnWidth(0.3), // Transaction Code (empty)
    // 7: const FlexColumnWidth(0.3), // Invoice Number (empty)
    // 8: const FlexColumnWidth(0.3), // Invoice Type (empty)
    // 9: const FlexColumnWidth(0.4), // Remarks (empty)
  };
}
