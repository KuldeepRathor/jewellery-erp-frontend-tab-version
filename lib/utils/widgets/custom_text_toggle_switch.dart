import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class CustomTextToggleSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final String Yes;
  final String No;

  final bool canRequestFocus;

  const CustomTextToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.canRequestFocus = false,
    required this.Yes,
    required this.No,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      canRequestFocus: canRequestFocus,
      child: Container(
        width: 60,
        height: 24,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            value ? Yes : No,
            style: const TextStyle(
              color: secondaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
