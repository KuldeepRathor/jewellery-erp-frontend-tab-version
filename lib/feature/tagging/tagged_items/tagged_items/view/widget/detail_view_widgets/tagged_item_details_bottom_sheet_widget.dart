import 'package:flutter/material.dart';

class TaggedItemDetailsBottomSheetWidget extends StatelessWidget {
  const TaggedItemDetailsBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: 1000,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItemDetails(),
                    const SizedBox(height: 20),
                    _buildImageGallery(),
                    const SizedBox(height: 20),
                    _buildStoneDetails(),
                  ],
                ),
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF28328B),
      child: const Row(
        children: [
          Text(
            'Item Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildDetailRow('ID', '731095'),
        _buildDetailRow('Item Name/ Design', 'Necklace Victorian Fancy'),
        _buildDetailRow('Size', 'NONE'),
        _buildDetailRow('Dealer', 'A'),
        _buildDetailRow('Grade', 'G'),
        _buildDetailRow('Rate', '₹ 18,000'),
        _buildDetailRow('Mc', '₹ 75,000'),
        _buildDetailRow('Wastage', '3.604 = 12%'),
        _buildDetailRow('HUID', '609 328'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF28328B),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Tooltip(
              message: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return Row(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage("https://via.placeholder.com/80x80"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoneDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stone Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            _buildTableRow(['Stone Name', 'Pcs', 'Weight', 'Rate', 'Value'],
                isHeader: true),
            _buildTableRow(['C.RE', '1', '13.350', '₹4,00,000', '134576']),
            _buildTableRow(['CZ', '1', '5.350', '₹4,00,000', '445176']),
            _buildTableRow(['MZN', '1', '3.350', '₹4,00,000', '4576']),
            _buildTableRow(['BEM', '1', '5.350', '₹4,00,000', '245756']),
            _buildTableRow(['SSP', '1', '4.350', '₹4,00,000', '134576']),
            _buildTableRow(['SSP', '1', '6.350', '₹4,00,000', '6543']),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells
          .map((cell) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  cell,
                  style: TextStyle(
                    color: isHeader ? const Color(0xFF28328B) : Colors.black,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                    fontSize: isHeader ? 12 : 14,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Color(0xFF28328B)),
              SizedBox(width: 8),
              Text(
                'Tagged By: Viajy Kumar (A1234)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {},
          //       child: Text('Discard'),
          //       style: ElevatedButton.styleFrom(
          //         primary: Color(0xFFE6E8FF),
          //         onPrimary: Color(0xFF28328B),
          //       ),
          //     ),
          //     SizedBox(width: 16),
          //     ElevatedButton(
          //       onPressed: () {},
          //       child: Text('Next (ctrl+s)'),
          //       style: ElevatedButton.styleFrom(
          //         primary: Color(0xFF28328B),
          //         onPrimary: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
