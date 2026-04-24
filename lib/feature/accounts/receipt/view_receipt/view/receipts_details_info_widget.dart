import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/view_receipt/model/get_receipts_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class ReceiptsDetailsInfoWidget extends StatelessWidget {
  final GetReceiptsByIdResponse data;

  const ReceiptsDetailsInfoWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: 'Party Name/Phone/Code',
                              fontSize: 12,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 300,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    // text: "-",
                                    text: data.partyName ?? '-',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(color: grey2, height: 60, width: 2),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: 'Payment Date',
                              fontSize: 12,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 300,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text:
                                        data.date != null
                                            ? "${data.date!.day}/${data.date!.month}/${data.date!.year}"
                                            : '-',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLedgerDetailsWidget(),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(color: grey2, height: 150, width: 2),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: "Payment Number",
                          fontSize: 12,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text: data.paymentReceiptNumber ?? "-",
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 24),
                        const CustomText(
                          text: "Total Amount",
                          fontSize: 12,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text: "₹${data.total ?? '0'}",
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerDetailsWidget() {
    // Format address if available
    String addressText = "-";
    if (data.partyDetails != null &&
        data.partyDetails!.address != null &&
        data.partyDetails!.address!.isNotEmpty) {
      Address address = data.partyDetails!.address!.first;
      List<String> addressParts = [];

      if (address.addressLine1 != null && address.addressLine1!.isNotEmpty) {
        addressParts.add(address.addressLine1!);
      }
      if (address.addressLine2 != null && address.addressLine2!.isNotEmpty) {
        addressParts.add(address.addressLine2!);
      }
      if (address.city != null && address.city!.isNotEmpty) {
        addressParts.add(address.city!);
      }
      if (address.state != null && address.state!.isNotEmpty) {
        addressParts.add(address.state!);
      }
      if (address.pincode != null && address.pincode!.isNotEmpty) {
        addressParts.add(address.pincode!);
      }

      if (addressParts.isNotEmpty) {
        addressText = addressParts.join(", ");
      }
    }

    // Format bank details if available
    String bankDetailsText = "-";
    if (data.partyDetails != null &&
        data.partyDetails!.bankDetails != null &&
        data.partyDetails!.bankDetails!.isNotEmpty) {
      // Since bankDetails is List<dynamic>, you'll need to check its structure
      // Here I'm assuming each bank detail has some key fields like account number
      var bankDetail = data.partyDetails!.bankDetails!.first;
      if (bankDetail is Map<String, dynamic>) {
        List<String> bankParts = [];

        if (bankDetail.containsKey('bank_name')) {
          bankParts.add(bankDetail['bank_name'].toString());
        }
        if (bankDetail.containsKey('account_number')) {
          bankParts.add('A/c: ${bankDetail['account_number'].toString()}');
        }
        if (bankDetail.containsKey('ifsc')) {
          bankParts.add('IFSC: ${bankDetail['ifsc'].toString()}');
        }

        if (bankParts.isNotEmpty) {
          bankDetailsText = bankParts.join(", ");
        }
      }
    }

    return Container(
      width: Get.width * 0.5,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: grey1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Ledger Details",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLedgerDetailColumn("Ledger Name", data.partyName ?? "-"),
              const SizedBox(width: 16),
              _buildLedgerDetailColumn("GST", data.partyType ?? "-"),
              const SizedBox(width: 16),
              _buildLedgerDetailColumn("Address", addressText),
              const SizedBox(width: 16),
              _buildLedgerDetailColumn("Bank Details", bankDetailsText),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerDetailColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: label, fontSize: 12, color: primaryColor),
          const SizedBox(height: 4),
          CustomText(text: value, fontSize: 14, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
