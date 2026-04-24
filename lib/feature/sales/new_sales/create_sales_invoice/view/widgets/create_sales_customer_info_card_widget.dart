import 'package:flutter/material.dart';

class CustomerInfoCard extends StatelessWidget {
  final String customerName;
  final String sgstNumber;
  final String address;
  final String balancePayment;

  final VoidCallback onViewLedger;
  final VoidCallback onEdit;
  final double? width;

  const CustomerInfoCard({
    super.key,
    required this.customerName,
    required this.sgstNumber,
    required this.address,
    required this.balancePayment,
    required this.onViewLedger,
    required this.onEdit,
    this.width,
  });

  Widget _buildInfoColumn({
    required String label,
    required String value,
    Color labelColor = const Color(0xFF28328B),
    Color valueColor = const Color(0xFF111111),
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontFamily: 'Satoshi',
              fontWeight:
                  label == 'Customer Name' ? FontWeight.w700 : FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: width,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: valueColor,
                fontSize: 12,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return SizedBox(
      width: text.contains('Ledger') ? 122 : 83,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF28328B),
          fontSize: 12,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: const Color(0xFFE6E8FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInfoColumn(
                label: 'Customer Name',
                value: customerName,
                // width: 105,
              ),
              const SizedBox(width: 32),
              _buildInfoColumn(
                label: 'GSTIN',
                value: sgstNumber,
                width: 168,
              ),
              const SizedBox(width: 32),
              _buildInfoColumn(
                label: 'Address',
                value: address,
              ),
            ],
          ),
          const SizedBox(width: 21),
          _buildInfoColumn(
            label: 'Balance Payment',
            value: '₹ $balancePayment',
            labelColor: const Color(0xFFFC3A20),
            valueColor: const Color(0xFFFC3A20),
          ),
          const SizedBox(width: 21),
          // InkWell(
          //   onTap: onViewLedger,
          //   child: _buildActionButton('View Ledger (ctrl+l)'),
          // ),
          const SizedBox(width: 21),
          InkWell(
            onTap: onEdit,
            child: _buildActionButton('Edit (Ctrl+C)'),
          ),
        ],
      ),
    );
  }
}
