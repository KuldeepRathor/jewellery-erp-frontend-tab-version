// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_receipt_methods_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sales_return_credit_note_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/my_separator.dart';

class SalesPaymentDetailsTableData {
  TextEditingController amount;
  TextEditingController method;
  TextEditingController date;
  TextEditingController pos_bank;
  TextEditingController upi_utr_cn;
  List<FocusNode> tableFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  SalesPaymentDetailsTableData({
    required this.amount,
    required this.method,
    required this.date,
    required this.pos_bank,
    required this.upi_utr_cn,
  });
  Map<String, dynamic> toJsonValue() {
    return {
      'amount': amount.text,
      'method': method.text,
      'date': date.text,
      'pos_bank': pos_bank.text,
      'upi_utr_cn': upi_utr_cn.text,
    };
  }

  void dispose() {
    // Clean up focus nodes when disposing
    for (var node in tableFocusNodes) {
      node.dispose();
    }
  }
}

class SalesPaymentDetailsDialog extends StatefulWidget {
  const SalesPaymentDetailsDialog({super.key});

  @override
  State<SalesPaymentDetailsDialog> createState() =>
      _SalesPaymentDetailsDialogState();
}

class _SalesPaymentDetailsDialogState extends State<SalesPaymentDetailsDialog> {
  final SalesPaymentDetailsController controller =
      Get.find<SalesPaymentDetailsController>();

  late final Debouncer _saveDebouncer;

  final CreateSalesItemDetailsController itemDetailsController =
      Get.find<CreateSalesItemDetailsController>();
  final CreateSalesViewModel purchaseInvoiceViewmodel =
      Get.find<CreateSalesViewModel>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      // Check if current payment method is Cash
      String currentMethod =
          controller.controllers[rowIndex].method.text.toLowerCase();
      bool isCashMethod = currentMethod == "cash";

