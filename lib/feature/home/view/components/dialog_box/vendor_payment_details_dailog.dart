// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/get_debit_note_purchase_return_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/vendor_purchase/view_model/vendor_payments_detail_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/purchase_invoice_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/my_separator.dart';

class PaymentDetailsTableData {
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
  PaymentDetailsTableData({
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
}

class VendorPaymentDetailsDialog extends StatefulWidget {
  const VendorPaymentDetailsDialog({super.key});

  @override
  State<VendorPaymentDetailsDialog> createState() =>
      _VendorPaymentDetailsDialogState();
}

class _VendorPaymentDetailsDialogState
    extends State<VendorPaymentDetailsDialog> {
  final VendorPaymentDetailsController controller = Get.put(
    VendorPaymentDetailsController(),
  );

  final ItemDetailsController itemDetailsController =
      Get.find<ItemDetailsController>();
  final PurchaseInvoiceViewmodel purchaseInvoiceViewmodel =
      Get.find<PurchaseInvoiceViewmodel>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print(
      "table key event called ${event.logicalKey} $rowIndex ${controller.currentColIndex.value}",
    );
    if (event is KeyDownEvent) {
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
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  };
  @override
  void initState() {
    super.initState();
    controller.initializeRow();
    controller.calculateGstvalues();

    // Auto-populate paid amount with total price and focus on it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wait for calculations to complete, then set paid amount
      Future.delayed(const Duration(milliseconds: 200), () {
        // Set paid amount to total price (balance amount)
        controller.paidAmountController.text = controller.totalPrice.value;

        // Calculate balance amount (should be 0 after setting paid amount)
        controller.calculateBalanceAmount();

        // Update first payment row with the total amount
        if (controller.controllers.isNotEmpty) {
          controller.controllers[0].amount.text = controller.totalPrice.value;
          controller.controllers.refresh();
        }

        // Focus on paid amount field and select all text
        controller.paidAmountFocusNode.requestFocus();

        // Select all text in the paid amount field after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (controller.paidAmountController.text.isNotEmpty) {
            controller.paidAmountController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.paidAmountController.text.length,
            );
          }
        });
      });
    });
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
              // Implement save functionality here
              await controller.validateAndPostPurchaseInvoice();
              return;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            // LogicalKeySet(LogicalKeyboardKey.enter): const AddStoneRowIntent(),
            // LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.escape):
            //     const RemoveLastStoneRowIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const SaveStoneDetailsIntent(),
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
            onPressed: Get.back,
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
            autofocus: true,
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
                            shortcutButtonBackgroundColor: shortcutRedColor,
                            canRequestFocus: false,
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
                        columnWidths: controller.paymentColumnWidths,
                        rows: _buildRows(),
                        isLoadingMore: false,
                        controller: controller.scrollController,
                        addSizedBox: false,
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

  Widget _buildPaymentDetails() {
    double subTotal = double.parse(
      itemDetailsController.totalHeadersValue[itemDetailsController
              .totalHeadersValue
              .length -
          2],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentRow(
          'Sub total',
          '₹ $subTotal',
          // '₹ ${controller.displaySubTotal.value}',
        ),

        _buildTextfieldPaymentRow(
          label: 'Hallmark charges',
          textController: controller.hallMarkChargesController,
          onChanged: (newValue) {
            // controller.calculateRoundedOffValue(newValue);
            controller.getRoundOffTotal();
          },
        ),
        const SizedBox(height: 8),
        // _buildPaymentRow('Nett', '₹ 24,00,000.00'),
        Obx(() => _buildPaymentRow('CGST', '₹ ${controller.CGStValue}')),
        Obx(() => _buildPaymentRow('SGST', '₹ ${controller.SGSTValue}')),
        Obx(() => _buildPaymentRow('IGST', '₹ ${controller.IGStValue}')),

        const SizedBox(height: 16),
        // _buildPaymentRow('Total', '₹ ${controller.getTotalGstValue()}'),
        const MySeparator(height: 3, color: grey1),
        _buildTextfieldPaymentRow(
          label: 'Round Off',
          textController: controller.roundOffController,
          onChanged: (newValue) {
            // controller.calculateRoundedOffValue(newValue);
            controller.getRoundOffTotal();
          },
          onEditingComplete: () {
            FocusManager.instance.primaryFocus?.nextFocus();
            FocusManager.instance.primaryFocus?.nextFocus();
            FocusManager.instance.primaryFocus?.nextFocus();
          },
        ),
        //TODO
        Obx(
          () => _buildPaymentRow(
            'Total',
            '₹ ${controller.roundOffTotalToShow.value}',
          ),
        ),
        const SizedBox(height: 8),
        const MySeparator(height: 3, color: grey1),
        _buildTextfieldPaymentRow(
          label: 'TCS',
          textController: controller.tcsController,
          onChanged: (p0) {
            controller.calculateTaxChange();
          },
          readOnly: true,
        ),
        _buildTextfieldPaymentRow(
          label: 'TDS',
          textController: controller.tdsController,
          onChanged: (p0) {
            controller.calculateTaxChange();
          },
          readOnly: true,
        ),
        const SizedBox(height: 16),
        Obx(() => _buildPaymentRow('Nett', '₹ ${controller.totalPrice.value}')),
        const SizedBox(height: 16),
        const MySeparator(height: 3, color: grey1),
        _buildTextfieldPaymentRow(
          label: 'Paid Amount',
          textController: controller.paidAmountController,
          onChanged: (p0) {
            controller.calculateBalanceAmount();
            // Update first payment row when paid amount changes
            if (controller.controllers.isNotEmpty) {
              double totalReceived =
                  double.tryParse(controller.paidAmountController.text) ?? 0;
              if (controller.controllers.length == 1) {
                controller.controllers[0].amount.text = totalReceived
                    .toStringAsFixed(2);
              } else {
                // If multiple rows exist, calculate remaining amount for first row
                double otherRowsTotal = 0;
                for (int i = 1; i < controller.controllers.length; i++) {
                  otherRowsTotal +=
                      double.tryParse(controller.controllers[i].amount.text) ??
                      0;
                }
                double firstRowAmount = totalReceived - otherRowsTotal;
                controller.controllers[0].amount.text =
                    firstRowAmount >= 0
                        ? firstRowAmount.toStringAsFixed(2)
                        : "0.00";
              }
              controller.controllers.refresh();
            }
          },
          onEditingComplete: () {
            FocusManager.instance.primaryFocus?.nextFocus();
            FocusManager.instance.primaryFocus?.nextFocus();
            FocusManager.instance.primaryFocus?.nextFocus();
          },
          onTap: () {
            // Select all text when tapped
            if (controller.paidAmountController.text.isNotEmpty) {
              Future.delayed(const Duration(milliseconds: 50), () {
                controller.paidAmountController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.paidAmountController.text.length,
                );
              });
            }
          },
        ),
        _buildTextfieldPaymentRow(
          label: 'Balance Amount',
          textController: controller.balanceAmountController,
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildTextfieldPaymentRow({
    required String label,
    required TextEditingController textController,
    void Function(String)? onChanged,
    bool readOnly = false,
    void Function()? onEditingComplete,
    void Function()? onTap, // Add onTap parameter
  }) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Satoshi',
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          SizedBox(
            width: 130,
            child: Focus(
              onFocusChange: (hasFocus) {
                // Auto-select text when field gains focus
                if (hasFocus && textController.text.isNotEmpty) {
                  Future.delayed(Duration.zero, () {
                    textController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: textController.text.length,
                    );
                  });
                }
              },
              child: TextFormField(
                controller: textController,
                autofocus: label == 'Round Off',
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                readOnly: readOnly,
                focusNode:
                    label == 'Paid Amount'
                        ? controller.paidAmountFocusNode
                        : null,
                inputFormatters: [
                  AmountInputFormatter(), // Use your existing formatter for 2 decimal places
                ],
                onTap: () {
                  if (onTap != null) {
                    onTap();
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
                onChanged: onChanged,
                onEditingComplete: () {
                  if (onEditingComplete == null) {
                    FocusManager.instance.primaryFocus?.nextFocus();
                  } else {
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(value, style: textStyle),
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
              onTap: () => controller.validateAndPostPurchaseInvoice(),
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
                                    .postPurchaseInvoiceResponse
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
        onChanged: (newValue) {
          controller.onPaymentMethodAmountChanged(index); // Add this line
        },
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

          controller.moveNextFocus();
        },
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[3],
        onTap: () {
          controller.currentRowIndex.value = index;

          controller.currentColIndex.value = 3;
        },
      ),
      _buildLastColumn(index),
      // _buildCell(
      //   textController: controller.controllers[index].upi_utr_cn,
      //   header: controller.paymentHeaders[5],
      //   rowIndex: index,
      //   focusNode: controller.controllers[index].tableFocusNodes[4],
      // ),
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

      bool isDebitNoteMethod = methodText.toLowerCase() == "debit note";
      bool isCashMethod = methodText.toLowerCase() == "cash";

      if (isDebitNoteMethod) {
        // Get the balance safely
        String balance = '0';
        try {
          balance = controller.controllers[index].upi_utr_cn.text;
        } catch (e) {
          log("Error getting debit note balance: $e");
          balance = '0';
        }

        // Create a read-only display for debit note balance
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
        // Regular UPI/UTR/CN field for other payment methods
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

            if (controller.paymentMethods.isEmpty) {
              return const Center(child: Text('No payment methods available'));
            }

            return GenericAutocompleteDropdown<PaymentMethodResponse>(
              controller: TextEditingController(text: value),
              focusNode: focusNode,
              items: controller.paymentMethods,
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
                  // For other payment methods, move to next field normally
                  controller.moveNextFocus();
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
    // bool isCashMethod =
    //     controller.controllers[rowIndex].method.text.toLowerCase() == "cash";

    // Check if the selected method is Debit Note
    bool isDebitNoteMethod =
        controller.controllers[rowIndex].method.text.toLowerCase() ==
        "debit note";

    if (isDebitNoteMethod) {
      return _buildDebitNoteDropdown(
        value: value,
        onChanged: onChanged,
        rowIndex: rowIndex,
        focusNode: focusNode,
        onTap: onTap,
      );
    }
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
            // Show loading state if either payment methods or bank list is loading
            if (controller.isLoading.value ||
                controller.accountSettingsResponse.value.status ==
                    Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }

            // Use the dynamic bank list from controller
            List<String> availableBanks =
                controller.bankList.isNotEmpty
                    ? controller.bankList.toList()
                    : ["None"]; // Fallback

            return GenericAutocompleteDropdown<String>(
              controller: TextEditingController(text: value),
              focusNode: focusNode,
              items: availableBanks,
              maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
              getDisplayValue: (method) => method,
              onSelected: (method) {
                onChanged(method);

                // Optional: Log selected account details
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

  Widget _buildDebitNoteDropdown({
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
            if (controller.isDebitNotesLoading.value ||
                controller.debitNotesResponse.value.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.debitNotesList.isEmpty) {
              return const Center(
                child: Text(
                  'No debit notes available',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            }

            GetPurchaseReturnDebitNoteValue? selectedDebitNote;
            if (value.isNotEmpty) {
              selectedDebitNote = controller.debitNotesList.firstWhereOrNull(
                (note) => note.id == value || note.returnInvoiceNumber == value,
              );
            }

            return GenericAutocompleteDropdown<GetPurchaseReturnDebitNoteValue>(
              controller: TextEditingController(
                text: selectedDebitNote?.returnInvoiceNumber ?? '',
              ),
              focusNode: focusNode,
              items: controller.debitNotesList,
              maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
              getDisplayValue: (note) => note.returnInvoiceNumber ?? '',
              onSelected: (note) {
                // Store the debit note ID in pos_bank field
                controller.controllers[rowIndex].pos_bank.text = note.id ?? '';

                // Store the balance in upi_utr_cn field
                controller.controllers[rowIndex].upi_utr_cn.text =
                    note.balance ?? '0';

                // Update the amount field with the debit note balance
                double debitNoteBalance =
                    double.tryParse(note.balance ?? '0') ?? 0;
                controller.controllers[rowIndex].amount.text = debitNoteBalance
                    .toStringAsFixed(2);

                // Trigger UI refresh
                controller.controllers.refresh();

                // Log for debugging
                log(
                  "Selected debit note: ${note.returnInvoiceNumber}, Balance: ${note.balance}",
                );

                // Move to next field
                controller.moveNextFocus();
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

  // Widget _buildBankDropdown({
  //   required String value,
  //   required List<String> list,
  //   required Function(String?) onChanged,
  //   required int rowIndex,
  //   required FocusNode focusNode,
  //   required void Function() onTap,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 4),
  //     child: Focus(
  //       canRequestFocus: false,
  //       onKeyEvent: (node, event) {
  //         return onTableKeyEvent(node, event, rowIndex);
  //       },
  //       child: SizedBox(
  //         height: 52,
  //         child: Obx(() {
  //           if (controller.isLoading.value) {
  //             return const Center(child: CircularProgressIndicator());
  //           }

  //           if (controller.paymentMethods.isEmpty) {
  //             return const Center(child: Text('No payment methods available'));
  //           }

  //           return GenericAutocompleteDropdown<String>(
  //             controller: TextEditingController(text: value),
  //             focusNode: focusNode,
  //             items: list,
  //             maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
  //             getDisplayValue: (method) => method,
  //             onSelected: (method) => onChanged(method),
  //             enabled: true,
  //             isLastRow: true,
  //             padding: const EdgeInsets.symmetric(vertical: 8),
  //             fieldHeight: 58.0,
  //             borderColor: secondaryColor,
  //             keyboardType: TextInputType.text,
  //             autofocus: false,
  //             onEditingComplete: () {},
  //           );
  //         }),
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
    FocusNode? focusNode,
    void Function(String)? onChanged,
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
                    inputFormatters: _getInputFormatters(header),
                    focusNode: focusNode,
                    onTap: () {
                      controller.currentRowIndex.value = rowIndex;

                      controller.currentColIndex.value = controller
                          .controllers[rowIndex]
                          .tableFocusNodes
                          .indexOf(focusNode!);
                    },
                    autofocus:
                        rowIndex == 0 && header == controller.paymentHeaders[1],
                    controller: textController,
                    keyboardType: TextInputType.number,
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
                        borderSide: BorderSide(
                          color: secondaryColor,
                          width: 2.0,
                        ),
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
                        if (header == controller.paymentHeaders[5]) {
                          // UPI/UTR/CN column
                          // Only require UPI/UTR/CN if payment method is not cash
                          bool isCashPayment =
                              controller.controllers[rowIndex].method.text ==
                              "Cash";
                          if (!isCashPayment) {
                            return 'Please enter $header';
                          }
                          return null;
                        }
                        if (header == 'Amount (₹)') {
                          return 'Please enter $header';
                        }
                      }
                      if (header == 'Amount (₹)') {
                        if (double.tryParse(value!) == null) {
                          return 'Please enter a valid number';
                        }
                      }
                      return null;
                    },
                    onChanged: onChanged,
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

  Widget _buildDatePickerCell(
    int rowIndex,
    TextEditingController textController,
    FocusNode focusNode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
