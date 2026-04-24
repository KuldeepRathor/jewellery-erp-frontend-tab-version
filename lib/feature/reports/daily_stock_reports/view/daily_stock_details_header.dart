import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/model/daily_stock_report_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class DailyStockHeaderWidget extends StatelessWidget {
  final DailyStockResponseModel dailyStockModel;

  const DailyStockHeaderWidget({super.key, required this.dailyStockModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: _buildContainerDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 16),
            _buildPartyDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const CustomText(
      text: 'Counter Details',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _buildPartyDetailsCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Counter Name', dailyStockModel.counterName ?? ''),
        const SizedBox(width: 42),
        const SizedBox(height: 40, child: VerticalDivider(color: grey2)),
        const SizedBox(width: 42),
        _buildDetailRow(
          'Total Stock Heads',
          dailyStockModel.totalItems.toString(),
        ),
        const SizedBox(width: 42),
        const SizedBox(height: 40, child: VerticalDivider(color: grey2)),
        const SizedBox(width: 42),
        _buildDetailRow('Date', DateTime.now().toString()),
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
