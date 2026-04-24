// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/advance_booking/sales_advance_booking_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/jewellery_plan/sales_jewellery_plan_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/old_gold/sales_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/orders/sales_add_orders_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/quick_estimate/sales_quick_estimate_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/quick_old_gold/sales_quick_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/sales_sales_person_selection_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/old_gold/sales_old_gold_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/text_with_shortcut_button_widget.dart';

class CreateSalesTableWidget extends StatefulWidget {
  const CreateSalesTableWidget({super.key});

  @override
  State<CreateSalesTableWidget> createState() => _CreateSalesTableWidgetState();
}

class _CreateSalesTableWidgetState extends State<CreateSalesTableWidget> {
  final CreateSalesItemDetailsController controller =
      Get.find<CreateSalesItemDetailsController>();
  final CreateSalesViewModel createSalesViewModel =
      Get.find<CreateSalesViewModel>();
  final SalesOldGoldController oldGoldController =
      Get.find<SalesOldGoldController>();
  final RateCaratInputController rateCaratInputController =
      Get.find<RateCaratInputController>();
  // final InventoryViewmodel inventoryViewmodel = Get.find<InventoryViewmodel>();

  final SalesPaymentDetailsController salesPaymentDetailsController =
      Get.find<SalesPaymentDetailsController>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          controller.validateAndAddRow();
          return KeyEventResult.handled;
        } else {
          bool isCodeOrTag =
              controller.currentColIndex.value == 0 ||
              controller.currentColIndex.value == 1;

          // Check if we're in MC Total field (index 7) and in correction mode
          bool isMCTotalInCorrectionMode =
              controller.currentColIndex.value == 7 &&
              !createSalesViewModel.isFastMode.value;

          if (!isCodeOrTag) {
            if (isMCTotalInCorrectionMode) {
              // In correction mode at MC Total field, move to next row
              if (controller.currentRowIndex.value ==
                  controller.controllers.length - 1) {
                // We're at the last row, so add a new one
                controller.validateAndAddRow();
                // After adding, the new row is at controllers.length - 1
                controller.currentRowIndex.value =
                    controller.controllers.length - 1;
              } else {
                // Not at last row, just move to next row
                controller.currentRowIndex.value++;
              }

              // Now set column to 0 and request focus
              controller.currentColIndex.value = 0;
              controller
                  .controllers[controller.currentRowIndex.value]
                  .tableFocusNodes[0]
                  .requestFocus();
              return KeyEventResult.handled;
            } else {
              // Default behavior - move to next field
              controller.moveNextFocus();
              return KeyEventResult.handled;
            }
          }
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
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        controller.currentColIndex.value = 0;
        controller.controllers[rowIndex].tableFocusNodes[0].requestFocus();
        controller.resetRow(rowIndex);

        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyE &&
          HardwareKeyboard.instance.isControlPressed) {
        var response = controller.controllers[rowIndex];
        CreateSalesSalesPersonDialog.show(
          context: Get.context!,
          rowIndex: rowIndex,
          title: 'Select Sales Person for ${response.code.text}',
        );
      }
    }
    return KeyEventResult.ignored;
  };

  @override
  void initState() {
    super.initState();
    controller.clearControllers();
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
                            // onTap: () =>
                            //     controller.fetchTaggingLineItemCodeTag(0),
                            buttonName: "+ Add",
                            shortcut: "Shift+Enter",
                            color: primaryColor,
                            shortcutButtonBackgroundColor: shortcutGreyColor,
                            canRequestFocus: false,
                          ),
                          ButtonShortcutWidget(
                            onTap: controller.removeLastRow,
                            buttonName: "Remove",
                            shortcut: "Shift+Esc",
                            color: redTextColor,
                            shortcutButtonBackgroundColor: shortcutRedColor,
                            canRequestFocus: false,
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
                            columnWidths: controller.columnWidths,
                            context: context,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          backgroundColor: totalGreenColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() {
                      // Get the totals directly from the old gold controller to ensure consistency
                      final oldGoldTotals = oldGoldController.totalHeadersValue;

                      controller.totalHeadersValueOldGold.value = [
                        "Old Gold Total",
                        // Get pieces total from index 1 of old gold controller's totals
                        oldGoldTotals.length > 1 ? oldGoldTotals[1] : "0",
                        // Get gross weight total from index 2 of old gold controller's totals
                        oldGoldTotals.length > 2 ? oldGoldTotals[2] : "0",
                        "",
                        // Get the final total amount from index 8 of old gold controller's totals
                        oldGoldTotals.length > 8 ? oldGoldTotals[8] : "0",
                        "",
                      ];

                      log(
                        "Old Gold Totals from controller: ${oldGoldController.totalHeadersValue.toString()}",
                      );

                      return Visibility(
                        visible:
                            oldGoldController.controllers.toList().isNotEmpty &&
                            ((oldGoldController
                                    .controllers
                                    .firstOrNull
                                    ?.total_amount
                                    .text
                                    .isNotEmpty ??
                                false)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ItemListHeaderTable(
                            headers:
                                controller.totalHeadersValueOldGold.toList(),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              TextWithShortcutButton(
                                text: 'Add/Edit Old Gold',
                                controlKey: 'Ctrl',
                                functionKey: 'F4',
                                onPressed: () async {
                                  print('Button pressed!');
                                  await PermissionGuardUtil.withActionPermissionAsync(
                                    1101,
                                    () async {
                                      final result = await Get.dialog(
                                        const SalesOldGoldDialog(),
                                      );

                                      // Add focus restoration logic similar to shortcut handler
                                      if (result == true) {
                                        // Request focus to the first item code field
                                        if (controller.controllers.isNotEmpty) {
                                          controller.currentRowIndex.value = 0;
                                          controller.currentColIndex.value = 0;
                                          controller
                                              .controllers
                                              .first
                                              .tableFocusNodes[0]
                                              .requestFocus();
                                        }
                                      }
                                    },
                                  );

                                  setState(() {});
                                  // Add your desired action here
                                },
                              ),
                              const SizedBox(width: 16),
                              TextWithShortcutButton(
                                text: 'Add/Edit Estimate',
                                controlKey: 'Ctrl',
                                functionKey: 'F5',
                                onPressed: () {
                                  print('Button pressed!');
                                  Get.dialog(const SalesQuickEstimateDialog());
                                  // Add your desired action here
                                },
                              ),
                              const SizedBox(width: 16),
                              TextWithShortcutButton(
                                text: 'Others',
                                controlKey: 'Ctrl',
                                functionKey: 'F6',
                                onTapDown: (details) {
                                  _showPopupMenu(
                                    context,
                                    details.globalPosition,
                                  );
                                },
                              ),
                            ],
                          ),
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

  void _showPopupMenu(BuildContext context, Offset offset) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(offset, offset.translate(0, 0)),
      Offset.zero & overlay.size,
    );

    final String? selectedValue = await showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'advance_booking',
          child: _buildMenuItem('Add Advance Booking', 'F9'),
          onTap: () {
            print('Advance Booking selected');
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const SalesAdvanceBookingDialog());
            }
          },
        ),
        PopupMenuItem<String>(
          value: 'jewellery_plan',
          child: _buildMenuItem('Add Jewellery Plan', 'F10'),
          onTap: () {
            print('Advance Booking selected');
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const SalesJewelleryPlanDialog());
            }
          },
        ),
        PopupMenuItem<String>(
          value: 'old_gold_estimate',
          child: _buildMenuItem('Add Old Gold Estimate', 'F8'),
          onTap: () {
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const SalesQuickOldGoldDialog());
            }
          },
        ),
        PopupMenuItem<String>(
          value: 'digital_gold',
          child: _buildMenuItem('Add Digital Gold', 'F7'),
        ),
        PopupMenuItem<String>(
          value: 'orders',
          child: _buildMenuItem('Add orders', 'F11'),
          onTap: () {
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const SalesAddOrdersDialog());
            }
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
    );

    if (selectedValue != null) {
      print('Selected action: $selectedValue');
      // Handle the selected action here
    }
  }

  Widget _buildMenuItem(String text, String shortcut) {
    return Text(
      '$text ($shortcut)',
      style: const TextStyle(
        color: Color(0xFF28328B),
        fontSize: 16,
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
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

  TableRow _buildTableHeaders(CreateSalesItemDetailsController controller) {
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

  List<TableRow> _buildRows(CreateSalesItemDetailsController controller) {
    log("Controller length ${controller.controllers.length}");

    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  TableRow _buildTableRow(
    int index,
    CreateSalesItemDetailsController controller,
  ) {
    bool isSold = controller.controllers[index].status?.toLowerCase() == 'sold';
    bool isEditable = !createSalesViewModel.isFastMode.value;

    final RBACController rbacController = Get.find<RBACController>();
    bool hasCostDiscounEditPermission = rbacController.hasAction(1105);
    List<Widget> cells = [
      _buildCell(
        text: (index + 1).toString(),
        editable: false,
        controller: controller,
      ),

      Stack(
        children: [
          _buildCell(
            textController: controller.controllers[index].code,
            header: controller.headers[1],
            rowIndex: index,
            controller: controller,
            focusNode:
                controller
                    .controllers[index]
                    .tableFocusNodes[0], // First focus node
          ),
          if (isSold)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'SOLD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),

      _buildCell(
        textController: controller.controllers[index].tagNo,
        header: controller.headers[2],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[1], // Second focus node
      ),

      // Description
      _buildCell(
        textController: controller.controllers[index].item_description,
        header: controller.headers[3],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[2], // Third focus node
        readOnly: !isEditable,
      ),

      // Pcs
      _buildCell(
        textController: controller.controllers[index].pcs,
        header: controller.headers[4],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[3], // Fourth focus node
        readOnly: !isEditable,
      ),

      // G.Wt.
      _buildCell(
        textController: controller.controllers[index].gwt,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[4], // Fifth focus node
        readOnly: !isEditable,
      ),

      // N.Wt.
      _buildCell(
        textController: controller.controllers[index].nwt,
        header: controller.headers[6],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[5], // Sixth focus node
        readOnly: !isEditable,
      ),

      // VA
      _buildCell(
        textController: controller.controllers[index].va,
        header: controller.headers[7],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[6], // Seventh focus node
        readOnly: !isEditable,
      ),

      // MC
      Obx(
        () => _buildCell(
          textController:
              createSalesViewModel.isFastMode.value
                  ? TextEditingController(text: getMcTotalValue(index: index))
                  : controller.controllers[index].mc,
          header: controller.headers[8],
          rowIndex: index,
          controller: controller,
          focusNode:
              controller
                  .controllers[index]
                  .tableFocusNodes[7], // Eighth focus node
          readOnly: createSalesViewModel.isFastMode.value,
        ),
      ),
      // Stone Cost
      _buildCell(
        textController: controller.controllers[index].stone,
        header: controller.headers[9],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[8], // Ninth focus node
        // readOnly: !isEditable,
      ),

      // Hall Mark
      _buildCell(
        textController: controller.controllers[index].hallMark,
        header: controller.headers[10],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[9], // Tenth focus node
        // readOnly: !isEditable,
      ),

      // Rate
      // _buildCell(
      //   textController: controller.controllers[index].rate,
      //   header: controller.headers[11],
      //   rowIndex: index,
      //   controller: controller,
      //   focusNode: controller
      //       .controllers[index].tableFocusNodes[10], // Eleventh focus node
      //   readOnly: !isEditable,
      // ),

      // Cost Discount
      _buildCell(
        textController: controller.controllers[index].costDiscount,
        header: controller.headers[11],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[10], // Twelfth focus node
        // readOnly: !isEditable,
        readOnly: !hasCostDiscounEditPermission,
      ),

      // Sales Amount
      _buildCell(
        textController: TextEditingController(
          text: controller.controllers[index].salesAmount,
        ),
        header: controller.headers[12],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[11], // Thirteenth focus node
        // readOnly: !isEditable,
      ),

      // Total
      _buildCell(
        textController: TextEditingController(
          text: controller.controllers[index].total,
        ),
        header: controller.headers[13],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[12], // Fourteenth focus node
        // readOnly: !isEditable,
      ),
    ];

    // cells.add(_buildMoreOptionsCell(index, controller));
    cells.add(const SizedBox());
    return TableRow(children: cells);
  }

  String getMcTotalValue({required int index}) {
    final itemData = controller.controllers[index];

    final mcValue = double.tryParse(itemData.mc.text) ?? 0;
    final makingChargesType = itemData.makingChargesType?.toLowerCase();

    double mcTotalValue = 0;
    if (makingChargesType == "gwt") {
      final gwt = double.tryParse(itemData.gwt.text) ?? 0;
      mcTotalValue = mcValue * gwt;
    } else if (makingChargesType == "nwt") {
      final nwt = double.tryParse(itemData.nwt.text) ?? 0;
      mcTotalValue = mcValue * nwt;
    } else {
      mcTotalValue = mcValue;
    }

    return mcTotalValue.toStringAsFixed(2);
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    required CreateSalesItemDetailsController controller,
    FocusNode? focusNode,
    bool readOnly = false,
    String? tooltipMessage, // Optional tooltip message
  }) {
    // Helper function to get the actual cell value for tooltip
    String getTooltipMessage() {
      if (tooltipMessage != null) {
        return tooltipMessage;
      }

      // Return the actual value of the cell
      if (editable && textController != null) {
        // For editable cells, get the value from textController
        String value = textController.text;
        return value.isEmpty ? "Empty" : value;
      } else if (!editable && text != null) {
        // For non-editable cells, get the text value
        return text.isEmpty ? "Empty" : text;
      }

      return "No value";
    }

    Widget cellContent = Container(
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
                    child: Obx(
                      () => TextFormField(
                        controller: textController,
                        readOnly: readOnly,
                        focusNode: focusNode,
                        keyboardType: TextInputType.number,
                        enabled: true,
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

                          if (!createSalesViewModel.isFastMode.value &&
                              (header == 'G.Wt. (gm)' ||
                                  header == 'N.Wt. (gm)' ||
                                  header == 'VA%' ||
                                  header == 'MC Total (₹)')) {
                            textController?.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: textController.text.length,
                            );
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
                            if (header == 'Tag No' ||
                                header == 'Pcs' ||
                                header == 'G.Wt. (gm)' ||
                                header == 'Less' ||
                                header == 'WST/Tch' ||
                                header == 'MC (₹)' ||
                                header == 'MC Total (₹)' ||
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
                              header == 'MC Total (₹)' ||
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

                            if (header == "Item Code") {
                              String value =
                                  controller.controllers[rowIndex].code.text;
                              int? barcodeNum = int.tryParse(value);
                              log("barcode: $barcodeNum");

                              if (barcodeNum != null) {
                                controller.debouncer.run(() {
                                  controller.fetchTaggingLineItemByBarcode(
                                    rowIndex,
                                    value,
                                  );
                                });
                                return;
                              }
                            }

                            return;
                          }

                          if (header == "VA" &&
                              !controller.validateVAMCChanges(
                                index: rowIndex,
                                field: 'va',
                                newValue: value,
                              )) {
                            print("Value is correct");
                            final element = controller.controllers[rowIndex];

                            // Reset to originalVa value with appropriate formatting based on type
                            String? wastageType = element.wastageType;
                            if (wastageType?.toLowerCase() == "%") {
                              textController?.text = element.originalVa
                                  .toStringAsFixed(3);
                            } else {
                              textController?.text = element.originalVa
                                  .toStringAsFixed(3);
                            }
                          }

                          // Handle MC changes
                          if ((header == "MC (₹)" ||
                                  header == "MC Total (₹)") &&
                              !controller.validateVAMCChanges(
                                index: rowIndex,
                                field: 'mc',
                                newValue: value,
                              )) {
                            final element = controller.controllers[rowIndex];

                            // Instead of calculating monetary value, we'll set the actual MC value
                            textController?.text = element.originalMc
                                .toStringAsFixed(2);
                          }
                          if (header == controller.headers[5] ||
                              header == controller.headers[6]) {
                            controller
                                .calculateSalesAndTotalAmountforFetchedItems(
                                  index: rowIndex,
                                );
                          } else {
                            controller.addSalesAndTotalAmount(index: rowIndex);
                          }
                          controller.updateTotals();

                          setState(() {});
                        },
                        onEditingComplete: () {
                          print("on Editing called");

                          // Handle Item Code (barcode scanning)
                          if (header == "Item Code") {
                            String value =
                                controller.controllers[rowIndex].code.text;
                            int? barcodeNum = int.tryParse(value);
                            log("barcode: $barcodeNum");

                            if (barcodeNum != null && value.length >= 5) {
                              controller.fetchTaggingLineItemByBarcode(
                                rowIndex,
                                value,
                              );
                              return;
                            }
                          }

                          // Handle Tag No
                          if (header == "Tag No") {
                            if (controller
                                .controllers[rowIndex]
                                .code
                                .text
                                .isNotEmpty) {
                              controller.fetchTaggingLineItemCodeTag(rowIndex);
                            }
                            return;
                          }

                          // Handle MC Total field in correction mode
                          if (header == "MC Total (₹)" &&
                              !createSalesViewModel.isFastMode.value) {
                            // In correction mode, when Enter is pressed in MC Total field,
                            // move to next row (creating new row if needed)
                            controller.moveNextFocus();
                            if (controller.currentRowIndex.value ==
                                controller.controllers.length - 1) {
                              controller.validateAndAddRow();
                            }
                            return;
                          }

                          // Default behavior - just move to next field
                          controller.moveNextFocus();
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

    // Wrap with Tooltip
    return Tooltip(
      message: getTooltipMessage(),
      decoration: BoxDecoration(
        color: toolTipBgColor, // Use your app's tooltip background color
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
      waitDuration: const Duration(
        milliseconds: 500,
      ), // Delay before showing tooltip
      showDuration: const Duration(
        seconds: 3,
      ), // How long tooltip stays visible
      triggerMode: TooltipTriggerMode.longPress, // Show on long press
      child: cellContent,
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
        header == 'MC Total (₹)' ||
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

  // Widget _buildMoreOptionsCell(
  //     int rowIndex, CreateSalesItemDetailsController controller) {
  //   return Theme(
  //     data: ThemeData(
  //         focusColor: greyTextColor,
  //         tooltipTheme: const TooltipThemeData(
  //           decoration: BoxDecoration(
  //             color: Colors.transparent,
  //           ),
  //         )),
  //     child: CustomPopupMenuButtonWidget<String>(
  //       icon: const Icon(
  //         Icons.more_vert,
  //       ),
  //       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
  //         ...controller.popUpValues.map((element) {
  //           return PopupMenuItem<String>(
  //             value: element,
  //             // padding: EdgeInsets.all(0),

  //             height: 0,
  //             child: SizedBox(
  //               width: 88,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(
  //                     height: 8,
  //                   ),
  //                   Text(
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     element,
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 8,
  //                   ),
  //                   if (element != "Delete")
  //                     CustomDashedLineWidget(
  //                       width: Get.width,
  //                     )
  //                 ],
  //               ),
  //             ),
  //           );
  //         })
  //       ],
  //       onSelected: (String value) {
  //         // Handle the selected option
  //         switch (value) {
  //           case 'View':
  //             controller.showItemDetails(index: rowIndex);
  //             break;
  //           case 'Edit':
  //             controller.showItemDetails(index: rowIndex);
  //             break;

  //           case 'Delete':
  //             // Handle delete action
  //             break;
  //         }
  //       },
  //     ),
  //   );
  // }
}
