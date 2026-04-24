import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/model/sales_record_detail_report_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/view/detailed_sales_stone_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/view/widgets/detailed_sales_summary_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/view_model/detailed_sales_summary_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:svg_flutter/svg.dart';

class DetailedSalesSummaryPage extends StatefulWidget {
  const DetailedSalesSummaryPage({super.key});

  @override
  State<DetailedSalesSummaryPage> createState() =>
      _DetailedSalesSummaryPageState();
}

class _DetailedSalesSummaryPageState extends State<DetailedSalesSummaryPage> {
  final DetailedSalesSummaryController controller = Get.put(
    DetailedSalesSummaryController(),
  );
  // @override
  // void initState() {
  //   super.initState();
  //   controller.getSalesRecoedDetail();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(
            header: 'Sales Record Detail Report',
            wantBackButton: true,
            onBackButtonTap: () {
              Get.back();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSalesTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTable() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  "Sales Record Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                const DetailedSalesSummaryBasicFilterWidget(),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final apiStatus =
                    controller.salesRecordDetailReportResponse.value.status;

                if (apiStatus == Status.COMPLETED) {
                  final data =
                      controller.salesRecordDetailReportResponse.value.data;
                  if (data?.values?.isEmpty ?? true) {
                    return Center(
                      child: SvgPicture.asset(
                        'assets/svgs/error/no_records_found.svg',
                      ),
                    );
                  }

                  return _SynchronizedScrollTable(
                    controller: controller,
                    data: data!,
                    onShowStoneDetails: () => _showStoneDetailsDialog(data),
                    getCellContent: _getCellContent,
                  );
                } else if (apiStatus == Status.LOADING) {
                  return const Center(child: CircularProgressIndicator());
                } else if (apiStatus == Status.ERROR) {
                  return Center(
                    child: Text(
                      controller
                              .salesRecordDetailReportResponse
                              .value
                              .message ??
                          "Something went wrong",
                    ),
                  );
                }
                return const SizedBox();
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _showStoneDetailsDialog(SalesRecordDetailReportResponse data) {
    if (data.stoneData != null || data.stoneTotal != null) {
      Get.dialog(
        SalesRecordStoneDetailsDialog(
          stoneData: data.stoneData,
          stoneTotal: data.stoneTotal,
        ),
      );
    } else {
      Get.snackbar(
        'No Stone Data',
        'Stone details are not available for this report',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  String _getCellContent(
    SalesRecordDetailReportValue record,
    int cellIndex,
    int rowIndex,
  ) {
    switch (cellIndex) {
      case 0:
        return "${rowIndex + 1}";
      case 1:
        return record.invoiceDate?.toString().split(' ')[0] ?? '-';
      case 2:
        return record.invoiceNumber ?? '-';
      case 3:
        return "${record.code} - ${record.tagNumber}";
      case 4:
        return record.itemDescription ?? '-';
      case 5:
        return record.code ?? '-';
      case 6:
        return record.pieces?.toString() ?? '-';
      case 7:
        return record.grossWeight ?? '-';
      case 8:
        return record.netWeight ?? '-';
      case 9:
        return record.stoneWeightCarat ?? '-';
      case 10:
        return record.stoneAmount ?? '-';
      case 11:
        return record.oldGoldNettWeight ?? '-';
      case 12:
        return record.oldGoldGrossWeight ?? '-';
      case 13:
        return record.oldGoldAmount ?? '-';
      case 14:
        return record.weightDifference ?? '-';
      case 15:
        return record.receivedAmount ?? '-';
      case 16:
        return record.paymentMethodCash ?? '-';
      case 17:
        return record.paymentMethodCard ?? '-';
      case 18:
        return record.paymentMethodNeftRtgs ?? '-';
      case 19:
        return record.paymentMethodUpiImps ?? '-';
      case 20:
        return record.paymentMethodCheque ?? '-';
      default:
        return '-';
    }
  }
}

// Custom widget to synchronize scrolling between table and total row
class _SynchronizedScrollTable extends StatefulWidget {
  final DetailedSalesSummaryController controller;
  final SalesRecordDetailReportResponse data;
  final VoidCallback onShowStoneDetails;
  final String Function(SalesRecordDetailReportValue, int, int) getCellContent;

  const _SynchronizedScrollTable({
    required this.controller,
    required this.data,
    required this.onShowStoneDetails,
    required this.getCellContent,
  });

  @override
  State<_SynchronizedScrollTable> createState() =>
      _SynchronizedScrollTableState();
}

class _SynchronizedScrollTableState extends State<_SynchronizedScrollTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // This will capture scroll events from the LineWiseCustomTable
        // and apply them to our total row
        if (notification is ScrollUpdateNotification) {
          if (notification.metrics.axis == Axis.horizontal) {
            // Update the scroll position of the total row
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(notification.metrics.pixels);
            }
          }
        }
        return false;
      },
      child: Column(
        children: [
          Expanded(
            child: LineWiseCustomTable(
              headers: widget.controller.headers.toList(),
              columnWidths: widget.controller.columnWidths.toList(),
              itemCount: widget.data.values?.length ?? 0,
              buildRow: (context, index, totalWidth) {
                final record = widget.data.values?.elementAt(index);
                if (record == null) return const SizedBox();

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        children: List.generate(
                          widget.controller.headers.length,
                          (cellIndex) {
                            String cellContent = widget.getCellContent(
                              record,
                              cellIndex,
                              index,
                            );
                            return SizedBox(
                              width: getColumnWidthForSingleTableCell(
                                totalWidth: totalWidth,
                                columnWidth:
                                    widget.controller.columnWidths[cellIndex],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: CustomText(
                                  text: cellContent,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.data.total != null)
            _buildGrandTotalRow(widget.data.total!),
        ],
      ),
    );
  }

  Widget _buildGrandTotalRow(SalesRecordDetailReportTotal total) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Get the available width from the parent
                final availableWidth = MediaQuery.of(context).size.width - 64;

                return Row(
                  children: List.generate(widget.controller.headers.length, (
                    index,
                  ) {
                    final cellWidth = getColumnWidthForSingleTableCell(
                      totalWidth: availableWidth,
                      columnWidth: widget.controller.columnWidths[index],
                    );

                    return SizedBox(
                      width: cellWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _buildTotalCell(index, total),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCell(int index, SalesRecordDetailReportTotal total) {
    String text = '';
    bool isClickable = false;

    switch (index) {
      case 0: // Sr
        text = '';
        break;
      case 1: // Invoice Date
        text = 'Total';
        break;
      case 2: // Invoice Number
      case 3: // Tag Number
      case 4: // Item Description
      case 5: // Code
        text = '';
        break;
      case 6: // Pieces
        text = total.pieces?.toString() ?? '0';
        break;
      case 7: // Gross Weight
        text = total.grossWeight ?? '0';
        break;
      case 8: // Net Weight
        text = total.netWeight ?? '0';
        break;
      case 9: // Stone Weight Carat
        text = total.stoneWeightCarat ?? '0';
        break;
      case 10: // Stone Amount
        text = total.stoneAmount ?? '0';
        break;
      case 11: // Old Gold Nett Weight
        text = total.oldGoldNettWeight ?? '0';
        break;
      case 12: // Old Gold Gross Weight
        text = total.oldGoldGrossWeight ?? '0';
        break;
      case 13: // Old Gold Amount
        text = total.oldGoldAmount ?? '0';
        break;
      case 14: // Weight Difference
        text = total.weightDifference ?? '0';
        break;
      case 15: // Received Amount
        text = total.receivedAmount ?? '0';
        isClickable = true;
        break;
      case 16: // Cash
        text = total.paymentMethodCash ?? '0';
        break;
      case 17: // Card
        text = total.paymentMethodCard ?? '0';
        break;
      case 18: // NEFT/RTGS
        text = total.paymentMethodNeftRtgs ?? '0';
        break;
      case 19: // UPI/IMPS
        text = total.paymentMethodUpiImps ?? '0';
        break;
      case 20: // Cheque
        text = total.paymentMethodCheque ?? '0';

        break;
      default:
        text = '';
    }

    if (isClickable) {
      return InkWell(
        onTap: widget.onShowStoneDetails,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
