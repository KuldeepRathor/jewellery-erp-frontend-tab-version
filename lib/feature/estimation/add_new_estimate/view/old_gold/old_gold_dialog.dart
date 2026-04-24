// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/old_gold/old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class OldGoldDetailsTableData {
  String? id;
  TextEditingController code;

  TextEditingController description;
  TextEditingController pcs;
  TextEditingController gross_wtt;
  TextEditingController less;
  TextEditingController net_wtt;
  TextEditingController purity;
  TextEditingController rate;
  TextEditingController amount;
  TextEditingController round_off;
  TextEditingController total_amount;
  String? selectedPurityType;
  MetalType? selectedMetalType;
  String? ornamentId;
  String? ornamentName;
  List<FocusNode> tableFocusNodes = List.generate(10, (index) => FocusNode());
  OldGoldDetailsTableData({
    this.id,
    required this.code,
    required this.description,
    required this.pcs,
    required this.gross_wtt,
    required this.less,
    required this.net_wtt,
    required this.purity,
    required this.rate,
    required this.amount,
    required this.round_off,
    required this.total_amount,
    this.selectedPurityType,
    this.selectedMetalType,
    this.ornamentId,
    this.ornamentName,
  });
  Map<String, dynamic> toJsonValue() {
    return {
      "id": id,
      "code": code.text,
      "description": description.text,
      "pcs": pcs.text,
      'gross_wtt': gross_wtt.text,
      'less': less.text,
      'net_wtt': net_wtt.text,
      'purity': purity.text,
      'rate': rate.text,
      'amount': amount.text,
      'round_off': round_off.text,
      'total_amount': total_amount.text,
      'selectedPurityType': selectedPurityType, // ADDED
      'metalType': selectedMetalType?.toJson(),
    };
  }
}

class OldGoldDialog extends StatefulWidget {
  const OldGoldDialog({super.key});

  @override
  State<OldGoldDialog> createState() => _OldGoldDialogState();
}

class _OldGoldDialogState extends State<OldGoldDialog> {
  final OldGoldController controller = Get.find<OldGoldController>();
  final InventoryViewmodel inventoryViewmodel = Get.find<InventoryViewmodel>();

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
        log("Arrow up");
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
        print("inside escape pressed");
        if (controller.currentColIndex.value == 0) {
          print("inside escape pressed ignored");
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

    // ADD THIS: Ensure GoldRateController is registered
    if (!Get.isRegistered<GoldRateController>()) {
      Get.put(GoldRateController());
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initializeRow();
      print("logging init");
      controller.controllers.last.tableFocusNodes[0].requestFocus();
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
              // await controller.validateAndPostPurchaseInvoice();
              Get.back();
              return;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const SaveStoneDetailsIntent(),
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
                  child: FocusScope(
                    autofocus: true,

                    // onKeyEvent: onNormalKeyEvent,
                    child: _buildContent(),
                  ),
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
            onPressed: Get.back,
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
                            shortcutButtonBackgroundColor: shortcutGreyColor,
                            canRequestFocus: false,
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
        // _buildTextCell(
        //   textController: row.code, // Using the new implementation here
        // ),
        // _buildCell(
        //   textController: row.code,
        //   rowIndex: index,
        //   focusNode: row.tableFocusNodes[0],
        // ),
        _buildCodeDropdown(
          index: index,
          controller: controller,
          focusNode: row.tableFocusNodes[0],
        ),
        _buildCell(
          textController: row.description,
          rowIndex: index,
          focusNode: row.tableFocusNodes[1],
          header: controller.paymentHeaders[2], // Description
        ),
        _buildCell(
          textController: row.pcs,
          rowIndex: index,
          focusNode: row.tableFocusNodes[2],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[3], // Pcs
        ),
        _buildCell(
          textController: row.gross_wtt,
          rowIndex: index,
          focusNode: row.tableFocusNodes[3],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[4], // Gross Wt.
        ),
        _buildCell(
          textController: row.less,
          rowIndex: index,
          focusNode: row.tableFocusNodes[4],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[5], // Less
          validator: (p0) {
            return null;
          },
        ),
        _buildCell(
          textController: row.net_wtt,
          rowIndex: index,
          focusNode: row.tableFocusNodes[5],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[6], // Net Wt.
        ),
        _buildCell(
          textController: row.purity,
          rowIndex: index,
          focusNode: row.tableFocusNodes[6],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[7], // Pure
          validator: controller.validatePurity,
          onChanged: (value) {
            // Remove any non-numeric characters except decimal point
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
        ),
        _buildCell(
          textController: row.rate,
          rowIndex: index,
          focusNode: row.tableFocusNodes[7],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[8], // Rate
        ),
        _buildCell(
          textController: row.round_off,
          rowIndex: index,
          focusNode: row.tableFocusNodes[8],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[9], // Round Off
        ),
        _buildCell(
          textController: row.total_amount,
          rowIndex: index,
          focusNode: row.tableFocusNodes[9],
          keyboardType: TextInputType.number,
          header: controller.paymentHeaders[10], // Total
        ),
        _buildDeleteIcon(index),
      ],
    );
  }

