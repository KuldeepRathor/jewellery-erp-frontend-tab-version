import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view_model/size_group_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class SizeGroupTable extends StatelessWidget {
  SizeGroupTable({super.key});

  final SizeGroupController controller = Get.put(SizeGroupController());
  KeyEventResult onTableKeyEvent(FocusNode node, KeyEvent event, int rowIndex) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.6375,
      // constraints: BoxConstraints(maxWidth: 800),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => _buildToggleOption(
                            'Required',
                            controller.isRequired.value,
                            controller.toggleRequired,
                            focusNode: FocusNode(),
                          ),
                        ),
                        const Spacer(),
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
                        SizedBox(width: Get.width * 0.4),
                      ],
                    ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE6E8FF)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 110, minWidth: 70),
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

  TableRow _buildTableRow(int index, SizeGroupController controller) {
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
          textController: controller.rows[index].size,
          header: controller.headers[1],
          rowIndex: index,
          colIndex: 1,
          controller: controller,
          focusNode: controller.rows[index].focusNodes[1],
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
    required SizeGroupController controller,
    required FocusNode focusNode,
  }) {
    if (colIndex == 0) {
      // Code column
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Focus(
          canRequestFocus: false,
          onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
          child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]*$')),
            ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
        child: TextFormField(
          inputFormatters: [
            header == "Size (mm)"
                ? FilteringTextInputFormatter.allow(
                  RegExp(r'.*'),
                ) // Allows everything
                : (FilteringTextInputFormatter.allow(
                  RegExp(r'^[a-zA-Z0-9]*$'),
                )),
          ],
          controller: textController,
          focusNode: focusNode,
          keyboardType:
              header == "Size (mm)" ? TextInputType.number : TextInputType.text,
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
            if (header == "Size (mm)" && double.tryParse(value) == null) {
              return 'Please enter a valid number';
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
}
