import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

class GenericAttentionDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<DialogAction> actions;
  final VoidCallback? onClose;

  const GenericAttentionDialog({
    super.key,
    this.title = 'Attention!',
    required this.message,
    required this.actions,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Actions(
        actions: <Type, Action<Intent>>{
          CloseDialogIntent: CallbackAction<CloseDialogIntent>(
            onInvoke: (intent) {
              log("close escape pressed");
              Get.back();
              // onClose?.call();
              return null;
            },
          ),
          MoveToNextScreenIntent: CallbackAction<MoveToNextScreenIntent>(
            onInvoke: (intent) {
              log("close enter pressed");
              if (actions.isNotEmpty) {
                actions[1].onPressed();
              }
              // actions.;
              return;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.escape): const CloseDialogIntent(),
            LogicalKeySet(LogicalKeyboardKey.enter):
                const MoveToNextScreenIntent(),
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
                      CustomText(
                        text: title,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text: message,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: blackColor,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children:
                            actions
                                .map(
                                  (action) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: _buildActionButton(action),
                                  ),
                                )
                                .toList(),
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
                      onClose?.call();
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

  Widget _buildActionButton(DialogAction action) {
    return InkWell(
      onTap: () {
        // Get.back();
        action.onPressed();
      },
      child: Container(
        height: 38,
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: action.isDefault ? primaryColor : grey1,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: ButtonShortcutWidget(
            buttonName: action.text,
            color: action.isDefault ? whiteColor : primaryColor,
            shortcut: action.shortcut,
            shortcutButtonBackgroundColor: grey1,
            shortcutButtonColor: primaryColor,
          ),
        ),
      ),
    );
  }
}

class DialogAction {
  final String text;
  final VoidCallback onPressed;
  final bool isDefault;
  final String shortcut;

  const DialogAction({
    required this.text,
    required this.onPressed,
    this.isDefault = false,
    this.shortcut = '',
  });
}

// Define a custom intent for closing the dialog
class CloseDialogIntent extends Intent {
  const CloseDialogIntent();
}
