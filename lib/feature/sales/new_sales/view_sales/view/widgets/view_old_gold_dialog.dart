// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view_model/view_sales_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ViewOldGoldDialog extends StatefulWidget {
  const ViewOldGoldDialog({super.key});

  @override
  State<ViewOldGoldDialog> createState() => _ViewOldGoldDialogState();
}

class _ViewOldGoldDialogState extends State<ViewOldGoldDialog> {
  final ViewSalesController viewSalesController =
      Get.find<ViewSalesController>();
  final ScrollController scrollController = ScrollController();

  final headers = [
    'Sn',
    'Code',
    'Description',
    'Pcs',
    'Gross Wt.',
    'Less',
    'Net Wt.',
    'Pure',
    'Rate',
    'Round Off',
    'Total',
  ];

  final columnWidths = [
    0.1,
    0.28,
    0.28,
    0.2,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.2,
    0.28,
  ];

  final totalColumnWidths = [
    0.66,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.28,
    0.2,
    0.29,
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: Get.height * 0.5,
        width: Get.width * 0.75,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            spreadRadius: 0.5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Old Gold Details',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      final response =
          viewSalesController.getSalesRecordByIdAggregateResponse.value;

      if (response.status == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      if (response.status == Status.ERROR) {
        return Center(child: Text('Error: ${response.message}'));
      }

      final oldGolds = response.data?.oldGolds ?? [];

      if (oldGolds.isEmpty) {
        return const Center(child: Text('No old gold records found'));
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: CustomTableWidget(
                    headers: [_buildTableHeaders()],
                    columnWidths: columnWidths,
                    rows: _buildRows(oldGolds),
                    isLoadingMore: false,
                    controller: scrollController,
                    addSizedBox: false,
                  ),
                ),
                ItemListHeaderTable(
                  headers: _calculateTotals(oldGolds),
                  columnWidthsCustom: getColumnWidths(
                    columnWidths: totalColumnWidths,
                    context: context,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  backgroundColor: totalGreenColor,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
        ],
      );
    });
  }

  List<String> _calculateTotals(
    List<GetSalesRecordByIdAggregateOldGold> oldGolds,
  ) {
    double totalPcs = 0;
    double totalGWt = 0;
    double totalLess = 0;
    double totalNWt = 0;
    double totalAmount = 0;

    for (var item in oldGolds) {
      totalPcs += item.pieces?.toDouble() ?? 0;
      totalGWt += double.tryParse(item.grossWeight ?? '0') ?? 0;
      totalLess += double.tryParse(item.less ?? '0') ?? 0;
      totalNWt += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalAmount += double.tryParse(item.total ?? '0') ?? 0;
    }

    return [
      "Total",
      totalPcs.toStringAsFixed(2),
      totalGWt.toStringAsFixed(3),
      totalLess.toStringAsFixed(2),
      totalNWt.toStringAsFixed(3),
      "", // Purity doesn't have a total
      "", // Rate doesn't have a total
      "", // Round off doesn't have a total
      totalAmount.toStringAsFixed(2),
      "",
    ];
  }

  TableRow _buildTableHeaders() {
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sn") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: header,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  List<TableRow> _buildRows(List<GetSalesRecordByIdAggregateOldGold> oldGolds) {
    return List.generate(
      oldGolds.length,
      (index) => _buildTableRow(index, oldGolds[index]),
    );
  }

  TableRow _buildTableRow(
    int index,
    GetSalesRecordByIdAggregateOldGold oldGold,
  ) {
    return TableRow(
      children: [
        _buildCell(text: (index + 1).toString()),
        _buildCell(text: oldGold.code ?? ''),
        _buildCell(text: oldGold.description ?? ''),
        _buildCell(text: oldGold.pieces?.toString() ?? '0'),
        _buildCell(text: oldGold.grossWeight ?? '0'),
        _buildCell(text: oldGold.less ?? '0'),
        _buildCell(text: oldGold.netWeight ?? '0'),
        _buildCell(text: oldGold.purityType ?? '0'),
        _buildCell(text: oldGold.rate ?? '0'),
        _buildCell(text: oldGold.roundOff ?? '0'),
        _buildCell(text: oldGold.total ?? '0'),
      ],
    );
  }

  Widget _buildCell({required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Tooltip(
        message: text,
        child: CustomText(
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            spreadRadius: 0.5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 38,
                width: 140,
                child: const Center(
                  child: CustomText(
                    text: "Close",
                    fontSize: 16,
                    color: whiteColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
