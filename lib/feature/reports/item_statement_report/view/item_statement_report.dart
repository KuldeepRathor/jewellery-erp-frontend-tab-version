import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/view/widgets/item_statement_report_basic_filter_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/view_model/item_statement_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_reports_table.dart';

import '../model/item_statement_report_model.dart';

class ItemStatementReport extends GetView<ItemStatementReportViewModel> {
  const ItemStatementReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: GetBuilder<ItemStatementReportViewModel>(
        builder: (_) {
          return FocusScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: 'Item Statement Report',
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
                        itemStatementReportTable(),
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
          width: getDeviceWidth(context) * .975,
          child: Row(
            children: [
              const ItemStatementReportFilterWidget(),

              const Spacer(),
              Row(
                children: <Widget>[
                  const Text(
                    'Display By: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:
                            controller.isWeightGroupView.value
                                ? 'Weight Group'
                                : 'Stock Head',
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontFamily: 'Satoshi',
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.isWeightGroupView.value =
                                newValue == 'Weight Group';
                            controller.update();
                          }
                        },
                        items:
                            <String>[
                              'Stock Head',
                              'Weight Group',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   width: getDeviceWidth(context) * .02,
              // ),
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

  Widget itemStatementReportTable() {
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
                  child: Row(
                    children: [
                      const Text(
                        "Item Statement Report ",
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
              ],
            ),
            Expanded(child: buildItemStatementReport()),
          ],
        ),
      ),
    );
  }

  Widget buildItemStatementReport() {
    return GetBuilder<ItemStatementReportViewModel>(
      builder: (context) {
        return Obx(() {
          final apiStatus =
              controller.itemStatementReportResponseModel.value.status;
          if (apiStatus == Status.COMPLETED) {
            return CustomTableReportWidget(
              headers: [buildTableHeaders()],
              columnWidthsHeaders: controller.columnWidthsHeader,
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
                  columnWidthsHeaders: controller.columnWidthsHeader,
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
                  columnWidthsHeaders: controller.columnWidthsHeader,
                  subHeaders: [buildTableSubHeaders()],
                  columnWidths: controller.columnWidths,
                  rows: const [],
                  addSizedBox: false,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      controller
                              .itemStatementReportResponseModel
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
                  controller.itemStatementReportResponseModel.value.message ??
                      "Something went wrong",
                ),
              ),
            );
          }
        });
      },
    );
  }

  TableRow buildTableHeaders() {
    return TableRow(
      children: List.generate(controller.headers.length, (i) {
        // Only add margin to columns other than the "Item" column (index 1)
        // This ensures Code and Item are grouped together without spacing
        bool shouldAddMargin = i != 1;

        return Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Add right margin to all columns except "Item" (index 1)
          margin: EdgeInsets.only(right: shouldAddMargin ? 12 : 0),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomText(
                  text: controller.headers[i],
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  TableRow buildTableSubHeaders() {
    // Calculate column counts for each section based on the current state
    int basicColCount = 2; // "Code" and "Item" columns
    int sectionColCount =
        2 + // "Qty" and "Net Weight"
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);

    // Define the section boundaries
    List<int> sectionEndIndices = [];
    List<int> sectionStartIndices = [];

    // First section ends at "Item" (index 1)
    sectionEndIndices.add(1); // End of basic columns (0-1)
    sectionStartIndices.add(0); // Start of first section (Code)

    // Add end indices for each section
    int currentIndex = basicColCount - 1; // Start after basic columns

    // Opening section
    sectionStartIndices.add(currentIndex + 1); // Start of Opening section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Inward section
    sectionStartIndices.add(currentIndex + 1); // Start of Inward section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Outward section
    sectionStartIndices.add(currentIndex + 1); // Start of Outward section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Issue section
    sectionStartIndices.add(currentIndex + 1); // Start of Issue section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Difference section
    sectionStartIndices.add(currentIndex + 1); // Start of Difference section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Closing section
    sectionStartIndices.add(currentIndex + 1); // Start of Closing section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Stock Closing section
    sectionStartIndices.add(currentIndex + 1); // Start of Stock Closing section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    return TableRow(
      children: List.generate(controller.subHeader.length, (i) {
        // Check if this is the first or last column in a section
        bool isFirstInSection = sectionStartIndices.contains(i);
        bool isLastInSection = sectionEndIndices.contains(i);

        // Don't add margin between "Code" and "Item" columns
        bool shouldAddMargin = isLastInSection && i != 0;

        // Determine the appropriate border radius based on position
        BorderRadius borderRadius;
        if (isFirstInSection && isLastInSection) {
          // Both first and last in section (single column section)
          borderRadius = BorderRadius.circular(8);
        } else if (isFirstInSection) {
          // First column in section
          borderRadius = const BorderRadius.only(
            // topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          );
        } else if (isLastInSection) {
          // Last column in section
          borderRadius = const BorderRadius.only(
            // topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          );
        } else {
          // Middle column in section (no border radius)
          borderRadius = BorderRadius.zero;
        }

        return Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Apply right margin if it's the last column in a section, BUT NOT for "Code" column
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

  List<TableRow> buildRows(BuildContext context) {
    List<ItemValue>? itemValues =
        controller.itemStatementReportResponseModel.value.data?.values;

    if (itemValues == null || itemValues.isEmpty) {
      return [];
    }

    // Group data by counter_name
    Map<String, List<ItemValue>> groupedByCounter = {};
    for (var item in itemValues) {
      String counterName = item.counterName ?? "";
      if (!groupedByCounter.containsKey(counterName)) {
        groupedByCounter[counterName] = [];
      }
      groupedByCounter[counterName]?.add(item);
    }

    List<TableRow> rows = [];

    groupedByCounter.forEach((counterName, group) {
      // Add group header
      rows.add(
        TableRow(
          children: List.generate(
            controller.subHeader.length,
            (index) => TableCell(
              child:
                  index == 0
                      ? Tooltip(
                        message: counterName,
                        child: Text(
                          counterName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : const SizedBox(),
            ),
          ),
        ),
      );

      bool showWeightGroup = controller.isWeightGroupView.value;

      for (var itemValue in group) {
        if (itemValue.stockHeads == null) continue;

        for (var stockHead in itemValue.stockHeads!) {
          // For Weight Group view
          if (showWeightGroup) {
            // Add a stock head row as a subheader
            // rows.add(
            //   TableRow(
            //     children: List.generate(
            //       controller.subHeader.length,
            //       (index) => TableCell(
            //         child: index == 1
            //             ? Padding(
            //                 padding:
            //                     const EdgeInsets.symmetric(vertical: 8.0),
            //                 child: Text(
            //                   stockHead.stockHeadName ?? '',
            //                   style: const TextStyle(
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //               )
            //             : const SizedBox(),
            //       ),
            //     ),
            //   ),
            // );

            // Process weight groups (tagging codes)
            if (stockHead.taggingCodes != null) {
              for (var taggingCode in stockHead.taggingCodes!) {
                final isHideNullEnabled =
                    controller.filterController.selectedOther.value != null;

                if (isHideNullEnabled) {
                  final openingQty =
                      double.tryParse(taggingCode.openingQuantity ?? "0") ?? 0;

                  if (openingQty == 0) {
                    continue; // SKIP ROW
                  }
                }
                rows.add(
                  createWeightGroupRow(
                    taggingCode,
                    stockHead.weightGroupName ?? stockHead.stockHeadName ?? '',
                  ),
                );
              }
            }

            // Add stock head total after all weight groups
            if (stockHead.total != null) {
              rows.add(createStockHeadTotalRow(stockHead.total!));
            }
          } else {
            // For Stock Head view - process each stock head
            if (stockHead.total == null) continue;

            final isHideNullEnabled =
                controller.filterController.selectedOther.value != null;

            if (isHideNullEnabled) {
              final openingQty =
                  double.tryParse(stockHead.total!.openingQuantity ?? "0") ?? 0;

              if (openingQty == 0) {
                continue; // Skip Row
              }
            }

            rows.add(
              createStockHeadRow(
                stockHead.total!,
                stockHead.stockHeadName ?? '',
                stockHead.stockHeadCode ?? '',
              ),
            );
          }
        }
      }

      // Add totals row for the counter group
      rows.add(calculateTotalsRow(group, showWeightGroup));
    });

    return rows;
  }

  String formatQuantity(String? value) {
    if (value == null || value.isEmpty) return '0';

    // Parse the string to double, then round to integer and convert back to string
    double? numValue = double.tryParse(value);
    if (numValue != null) {
      return numValue.round().toString();
    }
    return '0';
  }

  // Helper method for creating a weight group row
  TableRow createWeightGroupRow(Total taggingCode, String weightGroupName) {
    // Initialize row data with tagging code and leave item empty
    List<String> row = [
      taggingCode.taggingCode ?? '', // Code column shows tagging_code

      weightGroupName, // Item column is blank for weight groups
    ];

    // Add Opening columns
    row.add(formatQuantity(taggingCode.openingQuantity));
    row.add(taggingCode.openingNetWeight ?? '0.000');

    // Add conditional Opening columns
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.openingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.openingAmount ?? '0.000');
    }

    // Add Inward columns
    row.add(formatQuantity(taggingCode.inwardQt));
    row.add(taggingCode.inwardNetWeight ?? '0.000');

    // Add conditional Inward columns
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.inwardGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.inwardAmount ?? '0.000');
    }

    // Add Outward columns
    row.add(formatQuantity(taggingCode.outwardQt));
    row.add(taggingCode.outwardNetWeight ?? '0.000');

    // Add conditional Outward columns
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.outwardGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.outwardAmount ?? '0.000');
    }

    // Add Issue columns
    row.add(formatQuantity(taggingCode.outwardStockIssueQuantity));
    row.add(taggingCode.outwardStockIssueNetWeight ?? '0.000');
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.outwardStockIssueGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.outwardStockIssueAmount ?? '0.000');
    }

    // Add Difference columns
    row.add('0'); // Difference Qty
    row.add(taggingCode.diffNetWeight ?? '0.000');
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.diffGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add('0.000');
    }

    // Add Closing columns
    row.add(formatQuantity(taggingCode.closingQt));
    row.add(taggingCode.closingNetWeight ?? '0.000');

    // Add conditional Closing columns
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.closingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.closingAmount ?? '0.000');
    }

    // Add Stock Closing columns
    row.add(formatQuantity(taggingCode.closingQt));
    row.add(taggingCode.closingNetWeight ?? '0.000');

    // Add conditional Stock Closing columns
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.closingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.closingAmount ?? '0.000');
    }

