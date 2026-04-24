import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/create_order_add_notes_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/create_order_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class CreateOrderItemDetailsWidget extends StatefulWidget {
  const CreateOrderItemDetailsWidget({super.key});

  @override
  State<CreateOrderItemDetailsWidget> createState() =>
      _CreateOrderItemDetailsWidgetState();
}

class _CreateOrderItemDetailsWidgetState
    extends State<CreateOrderItemDetailsWidget> {
  final CreateOrderItemDetailsController controller = Get.put(
    CreateOrderItemDetailsController(),
  );
  final InventoryViewmodel inventoryViewmodel = Get.find<InventoryViewmodel>();
  final CreateOrderViewModel createOrderViewModel =
      Get.find<CreateOrderViewModel>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    log("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          controller.validateAndAddRow();
          return KeyEventResult.handled;
        } else {
          // Allow the dropdown to handle the Enter key if it's the active field
          if (controller.currentColIndex.value == 2 &&
              node == controller.controllers[rowIndex].tableFocusNodes[2]) {
            // This is the purity dropdown - let it handle Enter natively
            return KeyEventResult.ignored;
          }
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
    return Focus(
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
                // Header with title and buttons
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
                        shortcut: "Shift+Enter",
                        color: primaryColor,
                        shortcutButtonBackgroundColor: shortcutGreyColor,
                      ),
                      const SizedBox(width: 8),
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
                // Table
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                ),
                // Total row
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

                // After the existing Total row, add:
                Obx(() {
                  final CreateOrderOldGoldController oldGoldController =
                      Get.find<CreateOrderOldGoldController>();

                  controller.updateOldGoldTotals();

                  return Visibility(
                    visible:
                        oldGoldController.controllers.isNotEmpty &&
                        (oldGoldController
                                .controllers
                                .firstOrNull
                                ?.total_amount
                                .text
                                .isNotEmpty ??
                            false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ItemListHeaderTable(
                        headers: controller.totalHeadersValueOldGold.toList(),
                        columnWidthsCustom: getColumnWidths(
                          columnWidths: controller.totalColumnWidthsOldGold,
                          context: context,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: tertiaryColor,
                      ),
                    ),
                  );
                }),
                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      _buildBottomButton(
                        text: 'Add Old Gold',
                        shortcut: 'Ctrl + F4',
                        onPressed: () async {
                          final result = await Get.dialog(
                            const CreateOrderOldGoldDialog(),
                          );
                          if (result == true) {
                            // Handle the result if needed
                            // The old gold data is stored in the controller
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildBottomButton(
                        text: 'Add Notes',
                        shortcut: 'Ctrl + F5',
                        onPressed: () {
                          Get.dialog(const AddNotesDialog());
                        },
                      ),
                      const Spacer(),
                      _buildBottomButton(
                        text: 'View More',
                        shortcut: 'Ctrl + F10',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  if (createOrderViewModel.hasNotes.value) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: grey1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: "Added Notes :",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.dialog(const AddNotesDialog());
                                },
                                child: const Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: createOrderViewModel.notesController.text,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required String text,
    required String shortcut,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            CustomText(
              text: text,
              fontSize: 14,
              color: primaryColor,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: shortcutGreyColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: CustomText(
                text: shortcut,
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeaders(CreateOrderItemDetailsController controller) {
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
            if (header == 'VA %' || header == 'MC' || header == 'Stone')
              Tooltip(
                message: getTooltipMessage(header),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: toolTipBgColor,
                ),
                triggerMode: TooltipTriggerMode.tap,
                child: const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  List<TableRow> _buildRows(CreateOrderItemDetailsController controller) {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(
    int index,
    CreateOrderItemDetailsController controller,
  ) {
    List<Widget> cells = [
      // Sn
      _buildCell(
        text: (index + 1).toString(),
        editable: false,
        controller: controller,
      ),
      // I
      //tem Description
      _buildCell(
        textController: controller.controllers[index].item_description,
        header: controller.headers[1],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[0],
      ),
      // _buildDesignDropdown(
      //   index: index,
      //   controller: controller,
      //   focusNode: controller.controllers[index].tableFocusNodes[0],
      // ),
      // Size
      _buildCell(
        textController: controller.controllers[index].size,
        header: controller.headers[2],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[1],
      ),
      // Purity dropdown
      _buildPurityDropdown(
        index: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[2],
      ),
      // N.Wt. (gm)
      _buildCell(
        textController: controller.controllers[index].nwt,
        header: controller.headers[4],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[3],
      ),
      // VA %
      _buildCell(
        textController: controller.controllers[index].va,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),
      // MC
      _buildCell(
        textController: controller.controllers[index].mc,
        header: controller.headers[6],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[5],
      ),
      // Stone
      _buildCell(
        textController: controller.controllers[index].stone,
        header: controller.headers[7],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[6],
      ),
      // GST %
      _buildCell(
        textController: controller.controllers[index].gst,
        header: controller.headers[8],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[7],
      ),
      // Total Amount (₹)
      _buildCell(
        textController: controller.controllers[index].amount,
        header: controller.headers[9],
        rowIndex: index,
        controller: controller,
        focusNode: controller.controllers[index].tableFocusNodes[8],
      ),
      // Empty cell for actions
      const SizedBox(width: 30),
    ];

    return TableRow(children: cells);
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    required CreateOrderItemDetailsController controller,
    FocusNode? focusNode,
  }) {
    // Remove the logic that makes Total Amount field read-only
    // Now it will always be editable

    return Container(
      child:
          editable
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: GestureDetector(
                  onDoubleTap:
                      (header == "VA %" || header == "MC")
                          ? () {
                            // Implement double-click functionality for VA% and MC
                          }
                          : null,
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
                            header == 'Stone') {
                          controller.showStoneDialog(rowIndex);
                          return KeyEventResult.handled;
                        }
                        return KeyEventResult.ignored;
                      },
                      child: TextFormField(
                        controller: textController,
                        focusNode: focusNode,
                        keyboardType: _getKeyboardType(header),
                        inputFormatters: _getInputFormatters(header),
                        onTap: () {
                          log("Setting current values");
                          controller.currentRowIndex.value = rowIndex;

                          // Update column index mapping
                          if (header == controller.headers[1]) {
                            controller.currentColIndex.value = 0;
                          } else if (header == controller.headers[2]) {
                            controller.currentColIndex.value = 1;
                          } else if (header == controller.headers[3]) {
                            controller.currentColIndex.value = 2;
                          } else if (header == controller.headers[4]) {
                            controller.currentColIndex.value = 3;
                          } else if (header == controller.headers[5]) {
                            controller.currentColIndex.value = 4;
                          } else if (header == controller.headers[6]) {
                            controller.currentColIndex.value = 5;
                          } else if (header == controller.headers[7]) {
                            controller.currentColIndex.value = 6;
                          } else if (header == controller.headers[8]) {
                            controller.currentColIndex.value = 7;
                          } else if (header == controller.headers[9]) {
                            controller.currentColIndex.value = 8;
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (header == 'Size' ||
                                header == 'VA %' ||
                                header == 'MC' ||
                                header == 'Stone') {
                              return null;
                            } else if (header != null) {
                              return 'Please enter $header';
                            }
                          }

                          if (header == 'N.Wt. (gm)' ||
                              header == 'VA %' ||
                              header == 'MC' ||
                              header == 'Stone' ||
                              header == 'Total Amount (₹)') {
                            if (double.tryParse(value ?? '') == null) {
                              return 'Please enter a valid number';
                            }
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // Check if this is the Total Amount field
                          if (header == 'Total Amount (₹)') {
                            // Get the rate mode
                            final CreateOrderViewModel createOrderViewModel =
                                Get.find<CreateOrderViewModel>();
                            bool isRateFix =
                                createOrderViewModel.RateFixMode.value;

                            if (isRateFix) {
                              log(
                                "User manually changed total amount in Rate Fix mode",
                              );
                              // Set the flag to prevent recalculation
                              controller.isManuallyEditingAmount.value = true;
                              controller.manuallyEditingRowIndex.value =
                                  rowIndex;
                            }
                          }
                          controller.updateTotals();
                        },
                        onEditingComplete: () {
                          // Reset the flag when editing is complete
                          if (header == 'Total Amount (₹)') {
                            controller.isManuallyEditingAmount.value = false;
                            controller.manuallyEditingRowIndex.value = -1;
                          }
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

  // Widget _buildDesignDropdown({
  //   required int index,
  //   required CreateOrderItemDetailsController controller,
  //   required FocusNode focusNode,
  // }) {
  //   return Obx(() {
  //     final designValues =
  //         controller.getDesignResponse.value.data?.values ?? [];

  //     return GenericAutocompleteDropdown<GetDesignDropdownValue>(
  //       controller: controller.controllers[index].item_description,
  //       focusNode: focusNode,
  //       items: designValues,
  //       getDisplayValue: (item) => '${item.code} - ${item.name}',
  //       onSelected: (selectedValue) {
  //         controller.controllers[index].item_description.text =
  //             '${selectedValue.code} - ${selectedValue.name}';
  //         // Optionally store the design ID somewhere for later use
  //         // controller.controllers[index].designId = selectedValue.id;

  //         // Move to next field after selection
  //         controller.controllers[index].tableFocusNodes[1].requestFocus();
  //       },
  //       onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
  //       enabled: controller.getDesignResponse.value.status == Status.COMPLETED,
  //       isLastRow: controller.controllers.length == index + 1,
  //     );
  //   });
  // }

  Widget _buildPurityDropdown({
    required int index,
    required CreateOrderItemDetailsController controller,
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
          // Move to next field after selection
          controller.controllers[index].tableFocusNodes[3].requestFocus();
        },
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
        enabled: controller.getPurityResponse.value.status == Status.COMPLETED,
        isLastRow: controller.controllers.length == index + 1,
      );
    });
  }

  TextInputType? _getKeyboardType(String? header) {
    if (header == 'Item Description') {
      return TextInputType.text;
    }
    return TextInputType.number;
  }
}

String getTooltipMessage(String header) {
  if (header == "Stone") {
    return "Alt + D to add Stone details";
  } else if (header == "VA %") {
    return "Value Addition Percentage";
  } else if (header == "MC") {
    return "Making Charges";
  } else {
    return "";
  }
}

List<TextInputFormatter> _getInputFormatters(String? header) {
  // For weight fields (3 decimal places)
  if (header == 'N.Wt. (gm)') {
    return [
      WeightInputFormatter(), // Max 3 decimal places
    ];
  }
  // For amount fields (2 decimal places)
  else if (header == 'Size' ||
      header == 'VA %' ||
      header == 'MC' ||
      header == 'Stone' ||
      header == 'Total Amount (₹)') {
    return [
      AmountInputFormatter(), // Max 2 decimal places
    ];
  }
  // For text fields
  else if (header == 'Item Description') {
    return [];
  } else {
    return [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))];
  }
}
