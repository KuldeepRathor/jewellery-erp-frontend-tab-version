import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class CreateOrderOldGoldDialog extends StatefulWidget {
  const CreateOrderOldGoldDialog({super.key});

  @override
  State<CreateOrderOldGoldDialog> createState() =>
      _CreateOrderOldGoldDialogState();
}

class _CreateOrderOldGoldDialogState extends State<CreateOrderOldGoldDialog> {
  final CreateOrderOldGoldController controller = Get.put(
    CreateOrderOldGoldController(),
  );

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter &&
          controller.currentColIndex.value == 0) {
        return KeyEventResult.ignored;
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          if (controller.currentColIndex.value == 6) {
            controller.handlePurityFocusLoss(rowIndex);
          }
          controller.moveNextFocus();
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab &&
          HardwareKeyboard.instance.isShiftPressed) {
        controller.movePreviousFocus(node);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        if (controller.currentColIndex.value == 6) {
          controller.handlePurityFocusLoss(rowIndex);
        }
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
      if (event.logicalKey == LogicalKeyboardKey.escape) {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeRow();
      if (controller.controllers.isNotEmpty) {
        controller.controllers.last.tableFocusNodes[0].requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Actions(
        actions: <Type, Action<Intent>>{
          SaveStoneDetailsIntent: CallbackAction<SaveStoneDetailsIntent>(
            onInvoke: (intent) async {
              bool isValid = await controller.validateAndSave();
              if (isValid) {
                Get.back(result: true);
              }
              return;
            },
          ),
          DiscardStoneDetailsIntent: CallbackAction<DiscardStoneDetailsIntent>(
            onInvoke: (intent) {
              controller.clearAllFields();
              return;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const SaveStoneDetailsIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
                const DiscardStoneDetailsIntent(),
          },
          child: Container(
            height: Get.height * 0.5,
            width: Get.width * 0.75,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: FocusScope(autofocus: true, child: _buildContent()),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            spreadRadius: 0.5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Add Old Gold Details',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () {
              Get.back(result: true);
            },
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Focus(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CustomText(
                        text: 'Old Gold Details',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonShortcutWidget(
                            onTap: controller.validateAndAddRow,
                            buttonName: "+ Add",
                            shortcut: "Enter",
                            color: primaryColor,
                            canRequestFocus: false,
                            shortcutButtonBackgroundColor: shortcutGreyColor,
                          ),
                          ButtonShortcutWidget(
                            onTap: controller.removeLastRow,
                            buttonName: "Remove",
                            shortcut: "Shift+Esc",
                            color: redTextColor,
                            canRequestFocus: false,
                            shortcutButtonBackgroundColor: shortcutRedColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(
                      () => CustomTableWidget(
                        headers: [_buildTableHeaders()],
                        columnWidths: controller.oldGoldColumnWidths,
                        rows: _buildRows(),
                        isLoadingMore: false,
                        controller: controller.scrollController,
                        addSizedBox: false,
                      ),
                    ),
                  ),
                  Obx(
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableHeaders() {
    List<Widget> cells = [];

    for (int i = 0; i < controller.paymentHeaders.length; i++) {
      String header = controller.paymentHeaders.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sn") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: header,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
    final row = controller.controllers[index];
    return TableRow(
      children: [
        _buildCell(text: (index + 1).toString(), editable: false),
        _buildCodeDropdown(
          index: index,
          controller: controller,
          focusNode: row.tableFocusNodes[0],
        ),
        _buildCell(
          textController: row.description,
          rowIndex: index,
          focusNode: row.tableFocusNodes[1],
          header: controller.paymentHeaders[2],
        ),
        _buildCell(
          textController: row.pcs,
          rowIndex: index,
          focusNode: row.tableFocusNodes[2],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[3],
        ),
        _buildCell(
          textController: row.gross_wtt,
          rowIndex: index,
          focusNode: row.tableFocusNodes[3],
          keyboardType: TextInputType.number,
          selectAllOnTap: true,
          header: controller.paymentHeaders[4],
        ),
        _buildCell(
          textController: row.less,
          rowIndex: index,
          focusNode: row.tableFocusNodes[4],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[5],
          validator: (p0) {
            return null;
          },
        ),
        _buildCell(
          textController: row.net_wtt,
          rowIndex: index,
          focusNode: row.tableFocusNodes[5],
          keyboardType: TextInputType.number,
          selectAllOnTap: true,
          header: controller.paymentHeaders[6],
        ),
        _buildCell(
          textController: row.purity,
          rowIndex: index,
          focusNode: row.tableFocusNodes[6],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[7],
          validator: controller.validatePurity,
          selectAllOnTap: true,
          onChanged: (value) {
            final cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
            if (cleanValue != value) {
              row.purity.text = cleanValue;
            }
            double val = double.tryParse(cleanValue) ?? 0;
            if (val > 100) {
              row.purity.text = "100";
            }
            controller.calculateAmount(index);
          },
          onFocusChange: (hasFocus) {
            if (!hasFocus && controller.currentColIndex.value == 6) {
              controller.handlePurityFocusLoss(index);
            }
          },
        ),
        _buildCell(
          textController: row.rate,
          rowIndex: index,
          focusNode: row.tableFocusNodes[7],
          keyboardType: TextInputType.number,
          selectAllOnTap: true,
          header: controller.paymentHeaders[8],
        ),
        _buildCell(
          textController: row.round_off,
          rowIndex: index,
          focusNode: row.tableFocusNodes[8],
          keyboardType: TextInputType.number,
          selectAllOnTap: true,
          header: controller.paymentHeaders[9],
        ),
        _buildCell(
          textController: row.total_amount,
          rowIndex: index,
          focusNode: row.tableFocusNodes[9],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[10],
        ),
        _buildDeleteIcon(index),
      ],
    );
  }

  Widget _buildDeleteIcon(int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 26),
          onPressed: () {
            controller.removeCurrentRow(index);
          },
          splashRadius: 20,
          tooltip: "Delete row",
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    bool editable = true,
    int rowIndex = 0,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    String? header,
    bool selectAllOnTap = false,
    Function(bool)? onFocusChange,
  }) {
    return Container(
      child:
          editable
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Focus(
                  canRequestFocus: false,
                  onKeyEvent:
                      (node, event) => onTableKeyEvent(node, event, rowIndex),
                  onFocusChange: (hasFocus) {
                    if (hasFocus &&
                        selectAllOnTap &&
                        textController != null &&
                        textController.text.isNotEmpty) {
                      Future.delayed(const Duration(milliseconds: 50), () {
                        textController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: textController.text.length,
                        );
                      });
                    }

                    if (onFocusChange != null) {
                      onFocusChange(hasFocus);
                    }
                  },
                  child: TextFormField(
                    focusNode: focusNode,
                    onTap: () {
                      controller.currentRowIndex.value = rowIndex;
                      controller.currentColIndex.value = controller
                          .controllers[rowIndex]
                          .tableFocusNodes
                          .indexOf(focusNode!);

                      if (selectAllOnTap &&
                          textController != null &&
                          textController.text.isNotEmpty) {
                        Future.delayed(const Duration(milliseconds: 50), () {
                          textController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: textController.text.length,
                          );
                        });
                      }
                    },
                    onChanged: (value) {
                      if (onChanged != null) {
                        onChanged(value);
                      }
                      if (textController ==
                              controller.controllers[rowIndex].gross_wtt ||
                          textController ==
                              controller.controllers[rowIndex].less) {
                        controller.calculateNetWeight(rowIndex);
                      }

                      controller.calculateAmount(rowIndex);
                      controller.updateTotals();
                    },
                    controller: textController,
                    keyboardType: keyboardType,
                    inputFormatters:
                        header != null ? getInputFormatters(header) : [],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      isDense: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      suffixText:
                          textController ==
                                  controller.controllers[rowIndex].purity
                              ? '%'
                              : null,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    validator:
                        validator ??
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (keyboardType == TextInputType.number) {
                            if (double.tryParse(value) == null) {
                              return 'Invalid number';
                            }
                          }
                          return null;
                        },
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
    required CreateOrderOldGoldController controller,
    required FocusNode focusNode,
  }) {
    return Obx(() {
      return GenericAutocompleteDropdown<GetAllOrnamentsResponseValue>(
        controller: controller.controllers[index].code,
        focusNode: focusNode,
        items: controller.codeList,
        getDisplayValue: (item) => item.code ?? '',
        maxWidthForOptions: DROPDOWN_OPTIONS_MAX_WIDTH,
        onSelected: (selectedValue) {
          if (selectedValue.code != null) {
            controller.controllers[index].code.text = selectedValue.code!;
            controller.setItemDescription(index, selectedValue.code!);
            controller.controllers[index].tableFocusNodes[1].requestFocus();
            controller.currentColIndex.value = 1;
          }
        },
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
        isLastRow: controller.controllers.length == index + 1,
        onTap: () {
          controller.currentRowIndex.value = index;
          controller.currentColIndex.value = controller
              .controllers[index]
              .tableFocusNodes
              .indexOf(focusNode);
        },
      );
    });
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            spreadRadius: 0.5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              controller.clearAllFields();
            },
            child: Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: CustomText(
                  text: "Discard",
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: Get.width * 0.01),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                bool isValid = await controller.validateAndSave();
                if (isValid) {
                  Get.back(result: true);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 38,
                width: 140,
                child: Center(
                  child: Obx(
                    () =>
                        controller.isLoading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : ButtonShortcutWidget(
                              buttonName: "Save",
                              shortcut: "Ctrl + S",
                              buttonsize: 16,
                              color: whiteColor,
                              shortcutButtonColor: primaryColor,
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextInputFormatter> getInputFormatters(String? header) {
    if (header == 'Gross Wt.' || header == 'Net Wt.' || header == 'Less') {
      return [WeightInputFormatter()];
    } else if (header == 'Rate' || header == 'Total' || header == 'Round Off') {
      return [AmountInputFormatter()];
    } else if (header == 'Pcs') {
      return [FilteringTextInputFormatter.digitsOnly];
    } else if (header == 'Pure') {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
      ];
    } else if (header == 'Code') {
      return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_/]'))];
    } else {
      return [];
    }
  }
}
