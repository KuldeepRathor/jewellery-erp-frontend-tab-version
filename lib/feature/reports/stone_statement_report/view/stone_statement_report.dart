import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stone_statement_report/model/stone_statement_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stone_statement_report/view/widgets/stone_statement_report_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stone_statement_report/view_model/stone_statement_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_reports_table.dart';

class StoneStatementReport extends GetView<StoneStatementReportViewModel> {
  const StoneStatementReport({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoneStatementReportViewModel());

    return Scaffold(
      backgroundColor: grey1,
      body: GetBuilder<StoneStatementReportViewModel>(
        init: controller,
        builder: (_) {
          return FocusScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: 'Stone Statement Report',
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
                        stoneStatementReportTable(),
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
              const StoneStatementReportFilterWidget(),
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

  Widget stoneStatementReportTable() {
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Stone Statement Report",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildStoneStatementReport(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStoneStatementReport() {
    return GetBuilder<StoneStatementReportViewModel>(
      builder: (context) {
        return Obx(() {
          final apiStatus =
              controller.stoneStatementReportResponseModel.value.status;
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
                              .stoneStatementReportResponseModel
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
                  controller.stoneStatementReportResponseModel.value.message ??
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
        // Only add margin to columns other than the "Stone" column (index 1)
        bool shouldAddMargin = i != 1;

        return Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
    int basicColCount = 2; // "Code" and "Stone" columns
    int sectionColCount =
        2 + // "Pcs" and "Weight"
        (controller.inclusiveAmount ? 1 : 0);

    // Define the section boundaries
    List<int> sectionEndIndices = [];
    List<int> sectionStartIndices = [];

    // First section ends at "Stone" (index 1)
    sectionEndIndices.add(1); // End of basic columns (0-1)
    sectionStartIndices.add(0); // Start of first section (Code)

    // Add end indices for each section
    int currentIndex = basicColCount - 1; // Start after basic columns

    // Opening section
    sectionStartIndices.add(currentIndex + 1);
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Inward section
    sectionStartIndices.add(currentIndex + 1);
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Outward section
    sectionStartIndices.add(currentIndex + 1);
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Issue section
    sectionStartIndices.add(currentIndex + 1);
    currentIndex += sectionColCount;
    sectionEndIndices.add(currentIndex);

    // Closing section
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
              Flexible(
                child: CustomText(
                  text: controller.subHeader[i],
                  fontSize: 12, // Reduced font size to prevent overflow
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

  List<TableRow> buildRows(BuildContext context) {
    List<StoneStatementReportValue>? stoneValues =
        controller.stoneStatementReportResponseModel.value.data?.values;

    if (stoneValues == null || stoneValues.isEmpty) {
      return [];
    }

    List<TableRow> rows = [];

    // Add individual stone rows
    for (var stone in stoneValues) {
      rows.add(createStoneRow(stone));
    }

    // Add totals row
    rows.add(calculateTotalsRow(stoneValues));

    return rows;
  }

  TableRow createStoneRow(StoneStatementReportValue stone) {
    List<String> row = [
      stone.stoneCode ?? '', // Code
      stone.stoneName ?? '', // Stone Name
    ];

    // Add Opening columns
    row.add(controller.formatQuantity(stone.openingPieces));
    row.add(controller.formatWeight(stone.openingWeight));
    if (controller.inclusiveAmount) {
      row.add(controller.formatAmount(stone.openingAmount));
    }

    // Add Inward columns
    row.add(controller.formatQuantity(stone.inwardPieces));
    row.add(controller.formatWeight(stone.inwardWeight));
    if (controller.inclusiveAmount) {
      row.add(controller.formatAmount(stone.inwardAmount));
    }

    // Add Outward columns
    row.add(controller.formatQuantity(stone.outwardPieces));
    row.add(controller.formatWeight(stone.outwardWeight));
    if (controller.inclusiveAmount) {
      row.add(controller.formatAmount(stone.outwardAmount));
    }

    // Add Issue columns
    row.add(controller.formatQuantity(stone.stockIssuePieces));
    row.add(controller.formatWeight(stone.stockIssueWeight));
    if (controller.inclusiveAmount) {
      row.add(controller.formatAmount(stone.stockIssueAmount));
    }

    // Add Closing columns
    row.add(controller.formatQuantity(stone.closingPieces));
    row.add(controller.formatWeight(stone.closingWeight));
    if (controller.inclusiveAmount) {
      row.add(controller.formatAmount(stone.closingAmount));
    }

    return buildTableRow(row);
  }

  TableRow calculateTotalsRow(List<StoneStatementReportValue> stoneValues) {
    // Initialize totals
    int totalOpeningPieces = 0;
    double totalOpeningWeight = 0.0;
    double totalOpeningAmount = 0.0;
    int totalInwardPieces = 0;
    double totalInwardWeight = 0.0;
    double totalInwardAmount = 0.0;
    int totalOutwardPieces = 0;
    double totalOutwardWeight = 0.0;
    double totalOutwardAmount = 0.0;
    int totalIssuePieces = 0;
    double totalIssueWeight = 0.0;
    double totalIssueAmount = 0.0;
    int totalClosingPieces = 0;
    double totalClosingWeight = 0.0;
    double totalClosingAmount = 0.0;

    // Sum up values
    for (var stone in stoneValues) {
      totalOpeningPieces += stone.openingPieces ?? 0;
      totalOpeningWeight += double.tryParse(stone.openingWeight ?? '0') ?? 0;
      totalOpeningAmount += double.tryParse(stone.openingAmount ?? '0') ?? 0;

      totalInwardPieces += stone.inwardPieces ?? 0;
      totalInwardWeight += double.tryParse(stone.inwardWeight ?? '0') ?? 0;
      totalInwardAmount += double.tryParse(stone.inwardAmount ?? '0') ?? 0;

      totalOutwardPieces += stone.outwardPieces ?? 0;
      totalOutwardWeight += double.tryParse(stone.outwardWeight ?? '0') ?? 0;
      totalOutwardAmount += double.tryParse(stone.outwardAmount ?? '0') ?? 0;

      totalIssuePieces += stone.stockIssuePieces ?? 0;
      totalIssueWeight += double.tryParse(stone.stockIssueWeight ?? '0') ?? 0;
      totalIssueAmount += double.tryParse(stone.stockIssueAmount ?? '0') ?? 0;

      totalClosingPieces += stone.closingPieces ?? 0;
      totalClosingWeight += double.tryParse(stone.closingWeight ?? '0') ?? 0;
      totalClosingAmount += double.tryParse(stone.closingAmount ?? '0') ?? 0;
    }

    List<String> totalStrings = [
      'Total', // Code
      '', // Stone Name
    ];

    // Add Opening totals
    totalStrings.add(totalOpeningPieces.toString());
    totalStrings.add(totalOpeningWeight.toStringAsFixed(2));
    if (controller.inclusiveAmount) {
      totalStrings.add(totalOpeningAmount.toStringAsFixed(2));
    }

    // Add Inward totals
    totalStrings.add(totalInwardPieces.toString());
    totalStrings.add(totalInwardWeight.toStringAsFixed(2));
    if (controller.inclusiveAmount) {
      totalStrings.add(totalInwardAmount.toStringAsFixed(2));
    }

    // Add Outward totals
    totalStrings.add(totalOutwardPieces.toString());
    totalStrings.add(totalOutwardWeight.toStringAsFixed(2));
    if (controller.inclusiveAmount) {
      totalStrings.add(totalOutwardAmount.toStringAsFixed(2));
    }

    // Add Issue totals
    totalStrings.add(totalIssuePieces.toString());
    totalStrings.add(totalIssueWeight.toStringAsFixed(2));
    if (controller.inclusiveAmount) {
      totalStrings.add(totalIssueAmount.toStringAsFixed(2));
    }

    // Add Closing totals
    totalStrings.add(totalClosingPieces.toString());
    totalStrings.add(totalClosingWeight.toStringAsFixed(2));
    if (controller.inclusiveAmount) {
      totalStrings.add(totalClosingAmount.toStringAsFixed(2));
    }

    return buildTotalRow(totalStrings);
  }

  TableRow buildTableRow(List<dynamic> rowData) {
    // Calculate section boundaries
    int basicColCount = 2; // "Code" and "Stone" columns
    int sectionColCount = 2 + (controller.inclusiveAmount ? 1 : 0);

    List<int> sectionEndIndices = [];
    sectionEndIndices.add(1); // End of basic columns

    int currentIndex = basicColCount - 1;
    for (int i = 0; i < 5; i++) {
      // 5 sections: Opening, Inward, Outward, Issue, Closing
      currentIndex += sectionColCount;
      sectionEndIndices.add(currentIndex);
    }

    List<Widget> cells =
        rowData.asMap().entries.map((entry) {
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

  TableRow buildTotalRow(List<String> totals) {
    // Calculate section boundaries
    int basicColCount = 2;
    int sectionColCount = 2 + (controller.inclusiveAmount ? 1 : 0);

    List<int> sectionEndIndices = [];
    sectionEndIndices.add(1); // End of basic columns

    int currentIndex = basicColCount - 1;
    for (int i = 0; i < 5; i++) {
      // 5 sections
      currentIndex += sectionColCount;
      sectionEndIndices.add(currentIndex);
    }

    return TableRow(
      children:
          totals.asMap().entries.map((entry) {
            int i = entry.key;
            String total = entry.value;

            bool isLastInSection = sectionEndIndices.contains(i);
            bool shouldAddMargin = isLastInSection && i != 0;

            String displayText = total.isEmpty ? '' : total;

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
                            decoration: const BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.all(
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
