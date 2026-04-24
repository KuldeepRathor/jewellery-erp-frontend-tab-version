// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/view_model/new_plan_paymnet_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/purchase_invoice_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class NewPlanPaymentDetailsTableData {
  TextEditingController amount;
  TextEditingController method;
  TextEditingController date;
  TextEditingController pos_bank;
  TextEditingController upi_utr_cn;
  int? bankId;
  List<FocusNode> tableFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  NewPlanPaymentDetailsTableData({
    required this.amount,
    required this.method,
    required this.date,
    required this.pos_bank,
    required this.upi_utr_cn,
    this.bankId,
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

class NewPlanPaymentDetailsDialog extends StatefulWidget {
  const NewPlanPaymentDetailsDialog({super.key});

  @override
  State<NewPlanPaymentDetailsDialog> createState() =>
      _NewPlanPaymentDetailsDialogState();
}

class _NewPlanPaymentDetailsDialogState
    extends State<NewPlanPaymentDetailsDialog> {
  final NewPlanPaymentDetailsController controller = Get.put(
    NewPlanPaymentDetailsController(),
  );

  final PurchaseInvoiceViewmodel purchaseInvoiceViewmodel =
      Get.put<PurchaseInvoiceViewmodel>(PurchaseInvoiceViewmodel());

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
    // _setInstallmentAmount();
  }

  // void _setInstallmentAmount() {
  //   final StartNewPlanController planController =
  //       Get.find<StartNewPlanController>();
  //   if (planController.hasPlanDetails()) {
  //     controller.installmentAmountController.text =
  //         planController.getActivePlanAmount() ?? '0';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Actions(
        actions: <Type, Action<Intent>>{
          SaveStoneDetailsIntent: CallbackAction<SaveStoneDetailsIntent>(
            onInvoke: (intent) async {
              // Implement save functionality here
              await controller.validateAndCreateSubscription();
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
            height: Get.height * 0.55,
            width: Get.width * 0.65,
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
          flex: 2,
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
        Container(width: 2, height: Get.height, color: secondaryColor),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
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
                          ),
                          ButtonShortcutWidget(
                            onTap: controller.removeLastRow,
                            buttonName: "Remove",
                            shortcut: "Shift+Esc",
                            color: redTextColor,
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
        const CustomText(
          text: "Paymnet Summary",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 8),
        _buildPaymentRow(
          'Installment Amount',
          '₹${controller.startNewPlanController.sipAmountController.text}',
        ),
      ],
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
              onTap: () => controller.validateAndCreateSubscription(),
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                // color: primaryColor,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 38,
                width: 180,
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
                              buttonName: "Save & Print",
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
    required Function(String?) onChanged,
    required int rowIndex,
    required FocusNode focusNode,
    required void Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
        child: SizedBox(
          height: 52,
          child: Obx(() {
            if (controller.accountsResponse.value.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.accountsResponse.value.status == Status.ERROR) {
              return const Center(
                child: Text(
                  'Error loading data',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            final items =
                list
                    .map((method) => PaymentMethodResponse(method: method))
                    .toList();

            if (items.isEmpty) {
              return const Center(child: Text('No options available'));
            }

            return GenericAutocompleteDropdown<PaymentMethodResponse>(
              controller: TextEditingController(text: value),
              focusNode: focusNode,
              items: items,
              getDisplayValue: (method) => method.method ?? '',
              onSelected: (method) => onChanged(method.method),
              enabled: true,
              isLastRow: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              fieldHeight: 58.0,
              borderColor: secondaryColor,
              keyboardType: TextInputType.text,
              autofocus: false,
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

                      if (header == controller.paymentHeaders[1]) {
                        controller.currentColIndex.value = 0;
                      } else if (header == controller.paymentHeaders[2]) {
                        controller.currentColIndex.value = 1;
                      } else if (header == controller.paymentHeaders[3]) {
                        controller.currentColIndex.value = 2;
                        log("Setting 3");
                      } else if (header == controller.paymentHeaders[4]) {
                        controller.currentColIndex.value = 3;
                      } else if (header == controller.paymentHeaders[5]) {
                        log("Setting 5");
                        controller.currentColIndex.value = 4;
                      } else {
                        controller.currentColIndex.value = 0;
                      }
                    },
                    autofocus:
                        rowIndex == 0 && header == controller.paymentHeaders[1],
                    controller: textController,
                    keyboardType: TextInputType.number,
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
