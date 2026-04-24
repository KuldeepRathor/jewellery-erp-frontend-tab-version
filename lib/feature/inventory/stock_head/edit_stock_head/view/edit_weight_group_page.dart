import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/view_model/edit_weight_group_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class EditWeightGroupTable extends StatefulWidget {
  const EditWeightGroupTable({super.key});

  @override
  State<EditWeightGroupTable> createState() => _EditWeightGroupTableState();
}

class _EditWeightGroupTableState extends State<EditWeightGroupTable> {
  final EditWeightGroupController controller = Get.put(
    EditWeightGroupController(),
  );
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
                      () => CheckboxToggle(
                        label: 'Nett Wt',
                        isChecked: controller.isNettWtSelected.value,
                        onChanged: (value) {
                          if (value) controller.toggleWeightType(true);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => CheckboxToggle(
                        label: 'Gross Wt',
                        isChecked: !controller.isNettWtSelected.value,
                        onChanged: (value) {
                          if (value) controller.toggleWeightType(false);
                        },
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
                    ),
                    ButtonShortcutWidget(
                      onTap: controller.removeLastRow,
                      buttonName: "Remove",
                      shortcut: "Shift+Esc",
                      color: redTextColor,
                      shortcutButtonBackgroundColor: shortcutRedColor,
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

  TableRow _buildTableRow(int index, EditWeightGroupController controller) {
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
          // child: IconButton(
          //   icon: const Icon(
          //     Icons.delete,
          //     color: Colors.red,
          //     size: 22,
          //   ),
          //   onPressed: () => controller.removeCurrentRow(index),
          // ),
        ),
      ],
    );
  }

  Widget _buildCell({
    required TextEditingController textController,
    required String header,
    required int rowIndex,
    required int colIndex,
    required EditWeightGroupController controller,
    required FocusNode focusNode,
  }) {
    if (colIndex == 0) {
      // Code column
      return Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
    required EditWeightGroupController controller,
    required FocusNode minFocusNode,
    required FocusNode maxFocusNode,
  }) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Container(
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  controller: minController,
                  focusNode: minFocusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "min",
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    errorText: _validateMin(
                      minController.text,
                      maxController.text,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
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
                    setState(() {}); // Trigger rebuild to show validation
                  },
                  onTap: () {
                    controller.currentRowIndex.value = rowIndex;
                    controller.currentColIndex.value =
                        2; // Index for min weight
                  },
                ),
              ),
              const CustomText(text: "-"),
              Expanded(
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  controller: maxController,
                  focusNode: maxFocusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "max",
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    errorText: _validateMax(
                      minController.text,
                      maxController.text,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
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
                  onTap: () {
                    controller.currentRowIndex.value = rowIndex;
                    controller.currentColIndex.value =
                        3; // Index for max weight
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateMin(String minValue, String maxValue) {
    if (minValue.isEmpty) return null;

    final double? min = double.tryParse(minValue);
    final double? max = double.tryParse(maxValue);

    if (min == null) return 'Invalid';
    if (max != null && min > max) return 'Min > Max';

    return null;
  }

  String? _validateMax(String minValue, String maxValue) {
    if (maxValue.isEmpty) return null;

    final double? min = double.tryParse(minValue);
    final double? max = double.tryParse(maxValue);

    if (max == null) return 'Invalid';
    if (min != null && min > max) return 'Min > Max';

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
