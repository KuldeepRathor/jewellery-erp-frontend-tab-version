// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/table_key_handler.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class TaggingItemDetails extends StatefulWidget {
  const TaggingItemDetails({super.key});

  @override
  State<TaggingItemDetails> createState() => _TaggingItemDetailsState();
}

class _TaggingItemDetailsState extends State<TaggingItemDetails> {
  final TaggingItemDetailsController controller = Get.put(
    TaggingItemDetailsController(),
  );
  final taggingController = Get.find<TaggingController>();

  late final KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent;
  void initializeKeyEventHandler() {
    final keyHandler = TableKeyEventHandler(controller);
    onTableKeyEvent = keyHandler.handleKeyEvent;
  }

  @override
  void initState() {
    super.initState();
    initializeKeyEventHandler();
  }

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
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.enter):
              const AddTaggingDetailsIntent(),
          // LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
          //     const MoveToNextScreenIntent(),
        },
        child: Focus(
          autofocus: true,
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

  TableRow _buildTableHeaders(TaggingItemDetailsController controller) {
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

  List<TableRow> _buildRows(TaggingItemDetailsController controller) {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(int index, TaggingItemDetailsController controller) {
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
        text: "",
        editable: false,
        // textController: controller.controllers[index].code,
        header: controller.headers[1],
        rowIndex: index,
        controller: controller,
      ),
      _buildCell(
        text: "",
        editable: false,
        // textController: controller.controllers[index].tag,
        header: controller.headers[2],
        rowIndex: index,
        controller: controller,
      ),
      _buildCell(
        textController: controller.controllers[index].design,
        header: controller.headers[3],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[0],
        readOnly: true,
      ),

      // _buildCodeDropdown(
      //   index: index,
      //   controller: controller,
      //   focusNode: controller.controllers[index].tableFocusNodes[0],
      // ),
      _buildCell(
        textController: controller.controllers[index].purity,
        header: controller.headers[4],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[1],
        readOnly: true,
      ),
      // _buildPurityDropdown(
      //   index: index,
      //   controller: controller,
      //   focusNode: controller.controllers[index].tableFocusNodes[1],
      // ),
      _buildCell(
        textController: controller.controllers[index].pcs,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[2],
      ),
      _buildCell(
        textController: controller.controllers[index].gwt,
        header: controller.headers[6],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[3],
      ),

      _buildCell(
        textController: controller.controllers[index].nwt,
        header: controller.headers[7],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),
      _buildCell(
        textController: controller.controllers[index].va,
        header: controller.headers[8],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[5],
      ),
      _buildCell(
        textController: controller.controllers[index].mc,
        header: controller.headers[9],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[6],
      ),
      _buildCell(
        textController: controller.controllers[index].stone,
        header: controller.headers[10],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[7],
      ),
      _buildCell(
        textController: controller.controllers[index].rate,
        header: controller.headers[11],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[8],
      ),
      _buildCell(
        textController: controller.controllers[index].huid,
        header: controller.headers[12],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[9],
      ),
    ];

    cells.add(_buildMoreOptionsCell(index, controller));

    return TableRow(children: cells);
  }

  // Widget _buildCodeDropdown({
  //   required int index,
  //   required TaggingItemDetailsController controller,
  //   required FocusNode focusNode,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
  //     child: Focus(
  //       canRequestFocus: false,
  //       onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
  //       child: GenericAutocompleteDropdown<GetDesignResponseModel>(
  //         focusNode: focusNode,
  //         getDisplayValue: (displayValue) => displayValue.name ?? "",
  //         controller: controller.controllers[index].design,
  //         items:
  //             taggingController.getDesignListingResponse.value.data?.values ??
  //                 [],
  //         onTap: () {
  //           log("Setting current values for Design dropdown");
  //           controller.currentRowIndex.value = index;
  //           controller.currentColIndex.value = 0;
  //         },
  //         onSelected: (GetDesignResponseModel? value) {
  //           if (value != null) {
  //             log("Design selected: $value");
  //             controller.setDesignId(index, value.code ?? "");
  //             taggingController.setSelectedDesign(value);
  //             // controller.moveNextFocus(event: event);
  //             controller.controllers[index].tableFocusNodes[1].requestFocus();
  //           }
  //         },
  //         enabled: false,
  //         isLastRow: this.controller.controllers.length == index + 1,
  //         customOptionsBuilder: (TextEditingValue textEditingValue) async {
  //           final items =
  //               taggingController.getDesignListingResponse.value.data?.values ??
  //                   [];
  //           if (textEditingValue.text.isEmpty) {
  //             return items;
  //           }

  //           final searchTerm = textEditingValue.text.toLowerCase();
  //           return items.where((design) {
  //             final code = design.code?.toLowerCase() ?? '';
  //             final name = design.name?.toLowerCase() ?? '';
  //             return code.contains(searchTerm) || name.contains(searchTerm);
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPurityDropdown({
  //   required int index,
  //   required TaggingItemDetailsController controller,
  //   required FocusNode focusNode,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
  //     child: Focus(
  //       canRequestFocus: false,
  //       onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
  //       child: GenericAutocompleteDropdown<String>(
  //         focusNode: focusNode,
  //         getDisplayValue: (item) => item,
  //         controller: controller.controllers[index].purity,
  //         items: taggingController.getPurityResponse.value.data?.values ?? [],
  //         onTap: () {
  //           log("Setting current values for Purity dropdown");
  //           controller.currentRowIndex.value = index;
  //           controller.currentColIndex.value = 1;
  //         },
  //         onSelected: (String? value) {
  //           if (value != null) {
  //             controller.controllers[index].purity.text = value;
  //             taggingController.setSelectedPurity(value);
  //             controller.updateTotals();
  //             // controller.moveNextFocus();
  //             controller.controllers[index].tableFocusNodes[2].requestFocus();
  //           }
  //         },
  //         enabled: false,
  //         isLastRow: this.controller.controllers.length == index + 1,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    required TaggingItemDetailsController controller,
    FocusNode? focusNode,
    bool readOnly = false,
  }) {
    if (header == controller.headers[1]) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: CustomText(
          text: controller.controllers[rowIndex].code.value,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      );
    } else if (header == controller.headers[2]) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: CustomText(
          text: controller.controllers[rowIndex].tag.value,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      );
    }
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
                          print("Calling from 4");
                          controller.showStoneDialog(rowIndex);
                          return KeyEventResult.handled;
                        }
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.keyC &&
                            HardwareKeyboard.instance.isAltPressed &&
                            header == 'WST/Tch') {
                          print("Changing values ");
                          controller.updateTotals();
                          setState(() {});
                          return KeyEventResult.handled;
                        }
                        return KeyEventResult.ignored;
                      },
                      child: Obx(
                        () => TextFormField(
                          readOnly: readOnly,
                          inputFormatters: [
                            header == "Purity" || header == "HUID"
                                ? FilteringTextInputFormatter.allow(
                                  RegExp(r'^[a-zA-Z0-9]*$'),
                                )
                                : header == "G.Wt. (gm)" ||
                                    header == "N.Wt. (gm)"
                                ? WeightInputFormatter()
                                : header == "VA" ||
                                    header == "MC (₹)" ||
                                    header == "Stone (₹)" ||
                                    header == "Rate (₹)"
                                ? AmountInputFormatter()
                                : FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$'),
                                ),
                          ],
                          controller: textController,
                          focusNode: focusNode,
                          keyboardType: TextInputType.number,
                          enabled: header != "Item Description",
                          onTap: () {
                            log("Setting current values for cell");
                            controller.currentRowIndex.value = rowIndex;
                            controller.currentColIndex.value = controller
                                .controllers[rowIndex]
                                .tableFocusNodes
                                .indexOf(focusNode!);
                            if (textController != null) {
                              textController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: textController.text.length,
                              );
                            }
                          },
                          // onFieldSubmitted: (value) {
                          //  log("Setting current values for cell");
                          // controller.currentRowIndex.value = rowIndex;
                          // controller.currentColIndex.value = controller
                          //     .controllers[rowIndex].tableFocusNodes
                          //     .indexOf(focusNode!);
                          // if (textController != null) {
                          //   textController.selection = TextSelection(
                          //     baseOffset: 0,
                          //     extentOffset: textController.text.length,
                          //   );
                          // }
                          // },
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
                            final rowData = controller.controllers[rowIndex];

                            if (value == null || value.isEmpty) {
                              // HUID validation
                              if (header == "HUID") {
                                if (taggingController.isHuidRequired.value &&
                                    (controller.controllers.length ==
                                        rowIndex + 1)) {
                                  if (!RegExp(
                                    r'^[a-zA-Z0-9]{6}$',
                                  ).hasMatch(value ?? '')) {
                                    return 'HUID must be 6 alphanumeric characters';
                                  }
                                  return 'HUID is required';
                                }
                                return null;
                              }

                              // Rate validation
                              if (header == 'Rate (₹)') {
                                if (rowData.isRateRequired) {
                                  return 'Rate is required';
                                }
                                return null;
                              }

                              // Stone validation
                              if (header == 'Stone (₹)') {
                                if (rowData.isStoneRequired) {
                                  return 'Stone details are required';
                                }
                                return null;
                              }
                              // Other field validations
                              // if (value!.isEmpty &&
                              //     header != 'Stone (₹)' &&
                              //     header != 'Rate (₹)' &&
                              //     header != 'HUID') {
                              //   return 'Please enter $header';
                              // }
                            }
                            if (header == 'N.Wt. (gm)') {
                              final row = controller.controllers[rowIndex];
                              log(
                                "value is ${row.gwtValue} ${row.nwtValue} ${row.shouldGwtEqualNwt()}",
                              );
                              if (row.shouldGwtEqualNwt() &&
                                  row.gwtValue != row.nwtValue) {
                                return 'Net weight must equal gross weight when there are no stones';
                              }
                            }
                            // Existing numeric validations
                            if (header == 'G.Wt. (gm)' ||
                                header == 'N.Wt. (gm)' ||
                                // header == 'VA (₹)' ||
                                // header == 'MC (₹)' ||
                                header == 'Stone (₹)' ||
                                header == 'Rate (₹)') {
                              // print(
                              //     "Value is ${double.tryParse(value!) == null} || ${double.parse(value) < 0.0}");

                              if (double.tryParse(value!) == null) {
                                return 'Please enter a valid number';
                              } else if (double.parse(value) < 0.0) {
                                return 'Please enter a non-negative number';
                              }
                            }

                            return null;
                          },
                          onChanged: (value) {
                            if (header == controller.headers[6]) {
                              // G.Wt. field
                              final row = controller.controllers[rowIndex];
                              // Always sync nwt with gwt as user types
                              row.nwt.text = value;
                            }
                            controller.updateTotals();
                            // if (header == controller.headers[6]) {
                            //   // G.Wt. field
                            //   final row = controller.controllers[rowIndex];
                            //   // if (row.shouldGwtEqualNwt()) {
                            //   // Update nwt to match gwt when they should be equal
                            //   row.nwt.text = value;
                            //   // }
                            // }
                            // if (header == controller.headers[7]) {
                            //   // N.Wt. field
                            //   final row = controller.controllers[rowIndex];
                            //   if (row.shouldGwtEqualNwt() &&
                            //       row.gwtValue != row.nwtValue) {
                            //     showErrorToast(
                            //         message:
                            //             'Net weight must equal gross weight when there are no stones');
                            //     row.nwt.text = row.gwt.text;
                            //   }
                            //   String? makingChargeTypeId =
                            //       row.selectedDesign?.makingChargeType?.id;
                            //   if (["1", "2", "3"].contains(makingChargeTypeId)) {
                            //     controller.validateWeight(rowIndex);
                            //   }
                            // }
                            // if (header == controller.headers[10] &&
                            //     controller.controllers
                            //         .toList()
                            //         .elementAt(rowIndex)
                            //         .stoneDetailsTableData
                            //         .isNotEmpty) {
                            //   print("Calling from 6");
                            //   controller.showStoneDialog(rowIndex);
                            // }
                            // controller.updateTotals();

                            // if (header == 'Design' ||
                            //     header == 'G.Wt. (gm)' ||
                            //     header == 'N.Wt. (gm)') {
                            //   log("Field changed: $header = $value");
                            //   controller.checkAndFetchTagAndCode(rowIndex);
                            // }
                          },

                          onEditingComplete: () {
                            bool validationPassed = true;
                            final row = controller.controllers[rowIndex];

                            if (header == controller.headers[6]) {
                              // G.Wt. field
                              row.nwt.text = textController!.text;

                              // Check and fetch tag and code
                              controller.checkAndFetchTagAndCode(rowIndex);
                            }

                            if (header == controller.headers[7]) {
                              // N.Wt. field
                              if (row.shouldGwtEqualNwt() &&
                                  row.gwtValue != row.nwtValue) {
                                showErrorToast(
                                  message:
                                      'Net weight must equal gross weight when there are no stones',
                                );
                                row.nwt.text = row.gwt.text;
                                validationPassed = false;
                                // Keep focus on current field
                                focusNode?.requestFocus();
                                return;
                              }

                              String? makingChargeTypeId =
                                  row.selectedDesign?.makingChargeType?.id;
                              if ([
                                "1",
                                "2",
                                "3",
                              ].contains(makingChargeTypeId)) {
                                // Check if weight is in valid range
                                if (!controller.isWeightInValidRange(row)) {
                                  controller.validateWeight(rowIndex);
                                  validationPassed = false;
                                  // Keep focus on current field
                                  focusNode?.requestFocus();
                                  return;
                                }
                              }

                              // Check and fetch tag and code
                              controller.checkAndFetchTagAndCode(rowIndex);
                            }

                            if (header == controller.headers[10] &&
                                controller.controllers
                                    .toList()
                                    .elementAt(rowIndex)
                                    .stoneDetailsTableData
                                    .isNotEmpty) {
                              print("Calling from onEditingComplete");
                              controller.showStoneDialog(rowIndex);
                            }

                            // Update totals
                            controller.updateTotals();

                            if (header == 'Design' ||
                                header == 'G.Wt. (gm)' ||
                                header == 'N.Wt. (gm)') {
                              log(
                                "Field changed in onEditingComplete: $header = ${textController?.text}",
                              );
                              controller.checkAndFetchTagAndCode(rowIndex);
                            }

                            // Only move to next field if validation passed
                            if (validationPassed) {
                              // Move to next focus
                              controller.moveNextFocus(
                                event: const KeyDownEvent(
                                  logicalKey: LogicalKeyboardKey.enter,
                                  timeStamp: Duration.zero,
                                  physicalKey: PhysicalKeyboardKey.enter,
                                ),
                              );
                            }
                          },
                          //  onEditingComplete: () {
                          //   if (textController != null) {
                          //     textController.selection = TextSelection(
                          //       baseOffset: 0,
                          //       extentOffset: textController.text.length,
                          //     );
                          //   }
                          //   print("on editing complete called");
                          // },
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
    TaggingItemDetailsController controller,
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
                        if (element != controller.popUpValues.last)
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
            case 'Delete':
              // Handle delete action
              controller.removeCurrentRow(rowIndex);
              break;
          }
        },
      ),
    );
  }
}