  Widget _buildCodeDropdown({
    required int index,
    required OldGoldController controller,
    required FocusNode focusNode,
  }) {
    return Obx(() {
      return GenericAutocompleteDropdown<GetAllOrnamentsResponseValue>(
        controller: controller.controllers[index].code,
        focusNode: focusNode,
        // autofocus: true,
        items: controller.codeList,
        getDisplayValue: (item) => item.code ?? '',
        onSelected: (selectedValue) {
          if (selectedValue.code != null) {
            controller.controllers[index].code.text = selectedValue.code!;
            controller.setItemDescription(index, selectedValue.code!);
            controller.controllers[index].tableFocusNodes[1].requestFocus();
            controller.currentColIndex.value = 1;
          }
        },
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
        enabled: controller.controllers[index].id == null,
        isLastRow: controller.controllers.length == index + 1,
        onTap: () {
          controller.currentRowIndex.value = index;
          controller.currentColIndex.value = 0;
        },
      );
    });
  }

  // Widget _buildPurityDropdown({
  //   required int index,
  //   required OldGoldController controller,
  //   required FocusNode focusNode,
  // }) {
  //   return Obx(() {
  //     final purityValues =
  //         controller.getPurityResponse.value.data?.values?.toList() ?? [];

  //     return GenericAutocompleteDropdown<String>(
  //       controller: controller.controllers[index].purity,
  //       focusNode: focusNode,
  //       items: purityValues,
  //       getDisplayValue: (item) => item,
  //       onSelected: (selectedValue) {
  //         controller.controllers[index].purity.text = selectedValue;
  //         // Set rate based on selected purity
  //         RateCaratInputController rateCaratInputController =
  //             Get.find<RateCaratInputController>();
  //         final rate = rateCaratInputController.getRateForPurity(selectedValue);
  //         controller.controllers[index].rate.text = rate;

  //         // Calculate amount with new rate
  //         controller.calculateAmount(index);

  //         controller.controllers[index].tableFocusNodes[7].requestFocus();
  //       },
  //       onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
  //       enabled:
  //           controller.getPurityResponse.value.status == Status.COMPLETED &&
  //               controller.controllers[index].id == null,
  //       isLastRow: controller.controllers.length == index + 1,
  //       onTap: () {
  //         controller.currentRowIndex.value = index;
  //         controller.currentColIndex.value =
  //             controller.controllers[index].tableFocusNodes.indexOf(focusNode);
  //       },
  //     );
  //   });
  // }
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
                  child: TextFormField(
                    focusNode: focusNode,
                    readOnly:
                        controller.controllers[rowIndex].id != null
                            ? true
                            : false,
                    onTap: () {
                      controller.currentRowIndex.value = rowIndex;
                      controller.currentColIndex.value = controller
                          .controllers[rowIndex]
                          .tableFocusNodes
                          .indexOf(focusNode!);
                    },
                    onChanged: (value) {
                      if (onChanged != null) {
                        onChanged(value);
                      }
                      // Add calculation triggers
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                log(
                  "tapped here ${jsonEncode(controller.controllers.first.toJsonValue())}",
                );
                // controller.controllers.first.toJsonValue();
                Get.back();
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
    // For weight fields (3 decimal places)
    if (header == 'Gross Wt.' || header == 'Net Wt.' || header == 'Less') {
      return [
        WeightInputFormatter(), // Max 3 decimal places
      ];
    }
    // For amount fields (2 decimal places)
    else if (header == 'Rate' || header == 'Total' || header == 'Round Off') {
      return [
        AmountInputFormatter(), // Max 2 decimal places
      ];
    }
    // For integer fields (no decimal places)
    else if (header == 'Pcs') {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    // For purity field (percentage, 0-100)
    else if (header == 'Pure') {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
      ];
    }
    // For fields that should be alphanumeric (Code)
    else if (header == 'Code') {
      return [
        // Allow letters, numbers, and some special characters commonly used in codes
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_/]')),
      ];
    } else {
      return [];
    }
  }
}
