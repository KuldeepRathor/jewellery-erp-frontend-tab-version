import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/model/get_repair_details_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class ViewRepairPaymentDetailsWidget extends StatelessWidget {
  final GetRepairDetailsByIdResponse repairData;

  const ViewRepairPaymentDetailsWidget({super.key, required this.repairData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildInvoiceDetails()),
            const SizedBox(width: 24),
            Expanded(child: _buildPaymentDetailsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    // Get first payment detail if available
    final paymentDetail = repairData.paymentDetails?.firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Invoice Details',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildInvoiceRow('Amount', paymentDetail?.amount ?? '0'),
              _buildDivider(),
              _buildInvoiceRow(
                'Received Amount',
                paymentDetail?.receivedAmount ?? '0',
              ),
              _buildDivider(),
              _buildInvoiceRow(
                'Final Amount',
                paymentDetail?.finalAmount ?? '0',
                isBold: true,
              ),
              _buildDivider(),
              _buildInvoiceRow(
                'Balance Amount',
                paymentDetail?.balanceAmount ?? '0',
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsTable() {
    // Get payment methods if available
    final paymentMethods =
        repairData.paymentDetails?.isNotEmpty == true &&
                repairData.paymentDetails!.first.paymentMethods?.isNotEmpty ==
                    true
            ? repairData.paymentDetails!.first.paymentMethods
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Payment Method Details',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: CustomText(
                        text: 'Sn',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        text: 'Amount (₹)',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        text: 'Method',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        text: 'Date',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        text: 'UPI/UTR/Cn.',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (paymentMethods == null || paymentMethods.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('No payment methods available')),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = paymentMethods[index];
                    String formattedDate =
                        method.date != null
                            ? "${method.date!.day.toString().padLeft(2, '0')}-${method.date!.month.toString().padLeft(2, '0')}-${method.date!.year}"
                            : "N/A";

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: CustomText(
                              text: (index + 1).toString(),
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              text: method.amount ?? 'N/A',
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              text: method.method ?? 'N/A',
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              text: formattedDate,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              text: method.paymentCode ?? 'N/A',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceRow(
    String label,
    String value, {
    bool isBold = false,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
          CustomText(
            text: '₹ $value',
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted ? Colors.red : Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(color: Colors.grey.shade300),
    );
  }
}
