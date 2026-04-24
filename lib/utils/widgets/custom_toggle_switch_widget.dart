import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final bool canRequestFocus;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF018B5A),
    this.inactiveColor = const Color(0xFFFC3A20),
    this.canRequestFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      // focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      child: Container(
        width: 32,
        height: 15,
        padding: const EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 2),
        decoration: ShapeDecoration(
          color: value ? activeColor : inactiveColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 11,
            height: 11,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
