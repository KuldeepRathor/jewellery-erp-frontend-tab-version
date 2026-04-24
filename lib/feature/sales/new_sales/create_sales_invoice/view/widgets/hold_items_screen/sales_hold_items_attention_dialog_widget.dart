// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

class SalesHoldItemsAttentionDialog extends StatelessWidget {
  SalesHoldItemsAttentionDialog({super.key});
  SidebarController sidebarController = Get.find<SidebarController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Actions(
        actions: <Type, Action<Intent>>{
          MoveToNextScreenIntent: CallbackAction<MoveToNextScreenIntent>(
            onInvoke: (intent) {
              // sidebarController.navigateToWidget(
              //   newChild: const CreateSalesHoldItemsScreen(),
              // );

              Get.back(result: true);
              Get.back();
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: Get.width * 0.9,
                    height: Get.height * 0.9,
                    padding: const EdgeInsets.all(16),
                    child: const CreateSalesHoldItemsScreen(),
                  ),
                ),
                // barrierDismissible: false,
              );
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
                        text:
                            'Please confirm if you want to deliver or hold items',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
                                buttonName: "Deliver",
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
                              // sidebarController.navigateToWidget(
                              //   newChild: const CreateSalesHoldItemsScreen(),
                              // );

                              Get.back(result: true);
                              Get.back();
                              Get.dialog(
                                Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Container(
                                    width: Get.width * 0.9,
                                    height: Get.height * 0.9,
                                    padding: const EdgeInsets.all(16),
                                    child: const CreateSalesHoldItemsScreen(),
                                  ),
                                ),
                                // barrierDismissible: false,
                              );
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
                                  buttonName: "Hold",
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
                      Get.back(result: false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: shortcutRedColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: redTextColor,
                        size: 20,
                      ),
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
