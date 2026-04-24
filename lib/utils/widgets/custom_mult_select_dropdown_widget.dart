// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class CustomMultiSelectDropdown<T> extends StatefulWidget {
  final String name;
  final double width;
  final List<T> items;
  final List<T> selectedItems;
  final ValueChanged<List<T>> onChanged;
  final String Function(T) displayStringForOption;
  final FocusNode? focusNode;
  final String? Function(List<T>?)? validator;

  const CustomMultiSelectDropdown({
    super.key,
    required this.name,
    required this.width,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.displayStringForOption,
    this.focusNode,
    this.validator,
  });

  @override
  CustomMultiSelectDropdownState<T> createState() =>
      CustomMultiSelectDropdownState<T>();
}

class CustomMultiSelectDropdownState<T>
    extends State<CustomMultiSelectDropdown<T>> {
  late List<T> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  void didUpdateWidget(CustomMultiSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != oldWidget.selectedItems) {
      _selectedItems = List.from(widget.selectedItems);
    }
  }

  void _toggleItem(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
    widget.onChanged(_selectedItems);
  }

  String _getDisplayText() {
    if (_selectedItems.isEmpty) {
      return 'Select ${widget.name}';
    }

    const int maxChars = 30;
    String displayText = _selectedItems
        .map((item) => widget.displayStringForOption(item))
        .join(', ');

    if (displayText.length <= maxChars) {
      return displayText;
    } else {
      String truncatedText = displayText.substring(0, maxChars);
      int lastCommaIndex = truncatedText.lastIndexOf(',');
      if (lastCommaIndex != -1) {
        truncatedText = truncatedText.substring(0, lastCommaIndex);
      }
      return '$truncatedText... (+${_selectedItems.length - truncatedText.split(',').length})';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.name,
          color: blackColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          width: widget.width,
          child: DropdownButtonFormField<T>(
            focusNode: widget.focusNode,
            isExpanded: true,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              errorStyle: TextStyle(height: 0, color: Colors.transparent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            hint: Text(
              _getDisplayText(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: blackColor,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            style: const TextStyle(
              color: blackColor,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
            value: null,
            items:
                widget.items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: StatefulBuilder(
                      builder: (
                        BuildContext context,
                        StateSetter setMenuItemState,
                      ) {
                        return Row(
                          children: [
                            Checkbox(
                              value: _selectedItems.contains(item),
                              onChanged: (_) {
                                _toggleItem(item);
                                setMenuItemState(() {});
                              },
                            ),
                            Expanded(
                              child: Text(
                                widget.displayStringForOption(item),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
            onChanged: (item) {
              // Item selection is handled by checkbox
            },
            selectedItemBuilder: (BuildContext context) {
              return widget.items.map<Widget>((T item) {
                return Text(
                  _getDisplayText(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
          ),
        ),
        FormField<String>(
          validator: (_) {
            if (widget.validator != null) {
              return widget.validator!(_selectedItems);
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return state.hasError
                ? Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
