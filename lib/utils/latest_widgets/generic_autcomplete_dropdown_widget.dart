import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class GenericAutocompleteDropdown<T extends Object> extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<T> items;
  final String Function(T) getDisplayValue;
  final Function(T) onSelected;
  final KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent;
  final bool enabled;
  final bool isLastRow;
  final String? labelText;
  final EdgeInsetsGeometry padding;
  final double fieldHeight;
  final double maxHeight;
  final double? maxWidthForOptions;
  final Color borderColor;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final void Function()? onTap;
  final Future<Iterable<T>> Function(TextEditingValue)? customOptionsBuilder;
  final bool autofocus;
  final Widget Function(T item)? itemBuilder;
  final void Function()? onEditingComplete;

  const GenericAutocompleteDropdown({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.items,
    required this.getDisplayValue,
    required this.onSelected,
    this.onKeyEvent,
    this.enabled = true,
    this.isLastRow = false,
    this.labelText,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    this.fieldHeight = 38.0,
    this.maxHeight = 150.0,
    this.maxWidthForOptions,
    this.borderColor = secondaryColor,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.customOptionsBuilder,
    this.autofocus = false,
    this.itemBuilder,
    this.onEditingComplete,
  });

  Iterable<T> defaultOptionsBuilder(TextEditingValue textEditingValue) {
    if (textEditingValue.text.isEmpty) {
      return items;
    }
    final searchText = textEditingValue.text.toLowerCase();
    return items.toList()..sort((a, b) {
      final aContains = getDisplayValue(a).toLowerCase().contains(searchText);
      final bContains = getDisplayValue(b).toLowerCase().contains(searchText);
      if (aContains && !bContains) return -1;
      if (!aContains && bContains) return 1;
      return getDisplayValue(
        a,
      ).toLowerCase().compareTo(getDisplayValue(b).toLowerCase());
    });
  }

  Widget _defaultItemBuilder(T item) {
    return SizedBox(
      width: double.infinity,
      child: CustomText(
        text: getDisplayValue(item),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.visible,
        maxLines: null,
      ),
    );
  }

  double getMaxWidthForOptions({required double biggestWidth}) {
    if (maxWidthForOptions != null) {
      // Always return the maximum of fieldWidth and maxWidthForOptions
      return maxWidthForOptions! > biggestWidth
          ? maxWidthForOptions!
          : biggestWidth;
    } else {
      return biggestWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Focus(
        canRequestFocus: false,
        onKeyEvent:
            onKeyEvent != null
                ? (node, event) => onKeyEvent!(node, event)
                : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Store the field width for use in optionsViewBuilder
            final fieldWidth = constraints.biggest.width;

            return RawAutocomplete<T>(
              focusNode: focusNode,
              textEditingController: controller,
              optionsViewBuilder: (context, onSelected, options) {
                // Calculate the desired width
                final desiredWidth = getMaxWidthForOptions(
                  biggestWidth: fieldWidth,
                );

                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: borderColor, width: 0.5),
                    ),
                    // Wrap with SizedBox to enforce width
                    child: SizedBox(
                      width: desiredWidth,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int optionIndex) {
                            final T item = options.elementAt(optionIndex);
                            return InkWell(
                              onTap: () {
                                log("I am here called");
                                onSelected(item);
                              },
                              child: Builder(
                                builder: (BuildContext context) {
                                  final bool highlight =
                                      AutocompleteHighlightedOption.of(
                                        context,
                                      ) ==
                                      optionIndex;
                                  if (highlight) {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((
                                          Duration timeStamp,
                                        ) {
                                          Scrollable.ensureVisible(
                                            context,
                                            alignment: 0.5,
                                          );
                                        });
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        color:
                                            highlight
                                                ? Theme.of(context).focusColor
                                                : Colors.white,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        child:
                                            itemBuilder?.call(item) ??
                                            _defaultItemBuilder(item),
                                      ),
                                      const CustomDashedLineWidget(
                                        width: double.infinity,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (customOptionsBuilder != null) {
                  return await customOptionsBuilder!(textEditingValue);
                }
                return defaultOptionsBuilder(textEditingValue);
              },
              displayStringForOption: getDisplayValue,
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                if (fieldFocusNode.hasFocus &&
                    textEditingController.text.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    textEditingController.text = ' ';
                    textEditingController
                        .selection = TextSelection.fromPosition(
                      const TextPosition(offset: 0),
                    );
                    textEditingController.text = '';
                  });
                }
                return KeyboardListener(
                  focusNode: FocusNode(canRequestFocus: false),
                  onKeyEvent: (KeyEvent event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.enter) {
                      // Call the onFieldSubmitted callback which should select the highlighted option
                      onFieldSubmitted();
                    }
                  },
                  child: TextFormField(
                    onTap: onTap,
                    enabled: enabled,
                    controller: textEditingController,
                    onEditingComplete: () {
                      // onEditingComplete();
                    },
                    focusNode: fieldFocusNode,
                    autofocus: autofocus,
                    keyboardType: keyboardType,
                    onFieldSubmitted: (val) {
                      onFieldSubmitted();
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Satoshi',
                    ),
                    validator: validator,
                    decoration: InputDecoration(
                      labelText: labelText,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: isLastRow ? borderColor : Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: isLastRow ? borderColor : Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: borderColor, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      errorStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
              onSelected: onSelected,
            );
          },
        ),
      ),
    );
  }
}
