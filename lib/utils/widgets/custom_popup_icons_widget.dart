import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

class CustomPopUpIcon extends StatelessWidget {
  final String buttonName;
  final String image;

  const CustomPopUpIcon({
    super.key,
    required this.buttonName,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // clipBehavior: Clip.antiAlias,
      height: 38,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Row(
          children: [
            SvgPicture.asset(image),
            const SizedBox(width: 8),
            CustomText(
              textAlign: TextAlign.center,
              text: buttonName,
              color: whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
