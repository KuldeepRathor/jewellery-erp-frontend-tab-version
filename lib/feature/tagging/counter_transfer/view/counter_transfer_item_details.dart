// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view_model/counter_transfer_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class CounterTransferItemDetails extends StatefulWidget {
  const CounterTransferItemDetails({super.key});

  @override
  State<CounterTransferItemDetails> createState() =>
      _CounterTransferItemDetailsState();
}

class _CounterTransferItemDetailsState
    extends State<CounterTransferItemDetails> {
  final CounterTransferItemDetailsController controller = Get.put(
    CounterTransferItemDetailsController(),
  );

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");
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
        controller.movePreviousFocus();
        // controller.movePreviousFocus(node);
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
        controller.controllers[rowIndex].tableFocusNodes[0].requestFocus();
        controller.resetRow(rowIndex);
      }
    }
    return KeyEventResult.ignored;
  };

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: const <Type, Action<Intent>>{
        // AddPurchaseDetailsIntent: CallbackAction<AddPurchaseDetailsIntent>(
        //   onInvoke: (intent) => controller.validateAndAddRow(),
        // ),
        // MoveToNextScreenIntent: CallbackAction<MoveToNextScreenIntent>(
        //   onInvoke: (intent) async {
        //     bool value = controller.validateRow();
        //     if (value == true) {
        //       bool dialogValue = await Get.dialog(AttentionDialog());
        //       if (dialogValue == true) {
        //         Get.dialog(PaymentDetailsDialog());
        //       }
        //     }
        //     return;
        //   },
        // ),
      },
      child: Shortcuts(
        shortcuts: const <LogicalKeySet, Intent>{
          // LogicalKeySet(LogicalKeyboardKey.enter):
          //     const AddPurchaseDetailsIntent(),
          // LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
          //     const MoveToNextScreenIntent(),
        },
        child: Container(
          width: double.infinity,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: 'Item Details',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const Spacer(),
                        ButtonShortcutWidget(
                          onTap: () => controller.validateAndAddRow(),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => CustomTableWidget(
                          headers: [_buildTableHeaders(controller)],
                          columnWidths: controller.columnWidths,
                          rows: _buildRows(controller),
                          controller: controller.scrollController,
                          addSizedBox: false,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Obx(
                      () => ItemListHeaderTable(
                        headers: controller.totalHeadersValue.toList(),
                        columnWidthsCustom: getColumnWidths(
                          columnWidths: controller.totalColumnWidths,
                          context: context,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: totalGreenColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getTooltipMessage(String header) {
    if (header == "Stone (₹)") {
      return "Alt + D to add Stone details";
    } else {
      return "Alt + C or Double Click to Change";
    }
  }

  TableRow _buildTableHeaders(CounterTransferItemDetailsController controller) {
    List<Widget> cells = [];

    for (int i = 0; i < controller.headers.length; i++) {
      String header = controller.headers.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sn") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: controller.headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Visibility(
              visible:
                  header == 'WST/Tch' ||
                  // header == 'MC (₹)' ||
                  header == 'Stone (₹)',
              child: Tooltip(
                message: getTooltipMessage(header),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: toolTipBgColor,
                ),
                triggerMode: TooltipTriggerMode.tap,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  List<TableRow> _buildRows(CounterTransferItemDetailsController controller) {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(
    int index,
    CounterTransferItemDetailsController controller,
  ) {
    List<Widget> cells = [
      _buildCell(
        text: (index + 1).toString(),
        editable: false,
        controller: controller,
      ),
      // _buildCodeDropdown(
      //   index: index,
      //   controller: controller,
      //   focusNode: controller.controllers[index].tableFocusNodes[0],
      // ),
      _buildCell(
        textController: controller.controllers[index].existingTagNumber,
        header: controller.headers[1],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[0],
      ),
      // _buildCell(
      //   textController: controller.controllers[index].counterNumber,
      //   header: controller.headers[2],
      //   rowIndex: index,
      //   controller: controller,
      //   focusNode: controller.controllers[index].tableFocusNodes[1],
      // ),
      _buildCell(
        textController: controller.controllers[index].description,
        header: controller.headers[2],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[1],
      ),
      _buildCell(
        textController: controller.controllers[index].gwt,
        header: controller.headers[3],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[2],
      ),
      _buildCell(
        textController: controller.controllers[index].nwt,
        header: controller.headers[4],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[3],
      ),
      _buildCell(
        textController: controller.controllers[index].stoneCost,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),

      _buildCell(
        textController: controller.controllers[index].totalCost,
        header: controller.headers[6],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[5],
      ),
    ];

    cells.add(_buildMoreOptionsCell(index, controller));

    return TableRow(children: cells);
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    required CounterTransferItemDetailsController controller,
    FocusNode? focusNode,
  }) {
    return Container(
      child:
          editable
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: GestureDetector(
                  child: Focus(
                    canRequestFocus: false,
                    onKeyEvent:
                        (node, event) => onTableKeyEvent(node, event, rowIndex),
                    child: Focus(
                      canRequestFocus: false,
                      onKeyEvent: (node, event) {
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.keyD &&
                            HardwareKeyboard.instance.isAltPressed &&
                            header == 'Stone (₹)') {
                          // controller.showStoneDialog(rowIndex);
                          // return KeyEventResult.handled;
                        }
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.keyC &&
                            HardwareKeyboard.instance.isAltPressed &&
                            header == 'WST/Tch') {
                          print("Changeing values ");
                          // controller.changeWstUnit(index: rowIndex);
                          controller.updateTotals();
                          // controller.updateRowAmount(rowIndex);
                          setState(() {});

                          return KeyEventResult.handled;
                        }
                        return KeyEventResult.ignored;
                      },
                      // onKey: (RawKeyEvent event) {
                      //   if (event is RawKeyDownEvent &&
                      //       event.logicalKey == LogicalKeyboardKey.keyD &&
                      //       event.isAltPressed &&
                      //       header == 'Stone (₹)') {
                      //     controller.showStoneDialog(rowIndex);
                      //   }
                      // },
                      child: Obx(
                        () => TextFormField(
                          controller: textController,
                          focusNode: focusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            header == 'G.Wt. (gm)' || header == 'N.Wt. (gm)'
                                ? WeightInputFormatter()
                                : header == 'Stone Cost' ||
                                    header == 'Total Cost'
                                ? AmountInputFormatter()
                                : FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$'),
                                ),
                          ],
                          enabled: header != "Item Description",
                          onTap: () {
                            log("Setting current values");
                            controller.currentRowIndex.value = rowIndex;

                            controller.currentColIndex.value = controller
                                .controllers[rowIndex]
                                .tableFocusNodes
                                .indexOf(focusNode!);
                          },
                          decoration: InputDecoration(
                            suffix:
                                header == 'WST/Tch'
                                    ? Obx(
                                      () => CustomText(
                                        text:
                                            controller.controllers
                                                .toList()[rowIndex]
                                                .wst_unit,
                                      ),
                                    )
                                    : null,
                            contentPadding: const EdgeInsets.all(10),
                            isDense: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    controller.controllers.length ==
                                            rowIndex + 1
                                        ? secondaryColor
                                        : Colors.transparent,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            disabledBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                header == "Item Description"
                                    ? secondaryColor
                                    : Colors.black,
                            decoration:
                                header == "Item Description"
                                    ? TextDecoration.underline
                                    : null,
                            decorationThickness: 2,
                            decorationColor:
                                header == "Item Description"
                                    ? secondaryColor
                                    : Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (header == 'Pcs' ||
                                  header == 'G.Wt. (gm)' ||
                                  header == 'Less' ||
                                  header == 'WST/Tch' ||
                                  header == 'MC (₹)' ||
                                  header == 'Stone (₹)') {
                                return null;
                              } else {
                                return 'Please enter $header';
                              }
                            }

                            if (header == 'Pcs' ||
                                header == 'G.Wt. (gm)' ||
                                header == 'Less' ||
                                header == 'N.Wt. (gm)' ||
                                header == 'WST/Tch' ||
                                header == 'MC (₹)' ||
                                header == 'Stone (₹)' ||
                                header == 'Rate (₹)' ||
                                header == 'Amount (₹)') {
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              } else {
                                if (double.parse(value) < 0.0) {
                                  return 'Please enter a valid number';
                                }
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (header == 'Existing Tag Number') {
                              controller.controllers[rowIndex].itemId = null;
                              if (value.isNotEmpty) {
                                controller.fetchAndPopulateData(rowIndex);
                              }
                            }
                            controller.updateTotals();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                child: CustomText(
                  text: text!,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
    );
  }

  Widget _buildMoreOptionsCell(
    int rowIndex,
    CounterTransferItemDetailsController controller,
  ) {
    return IconButton(
      icon: const Icon(Icons.more_vert, size: 20),
      onPressed: () => controller.showMoreOptions(rowIndex),
    );
  }
}
