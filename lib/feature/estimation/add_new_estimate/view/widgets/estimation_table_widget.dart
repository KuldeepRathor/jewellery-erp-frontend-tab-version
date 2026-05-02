// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/barcode_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/item_details_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/sales_person_selection_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/old_gold/old_gold_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class EstimationTableWidget extends StatefulWidget {
  const EstimationTableWidget({super.key});

  @override
  State<EstimationTableWidget> createState() => _EstimationTableWidgetState();
}

class _EstimationTableWidgetState extends State<EstimationTableWidget> {
  final EstimationItemDetailsController controller =
      Get.find<EstimationItemDetailsController>();

  final EstimationViewModel estimationViewModel =
      Get.find<EstimationViewModel>();

  final OldGoldController oldGoldController = Get.find<OldGoldController>();
  String? result;
  // final InventoryViewmodel inventoryViewmodel = Get.find<InventoryViewmodel>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          // Call validateAndAddRow when Shift+Enter is pressed
          controller.validateAndAddRow();
          return KeyEventResult.handled;
        } else {
          bool isCodeOrTag =
              controller.currentColIndex.value == 0 ||
              controller.currentColIndex.value == 1;
          if (!isCodeOrTag) {
            controller.moveNextFocus();
            return KeyEventResult.handled;
          }
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
      }

      if (event.logicalKey == LogicalKeyboardKey.keyE &&
          HardwareKeyboard.instance.isControlPressed) {
        var response = controller.controllers[rowIndex];
        SalesPersonDialog.show(
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
                          TextButton(
                            onPressed: () async {
                              String?
                              res = await SimpleBarcodeScanner.scanBarcode(
                                context,
                                barcodeAppBar: const BarcodeAppBar(
                                  appBarTitle: 'Scan Barcode',
                                  centerTitle: false,
                                  enableBackButton: true,
                                  backButtonIcon: Icon(Icons.arrow_back_ios),
                                ),
                                isShowFlashIcon: true,
                                delayMillis: 2000,
                                cameraFace:
                                    CameraFace.back,
                              );

                              if (res != null && res != "-1") {
                                final controller =
                                    Get.find<EstimationItemDetailsController>();

                                int rowIndex = controller.currentRowIndex.value;

                                controller.fetchTaggingLineItemByBarcode(
                                  rowIndex,
                                  res,
                                );
                              }
                            },
                            child: const Text(
                              "Scan",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            height: 14,
                            child: VerticalDivider(color: primaryColor),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const BarcodeDialogWidget(),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Enter Barcode",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
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
                    ),
                    SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Padding(
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

  // void _showPopupMenu(BuildContext context, Offset offset) async {
  //   final RenderBox overlay =
  //       Overlay.of(context).context.findRenderObject() as RenderBox;
  //   final RelativeRect position = RelativeRect.fromRect(
  //     Rect.fromPoints(offset, offset.translate(0, 0)),
  //     Offset.zero & overlay.size,
  //   );

  //   final String? selectedValue = await showMenu<String>(
  //     context: context,
  //     position: position,
  //     items: [
  //       PopupMenuItem<String>(
  //           value: 'advance_booking',
  //           child: _buildMenuItem('Add Advance Booking', 'F9'),
  //           onTap: () {
  //             print('Advance Booking selected');
  //             bool isItemsDataValid = controller.validateRow();
  //             if (isItemsDataValid == false) {
  //               showErrorToast(message: "Invalid Item Data");
  //             } else {
  //               Get.dialog(const AdvanceBookingDialog());
  //             }
  //           }),
  //       PopupMenuItem<String>(
  //           value: 'jewellery_plan',
  //           child: _buildMenuItem('Add Jewellery Plan', 'F10'),
  //           onTap: () {
  //             print('Advance Booking selected');
  //             bool isItemsDataValid = controller.validateRow();
  //             if (isItemsDataValid == false) {
  //               showErrorToast(message: "Invalid Item Data");
  //             } else {
  //               Get.dialog(const JewelleryPlanDialog());
  //             }
  //           }),
  //       PopupMenuItem<String>(
  //         value: 'old_gold_estimate',
  //         child: _buildMenuItem('Add Old Gold Estimate', 'F8'),
  //         onTap: () {
  //           // bool isItemsDataValid = controller.validateRow();
  //           // if (isItemsDataValid == false) {
  //           //   showErrorToast(message: "Invalid Item Data");
  //           // } else {
  //           Get.dialog(const QuickOldGoldDialog());
  //           // }
  //         },
  //       ),
  //       PopupMenuItem<String>(
  //         value: 'digital_gold',
  //         child: _buildMenuItem('Add Digital Gold', 'F7'),
  //         onTap: () {
  //           bool isItemsDataValid = controller.validateRow();
  //           if (isItemsDataValid == false) {
  //             showErrorToast(message: "Invalid Item Data");
  //           } else {
  //             Get.dialog(const EstimationDigitalGoldDialog());
  //           }
  //         },
  //       ),
  //       PopupMenuItem<String>(
  //           value: 'orders',
  //           child: _buildMenuItem('Add orders', 'F11'),
  //           onTap: () {
  //             bool isItemsDataValid = controller.validateRow();
  //             if (isItemsDataValid == false) {
  //               showErrorToast(message: "Invalid Item Data");
  //             } else {
  //               Get.dialog(const AddOrdersDialog());
  //             }
  //           }),
  //       PopupMenuItem<String>(
  //           value: 'payment_details',
  //           child: _buildMenuItem('Add Payment Details', '-'),
  //           onTap: () {
  //             bool isItemsDataValid = controller.validateRow();
  //             if (isItemsDataValid == false) {
  //               showErrorToast(message: "Invalid Item Data");
  //             } else {
  //               Get.dialog(
  //                 const EstimationPaymentDetailsDialog(),
  //               );
  //             }
  //           }),
  //     ],
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     elevation: 8,
  //   );

  //   if (selectedValue != null) {
  //     print('Selected action: $selectedValue');
  //     // Handle the selected action here
  //   }
  // }

  // Widget _buildMenuItem(String text, String shortcut) {
  //   return Text(
  //     '$text ($shortcut)',
  //     style: const TextStyle(
  //       color: Color(0xFF28328B),
  //       fontSize: 16,
  //       fontFamily: 'Satoshi',
  //       fontWeight: FontWeight.w500,
  //       decoration: TextDecoration.underline,
  //     ),
  //   );
  // }

  String getTooltipMessage(String header) {
    if (header == "Stone (₹)") {
      return "Alt + D to add Stone details";
    } else {
      return "Alt + C or Double Click to Change";
    }
  }

  TableRow _buildTableHeaders(EstimationItemDetailsController controller) {
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

  List<TableRow> _buildRows(EstimationItemDetailsController controller) {
    log("Controller length ${controller.controllers.length}");

    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index, controller),
    );
  }

  String getMcTotalValue({required int index}) {
    final itemData = controller.controllers[index];

    final mcValue = double.tryParse(itemData.mc.text) ?? 0;
    final makingChargesType =
        itemData.itemResponse?.designLineItem?.makingChargesType?.toLowerCase();

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

  TableRow _buildTableRow(
    int index,
    EstimationItemDetailsController controller,
  ) {
    // bool isSold =
    //     controller.controllers[index].itemResponse?.status?.toLowerCase() ==
    //         'sold';
    bool isEditable = !estimationViewModel.isFastMode.value;

    List<Widget> cells = [
      _buildCell(
        text: (index + 1).toString(),
        editable: false,
        controller: controller,
      ),

      // Stack(
      //   children: [
      //     _buildCell(
      //       textController: controller.controllers[index].code,
      //       header: controller.headers[1],
      //       rowIndex: index,
      //       controller: controller,
      //       focusNode: controller
      //           .controllers[index].tableFocusNodes[0], // First focus node
      //     ),
      //     if (isSold)
      //       Positioned(
      //         right: 4,
      //         top: 4,
      //         child: Container(
      //           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      //           decoration: BoxDecoration(
      //             color: Colors.red[700],
      //             borderRadius: BorderRadius.circular(4),
      //           ),
      //           child: const Text(
      //             'SOLD',
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 10,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),

      // _buildCell(
      //   textController: controller.controllers[index].tagNo,
      //   header: controller.headers[2],
      //   rowIndex: index,
      //   controller: controller,
      //   focusNode: controller
      //       .controllers[index].tableFocusNodes[1], // Second focus node
      // ),

      // Description
      // _buildCell(
      //   textController: controller.controllers[index].item_description,
      //   header: controller.headers[3],
      //   rowIndex: index,
      //   controller: controller,
      //   focusNode: controller
      //       .controllers[index].tableFocusNodes[2], // Third focus node
      //   readOnly: !isEditable,
      // ),

      // Pcs
      // _buildCell(
      //   textController: controller.controllers[index].pcs,
      //   header: controller.headers[4],
      //   rowIndex: index,
      //   controller: controller,
      //   focusNode: controller
      //       .controllers[index].tableFocusNodes[3], // Fourth focus node
      //   readOnly: !isEditable,
      // ),

      // G.Wt.
      _buildCell(
        textController: controller.controllers[index].gwt,
        header: controller.headers[1],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[0], // Fifth focus node
        readOnly: !isEditable,
      ),

      // N.Wt.
      _buildCell(
        textController: controller.controllers[index].nwt,
        header: controller.headers[2],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[1], // Sixth focus node
        readOnly: !isEditable,
      ),

      // VA
      _buildCell(
        textController: controller.controllers[index].va,
        header: controller.headers[3],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[2], // Seventh focus node
        readOnly: !isEditable,
      ),

      // MC
      _buildCell(
        textController: TextEditingController(
          text: getMcTotalValue(index: index),
        ),
        header: controller.headers[4],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[3], // Eighth focus node
        readOnly: !isEditable,
      ),

      // Stone Cost
      _buildCell(
        textController: controller.controllers[index].stone,
        header: controller.headers[5],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[4], // Ninth focus node
        readOnly: !isEditable,
      ),

      // Hall Mark
      // _buildCell(
      //   textController: controller.controllers[index].hallMark,
      //   header: controller.headers[10],
      //   rowIndex: index,
      //   controller: controller,
      //   focusNode: controller
      //       .controllers[index].tableFocusNodes[9], // Tenth focus node
      //   readOnly: !isEditable,
      // ),

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
      // _buildCell(
      //   textController: controller.controllers[index].costDiscount,
      //   header: controller.headers[11],
      //   rowIndex: index,
      //   controller: controller,
      //   focusNode: controller
      //       .controllers[index].tableFocusNodes[10], // Twelfth focus node
      //   readOnly: !isEditable,
      // ),

      // Sales Amount
      _buildCell(
        textController: TextEditingController(
          text: controller.controllers[index].salesAmount,
        ),
        header: controller.headers[6],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[5], // Thirteenth focus node
        readOnly: !isEditable,
      ),

      // Total
      _buildCell(
        textController: TextEditingController(
          text: controller.controllers[index].total,
        ),
        header: controller.headers[7],
        rowIndex: index,
        controller: controller,
        focusNode:
            controller
                .controllers[index]
                .tableFocusNodes[6], // Fourteenth focus node
        readOnly: !isEditable,
      ),
    ];

    // cells.add(_buildMoreOptionsCell(index, controller));
    cells.add(
      Theme(
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
                PopupMenuItem<String>(
                  height: 0,
                  child: SizedBox(
                    width: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          "View Details",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDashedLineWidget(width: Get.width),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const ItemDetailsDialogWidget(),
                        );
                      },
                    );
                  },
                ),
                PopupMenuItem<String>(
                  height: 0,
                  onTap: () {
                    var response = controller.controllers[index];
                    SalesPersonDialog.show(
                      context: Get.context!,
                      rowIndex: index,
                      title: 'Select Sales Person for ${response.code.text}',
                    );
                  },
                  child: SizedBox(
                    width: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          "Add/Change Employee",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDashedLineWidget(width: Get.width),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  height: 0,
                  onTap: () {
                    controller.removeCurrentRow(index);
                  },
                  child: const SizedBox(
                    width: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "Delete Item",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
        ),
      ),
    );
    return TableRow(children: cells);
  }

  // Validator function
  String? validateCellInput(String? value, String? header) {
    if (value == null || value.isEmpty) {
      final skipValidationFields = [
        'Tag No',
        'Pcs',
        'G.Wt. (gm)',
        'Less',
        'WST/Tch',
        'MC (₹)',
        'MC Total (₹)',
        'Stone (₹)',
      ];
      return skipValidationFields.contains(header)
          ? null
          : 'Please enter $header';
    }

    final numericFields = [
      'Pcs',
      'G.Wt. (gm)',
      'Less',
      'N.Wt. (gm)',
      'WST/Tch',
      'MC (₹)',
      'MC Total (₹)',
      'Stone (₹)',
      'Rate (₹)',
      'Amount (₹)',
    ];

    if (numericFields.contains(header)) {
      final number = double.tryParse(value);
      if (number == null || number < 0.0) {
        return 'Please enter a valid number';
      }
    }
    return null;
  }

  // Handle column index updates
  void updateColumnIndex(
    EstimationItemDetailsController controller,
    String? header,
    int rowIndex,
    FocusNode? focusNode,
  ) {
    controller.currentRowIndex.value = rowIndex;
    if (focusNode != null) {
      controller.currentColIndex.value = controller
          .controllers[rowIndex]
          .tableFocusNodes
          .indexOf(focusNode);
    }
  }

  // Handle value changes
  void handleValueChange(
    String? header,
    String value,
    int rowIndex,
    EstimationItemDetailsController controller,
    TextEditingController? textController,
  ) {
    print(
      "Value is corrent 1 ${controller.validateVAMCChanges(index: rowIndex, field: 'va', newValue: value)}",
    );
    // Handle Item Code and Tag No
    if (header == "Item Code" || header == "Tag No") {
      final capitalizedValue = value.toUpperCase();
      final currentCursorPosition = textController?.selection.baseOffset;
      textController?.value = TextEditingValue(
        text: capitalizedValue,
        selection: TextSelection.collapsed(offset: currentCursorPosition ?? 0),
      );

      if (header == "Item Code") {
        String value = controller.controllers[rowIndex].code.text;
        int? barcodeNum = int.tryParse(value);
        log("barcode: $barcodeNum");

        if (barcodeNum != null) {
          controller.debouncer.run(() {
            controller.fetchTaggingLineItemByBarcode(rowIndex, value);
          });
          return;
        }
      }
      return;
    }

    // Handle VA changes
    if (header == "VA" &&
        !controller.validateVAMCChanges(
          index: rowIndex,
          field: 'va',
          newValue: value,
        )) {
      print("Value is corrent");
      final element = controller.controllers[rowIndex];

      // Reset to originalVa value with appropriate formatting based on type
      String? wastageType = element.itemResponse?.designLineItem?.wastageType;
      if (wastageType?.toLowerCase() == "%") {
        textController?.text = element.originalVa.toStringAsFixed(3);
      } else {
        textController?.text = element.originalVa.toStringAsFixed(3);
      }
    }

    // Handle MC changes
    if ((header == "MC (₹)" || header == "MC Total (₹)") &&
        !controller.validateVAMCChanges(
          index: rowIndex,
          field: 'mc',
          newValue: value,
        )) {
      final element = controller.controllers[rowIndex];
      textController?.text = element.originalMc.toStringAsFixed(2);
    }
    if (header == controller.headers[5] || header == controller.headers[6]) {
      controller.calculateSalesAndTotalAmountFromFetchedItems(index: rowIndex);
    } else {
      controller.addSalesAndTotalAmount(index: rowIndex);
    }
    controller.updateTotals();
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    required EstimationItemDetailsController controller,
    FocusNode? focusNode,
    bool readOnly = false,
  }) {
    if (!editable) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: CustomText(
          text: text!,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
        child: Obx(
          () => TextFormField(
            readOnly: readOnly,
            controller: textController,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            onTap: () {
              // Update column index
              updateColumnIndex(controller, header, rowIndex, focusNode);

              // Get the estimation view model
              final EstimationViewModel estimationViewModel =
                  Get.find<EstimationViewModel>();

              // In correction mode, select all text for weight and value fields
              if (!estimationViewModel.isFastMode.value &&
                  (header == 'G.Wt. (gm)' ||
                      header == 'N.Wt. (gm)' ||
                      header == 'VA' ||
                      header == 'MC Total (₹)')) {
                textController?.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: textController.text.length,
                );
              }
            },
            decoration: TableCellStyle.getInputDecoration(
              isLastRow: controller.controllers.length == rowIndex + 1,
              header: header,
              rowIndex: rowIndex,
              controller: controller,
            ),
            inputFormatters: getInputFormatters(header),
            style: TableCellStyle.getTextStyle(header),
            validator: (value) => validateCellInput(value, header),
            onChanged:
                (value) => handleValueChange(
                  header,
                  value,
                  rowIndex,
                  controller,
                  textController,
                ),
            onEditingComplete: () {
              print("on Editing called");

              // Handle Item Code (barcode scanning)
              if (header == "Item Code") {
                String value = controller.controllers[rowIndex].code.text;
                int? barcodeNum = int.tryParse(value);
                log("barcode: $barcodeNum");

                if (barcodeNum != null && value.length >= 5) {
                  controller.debouncer.run(() {
                    controller.fetchTaggingLineItemByBarcode(rowIndex, value);
                  });
                  return;
                }
              }

              // Handle Tag No
              if (header == "Tag No") {
                if (controller.controllers[rowIndex].code.text.isNotEmpty) {
                  controller.debouncer.run(() {
                    controller.fetchTaggingLineItemCodeTag(rowIndex);
                  });
                }
                return;
              }

              // Handle MC Total field in correction mode
              final EstimationViewModel estimationViewModel =
                  Get.find<EstimationViewModel>();
              if (header == "MC Total (₹)" &&
                  !estimationViewModel.isFastMode.value) {
                // In correction mode, when Enter is pressed in MC Total field,
                // move to next row (creating new row if needed)
                if (controller.currentRowIndex.value ==
                    controller.controllers.length - 1) {
                  controller.validateAndAddRow();
                } else {
                  // Move to next row, first column
                  controller.currentRowIndex.value++;
                  controller.currentColIndex.value = 0;
                  controller
                      .controllers[controller.currentRowIndex.value]
                      .tableFocusNodes[0]
                      .requestFocus();
                }
                return;
              }

              // Default behavior
              if (!controller.isProgrammaticFocus) {
                controller.moveNextFocus();
              }
            },
          ),
        ),
      ),
    );
  }

  /// Get the appropriate input formatters based on the field header
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
  //     int rowIndex, EstimationItemDetailsController controller) {
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
  //           case 'Payment':
  //             // Handle edit action
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

class TableCellStyle {
  static InputDecoration getInputDecoration({
    required bool isLastRow,
    String? header,
    required int rowIndex,
    required EstimationItemDetailsController controller,
  }) {
    return InputDecoration(
      suffix:
          header == 'WST/Tch'
              ? Obx(
                () => CustomText(
                  text: controller.controllers.toList()[rowIndex].wst_unit,
                ),
              )
              : null,
      contentPadding: const EdgeInsets.all(10),
      isDense: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isLastRow ? secondaryColor : Colors.transparent,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: secondaryColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      disabledBorder: InputBorder.none,
    );
  }

  static TextStyle getTextStyle(String? header) {
    final isDescription = header == "Item Description";
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: isDescription ? secondaryColor : Colors.black,
      decoration: isDescription ? TextDecoration.underline : null,
      decorationThickness: 2,
      decorationColor: isDescription ? secondaryColor : Colors.white,
    );
  }
}
