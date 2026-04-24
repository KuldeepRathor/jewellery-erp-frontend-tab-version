// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

class PartyDetailsCard extends StatelessWidget {
  final String sundryDebtor;
  final String sgst;
  final String address;
  final VoidCallback onEditPressed;
  const PartyDetailsCard({
    super.key,
    required this.sundryDebtor,
    required this.sgst,
    required this.address,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: grey1,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Sundry Debtor',
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(text: sundryDebtor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'GSTIN',
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(text: sgst, color: primaryTextColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Address',
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(text: address, color: primaryTextColor),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: grey1,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ButtonShortcutWidget(
              onTap: onEditPressed,
              canRequestFocus: false,
              buttonName: "Edit",
              shortcut: "Ctrl + E",
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
