// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg_flutter.dart';

class CustomButton3 extends StatelessWidget {
  final String buttonName;
  final String image;
  final void Function()? onTap;

  const CustomButton3({
    super.key,
    required this.buttonName,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          clipBehavior: Clip.antiAlias,
          height: 38,
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                SvgPicture.asset(image),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.center,
                    text: buttonName,
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
