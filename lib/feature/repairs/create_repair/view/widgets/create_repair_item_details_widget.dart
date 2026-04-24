import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/create_repair/view_model/create_repair_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class CreateRepairItemDetailsWidget extends StatefulWidget {
  const CreateRepairItemDetailsWidget({super.key});

  @override
  State<CreateRepairItemDetailsWidget> createState() =>
      _CreateRepairItemDetailsWidgetState();
}

class _CreateRepairItemDetailsWidgetState
    extends State<CreateRepairItemDetailsWidget> {
  final CreateRepairItemDetailsController controller = Get.put(
    CreateRepairItemDetailsController(),
  );
  final InventoryViewmodel inventoryViewmodel = Get.find<InventoryViewmodel>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    log("table key event called ${event.logicalKey} $rowIndex");
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
                          ),
                          ButtonShortcutWidget(
                            onTap: controller.removeLastRow,
                            buttonName: "Remove",
                            shortcut: "Shift+Esc",
                            color: redTextColor,
                            shortcutButtonBackgroundColor: shortcutRedColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
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

  TableRow _buildTableHeaders(CreateRepairItemDetailsController controller) {
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

  List<TableRow> _buildRows(CreateRepairItemDetailsController controller) {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(
    int index,
    CreateRepairItemDetailsController controller,
  ) {
    List<Widget> cells = [
      _buildCell(
        text: (index + 1).toString(),
        editable: false,
        controller: controller,
      ),
      _buildCell(
        textController: controller.controllers[index].item_description,
        header: controller.headers[1],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[0],
      ),
      _buildCell(
        textController: controller.controllers[index].size,
        header: controller.headers[2],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[1],
      ),
      _buildPurityDropdown(
        index: index,
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
        textController: controller.controllers[index].amount,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),
    ];

    // cells.add(_buildEstimateCell(index, controller));

    return TableRow(children: cells);
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    required CreateRepairItemDetailsController controller,
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
                      child: TextFormField(
                        controller: textController,
                        focusNode: focusNode,
                        keyboardType: TextInputType.number,
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
                                  controller.controllers.length == rowIndex + 1
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          decorationThickness: 2,
                          decorationColor: Colors.white,
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
                          controller.updateTotals();
                        },
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

  Widget _buildPurityDropdown({
    required int index,
    required CreateRepairItemDetailsController controller,
    required FocusNode focusNode,
  }) {
    return Obx(() {
      final purityValues =
          controller.getPurityResponse.value.data?.values?.toList() ?? [];

      return GenericAutocompleteDropdown<String>(
        controller: controller.controllers[index].purity,
        focusNode: focusNode,
        items: purityValues,
        getDisplayValue: (item) => item,
        onSelected: (selectedValue) {
          controller.controllers[index].purity.text = selectedValue;
          // Move to next field
          controller.controllers[index].tableFocusNodes[3].requestFocus();
        },
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
        enabled: controller.getPurityResponse.value.status == Status.COMPLETED,
        isLastRow: controller.controllers.length == index + 1,
      );
    });
  }

  // Widget _buildEstimateCell(
  //     int rowIndex, CreateRepairItemDetailsController controller) {
  //   return Theme(
  //     data: ThemeData(
  //       focusColor: greyTextColor,
  //       tooltipTheme: const TooltipThemeData(
  //         decoration: BoxDecoration(
  //           color: Colors.transparent,
  //         ),
  //       ),
  //     ),
  //     child: InkWell(
  //       // onTap: () {
  //       //   if (!Get.isRegistered<CreateRepairEstimationController>()) {
  //       //     Get.put(CreateRepairEstimationController(), permanent: true);
  //       //   }
  //       //   Get.dialog(const CreateRepairEstimateDialog());
  //       // },
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         alignment: Alignment.center, // Centers the content
  //         child: const Padding(
  //           padding: EdgeInsets.only(top: 8),
  //           child: CustomText(
  //             text: "+Est",
  //             fontSize: 14,
  //             fontWeight: FontWeight.w700,
  //             color: secondaryColor,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
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
  else if (header == 'Size' ||
      header == 'Stone (₹)' ||
      header == 'Rate (₹)' ||
      header == 'Amount (₹)') {
    return [
      AmountInputFormatter(), // Max 2 decimal places
    ];
  }
  // For other numeric fields
  else {
    return [
      // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
    ];
  }
}
