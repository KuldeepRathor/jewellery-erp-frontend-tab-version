import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/view/widgets/custom_gold_rate_popup_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/settings_popup.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

// ignore: must_be_immutable
class HeaderWidget extends StatelessWidget {
  String header;
  bool? wantBackButton;
  bool isReport;
  void Function()? onBackButtonTap;
  HeaderWidget({
    super.key,
    required this.header,
    this.onBackButtonTap,
    this.wantBackButton,
    this.isReport = false,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onNormalKeyEvent(node, event, []),
      child: Container(
        // height: 62,
        width: double.infinity,
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Visibility(
                visible: wantBackButton ?? false,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (onBackButtonTap != null) {
                          onBackButtonTap!();
                        } else {
                          Get.back();
                        }
                      },
                      child: Container(
                        width: 27,
                        height: 35,
                        decoration: ShapeDecoration(
                          color: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const SizedBox(
                          width: 15,
                          height: 15,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: whiteColor,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              CustomText(
                text: header,
                // 'Purchase',
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,

                // textAlign: TextAlign.start,
              ),
              const Spacer(),
              if (!isReport) CustomGoldRatePopup(),
              SettingsPopup(),
              // const CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     'https://cdn-icons-png.flaticon.com/512/149/149071.png',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
