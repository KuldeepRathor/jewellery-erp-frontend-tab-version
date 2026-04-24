// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/stock_issue_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class StockIssueItemDetailsWidget extends StatefulWidget {
  const StockIssueItemDetailsWidget({super.key});

  @override
  State<StockIssueItemDetailsWidget> createState() =>
      _StockIssueItemDetailsWidgetState();
}

class _StockIssueItemDetailsWidgetState
    extends State<StockIssueItemDetailsWidget> {
  final StockIssueItemDetailsController controller = Get.put(
    StockIssueItemDetailsController(),
  );

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          bool isCodeOrTag =
              controller.currentColIndex.value == 0 ||
              controller.currentColIndex.value == 1;
          if (!isCodeOrTag) {
            controller.moveNextFocus();
            return KeyEventResult.handled;
          }
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab &&
          HardwareKeyboard.instance.isShiftPressed) {
        // controller.movePreviousFocus(addButtonFocusNode);
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
        // Reset the current row and move focus to first field
        controller.resetRow(rowIndex);
        controller.currentColIndex.value = 0;

        // If this is not the first row, move to the previous row
        if (rowIndex > 0) {
          controller.currentRowIndex.value = rowIndex - 1;
          // Focus on the same column in the previous row
          controller
              .controllers[controller.currentRowIndex.value]
              .tableFocusNodes[controller.currentColIndex.value]
              .requestFocus();
        } else {
          // If it's the first row, just focus on the first field
          controller
              .controllers[rowIndex]
              .tableFocusNodes[controller.currentColIndex.value]
              .requestFocus();
        }

        return KeyEventResult.handled;
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

  TableRow _buildTableHeaders(StockIssueItemDetailsController controller) {
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

  List<TableRow> _buildRows(StockIssueItemDetailsController controller) {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(
    int index,
    StockIssueItemDetailsController controller,
  ) {
    List<Widget> cells = [
      // Cell 1: Serial number
      _buildCell(
        text: (index + 1).toString(),
        editable: false,
        controller: controller,
      ),

      // Cell 2: Item Code
      _buildCell(
        textController: controller.controllers[index].item_code,
        header: controller.headers[1],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[0],
      ),

      // Cell 3: Tag No.
      _buildCell(
        textController: controller.controllers[index].tag_no,
        header: controller.headers[2],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[1],
      ),

      // Cell 4: Description
      _buildCell(
        textController: controller.controllers[index].description,
        header: controller.headers[3],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[2],
      ),

      // Cell 5: Pcs
      _buildCell(
        textController: controller.controllers[index].pcs,
        header: controller.headers[4],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[3],
      ),

      // Cell 6: G.Wt.
      _buildCell(
        textController: controller.controllers[index].gwt,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),

      // Cell 7: N.Wt.
      _buildCell(
        textController: controller.controllers[index].nwt,
        header: controller.headers[6],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[5],
      ),

      // Cell 8: VA
      _buildCell(
        textController: controller.controllers[index].va,
        header: controller.headers[7],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[6],
      ),

      // Cell 9: MC
      _buildCell(
        textController: controller.controllers[index].mc,
        header: controller.headers[8],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[7],
      ),

      // Cell 10: Stone
      _buildCell(
        textController: controller.controllers[index].stone,
        header: controller.headers[9],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[8],
      ),

      // Cell 11: Hall Mark
      _buildCell(
        textController: controller.controllers[index].hall_mark,
        header: controller.headers[10],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[9],
      ),

      // Cell 12: Cost Discount
      // _buildCell(
      //   textController: controller.controllers[index].costDiscount,
      //   header: controller.headers[11],
      //   rowIndex: index,
      //   controller: controller,
      //   focusNode: controller.controllers[index].tableFocusNodes[10],
      // ),

      // Cell 13: Sales Amount - No focus node needed for read-only
      _buildCell(
        textController: TextEditingController(
          text: controller.controllers[index].salesAmount.text,
        ),
        header: controller.headers[12],
        rowIndex: index,
        controller: controller,
      ),

      // Cell 14: Total - No focus node needed for read-only
      // _buildCell(
      //     textController:
      //         TextEditingController(text: controller.controllers[index].total),
      //     header: controller.headers[13],
      //     rowIndex: index,
      //     controller: controller,
      //     editable: false),
    ];

    // Cell 15: More options
    cells.add(_buildMoreOptionsCell(index, controller));

    return TableRow(children: cells);
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    required StockIssueItemDetailsController controller,
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
                            header == 'Stone Cost (₹)') {
                          controller.showStoneDialog(rowIndex);
                          return KeyEventResult.handled;
                        }
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.keyC &&
                            HardwareKeyboard.instance.isAltPressed &&
                            header == 'WST/Tch') {
                          print("Changing values ");
                          controller.changeWstUnit(index: rowIndex);
                          controller.updateTotals();
                          setState(() {});
                          return KeyEventResult.handled;
                        }
                        return KeyEventResult.ignored;
                      },
                      child: Obx(
                        () => TextFormField(
                          controller: textController,
                          focusNode: focusNode,
                          enabled: header != "Item Description",
                          // Use appropriate input formatters for numeric fields
                          inputFormatters: getInputFormatters(header),
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

                          onChanged: (value) {
                            log("=== Field change detected ===");
                            log(
                              "Row: $rowIndex, Field: $header, New value: $value",
                            );

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

                              return;
                            }

                            if (header == controller.headers[9] &&
                                controller.controllers
                                    .toList()
                                    .elementAt(rowIndex)
                                    .stoneDetailsTableData
                                    .isNotEmpty) {
                              log("Showing stone dialog for row $rowIndex");
                              controller.showStoneDialog(rowIndex);
                            }

                            if (header == "N.Wt. (gm)" ||
                                header == "G.Wt. (gm)" ||
                                header == "VA" ||
                                header == "MC (₹)" ||
                                header == "Stone Cost (₹)" ||
                                header == "Hall Mark (₹)" ||
                                header == "Cost Discount" ||
                                header == "Rate") {
                              log("Value change requires recalculation");

                              // Call the appropriate method based on whether this is a fetched item or manual entry
                              if (controller.controllers[rowIndex].originalVa >
                                      0 ||
                                  controller.controllers[rowIndex].originalMc >
                                      0) {
                                log(
                                  "Using calculateSalesAndTotalAmountFromFetchedItems for row $rowIndex",
                                );
                                controller
                                    .calculateSalesAndTotalAmountFromFetchedItems(
                                      index: rowIndex,
                                    );
                              } else {
                                log(
                                  "Using addSalesAndTotalAmount for row $rowIndex",
                                );
                                controller.addSalesAndTotalAmount(
                                  index: rowIndex,
                                );
                              }
                            }

                            log("Updating totals after field change");
                            controller.updateTotals();
                          },

                          onEditingComplete: () {
                            // Handle field completion, especially for lookups

                            if (header == "Tag No.") {
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
                                log(
                                  "Both Item Code and Tag No. are filled, fetching data...",
                                );
                                controller.fetchTaggingLineItemCodeTag(
                                  rowIndex,
                                );
                              }
                              controller.isItemDetailsVisible.value;
                              return;
                            }

                            // Move to next field
                            controller.moveNextFocus();
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
                  text: text ?? textController?.text ?? "",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
    );
  }

  Widget _buildMoreOptionsCell(
    int rowIndex,
    StockIssueItemDetailsController controller,
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
                        if (element != controller.popUpValues.last)
                          CustomDashedLineWidget(width: Get.width),
                      ],
                    ),
                  ),
                );
              }),
            ],
        onSelected: (String value) {
          switch (value) {
            case 'View':
              controller.showItemDetails(index: rowIndex);
              break;
            case 'Edit':
              controller.showItemDetails(index: rowIndex);
              break;
            case "Delete":
              controller.removeCurrentRow(rowIndex);
              break;
          }
        },
      ),
    );
  }

  List<TextInputFormatter> getInputFormatters(String? header) {
    // For weight fields (3 decimal places)
    if (header == 'G.Wt. (gm)' || header == 'N.Wt. (gm)' || header == 'VA') {
      return [
        WeightInputFormatter(), // Max 3 decimal places
      ];
    }
    // For amount fields (2 decimal places)
    else if (header == 'MC (₹)' ||
        header == 'Stone Cost (₹)' ||
        header == 'Hall Mark (₹)' ||
        header == 'Cost Discount' ||
        header == 'Sales Amount' ||
        header == 'Value') {
      return [
        AmountInputFormatter(), // Max 2 decimal places
      ];
    }
    // For integer fields (no decimal places)
    else if (header == 'Pcs') {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    // For fields that should be alphanumeric (Item Code, Tag No)
    else if (header == 'Item Code' || header == 'Tag No') {
      return [
        // Allow letters, numbers, and some special characters commonly used in codes
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_/]')),
      ];
    } else {
      return [];
    }
  }
}
