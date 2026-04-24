// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:flutter/material.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class ButtonShortcutWidget extends StatelessWidget {
  void Function()? onTap;
  final String buttonName;
  final String shortcut;
  final Color color;
  Color? shortcutButtonBackgroundColor;
  Color? shortcutButtonColor;
  double? buttonsize;
  final FocusNode? focusNode;
  final bool canRequestFocus;

  ButtonShortcutWidget({
    super.key,
    this.onTap,
    required this.buttonName,
    required this.shortcut,
    required this.color,
    this.shortcutButtonBackgroundColor,
    this.shortcutButtonColor,
    this.buttonsize,
    this.focusNode,
    this.canRequestFocus = true,
  });

  @override
  Widget build(BuildContext context) {
    List<String> shortcutParts =
        shortcut.split('+').map((e) => e.trim()).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          focusNode: focusNode,
          canRequestFocus: canRequestFocus,
          child: Ink(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: buttonName,
                  color: color,
                  fontSize: buttonsize ?? 12,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(width: 8),
                Row(
                  children:
                      shortcutParts.asMap().entries.map((entry) {
                        int index = entry.key;
                        String part = entry.value;
                        return Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: shortcutButtonBackgroundColor ?? grey2,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: CustomText(
                                text: part,
                                color: shortcutButtonColor ?? color,
                                fontSize: 10,
                              ),
                            ),
                            if (index < shortcutParts.length - 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: CustomText(
                                  text: "+",
                                  color: color,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