    return buildTableRow(row);
  }

  // Helper method to create a stock head total row after weight groups
  TableRow createStockHeadTotalRow(Total stockHeadTotal) {
    List<String> row = [
      "Total", // Code column shows "Total"
      "", // Item column is blank
    ];

    // Add Opening columns
    row.add(formatQuantity(stockHeadTotal.openingQuantity));
    row.add(stockHeadTotal.openingNetWeight ?? '0.000');

    // Add conditional Opening columns
    if (controller.inclusiveGrossWeight) {
      row.add(stockHeadTotal.openingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(stockHeadTotal.openingAmount ?? '0.000');
    }

    // Add Inward columns
    row.add(formatQuantity(stockHeadTotal.inwardQt));
    row.add(stockHeadTotal.inwardNetWeight ?? '0.000');

    // Add conditional Inward columns
    if (controller.inclusiveGrossWeight) {
      row.add(stockHeadTotal.inwardGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(stockHeadTotal.inwardAmount ?? '0.000');
    }

    // Add Outward columns
    row.add(formatQuantity(stockHeadTotal.outwardQt));
    row.add(stockHeadTotal.outwardNetWeight ?? '0.000');

    // Add conditional Outward columns
    if (controller.inclusiveGrossWeight) {
      row.add(stockHeadTotal.outwardGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(stockHeadTotal.outwardAmount ?? '0.000');
    }

    // Add Issue columns
    row.add(formatQuantity(stockHeadTotal.outwardStockIssueQuantity));
    row.add(stockHeadTotal.outwardStockIssueNetWeight ?? '0.000');
    if (controller.inclusiveGrossWeight) {
      row.add(stockHeadTotal.outwardStockIssueGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(stockHeadTotal.outwardStockIssueAmount ?? '0.000');
    }

    // Add Difference columns
    row.add('0'); // Difference Qty
    row.add(stockHeadTotal.diffNetWeight ?? '0.000');
    if (controller.inclusiveGrossWeight) {
      row.add(stockHeadTotal.diffGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add('0.000');
    }

    // Add Closing columns
    row.add(formatQuantity(stockHeadTotal.closingQt));
    row.add(stockHeadTotal.closingNetWeight ?? '0.000');

    // Add conditional Closing columns
    if (controller.inclusiveGrossWeight) {
      row.add(stockHeadTotal.closingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(stockHeadTotal.closingAmount ?? '0.000');
    }

    // Add Stock Closing columns
    row.add(formatQuantity(stockHeadTotal.closingQt));
    row.add(stockHeadTotal.closingNetWeight ?? '0.000');

    // Add conditional Stock Closing columns
    if (controller.inclusiveGrossWeight) {
      row.add(stockHeadTotal.closingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(stockHeadTotal.closingAmount ?? '0.000');
    }

    return buildTotalRow(
      row,
      isStockHeadTotal: true,
    ); // Use the buildTotalRow method to style it as a total row
  }

  // Create a row for Stock Head view
  TableRow createStockHeadRow(
    Total total,
    String stockHeadName,
    String stockHeadCode,
  ) {
    // Initialize row data with blank code and stock head name
    List<String> row = [
      stockHeadCode, // Code column is blank for Stock Head view
      stockHeadName, // Item column shows stock head name
    ];

    // Add Opening columns
    row.add(formatQuantity(total.openingQuantity));
    row.add(total.openingNetWeight ?? '0.000');

    // Add conditional Opening columns
    if (controller.inclusiveGrossWeight) {
      row.add(total.openingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(total.openingAmount ?? '0.000');
    }

    // Add Inward columns
    row.add(formatQuantity(total.inwardQt));
    row.add(total.inwardNetWeight ?? '0.000');

    // Add conditional Inward columns
    if (controller.inclusiveGrossWeight) {
      row.add(total.inwardGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(total.inwardAmount ?? '0.000');
    }

    // Add Outward columns
    row.add(formatQuantity(total.outwardQt));
    row.add(total.outwardNetWeight ?? '0.000');

    // Add conditional Outward columns
    if (controller.inclusiveGrossWeight) {
      row.add(total.outwardGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(total.outwardAmount ?? '0.000');
    }

    // Add Issue columns (placeholders since they're not in the data)
    row.add(formatQuantity(total.outwardStockIssueQuantity)); // Issue Qty
    row.add(total.outwardStockIssueNetWeight ?? '0.000'); // Issue Net Weight
    if (controller.inclusiveGrossWeight) {
      row.add(
        total.outwardStockIssueGrossWeight ?? '0.000',
      ); // Issue Gross Weight
    }
    if (controller.inclusiveAmount) {
      row.add(total.outwardStockIssueAmount ?? '0.000'); // Issue Amount
    }

    // Add Difference columns (placeholders since they're not in the data)
    row.add('0'); // Difference Qty
    row.add(total.diffNetWeight ?? "0"); // Difference Net Weight
    if (controller.inclusiveGrossWeight) {
      row.add(total.diffGrossWeight ?? "0.000"); // Difference Gross Weight
    }
    if (controller.inclusiveAmount) {
      row.add('0.000'); // Difference Amount
    }

    // Add Closing columns
    row.add(formatQuantity(total.closingQt));
    row.add(total.closingNetWeight ?? '0.000');

    // Add conditional Closing columns
    if (controller.inclusiveGrossWeight) {
      row.add(total.closingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(total.closingAmount ?? '0.000');
    }

    // Add Stock Closing columns (same as Closing)
    row.add(formatQuantity(total.closingQt));
    row.add(total.closingNetWeight ?? '0.000');

    // Add conditional Stock Closing columns
    if (controller.inclusiveGrossWeight) {
      row.add(total.closingGrossWeight ?? '0.000');
    }
    if (controller.inclusiveAmount) {
      row.add(total.closingAmount ?? '0.000');
    }

    return buildTableRow(row);
  }

  // Calculate totals for a group
  TableRow calculateTotalsRow(
    List<ItemValue> groupItems,
    bool showWeightGroup,
  ) {
    // Initialize totals with zeros
    List<double> totals = List.filled(controller.subHeader.length, 0.0);

    // First two columns are text fields
    totals[0] = 0;
    totals[1] = 0;

    if (showWeightGroup) {
      // Sum up all tagging codes across stock heads
      for (var itemValue in groupItems) {
        if (itemValue.stockHeads == null) continue;

        for (var stockHead in itemValue.stockHeads!) {
          if (stockHead.taggingCodes == null) continue;

          for (var taggingCode in stockHead.taggingCodes!) {
            // Sum Opening columns
            addValueToTotals(totals, 2, taggingCode.openingQuantity);
            addValueToTotals(totals, 3, taggingCode.openingNetWeight);

            // Add conditional Opening columns
            int offset = 4;
            if (controller.inclusiveGrossWeight) {
              addValueToTotals(totals, offset, taggingCode.openingGrossWeight);
              offset++;
            }
            if (controller.inclusiveAmount) {
              addValueToTotals(totals, offset, taggingCode.openingAmount);
              offset++;
            }

            // Sum Inward columns
            addValueToTotals(totals, offset, taggingCode.inwardQt);
            addValueToTotals(totals, offset + 1, taggingCode.inwardNetWeight);

            // Add conditional Inward columns
            int inwardOffset = offset + 2;
            if (controller.inclusiveGrossWeight) {
              addValueToTotals(
                totals,
                inwardOffset,
                taggingCode.inwardGrossWeight,
              );
              inwardOffset++;
            }
            if (controller.inclusiveAmount) {
              addValueToTotals(totals, inwardOffset, taggingCode.inwardAmount);
              inwardOffset++;
            }

            // Sum Outward columns
            addValueToTotals(totals, inwardOffset, taggingCode.outwardQt);
            addValueToTotals(
              totals,
              inwardOffset + 1,
              taggingCode.outwardNetWeight,
            );

            // Add conditional Outward columns
            int outwardOffset = inwardOffset + 2;
            if (controller.inclusiveGrossWeight) {
              addValueToTotals(
                totals,
                outwardOffset,
                taggingCode.outwardGrossWeight,
              );
              outwardOffset++;
            }
            if (controller.inclusiveAmount) {
              addValueToTotals(
                totals,
                outwardOffset,
                taggingCode.outwardAmount,
              );
              outwardOffset++;
            }

            // Skip Issue and Difference columns (all zeros)
            int skipCols = 4;
            if (controller.inclusiveGrossWeight) skipCols += 2;
            if (controller.inclusiveAmount) skipCols += 2;

            // Sum Closing columns
            int closingOffset = outwardOffset + skipCols;
            addValueToTotals(totals, closingOffset, taggingCode.closingQt);
            addValueToTotals(
              totals,
              closingOffset + 1,
              taggingCode.closingNetWeight,
            );

            // Add conditional Closing columns
            int closingCondOffset = closingOffset + 2;
            if (controller.inclusiveGrossWeight) {
              addValueToTotals(
                totals,
                closingCondOffset,
                taggingCode.closingGrossWeight,
              );
              closingCondOffset++;
            }
            if (controller.inclusiveAmount) {
              addValueToTotals(
                totals,
                closingCondOffset,
                taggingCode.closingAmount,
              );
              closingCondOffset++;
            }

            // Sum Stock Closing columns (same values as Closing)
            addValueToTotals(totals, closingCondOffset, taggingCode.closingQt);
            addValueToTotals(
              totals,
              closingCondOffset + 1,
              taggingCode.closingNetWeight,
            );

            // Add conditional Stock Closing columns
            int stockClosingOffset = closingCondOffset + 2;
            if (controller.inclusiveGrossWeight) {
              addValueToTotals(
                totals,
                stockClosingOffset,
                taggingCode.closingGrossWeight,
              );
              stockClosingOffset++;
            }
            if (controller.inclusiveAmount) {
              addValueToTotals(
                totals,
                stockClosingOffset,
                taggingCode.closingAmount,
              );
            }
          }
        }
      }
    } else {
      // Sum up all stock head totals
      for (var itemValue in groupItems) {
        if (itemValue.stockHeads == null) continue;

        for (var stockHead in itemValue.stockHeads!) {
          if (stockHead.total == null) continue;

          Total total = stockHead.total!;

          // Sum Opening columns
          addValueToTotals(totals, 2, total.openingQuantity);
          addValueToTotals(totals, 3, total.openingNetWeight);

          // Add conditional Opening columns
          int offset = 4;
          if (controller.inclusiveGrossWeight) {
            addValueToTotals(totals, offset, total.openingGrossWeight);
            offset++;
          }
          if (controller.inclusiveAmount) {
            addValueToTotals(totals, offset, total.openingAmount);
            offset++;
          }

          // Sum Inward columns
          addValueToTotals(totals, offset, total.inwardQt);
          addValueToTotals(totals, offset + 1, total.inwardNetWeight);

          // Add conditional Inward columns
          int inwardOffset = offset + 2;
          if (controller.inclusiveGrossWeight) {
            addValueToTotals(totals, inwardOffset, total.inwardGrossWeight);
            inwardOffset++;
          }
          if (controller.inclusiveAmount) {
            addValueToTotals(totals, inwardOffset, total.inwardAmount);
            inwardOffset++;
          }

          // Sum Outward columns
          addValueToTotals(totals, inwardOffset, total.outwardQt);
          addValueToTotals(totals, inwardOffset + 1, total.outwardNetWeight);

          // Add conditional Outward columns
          int outwardOffset = inwardOffset + 2;
          if (controller.inclusiveGrossWeight) {
            addValueToTotals(totals, outwardOffset, total.outwardGrossWeight);
            outwardOffset++;
          }
          if (controller.inclusiveAmount) {
            addValueToTotals(totals, outwardOffset, total.outwardAmount);
            outwardOffset++;
          }

          // Skip Issue and Difference columns (all zeros)
          int skipCols = 4;
          if (controller.inclusiveGrossWeight) skipCols += 2;
          if (controller.inclusiveAmount) skipCols += 2;

          // Sum Closing columns
          int closingOffset = outwardOffset + skipCols;
          addValueToTotals(totals, closingOffset, total.closingQt);
          addValueToTotals(totals, closingOffset + 1, total.closingNetWeight);

          // Add conditional Closing columns
          int closingCondOffset = closingOffset + 2;
          if (controller.inclusiveGrossWeight) {
            addValueToTotals(
              totals,
              closingCondOffset,
              total.closingGrossWeight,
            );
            closingCondOffset++;
          }
          if (controller.inclusiveAmount) {
            addValueToTotals(totals, closingCondOffset, total.closingAmount);
            closingCondOffset++;
          }

          // Sum Stock Closing columns (same values as Closing)
          addValueToTotals(totals, closingCondOffset, total.closingQt);
          addValueToTotals(
            totals,
            closingCondOffset + 1,
            total.closingNetWeight,
          );

          // Add conditional Stock Closing columns
          int stockClosingOffset = closingCondOffset + 2;
          if (controller.inclusiveGrossWeight) {
            addValueToTotals(
              totals,
              stockClosingOffset,
              total.closingGrossWeight,
            );
            stockClosingOffset++;
          }
          if (controller.inclusiveAmount) {
            addValueToTotals(totals, stockClosingOffset, total.closingAmount);
          }
        }
      }
    }

    List<String> totalStrings =
        totals.asMap().entries.map((entry) {
          int i = entry.key;
          double value = entry.value;

          if (i == 0) return 'Total';
          if (i == 1) return '';

          // Calculate section boundaries dynamically
          int basicColCount = 2; // "Code" and "Item" columns
          int sectionColCount =
              2 + // "Qty" and "Net Weight"
              (controller.inclusiveGrossWeight ? 1 : 0) +
              (controller.inclusiveAmount ? 1 : 0);

          // If i is greater than the basic columns (Code and Item),
          // check if it's the first column in any section
          if (i >= basicColCount) {
            // Calculate the relative position within its section
            int positionAfterBasicCols = i - basicColCount;

            // In each section, the first column (index 0 within section) is always the quantity
            int positionInSection = positionAfterBasicCols % sectionColCount;

            // If this is the first column in any section after the basic columns,
            // it's a quantity column
            if (positionInSection == 0) {
              return value.round().toString();
            }
          }

          // For all other columns (weights, amounts), show decimal values
          return value.toStringAsFixed(3);
        }).toList();

    return buildTotalRow(totalStrings);
  }

  // Helper method to safely add string values to totals
  void addValueToTotals(List<double> totals, int index, String? value) {
    if (index < totals.length && value != null) {
      double? numValue = double.tryParse(value);
      if (numValue != null) {
        totals[index] += numValue;
      }
    }
  }

  // Helper method to create a row from stock head total
  TableRow createRowFromStockHeadTotal(
    Total total,
    String stockHeadName,
    String stockHeadCode,
  ) {
    List<String> row = [
      stockHeadCode, // Using stock head code as the "Code"
      stockHeadName, // Stock Head Name
      total.openingQuantity ?? '0',
      total.openingNetWeight ?? '0',
    ];

    // Add conditional columns for Opening
    if (controller.inclusiveGrossWeight) {
      row.add(total.openingGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(total.openingAmount ?? '0');
    }

    // Add Inward columns
    row.add(total.inwardQt ?? '0');
    row.add(total.inwardNetWeight ?? '0');

    // Add conditional columns for Inward
    if (controller.inclusiveGrossWeight) {
      row.add(total.inwardGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(total.inwardAmount ?? '0');
    }

    // Add Outward columns
    row.add(total.outwardQt ?? '0');
    row.add(total.outwardNetWeight ?? '0');

    // Add conditional columns for Outward
    if (controller.inclusiveGrossWeight) {
      row.add(total.outwardGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(total.outwardAmount ?? '0');
    }

    // Add Issue columns (placeholders)
    row.add('0'); // Issue Qty
    row.add('0'); // Issue Net Weight
    if (controller.inclusiveGrossWeight) {
      row.add('0'); // Issue Gross Weight
    }
    if (controller.inclusiveAmount) {
      row.add('0'); // Issue Amount
    }

    // Add Difference columns (placeholders)
    row.add('0'); // Difference Qty
    row.add('0'); // Difference Net Weight
    if (controller.inclusiveGrossWeight) {
      row.add('0'); // Difference Gross Weight
    }
    if (controller.inclusiveAmount) {
      row.add('0'); // Difference Amount
    }

    // Add Closing columns
    row.add(total.closingQt ?? '0');
    row.add(total.closingNetWeight ?? '0');

    // Add conditional columns for Closing
    if (controller.inclusiveGrossWeight) {
      row.add(total.closingGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(total.closingAmount ?? '0');
    }

    // Add Stock Closing columns (same as Closing)
    row.add(total.closingQt ?? '0');
    row.add(total.closingNetWeight ?? '0');

    // Add conditional columns for Stock Closing
    if (controller.inclusiveGrossWeight) {
      row.add(total.closingGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(total.closingAmount ?? '0');
    }

    return buildTableRow(row);
  }

  // Helper method to create a row from tagging code
  TableRow createRowFromTaggingCode(Total taggingCode, String stockHeadName) {
    List<String> row = [
      taggingCode.taggingCode ?? '',
      stockHeadName,
      taggingCode.openingQuantity ?? '0',
      taggingCode.openingNetWeight ?? '0',
    ];

    // Add conditional columns for Opening
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.openingGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.openingAmount ?? '0');
    }

    // Add Inward columns
    row.add(taggingCode.inwardQt ?? '0');
    row.add(taggingCode.inwardNetWeight ?? '0');

    // Add conditional columns for Inward
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.inwardGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.inwardAmount ?? '0');
    }

    // Add Outward columns
    row.add(taggingCode.outwardQt ?? '0');
    row.add(taggingCode.outwardNetWeight ?? '0');

    // Add conditional columns for Outward
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.outwardGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.outwardAmount ?? '0');
    }

    // Add remaining sections with placeholder values
    // Issue (Qty, Net Weight, and conditionals)
    row.add('0'); // Issue Qty
    row.add('0'); // Issue Net Weight
    if (controller.inclusiveGrossWeight) {
      row.add('0'); // Issue Gross Weight
    }
    if (controller.inclusiveAmount) {
      row.add('0'); // Issue Amount
    }

    // Difference (Qty, Net Weight, and conditionals)
    row.add('0'); // Difference Qty
    row.add('0'); // Difference Net Weight
    if (controller.inclusiveGrossWeight) {
      row.add('0'); // Difference Gross Weight
    }
    if (controller.inclusiveAmount) {
      row.add('0'); // Difference Amount
    }

    // Closing columns
    row.add(taggingCode.closingQt ?? '0');
    row.add(taggingCode.closingNetWeight ?? '0');

    // Add conditional columns for Closing
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.closingGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.closingAmount ?? '0');
    }

    // Stock Closing (usually same as Closing)
    row.add(taggingCode.closingQt ?? '0');
    row.add(taggingCode.closingNetWeight ?? '0');

    // Add conditional columns for Stock Closing
    if (controller.inclusiveGrossWeight) {
      row.add(taggingCode.closingGrossWeight ?? '0');
    }
    if (controller.inclusiveAmount) {
      row.add(taggingCode.closingAmount ?? '0');
    }

    return buildTableRow(row);
  }

  // Helper methods to calculate column indices based on the current state
  int getInwardQtyIndex() {
    // Base index is 6, but adjust if inclusiveGrossWeight and/or inclusiveAmount are true
    return 4 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);
  }

  int getOutwardQtyIndex() {
    // Base index is 8, but adjust based on additional columns
    return getInwardQtyIndex() +
        2 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);
  }

  int getIssueQtyIndex() {
    return getOutwardQtyIndex() +
        2 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);
  }

  int getDifferenceQtyIndex() {
    return getIssueQtyIndex() +
        2 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);
  }

  int getClosingQtyIndex() {
    return getDifferenceQtyIndex() +
        2 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);
  }

  int getStockClosingQtyIndex() {
    return getClosingQtyIndex() +
        2 +
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);
  }

  TableRow buildTableRow(List<dynamic> rowData) {
    // Calculate section boundaries similar to buildTableSubHeaders
    int basicColCount = 2; // "Code" and "Item" columns
    int sectionColCount =
        2 + // "Qty" and "Net Weight"
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);

    // Define the section boundaries
    List<int> sectionEndIndices = [];

    // First section ends at "Item" (index 1)
    sectionEndIndices.add(1); // End of basic columns (0-1)

    // Add end indices for each section
    int currentIndex = basicColCount - 1; // Start after basic columns

    // Opening section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Inward section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Outward section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Issue section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Difference section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Closing section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Stock Closing section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    List<Widget> cells =
        rowData.asMap().entries.map((entry) {
          int i = entry.key;
          dynamic cellContent = entry.value;

          // Check if this is the last column in a section
          // bool isLastInSection =
          sectionEndIndices.contains(i);

          // Don't add margin between "Code" and "Item" columns
          // bool shouldAddMargin = isLastInSection && i != 0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            // Add right margin to the container if necessary
            // margin: EdgeInsets.only(right: shouldAddMargin ? 12.0 : 0),
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

  TableRow buildTotalRow(List<String> totals, {bool isStockHeadTotal = false}) {
    // Calculate section boundaries similar to buildTableSubHeaders
    int basicColCount = 2; // "Code" and "Item" columns
    int sectionColCount =
        2 + // "Qty" and "Net Weight"
        (controller.inclusiveGrossWeight ? 1 : 0) +
        (controller.inclusiveAmount ? 1 : 0);

    // Define the section boundaries
    List<int> sectionEndIndices = [];

    // First section ends at "Item" (index 1)
    sectionEndIndices.add(1); // End of basic columns (0-1)

    // Add end indices for each section
    int currentIndex = basicColCount - 1; // Start after basic columns

    // Opening section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Inward section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Outward section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Issue section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Difference section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Closing section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Stock Closing section
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Use lightGreenColor for stock head totals and greenColor for counter totals
    Color totalBackgroundColor =
        isStockHeadTotal ? lightGreenColor : greenColor;

    return TableRow(
      children:
          totals.asMap().entries.map((entry) {
            int i = entry.key;
            String total = entry.value;

            // Check if this is the last column in a section
            bool isLastInSection = sectionEndIndices.contains(i);

            // Don't add margin between "Code" and "Item" columns
            bool shouldAddMargin = isLastInSection && i != 0;

            // For empty values (especially for Item column), don't show "0.00"
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
                              // Use different background colors based on row type
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
                                      // Use black text for light green background, white for dark green
                                      color:
                                          isStockHeadTotal
                                              ? greenColor
                                              : Colors.white,
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
