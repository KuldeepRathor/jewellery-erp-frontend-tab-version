// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/line_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/widgets/stone_details_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ItemDetailsWidget extends StatelessWidget {
  final List<LineItem> lineItems;

  const ItemDetailsWidget({super.key, required this.lineItems});

  @override
  Widget build(BuildContext context) {
    log(
      "The value is ${lineItems.map((e) => e.lineStones?.map((e) => e.toJson()))}",
    );
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
                columnWidthsCustom: totalColumnWidths,
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
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  List<TableRow> _buildRows() {
    return lineItems.mapIndexed((index, lineItem) {
      return TableRow(
        children:
            headers.asMap().entries.map((headerEntry) {
              int headerIndex = headerEntry.key;
              String value = _getCellValue(headerIndex, lineItem, index);
              return GestureDetector(
                onTap: () {
                  if (headerEntry.value == "Stone (₹)") {
                    List<StoneDetailsTableData> details =
                        lineItems[index].lineStones
                            ?.map(
                              (e) => StoneDetailsTableData(
                                id: e.id,
                                name: TextEditingController(text: e.name),
                                carat_weight: TextEditingController(
                                  text: e.carat ?? e.weight ?? "",
                                ),
                                pcs: TextEditingController(
                                  text: e.pieces.toString(),
                                ),
                                rate: TextEditingController(text: e.rate ?? ""),
                                total: TextEditingController(
                                  text: e.total ?? '',
                                ),
                                weightUnit: e.carat == null ? "gm" : "CT",
                              ),
                            )
                            .toList() ??
                        [];

                    Get.dialog(
                      StoneDetailsDialog(
                        initialStoneValue: details,
                        onSave: (totalValue, stoneDetailsValue) {},
                        isDisabled: true,
                      ),
                    );
                  }
                },
                child: Column(
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
                ),
              );
            }).toList(),
      );
    }).toList();
  }

  String getWastageValues(LineItem lineItem) {
    print("getting wastage values");
    if (lineItem.va != null) {
      print(
        "getting wastage values : ${lineItem.va ?? "-"
                " %"}",
      );
      return "${lineItem.va ?? "-"} %";
    }
    if (lineItem.tch != null) {
      print(
        "getting wastage values : ${lineItem.tch ?? "-"
                " %"}",
      );
      return "${lineItem.tch ?? "-"} gm";
    }
    return "-";
  }

  String _getCellValue(int headerIndex, LineItem item, int rowIndex) {
    switch (headerIndex) {
      case 0:
        return (rowIndex + 1).toString();
      case 1:
        return item.code?.toString() ?? '';
      case 2:
        return item.itemDescription?.toString() ?? '';
      case 3:
        return item.pieces?.toString() ?? '';
      case 4:
        return item.grossWeight?.toString() ?? '';
      case 5:
        return item.less?.toString() ?? '';
      case 6:
        return item.netWeight?.toString() ?? '';
      case 7:
        return getWastageValues(item);
      case 8:
        return item.mc?.toString() ?? '';
      case 9:
        return item.stone?.toString() ?? '';
      case 10:
        return item.rate?.toString() ?? '';
      case 11:
        return item.amount?.toString() ?? '';
      default:
        return '';
    }
  }

  double getVADoubleValue(LineItem lineItem) {
    if (lineItem.va != null) {
      return double.tryParse(lineItem.va ?? "") ?? 0;
    }
    if (lineItem.tch != null) {
      return double.tryParse(lineItem.tch ?? "") ?? 0;
    }
    return 0;
  }

  List<String> _calculateTotals() {
    double totalPcs = 0,
        totalGWt = 0,
        totalLess = 0,
        totalNWt = 0,
        totalVATch = 0,
        totalMC = 0,
        totalStone = 0,
        totalRate = 0,
        totalAmount = 0;

    for (var item in lineItems) {
      totalPcs += double.tryParse(item.pieces.toString()) ?? 0;
      totalGWt += double.tryParse(item.grossWeight ?? '0') ?? 0;
      totalLess += double.tryParse(item.less ?? '0') ?? 0;
      totalNWt += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalVATch += getVADoubleValue(item);
      totalMC += double.tryParse(item.mc ?? '0') ?? 0;
      totalStone += double.tryParse(item.stone ?? '0') ?? 0;
      totalRate += double.tryParse(item.rate ?? '0') ?? 0;
      totalAmount += double.tryParse(item.amount ?? '0') ?? 0;
    }

    return [
      "Total",
      totalPcs.toStringAsFixed(2),
      totalGWt.toStringAsFixed(3),
      totalLess.toStringAsFixed(3),
      totalNWt.toStringAsFixed(3),
      totalVATch.toStringAsFixed(2),
      totalMC.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      totalRate.toStringAsFixed(2),
      totalAmount.toStringAsFixed(2),
    ];
  }

  static const List<String> headers = [
    'Sn',
    'Code',
    'Item Description',
    'Pcs',
    'G.Wt. (gm)',
    'Less',
    'N.Wt. (gm)',
    'WST/Tch',
    'MC (₹)',
    'Stone (₹)',
    'Rate (₹)',
    'Amount (₹)',
  ];

  static const List<double> columnWidths = [
    0.1,
    0.28,
    0.72,
    0.2,
    0.32,
    0.3,
    0.325,
    0.2,
    0.3,
    0.32,
    0.3,
    0.3,
  ];

  static final Map<int, TableColumnWidth> totalColumnWidths = {
    0: const FlexColumnWidth(1.05),
    1: const FlexColumnWidth(0.2),
    2: const FlexColumnWidth(0.3),
    3: const FlexColumnWidth(0.3),
    4: const FlexColumnWidth(0.32),
    5: const FlexColumnWidth(0.2),
    6: const FlexColumnWidth(0.3),
    7: const FlexColumnWidth(0.3),
    8: const FlexColumnWidth(0.3),
    9: const FlexColumnWidth(0.3),
  };
}
