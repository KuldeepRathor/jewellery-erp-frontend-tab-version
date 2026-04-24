import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/model/daily_reports_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view/widgets/credit_summary_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view/widgets/daily_reports_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view/widgets/digital_coin_summary_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view/widgets/material_in_out_purchase_summary_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view/widgets/purchase_summary_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view/widgets/sales_summary_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view_model/daily_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg_flutter.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({super.key});

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  final DailyReportViewModel controller = Get.put(DailyReportViewModel());
  @override
  void initState() {
    super.initState();
    controller.getDailyReportDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/svgs/auth/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              HeaderWidget(
                header: "Daily Report",
                isReport: true,
                wantBackButton: true,
                onBackButtonTap: () {
                  Get.back();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const DailyReportFilterWidget(),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => controller.clearFilters(),
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final apiStatus =
                            controller.dailyReportResponse.value.status;

                        if (apiStatus == Status.LOADING) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (apiStatus == Status.COMPLETED) {
                          final data =
                              controller.dailyReportResponse.value.data;
                          return Column(
                            children: [
                              const SalesSummaryWidget(),
                              const SizedBox(height: 16),
                              const PurchaseSummaryWidget(),
                              const SizedBox(height: 16),
                              const CreditSummaryWidget(),
                              const SizedBox(height: 16),
                              CommonSummaryWidget(
                                title: 'Jewellery Plan',
                                blueSubtitle: "No of Installments",
                                data: data?.jewelleryPlan ?? AdvanceBooking(),
                                transactions: data?.jewelleryPlan?.transactions,
                              ),
                              const SizedBox(height: 16),
                              CommonSummaryWidget(
                                title: 'Advance Booking',
                                blueSubtitle: "No of Bookings",
                                data: data?.advanceBooking ?? AdvanceBooking(),
                                transactions:
                                    data?.advanceBooking?.transactions,
                              ),
                              const SizedBox(height: 16),
                              CommonSummaryWidget(
                                title: 'Orders',
                                blueSubtitle: "Orders",
                                data: data?.orders ?? AdvanceBooking(),
                                transactions: data?.orders?.transactions,
                              ),
                              const SizedBox(height: 16),
                              CommonSummaryWidget(
                                title: 'Repairs',
                                blueSubtitle: "Repairs",
                                data: data?.repairs ?? AdvanceBooking(),
                                transactions: data?.repairs?.transactions,
                              ),
                              const SizedBox(height: 16),
                              const DigitalCoinSummaryWidget(),
                              const SizedBox(height: 16),
                              const MaterialInoutSummaryWidget(),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              controller.dailyReportResponse.value.message ??
                                  'Something went wrong',
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SummaryRowData {
  final String title;
  final String amount;
  final String subtitle1;
  final String subtitle2;
  final String amountDetails;

  SummaryRowData(
    this.title,
    this.amount,
    this.subtitle1,
    this.subtitle2,
    this.amountDetails,
  );
}

class CommonSummaryWidget extends StatelessWidget {
  final String title;
  final String blueSubtitle;
  final AdvanceBooking data;
  final List<Transaction>? transactions;

  const CommonSummaryWidget({
    super.key,
    required this.title,
    required this.data,
    this.transactions,
    required this.blueSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard(
                      blueSubtitle,
                      data.orders?.amount ??
                          data.installments?.amount ??
                          data.bookings?.amount ??
                          '0',
                      '${data.orders?.weight ?? data.installments?.weight ?? data.bookings?.weight ?? "0"} Gms',
                      'Avg rate ${data.orders?.averageRate ?? data.installments?.averageRate ?? data.bookings?.averageRate ?? "0"}',
                    ),
                    _buildVerticalDivider(),
                    _buildSummaryCard(
                      'Billed',
                      data.billed?.amount ?? '0',
                      '${data.billed?.weight ?? "0"} Gms',
                      'Avg rate ${data.billed?.averageRate ?? "0"}',
                    ),
                    _buildVerticalDivider(),
                    _buildSummaryCard(
                      'Cancelled',
                      data.cancelled?.amount ?? '0',
                      '${data.cancelled?.weight ?? "0"} Gms',
                      'Avg rate ${data.cancelled?.averageRate ?? "0"}',
                    ),
                  ],
                ),
                const CustomDashedLineWidget(width: double.infinity),
                if (transactions != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...transactions!.asMap().entries.map((entry) {
                          final transaction = entry.value;
                          return Row(
                            children: [
                              _buildPaymentMethod(
                                transaction.type ?? '',
                                transaction.amount ?? '0',
                              ),
                              if (entry.key != transactions!.length - 1)
                                _buildVerticalDivider(height: 48),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'View Detailed Report',
                  style: TextStyle(
                    color: Color(0xFF4758EC),
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Color(0xFF4758EC), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    String weight,
    String rate,
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
              const Icon(
                Icons.arrow_forward,
                color: Color(0xFF4758EC),
                size: 20,
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
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                rate,
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
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
              // _getPaymentIcon(method),
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
