import 'package:flutter/material.dart';

class CustomSearchableDropdownWidget<T> extends StatelessWidget {
  final FocusNode focusNode;
  final T? initialSelection;
  final TextEditingController? controller;
  final void Function(T? value) onSelected;
  final List<DropdownMenuEntry<T>> items;
  final double height;
  final double? dropdownHeight;
  final Color borderColor;
  final Color focusedBorderColor;
  final Widget? trailingIcon;
  final TextStyle? textStyle;
  final double? width;
  final bool enabled;

  const CustomSearchableDropdownWidget({
    super.key,
    required this.focusNode,
    required this.initialSelection,
    this.controller,
    required this.onSelected,
    required this.items,
    this.height = 38,
    this.dropdownHeight = 150,
    this.borderColor = Colors.transparent,
    this.focusedBorderColor = Colors.blue,
    this.trailingIcon,
    this.textStyle,
    this.width,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: DropdownMenu<T>(
        requestFocusOnTap: true,
        enabled: enabled,
        focusNode: focusNode,
        initialSelection: initialSelection,
        controller: controller,
        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          fixedSize: WidgetStatePropertyAll(
            Size.fromHeight(dropdownHeight!),
          ),
        ),
        onSelected: onSelected,
        dropdownMenuEntries: items,
        textStyle: textStyle ??
            const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
        expandedInsets: EdgeInsets.zero,
        trailingIcon: trailingIcon ??
            const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          constraints: BoxConstraints(
            maxHeight: height,
            minWidth: double.maxFinite,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
