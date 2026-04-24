import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? name;
  final double width;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final FocusNode? focusNode;
  final double? nameFont;
  final Color? textColor;
  final String Function(T?)? itemAsString;
  final bool? enabled;
  final bool autofocus;
  const CustomDropdownField({
    super.key,
    this.name,
    required this.width,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.focusNode,
    this.nameFont,
    this.textColor,
    this.itemAsString,
    this.enabled,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name != null) ...[
          CustomText(
            text: name!,
            color: textColor ?? blackColor,
            fontWeight: FontWeight.w700,
            fontSize: nameFont ?? 12,
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          height: 38,
          width: width,
          child: DropdownButtonFormField<T>(
            focusNode: focusNode,
            autofocus: autofocus,
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: enabled == false ? grey2 : secondaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: enabled == false ? grey2 : secondaryColor,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: grey2),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            style: const TextStyle(
              color: blackColor,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
            value: selectedItem,
            items:
                items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: CustomText(
                      text:
                          itemAsString != null
                              ? itemAsString!(item)
                              : item.toString(),
                      color: blackColor,
                      fontSize: 16,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
            onChanged: enabled == false ? null : onChanged,
          ),
        ),
      ],
    );
  }
}
