// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_add_more_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_table_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/text_with_shortcut_button_widget.dart';

class HoldItemsTableWidget extends StatefulWidget {
  const HoldItemsTableWidget({super.key});

  @override
  State<HoldItemsTableWidget> createState() => _HoldItemsTableWidgetState();
}

class _HoldItemsTableWidgetState extends State<HoldItemsTableWidget> {
  final HoldItemDetailsController controller = Get.find();
  // final InventoryViewmodel inventoryViewmodel = Get.find<InventoryViewmodel>();

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
  void initState() {
    super.initState();
    controller.initializeValues();
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths,
                            itemCount: controller.controllers.length,
                            controller: ScrollController(),
                            buildRow: (context, index, totalWidth) {
                              return _buildRowItem(index, context, totalWidth);
                            },
                            addBottomSpace: false,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Obx(
                        () => LineWiseCustomHeaderTable(
                          headers: controller.totalHeadersValue.toList(),
                          columnWidths: controller.totalColumnWidths,
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
                            text: '+Add Others',
                            controlKey: 'Ctrl',
                            functionKey: 'F10',
                            onPressed: () async {
                              print('Button pressed!');
                              // Add your desired action here
                              await Get.dialog(AddMoreItemsDialog());
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

  // Add this new method to build each row
  Widget _buildRowItem(int index, BuildContext context, double totalWidth) {
    // Create cell data
    List<String> cellTexts = [
      '', // For checkbox cell
      (index + 1).toString(),
      controller.controllers[index].code,
      controller.controllers[index].item_description,
      controller.controllers[index].nwt,
      controller.controllers[index].totalAmount,
      '', // For empty cell at end
    ];

    // Calculate the width for each cell
    List<double> cellWidths = controller.columnWidths;

    // Build the row with Material+InkWell for the entire row
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          toggleCheckBox(index);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: List.generate(
              cellTexts.length,
              (cellIndex) => SizedBox(
                width: totalWidth * (cellWidths[cellIndex] / 4),
                child:
                    cellIndex == 0
                        ? CustomCheckBoxWidget(
                          onChanged: (value) {
                            controller.controllers[index].isSelected =
                                value ?? false;
                            controller
                                .controllers[index]
                                .createSalesItemDetailsTableData
                                .isHandOver = value ?? false;
                            setState(() {});
                          },
                          value: controller.controllers[index].isSelected,
                        )
                        : CustomText(
                          text: cellTexts[cellIndex],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toggleCheckBox(int index) {
    controller.controllers[index].isSelected =
        !controller.controllers[index].isSelected;
    controller.controllers[index].createSalesItemDetailsTableData.isHandOver =
        controller.controllers[index].isSelected;
    setState(() {});
  }
}
