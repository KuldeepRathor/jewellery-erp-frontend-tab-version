// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/text_with_shortcut_button_widget.dart';

class SalesReturnTableWidget extends StatefulWidget {
  const SalesReturnTableWidget({super.key});

  @override
  State<SalesReturnTableWidget> createState() => _SalesReturnTableWidgetState();
}

class _SalesReturnTableWidgetState extends State<SalesReturnTableWidget> {
  final SalesReturnItemDetailsController controller =
      Get.find<SalesReturnItemDetailsController>();
  final SalesReturnViewmodel salesReturnViewmodel =
      Get.find<SalesReturnViewmodel>();

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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Item Details',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          Spacer(),
                          // ButtonShortcutWidget(
                          //   // onTap: () =>
                          //   //     controller.fetchTaggingLineItemCodeTag(0),
                          //   buttonName: "+ Add",
                          //   shortcut: "Enter",
                          //   color: primaryColor,
                          //   shortcutButtonBackgroundColor: shortcutGreyColor,
                          //   canRequestFocus: false,
                          // ),
                          // ButtonShortcutWidget(
                          //   // onTap: controller.removeLastRow,
                          //   buttonName: "Remove",
                          //   shortcut: "Shift+Esc",
                          //   color: redTextColor,
                          //   shortcutButtonBackgroundColor: shortcutRedColor,
                          //   canRequestFocus: false,
                          // ),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                      child: Row(
                        children: [
                          const Spacer(),
                          TextWithShortcutButton(
                            text: 'View More',
                            controlKey: 'Ctrl',
                            functionKey: 'F10',
                            onPressed: () {
                              print('Button pressed!');
                              // Add your desired action here
                            },
                          ),
                          const SizedBox(width: 16),
                        ],
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

