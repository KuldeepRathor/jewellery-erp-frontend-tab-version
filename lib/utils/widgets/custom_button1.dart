// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class CustomButton1 extends StatelessWidget {
  final String buttonName;
  final void Function()? onTap;
  final bool isLoading;
  final FocusNode? focusNode;

  const CustomButton1({
    super.key,
    required this.buttonName,
    this.onTap,
    this.isLoading = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        focusNode: focusNode ?? FocusNode(),
        focusColor: primaryColor.withBlue(190),
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          height: 38,
          width: 140,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Add this line
              children: [
                Flexible(
                  // Wrap CustomText with Flexible
                  child: CustomText(
                    textAlign: TextAlign.center,
                    text: buttonName,
                    color: whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isLoading) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 48, 47, 47),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
