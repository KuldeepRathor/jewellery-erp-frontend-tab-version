import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view_model/online_only_design_table_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class OnlineDesignTableWidget extends StatefulWidget {
  const OnlineDesignTableWidget({super.key});

  @override
  State<OnlineDesignTableWidget> createState() =>
      _OnlineDesignTableWidgetState();
}

class _OnlineDesignTableWidgetState extends State<OnlineDesignTableWidget> {
  final controller = Get.find<OnlineOnlyTableController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildTableContent()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onNormalKeyEvent(node, event, []),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Stock Quantity',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              _buildActionButton(
                label: '+ Add',
                shortcut: 'Enter',
                textColor: const Color(0xFF28328B),
                backgroundColor: const Color(0x1928328B),
                onTap: () => controller.addRow(),
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                label: 'Remove',
                shortcut: 'Esc',
                textColor: const Color(0xFFFC3A20),
                backgroundColor: const Color(0x19FC3A20),
                onTap:
                    () => controller.removeRow(
                      index: controller.controllers.length - 1,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    return Obx(() {
      return CustomTableWidget(
        headers: [_buildTableHeaders()],
        columnWidths: controller.columnWidths,
        rows: _buildRows(),
        isLoadingMore: false,
        controller: controller.scrollController,
        addSizedBox: false,
      );
    });
  }

  TableRow _buildTableHeaders() {
    return TableRow(
      children:
          controller.headers
              .map(
                (header) => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  color: secondaryColor,
                  child: CustomText(
                    text: header,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Satoshi",
                  ),
                ),
              )
              .toList(),
    );
  }

  List<TableRow> _buildRows() {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index: index),
    );
  }

  TableRow _buildTableRow({required int index}) {
    final row = controller.controllers[index];

    return TableRow(
      children: [
        // Pcs - Required field
        _buildTextFieldCell(
          controller: row.pcs,
          focusNode: row.tableFocusNodes[0],
          index: index,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pcs is required';
            }
            final pcs = int.tryParse(value);
            if (pcs == null || pcs <= 0) {
              return 'Invalid value';
            }
            return null;
          },
          onChanged: (value) => controller.updateTotals(),
        ),

        // Weight/pc
        _buildTextFieldCell(
          controller: row.weightPc,
          focusNode: row.tableFocusNodes[1],
          index: index,
          keyboardType: TextInputType.number,
          inputFormatters: [WeightInputFormatter()],
          onChanged: (value) => controller.updateTotals(),
        ),

        // Size
        _buildTextFieldCell(
          controller: row.size,
          focusNode: row.tableFocusNodes[2],
          index: index,
          keyboardType: TextInputType.text,
        ),

        // Amount/pc - Required field
        _buildTextFieldCell(
          controller: row.amountPc,
          focusNode: row.tableFocusNodes[3],
          index: index,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Amount/pc is required';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Invalid amount';
            }
            return null;
          },
          onChanged: (value) => controller.updateTotals(),
        ),

        // Undiscounted Amount
        _buildTextFieldCell(
          controller: row.undiscountedAmount,
          focusNode: row.tableFocusNodes[4],
          index: index,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          onChanged: (value) => controller.updateTotals(),
        ),

        // Delete button
        _buildDeleteCell(onDelete: () => controller.removeRow(index: index)),
      ],
    );
  }

  Widget _buildTextFieldCell({
    required TextEditingController controller,
    required FocusNode focusNode,
    required int index,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
        child: TextFormField(
          onTap: () {
            this.controller.currentRowIndex.value = index;
            this.controller.currentColIndex.value = this
                .controller
                .controllers[index]
                .tableFocusNodes
                .indexOf(focusNode);
          },
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          decoration: _getInputDecoration(index: index),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration({required int index}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      isDense: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:
              controller.controllers.length == index + 1
                  ? secondaryColor
                  : Colors.transparent,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: secondaryColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

  Widget _buildDeleteCell({required VoidCallback onDelete}) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 28,
            color: redTextColor,
          ),
          onPressed: onDelete,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // TableRow? _buildFooterRow() {
  //   return controller.totalHeadersValue.isNotEmpty
  //       ? TableRow(
  //           children: controller.totalHeadersValue
  //               .map((total) => Container(
  //                     padding: const EdgeInsets.symmetric(
  //                         vertical: 8, horizontal: 4),
  //                     decoration: const BoxDecoration(
  //                       border: Border(
  //                         top: BorderSide(color: Color(0xFFE5E5E5)),
  //                       ),
  //                     ),
  //                     child: CustomText(
  //                       text: total,
  //                       color: Colors.black,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w700,
  //                       fontFamily: "Satoshi",
  //                     ),
  //                   ))
  //               .toList(),
  //         )
  //       : null;
  // }

  Widget _buildActionButton({
    required String label,
    required String shortcut,
    required Color textColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              shortcut,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        controller.currentColIndex.value = 0;
        controller.controllers[rowIndex].tableFocusNodes[0].requestFocus();
        controller.resetRow(rowIndex);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  };
}
