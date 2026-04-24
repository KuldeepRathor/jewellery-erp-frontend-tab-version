import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class PurchaseReturnInvoiceVendorBillDetailsWidget extends StatelessWidget {
  final String invoiceNo;
  final String vendorInvoiceNo;
  final String invoiceCreated;
  final String invoiceReceived;
  final bool isVendor;

  const PurchaseReturnInvoiceVendorBillDetailsWidget({
    super.key,
    required this.invoiceNo,
    required this.vendorInvoiceNo,
    required this.invoiceCreated,
    required this.invoiceReceived,
    required this.isVendor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: '${isVendor ? "Vendor" : "Customer"} Bill Details',
                    color: blackColor,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const CustomText(
                        text: 'Invoice No: ',
                        color: blackColor,
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                      Expanded(
                        child: CustomText(
                          text: invoiceNo,
                          // maxLines: 1,
                          color: secondaryColor,
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoField("Vendor Invoice No.", vendorInvoiceNo),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoField("Invoice Created", invoiceCreated),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoField("Invoice Received", invoiceReceived),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: primaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 8),
        Container(
          height: 34,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: secondaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: blackColor,
                fontSize: 14,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
