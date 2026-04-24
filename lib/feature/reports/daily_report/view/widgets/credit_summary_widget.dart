import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view_model/daily_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class CreditSummaryWidget extends StatelessWidget {
  const CreditSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyReportViewModel>(
      builder: (controller) {
        final creditSummary =
            controller.dailyReportResponse.value.data?.creditSummary;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Credit Summary',
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
                    // Headers
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildHeader('', flex: 1),
                          _buildHeader('Opening'),
                          _buildHeader('Today\'s Credit'),
                          _buildHeader('Today\'s Debit'),
                          _buildHeader('Today\'s Debit'),
                          _buildHeader(
                            'Details',
                            alignment: MainAxisAlignment.start,
                          ),
                        ],
                      ),
                    ),
                    const CustomDashedLineWidget(width: double.infinity),
                    const SizedBox(height: 32),
                    // Vendor Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildLabel('Vendor'),
                          _buildAmount(creditSummary?.vendor?.opening ?? '0'),
                          _buildAmount(
                            creditSummary?.vendor?.todayCredit ?? '0',
                          ),
                          _buildAmount(
                            creditSummary?.vendor?.todayDebit ?? '0',
                          ),
                          _buildAmount(creditSummary?.vendor?.closing ?? '0'),
                          _buildViewDetails(() {
                            // Handle view details for vendor
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    const CustomDashedLineWidget(width: double.infinity),
                    const SizedBox(height: 16),
                    // Customer Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildLabel('Customer'),
                          _buildAmount(creditSummary?.customer?.opening ?? '0'),
                          _buildAmount(
                            creditSummary?.customer?.todayCredit ?? '0',
                          ),
                          _buildAmount(
                            creditSummary?.customer?.todayDebit ?? '0',
                          ),
                          _buildAmount(creditSummary?.customer?.closing ?? '0'),
                          _buildViewDetails(() {
                            // Handle view details for customer
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
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
                    Icon(
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

  Widget _buildHeader(
    String text, {
    int flex = 1,
    MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4758EC),
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Expanded(
      child: Row(
        children: [
          Text(
            text,
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

  Widget _buildAmount(String amount) {
    return Expanded(
      child: Row(
        children: [
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF28328B),
              fontSize: 32,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewDetails(VoidCallback onPressed) {
    return Expanded(
      child: Row(
        children: [
          InkWell(
            onTap: onPressed,
            child: const Row(
              children: [
                Text(
                  'View Details',
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
}
