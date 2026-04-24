import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  const CustomCheckBoxWidget({
    super.key,
    required this.onChanged,
    required this.value,
    this.focusNode,
  });
  final FocusNode? focusNode;
  final void Function(bool?)? onChanged;
  final bool? value;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      focusNode: focusNode,
      value: value,
      side: const BorderSide(color: primaryColor, width: 2),
      activeColor: secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      onChanged: onChanged,
    );
  }
}
