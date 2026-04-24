// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg_flutter.dart';

class CustomButton2 extends StatelessWidget {
  final String buttonName;
  final String image;
  final Color backgroundColor;
  final Color textColor;
  final void Function()? onTap;
  final Widget Function(BuildContext, String, {Key? key})? svgBuilder;

  const CustomButton2({
    super.key,
    required this.buttonName,
    required this.image,
    this.onTap,
    this.backgroundColor = primaryColor,
    this.textColor = whiteColor,
    this.svgBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // clipBehavior: Clip.antiAlias,
          height: 38,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                svgBuilder != null
                    ? svgBuilder!(context, image)
                    : SvgPicture.asset(
                      image,
                      // ignore: deprecated_member_use
                      color: textColor,
                    ),
                const SizedBox(width: 8),
                CustomText(
                  textAlign: TextAlign.center,
                  text: buttonName,
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
