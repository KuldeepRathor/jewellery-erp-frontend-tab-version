// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class UserLockerCardWidget extends StatelessWidget {
  final String type;
  final String totalAmount;
  final String totalWeight;
  final String buyAmount;
  final String buyCount;
  final String deliverAmount;
  final String deliverCount;
  final double width;

  const UserLockerCardWidget({
    super.key,
    required this.type,
    required this.totalAmount,
    required this.totalWeight,
    required this.buyAmount,
    required this.buyCount,
    required this.deliverAmount,
    required this.deliverCount,
    this.width = 300, // Default width if not specified
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTypeHeader(),
          _buildBalanceDetails(),
          const SizedBox(height: 16),
          _buildActionFooter(),
        ],
      ),
    );
  }

  Widget _buildTypeHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: type,
          fontSize: 20,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
          color: Colors.orange[700],
        ),
      ),
    );
  }

  Widget _buildBalanceDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBalanceColumn('Total Amount', totalAmount),
          _buildBalanceColumn('Total Weight', totalWeight),
        ],
      ),
    );
  }

  Widget _buildBalanceColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 12,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
          color: primaryColor,
        ),
        CustomText(
          text: value,
          fontSize: 20,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildActionFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF252F8A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionColumn('Buy', '$buyAmount ($buyCount)'),
          const SizedBox(width: 36),
          _buildActionColumn('Deliver', '$deliverAmount ($deliverCount)'),
        ],
      ),
    );
  }

  Widget _buildActionColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 12,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        CustomText(
          text: value,
          fontSize: 16,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ],
    );
  }
}
