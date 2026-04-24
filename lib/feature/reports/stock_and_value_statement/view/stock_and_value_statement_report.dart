import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/model/stock_and_value_statement_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/view/widgets/stock_and_value_statement_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/view_model/stock_and_value_statement_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_reports_table.dart';

class StockAndValueStatementReport
    extends GetView<StockAndValueStatementReportViewModel> {
  const StockAndValueStatementReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: GetBuilder<StockAndValueStatementReportViewModel>(
        builder: (_) {
          return FocusScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: 'Stock And Value Statement Report',
                  isReport: true,
                  wantBackButton: true,
                  onBackButtonTap: () {
                    Get.back();
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActionBar(context),
                        const SizedBox(height: 8),
                        stockAndValueReportTable(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: getDeviceWidth(context) * .96,
          child: Row(
            children: [
              // Add the filter widget similar to ItemStatementReport
              const StockAndValueStatementReportFilterWidget(),

              const Spacer(),

              CustomButton2(
                backgroundColor: grey1,
                textColor: primaryBtnColor,
                onTap: () async {
                  await controller.downloadReport();
                },
                image: 'assets/svgs/download.svg',
                buttonName: 'Download',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget stockAndValueReportTable() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(Get.context!).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(
                    () => Row(
                      children: [
                        const Text(
                          "Stock And Value Statement Report",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Text(
                          controller.getFormattedDateRange(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildStockAndValueReport(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStockAndValueReport() {
    return GetBuilder<StockAndValueStatementReportViewModel>(
      builder: (context) {
        return Obx(() {
          final apiStatus =
              controller.stockAndStatmentValueReportResponseModel.value.status;
          if (apiStatus == Status.COMPLETED) {
            return CustomTableReportWidget(
              headers: [buildTableHeaders()],
              columnWidthsHeaders: controller.columnWidthsHeaders,
              subHeaders: [buildTableSubHeaders()],
              columnWidths: controller.columnWidths,
              rows: buildRows(Get.context!),
              addSizedBox: true,
            );
          } else if (apiStatus == Status.LOADING) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTableReportWidget(
                  headers: [buildTableHeaders()],
                  columnWidthsHeaders: controller.columnWidthsHeaders,
                  subHeaders: [buildTableSubHeaders()],
                  columnWidths: controller.columnWidths,
                  rows: const [],
                  addSizedBox: false,
                ),
                const Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            );
          } else if (apiStatus == Status.ERROR) {
            return Column(
              children: [
                CustomTableReportWidget(
                  headers: [buildTableHeaders()],
                  columnWidthsHeaders: controller.columnWidthsHeaders,
                  subHeaders: [buildTableSubHeaders()],
                  columnWidths: controller.columnWidths,
                  rows: const [],
                  addSizedBox: false,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      controller
                              .stockAndStatmentValueReportResponseModel
                              .value
                              .message ??
                          "Something went wrong",
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Expanded(
              child: Center(
                child: Text(
                  controller
                          .stockAndStatmentValueReportResponseModel
                          .value
                          .message ??
                      "Something went wrong",
                ),
              ),
            );
          }
        });
      },
    );
  }

  // Keep all the existing table building methods unchanged
  TableRow buildTableHeaders() {
    return TableRow(
      children: [
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: CustomText(
                  text: "Code / Item",
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: CustomText(
                  text: "Opening",
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: CustomText(
                  text: "Inward",
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: CustomText(
                  text: "Outward",
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          // Add this line to match other headers:
          margin: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: CustomText(
                  text: "Closing",
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TableRow buildTableSubHeaders() {
    int basicColCount = 2;
    int sectionColCount =
        2 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);

    List<int> sectionEndIndices = [];
    List<int> sectionStartIndices = [];

    sectionEndIndices.add(1);
    sectionStartIndices.add(0);

    int currentIndex = basicColCount - 1;

    sectionStartIndices.add(currentIndex + 1);
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    sectionStartIndices.add(currentIndex + 1);
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    sectionStartIndices.add(currentIndex + 1);
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    sectionStartIndices.add(currentIndex + 1);
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    return TableRow(
      children: List.generate(controller.subHeader.length, (i) {
        bool isFirstInSection = sectionStartIndices.contains(i);
        bool isLastInSection = sectionEndIndices.contains(i);
        bool shouldAddMargin = isLastInSection && i != 0;

        BorderRadius borderRadius;
        if (isFirstInSection && isLastInSection) {
          borderRadius = BorderRadius.circular(8);
        } else if (isFirstInSection) {
          borderRadius = const BorderRadius.only(
            bottomLeft: Radius.circular(8),
          );
        } else if (isLastInSection) {
          borderRadius = const BorderRadius.only(
            bottomRight: Radius.circular(8),
          );
        } else {
          borderRadius = BorderRadius.zero;
        }

        return Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: EdgeInsets.only(right: shouldAddMargin ? 12.0 : 0),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.7),
            borderRadius: borderRadius,
          ),
          child: Row(
            children: [
              CustomText(
                text: controller.subHeader[i],
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        );
      }),
    );
  }

  // Keep all the remaining methods from the original implementation
  String _formatGroupName(String groupName) {
    if (groupName.length <= 10 && !groupName.contains(' ')) {
      return 'Category: $groupName';
    }
    return groupName;
  }

  String _getGroupKeyFromItem(CombinedValue item) {
    if (item.description != null && item.description!.isNotEmpty) {
      final desc = item.description!.toUpperCase();

      if (desc.contains('GOLD')) return 'GOLD ITEMS';
      if (desc.contains('SILVER')) return 'SILVER ITEMS';
      if (desc.contains('PLATINUM')) return 'PLATINUM ITEMS';
      if (desc.contains('DIAMOND')) return 'DIAMOND ITEMS';

      if (desc.contains('RING')) return 'RINGS';
      if (desc.contains('CHAIN') || desc.contains('NECKLACE')) {
        return 'CHAINS & NECKLACES';
      }
      if (desc.contains('BANGLE') || desc.contains('BRACELET')) {
        return 'BANGLES & BRACELETS';
      }
      if (desc.contains('EARRING')) return 'EARRINGS';
      if (desc.contains('PENDANT')) return 'PENDANTS';
    }

    return item.ornamentId ?? 'OTHERS';
  }

  List<TableRow> buildRows(BuildContext context) {
    List<CombinedValue>? combinedValues =
        controller
            .stockAndStatmentValueReportResponseModel
            .value
            .data
            ?.combinedValues;

    if (combinedValues == null || combinedValues.isEmpty) {
      return [];
    }

    List<TableRow> rows = [];

    if (controller.isGroupView.value) {
      Map<String, List<CombinedValue>> groupedData = {};
      for (var item in combinedValues) {
        String groupKey = _getGroupKeyFromItem(item);

        if (!groupedData.containsKey(groupKey)) {
          groupedData[groupKey] = [];
        }
        groupedData[groupKey]?.add(item);
      }

      var sortedKeys = groupedData.keys.toList()..sort();

      for (var groupName in sortedKeys) {
        var group = groupedData[groupName]!;

        rows.add(
          TableRow(
            children: List.generate(
              controller.subHeader.length,
              (index) => TableCell(
                child:
                    index == 0
                        ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                _formatGroupName(groupName),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${group.length} items',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : const SizedBox(),
              ),
            ),
          ),
        );

        for (var item in group) {
          rows.add(createItemRow(item));
        }

        rows.add(calculateGroupTotalRow(group));
      }
    } else {
      for (var item in combinedValues) {
        rows.add(createItemRow(item));
      }

      rows.add(calculateOverallTotalRow(combinedValues));
    }

    return rows;
  }

  // Keep all the remaining helper methods unchanged from the original implementation
  TableRow createItemRow(CombinedValue item) {
    List<String> row = [
      item.code ?? '',
      item.description ?? '',
      formatQuantity(item.openingQt),
      item.openingNetWeight ?? '0.000',
    ];

    if (controller.inclusiveGrossWeight) {
      row.add(item.openingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(item.openingAmount ?? '0.000');
    }

    row.add(formatQuantity(item.inwardQt));
    row.add(item.inwardNetWeight ?? '0.000');

    if (controller.inclusiveGrossWeight) {
      row.add(item.inwardGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(item.inwardAmount ?? '0.000');
    }

    row.add(formatQuantity(item.outwardQt));
    row.add(item.outwardNetWeight ?? '0.000');

    if (controller.inclusiveGrossWeight) {
      row.add(item.outwardGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(item.outwardAmount ?? '0.000');
    }

    row.add(formatQuantity(item.closingQt));
    row.add(item.closingNetWeight ?? '0.000');

    if (controller.inclusiveGrossWeight) {
      row.add(item.closingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(item.closingAmount ?? '0.000');
    }

    return buildTableRow(row);
  }

  String formatQuantity(String? value) {
    if (value == null || value.isEmpty) return '0';
    double? numValue = double.tryParse(value);
    if (numValue != null) {
      return numValue.round().toString();
    }
    return '0';
  }

  TableRow calculateGroupTotalRow(List<CombinedValue> group) {
    List<double> totals = List.filled(controller.subHeader.length, 0.0);
    totals[0] = 0;
    totals[1] = 0;

    for (var item in group) {
      int offset = 2;

      addValueToTotals(totals, offset, item.openingQt);
      addValueToTotals(totals, offset + 1, item.openingNetWeight);
      offset += 2;

      if (controller.inclusiveGrossWeight) {
        addValueToTotals(totals, offset, item.openingGrossWeight);
        offset++;
      }
      if (controller.inclusiveAmount) {
        addValueToTotals(totals, offset, item.openingAmount);
        offset++;
      }

      addValueToTotals(totals, offset, item.inwardQt);
      addValueToTotals(totals, offset + 1, item.inwardNetWeight);
      offset += 2;

      if (controller.inclusiveGrossWeight) {
        addValueToTotals(totals, offset, item.inwardGrossWeight);
        offset++;
      }
      if (controller.inclusiveAmount) {
        addValueToTotals(totals, offset, item.inwardAmount);
        offset++;
      }

      addValueToTotals(totals, offset, item.outwardQt);
      addValueToTotals(totals, offset + 1, item.outwardNetWeight);
      offset += 2;

      if (controller.inclusiveGrossWeight) {
        addValueToTotals(totals, offset, item.outwardGrossWeight);
        offset++;
      }
      if (controller.inclusiveAmount) {
        addValueToTotals(totals, offset, item.outwardAmount);
        offset++;
      }

      addValueToTotals(totals, offset, item.closingQt);
      addValueToTotals(totals, offset + 1, item.closingNetWeight);
      offset += 2;

      if (controller.inclusiveGrossWeight) {
        addValueToTotals(totals, offset, item.closingGrossWeight);
        offset++;
      }
      if (controller.inclusiveAmount) {
        addValueToTotals(totals, offset, item.closingAmount);
        offset++;
      }
    }

    List<String> totalStrings =
        totals.asMap().entries.map((entry) {
          int i = entry.key;
          double value = entry.value;

          if (i == 0) return 'Total';
          if (i == 1) return '';

          int basicColCount = 2;
          int sectionColCount =
              2 +
              (controller.inclusiveGrossWeight ? 1 : 0) +
              (controller.inclusiveAmount ? 1 : 0);

          if (i >= basicColCount) {
            int positionAfterBasicCols = i - basicColCount;
            int positionInSection = positionAfterBasicCols % sectionColCount;

            if (positionInSection == 0) {
              return value.round().toString();
            }
          }

          return value.toStringAsFixed(3);
        }).toList();

    return buildTotalRow(totalStrings, isGroupTotal: true);
  }

  TableRow calculateOverallTotalRow(List<CombinedValue> allItems) {
    return calculateGroupTotalRow(allItems);
  }

  void addValueToTotals(List<double> totals, int index, String? value) {
    if (index < totals.length && value != null) {
      double? numValue = double.tryParse(value);
      if (numValue != null) {
        totals[index] += numValue;
      }
    }
  }

  TableRow buildTableRow(List<dynamic> rowData) {
    int basicColCount = 2;
    int sectionColCount =
        2 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);

    List<int> sectionEndIndices = [];
    sectionEndIndices.add(1);

    int currentIndex = basicColCount - 1;
    for (int i = 0; i < 4; i++) {
      currentIndex += sectionColCount;
      sectionEndIndices.add(currentIndex);
    }

    List<Widget> cells =
        rowData.asMap().entries.map((entry) {
          // int i = entry.key;
          dynamic cellContent = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Tooltip(
                          message: cellContent.toString(),
                          child: CustomText(
                            text: cellContent.toString(),
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomDashedLineWidget(width: Get.width),
              ],
            ),
          );
        }).toList();

    return TableRow(children: cells);
  }

  TableRow buildTotalRow(List<String> totals, {bool isGroupTotal = false}) {
    int basicColCount = 2;
    int sectionColCount =
        2 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);

    List<int> sectionEndIndices = [];
    sectionEndIndices.add(1);

    int currentIndex = basicColCount - 1;
    for (int i = 0; i < 4; i++) {
      currentIndex += sectionColCount;
      sectionEndIndices.add(currentIndex);
    }

    Color totalBackgroundColor = greenColor;

    return TableRow(
      children:
          totals.asMap().entries.map((entry) {
            int i = entry.key;
            String total = entry.value;

            bool isLastInSection = sectionEndIndices.contains(i);
            bool shouldAddMargin = isLastInSection && i != 0;

            String displayText = total.isEmpty ? '' : (i > 1 ? total : total);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            margin: EdgeInsets.only(
                              right: shouldAddMargin ? 12.0 : 0.0,
                            ),
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: totalBackgroundColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Tooltip(
                                    message: displayText,
                                    child: CustomText(
                                      text: displayText,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