  TableRow _buildTableHeaders(SalesReturnItemDetailsController controller) {
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

  List<TableRow> _buildRows(SalesReturnItemDetailsController controller) {
    log("Controller length ${controller.controllers.length}");

    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(
    int index,
    SalesReturnItemDetailsController controller,
  ) {
    bool readOnly = salesReturnViewmodel.isFastMode.value;
    List<Widget> cells = [
      _buildCheckbox(index, controller),
      _buildTextCell(text: (index + 1).toString()),
      // Item Code
      _buildCell(
        textController: controller.controllers[index].code,
        header: 'Item Code',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[0],
        readOnly: true,
      ),
      // Tag No
      _buildCell(
        textController: controller.controllers[index].tagNo,
        header: 'Tag No',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[1],
        readOnly: true,
      ),
      // Item Description
      _buildCell(
        textController: controller.controllers[index].item_description,
        header: 'Description',
        rowIndex: index,
        controller: controller,
        readOnly: true,
      ),
      // Pcs
      _buildCell(
        textController: controller.controllers[index].pcs,
        header: 'Pcs',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[2],
        readOnly: true,
      ),
      // G.Wt.
      _buildCell(
        textController: controller.controllers[index].gwt,
        header: 'G.Wt. (gm)',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[3],
        readOnly: readOnly,
      ),
      // N.Wt.
      _buildCell(
        textController: controller.controllers[index].nwt,
        header: 'N.Wt. (gm)',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[4],
        readOnly: readOnly,
      ),
      // VA
      _buildCell(
        textController: controller.controllers[index].va,
        header: 'VA',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[5],
        readOnly: readOnly,
      ),
      // MC
      _buildCell(
        textController: TextEditingController(
          text: getMcTotalValue(index: index),
        ),
        header: 'MC (₹)',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[6],
        readOnly: readOnly,
      ),
      // Stone Cost
      _buildCell(
        textController: controller.controllers[index].stone,
        header: 'Stone Cost(₹)',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[7],
        readOnly: readOnly,
      ),
      // Hall Mark
      _buildCell(
        textController: controller.controllers[index].hallMark,
        header: 'Hall Mark',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[8],
        readOnly: true,
      ),
      // Cost Discount
      _buildCell(
        textController: controller.controllers[index].costDiscount,
        header: 'Cost Discount',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[9],
        readOnly: true,
      ),
      // Sales Amount
      _buildCell(
        textController: controller.controllers[index].salesAmount,
        header: 'Sales Amount',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[10],
        readOnly: true,
      ),
      // Total
      _buildCell(
        textController: controller.controllers[index].total,
        header: 'Total',
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[11],
        readOnly: true,
      ),
    ];

    cells.add(_buildMoreOptionsCell(index, controller));
    return TableRow(children: cells);
  }

  String getMcTotalValue({required int index}) {
    final itemData = controller.controllers[index];

    final mcValue = double.tryParse(itemData.mc.text) ?? 0;

    final makingChargesType =
        itemData.itemResponse?.makingChargesType?.toLowerCase() ?? '';

    double mcTotalValue = 0;
    if (makingChargesType == "gwt") {
      final gwt = double.tryParse(itemData.gwt.text) ?? 0;
      mcTotalValue = mcValue * gwt;
    } else if (makingChargesType == "nwt") {
      final nwt = double.tryParse(itemData.nwt.text) ?? 0;
      mcTotalValue = mcValue * nwt;
    } else {
      // Fixed or per piece
      mcTotalValue = mcValue;
    }

    return mcTotalValue.toStringAsFixed(2);
  }

  Widget _buildCheckbox(
    int rowIndex,
    SalesReturnItemDetailsController controller,
  ) {
    final itemResponse = controller.controllers[rowIndex].itemResponse;
    final taggingStatus = itemResponse?.taggingRecord?.status;
    final isReturned = taggingStatus == "Returned";

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Row(
        children: [
          CustomCheckBoxWidget(
            onChanged:
                isReturned
                    ? null
                    : (value) {
                      controller.controllers[rowIndex].isSelected =
                          value ?? false;
                      controller.updateTotals();
                      final SalesReturnSearchPartyController
                      salesReturnSearchPartyController = Get.put(
                        SalesReturnSearchPartyController(),
                      );
                      final salesPerson =
                          controller
                              .controllers[rowIndex]
                              .itemResponse
                              ?.salesPerson;
                      if (salesPerson != null) {
                        salesReturnSearchPartyController.setSelectedEmployee(
                          GetEmployeesValue(
                            id: salesPerson.id!,
                            employeeId: salesPerson.employeeId,
                            organizationId: salesPerson.organizationId,
                            shopId: salesPerson.shopId,
                            firstName: salesPerson.firstName,
                            lastName: salesPerson.lastName,
                            email: salesPerson.email,
                            phoneNumber: salesPerson.phoneNumber,
                            phoneCountryCode: salesPerson.phoneCountryCode,
                            code: salesPerson.code,
                          ),
                        );
                      }
                      setState(() {});
                    },
            value:
                isReturned
                    ? false
                    : controller.controllers[rowIndex].isSelected,
          ),
          if (isReturned)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Tooltip(
                message: "This item has already been returned",
                child: Icon(Icons.info_outline, size: 16, color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildTextCell({required String text}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: CustomText(
        text: text,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCell({
    TextEditingController? textController,
    String? header,
    int rowIndex = 0,
    required SalesReturnItemDetailsController controller,
    FocusNode? focusNode,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
        child: Obx(
          () => TextFormField(
            controller: textController,
            readOnly: readOnly,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: getInputFormatters(header),
            onTap: () {
              log("Setting current values $header");
              controller.currentRowIndex.value = rowIndex;

              if (focusNode != null) {
                controller.currentColIndex.value = controller
                    .controllers[rowIndex]
                    .tableFocusNodes
                    .indexOf(focusNode);
              }
            },
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
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              disabledBorder: InputBorder.none,
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
                if (header == 'Tag No' ||
                    header == 'Pcs' ||
                    header == 'G.Wt. (gm)' ||
                    header == 'VA' ||
                    header == 'MC (₹)' ||
                    header == 'Stone Cost(₹)') {
                  return null;
                } else {
                  return 'Please enter $header';
                }
              }

              // ADD CORRECTION MODE VALIDATION
              String? correctionError = controller
                  .getCorrectionModeErrorMessage(header, value, rowIndex);
              if (correctionError != null) {
                return correctionError;
              }

              if (header == 'Pcs' ||
                  header == 'G.Wt. (gm)' ||
                  header == 'N.Wt. (gm)' ||
                  header == 'VA' ||
                  header == 'MC (₹)' ||
                  header == 'Stone Cost(₹)' ||
                  header == 'Hall Mark' ||
                  header == 'Cost Discount' ||
                  header == 'Sales Amount' ||
                  header == 'Total') {
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
              // Handle Item Code and Tag No
              if (header == "Item Code" || header == "Tag No") {
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

              // ADD CORRECTION MODE VALIDATION IN ONCHANGED
              if (!controller.validateCorrectionModeValue(
                header,
                value,
                rowIndex,
              )) {
                // Show a toast or some indication that the value is invalid
                showErrorToast(
                  message: "Value cannot exceed original fetched value",
                );
                return;
              }

              // If changing numeric fields that affect calculations
              if (header == 'VA' ||
                  header == 'MC (₹)' ||
                  header == 'Stone Cost(₹)' ||
                  header == 'Hall Mark' ||
                  header == 'Cost Discount' ||
                  header == 'G.Wt. (gm)' ||
                  header == 'N.Wt. (gm)') {
                // Recalculate sales amount and total
                controller.calculateSalesAndTotalAmount(index: rowIndex);
              }

              // Update totals and refresh UI
              controller.updateTotals();
              setState(() {});
            },
            onEditingComplete: () {
              print("on Editing called");
            },
          ),
        ),
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
        header == 'Stone Cost(₹)' ||
        header == 'Hall Mark' ||
        header == 'Cost Discount' ||
        header == 'Sales Amount' ||
        header == 'Total') {
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

  Widget _buildMoreOptionsCell(
    int rowIndex,
    SalesReturnItemDetailsController controller,
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
            case 'Return':
              // Handle return action
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
