// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class TextWithShortcutButton extends StatelessWidget {
  final String text;
  final String controlKey;
  final String functionKey;
  final void Function()? onPressed;
  final Color textColor;
  final Color shortcutColor;
  final Color shortcutBackgroundColor;
  final void Function(TapDownDetails)? onTapDown;

  const TextWithShortcutButton({
    super.key,
    required this.text,
    required this.controlKey,
    required this.functionKey,
    this.onPressed,
    this.textColor = primaryColor,
    this.shortcutColor = primaryColor,
    this.shortcutBackgroundColor = const Color(0x19111111),
    this.onTapDown,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        onTapDown: onTapDown,
        borderRadius: BorderRadius.circular(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            _buildShortcutIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildKeyContainer(controlKey),
        const SizedBox(width: 2),
        Text(
          '+',
          style: TextStyle(
            color: shortcutColor,
            fontSize: 10,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            height: 0.21,
          ),
        ),
        const SizedBox(width: 2),
        _buildKeyContainer(functionKey),
      ],
    );
  }

  Widget _buildKeyContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: shortcutBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: shortcutColor,
          fontSize: 12,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
