import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class CustomDateField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Function(BuildContext context)? onTap;
  final bool readOnly;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;

  const CustomDateField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.onTap,
    this.readOnly = true,
    this.borderColor,
    this.contentPadding,
    this.focusNode,
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  late final FocusNode focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      focusNode = widget.focusNode!;
    } else {
      focusNode = FocusNode();
    }

    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    if (widget.onTap != null) {
      widget.onTap!(context);
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );

      if (picked != null) {
        widget.controller.text = "${picked.day}/${picked.month}/${picked.year}";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.labelText,
          color: primaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        InkWell(
          focusNode: focusNode,
          onTap: () => _showDatePicker(context),
          child: AbsorbPointer(
            child: CustomTextField(
              canRequestFocus: false,
              borderColor:
                  isFocused ? secondaryColor : widget.borderColor ?? grey1,
              contentPadding: widget.contentPadding,
              readOnly: widget.readOnly,
              suffixIcon: Icon(
                Icons.calendar_month_outlined,
                color: isFocused ? secondaryColor : Colors.grey,
              ),
              controller: widget.controller,
              validator:
                  widget.validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "${widget.labelText} missing";
                    }
                    return null;
                  },
            ),
          ),
        ),
      ],
    );
  }
}
