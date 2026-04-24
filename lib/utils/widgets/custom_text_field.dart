import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class CustomTextField extends StatefulWidget {
  final String? name;
  final double? width;
  final double? height;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? enabled;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? nameColor;
  final double? nameFontSize;
  final Color? borderColor;
  final AutovalidateMode? autovalidateMode;
  final bool capitalizeText;
  final Color? fillColor;
  final bool? filled;
  final bool showSizedBox;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool readOnly;
  final bool canRequestFocus;
  final void Function()? onTap;
  final bool isRequired;
  final void Function()? onEditingComplete;
  final bool obscureText;

  const CustomTextField({
    super.key,
    this.name,
    this.width,
    this.height,
    this.hintText,
    this.controller,
    this.validator,
    this.enabled,
    this.onChanged,
    this.suffixIcon,
    this.focusNode,
    this.autofocus = false,
    this.nameColor,
    this.nameFontSize,
    this.borderColor,
    this.autovalidateMode,
    this.capitalizeText = false,
    this.fillColor,
    this.filled,
    this.showSizedBox = true,
    this.keyboardType,
    this.prefixIcon,
    this.inputFormatters,
    this.maxLines = 1,
    this.readOnly = false,
    this.canRequestFocus = true,
    this.onTap,
    this.isRequired = false,
    this.obscureText = false,
    EdgeInsetsGeometry? contentPadding,
    this.onEditingComplete,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // late TextEditingController _effectiveController;
  // @override
  // void initState() {
  //   super.initState();
  //   _effectiveController = widget.controller ?? TextEditingController();
  // }

  // @override
  // void dispose() {
  //   if (widget.controller == null) {
  //     _effectiveController.dispose();
  //   }
  //   super.dispose();
  // }

  // void _handleOnChanged(String value) {
  //   if (widget.capitalizeText) {
  //     final capitalizedValue = value.toUpperCase();
  //     _effectiveController.value = TextEditingValue(
  //       text: capitalizedValue,
  //       selection: TextSelection.collapsed(offset: capitalizedValue.length),
  //     );
  //     widget.onChanged?.call(capitalizedValue);
  //   } else {
  //     widget.onChanged?.call(value);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.name != null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: widget.name ?? "",
                color: widget.nameColor ?? blackColor,
                fontWeight: FontWeight.w700,
                fontSize: widget.nameFontSize ?? 12,
              ),
              if (widget.isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        if (widget.showSizedBox) const SizedBox(height: 8),
        SizedBox(
          width: widget.width,
          child: TextFormField(
            onEditingComplete: widget.onEditingComplete,
            onTap: widget.onTap,
            canRequestFocus: widget.canRequestFocus,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            autovalidateMode: widget.autovalidateMode,
            controller: widget.controller,
            validator: widget.validator,
            enabled: widget.enabled,
            textAlignVertical: TextAlignVertical.center,
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            obscureText: widget.obscureText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Satoshi',
            ),
            textCapitalization:
                widget.capitalizeText
                    ? TextCapitalization.characters
                    : TextCapitalization.none,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              //  isDense: true,
              fillColor: widget.fillColor,
              filled: widget.filled,
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon,
              hintStyle: const TextStyle(color: Colors.grey),
              isCollapsed: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 12.0,
              ),

              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? secondaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? secondaryColor,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              // errorBorder: OutlineInputBorder(
              //   borderSide: BorderSide(
              //       color: borderColor ?? secondaryColor, width: 1.0),
              //   borderRadius:
              //       const BorderRadius.all(Radius.circular(10.0)),
              // ),
              // errorStyle: const TextStyle(
              //   color: redTextColor,
              //   fontSize: 0,
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
