import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class PurchaseReturnInvoicePartyDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> partyDetails;

  const PurchaseReturnInvoicePartyDetailsWidget({
    super.key,
    required this.partyDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192,
      decoration: _buildContainerDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 8),
            _buildPartyName(),
            const SizedBox(height: 18),
            CustomDashedLineWidget(width: MediaQuery.of(context).size.width),
            const SizedBox(height: 16),
            _buildPartyDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const CustomText(
      text: 'Party Details',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _buildPartyName() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: secondaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          partyDetails['name']?.toString() ?? 'N/A',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildPartyDetailsCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          'Sundry Debtor',
          partyDetails['name']?.toString() ?? 'N/A',
        ),
        const SizedBox(width: 16),
        _buildDetailRow(
          'GSTIN',
          partyDetails['gstNumber']?.toString() ?? 'N/A',
        ),
        const SizedBox(width: 16),
        _buildDetailRow(
          'Address',
          partyDetails['addressLine1']?.toString() ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    );
  }
}
