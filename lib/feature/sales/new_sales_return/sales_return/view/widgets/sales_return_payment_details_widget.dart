// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

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
}

class SalesReturnPaymentDetailsDialog extends StatefulWidget {
  const SalesReturnPaymentDetailsDialog({super.key});

  @override
  State<SalesReturnPaymentDetailsDialog> createState() =>
      _SalesReturnPaymentDetailsDialog();
}

class _SalesReturnPaymentDetailsDialog
    extends State<SalesReturnPaymentDetailsDialog> {
  final SalesReturnPaymentDetailsController controller =
      Get.find<SalesReturnPaymentDetailsController>();

  final SalesReturnItemDetailsController itemDetailsController =
      Get.find<SalesReturnItemDetailsController>();
  final SalesReturnViewmodel purchaseInvoiceViewmodel =
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
  void initState() {
    super.initState();
    controller.initializeRow();
    controller.calculateGstvalues();
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
            width: Get.width * 0.3,
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
                    onKeyEvent: onNormalKeyEvent,
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
                onKeyEvent: onNormalKeyEvent,
                child: _buildPaymentDetails(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentRow(
          'Sub Total',
          '₹ ${itemDetailsController.totalHeadersValue[itemDetailsController.totalHeadersValue.length - 3]}',
        ),
        _buildTextfieldPaymentRow(
          label: 'Scheme Disc',
          textController: controller.schemeDiscountController,
          onChanged: (p0) {
            controller.calculateGstvaluesWithDebouncer();
          },
        ),
        _buildTextfieldPaymentRow(
          label: 'Rate Disc',
          textController: controller.rateDiscountController,
          onChanged: (p0) {
            controller.calculateGstvaluesWithDebouncer();
          },
        ),
        _buildTextfieldPaymentRow(
          label: 'Discount',
          textController: controller.discountController,
          onChanged: (p0) {
            controller.calculateGstvaluesWithDebouncer();
          },
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
            controller.reCalculateAfterRoundOffWithDebouncer();
          },
        ),
        _buildTextfieldPaymentRow(
          label: 'Advance (ADJ)',
          textController: controller.advanceAmountController,
          onChanged: (p0) {
            controller.reCalculateAfterRoundOffWithDebouncer();
          },
        ),
        _buildTextfieldPaymentRow(
          label: 'Round Off',
          textController: controller.roundOffController,
          onChanged: (p0) {
            controller.reCalculateAfterRoundOffWithDebouncer();
          },
        ),
        _buildTextfieldPaymentRow(
          label: 'Bank Charges',
          textController: controller.bankChargesAmountController,
          onChanged: (p0) {
            controller.reCalculateAfterRoundOffWithDebouncer();
          },
        ),
        const SizedBox(height: 16),
        const MySeparator(height: 3, color: grey1),
        Obx(
          () => _buildPaymentRow('Final Amount', '₹ ${controller.totalPrice}'),
        ),
      ],
    );
  }

  Widget _buildTextfieldPaymentRow({
    required String label,
    required TextEditingController textController,
    void Function(String)? onChanged,
    bool readOnly = false,
  }) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Satoshi',
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          SizedBox(
            width: 150,
            child: TextFormField(
              controller: textController,
              autofocus: label == 'Round Off',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              readOnly: readOnly,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
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
              onTap: () {
                controller.validateAndPostPurchaseInvoice();
              },
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
}
