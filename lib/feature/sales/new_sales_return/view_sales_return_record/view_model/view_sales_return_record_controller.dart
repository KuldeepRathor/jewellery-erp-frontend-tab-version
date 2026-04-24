// Updated view_sales_return_record_controller.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/model/get_sales_return_record_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view/view_sales_return_record_page.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewSalesReturnRecordController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  final getSalesReturnRecordByIdResponse =
      Rx<ApiResponse<GetSalesReturnRecordByIdResponse>>(
        ApiResponse.initial("Initial"),
      );

  // Add current item selection for bottom widget
  final RxInt currentSelectedItemIndex = 0.obs;

  void updateSelectedItem(int index) {
    currentSelectedItemIndex.value = index;
  }

  Future<void> getSalesRecordById({required String id}) async {
    try {
      getSalesReturnRecordByIdResponse.value = ApiResponse.loading("Loading");
      final response = await estimationRepository.getSalesReturnRecordById(
        id: id,
      );
      getSalesReturnRecordByIdResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getSalesReturnRecordByIdResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }

  // Calculate totals for return summary
  Map<String, dynamic> calculateReturnTotals() {
    final response = getSalesReturnRecordByIdResponse.value;
    if (response.status != Status.COMPLETED || response.data == null) {
      return {
        'totalItems': 0,
        'totalPieces': 0,
        'totalGrossWeight': 0.0,
        'totalNetWeight': 0.0,
        'totalAmount': 0.0,
      };
    }

    final lineItems = response.data!.lineItems ?? [];

    int totalItems = lineItems.length;
    int totalPieces = 0;
    double totalGrossWeight = 0.0;
    double totalNetWeight = 0.0;
    double totalAmount = 0.0;

    for (var item in lineItems) {
      totalPieces += item.pieces ?? 0;
      totalGrossWeight += double.tryParse(item.grossWeight ?? '0') ?? 0;
      totalNetWeight += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalAmount += double.tryParse(item.totalAmount ?? '0') ?? 0;
    }

    return {
      'totalItems': totalItems,
      'totalPieces': totalPieces,
      'totalGrossWeight': totalGrossWeight,
      'totalNetWeight': totalNetWeight,
      'totalAmount': totalAmount,
    };
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}

// Enhanced table widget with selection support
// view_sales_return_enhanced_table_widget.dart
class ViewSalesReturnEnhancedTableWidget extends StatefulWidget {
  const ViewSalesReturnEnhancedTableWidget({super.key});

  @override
  State<ViewSalesReturnEnhancedTableWidget> createState() =>
      _ViewSalesReturnEnhancedTableWidgetState();
}

class _ViewSalesReturnEnhancedTableWidgetState
    extends State<ViewSalesReturnEnhancedTableWidget> {
  final ViewSalesReturnRecordController viewSalesReturnController =
      Get.find<ViewSalesReturnRecordController>();

  final headers = [
    'Sn',
    'Item Code',
    'Tag No',
    'Description',
    'Pcs',
    'G.Wt. (gm)',
    'N.Wt. (gm)',
    'VA (₹)',
    'MC (₹)',
    'Stone (₹)',
    'Hall Mark (₹)',
    'Discount (₹)',
    'Sales Amount (₹)',
    'Total (₹)',
  ];

  final columnWidths = [
    0.08,
    0.2,
    0.2,
    0.3,
    0.2,
    0.3,
    0.3,
    0.2,
    0.2,
    0.2,
    0.2,
    0.2,
    0.3,
    0.3,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Container(
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
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      final response =
                          viewSalesReturnController
                              .getSalesReturnRecordByIdResponse
                              .value;

                      if (response.status == Status.LOADING) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (response.status == Status.ERROR) {
                        return Center(
                          child: Text('Error: ${response.message}'),
                        );
                      }

                      if (response.status == Status.COMPLETED &&
                          response.data != null) {
                        final lineItems = response.data?.lineItems ?? [];

                        return Table(
                          columnWidths: _getColumnWidths(),
                          children: [
                            _buildTableHeaders(),
                            ..._buildRows(lineItems),
                          ],
                        );
                      }

                      return const SizedBox();
                    }),
                  ),
                ),
              ),
              _buildTotalsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Map<int, TableColumnWidth> _getColumnWidths() {
    Map<int, TableColumnWidth> widths = {};
    for (int i = 0; i < columnWidths.length; i++) {
      widths[i] = FlexColumnWidth(columnWidths[i]);
    }
    return widths;
  }

  TableRow _buildTableHeaders() {
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      String header = headers[i];
      cells.add(
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFFC3A20), // Red theme for returns
          ),
          child: Text(
            header,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return TableRow(children: cells);
  }

  List<TableRow> _buildRows(
    List<GetSalesReturnRecordByIdResponseLineItem> lineItems,
  ) {
    return lineItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      // Check if this row is selected
      bool isSelected =
          viewSalesReturnController.currentSelectedItemIndex.value == index;

      List<Widget> cells = [
        _buildCell(text: (index + 1).toString(), isSelected: isSelected),
        _buildCell(text: item.code ?? '', isSelected: isSelected),
        _buildCell(text: item.tag ?? '', isSelected: isSelected),
        _buildCell(text: item.description ?? '', isSelected: isSelected),
        _buildCell(
          text: item.pieces?.toString() ?? '0',
          isSelected: isSelected,
        ),
        _buildCell(text: item.grossWeight ?? '0', isSelected: isSelected),
        _buildCell(text: item.netWeight ?? '0', isSelected: isSelected),
        _buildCell(text: item.finalVa ?? '0', isSelected: isSelected),
        _buildCell(text: item.finalMc ?? '0', isSelected: isSelected),
        _buildCell(text: item.stoneCost ?? '0', isSelected: isSelected),
        _buildCell(text: item.hallMark ?? '0', isSelected: isSelected),
        _buildCell(text: item.discount ?? '0', isSelected: isSelected),
        _buildCell(text: item.salesAmount ?? '0', isSelected: isSelected),
        _buildCell(text: item.totalAmount ?? '0', isSelected: isSelected),
      ];

      return TableRow(
        children:
            cells
                .map(
                  (cell) => GestureDetector(
                    onTap: () {
                      viewSalesReturnController.updateSelectedItem(index);
                    },
                    child: cell,
                  ),
                )
                .toList(),
      );
    }).toList();
  }

  Widget _buildCell({required String text, bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFE6E6) : Colors.white,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
          right: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? const Color(0xFFFC3A20) : Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTotalsRow() {
    return Obx(() {
      final totals = viewSalesReturnController.calculateReturnTotals();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFFFE6E6), // Light red for totals
        ),
        child: Table(
          columnWidths: _getColumnWidths(),
          children: [
            TableRow(
              children: [
                _buildTotalCell(''),
                _buildTotalCell('Total'),
                _buildTotalCell(''),
                _buildTotalCell(''),
                _buildTotalCell(totals['totalPieces'].toString()),
                _buildTotalCell(totals['totalGrossWeight'].toStringAsFixed(3)),
                _buildTotalCell(totals['totalNetWeight'].toStringAsFixed(3)),
                _buildTotalCell(''), // VA total
                _buildTotalCell(''), // MC total
                _buildTotalCell(''), // Stone total
                _buildTotalCell(''), // Hall mark total
                _buildTotalCell(''), // Discount total
                _buildTotalCell(''), // Sales amount total
                _buildTotalCell(
                  '₹ ${formatCurrency(totals['totalAmount'].toStringAsFixed(2))}',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTotalCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFC3A20),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// Utility methods for formatting and calculations
class SalesReturnUtils {
  static String formatReturnDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatReturnTime(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String getReturnStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return '0xFF4CAF50'; // Green
      case 'pending':
        return '0xFFFF9800'; // Orange
      case 'cancelled':
        return '0xFFF44336'; // Red
      default:
        return '0xFF9E9E9E'; // Grey
    }
  }

  static Map<String, dynamic> calculateReturnSummary(
    List<GetSalesReturnRecordByIdResponseLineItem> lineItems,
  ) {
    double totalAmount = 0;
    double totalWeight = 0;
    int totalPieces = 0;

    for (var item in lineItems) {
      totalAmount += double.tryParse(item.totalAmount ?? '0') ?? 0;
      totalWeight += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalPieces += item.pieces ?? 0;
    }

    return {
      'totalAmount': totalAmount,
      'totalWeight': totalWeight,
      'totalPieces': totalPieces,
      'itemCount': lineItems.length,
    };
  }
}

// Custom widgets for common return UI elements
class ReturnStatusBadge extends StatelessWidget {
  final String status;
  final double? fontSize;

  const ReturnStatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = Colors.green;
        break;
      case 'pending':
        backgroundColor = Colors.orange;
        break;
      case 'cancelled':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ReturnAmountDisplay extends StatelessWidget {
  final String amount;
  final String label;
  final bool isHighlighted;

  const ReturnAmountDisplay({
    super.key,
    required this.amount,
    required this.label,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFFFE6E6) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? const Color(0xFFFC3A20) : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${formatCurrency(amount)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? const Color(0xFFFC3A20) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Routes configuration for the new return view
class SalesReturnRoutes {
  static const String viewSalesReturn = '/view-sales-return';

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: viewSalesReturn,
        page: () {
          final String id = Get.parameters['id'] ?? '';
          return ViewSalesReturnInvoicePage(id: id);
        },
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ];
  }
}

// Navigation helper
class SalesReturnNavigation {
  static void navigateToViewReturn(String returnId) {
    Get.toNamed(
      SalesReturnRoutes.viewSalesReturn,
      parameters: {'id': returnId},
    );
  }

  static void navigateBack() {
    Get.back();
  }
}