      if ((controller.currentColIndex.value == 1 ||
              controller.currentColIndex.value == 3) &&
          event.logicalKey == LogicalKeyboardKey.enter) {
        return KeyEventResult.ignored;
      }

      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          // Check if we're on the payment method column (index 1) and method is Cash
          if (controller.currentColIndex.value == 1) {
            String selectedMethod =
                controller.controllers[rowIndex].method.text;
            if (selectedMethod.toLowerCase() == "cash") {
              // For Cash payment method, skip to new row
              controller.validateAndAddRow();
              // Set focus to the first field (amount) of the new row
              controller.currentRowIndex.value =
                  controller.controllers.length - 1;
              controller.currentColIndex.value = 0;
              controller
                  .controllers[controller.currentRowIndex.value]
                  .tableFocusNodes[controller.currentColIndex.value]
                  .requestFocus();
              return KeyEventResult.handled;
            } else {
              // For non-cash methods, continue to next field normally
              controller.moveNextFocus();
              return KeyEventResult.handled;
            }
          }
          // Check if we're on the last column (upi_utr_cn field)
          else if (controller.currentColIndex.value == 4) {
            // We're on the last column, so add a new row and move focus to the first field
            controller.validateAndAddRow();
            // Set focus to the first field of the new row
            controller.currentRowIndex.value =
                controller.controllers.length - 1;
            controller.currentColIndex.value = 0;
            controller
                .controllers[controller.currentRowIndex.value]
                .tableFocusNodes[controller.currentColIndex.value]
                .requestFocus();
            return KeyEventResult.handled;
          } else {
            // Not on the last column, just move to the next field
            controller.moveNextFocus();
            return KeyEventResult.handled;
          }
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab &&
          HardwareKeyboard.instance.isShiftPressed) {
        // When going backward with Shift+Tab
        if (isCashMethod && controller.currentColIndex.value == 2) {
          // If on Date field and method is Cash, skip back to Method field
          controller.currentColIndex.value = 1;
          controller.controllers[rowIndex].tableFocusNodes[1].requestFocus();
          return KeyEventResult.handled;
        }
        controller.movePreviousFocus(node);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        // When going forward with Tab
        if (isCashMethod && controller.currentColIndex.value == 2) {
          // If on Date field and method is Cash, skip to new row
          controller.validateAndAddRow();
          controller.currentRowIndex.value = controller.controllers.length - 1;
          controller.currentColIndex.value = 0;
          controller
              .controllers[controller.currentRowIndex.value]
              .tableFocusNodes[controller.currentColIndex.value]
              .requestFocus();
          return KeyEventResult.handled;
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
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        controller.currentColIndex.value = 0;
        controller.controllers[rowIndex].tableFocusNodes[0].requestFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  };
  final FocusNode roundOffFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _saveDebouncer = Debouncer(milliseconds: 500);

    controller.initializeRow();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.calculateGstvalues();

      Future.delayed(const Duration(milliseconds: 100), () {
        roundOffFocusNode.requestFocus();

        if (controller.roundOffController.text.isNotEmpty) {
          controller.roundOffController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.roundOffController.text.length,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _saveDebouncer.dispose();
    roundOffFocusNode.dispose();
    super.dispose();
  }

  void _debouncedSave({required bool isHeld}) {
    _saveDebouncer.run(() {
      controller.validateAndPostPurchaseInvoice(isHeld: isHeld);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearPaymentDialogDataOnly();
        return true;
      },
      child: Dialog(
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
                // Implement save functionality here
                _debouncedSave(isHeld: false);
                return;
              },
            ),
            SaveSalesWithOGHeld: CallbackAction<SaveSalesWithOGHeld>(
              onInvoke: (intent) async {
                _debouncedSave(isHeld: true);
                return;
              },
            ),
          },
          child: Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              // LogicalKeySet(LogicalKeyboardKey.enter): const AddStoneRowIntent(),
              // LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.escape):
              //     const RemoveLastStoneRowIntent(),
              LogicalKeySet(
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.keyS,
                  ):
                  const SaveStoneDetailsIntent(),
              LogicalKeySet(
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.shift,
                    LogicalKeyboardKey.keyL,
                  ):
                  const SaveSalesWithOGHeld(),
            },
            child: Container(
              // height: Get.height * 0.75,
              width: Get.width * 0.7,
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
            text: 'Payment Details',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () {
              controller.clearPaymentDialogDataOnly();
              Get.back();
            },
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Focus(
            // autofocus: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Focus(
                canRequestFocus: false,
                // onKeyEvent: onNormalKeyEvent,
                child: _buildPaymentDetails(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(width: 2, height: Get.height, color: secondaryColor),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
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
                        text: 'Payment Method Details',
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
                    child: Obx(() {
                      try {
                        // Ensure controllers are initialized
                        if (!controller.isControllerInitialized) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.controllers.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('No payment methods added'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => controller.initializeRow(),
                                  child: const Text('Add Payment Method'),
                                ),
                              ],
                            ),
                          );
                        }

                        return CustomTableWidget(
                          headers: [_buildTableHeaders()],
                          columnWidths: controller.paymentColumnWidths,
                          rows: _buildRows(),
                          isLoadingMore: false,
                          controller: controller.scrollController,
                          addSizedBox: false,
                        );
                      } catch (e, stackTrace) {
                        log("Error in Obx widget: $e");
                        log("Stack trace: $stackTrace");

                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${e.toString()}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  controller.controllers.clear();
                                  controller.initializeRow();
                                },
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          3],
    );
    //      +
    // controller.schemeDisct +
    // controller.rateDisct +
    // controller.discount +
    // (double.tryParse(controller.jewellerDiscount.text) ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentRow('Sub Total', '₹ ${subTotal.toStringAsFixed(2)}'),
        // _buildPaymentRow('Nett', '₹ 24,00,000.00'),
        _buildPaymentRow(
          'Scheme Disct',
          '₹ ${controller.schemeDisct.toStringAsFixed(2)}',
        ),
        _buildPaymentRow(
          'Rate Disct',
          '₹ ${controller.rateDisct.toStringAsFixed(2)}',
        ),
        Obx(
          () => _buildPaymentRow(
            'Discount',
            '₹ ${controller.discount.value.toStringAsFixed(2)}',
          ),
        ),
        Obx(
          () => _buildPaymentRow(
            'Additional Less',
            '₹ ${(controller.additional_less.value / 1.03).toStringAsFixed(2)}',
          ),
        ),
        Obx(
          () => _buildPaymentRow(
            'Sales Amount',
            '₹ ${controller.salesAmount.toStringAsFixed(2)}',
          ),
        ),

        const MySeparator(height: 3, color: grey1),
        Obx(() => _buildPaymentRow('CGST', '₹ ${controller.CGStValue}')),
        Obx(() => _buildPaymentRow('SGST', '₹ ${controller.SGSTValue}')),
        Obx(() => _buildPaymentRow('IGST', '₹ ${controller.IGStValue}')),

        Obx(
          () => _buildPaymentRow(
            'Nett',
            '₹ ${controller.gstNet.toStringAsFixed(2)}',
          ),
        ),
        const SizedBox(height: 16),
        const MySeparator(height: 3, color: grey1),
        _buildTextfieldPaymentRow(
          label: 'TCS',
          textController: controller.tcsController,
          readOnly: true,
        ),
        _buildTextfieldPaymentRow(
          label: 'TDS',
          textController: controller.tdsController,
          readOnly: true,
        ),
        Obx(
          () => _buildPaymentRow(
            'Nett',
            '₹ ${controller.taxDeductionNet.toStringAsFixed(2)}',
          ),
        ),
        const SizedBox(height: 16),
        const MySeparator(height: 3, color: grey1),
        _buildTextfieldPaymentRow(
          label: 'Purchase (OG)',
          textController: controller.purchaseAmountController,
          onChanged: (p0) {
            controller.reCalculateAfterRoundOff();
          },
          readOnly: true,
        ),
        _buildTextfieldPaymentRow(
          label: 'Advance (ADJ)',
          textController: controller.advanceAmountController,
          onChanged: (p0) {
            controller.reCalculateAfterRoundOff();
          },
        ),

        _buildTextfieldPaymentRow(
          label: 'Round Off',
          textController: controller.roundOffController,
          focusNode: roundOffFocusNode,
          onChanged: (p0) {
            controller.reCalculateAfterRoundOff();
          },
          autofocus: true,
        ),
        _buildTextfieldPaymentRow(
          label: 'Bank Charges',
          textController: controller.bankChargesAmountController,
          onChanged: (p0) {
            controller.reCalculateAfterRoundOff();
          },
        ),

        const SizedBox(height: 16),
        const MySeparator(height: 3, color: grey1),
        Obx(
          () => _buildPaymentRow('Final Amount', '₹ ${controller.totalPrice}'),
        ),
        _buildTextfieldPaymentRow(
          label: 'Received',
          textController: controller.paidAmountController,
          onChanged: (p0) {
            controller.calculateBalanceAmount();
          },
          onEditingComplete: () {
            print("Called editing 3");
            FocusManager.instance.primaryFocus?.nextFocus();
            FocusManager.instance.primaryFocus?.nextFocus();
          },

          // onTap: () {
          //   // Populate when tapped
          //   controller.populateReceivedAmountIfEmpty();
          // },
        ),
        _buildTextfieldPaymentRow(
          label: 'Balance',
          textController: controller.balanceAmountController,
          readOnly: true,
          canRequestFocus: false,
        ),
      ],
    );
  }

  Widget _buildTextfieldPaymentRow({
    required String label,
    required TextEditingController textController,
    void Function(String)? onChanged,
    bool readOnly = false,
    bool autofocus = false,
    bool canRequestFocus = true,
    void Function()? onEditingComplete,
    FocusNode? focusNode,
  }) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Satoshi',
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          SizedBox(
            width: 150,
            child: Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  if (label == 'Received') {
                    controller.populateReceivedAmountIfEmpty();
                  }
                  if (textController.text.isNotEmpty) {
                    Future.delayed(Duration.zero, () {
                      textController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: textController.text.length,
                      );
                    });
                  }
                }
              },
              child: TextFormField(
                controller: textController,
                focusNode: focusNode,
                autofocus: autofocus && focusNode == null,
                canRequestFocus: canRequestFocus,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                readOnly: readOnly,
                onTap: () {
                  // Special handling for "Received" field to select all text
                  if (label == 'Received' && textController.text.isNotEmpty) {
                    Future.delayed(const Duration(milliseconds: 50), () {
                      textController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: textController.text.length,
                      );
                    });
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                    return 'Please enter $label';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (onChanged != null) {
                    onChanged(value);
                  }

                  // Special handling for "Received" field
                  if (label == 'Received') {
                    controller.onReceivedAmountChanged();
                  }
                },
                onEditingComplete: () {
                  print("Called editing");
                  if (onEditingComplete == null) {
                    print("Called editing null");
                    FocusManager.instance.primaryFocus?.nextFocus();
                  } else {
                    print("Called editing null c");
                    onEditingComplete.call();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isBold = false}) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Satoshi',
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          SelectableText(value, style: textStyle),
        ],
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
              onTap: () => _debouncedSave(isHeld: false),
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                // color: primaryColor,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 38,
                width: 140,
                child: Center(
                  child: Obx(
                    () =>
                        purchaseInvoiceViewmodel
                                    .postSalesResponse
                                    .value
                                    .status ==
                                Status.LOADING
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
                text: controller.paymentHeaders.elementAt(i),
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
        header: controller.paymentHeaders[0],
      ),
      _buildCell(
        textController: controller.controllers[index].amount,
        header: controller.paymentHeaders[1],
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[0],
        // onChanged: (newValue) {},
      ),
      _buildDropdown(
        value: controller.controllers[index].method.text,
        list: [],
        onChanged: (value) {
          controller.setSelectedMethod(value, index);
          controller.moveNextFocus();
        },
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[1],
        onTap: () {
          controller.currentRowIndex.value = index;
          controller.currentColIndex.value = 1;
        },
      ),
      _buildDatePickerCell(
        index,
        controller.controllers[index].date,
        controller.controllers[index].tableFocusNodes[2],
      ),
      _buildBankDropdown(
        value: controller.controllers[index].pos_bank.text,
        list: controller.bankList,
        onChanged: (value) {
          controller.setSelectedBank(value, index);

          // controller.moveNextFocus();
        },
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[3],
        onTap: () {
          controller.currentRowIndex.value = index;

          controller.currentColIndex.value = 3;
        },
      ),
      _buildLastColumn(index),
    ];

    cells.add(_buildMoreOptionsCell(index));

    return TableRow(children: cells);
  }

  Widget _buildLastColumn(int index) {
    try {
      // Safety check
      if (index >= controller.controllers.length) {
        return const SizedBox(width: 100, height: 38);
      }

      // Get the payment method safely
      String methodText = '';
      try {
        methodText = controller.controllers[index].method.text;
      } catch (e) {
        log("Error getting method text at index $index: $e");
        methodText = '';
      }

      bool isCreditNoteMethod = methodText.toLowerCase() == "credit note";
      bool isCashMethod = methodText.toLowerCase() == "cash";

      if (isCreditNoteMethod) {
        // Get the balance safely
        String balance = '0';
        try {
          balance = controller.controllers[index].upi_utr_cn.text;
        } catch (e) {
          log("Error getting credit note balance: $e");
          balance = '0';
        }

        // Create a read-only display for credit note balance
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                balance.isEmpty ? '0' : balance,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      } else if (isCashMethod) {
        // For Cash method, show disabled field
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: const Center(
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
      } else {
        // Regular UPI/UTR/CN field
        FocusNode? focusNode;
        try {
          if (controller.controllers[index].tableFocusNodes.length > 4) {
            focusNode = controller.controllers[index].tableFocusNodes[4];
          }
        } catch (e) {
          log("Error getting focus node: $e");
          focusNode = null;
        }

        return _buildCell(
          textController: controller.controllers[index].upi_utr_cn,
          header: controller.paymentHeaders[5],
          rowIndex: index,
          focusNode: focusNode,
        );
      }
    } catch (e) {
      log("Critical error in _buildLastColumn: $e");
      // Return a fallback widget
      return Container(
        width: 100,
        height: 38,
        color: Colors.red.withOpacity(0.1),
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.red),
        ),
      );
    }
  }

  Widget _buildMoreOptionsCell(int rowIndex) {
    return IconButton(
      icon: const Icon(
        Icons.delete_outline_rounded,
        size: 28,
        color: redTextColor,
      ),
      onPressed: () => controller.removeCurrentRow(rowIndex),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> list,
    required Function(String?) onChanged,
    required int rowIndex,
    required FocusNode focusNode,
    required void Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          return onTableKeyEvent(node, event, rowIndex);
        },
        child: SizedBox(
          height: 52,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.receiptMethods.isEmpty) {
              return const Center(child: Text('No payment methods available'));
            }

            return GenericAutocompleteDropdown<GetReceiptMethodsResponse>(
              controller: TextEditingController(text: value),
              focusNode: focusNode,
              items: controller.receiptMethods,
              maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
              getDisplayValue: (method) => method.method ?? '',
              onSelected: (method) {
                // Set the selected method first
                controller.setSelectedMethod(method.method, rowIndex);

                // Check if the selected method is Cash
                if (method.method?.toLowerCase() == "cash") {
                  // For Cash, skip to new row instead of moving to next field
                  controller.validateAndAddRow();
                  // Set focus to the first field (amount) of the new row
                  controller.currentRowIndex.value =
                      controller.controllers.length - 1;
                  controller.currentColIndex.value = 0;
                  controller
                      .controllers[controller.currentRowIndex.value]
                      .tableFocusNodes[controller.currentColIndex.value]
                      .requestFocus();
                } else {
                  Future.delayed(const Duration(milliseconds: 50), () {
                    controller.moveNextFocus();
                  });
                }
              },
              enabled: true,
              isLastRow: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              fieldHeight: 58.0,
              borderColor: secondaryColor,
              keyboardType: TextInputType.text,
              autofocus: false,
              onEditingComplete: () {},
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBankDropdown({
    required String value,
    required List<String> list,
    required Function(String?) onChanged,
    required int rowIndex,
    required FocusNode focusNode,
    required void Function() onTap,
  }) {
    // Check if the selected method is Cash
    bool isCashMethod =
        controller.controllers[rowIndex].method.text.toLowerCase() == "cash";

    // Check if the selected method is Credit Note
    bool isCreditNoteMethod =
        controller.controllers[rowIndex].method.text.toLowerCase() ==
        "credit note";

    if (isCreditNoteMethod) {
      return _buildCreditNoteDropdown(
        value: value,
        onChanged: onChanged,
        rowIndex: rowIndex,
        focusNode: focusNode,
        onTap: onTap,
      );
    }

    // If Cash method is selected, show disabled field
    if (isCashMethod) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Center(
            child: Text(
              'None',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    // Original bank dropdown code for non-cash methods
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          return onTableKeyEvent(node, event, rowIndex);
        },
        child: SizedBox(
          height: 52,
          child: Obx(() {
            if (controller.isLoading.value ||
                controller.accountSettingsResponse.value.status ==
                    Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }

            List<String> availableBanks =
                controller.bankList.isNotEmpty
                    ? controller.bankList.toList()
                    : ["None"];

            return GenericAutocompleteDropdown<String>(
              controller: TextEditingController(text: value),
              focusNode: focusNode,
              items: availableBanks,
              maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
              getDisplayValue: (method) => method,
              onSelected: (method) {
                onChanged(method);

                if (method != "None") {
                  final accountDetails = controller.getAccountByCode(method);
                  if (accountDetails != null) {
                    log(
                      "Selected bank: ${accountDetails.accountName}, "
                      "Account Number: ${accountDetails.accountNumber}, "
                      "Payment Code: ${accountDetails.paymentCode}, "
                      "IFSC: ${accountDetails.ifsc}",
                    );
                  }
                }
                Future.delayed(const Duration(milliseconds: 50), () {
                  controller.moveNextFocus();
                });
              },
              enabled: true,
              isLastRow: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              fieldHeight: 58.0,
              borderColor: secondaryColor,
              keyboardType: TextInputType.text,
              autofocus: false,
              onEditingComplete: () {},
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCreditNoteDropdown({
    required String value,
    required Function(String?) onChanged,
    required int rowIndex,
    required FocusNode focusNode,
    required void Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          return onTableKeyEvent(node, event, rowIndex);
        },
        child: SizedBox(
          height: 52,
          child: Obx(() {
            if (controller.isCreditNotesLoading.value ||
                controller.creditNotesResponse.value.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.creditNotesList.isEmpty) {
              return const Center(
                child: Text(
                  'No credit notes available',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            }

            GetSalesReturnCreditNoteValue? selectedCreditNote;
            if (value.isNotEmpty) {
              selectedCreditNote = controller.creditNotesList.firstWhereOrNull(
                (note) => note.id == value || note.saleReturnNumber == value,
              );
            }

            return GenericAutocompleteDropdown<GetSalesReturnCreditNoteValue>(
              controller: TextEditingController(
                text: selectedCreditNote?.saleReturnNumber ?? '',
              ),
              focusNode: focusNode,
              items: controller.creditNotesList,
              maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
              getDisplayValue: (note) => note.saleReturnNumber ?? '',
              onSelected: (note) {
                // Store the credit note ID in pos_bank field
                controller.controllers[rowIndex].pos_bank.text = note.id ?? '';

                // Store the balance in upi_utr_cn field
                controller.controllers[rowIndex].upi_utr_cn.text =
                    note.balance ?? '0';

                // Update the amount field with the credit note balance
                double creditNoteBalance =
                    double.tryParse(note.balance ?? '0') ?? 0;
                controller.controllers[rowIndex].amount.text = creditNoteBalance
                    .toStringAsFixed(2);

                // Trigger UI refresh
                controller.controllers.refresh();

                // Log for debugging
                log(
                  "Selected credit note: ${note.saleReturnNumber}, Balance: ${note.balance}",
                );

                Future.delayed(const Duration(milliseconds: 50), () {
                  controller.moveNextFocus();
                });
              },
              enabled: true,
              isLastRow: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              fieldHeight: 58.0,
              borderColor: secondaryColor,
              keyboardType: TextInputType.text,
              autofocus: false,
              onEditingComplete: () {},
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    bool editable = true,
    int rowIndex = 0,
    FocusNode? focusNode,
    void Function(String)? onChanged,
  }) {
    if (!editable) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: CustomText(
          text: text ?? textController?.text ?? '0',
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
        child: TextFormField(
          inputFormatters: _getInputFormatters(header),
          focusNode: focusNode,
          onTap:
              focusNode != null
                  ? () {
                    try {
                      controller.currentRowIndex.value = rowIndex;

                      // Safe column index calculation
                      if (controller.controllers.length > rowIndex) {
                        var focusNodes =
                            controller.controllers[rowIndex].tableFocusNodes;
                        for (int i = 0; i < focusNodes.length; i++) {
                          if (identical(focusNodes[i], focusNode)) {
                            controller.currentColIndex.value = i;
                            break;
                          }
                        }
                      }
                    } catch (e) {
                      log("Error in onTap: $e");
                    }

                    // Auto-populate remaining amount if field is empty
                    if (header == 'Amount (₹)') {
                      if (textController?.text.isEmpty == true) {
                        controller.populateRemainingAmount(rowIndex);
                      }

                      // Auto-select text for amount field
                      if (textController?.text.isNotEmpty == true) {
                        Future.delayed(const Duration(milliseconds: 50), () {
                          try {
                            textController!.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: textController.text.length,
                            );
                          } catch (e) {
                            // Ignore selection errors
                          }
                        });
                      }
                    }
                  }
                  : null,
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              if (header == controller.paymentHeaders[5]) {
                // Safe method check
                String method = '';
                try {
                  method =
                      controller.controllers[rowIndex].method.text
                          .toLowerCase();
                } catch (e) {
                  method = '';
                }

                if (method != "cash" && method != "credit note") {
                  return 'Please enter $header';
                }
                return null;
              }
              if (header == 'Amount (₹)') {
                return 'Please enter $header';
              }
            }
            if (header == 'Amount (₹)' && value != null) {
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
            }
            return null;
          },
          onChanged: (value) {
            if (onChanged != null) {
              onChanged(value);
            }

            if (header == 'Amount (₹)') {
              try {
                controller.onPaymentMethodAmountChanged(rowIndex);
              } catch (e) {
                log("Error in onChanged: $e");
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildDatePickerCell(
    int rowIndex,
    TextEditingController textController,
    FocusNode focusNode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
        child: SizedBox(
          height: 38,
          child: InkWell(
            focusNode: focusNode,
            onTap: () {
              controller.currentRowIndex.value = rowIndex;

              controller.currentColIndex.value = 2;

              controller.selectDate(Get.context!, rowIndex);
            },
            child: InputDecorator(
              isFocused: focusNode.hasFocus,
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
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 1,
                      textController.text.isNotEmpty
                          ? textController.text
                          : 'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            textController.text.isNotEmpty
                                ? Colors.black
                                : Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(Icons.calendar_today, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<TextInputFormatter> _getInputFormatters(String? header) {
  if (header == 'Amount (₹)') {
    return [
      AmountInputFormatter(), // Max 2 decimal places
    ];
  }

  return [];
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
