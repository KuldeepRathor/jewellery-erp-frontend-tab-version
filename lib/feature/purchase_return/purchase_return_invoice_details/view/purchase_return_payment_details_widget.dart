import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_resturn_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view_model/purchase_return_invoice_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class PurchaseReturnPaymentDetailsWidget extends StatelessWidget {
  final PurchaseReturnInvoiceInvoiceDeatilsController invoiceDetailsController =
      Get.find<PurchaseReturnInvoiceInvoiceDeatilsController>();

  PurchaseReturnPaymentDetailsWidget({super.key});

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

  Widget _buildInvoiceDetails(PurchaseReturnResponsePaymentDetail details) {
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
              _buildInvoiceRow('Total', details.total ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('CGST', details.cgst ?? '0'),
              _buildInvoiceRow('SGST', details.sgst ?? '0'),
              _buildInvoiceRow('IGST', details.igst?.toString() ?? '0'),
              _buildInvoiceRow('Nett', details.nett ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('TCS', details.tcs?.toString() ?? '0'),
              _buildInvoiceRow('TDS', details.tds?.toString() ?? '0.00'),
              _buildDivider(),
              _buildInvoiceRow('Round Off', details.roundOff ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('Total', details.total ?? '0', isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsTable(
    PurchaseReturnResponsePaymentDetail details,
  ) {
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
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('No payment methods available')),
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
