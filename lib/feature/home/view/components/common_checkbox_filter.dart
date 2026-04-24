// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class CommonTextSwitchButton extends StatefulWidget {
  final String text;
  final bool initialChecked;
  final ValueChanged<bool>? onChanged;
  final Color? buttonColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double switchWidth;
  final double switchHeight;

  const CommonTextSwitchButton({
    super.key,
    required this.text,
    this.initialChecked = false,
    this.onChanged,
    this.buttonColor,
    this.textStyle,
    this.padding,
    this.switchWidth = 24.0,
    this.switchHeight = 16.0,
  });

  @override
  _CommonTextSwitchButtonState createState() => _CommonTextSwitchButtonState();
}

class _CommonTextSwitchButtonState extends State<CommonTextSwitchButton> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.initialChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widget.buttonColor,
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: widget.textStyle ?? const TextStyle(color: Colors.white),
            ),
            Transform.scale(
              scale: 0.5,
              child: Switch(
                activeColor: greenColor,
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(isSwitched);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
