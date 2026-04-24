// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class CustomHeaderWidget extends StatelessWidget {
  final SidebarController sidebarController = Get.find();
  String header;
  bool? wantBackButton;
  void Function()? onBackButtonTap;
  CustomHeaderWidget({
    super.key,
    required this.header,
    this.wantBackButton,
    this.onBackButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        sidebarController.popBackSelectedWidget();
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
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
            const Spacer(),
            const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/149/149071.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
