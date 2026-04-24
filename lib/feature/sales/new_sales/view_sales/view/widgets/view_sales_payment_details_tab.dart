import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view_model/view_sales_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class PaymentDetailsWidget extends StatelessWidget {
  final ViewSalesController viewSalesController =
      Get.find<ViewSalesController>();

  PaymentDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Obx(() {
          final response =
              viewSalesController.getSalesRecordByIdAggregateResponse.value;

          if (response.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (response.status == Status.ERROR) {
            return Center(child: Text('Error: ${response.message}'));
          }

          final paymentDetails = response.data?.paymentDetails?.firstOrNull;
          if (paymentDetails == null) {
            return const Center(child: Text('No payment details available'));
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInvoiceDetails(paymentDetails)),
              const SizedBox(width: 24),
              Expanded(child: _buildPaymentDetailsTable(paymentDetails)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInvoiceDetails(PaymentDetail details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Invoice Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
              _buildInvoiceRow('Sub Total', details.subTotal ?? '0'),
              _buildInvoiceRow('Scheme Disct', details.schemeDiscount ?? '0'),
              _buildInvoiceRow('Rate Disct', details.rateDiscount ?? '0'),
              _buildInvoiceRow('Discount', '0.00'),
              _buildInvoiceRow(
                'Jeweller Discount',
                details.jewelleryPlanBaseAmount?.toString() ?? '0.00',
              ),
              _buildInvoiceRow('Sales Amount', details.salesAmount ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('CGST', details.cgst ?? '0'),
              _buildInvoiceRow('SGST', details.sgst ?? '0'),
              _buildInvoiceRow('IGST', details.igst ?? '0'),
              _buildInvoiceRow('Nett', details.nettGst ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('TCS', details.tcs ?? '0'),
              _buildInvoiceRow('TDS', details.tds?.toString() ?? '0.00'),
              _buildInvoiceRow('Nett', details.nettTdsTcs ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('Purchase (OG)', details.purchaseOldGold ?? '0'),
              _buildInvoiceRow('Advance (ADJ)', details.advance ?? '0'),
              _buildInvoiceRow('Round Off', details.roundOff ?? '0'),
              _buildInvoiceRow('Bank Charges', details.bankCharges ?? '0'),
              _buildDivider(),
              _buildInvoiceRow(
                'Final Amount',
                details.finalAmount ?? '0',
                isBold: true,
              ),
              _buildInvoiceRow('Received', details.receivedAmount ?? '0'),
              _buildInvoiceRow(
                'Balance',
                details.balanceAmount ?? '0',
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsTable(PaymentDetail details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Method Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        'Sn',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Amount (₹)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Method',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Date',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'POS/Bank',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'UPI/UTR/Cn.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Uni Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (details.paymentMethodDetails?.isEmpty ?? true)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No payment methods added',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                )
              else
                ...details.paymentMethodDetails!.asMap().entries.map(
                  (entry) => _buildPaymentMethodRow(
                    index: entry.key + 1,
                    method: entry.value,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodRow({
    required int index,
    required PaymentMethodDetail method,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                index.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '₹ ${method.amount ?? '0'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                method.method ?? '-',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                method.date != null
                    ? '${method.date!.day.toString().padLeft(2, '0')}/${method.date!.month.toString().padLeft(2, '0')}/${method.date!.year}'
                    : '-',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                method.pos ?? '-',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                method.paymentCode ?? '-',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                method.universalPaymentCode ?? '-',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
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
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹ $value',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? primaryColor : Colors.black,
            ),
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
