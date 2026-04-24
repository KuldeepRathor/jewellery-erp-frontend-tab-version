// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/ornament_type/view/add_ornament_type_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/view_model/purchase_return_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/get_ornament_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class PurchaseReturnItemDetailsWidget extends StatefulWidget {
  const PurchaseReturnItemDetailsWidget({super.key});

  @override
  State<PurchaseReturnItemDetailsWidget> createState() =>
      _PurchaseReturnItemDetailsWidgetState();
}

class _PurchaseReturnItemDetailsWidgetState
    extends State<PurchaseReturnItemDetailsWidget> {
  final PurchaseReturnItemDetailsController controller = Get.put(
    PurchaseReturnItemDetailsController(),
  );
  final InventoryViewmodel inventoryViewmodel = Get.find<InventoryViewmodel>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");

    if (event is KeyDownEvent) {
      if ((controller.currentColIndex.value == 0) &&
          event.logicalKey == LogicalKeyboardKey.enter) {
        return KeyEventResult.ignored;
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          controller.moveNextFocus();
          return KeyEventResult.handled;
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
        controller.currentColIndex.value = 0;
        controller.controllers[rowIndex].tableFocusNodes[0].requestFocus();
        controller.resetRow(rowIndex);

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
                            canRequestFocus: false,
                            shortcutButtonBackgroundColor: shortcutRedColor,
                            focusNode: FocusNode(canRequestFocus: false),
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

  TableRow _buildTableHeaders(PurchaseReturnItemDetailsController controller) {
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

  List<TableRow> _buildRows(PurchaseReturnItemDetailsController controller) {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(
    int index,
    PurchaseReturnItemDetailsController controller,
  ) {
    List<Widget> cells = [
      _buildCell(
        text: (index + 1).toString(),
        editable: false,
        controller: controller,
      ),
      _buildCodeDropdown(
        index: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[0],
      ),
      // _buildCell(
      //   textController: controller.controllers[index].item_description,
      //   header: controller.headers[2],
      //   rowIndex: index,
      //   controller: controller,
      // ),
      _buildCell(
        textController: controller.controllers[index].pcs,
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
        textController: controller.controllers[index].less,
        header: controller.headers[4],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[3],
      ),
      _buildCell(
        textController: controller.controllers[index].nwt,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),
      _buildCell(
        textController: controller.controllers[index].wst,
        header: controller.headers[6],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[5],
      ),
      _buildCell(
        textController: controller.controllers[index].mc,
        header: controller.headers[7],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[6],
      ),
      _buildCell(
        textController: controller.controllers[index].stone,
        header: controller.headers[8],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[7],
      ),
      _buildCell(
        textController: controller.controllers[index].rate,
        header: controller.headers[9],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[8],
      ),
      _buildCell(
        textController: controller.controllers[index].amount,
        header: controller.headers[10],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[9],
      ),
    ];

    // cells.add(_buildMoreOptionsCell(index, controller));
    cells.add(const SizedBox());

    return TableRow(children: cells);
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    required PurchaseReturnItemDetailsController controller,
    FocusNode? focusNode,
  }) {
    return Container(
      child:
          editable
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: GestureDetector(
                  // onDoubleTap: header != "Item Description"
                  //     ? null
                  //     : () {
                  //         if (header == "Item Description") {
                  //           // Implement navigation to other screen
                  //         }
                  //       },
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
                          controller.updateRowAmount(rowIndex);
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
                          // enabled: header != "Item Description",
                          // enabled: header != "Ornament Type",
                          // readOnly: header == "Ornament Type",
                          inputFormatters: _getInputFormatters(header),
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
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
                              if (header == 'Amount (₹)' ||
                                  header == 'Ornament') {
                                return 'Please enter $header';
                              } else {
                                return null;
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
                            // Handle stone dialog
                            if (header == controller.headers[9] &&
                                controller.controllers
                                    .toList()
                                    .elementAt(rowIndex)
                                    .stoneDetailsTableData
                                    .isNotEmpty) {
                              controller.showStoneDialog(rowIndex);
                            }

                            // Handle weight calculations
                            if (header == controller.headers[3] ||
                                header == controller.headers[5]) {
                              if (header == controller.headers[3]) {
                                // G.Wt. changed
                                controller.calculateNetWeight(rowIndex);
                              } else {
                                // N.Wt. changed
                                controller.calculateLess(rowIndex);
                              }
                            }

                            // Calculate NWT when Less changes
                            if (header == controller.headers[4]) {
                              controller.calculateNetWeight(rowIndex);
                            }

                            // Handle amount and rate calculations
                            if (header == controller.headers[10]) {
                              // Amount field
                              // If amount is entered, calculate rate and don't update amount
                              if (value.isNotEmpty) {
                                controller.calculateRateFromAmount(rowIndex);
                              }
                            } else if (header == controller.headers[9]) {
                              // Rate field
                              // If rate changes, update amount
                              controller.updateRowAmount(rowIndex);
                            } else {
                              // For all other fields that affect amount
                              controller.updateRowAmount(rowIndex);
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

  Widget _buildCodeDropdown({
    required int index,
    required PurchaseReturnItemDetailsController controller,
    required FocusNode focusNode,
  }) {
    return Obx(() {
      final allItems = [
        ...controller.codeList,
        GetAllOrnamentsResponseValue(
          name: "Add New Ornament",
          code: "add_new_ornament",
          id: "add_new_ornament",
        ),
      ];
      return GenericAutocompleteDropdown<GetAllOrnamentsResponseValue>(
        controller: controller.controllers[index].code,
        focusNode: focusNode,
        items: allItems,
        getDisplayValue: (item) {
          if (item.code == "add_new_ornament") {
            return "Add New Ornament";
          }
          return "${item.name ?? ''} - ${item.code ?? ''}";
        },
        onEditingComplete: () {},
        onSelected: (value) async {
          if (value.code == "add_new_ornament") {
            final result = await Get.dialog(
              const AddNewOrnamentTypeDialog(),
              barrierDismissible: false,
            );

            if (result != null && result is OrnamnetTypeValues) {
              // Refresh the ornaments list
              await controller.getCodeList();

              // Find and select the newly created ornament
              final newOrnament = controller.codeList.firstWhereOrNull(
                (item) => item.code == result.code,
              );

              if (newOrnament != null) {
                controller.controllers[index].ornament_name =
                    newOrnament.name ?? '';
                controller.setItemDescription(index, newOrnament.code ?? '');
                controller.controllers[index].code.text =
                    "${newOrnament.name ?? ''} - ${newOrnament.code ?? ''}";
                controller.controllers[index].tableFocusNodes[1].requestFocus();
                controller.currentColIndex.value = 1;
              }
            }
            return;
          }

          controller.controllers[index].ornament_name = value.name ?? '';
          controller.setItemDescription(index, value.code ?? '');

          //populating the pieces with 1
          // controller.controllers[index].pcs.text = "1";
          controller.controllers[index].tableFocusNodes[1].requestFocus();
          controller.currentColIndex.value = 1;
          //then calling update total function
          controller.updateTotals();
        },
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
        enabled:
            inventoryViewmodel.getAllOrnamentsResponse.value.status ==
            Status.COMPLETED,
        isLastRow: controller.controllers.length == index + 1,
        fieldHeight: 38,
        borderColor: secondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        onTap: () {
          controller.currentRowIndex.value = index;
          controller.currentColIndex.value = 0;
        },
      );
    });
  }
}

List<TextInputFormatter> _getInputFormatters(String? header) {
  // For weight fields (3 decimal places)
  if (header == 'G.Wt. (gm)' ||
      header == 'Less' ||
      header == 'N.Wt. (gm)' ||
      header == 'WST/Tch') {
    return [
      WeightInputFormatter(), // Max 3 decimal places
    ];
  }
  // For amount fields (2 decimal places)
  else if (header == 'MC (₹)' ||
      header == 'Stone (₹)' ||
      header == 'Rate (₹)' ||
      header == 'Amount (₹)') {
    return [
      AmountInputFormatter(), // Max 2 decimal places
    ];
  }
  // For other numeric fields
  else {
    return [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))];
  }
}
