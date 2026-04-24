import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/detailed_sales_report/view/detailed_sales_summary_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view_model/daily_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/cancelled_incvoice/view/cancelled_invoice_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view/sales_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/view/sales_return_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view/widgets/total_old_gold_dailog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class SalesSummaryWidget extends StatelessWidget {
  const SalesSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyReportViewModel>(
      builder: (controller) {
        final sales = controller.dailyReportResponse.value.data?.sales;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSalesCard(
                            'Total Sales (${sales?.totalSales?.invoiceCount ?? '0'})',
                            sales?.totalSales?.amount ?? '0',
                            '${sales?.totalSales?.weight ?? "0"}(${sales?.totalSales?.grossWeight ?? "0"}) Gms',
                            'Avg rate ${sales?.totalSales?.averageRate ?? "0"}',
                            () => Get.to(
                              () =>
                                  const SalesListingPage(wantBackButton: true),
                            ),
                          ),
                          _buildVerticalDivider(),
                          _buildSalesCard(
                            'Total Old Gold (${sales?.totalOldGold?.invoiceCount ?? '0'})',
                            sales?.totalOldGold?.amount ?? '0',
                            '${sales?.totalOldGold?.weight ?? "0"}(${sales?.totalOldGold?.grossWeight ?? "0"}) Gms',
                            sales?.totalOldGold?.averageRate ?? "0",
                            () {
                              final oldMetals =
                                  controller
                                      .dailyReportResponse
                                      .value
                                      .data
                                      ?.sales
                                      ?.oldMetals ??
                                  [];

                              // 🔹 Open dialog
                              Get.dialog(
                                TotalOldGoldDailog(oldMetals: oldMetals),
                              );
                            },
                          ),
                          _buildVerticalDivider(),
                          _buildSalesCard(
                            'Correction Weight (${sales?.correctionWeight?.invoiceCount ?? '0'})',
                            '${sales?.correctionWeight?.weight ?? "0"}(${sales?.correctionWeight?.grossWeight ?? "0"}) Gms',
                            '',
                            "",
                            null,
                          ),
                          _buildVerticalDivider(),
                          _buildSalesCard(
                            'Cancelled Invoices (${sales?.cancelledInvoice?.amount ?? '0'})',
                            sales?.cancelledInvoice?.amount ?? '0',
                            '${sales?.cancelledInvoice?.weight ?? "0"}(${sales?.cancelledInvoice?.grossWeight ?? "0"}) Gms',
                            sales?.cancelledInvoice?.averageRate ?? "0",
                            () => Get.to(
                              () => const CancelledInvoicePage(
                                wantBackButton: true,
                              ),
                            ),
                          ),
                          _buildVerticalDivider(),
                          _buildSalesCard(
                            'Sales Return (${sales?.salesReturn?.amount ?? '0'})',
                            sales?.salesReturn?.amount ?? '0',
                            '${sales?.salesReturn?.weight ?? "0"}(${sales?.salesReturn?.grossWeight ?? "0"}) Gms',
                            sales?.salesReturn?.averageRate ?? "0",
                            () => Get.to(
                              () => const SalesReturnListingPage(
                                wantBackButton: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CustomDashedLineWidget(width: double.infinity),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (sales?.transactions != null)
                              ...sales!.transactions!.asMap().entries.map((
                                entry,
                              ) {
                                final transaction = entry.value;
                                return Row(
                                  children: [
                                    _buildPaymentMethod(
                                      transaction.type ?? '',
                                      transaction.amount ?? '0',
                                    ),
                                    if (entry.key !=
                                        sales.transactions!.length - 1)
                                      _buildVerticalDivider(height: 48),
                                  ],
                                );
                              }),
                            Row(
                              children: [
                                _buildVerticalDivider(height: 48),
                                _buildPaymentMethod(
                                  "Advance",
                                  sales?.advance.toString() ?? "",
                                ),
                                _buildVerticalDivider(height: 48),
                                _buildPaymentMethod(
                                  "Balance",
                                  sales?.balance.toString() ?? "",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const DetailedSalesSummaryPage());
                      },
                      child: const Text(
                        'View Detailed Report',
                        style: TextStyle(
                          color: Color(0xFF4758EC),
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF4758EC),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Rest of the widget methods remain the same
  Widget _buildSalesCard(
    String title,
    String amount,
    String weight,
    String rate,
    VoidCallback? onArrowPress,
  ) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF4758EC),
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onArrowPress != null)
                InkWell(
                  onTap: onArrowPress,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF4758EC),
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF28328B),
              fontSize: 32,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weight,
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                rate,
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String method, String amount) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.payment, color: Color(0xFF9F9F9F), size: 16),
              const SizedBox(width: 4),
              Text(
                method,
                style: const TextStyle(
                  color: Color(0xFF9F9F9F),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider({double height = 135}) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        color: const Color(0xFF111111).withOpacity(0.1),
        thickness: 1,
        width: 1,
      ),
    );
  }
}
