import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';

class AddNewPartyDialog extends StatelessWidget {
  const AddNewPartyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.escape): const CloseDialogIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyC): const AddCustomerIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyV): const AddVendorIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          CloseDialogIntent: CallbackAction<CloseDialogIntent>(
            onInvoke: (CloseDialogIntent intent) => Get.back(),
          ),
          AddCustomerIntent: CallbackAction<AddCustomerIntent>(
            onInvoke:
                (AddCustomerIntent intent) =>
                    Get.dialog(const AddCustomerDialog()),
          ),
          AddVendorIntent: CallbackAction<AddVendorIntent>(
            onInvoke:
                (AddVendorIntent intent) => Get.dialog(const AddVendorDialog()),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  // height: Get.height * .25,
                  // width: Get.width * .20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomText(
                        text: 'Add New Party!',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: Get.height * .03),
                      const CustomText(
                        text: 'What type of Party do you want to add?',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: blackColor,
                      ),
                      SizedBox(height: Get.height * .05),
                      Wrap(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Get.dialog(const AddCustomerDialog()),
                            child: Container(
                              height: 38,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: tertiaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ButtonShortcutWidget(
                                buttonName: "Customer",
                                color: whiteColor,
                                shortcut: 'C',
                                shortcutButtonBackgroundColor: const Color(
                                  0xFFDC8515,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () => Get.dialog(const AddVendorDialog()),
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
                                  buttonName: "Vendor",
                                  color: whiteColor,
                                  shortcut: 'V',
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
                    onTap: () => Get.back(),
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
