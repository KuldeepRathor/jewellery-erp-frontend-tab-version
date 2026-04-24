import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_components/gst_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view_model/add_vendor_tabbar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class BalanceDetailsWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController openingBalanceCreditController;
  final TextEditingController openingBalanceDebitController;
  final TextEditingController openingWeightCreditController;
  final TextEditingController openingWeightDebitController;
  final TextEditingController closingBalanceCreditController;
  final TextEditingController closingWeightDebitController;

  const BalanceDetailsWidget({
    super.key,
    required this.formKey,
    required this.openingBalanceCreditController,
    required this.openingBalanceDebitController,
    required this.openingWeightCreditController,
    required this.openingWeightDebitController,
    required this.closingBalanceCreditController,
    required this.closingWeightDebitController,
  });

  @override
  Widget build(BuildContext context) {
    final addVendorTabController = Get.find<AddVendorTabController>();
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const NextTabIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NextTabIntent: CallbackAction<NextTabIntent>(
            onInvoke:
                (NextTabIntent intent) => addVendorTabController.nextTab(null),
          ),
        },
        child: FocusScope(
          autofocus: true,
          onKeyEvent: onNormalKeyEvent,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * .02),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Opening",
                            color: primaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          SizedBox(height: Get.height * .02),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'),
                                  ),
                                ],
                                name: 'Opening Balance Credit',
                                autofocus: true,
                                width: Get.width * .2,
                                controller: openingBalanceCreditController,
                                validator: _validateNumber,
                              ),
                              SizedBox(width: Get.width * .02),
                              CustomTextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'),
                                  ),
                                ],
                                name: 'Opening Balance Debit',
                                width: Get.width * .2,
                                controller: openingBalanceDebitController,
                                validator: _validateNumber,
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * .02),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'),
                                  ),
                                ],
                                name: 'Opening Weight Credit',
                                width: Get.width * .2,
                                controller: openingWeightCreditController,
                                validator: _validateNumber,
                              ),
                              SizedBox(width: Get.width * .02),
                              CustomTextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'),
                                  ),
                                ],
                                name: 'Opening Weight Debit',
                                width: Get.width * .2,
                                controller: openingWeightDebitController,
                                validator: _validateNumber,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: Get.width * .02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Closing",
                            color: primaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          SizedBox(height: Get.height * .02),
                          CustomTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$'),
                              ),
                            ],
                            name: 'Closing Balance Credit',
                            width: Get.width * .2,
                            controller: closingBalanceCreditController,
                            validator: _validateNumber,
                          ),
                          SizedBox(height: Get.height * .02),
                          CustomTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$'),
                              ),
                            ],
                            name: 'Closing Weight Debit',
                            width: Get.width * .2,
                            controller: closingWeightDebitController,
                            validator: _validateNumber,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateNumber(String? value) {
    // if (value == null || value.isEmpty) {
    //   return 'This field is required';
    // }
    // if (double.tryParse(value) == null) {
    //   return 'Please enter a valid number';
    // }
    return null;
  }
}
