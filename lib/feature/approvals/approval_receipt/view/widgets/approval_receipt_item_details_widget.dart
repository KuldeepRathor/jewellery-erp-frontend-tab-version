// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view_model/approval_receipt_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ApprovalReceiptItemDetailsWidget extends StatefulWidget {
  const ApprovalReceiptItemDetailsWidget({super.key});

  @override
  State<ApprovalReceiptItemDetailsWidget> createState() =>
      _ApprovalReceiptItemDetailsWidgetState();
}

class _ApprovalReceiptItemDetailsWidgetState
    extends State<ApprovalReceiptItemDetailsWidget> {
  final ApprovalReceiptItemDetailsController controller = Get.put(
    ApprovalReceiptItemDetailsController(),
  );
  // final InventoryViewmodel inventoryViewmodel = Get.find<InventoryViewmodel>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          // If we're on the last column (Hall Mark) and the last row
          if (controller.currentColIndex.value ==
                  controller.controllers[rowIndex].tableFocusNodes.length - 1 &&
              rowIndex == controller.controllers.length - 1) {
            // Add new row and set focus to the first cell of the new row
            controller.moveNextFocus();
            return KeyEventResult.handled;
          }

          // Otherwise, just move to the next field
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
        child: Focus(
          // autofocus: true,
          canRequestFocus: false,
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
                            focusNode: FocusNode(canRequestFocus: false),
                            canRequestFocus: false,
                          ),
                          ButtonShortcutWidget(
                            onTap: controller.removeLastRow,
                            buttonName: "Remove",
                            shortcut: "Shift+Esc",
                            color: redTextColor,
                            shortcutButtonBackgroundColor: shortcutRedColor,
                            focusNode: FocusNode(canRequestFocus: false),
                            canRequestFocus: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => CustomTableWidget(
                          headers: [_buildTableHeaders(controller)],
                          columnWidths: controller.columnWidths,
                          rows: _buildRows(controller),
                          addSizedBox: false,
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

  TableRow _buildTableHeaders(ApprovalReceiptItemDetailsController controller) {
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

  List<TableRow> _buildRows(ApprovalReceiptItemDetailsController controller) {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(
    int index,
    ApprovalReceiptItemDetailsController controller,
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
        textController: controller.controllers[index].item_code,
        header: controller.headers[1],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[0],
      ),
      _buildCell(
        textController: controller.controllers[index].tag_no,
        header: controller.headers[2],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[1],
      ),
      _buildCell(
        // text: controller.controllers[index].description,
        textController: controller.controllers[index].description,
        header: controller.headers[4],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[2],
      ),
      _buildCell(
        textController: controller.controllers[index].pcs,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[3],
      ),
      _buildCell(
        textController: controller.controllers[index].gwt,
        header: controller.headers[6],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),
      _buildCell(
        textController: controller.controllers[index].nwt,
        header: controller.headers[7],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[5],
      ),
      _buildCell(
        textController: controller.controllers[index].va,
        header: controller.headers[8],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[6],
      ),
      _buildCell(
        textController: controller.controllers[index].mc,
        header: controller.headers[9],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[7],
      ),
      _buildCell(
        textController: controller.controllers[index].stone,
        header: controller.headers[10],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[8],
      ),
      _buildCell(
        textController: controller.controllers[index].hall_mark,
        header: controller.headers[11],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[9],
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
    required ApprovalReceiptItemDetailsController controller,
    FocusNode? focusNode,
  }) {
    return Container(
      child:
          editable
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: GestureDetector(
                  onDoubleTap:
                      header != "Item Description"
                          ? null
                          : () {
                            if (header == "Item Description") {
                              // Implement navigation to other screen
                            }
                          },
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
                          controller.showStoneDialog(rowIndex);
                          return KeyEventResult.handled;
                        }
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.keyC &&
                            HardwareKeyboard.instance.isAltPressed &&
                            header == 'WST/Tch') {
                          print("Changeing values ");
                          controller.changeWstUnit(index: rowIndex);
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
                          enabled: header != "Item Description",
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(
                          //       RegExp(r'^\d*\.?\d*$')),
                          // ],
                          onTap: () {
                            log("Setting current values");
                            controller.currentRowIndex.value = rowIndex;

                            if (header == controller.headers[1]) {
                              controller.currentColIndex.value = 0;
                            } else if (header == controller.headers[2]) {
                              controller.currentColIndex.value = 1;
                            } else if (header == controller.headers[3]) {
                              controller.currentColIndex.value = 1;
                              log("Setting 3");
                            } else if (header == controller.headers[4]) {
                              controller.currentColIndex.value = 2;
                            } else if (header == controller.headers[5]) {
                              controller.currentColIndex.value = 3;
                            } else if (header == controller.headers[6]) {
                              controller.currentColIndex.value = 4;
                            } else if (header == controller.headers[7]) {
                              controller.currentColIndex.value = 5;
                            } else if (header == controller.headers[8]) {
                              controller.currentColIndex.value = 6;
                            } else if (header == controller.headers[9]) {
                              controller.currentColIndex.value = 7;
                            } else if (header == controller.headers[10]) {
                              controller.currentColIndex.value = 8;
                            } else if (header == controller.headers[11]) {
                              controller.currentColIndex.value = 9;
                            } else {
                              controller.currentColIndex.value = 0;
                            }
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
                          // validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   if (header == 'Pcs' ||
                          //       header == 'G.Wt. (gm)' ||
                          //       header == 'Less' ||
                          //       header == 'WST/Tch' ||
                          //       header == 'MC (₹)' ||
                          //       header == 'Stone (₹)') {
                          //     return null;
                          //   } else {
                          //     return 'Please enter $header';
                          //   }
                          // }

                          // if (header == 'Pcs' ||
                          //     header == 'G.Wt. (gm)' ||
                          //     header == 'Less' ||
                          //     header == 'N.Wt. (gm)' ||
                          //     header == 'WST/Tch' ||
                          //     header == 'MC (₹)' ||
                          //     header == 'Stone (₹)' ||
                          //     header == 'Rate (₹)' ||
                          //     header == 'Amount (₹)') {
                          //   if (double.tryParse(value) == null) {
                          //     return 'Please enter a valid number';
                          //   } else {
                          //     if (double.parse(value) < 0.0) {
                          //       return 'Please enter a valid number';
                          //     }
                          //   }
                          // }
                          // return null;
                          // },
                          onChanged: (value) {
                            if (header == "Item Code" || header == "Tag No.") {
                              final capitalizedValue = value.toUpperCase();
                              final currentCursorPosition =
                                  textController?.selection.baseOffset;
                              textController?.value = TextEditingValue(
                                text: capitalizedValue,
                                selection: TextSelection.collapsed(
                                  offset: currentCursorPosition ?? 0,
                                ),
                              );
                            }
                            if (header == "Item Code" || header == "Tag No.") {
                              // Fetch data when both item code and tag number are filled
                              if (controller
                                      .controllers[rowIndex]
                                      .item_code
                                      .text
                                      .isNotEmpty &&
                                  controller
                                      .controllers[rowIndex]
                                      .tag_no
                                      .text
                                      .isNotEmpty) {
                                // controller.fetchTaggingLineItemCodeTag(rowIndex);
                              }
                            }
                            if (header == controller.headers[9] &&
                                controller.controllers
                                    .toList()
                                    .elementAt(rowIndex)
                                    .stoneDetailsTableData
                                    .isNotEmpty) {
                              controller.showStoneDialog(rowIndex);
                            }
                            if (header == controller.headers[4] ||
                                header == controller.headers[5]) {
                              // controller.calculateNetWeight(rowIndex);
                            }
                            // controller.updateRowAmount(rowIndex);
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
    ApprovalReceiptItemDetailsController controller,
  ) {
    return Theme(
      data: ThemeData(
        focusColor: greyTextColor,
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: CustomPopupMenuButtonWidget<String>(
        icon: const Icon(Icons.more_vert),
        itemBuilder:
            (BuildContext context) => <PopupMenuEntry<String>>[
              ...controller.popUpValues.map((element) {
                return PopupMenuItem<String>(
                  value: element,

                  // padding: EdgeInsets.all(0),
                  height: 0,
                  child: SizedBox(
                    width: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          element,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (element != "Delete")
                          CustomDashedLineWidget(width: Get.width),
                      ],
                    ),
                  ),
                );
              }),
            ],
        onSelected: (String value) {
          // Handle the selected option
          switch (value) {
            case 'View':
              controller.showItemDetails(index: rowIndex);
              break;
            case 'Edit':
              controller.showItemDetails(index: rowIndex);
              break;

            case 'Delete':
              // Handle delete action
              break;
          }
        },
      ),
    );
  }
}
