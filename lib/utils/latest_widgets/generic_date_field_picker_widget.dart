import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class GenericDateField extends StatefulWidget {
  final String label;
  final double width;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(BuildContext context, TextEditingController controller)?
  onDateSelect;
  final Color labelColor;
  final double labelSize;
  final FontWeight labelWeight;
  final Color? iconColor;
  final Color focusedIconColor;
  final FocusNode? focusNode;

  const GenericDateField({
    super.key,
    required this.label,
    required this.controller,
    this.width = 250,
    this.validator,
    this.onDateSelect,
    this.labelColor = primaryTextColor,
    this.labelSize = 12,
    this.labelWeight = FontWeight.w700,
    this.iconColor = Colors.grey,
    this.focusedIconColor = secondaryColor,
    this.focusNode,
  });

  @override
  State<GenericDateField> createState() => _GenericDateFieldState();
}

class _GenericDateFieldState extends State<GenericDateField> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: widget.labelColor,
            fontSize: widget.labelSize,
            fontWeight: widget.labelWeight,
          ),
        ),
        InkWell(
          focusNode: _focusNode,
          onTap:
              widget.onDateSelect != null
                  ? () => widget.onDateSelect!(context, widget.controller)
                  : null,
          child: AbsorbPointer(
            child: CustomTextField(
              controller: widget.controller,
              canRequestFocus: false,
              validator: widget.validator,
              suffixIcon: Icon(
                Icons.calendar_month_outlined,
                color: isFocused ? widget.focusedIconColor : widget.iconColor,
              ),
              width: widget.width,
            ),
          ),
        ),
      ],
    );
  }
}
