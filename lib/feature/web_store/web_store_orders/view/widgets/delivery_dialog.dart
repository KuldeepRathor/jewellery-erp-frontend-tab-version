import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view_model/delivery_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_calendar.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';

class DeliverySaveIntent extends Intent {
  const DeliverySaveIntent();
}

class DeliveryDialog extends StatefulWidget {
  final String? selectedOrderId;
  const DeliveryDialog({super.key, this.selectedOrderId});

  @override
  State<DeliveryDialog> createState() => _DeliveryDialogState();
}

class _DeliveryDialogState extends State<DeliveryDialog> {
  late final DeliveryDialogController controller;

  @override
  void initState() {
    controller = Get.put(DeliveryDialogController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.deliveryDateFocusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<DeliveryDialogController>();
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
              const DeliverySaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            DeliverySaveIntent: CallbackAction<DeliverySaveIntent>(
              onInvoke: (DeliverySaveIntent intent) {
                controller.saveReturnDetails();
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
              width: MediaQuery.of(context).size.width * 0.3,
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
              text: 'Delivery Details',
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
                        label: 'Delivered Date',
                        textController: controller.deliveryDateController,
                        validator: controller.validateReturnDate,
                        focusNode: controller.deliveryDateFocusNode,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Refund Details Section
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
                () => controller.saveReturnDetails(
                  selectedOrderId: widget.selectedOrderId,
                ),
            text: "Save (CTRL+S)",
          ),
        ],
      ),
    );
  }
}
