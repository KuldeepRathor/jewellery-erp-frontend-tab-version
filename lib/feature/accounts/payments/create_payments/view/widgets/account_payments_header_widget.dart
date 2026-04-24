import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class AccountPaymentsHeaderWidget extends StatelessWidget {
  const AccountPaymentsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Payments ',
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8), // Add some spacing between texts
        ],
      ),
    );
  }
}
