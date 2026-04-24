// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/view/add_stone_rates_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/stone_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class StoneDetailsDialog extends StatefulWidget {
  final List<StoneDetailsTableData> initialStoneValue;
  final Function(double, List<StoneDetailsTableData>) onSave;
  final bool isDisabled;

  const StoneDetailsDialog({
    super.key,
    required this.initialStoneValue,
    required this.onSave,
    this.isDisabled = false,
  });

  @override
  State<StoneDetailsDialog> createState() => _StoneDetailsDialogState();
}

class _StoneDetailsDialogState extends State<StoneDetailsDialog> {
  final StoneDetailsController controller = Get.put(StoneDetailsController());

  late FocusNode tableFocusNode;
  late FocusNode addButtonFocusNode;
  late FocusNode removeButtonFocusNode;
  late FocusNode nextButtonFocusNode;
  late FocusNode closeFocusNode;

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");

    if (event is KeyDownEvent) {
      if (controller.currentColIndex.value == 0 &&
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
        controller.movePreviousFocus(addButtonFocusNode);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        controller.moveNextFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        return controller.moveFocus(
          KeyEventResult.handled,
          LogicalKeyboardKey.arrowUp,
          addButtonFocusNode: addButtonFocusNode,
          nextButtonFocusNode: nextButtonFocusNode,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        return controller.moveFocus(
          KeyEventResult.handled,
          LogicalKeyboardKey.arrowDown,
          addButtonFocusNode: addButtonFocusNode,
          nextButtonFocusNode: nextButtonFocusNode,
        );
      }

      if (event.logicalKey == LogicalKeyboardKey.escape &&
          HardwareKeyboard.instance.isShiftPressed) {
        controller.removeCurrentRow(rowIndex);
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        if (controller.currentColIndex.value == 0) {
          return KeyEventResult.ignored;
        }

        controller.currentColIndex.value = 0;
        controller.controllers[rowIndex].tableFocusNodes[0].requestFocus();
        controller.resetRow(rowIndex);

        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  };

  @override
  void initState() {
    super.initState();
    tableFocusNode = FocusNode();
    addButtonFocusNode = FocusNode();
    removeButtonFocusNode = FocusNode();
    nextButtonFocusNode = FocusNode();
    closeFocusNode = FocusNode();
    controller.getStoneRatesDetails();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initializeControllers(widget.initialStoneValue);
      controller.controllers.last.tableFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Actions(
        actions: <Type, Action<Intent>>{
          // AddStoneRowIntent: CallbackAction<AddStoneRowIntent>(
          //   onInvoke: (intent) => controller.validateAndAddRow(),
          // ),
          // RemoveLastStoneRowIntent: CallbackAction<RemoveLastStoneRowIntent>(
          //   onInvoke: (intent) => controller.removeLastRow(),
          // ),
          SaveStoneDetailsIntent: CallbackAction<SaveStoneDetailsIntent>(
            onInvoke: (intent) async {
              if (widget.isDisabled == false) {
                await validateAndSaveStoneData();
              }
              return null;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            // LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.enter):
            //     const AddStoneRowIntent(),
            // LogicalKeySet(
            //         LogicalKeyboardKey.shift, LogicalKeyboardKey.escape):
            //     const RemoveLastStoneRowIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const SaveStoneDetailsIntent(),
          },
          child: Container(
            height: Get.height * .7,
            width: Get.width * .675,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Focus(
                    canRequestFocus: false,
                    focusNode: closeFocusNode,
                    onKeyEvent: onNormalKeyEvent,
                    child: _buildHeader(),
                  ),
                  const SizedBox(height: 16),
                  Focus(
                    canRequestFocus: false,
                    onKeyEvent: onNormalKeyEvent,
                    child: _buildButtonRow(),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Focus(
                      canRequestFocus: true,
                      autofocus: true,
                      focusNode: tableFocusNode,
                      // onKeyEvent: onNormalKeyEvent,
                      child: _buildTable(),
                    ),
                  ),
                  _buildTotalRow(),
                  const SizedBox(height: 16),
                  Focus(
                    canRequestFocus: false,
                    onKeyEvent: onNormalKeyEvent,
                    child: _buildFooter(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const CustomText(
                text: "Stone Details",
                color: primaryColor,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Visibility(
      visible: widget.isDisabled == true ? false : true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          ButtonShortcutWidget(
            focusNode: addButtonFocusNode,
            onTap: () => controller.validateAndAddRow(),
            buttonName: "+ Add",
            shortcut: "Enter",
            color: primaryColor,
            shortcutButtonBackgroundColor: shortcutGreyColor,
          ),
          ButtonShortcutWidget(
            onTap: () => controller.removeLastRow(),
            buttonName: "Remove",
            shortcut: "Shift+Esc",
            color: redTextColor,
            shortcutButtonBackgroundColor: shortcutRedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => CustomTableWidget(
          headers: [_buildTableHeaders()],
          columnWidths: controller.stoneColumnWidths,
          rows: _buildRows(),
          isLoadingMore: false,
          controller: controller.scrollController,
          addSizedBox: false,
        ),
      ),
    );
  }

  TableRow _buildTableHeaders() {
    List<Widget> cells = [];

    for (int i = 0; i < controller.stoneHeaders.length; i++) {
      String header = controller.stoneHeaders.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sn") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: controller.stoneHeaders.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Visibility(
              visible:
                  header == 'WST/Tch' ||
                  header == 'MC (₹)' ||
                  header == 'Stone (₹)',
              child: Tooltip(
                message: "getTooltipMessage(header)",
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

  List<TableRow> _buildRows() {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index),
    );
  }

  TableRow _buildTableRow(int index) {
    List<Widget> cells = [
      _buildCell(
        text: (index + 1).toString(),
        editable: false,
        header: controller.stoneHeaders[0],
      ),
      _buildStoneNameAutocomplete(
        index,
        focusNode: controller.controllers[index].tableFocusNodes[0],
      ),
      _buildCell(
        textController: controller.controllers[index].name,
        header: controller.stoneHeaders[2],
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[1],
        readOnly: true,
      ),
      _buildCell(
        textController: controller.controllers[index].pcs,
        header: controller.stoneHeaders[3],
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[2],
      ),
      _buildCaratWeightCell(
        index,
        textFocusNode: controller.controllers[index].tableFocusNodes[3],
      ),
      _buildRateCell(
        index,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),
      _buildCell(
        textController: controller.controllers[index].total,
        header: controller.stoneHeaders[6],
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[5],
      ),
    ];

    cells.add(_buildMoreOptionsCell(index));

    return TableRow(children: cells);
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    FocusNode? focusNode,
    bool readOnly = false,
  }) {
    log("Assign Textfield focusNode to $rowIndex $focusNode ");
    bool isOthCodeSelected = controller.controllers[rowIndex].isOtherStone;

    if (header == controller.stoneHeaders[2] && isOthCodeSelected) {
      readOnly = false;
    } else if (header == controller.stoneHeaders[5] && isOthCodeSelected) {
      readOnly = false;
    }
    return Column(
      children: [
        Container(
          child:
              editable
                  ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: Obx(
                      () => Focus(
                        canRequestFocus: false,
                        onKeyEvent: (node, event) {
                          // Add special handling for Rate field - toggle unit with Alt+C
                          if (header == controller.stoneHeaders[5] &&
                              event is KeyDownEvent &&
                              event.logicalKey == LogicalKeyboardKey.keyC &&
                              HardwareKeyboard.instance.isAltPressed) {
                            controller.toggleRateUnit(rowIndex);
                            controller.updateRowAmount(rowIndex);
                            controller.updateTotals();
                            return KeyEventResult.handled;
                          }
                          return onTableKeyEvent(node, event, rowIndex);
                        },
                        child: TextFormField(
                          enabled: widget.isDisabled == true ? false : true,
                          readOnly: readOnly,
                          autofocus:
                              rowIndex == 0 &&
                                      header == controller.stoneHeaders[1]
                                  ? true
                                  : false,
                          onTap: () {
                            // setState(() {

                            // });
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
                          onEditingComplete: () {
                            if (textController != null) {
                              textController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: textController.text.length,
                              );
                            }
                          },
                          focusNode: focusNode,
                          controller: textController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            (header == controller.stoneHeaders[2] &&
                                    isOthCodeSelected)
                                ? FilteringTextInputFormatter
                                    .singleLineFormatter
                                : (header == 'Carat/gm' ||
                                        header == 'Carat/Weight'
                                    ? WeightInputFormatter()
                                    : AmountInputFormatter()),
                          ],
                          decoration: InputDecoration(
                            suffix:
                                header == 'Rate (₹)'
                                    ? CustomText(
                                      text:
                                          controller
                                              .controllers[rowIndex]
                                              .weightUnitFromBackend,
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
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            decoration: null,
                            decorationThickness: 2,
                            decorationColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter $header';
                            }
                            if (header == 'Pcs' ||
                                header == 'Rate (₹)' ||
                                header == 'Amount (₹)') {
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (header == 'Pcs' ||
                                header == 'Rate (₹)' ||
                                header == 'Carat/Weight') {
                              controller.updateRowAmount(rowIndex);
                            } else {
                              controller.updateTotals();
                            }
                          },
                        ),
                      ),
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 4, 13),
                    child: CustomText(
                      text: text!,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
        ),
        // CustomDashedLineWidget(
        //   width: Get.width,
        // )
      ],
    );
  }

  Widget _buildMoreOptionsCell(int rowIndex) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            size: 28,
            color:
                widget.isDisabled == true ? Colors.transparent : redTextColor,
          ),
          onPressed:
              () =>
                  widget.isDisabled == true
                      ? null
                      : controller.removeCurrentRow(rowIndex),
        ),
        const SizedBox(height: 8),
        // CustomDashedLineWidget(
        //   width: Get.width,
        // )
      ],
    );
  }

  void onStoneNameSelected({
    required GetStoneRatesValue selectedValue,
    required int index,
  }) {
    controller.setStonename(index: index, newValue: selectedValue.id!);
    bool isOthCode = selectedValue.isOther ?? false;
    if (isOthCode) {
      // When "Other" is selected, focus on the name field to enter custom name
      controller.controllers[index].tableFocusNodes[1].requestFocus();
      controller.currentColIndex.value = 1;
      controller.controllers[index].name.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.controllers[index].name.text.length,
      );
    } else {
      // Focus on Pcs field (index 2) instead of Carat/Weight (index 3)
      Future.delayed(const Duration(milliseconds: 50), () {
        controller.controllers[index].tableFocusNodes[2].requestFocus();
        controller.currentColIndex.value = 2;
        var textController = controller.controllers[index].pcs;
        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
      });
    }

    setState(() {});
  }

  Widget _buildStoneNameAutocomplete(int index, {FocusNode? focusNode}) {
    return Column(
      key: UniqueKey(),
      children: [
        GenericAutocompleteDropdown<GetStoneRatesValue>(
          controller: controller.controllers[index].stone_code,
          focusNode: controller.controllers[index].tableFocusNodes[0],
          items: const [],
          getDisplayValue: (stone) => stone.code ?? '',
          onEditingComplete: () {
            FocusManager.instance.primaryFocus?.nextFocus();
          },
          onSelected: (selectedValue) async {
            if (selectedValue.id == null && selectedValue.code == ADD_NEW) {
              controller.controllers[index].name.text = "";
              await Get.dialog(const AddStoneRatesDialog());
              await controller.getStoneRatesDetails();
            } else {
              onStoneNameSelected(index: index, selectedValue: selectedValue);
            }
          },
          autofocus: true,
          isLastRow: controller.controllers.length == index + 1,
          onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
          onTap: () {
            controller.currentRowIndex.value = index;
            controller.currentColIndex.value = controller
                .controllers[index]
                .tableFocusNodes
                .indexOf(controller.controllers[index].tableFocusNodes[0]);
            // controller.controllers[index].tableFocusNodes[0].requestFocus();
          },
          customOptionsBuilder: (textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return controller.getStoneRatesResponse.value.data?.values ?? [];
            }

            final searchText = textEditingValue.text.toLowerCase();
            if (searchText.isEmpty) {
              return controller.getStoneRatesResponse.value.data?.values ?? [];
            }

            var list =
                controller.getStoneRatesResponse.value.data?.values?.where(
                  (value) =>
                      // Search through code
                      (value.code?.toLowerCase().contains(searchText) ??
                          false) ||
                      // Also search through name
                      (value.name?.toLowerCase().contains(searchText) ??
                          false) ||
                      // Always include "Add New" option
                      (value.code == ADD_NEW),
                ) ??
                [];

            return list;
          },
          maxWidthForOptions: DROPDOWN_OPTIONS_MAX_WIDTH,
          itemBuilder:
              (item) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      text: item.name ?? "",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      color: item.code == ADD_NEW ? secondaryColor : null,
                    ),
                  ),
                  if (item.code != ADD_NEW)
                    CustomText(
                      text: item.code ?? "",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
        ),
      ],
    );
  }

  Widget _buildCaratWeightCell(int index, {FocusNode? textFocusNode}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Focus(
            onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
            canRequestFocus: false,
            child: Focus(
              canRequestFocus: false,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.keyC &&
                    HardwareKeyboard.instance.isAltPressed) {
                  controller.setWeightOrCarat(index: index);
                  controller.updateRowAmount(index);
                  controller.updateTotals();
                  setState(() {});
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => TextFormField(
                        enabled: widget.isDisabled == true ? false : true,
                        onTap:
                            () => setState(() {
                              controller.currentRowIndex.value = index;
                              controller.currentColIndex.value = controller
                                  .controllers[index]
                                  .tableFocusNodes
                                  .indexOf(textFocusNode!);
                              controller
                                  .controllers[index]
                                  .carat_weight
                                  .selection = TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    controller
                                        .controllers[index]
                                        .carat_weight
                                        .text
                                        .length,
                              );
                            }),
                        keyboardType: TextInputType.number,
                        controller: controller.controllers[index].carat_weight,
                        inputFormatters: [WeightInputFormatter()],
                        focusNode: textFocusNode,
                        decoration: InputDecoration(
                          suffix: Obx(
                            () => CustomText(
                              text: controller.controllers[index].weightUnit,
                            ),
                          ),
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
                                  controller.controllers.length == index + 1
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
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.updateRowAmount(index);
                          controller.updateTotals();
                        },
                      ),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // Expanded(
                  //   flex: 2,
                  //   child: DropdownButtonFormField<String>(
                  //     value: controller.controllers[index].weightUnit,
                  //     isExpanded: true,
                  //     dropdownColor: whiteColor,
                  //     focusNode: dropdownFocusNode,
                  //     items: controller.weightUnits.map((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         alignment: AlignmentDirectional.center,
                  //         child: Text(
                  //           value,
                  //           textAlign: TextAlign.right,
                  //         ),
                  //       );
                  //     }).toList(),
                  //     onChanged: (String? newValue) {
                  //       controller.setWeightOrCarat(
                  //           index: index, newValue: newValue!);
                  //       controller.updateTotals();
                  //     },
                  //     decoration: InputDecoration(
                  //       contentPadding: const EdgeInsets.all(10),
                  //       isDense: true,
                  //       border: const OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //             color: controller.controllers.length == index + 1
                  //                 ? secondaryColor
                  //                 : Colors.transparent),
                  //         borderRadius: const BorderRadius.all(
                  //           Radius.circular(8.0),
                  //         ),
                  //       ),
                  //       focusedBorder: const OutlineInputBorder(
                  //         borderSide: BorderSide(color: secondaryColor, width: 2.0),
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(8.0),
                  //         ),
                  //       ),
                  //     ),
                  //     style: const TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        // CustomDashedLineWidget(
        //   width: Get.width,
        // )
      ],
    );
  }

  Widget _buildRateCell(int index, {FocusNode? focusNode}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Focus(
            onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
            canRequestFocus: false,
            child: Focus(
              canRequestFocus: false,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.keyC &&
                    HardwareKeyboard.instance.isAltPressed) {
                  controller.toggleRateUnit(index);
                  controller.updateRowAmount(index);
                  controller.updateTotals();
                  setState(() {}); // Force UI update
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(
                      () => TextFormField(
                        enabled: widget.isDisabled == true ? false : true,
                        readOnly: !controller.controllers[index].isOtherStone,
                        onTap:
                            () => setState(() {
                              controller.currentRowIndex.value = index;
                              controller.currentColIndex.value = controller
                                  .controllers[index]
                                  .tableFocusNodes
                                  .indexOf(focusNode!);
                              controller
                                  .controllers[index]
                                  .rate
                                  .selection = TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    controller
                                        .controllers[index]
                                        .rate
                                        .text
                                        .length,
                              );
                            }),
                        keyboardType: TextInputType.number,
                        controller: controller.controllers[index].rate,
                        inputFormatters: [AmountInputFormatter()],
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          suffix: CustomText(
                            text:
                                controller
                                    .controllers[index]
                                    .weightUnitFromBackend,
                          ),
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
                                  controller.controllers.length == index + 1
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
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Rate (₹)';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.updateRowAmount(index);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ItemListHeaderTable(
          headers: controller.totalHeadersValue.toList(),
          columnWidthsCustom: getColumnWidths(
            columnWidths: controller.totalColumnWidths,
            context: context,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: totalGreenColor,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Visibility(
      visible: widget.isDisabled == true ? false : true,
      child: Row(
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ButtonShortcutWidget(
              focusNode: nextButtonFocusNode,
              onTap: () async {
                await validateAndSaveStoneData();
              },
              buttonName: "Next",
              shortcut: "CTRL + S",
              color: whiteColor,
              shortcutButtonColor: primaryColor,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Future<void> validateAndSaveStoneData() async {
    // final itemsController = Get.find<ItemDetailsController>();
    // double netWeight =
    //     double.tryParse(itemsController.controllers[0].nwt.text) ?? 0;
    // double currentTotalWeight = double.tryParse(controller
    //         .totalHeadersValue[controller.totalHeadersValue.length - 4]) ??
    //     0;
    // if (currentTotalWeight > netWeight) {
    //   showErrorToast(message: "Net Weight doesn't match");
    //   return;
    // }
    controller.controllers.removeWhere(
      (element) =>
          element.name.text.isEmpty &&
          (element.pcs.text.isEmpty || element.pcs.text == "1") &&
          element.carat_weight.text.isEmpty &&
          element.rate.text.isEmpty &&
          element.total.text.isEmpty,
    );
    await Future.delayed(const Duration(milliseconds: 100));
    if (controller.formKey.currentState!.validate()) {
      double value =
          double.tryParse(
            controller.totalHeadersValue[controller.totalHeadersValue.length -
                2],
          ) ??
          0.00;
      widget.onSave(value, controller.controllers);
      Get.back();
    }
  }
}
