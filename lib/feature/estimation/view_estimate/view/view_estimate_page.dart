import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/view_estimate/model/get_estimate_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class EstimateViewPage extends StatelessWidget {
  final GetEstimateByIdResponse estimateResponse;

  const EstimateViewPage({super.key, required this.estimateResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(
            header: "Estimate Details",
            wantBackButton: true,
            onBackButtonTap: () {
              SidebarController sidebarController = Get.find();
              sidebarController.popBackSelectedWidget();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  _buildBillingSummarySection(),
                  const SizedBox(height: 20),
                  _buildLineItemsSection(),
                  const SizedBox(height: 20),
                  _buildAdvanceBookingSection(),
                  const SizedBox(height: 20),
                  _buildJewelleryPlanSection(),
                  const SizedBox(height: 20),
                  _buildOldGoldSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side with Rate/Carat and Search
            Row(
              children: [
                // Rate/Carat Input (readonly for view mode)
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rate/gm',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          // Use lineItems first rate or default to "-"
                          estimateResponse.lineItems?.isNotEmpty == true
                              ? estimateResponse.lineItems!.first.rate ?? '-'
                              : '-',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Customer Details (readonly for view mode)
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          // Use customer name or ID
                          estimateResponse.partyDetails?.name ??
                              estimateResponse.customerId ??
                              '-',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Right side with Mode and Estimate Number
            Row(
              children: [
                // Mode Section
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Mode:',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'View Mode',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280), // grey2 color
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Vertical Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    color: const Color(0xFF6B7280), // grey2 color
                    height: 60,
                    width: 2,
                  ),
                ),
                // Estimate Number Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Estimate Number:',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      estimateResponse.estimateNumber ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1), // primaryColor
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItemsSection() {
    final lineItems = estimateResponse.lineItems ?? [];
    final oldGolds = estimateResponse.oldGolds ?? [];

    final headers = [
      'Sn',
      'Item Code',
      'Tag No',
      "Description",
      'Pcs',
      'G.Wt. (gm)',
      'N.Wt. (gm)',
      'VA',
      'MC (₹)',
      'Stone Cost(₹)',
      'Hall Mark',
      'Cost Discount',
      'Sales Amount',
      'Total',
      '',
    ];

    final columnWidths = [
      0.2, // Sn
      0.3, // Item Code
      0.2, // Tag No
      0.5, // Description
      0.2, // Pcs
      0.3, // G.Wt
      0.3, // N.Wt
      0.3, // VA
      0.2, // MC
      0.3, // Stone Cost
      0.3, // Hall Mark
      0.3, // Cost Discount
      0.3, // Sales Amount
      0.3, // Total
      0.1, // Empty column for consistency
    ];

    // Calculate totals
    final totals = _calculateTotals(lineItems);
    final oldGoldTotals = _calculateOldGoldTotals(oldGolds);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                children: [
                  Text(
                    'Item Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Satoshi',
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Main table with items
                    CustomTableWidget(
                      headers: [_buildTableHeaders(headers)],
                      columnWidths: columnWidths,
                      rows: _buildTableRows(lineItems),
                      addSizedBox: false,
                    ),

                    // Green Total row
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: ItemListHeaderTable(
                        headers: [
                          "Total",
                          "",
                          "",
                          "",
                          totals['pcs']?.toStringAsFixed(0) ?? "0.00",
                          totals['gwt']?.toStringAsFixed(3) ?? "0.00",
                          totals['nwt']?.toStringAsFixed(3) ?? "0.00",
                          "",
                          totals['mc']?.toStringAsFixed(2) ?? "0.00",
                          totals['stone']?.toStringAsFixed(2) ?? "0.00",
                          totals['hallmark']?.toStringAsFixed(2) ?? "0.00",
                          totals['discount']?.toStringAsFixed(2) ?? "0.00",
                          totals['sales']?.toStringAsFixed(2) ?? "0.00",
                          totals['total']?.toStringAsFixed(2) ?? "0.00",
                          "",
                        ],
                        columnWidthsCustom: getColumnWidths(
                          columnWidths: columnWidths,
                          context: Get.context!,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: totalGreenColor, // totalGreenColor
                      ),
                    ),

                    // Yellow Old Gold Total row (if old golds exist)
                    if (oldGolds.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ItemListHeaderTable(
                          headers: [
                            "Old Gold Total",
                            "",
                            oldGoldTotals['pcs']?.toStringAsFixed(2) ?? "0.00",
                            oldGoldTotals['gwt']?.toStringAsFixed(2) ?? "0.00",
                            // oldGoldTotals['nwt']?.toStringAsFixed(2) ?? "0.00",
                            "",
                            oldGoldTotals['amount']?.toStringAsFixed(2) ??
                                "0.00",
                            "",
                          ],
                          columnWidthsCustom: getColumnWidths(
                            columnWidths: const [1.0, 0.2, 0.2, 2.0, 0.3, 0.4],
                            context: Get.context!,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          backgroundColor: tertiaryColor, // tertiaryColor
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calculateTotals(
    List<GetEstimateByIdResponseLineItem> lineItems,
  ) {
    double totalPcs = 0;
    double totalGwt = 0;
    double totalNwt = 0;
    double totalVa = 0;
    double totalMc = 0;
    double totalStone = 0;
    double totalHallmark = 0;
    double totalDiscount = 0;
    double totalSales = 0;
    double totalAmount = 0;

    for (var item in lineItems) {
      totalPcs += item.finalPieces?.toDouble() ?? 0;
      totalGwt += double.tryParse(item.finalGrossWeight ?? '0') ?? 0;
      totalNwt += double.tryParse(item.finalNetWeight ?? '0') ?? 0;
      totalVa += double.tryParse(item.finalVa ?? '0') ?? 0;
      totalMc += double.tryParse(item.makingChargesAmount ?? '0') ?? 0;
      totalStone += double.tryParse(item.stoneCost ?? '0') ?? 0;
      totalHallmark += double.tryParse(item.hallMark ?? '0') ?? 0;
      totalDiscount += double.tryParse(item.discount ?? '0') ?? 0;
      totalSales += double.tryParse(item.salesAmount ?? '0') ?? 0;
      totalAmount += double.tryParse(item.totalAmount ?? '0') ?? 0;
    }

    return {
      'pcs': totalPcs,
      'gwt': totalGwt,
      'nwt': totalNwt,
      'va': totalVa,
      'mc': totalMc,
      'stone': totalStone,
      'hallmark': totalHallmark,
      'discount': totalDiscount,
      'sales': totalSales,
      'total': totalAmount,
    };
  }

  Map<String, double> _calculateOldGoldTotals(List<OldGold> oldGolds) {
    double totalPcs = 0;
    double totalGwt = 0;
    double totalNwt = 0;
    double totalAmount = 0;

    for (var item in oldGolds) {
      totalPcs += item.pieces?.toDouble() ?? 0;
      totalGwt += double.tryParse(item.grossWeight ?? '0') ?? 0;
      totalNwt += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalAmount += double.tryParse(item.amount ?? '0') ?? 0;
    }

    return {
      'pcs': totalPcs,
      'gwt': totalGwt,
      'nwt': totalNwt,
      'amount': totalAmount,
    };
  }

  TableRow _buildTableHeaders(List<String> headers) {
    return TableRow(
      children:
          headers
              .map(
                (header) => Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    header,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
    );
  }

  List<TableRow> _buildTableRows(
    List<GetEstimateByIdResponseLineItem> lineItems,
  ) {
    return lineItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return TableRow(
        children: [
          _buildDataCell((index + 1).toString()),
          _buildDataCell(item.code ?? '-'),
          _buildDataCell(item.tag ?? '-'),
          _buildDataCell(item.description ?? '-'),
          _buildDataCell(item.finalPieces?.toString() ?? '0'),
          _buildDataCell(item.finalGrossWeight ?? '-'),
          _buildDataCell(item.finalNetWeight ?? '-'),
          _buildDataCell(item.finalVa ?? '-'),
          _buildDataCell(item.makingChargesAmount ?? '-'),
          _buildDataCell(item.stoneCost ?? '-'),
          _buildDataCell(item.hallMark ?? '-'),
          _buildDataCell(item.discount ?? '-'),
          _buildDataCell(item.salesAmount ?? '-'),
          _buildDataCell(item.totalAmount ?? '-'),
          _buildDataCell(''), // Empty cell for the last column
        ],
      );
    }).toList();
  }

  Widget _buildDataCell(String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        text,
        maxLines: 1,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBillingSummarySection() {
    final billing = estimateResponse.billingSummary;
    if (billing == null) return const SizedBox.shrink();

    final oldGoldAmount = double.tryParse(billing.oldGoldAmount ?? '0') ?? 0;
    final advanceBookingAmount =
        double.tryParse(billing.advanceBookingAmount ?? '0') ?? 0;
    final jewelleryPlanAmount =
        double.tryParse(billing.jewelleryPlanAmount ?? '0') ?? 0;
    final subTotal = double.tryParse(billing.subTotal ?? '0') ?? 0;
    final gst = double.tryParse(billing.gst ?? '0') ?? 0;
    final total = double.tryParse(billing.total ?? '0') ?? 0;
    final digitalGoldAmount =
        double.tryParse(billing.digitalGoldAmount ?? '0') ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
            ),
            child: const Row(
              children: [
                Icon(Icons.receipt_long, color: primaryColor),
                SizedBox(width: 8),
                Text(
                  'Billing Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Satoshi',
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildBillingSummaryRow(
                  header: "Sub Total",
                  value: subTotal.toStringAsFixed(2),
                ),
                _buildBillingSummaryRow(
                  header: "GST",
                  value: gst.toStringAsFixed(2),
                ),
                if (oldGoldAmount > 0)
                  _buildBillingSummaryRow(
                    header: "Old Gold Discount",
                    value: oldGoldAmount.toStringAsFixed(2),
                  ),
                if (advanceBookingAmount > 0)
                  _buildBillingSummaryRow(
                    header: "Advance Booking Discount",
                    value: advanceBookingAmount.toStringAsFixed(2),
                  ),
                if (jewelleryPlanAmount > 0)
                  _buildBillingSummaryRow(
                    header: "Jewellery Plan Discount",
                    value: jewelleryPlanAmount.toStringAsFixed(2),
                  ),
                if (digitalGoldAmount > 0)
                  _buildBillingSummaryRow(
                    header: "Digital Gold Amount",
                    value: digitalGoldAmount.toStringAsFixed(2),
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Color(0xFFE5E5E5)),
                ),
                _buildBillingSummaryRow(
                  header: "Total",
                  value: total.toStringAsFixed(2),
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingSummaryRow({
    required String header,
    required String value,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            header,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontFamily: 'Satoshi',
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF1E293B),
            ),
          ),
          Text(
            '₹ $value',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? secondaryColor : const Color(0xFF475569),
              fontFamily: 'Satoshi',
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvanceBookingSection() {
    final bookings = estimateResponse.advanceBookingDetails;
    if (bookings == null || bookings.isEmpty) return const SizedBox.shrink();

    // Convert dynamic list to map list for compatibility with existing code
    final bookingMaps =
        bookings.map((booking) => booking as Map<String, dynamic>).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookingMaps.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final booking = bookingMaps[index];

        return ListTile(
          title: Text(booking['title'] ?? 'No Title'),
          subtitle: Text(booking['date'] ?? 'No Date'),
          trailing: Text(
            '₹ ${booking['amount']?.toStringAsFixed(2) ?? '0.00'}',
          ),
        );
      },
    );
  }

  Widget _buildJewelleryPlanSection() {
    // Implementation similar to _buildAdvanceBookingSection
    // Convert from model to map if needed
    return const SizedBox.shrink(); // Placeholder
  }

  Widget _buildOldGoldSection() {
    final oldGolds = estimateResponse.oldGolds;
    if (oldGolds == null || oldGolds.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
            ),
            child: const Row(
              children: [
                Text(
                  'Old Gold Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Satoshi',
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: oldGolds.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final oldGold = oldGolds[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          oldGold.description ?? '-',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '₹ ${double.tryParse(oldGold.amount ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w600,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildOldGoldDetail('Code', oldGold.code ?? '-'),
                        const SizedBox(width: 16),
                        _buildOldGoldDetail('Purity', "${oldGold.purityType}%"),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildOldGoldDetail(
                          'Pieces',
                          oldGold.pieces?.toString() ?? '0',
                        ),
                        const SizedBox(width: 16),
                        _buildOldGoldDetail(
                          'Gross Wt.',
                          '${oldGold.grossWeight ?? '0'} gm',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildOldGoldDetail(
                          'Net Wt.',
                          '${oldGold.netWeight ?? '0'} gm',
                        ),
                        const SizedBox(width: 16),
                        _buildOldGoldDetail('Rate', '₹ ${oldGold.rate ?? '0'}'),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOldGoldDetail(String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
