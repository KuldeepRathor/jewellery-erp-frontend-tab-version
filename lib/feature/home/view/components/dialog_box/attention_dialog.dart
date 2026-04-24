// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

class AttentionDialog extends StatelessWidget {
  ItemDetailsController itemDetailsController =
      Get.find<ItemDetailsController>();
  PartyDetailsController partyDetailsController = Get.find();
  VendorBillDetailsController vendorBillDetailsController = Get.find();

  AttentionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Actions(
        actions: <Type, Action<Intent>>{
          MoveToNextScreenIntent: CallbackAction<MoveToNextScreenIntent>(
            onInvoke: (intent) {
              // Get.back(result: true);
              itemDetailsController.clearControllers();
              Get.back(result: true);
              return;
            },
          ),
          ExitScreenIntent: CallbackAction<ExitScreenIntent>(
            onInvoke: (intent) {
              Get.back(result: false);
              return;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.enter):
                const MoveToNextScreenIntent(),
            LogicalKeySet(LogicalKeyboardKey.escape): const ExitScreenIntent(),
          },
          child: Focus(
            autofocus: true,
            child: Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              fit: StackFit.loose,
              children: [
                Container(
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
                        text: 'Attention!',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 16),
                      const CustomText(
                        text: 'Are you sure you want to\nsave and leave?',
                        fontSize: 12,
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
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: grey1,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ButtonShortcutWidget(
                                buttonName: "Back",
                                color: primaryColor,
                                shortcut: 'esc',
                                shortcutButtonBackgroundColor: grey1,
                                shortcutButtonColor: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              itemDetailsController.clearControllers();
                              partyDetailsController.clearControllers();
                              vendorBillDetailsController.clearControllers();
                              Get.back();
                            },
                            child: Container(
                              height: 38,
                              width: 120,
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
                                  buttonName: "Leave",
                                  color: whiteColor,
                                  shortcut: 'Enter',
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
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: shortcutRedColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const CustomText(text: 'esc', color: redTextColor),
                    ),
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
