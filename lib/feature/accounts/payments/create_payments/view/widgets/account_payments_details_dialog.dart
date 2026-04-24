// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view_model/account_payment_details_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view_model/accounts_payment_line_item_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/get_debit_note_purchase_return_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/payment_method_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/my_separator.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';

class AccountPaymentDetailsDialog extends StatefulWidget {
  const AccountPaymentDetailsDialog({super.key});

  @override
  State<AccountPaymentDetailsDialog> createState() =>
      _AccountPaymentDetailsDialogState();
}

class _AccountPaymentDetailsDialogState
    extends State<AccountPaymentDetailsDialog> {
  final AccountPaymentDetailsController controller = Get.find();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    if (event is KeyDownEvent) {
      // Check if current payment method is Cash or Debit Note
      String currentMethod =
          controller.controllers[rowIndex].method.text.toLowerCase();
      bool isCashMethod = currentMethod == "cash";

      if ((controller.currentColIndex.value == 0 || // Invoice Number
              controller.currentColIndex.value == 1 || // Method
              controller.currentColIndex.value == 3) && // POS/Bank
          event.logicalKey == LogicalKeyboardKey.enter) {
        return KeyEventResult.ignored;
      }

      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          // Check if we're on invoice number field (index 0)
          if (controller.currentColIndex.value == 0) {
            // Move to method field
            controller.currentColIndex.value = 1;
            controller.controllers[rowIndex].tableFocusNodes[1].requestFocus();
            return KeyEventResult.handled;
          }
          // Check if we're on the method column (index 1)
          else if (controller.currentColIndex.value == 1) {
            // Move to amount field
            controller.currentColIndex.value = 2;
            controller.controllers[rowIndex].tableFocusNodes[2].requestFocus();
            return KeyEventResult.handled;
          }
          // Check if we're on amount field (index 2)
          else if (controller.currentColIndex.value == 2) {
            String selectedMethod =
                controller.controllers[rowIndex].method.text.toLowerCase();
            if (selectedMethod == "cash") {
              // For Cash, skip POS/Bank and go directly to date field (index 4)
              controller.currentColIndex.value = 4;
              controller.controllers[rowIndex].tableFocusNodes[4]
                  .requestFocus();
            } else if (selectedMethod == "debit note") {
              // For Debit Note, go to POS/Bank field (index 3) for debit note selection
              controller.currentColIndex.value = 3;
              controller.controllers[rowIndex].tableFocusNodes[3]
                  .requestFocus();
            } else {
              // For other methods, go to POS/Bank field (index 3)
              controller.currentColIndex.value = 3;
              controller.controllers[rowIndex].tableFocusNodes[3]
                  .requestFocus();
            }
            return KeyEventResult.handled;
          }
          // Check if we're on POS/Bank field (index 3)
          else if (controller.currentColIndex.value == 3) {
            // Always go to date field next (index 4)
            controller.currentColIndex.value = 4;
            controller.controllers[rowIndex].tableFocusNodes[4].requestFocus();
            return KeyEventResult.handled;
          }
          // Check if we're on date field (index 4)
          else if (controller.currentColIndex.value == 4) {
            if (isCashMethod) {
              // For Cash, skip UPI/UTR/CN and create new row
              controller.validateAndAddRow();
              controller.currentRowIndex.value =
                  controller.controllers.length - 1;
              controller.currentColIndex.value = 0;
              controller
                  .controllers[controller.currentRowIndex.value]
                  .tableFocusNodes[controller.currentColIndex.value]
                  .requestFocus();
            } else {
              // For Debit Note and other methods, go to UPI/UTR/CN field (index 5)
              controller.currentColIndex.value = 5;
              controller.controllers[rowIndex].tableFocusNodes[5]
                  .requestFocus();
            }
            return KeyEventResult.handled;
          }
          // Check if we're on the last column (UPI/UTR/CN field - index 5)
          else if (controller.currentColIndex.value == 5) {
            // Add a new row and move focus to the first field
            controller.validateAndAddRow();
            return KeyEventResult.handled;
          } else {
            // Default behavior - just move to the next field
            controller.moveNextFocus();
            return KeyEventResult.handled;
          }
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab &&
          HardwareKeyboard.instance.isShiftPressed) {
        // When going backward with Shift+Tab
        if (controller.currentColIndex.value == 4) {
          // If on Date field (index 4), go back based on method
          if (isCashMethod) {
            // For Cash, skip POS/Bank and go back to Amount field (index 2)
            controller.currentColIndex.value = 2;
            controller.controllers[rowIndex].tableFocusNodes[2].requestFocus();
          } else {
            // For other methods, go back to POS/Bank field (index 3)
            controller.currentColIndex.value = 3;
            controller.controllers[rowIndex].tableFocusNodes[3].requestFocus();
          }
          return KeyEventResult.handled;
        }
        controller.movePreviousFocus(node);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        // When going forward with Tab
        if (controller.currentColIndex.value == 2) {
          // From Amount field
          String selectedMethod =
              controller.controllers[rowIndex].method.text.toLowerCase();
          if (selectedMethod == "cash") {
            // For Cash, skip POS/Bank and go to Date field (index 4)
            controller.currentColIndex.value = 4;
            controller.controllers[rowIndex].tableFocusNodes[4].requestFocus();
          } else {
            // For other methods, go to POS/Bank field (index 3)
            controller.currentColIndex.value = 3;
            controller.controllers[rowIndex].tableFocusNodes[3].requestFocus();
          }
          return KeyEventResult.handled;
        } else if (controller.currentColIndex.value == 3) {
          // From POS/Bank, always go to Date field (index 4)
          controller.currentColIndex.value = 4;
          controller.controllers[rowIndex].tableFocusNodes[4].requestFocus();
          return KeyEventResult.handled;
        } else if (controller.currentColIndex.value == 4) {
          // From Date field
          if (isCashMethod) {
            // For Cash, skip UPI/UTR/CN and create new row
            controller.validateAndAddRow();
            controller.currentRowIndex.value =
                controller.controllers.length - 1;
            controller.currentColIndex.value = 0;
            controller
                .controllers[controller.currentRowIndex.value]
                .tableFocusNodes[controller.currentColIndex.value]
                .requestFocus();
          } else {
            // For other methods, go to UPI/UTR/CN field (index 5)
            controller.currentColIndex.value = 5;
            controller.controllers[rowIndex].tableFocusNodes[5].requestFocus();
          }
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
        controller.removeRow(rowIndex);
      }
    }
    return KeyEventResult.ignored;
  };
  @override
  void initState() {
    super.initState();

    controller.fetchPaymentMethods();
    controller.setInvoiceNumberDropdown();

    // Then initialize rows after a short delay to ensure amountController is populated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the row with proper amount distribution after everything is set up
      controller.initializeRow();

      if (controller.controllers.isNotEmpty) {
        controller.controllers[0].tableFocusNodes[0].requestFocus();
        controller.currentRowIndex.value = 0;
        controller.currentColIndex.value = 0;

        // Auto-select the amount text if it's not empty
        if (controller.controllers[0].amount.text.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 100), () {
            controller.controllers[0].amount.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.controllers[0].amount.text.length,
            );
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        // Add Shortcuts and Actions widgets here
        child: Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const PostAccountReceiptsDetailsIntent(),
          },
          child: Actions(
            actions: {
              PostAccountReceiptsDetailsIntent:
                  CallbackAction<PostAccountReceiptsDetailsIntent>(
                    onInvoke: (intent) async {
                      final isLoading =
                          controller.postPaymentResponse.value.status ==
                          Status.LOADING;
                      // Use custom validation that handles empty rows
                      if (!isLoading && controller.validatePaymentRows()) {
                        controller.postPayment();
                      }
                      return null;
                    },
                  ),
            },
            child: FocusScope(
              autofocus: true,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildContent()),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildPaymentDetails(),
          ),
        ),
        const SizedBox(width: 16),
        Container(width: 2, height: Get.height, color: secondaryColor),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
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
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentField(
          label: 'Amount',
          textController: controller.amountController,
          readOnly: true,
          autofocus: true,
        ),
        _buildPaymentField(
          label: 'Round Off',
          textController: controller.roundOffController,
        ),
        _buildPaymentField(
          label: 'Bank Charges',
          textController: controller.bankChargesController,
        ),
        const MySeparator(height: 3, color: grey1),
        const SizedBox(height: 16),
        Obx(
          () => _buildPaymentRow(
            'Total',
            '₹ ${controller.totalController.value}',
          ),
        ),
        Obx(
          () => _buildPaymentRow('TCS', '₹ ${controller.tcsController.value}'),
        ),
        Obx(
          () => _buildPaymentRow('TDS', '₹ ${controller.tdsController.value}'),
        ),
        Obx(
          () =>
              _buildPaymentRow('Nett', '₹ ${controller.nettController.value}'),
        ),
        const SizedBox(height: 16),
        const MySeparator(height: 3, color: grey1),
        const SizedBox(height: 16),
        Obx(
          () => _buildPaymentRow(
            'Final Total',
            '₹ ${controller.finalTotalController.value}',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentField({
    required String label,
    required TextEditingController textController,
    bool readOnly = false,
    bool autofocus = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontSize: 14,
            color: primaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 4),
          CustomTextField(
            autofocus: autofocus,
            controller: textController,
            width: double.infinity,
            readOnly: readOnly,
            keyboardType: TextInputType.number,
            validator: (value) => controller.validateNumber(value),
            onChanged: (value) {
              // Special handling for amount field
              if (label == 'Amount') {
                controller.onTotalAmountChanged();
              }
              controller.calculateTotals();
            },
            onTap: () {
              // Auto-select text when tapped (similar to sales dialog)
              if (label == 'Amount' && textController.text.isNotEmpty) {
                Future.delayed(const Duration(milliseconds: 50), () {
                  textController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: textController.text.length,
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontSize: 14,
            color: primaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: value,
            fontSize: 14,
            color: secondaryColor,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeaders() {
    return TableRow(
      children:
          controller.paymentHeaders
              .map(
                (header) => Row(
                  children: [
                    if (header != "Sn") const SizedBox(width: 4),
                    Flexible(
                      child: CustomText(
                        text: header,
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }

  List<TableRow> _buildRows() {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index),
    );
  }

  TableRow _buildTableRow(int index) {
    final row = controller.controllers[index];
    return TableRow(
      children: [
        // 1. Sr no
        _buildCell(text: (index + 1).toString()),

        // In the _buildTableRow method, update the invoice number dropdown
        _buildDropdownCell(
          index: index,
          textController: row.invoiceNumber,
          items: controller.invoiceList,
          focusNode: row.tableFocusNodes[0],
          isSearchable: true,
          onSelected: (value) {
            row.invoiceNumber.text = value;

            // Get the line item controller to access invoice details
            final AccountsPaymentLineItemController lineItemController =
                Get.find<AccountsPaymentLineItemController>();

            // Find the selected invoice from the items list
            final selectedInvoice = lineItemController.items.firstWhereOrNull(
              (item) => item.invoiceNumber == value,
            );

            if (selectedInvoice != null) {
              // Populate the amount field with the balance from the selected invoice
              row.amount.text = selectedInvoice.balance;

              // Trigger the amount change handler to recalculate totals
              controller.onPaymentMethodAmountChanged(index);

              // Refresh the controllers to update UI
              controller.controllers.refresh();
            }

            // Add a small delay to ensure dropdown has closed and method field is ready
            Future.delayed(const Duration(milliseconds: 100), () {
              // Move focus to method field (index 1)
              controller.currentColIndex.value = 1;
              row.tableFocusNodes[1].requestFocus();
            });
          },
          validator:
              (value) => controller.validateBasedOnMethod(
                value,
                index,
                'invoice_number',
              ),
        ),
        // 3. Method
        _buildMethodDropdown(
          index: index,
          textController: row.method,
          focusNode: row.tableFocusNodes[1], // Keep as 1
          onSelected: (value) {
            row.method.text = value;
            if (value == 'Cash') {
              row.pos_bank.clear();
              row.upi_utr_cn.clear();
            }
            // Add delay to ensure dropdown closes properly
            Future.delayed(const Duration(milliseconds: 100), () {
              controller.currentColIndex.value = 2;
              row.tableFocusNodes[2].requestFocus();
            });
          },
          validator:
              (value) =>
                  controller.validateBasedOnMethod(value, index, 'method'),
        ),

        // 4. Amount
        _buildTableCell(
          textController: row.amount,
          rowIndex: index,
          focusNode: row.tableFocusNodes[2], // Changed from 0 to 2
          keyboardType: TextInputType.number,
          validator:
              (value) =>
                  controller.validateBasedOnMethod(value, index, 'amount'),
          fieldType: 'amount',
        ),

        // 5. POS/Bank
        _buildBankDropdownCell(
          index: index,
          textController: row.pos_bank,
          focusNode: row.tableFocusNodes[3], // Changed from 4 to 3
          validator:
              (value) =>
                  controller.validateBasedOnMethod(value, index, 'pos_bank'),
        ),

        // 6. Date
        _buildDatePickerCell(
          index: index,
          textController: row.date,
          focusNode: row.tableFocusNodes[4], // Changed from 2 to 4
          validator:
              (value) => controller.validateBasedOnMethod(value, index, 'date'),
        ),

        // 7. UPI/UTR/Cn
        _buildDebitNoteAwareCell(
          textController: row.upi_utr_cn,
          rowIndex: index,
          focusNode: row.tableFocusNodes[5], // Keep as 5
          validator:
              (value) =>
                  controller.validateBasedOnMethod(value, index, 'upi_utr_cn'),
          fieldType: 'upi_utr_cn',
        ),

        // 8. Actions
        _buildActionCell(index),
      ],
    );
  }

  Widget _buildDebitNoteAwareCell({
    required TextEditingController textController,
    required int rowIndex,
    required FocusNode focusNode,
    String? Function(String?)? validator,
    String? fieldType,
  }) {
    final method = controller.controllers[rowIndex].method.text.toLowerCase();

    if (method == "debit note") {
      // For debit notes, show a read-only field with the balance
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 4,
        ), // Same as receipt dialog
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Center(
            child: Tooltip(
              message: textController.text.isEmpty ? '0' : textController.text,
              child: Text(
                textController.text.isEmpty ? '0' : textController.text,
                style: const TextStyle(
                  fontSize: 14, // Keep at 14 to match receipt dialog
                  fontWeight:
                      FontWeight.w500, // Keep at w500 to match receipt dialog
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (method == "cash") {
      // For cash, show a disabled field
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 4,
        ), // Same as receipt dialog
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
                fontSize: 16, // Keep at 16 to match receipt dialog
                fontWeight:
                    FontWeight.w500, // Keep at w500 to match receipt dialog
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    } else {
      // For other methods, show the regular input field
      return _buildTableCell(
        textController: textController,
        rowIndex: rowIndex,
        focusNode: focusNode,
        validator: validator,
        fieldType: fieldType,
      );
    }
  }

  Widget _buildCell({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      child: CustomText(text: text, fontSize: 16, color: primaryTextColor),
    );
  }

  Widget _buildBankDropdownCell({
    required int index,
    required TextEditingController textController,
    required FocusNode focusNode,
    String? Function(String?)? validator,
  }) {
    bool isCashMethod =
        controller.controllers[index].method.text.toLowerCase() == "cash";

    bool isDebitNoteMethod =
        controller.controllers[index].method.text.toLowerCase() == "debit note";

    if (isDebitNoteMethod) {
      return _buildDebitNoteDropdown(
        index: index,
        textController: textController,
        focusNode: focusNode,
        onSelected: (value) {
          textController.text = value;
          Future.delayed(const Duration(milliseconds: 150), () {
            controller.currentColIndex.value = 4;
            controller.controllers[index].tableFocusNodes[4].requestFocus();
          });
        },
        validator: validator,
      );
    }

    if (isCashMethod) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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

    // Add Obx wrapper for reactive updates and loading state
    return Obx(() {
      // Show loading indicator while fetching accounts
      if (controller.accountSettingsResponse.value.status == Status.LOADING) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      // Get available banks from the controller
      List<String> availableBanks =
          controller.bankList.isNotEmpty
              ? controller.bankList.toList()
              : ["None"];

      return _buildDropdownCell(
        index: index,
        textController: textController,
        items: availableBanks,
        focusNode: focusNode,
        onSelected: (value) {
          textController.text = value;

          // Log account details if not "None"
          if (value != "None") {
            final accountDetails = controller.getAccountByCode(value);
            if (accountDetails != null) {
              log(
                "Selected bank: ${accountDetails.accountName}, "
                "Account Number: ${accountDetails.accountNumber}, "
                "Payment Code: ${accountDetails.paymentCode}, "
                "IFSC: ${accountDetails.ifsc}",
              );
            }
          }

          Future.delayed(const Duration(milliseconds: 150), () {
            controller.currentColIndex.value = 4;
            controller.controllers[index].tableFocusNodes[4].requestFocus();
          });
        },
        validator: validator,
      );
    });
  }

  Widget _buildTableCell({
    required TextEditingController textController,
    required int rowIndex,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? fieldType,
  }) {
    return Focus(
      canRequestFocus: true,
      onKeyEvent: (node, event) => onTableKeyEvent(node, event, rowIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        ), // Same as receipt dialog
        child: CustomTextField(
          controller: textController,
          onTap: () {
            controller.currentRowIndex.value = rowIndex;
            // Find the index of the current focusNode in the tableFocusNodes list
            int colIndex = controller.controllers[rowIndex].tableFocusNodes
                .indexOf(focusNode);
            controller.currentColIndex.value = colIndex;

            // Auto-select text for amount field
            if (fieldType == 'amount' && textController.text.isNotEmpty) {
              Future.delayed(const Duration(milliseconds: 50), () {
                textController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: textController.text.length,
                );
              });
            }
          },
          focusNode: focusNode,
          keyboardType: keyboardType,
          validator: validator,
          borderColor:
              controller.controllers.length == rowIndex + 1
                  ? secondaryColor
                  : Colors.transparent,
          onChanged: (value) {
            // Handle amount field changes
            if (fieldType == 'amount') {
              controller.onPaymentMethodAmountChanged(rowIndex);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDatePickerCell({
    required int index,
    required TextEditingController textController,
    required FocusNode focusNode,
    String? Function(String?)? validator,
  }) {
    if (textController.text.isEmpty) {
      textController.text = convertDateTimeToString(DateTime.now());
    }
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        ), // Same as receipt dialog
        child: InkWell(
          focusNode: focusNode,
          onTap: () async {
            controller.currentRowIndex.value = index;
            controller.currentColIndex.value = controller
                .controllers[index]
                .tableFocusNodes
                .indexOf(focusNode);

            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              textController.text = convertDateTimeToString(date);
            }
          },
          child: AbsorbPointer(
            child: CustomTextField(
              controller: textController,
              readOnly: true,
              validator: validator,
              borderColor:
                  controller.controllers.length == index + 1
                      ? secondaryColor
                      : Colors.transparent,
              suffixIcon: const Icon(Icons.calendar_today, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodDropdown({
    required int index,
    required TextEditingController textController,
    required FocusNode focusNode,
    required dynamic Function(String) onSelected,
    String? Function(String?)? validator,
  }) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return GenericAutocompleteDropdown<PaymentMethodResponse>(
            controller: textController,
            focusNode: focusNode,
            items: controller.paymentMethods,
            maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
            getDisplayValue: (method) => method.method ?? '',
            onSelected: (method) {
              controller.setSelectedMethod(method.method, index);

              // Add delay to ensure dropdown closes before moving focus
              Future.delayed(const Duration(milliseconds: 150), () {
                // Always move to amount field (index 2) after selecting method
                controller.currentColIndex.value = 2;
                controller.controllers[index].tableFocusNodes[2].requestFocus();
              });
            },
            validator: validator,
            onEditingComplete: () {},
            onTap: () {
              controller.currentRowIndex.value = index;
              controller.currentColIndex.value = controller
                  .controllers[index]
                  .tableFocusNodes
                  .indexOf(focusNode);
            },
            enabled: true,
            isLastRow: controller.controllers.length == index + 1,
          );
        }),
      ),
    );
  }

  Widget _buildDropdownCell({
    required int index,
    required TextEditingController textController,
    required List<String> items,
    required FocusNode focusNode,
    bool isSearchable = false,
    required dynamic Function(String) onSelected,
    String? Function(String?)? validator,
  }) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
      child: Padding(
        padding: const EdgeInsets.all(
          4.0,
        ), // Changed from 8.0 to 4.0 to match receipt dialog
        child: GenericAutocompleteDropdown<String>(
          controller: textController,
          focusNode: focusNode,
          items: items,
          getDisplayValue: (item) => item,
          onSelected: onSelected,
          maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
          validator: validator,
          onEditingComplete: () {},
          onTap: () {
            controller.currentRowIndex.value = index;
            controller.currentColIndex.value = controller
                .controllers[index]
                .tableFocusNodes
                .indexOf(focusNode);
          },
          enabled: true,
          isLastRow: controller.controllers.length == index + 1,
        ),
      ),
    );
  }

  Widget _buildDebitNoteDropdown({
    required int index,
    required TextEditingController textController,
    required FocusNode focusNode,
    required dynamic Function(String) onSelected,
    String? Function(String?)? validator,
  }) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
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
          if (textController.text.isNotEmpty) {
            selectedDebitNote = controller.debitNotesList.firstWhereOrNull(
              (note) =>
                  note.id == textController.text ||
                  note.returnInvoiceNumber == textController.text,
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
              controller.controllers[index].pos_bank.text = note.id ?? '';

              // Store the balance in upi_utr_cn field
              controller.controllers[index].upi_utr_cn.text =
                  note.balance ?? '0';

              // Update the amount field with the debit note balance
              double debitNoteBalance =
                  double.tryParse(note.balance ?? '0') ?? 0;
              controller.controllers[index].amount.text = debitNoteBalance
                  .toStringAsFixed(2);

              // Trigger UI refresh
              controller.controllers.refresh();

              // Log for debugging
              log(
                "Selected debit note: ${note.returnInvoiceNumber}, Balance: ${note.balance}",
              );

              // Go to date field (index 4) instead of creating new row
              Future.delayed(const Duration(milliseconds: 150), () {
                controller.currentColIndex.value = 4;
                controller.controllers[index].tableFocusNodes[4].requestFocus();
              });
            },
            enabled: true,
            isLastRow: controller.controllers.length == index + 1,
            validator: validator,
            onEditingComplete: () {},
            onTap: () {
              controller.currentRowIndex.value = index;
              controller.currentColIndex.value = controller
                  .controllers[index]
                  .tableFocusNodes
                  .indexOf(focusNode);
            },
          );
        }),
      ),
    );
  }

  Widget _buildActionCell(int index) {
    return IconButton(
      icon: const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Icon(
          Icons.delete_outline_rounded,
          size: 28,
          color: redTextColor,
        ),
      ),
      onPressed: () => controller.removeRow(index),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              // accountTableController.clearControllers();
              // accountTableController.addRow();
              // journalViewModel.clearControllers();
            },
            child: Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: CustomText(
                  text: 'Save & Print',
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Material(
            color: Colors.transparent,
            child: Obx(() {
              final isLoading =
                  controller.postPaymentResponse.value.status == Status.LOADING;

              return InkWell(
                // onTap: isLoading
                //     ? null
                //     : () async {
                //         if (controller.controllers.length > 1 &&
                //             controller.controllers.last.amount.text.isEmpty) {
                //           controller.controllers.removeLast();
                //         }
                //         await Future.delayed(const Duration(milliseconds: 100));
                //         if (controller.formKey.currentState!.validate()) {
                //           controller.postPayment();
                //         }
                //       },
                onTap:
                    isLoading
                        ? null
                        : () async {
                          // Use custom validation that handles empty rows
                          if (controller.validatePaymentRows()) {
                            controller.postPayment();
                          }
                        },
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  decoration: BoxDecoration(
                    color:
                        isLoading
                            ? primaryColor.withOpacity(0.7)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 38,
                  width: 140,
                  child: Center(
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  whiteColor,
                                ),
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
              );
            }),
          ),
        ],
      ),
    );
  }
}
