import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class DesignOrderDetailsRow extends StatelessWidget {
  final String label;
  final String value;
  final bool hasBackground;

  const DesignOrderDetailsRow({
    super.key,
    required this.label,
    required this.value,
    this.hasBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.05,
      decoration: BoxDecoration(
        color: hasBackground ? grey1 : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: label,
                color: primaryColor,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: CustomText(
                text: value,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
