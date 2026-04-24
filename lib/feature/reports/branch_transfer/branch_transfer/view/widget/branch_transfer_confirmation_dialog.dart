import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/base_branch_transfer_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

class BranchTransferConfirmationDialog extends StatelessWidget {
  final BaseBranchTransferViewModel controller;

  const BranchTransferConfirmationDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Focus(
        autofocus: true,
        child: Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          fit: StackFit.loose,
          children: [
            Container(
              width: Get.width * .34,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomText(
                    text: 'Confirmation',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: '${controller.controllers.length} items ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                        children: const [
                          TextSpan(
                            text: 'are going to transfer to ',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          TextSpan(
                            text: '',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const CustomText(
                    text: 'Please confirm',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back(result: false);
                        },
                        child: Container(
                          height: 38,
                          width: 160,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: tertiaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ButtonShortcutWidget(
                            buttonName: "Discard",
                            color: whiteColor,
                            shortcut: 'esc',
                            shortcutButtonBackgroundColor: grey1,
                            shortcutButtonColor: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          await controller.submit();
                        },
                        child: Container(
                          height: 38,
                          width: 160,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: ButtonShortcutWidget(
                              buttonName: "Confirm",
                              color: whiteColor,
                              shortcut: 'Ctrl + a',
                              shortcutButtonBackgroundColor: grey1,
                              shortcutButtonColor: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -19,
              right: -14,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: redTextColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const CustomText(text: ' X ', color: whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
