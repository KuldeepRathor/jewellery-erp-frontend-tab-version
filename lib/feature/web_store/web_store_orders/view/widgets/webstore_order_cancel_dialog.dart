import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view_model/webstore_orders_cancelled_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_calendar.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class CancelSaveIntent extends Intent {
  const CancelSaveIntent();
}

class WebstoreOrdersCancelledDialog extends StatefulWidget {
  final String? selectedOrderId;
  const WebstoreOrdersCancelledDialog({super.key, this.selectedOrderId});

  @override
  State<WebstoreOrdersCancelledDialog> createState() =>
      _WebstoreOrdersCancelledDialogState();
}

class _WebstoreOrdersCancelledDialogState
    extends State<WebstoreOrdersCancelledDialog> {
  late final WebstoreOrdersCancelledDialogController controller;

  @override
  void initState() {
    controller = Get.put(WebstoreOrdersCancelledDialogController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.cancelDateFocusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<WebstoreOrdersCancelledDialogController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const CancelSaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            CancelSaveIntent: CallbackAction<CancelSaveIntent>(
              onInvoke: (CancelSaveIntent intent) {
                controller.saveCancelDetails();
                return null;
              },
            ),
          },
          child: FocusScope(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Form(
                key: controller.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildHeader(), _buildBody(), _buildFooter()],
                ),
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: 'Cancel Details',
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Return Details Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: 'Cancel Date',
                        textController: controller.cancelDateController,
                        validator: controller.validateCancelDate,
                        focusNode: controller.cancelDateFocusNode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        name: 'Reason',
                        controller: controller.reasonController,
                        hintText: 'Reason',
                        validator: controller.validateReason,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),

          // Refund Details Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Refund Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: 'Refund date',
                        textController: controller.refundDateController,
                        validator: controller.validateRefundDate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        name: 'Refund Amt.',
                        controller: controller.refundAmountController,
                        hintText: 'Enter amount',
                        validator: controller.validateRefundAmount,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        name: 'Refund Id',
                        controller: controller.refundIdController,
                        hintText: 'Enter refund ID',
                        validator: controller.validateRefundId,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController textController,
    required String? Function(String?)? validator,
    FocusNode? focusNode,
  }) {
    return CustomDateField(
      labelText: label,
      controller: textController,
      readOnly: true,
      validator: validator,
      focusNode: focusNode,
      onTap: (context) {
        controller.selectDate(context, textController);
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomInkButton(
            onPressed:
                () => controller.saveCancelDetails(
                  selectedOrderId: widget.selectedOrderId,
                ),
            text: "Save (CTRL+S)",
          ),
        ],
      ),
    );
  }
}
