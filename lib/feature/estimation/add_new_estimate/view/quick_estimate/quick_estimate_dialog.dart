import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/quick_estimate/quick_estimate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class QuickEstimateDialog extends StatelessWidget {
  const QuickEstimateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final QuickEstimateController controller =
        Get.find<QuickEstimateController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearControllers();
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveAdvanceBookingIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveAdvanceBookingIntent: CallbackAction<SaveAdvanceBookingIntent>(
              onInvoke: (SaveAdvanceBookingIntent intent) {
                controller.handleQuickEstimateDoneWithOldGold();
                return;
              },
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              height: Get.height * .25,
              width: Get.width * .25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                key: controller.quickEstimateFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(controller),
                    Expanded(child: _buildBookingForm(controller)),
                    // _buildFooter(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(QuickEstimateController controller) {
    return Container(
      height: 54,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Add Estimate',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm(QuickEstimateController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const CustomText(
          //   text: "Booking Details",
          //   fontSize: 16,
          //   fontWeight: FontWeight.w700,
          // ),
          // const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  autofocus: true,
                  controller: controller.estimateNumberTextController,
                  name: 'Estimate Number',
                  width: Get.width * .2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Estimate details';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    controller.fetchEstimateByEstimateNumber();
                  },
                  onChanged: (value) {
                    final textController =
                        controller.estimateNumberTextController;
                    final capitalizedValue = value.toUpperCase();
                    final currentCursorPosition =
                        textController.selection.baseOffset;
                    textController.value = TextEditingValue(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(
                        offset: currentCursorPosition,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
