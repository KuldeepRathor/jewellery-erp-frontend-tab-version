import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/purchase_invoice_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_service_create/view_model/service_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_service_create/view_model/service_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/my_separator.dart';

class ServicePaymentDetailsDialog extends StatefulWidget {
  const ServicePaymentDetailsDialog({super.key});

  @override
  State<ServicePaymentDetailsDialog> createState() =>
      _ServicePaymentDetailsDialogState();
}

class _ServicePaymentDetailsDialogState
    extends State<ServicePaymentDetailsDialog> {
  final ServicePaymentDetailsController controller = Get.put(
    ServicePaymentDetailsController(),
  );

  final ServiceItemDetailsWidgetController itemDetailsController =
      Get.find<ServiceItemDetailsWidgetController>();
  final PurchaseInvoiceViewmodel purchaseInvoiceViewmodel =
      Get.find<PurchaseInvoiceViewmodel>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    log("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      if ((controller.currentColIndex.value == 2 ||
              controller.currentColIndex.value == 4) &&
          event.logicalKey == LogicalKeyboardKey.enter) {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.paidAmountFocusNode.requestFocus();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => _buildPaymentRow(
            'Sub total',
            '₹ ${controller.displaySubTotal.value}',
          ),
        ),

        // _buildTextfieldPaymentRow(
        //   label: 'Hallmark charges',
        //   textController: controller.hallMarkChargesController,
        //   onChanged: (newValue) {
        //     // controller.calculateRoundedOffValue(newValue);
        //     controller.getRoundOffTotal();
        //   },
        // ),
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
        ),
        _buildTextfieldPaymentRow(
          label: 'TDS',
          textController: controller.tdsController,
          onChanged: (p0) {
            controller.calculateTaxChange();
          },
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
          },
          onEditingComplete: () {
            FocusManager.instance.primaryFocus?.nextFocus();
            FocusManager.instance.primaryFocus?.nextFocus();
            FocusManager.instance.primaryFocus?.nextFocus();
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
                AmountInputFormatter(), // 2 decimal places for all monetary values
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
              onEditingComplete: () {
                if (onEditingComplete == null) {
                  FocusManager.instance.primaryFocus?.nextFocus();
                } else {
                  onEditingComplete.call();
                }
              },
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
        onChanged: (newValue) {},
      ),
      _buildDropdown(
        value: controller.controllers[index].method.text,
        list: controller.methodList,
        onChanged: (value) => controller.setSelectedMethod(value, index),
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
      _buildDropdown(
        value: controller.controllers[index].pos_bank.text,
        list: controller.bankList,
        onChanged: (value) => controller.setSelectedBank(value, index),
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[3],
        onTap: () {
          controller.currentRowIndex.value = index;

          controller.currentColIndex.value = 3;
        },
      ),
      _buildCell(
        textController: controller.controllers[index].upi_utr_cn,
        header: controller.paymentHeaders[5],
        rowIndex: index,
        focusNode: controller.controllers[index].tableFocusNodes[4],
      ),
    ];

    cells.add(_buildMoreOptionsCell(index));

    return TableRow(children: cells);
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
    required void Function(String?)? onChanged,
    required int rowIndex,
    required void Function() onTap,
    required FocusNode focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
        child: SizedBox(
          height: 52,
          child: GenericAutocompleteDropdown<String>(
            controller: TextEditingController(text: value),
            focusNode: focusNode,
            items: list,
            getDisplayValue: (String type) => type,
            onSelected: (String value) {
              onChanged?.call(value);
            },
            enabled: true,
            isLastRow: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            fieldHeight: 58.0,
            borderColor: secondaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            autofocus: false,
          ),
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
                    inputFormatters: [
                      if (header == 'Amount (₹)')
                        AmountInputFormatter(), // 2 decimal places for amount fields
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
              isFocused: focusNode.hasFocus,
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
