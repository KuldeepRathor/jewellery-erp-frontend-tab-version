import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/payment_detail_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/payment_method_detail_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view_model/invoice_deatils_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class PurchasePaymentDetailsWidget extends StatelessWidget {
  final InvoiceDeatilsController invoiceDetailsController =
      Get.find<InvoiceDeatilsController>();

  PurchasePaymentDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Obx(() {
          final response =
              invoiceDetailsController.getInvoiceDetailsResponse.value;

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
              // _buildInvoiceRow('Total', details.total ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('CGST', details.cgst ?? '0'),
              _buildInvoiceRow('SGST', details.sgst ?? '0'),
              _buildInvoiceRow('IGST', details.igst ?? '0'),
              _buildInvoiceRow('Nett', details.nettBeforeTaxDeduction ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('TCS', details.tcs ?? '0'),
              _buildInvoiceRow('TDS', details.tds?.toString() ?? '0.00'),
              _buildDivider(),
              _buildInvoiceRow('Round Off', details.roundOff ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('Total', details.total ?? '0', isBold: true),
              _buildInvoiceRow('Paid Amount', details.paidAmount ?? '0'),
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
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text('Sn', style: TextStyle(color: Colors.white)),
                    ),
                    Expanded(
                      child: Text(
                        'Amount (₹)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Method',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Date',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'POS/Bank',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'UPI/UTR/Cn.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),
              if (details.paymentMethodDetails?.isEmpty ?? true)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('No payment methods added')),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(index.toString())),
          Expanded(child: Text('₹ ${method.amount ?? ''}')),
          Expanded(child: Text(method.method ?? '')),
          Expanded(child: Text(method.date?.toString().split(' ')[0] ?? '')),
          Expanded(child: Text(method.pos ?? '')),
          Expanded(child: Text(method.paymentCode ?? '')),
        ],
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
