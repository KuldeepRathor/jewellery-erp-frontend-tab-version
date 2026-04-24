// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AdditionalLessDialog extends StatefulWidget {
  const AdditionalLessDialog({super.key});

  @override
  State<AdditionalLessDialog> createState() => _AdditionalLessDialogState();
}

class _AdditionalLessDialogState extends State<AdditionalLessDialog> {
  final SidebarController sidebarController = Get.find<SidebarController>();
  final SalesPaymentDetailsController paymentController =
      Get.find<SalesPaymentDetailsController>();
  final TextEditingController additionalLessController =
      TextEditingController();
  final FocusNode additionalLessFocusNode = FocusNode();

  double get totalAmount {
    // Get base total from item details controller
    final itemDetailsController = Get.find<CreateSalesItemDetailsController>();
    double baseTotal =
        double.tryParse(
          itemDetailsController.totalHeadersValue[itemDetailsController
                  .totalHeadersValue
                  .length -
              2],
        ) ??
        0.0;

    log('Base Total from Items: $baseTotal');
    return baseTotal;
  }

  double get maxAllowedAmount {
    return totalAmount * 0.01; // 1% of total amount
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill with current additional less amount if any

    log('Total Price: ${paymentController.totalPrice.value}');
    additionalLessController.text =
        paymentController.additional_less.value.toString();

    // Focus on the text field when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      additionalLessFocusNode.requestFocus();
      if (additionalLessController.text.isNotEmpty &&
          additionalLessController.text != "0.0") {
        additionalLessController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: additionalLessController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    additionalLessController.dispose();
    additionalLessFocusNode.dispose();
    super.dispose();
  }

  void _validateAndApply() {
    final enteredValue = double.tryParse(additionalLessController.text) ?? 0.0;

    if (enteredValue < 0) {
      showErrorToast(message: 'Additional less amount cannot be negative');
      return;
    }

    if (enteredValue > maxAllowedAmount) {
      showErrorToast(
        message:
            'Maximum allowed additional less is ${maxAllowedAmount.toStringAsFixed(2)} (1% of total amount)',
      );
      return;
    }

    // Set the entered value directly
    paymentController.setAdditionalLess(value: enteredValue);

    log('Additional Less Amount Applied: ${enteredValue.toStringAsFixed(2)}');

    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Actions(
        actions: <Type, Action<Intent>>{
          MoveToNextScreenIntent: CallbackAction<MoveToNextScreenIntent>(
            onInvoke: (intent) {
              _validateAndApply();
              return;
            },
          ),
          ExitScreenIntent: CallbackAction<ExitScreenIntent>(
            onInvoke: (intent) {
              Get.back(result: false);
              return;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.enter):
                const MoveToNextScreenIntent(),
            LogicalKeySet(LogicalKeyboardKey.escape): const ExitScreenIntent(),
          },
          child: Focus(
            autofocus: true,
            child: Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              fit: StackFit.loose,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Additional Less Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // // Info text showing current total and max allowed
                      // Container(
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: grey1.withOpacity(0.3),
                      //     borderRadius: BorderRadius.circular(6),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         'Total Amount: ₹${formatCurrency(totalAmount.toStringAsFixed(2))}',
                      //         style: const TextStyle(fontSize: 14),
                      //       ),
                      //       const SizedBox(height: 4),
                      //       Text(
                      //         'Max Allowed (1%): ₹${formatCurrency(maxAllowedAmount.toStringAsFixed(2))}',
                      //         style: const TextStyle(
                      //           fontSize: 12,
                      //           color: secondaryColor,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: additionalLessController,
                        focusNode: additionalLessFocusNode,
                        width: Get.width * 0.25,
                        hintText: "Enter Additional Less Amount",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        onEditingComplete: () {
                          _validateAndApply();
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back(result: false);
                            },
                            child: Container(
                              height: 38,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: grey1,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ButtonShortcutWidget(
                                buttonName: "Cancel",
                                color: primaryColor,
                                shortcut: 'esc',
                                shortcutButtonBackgroundColor: grey1,
                                shortcutButtonColor: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: _validateAndApply,
                            child: Container(
                              height: 38,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: ButtonShortcutWidget(
                                  buttonName: "Apply",
                                  color: whiteColor,
                                  shortcut: 'Enter',
                                  shortcutButtonBackgroundColor: grey1,
                                  shortcutButtonColor: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () {
                      Get.back(result: false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: shortcutRedColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: redTextColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
