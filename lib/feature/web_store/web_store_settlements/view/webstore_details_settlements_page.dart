// Create new file: webstore_settlement_details_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/view_model/webstore_settlements_details_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:svg_flutter/svg_flutter.dart';

class WebStoreSettlementDetailsPage extends StatefulWidget {
  final String settlementId;
  final String settlementAmount;

  const WebStoreSettlementDetailsPage({
    super.key,
    required this.settlementId,
    required this.settlementAmount,
  });

  @override
  State<WebStoreSettlementDetailsPage> createState() =>
      _WebStoreSettlementDetailsPageState();
}

class _WebStoreSettlementDetailsPageState
    extends State<WebStoreSettlementDetailsPage> {
  late final WebStoreSettlementDetailsViewModel controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      WebStoreSettlementDetailsViewModel(settlementId: widget.settlementId),
      tag: widget.settlementId,
    );
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    Get.delete<WebStoreSettlementDetailsViewModel>(tag: widget.settlementId);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: 'Settlement Details', wantBackButton: true),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    Expanded(child: _buildDetailsTable()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {
            // Export functionality
          },
          image: 'assets/svgs/download.svg',
          buttonName: 'Export',
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        onChanged: controller.setSeachQuery,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search by customer name, phone, transaction ID',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }

  Widget _buildDetailsTable() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Transaction Details",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final apiStatus =
                    controller.getSettlementDetailsResponse.value.status;

                if (apiStatus == Status.COMPLETED) {
                  final data =
                      controller.getSettlementDetailsResponse.value.data;
                  if (data?.values?.isEmpty ?? true) {
                    return _buildEmptyState();
                  }

                  return LineWiseCustomTable(
                    headers: controller.headers.toList(),
                    columnWidths: controller.columnWidths.toList(),
                    itemCount: data?.values?.length ?? 0,
                    controller: _scrollController,
                    isLoadingMore: controller.isLoadingMore.value,
                    buildRow: (context, index, totalWidth) {
                      final item = data?.values?.elementAt(index);

                      return Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            children: List.generate(controller.headers.length, (
                              cellIndex,
                            ) {
                              String cellContent = "-";
                              switch (cellIndex) {
                                case 0:
                                  cellContent =
                                      item?.transactionCreatedAt != null
                                          ? DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(item!.transactionCreatedAt!)
                                          : "-";
                                  break;
                                case 1:
                                  cellContent = item?.phoneNumber ?? "-";
                                  break;
                                case 2:
                                  cellContent = item?.customerName ?? "-";
                                  break;
                                case 3:
                                  cellContent = item?.txnId ?? "-";
                                  break;
                                case 4:
                                  cellContent = item?.txnType ?? "-";
                                  break;
                                case 5:
                                  cellContent = "₹${item?.txnAmount ?? '0'}";
                                  break;
                                case 6:
                                  cellContent = item?.paymentMode ?? "-";
                                  break;
                                case 7:
                                  cellContent = item?.paymentId ?? "-";
                                  break;
                                case 8:
                                  cellContent =
                                      "₹${_formatAmount(item?.txnCharges)}";
                                  break;
                                case 9:
                                  cellContent =
                                      "₹${_formatAmount(item?.txnChargesGst)}";
                                  break;
                                case 10:
                                  cellContent =
                                      "₹${_formatAmount(item?.settlementAmount)}";
                                  break;
                                case 11:
                                  cellContent = item?.settlementId ?? '0';
                                  break;
                                case 12:
                                  cellContent =
                                      item?.settlementTime != null
                                          ? DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(item!.settlementTime!)
                                          : "-";

                                  break;
                              }

                              return SizedBox(
                                width: getColumnWidthForSingleTableCell(
                                  totalWidth: totalWidth,
                                  columnWidth:
                                      controller.columnWidths[cellIndex],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: Tooltip(
                                    message: cellContent,
                                    child: SelectableText(
                                      cellContent,
                                      // CustomText(
                                      // text: cellContent,
                                      // fontSize: 16,
                                      // overflow: TextOverflow.ellipsis,
                                      // fontFamily: 'Satoshi',
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  );
                } else if (apiStatus == Status.LOADING) {
                  return _buildLoadingState();
                } else if (apiStatus == Status.ERROR) {
                  return _buildErrorState();
                }

                return const SizedBox();
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';

    try {
      double value =
          amount is String ? double.parse(amount) : amount.toDouble();

      // Format to 2 decimal places
      String formatted = value.toStringAsFixed(2);

      // Remove trailing zeros and decimal point if not needed
      formatted = formatted.replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

      return formatted;
    } catch (e) {
      return '0';
    }
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: LineWiseCustomTable(
            headers: controller.headers.toList(),
            columnWidths: controller.columnWidths.toList(),
            itemCount: 0,
            buildRow: (context, index, totalWidth) => const SizedBox(),
            isLoadingMore: false,
            addBottomSpace: false,
          ),
        ),
        Expanded(
          flex: 15,
          child: Center(
            child: SvgPicture.asset('assets/svgs/error/no_records_found.svg'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: LineWiseCustomTable(
            headers: controller.headers.toList(),
            columnWidths: controller.columnWidths.toList(),
            itemCount: 0,
            buildRow: (context, index, totalWidth) => const SizedBox(),
            addBottomSpace: false,
          ),
        ),
        const Expanded(
          flex: 15,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        Expanded(
          child: LineWiseCustomTable(
            headers: controller.headers.toList(),
            columnWidths: controller.columnWidths.toList(),
            itemCount: 0,
            buildRow: (context, index, totalWidth) => const SizedBox(),
            addBottomSpace: false,
          ),
        ),
        const Expanded(
          flex: 15,
          child: Center(child: Text("Something went wrong")),
        ),
      ],
    );
  }
}
