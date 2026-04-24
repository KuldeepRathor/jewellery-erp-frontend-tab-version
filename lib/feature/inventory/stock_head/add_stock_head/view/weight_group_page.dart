import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view_model/weight_group_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class WeightGroupTable extends StatefulWidget {
  const WeightGroupTable({super.key});

  @override
  State<WeightGroupTable> createState() => _WeightGroupTableState();
}

class _WeightGroupTableState extends State<WeightGroupTable> {
  final FocusNode nettWtFocusNode = FocusNode();
  final FocusNode grossWtFocusNode = FocusNode();

  @override
  void dispose() {
    nettWtFocusNode.dispose();
    grossWtFocusNode.dispose();
    super.dispose();
  }

  final WeightGroupController controller = Get.put(WeightGroupController());
  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          controller.moveNextFocus();
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab &&
          HardwareKeyboard.instance.isShiftPressed) {
        controller.movePreviousFocus(node);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        controller.moveNextFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        return controller.moveFocus(
          KeyEventResult.handled,
          LogicalKeyboardKey.arrowUp,
          nextFocusNode: node,
          previousFocusNode: node,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        return controller.moveFocus(
          KeyEventResult.handled,
          LogicalKeyboardKey.arrowDown,
          nextFocusNode: node,
          previousFocusNode: node,
        );
      }

      if (event.logicalKey == LogicalKeyboardKey.escape &&
          HardwareKeyboard.instance.isShiftPressed) {
        controller.removeCurrentRow(rowIndex);
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        controller.currentColIndex.value = 0;
        controller.rows[rowIndex].focusNodes[0].requestFocus();
        controller.resetRow(rowIndex);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.6375,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => _buildToggleOption(
                        "Nett Wt",
                        controller.isNettWtSelected.value,
                        () => controller.toggleWeightType(true),
                        focusNode: nettWtFocusNode,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => _buildToggleOption(
                        "Gross Wt",
                        !controller.isNettWtSelected.value,
                        () => controller.toggleWeightType(false),
                        focusNode: grossWtFocusNode,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     const Text(
                    //       "Required",
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         fontFamily: 'Satoshi',
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //     Obx(
                    //       () => Transform.scale(
                    //         scale: 0.6,
                    //         child: Switch(
                    //           value: controller.isRequired.value,
                    //           onChanged: (value) => controller.toggleRequired(),
                    //           activeColor: whiteColor,
                    //           activeTrackColor: totalGreenColor,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const Spacer(),
                    // SizedBox(
                    //   width: 100,
                    // ),
                    ButtonShortcutWidget(
                      onTap: controller.validateAndAddRow,
                      buttonName: "+ Add",
                      shortcut: "Enter",
                      color: primaryColor,
                      shortcutButtonBackgroundColor: shortcutGreyColor,
                      canRequestFocus: false,
                    ),
                    ButtonShortcutWidget(
                      onTap: controller.removeLastRow,
                      buttonName: "Remove",
                      shortcut: "Shift+Esc",
                      color: redTextColor,
                      shortcutButtonBackgroundColor: shortcutRedColor,
                      canRequestFocus: false,
                    ),
                    const SizedBox(width: 200),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => CustomTableWidget(
                      headers: [_buildTableHeaders()],
                      columnWidths: controller.columnWidths,
                      rows: _buildRows(),
                      addSizedBox: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String label,
    bool value,
    VoidCallback onToggle, {
    required FocusNode focusNode,
  }) {
    // log("Focus is ${focusNode.hasFocus}");
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        focusNode: focusNode,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color:
                    focusNode.hasPrimaryFocus
                        ? Colors.blue
                        : const Color(0xFFE6E8FF),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 70),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomToggleSwitch(
                canRequestFocus: false,
                value: value,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableHeaders() {
    return TableRow(
      children:
          controller.headers.map((header) {
            return Container(
              width: Get.width,
              padding: const EdgeInsets.only(left: 6),
              child: CustomText(
                text: header,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            );
          }).toList(),
    );
  }

  List<TableRow> _buildRows() {
    return List.generate(
      controller.rows.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(int index, WeightGroupController controller) {
    return TableRow(
      children: [
        _buildCell(
          textController: controller.rows[index].code,
          header: controller.headers[0],
          rowIndex: index,
          colIndex: 0,
          controller: controller,
          focusNode: controller.rows[index].focusNodes[0],
        ),
        _buildCell(
          textController: controller.rows[index].name,
          header: controller.headers[1],
          rowIndex: index,
          colIndex: 1,
          controller: controller,
          focusNode: controller.rows[index].focusNodes[1],
        ),
        _buildWeightCell(
          minController: controller.rows[index].minWeight,
          maxController: controller.rows[index].maxWeight,
          header: controller.headers[2],
          rowIndex: index,
          controller: controller,
          minFocusNode: controller.rows[index].focusNodes[2],
          maxFocusNode: controller.rows[index].focusNodes[3],
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            // horizontal: 8,
            vertical: 5,
          ),
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 22),
            onPressed: () => controller.removeCurrentRow(index),
          ),
        ),
      ],
    );
  }

  Widget _buildCell({
    required TextEditingController textController,
    required String header,
    required int rowIndex,
    required int colIndex,
    required WeightGroupController controller,
    required FocusNode focusNode,
  }) {
    if (colIndex == 0) {
      // Code column
      return Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: TextFormField(
            controller: textController,
            focusNode: focusNode,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              isDense: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      controller.rows.length == rowIndex + 1
                          ? secondaryColor
                          : Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              suffixIcon: Obx(() {
                if (controller.isCheckingCode['$rowIndex'] == true) {
                  return const SizedBox(
                    width: 10,
                    height: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 4),
                    ),
                  );
                }
                if (textController.text.isNotEmpty) {
                  if (controller.codeAvailability['$rowIndex'] == false) {
                    return const Icon(Icons.error, color: Colors.red);
                  }
                  if (controller.codeAvailability['$rowIndex'] == true) {
                    return const Icon(Icons.check_circle, color: Colors.green);
                  }
                }
                return const SizedBox.shrink();
              }),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            onChanged: (value) {
              final capitalizedValue = value.toUpperCase();
              final currentCursorPosition = textController.selection.baseOffset;
              textController.value = TextEditingValue(
                text: capitalizedValue,
                selection: TextSelection.collapsed(
                  offset: currentCursorPosition,
                ),
              );
              controller.checkCodeAvailability(capitalizedValue, rowIndex);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $header';
              }
              if (controller.codeAvailability['$rowIndex'] == false) {
                return 'Code already exists';
              }
              if (!controller.isCodeUniqueLocally(value, rowIndex)) {
                return 'Code must be unique';
              }
              return null;
            },
            onTap: () {
              controller.currentRowIndex.value = rowIndex;
              controller.currentColIndex.value = colIndex;
            },
          ),
        ),
      );
    }
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: TextFormField(
          controller: textController,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            isDense: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    controller.rows.length == rowIndex + 1
                        ? secondaryColor
                        : Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $header';
            }
            return null;
          },
          onTap: () {
            controller.currentRowIndex.value = rowIndex;
            controller.currentColIndex.value = colIndex;
          },
        ),
      ),
    );
  }

  Widget _buildWeightCell({
    required TextEditingController minController,
    required TextEditingController maxController,
    required String header,
    required int rowIndex,
    required WeightGroupController controller,
    required FocusNode minFocusNode,
    required FocusNode maxFocusNode,
  }) {
    bool isFirstRow = rowIndex == 0;
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 38,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      controller.rows.length == rowIndex + 1
                          ? secondaryColor
                          : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [WeightInputFormatter()],
                      enabled: !isFirstRow,
                      controller: minController,
                      focusNode: minFocusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "min",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        isDense: true,
                        border: InputBorder.none,
                        errorStyle: TextStyle(
                          height: 0,
                        ), // Hide individual error
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        if (isFirstRow && value != "0.001") {
                          minController.text = "0.001";
                          minController.selection =
                              const TextSelection.collapsed(offset: 5);
                        } else {
                          setState(() {});
                        }
                      },
                      validator: (value) {
                        if (isFirstRow) return null;
                        return _validateMin(
                          value ?? '',
                          maxController.text,
                          rowIndex,
                        );
                      },
                      onTap: () {
                        controller.currentRowIndex.value = rowIndex;
                        controller.currentColIndex.value = 2;
                        // Select all text when tapped
                        minController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: minController.text.length,
                        );
                      },
                    ),
                  ),
                  const CustomText(text: "-"),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [WeightInputFormatter()],
                      controller: maxController,
                      focusNode: maxFocusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "max",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        isDense: true,
                        border: InputBorder.none,
                        errorStyle: TextStyle(
                          height: 0,
                        ), // Hide individual error
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        setState(() {}); // Trigger rebuild to show validation
                      },
                      validator: (value) {
                        return _validateMax(
                          minController.text,
                          value ?? '',
                          rowIndex,
                        );
                      },
                      onTap: () {
                        controller.currentRowIndex.value = rowIndex;
                        controller.currentColIndex.value = 3;
                        // Select all text when tapped
                        maxController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: maxController.text.length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Combined error text below the container
            if (_validateMin(
                      minController.text,
                      maxController.text,
                      rowIndex,
                    ) !=
                    null ||
                _validateMax(
                      minController.text,
                      maxController.text,
                      rowIndex,
                    ) !=
                    null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  _validateMin(
                        minController.text,
                        maxController.text,
                        rowIndex,
                      ) ??
                      _validateMax(
                        minController.text,
                        maxController.text,
                        rowIndex,
                      ) ??
                      '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? _validateMin(String minValue, String maxValue, int rowIndex) {
    if (minValue.isEmpty) return null;

    final double? min = double.tryParse(minValue);
    final double? max = double.tryParse(maxValue);

    if (min == null) return 'Invalid';

    // Basic validation
    if (max != null && min >= max) return 'Min ≥ Max';

    // Only validate overlap if we have both values
    if (max != null) {
      // Get current row index from controller
      // final rowIndex = controller.currentRowIndex.value;
      return controller.validateWeightRange(minValue, maxValue, rowIndex);
    }

    return null;
  }

  String? _validateMax(String minValue, String maxValue, int rowIndex) {
    if (maxValue.isEmpty) return null;

    final double? min = double.tryParse(minValue);
    final double? max = double.tryParse(maxValue);

    if (max == null) return 'Invalid';

    // Basic validation
    if (min != null && min >= max) return 'Min ≥ Max';

    // Only validate overlap if we have both values
    if (min != null) {
      // Get current row index from controller

      return controller.validateWeightRange(minValue, maxValue, rowIndex);
    }

    return null;
  }
}

class CheckboxToggle extends StatelessWidget {
  final String label;
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const CheckboxToggle({
    super.key,
    required this.label,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isChecked ? Colors.black : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? primaryColor : Colors.white,
                border: Border.all(
                  color: isChecked ? primaryColor : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child:
                  isChecked
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
