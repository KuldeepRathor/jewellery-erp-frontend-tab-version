// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/create_jewellery_plan/setup_jewellery_plan_benefits_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/create_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class CreateJewelleryPlanPage extends StatefulWidget {
  const CreateJewelleryPlanPage({super.key});

  @override
  State<CreateJewelleryPlanPage> createState() =>
      _CreateJewelleryPlanPageState();
}

class _CreateJewelleryPlanPageState extends State<CreateJewelleryPlanPage> {
  final CreateJewelleryPlanController controller = Get.put(
    CreateJewelleryPlanController(),
  );

  final FocusNode planDetailsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      planDetailsFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    planDetailsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        autofocus: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/svgs/auth/background.svg",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                CustomHeaderWidget(header: "Create Plan", wantBackButton: true),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildPlanDetails(),
                              const SizedBox(height: 16),
                              _buildPaymentDetails(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _footerWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetails() {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildPlanNameSection()),
        const SizedBox(width: 16),
        Flexible(flex: 2, child: _buildPlanTimeFrame()),
        const SizedBox(width: 16),
        Expanded(flex: 3, child: _buildPlanDuration()),
        const SizedBox(width: 16),
        Flexible(flex: 2, child: _buildPlanType()),
      ],
    );
  }

  Widget _buildPlanNameSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Plan Details',
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          CustomTextField(
            controller: controller.planNameController,
            name: "Plan Name",
            nameColor: primaryColor,
            width: Get.width * 0.5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Plan name is required';
              }
              return null;
            },
            focusNode: planDetailsFocusNode,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanTimeFrame() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Plan Month/Days',
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _buildRadioTile('Monthly Plan', 'planTimeFrame')),
              const SizedBox(width: 16),
              Expanded(child: _buildRadioTile('Daily Plan', 'planTimeFrame')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDuration() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Plan Duration',
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => CustomDropdownField<String>(
                    name: 'Months',
                    nameFont: 12,
                    textColor: primaryColor,
                    width: Get.width * 0.5,
                    items: controller.planDurations,
                    selectedItem: controller.planDuration.value,
                    onChanged: controller.setPlanDuration,
                    enabled: controller.planTimeFrame.value == 'Monthly Plan',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => CustomTextField(
                    controller: controller.daysController,
                    name: "Days",
                    nameColor: primaryColor,
                    width: Get.width * 0.5,
                    enabled: controller.planTimeFrame.value == 'Daily Plan',
                    validator: (value) {
                      if (controller.planTimeFrame.value == 'Daily Plan') {
                        if (value == null || value.isEmpty) {
                          return 'Days are required';
                        }
                        int? days = int.tryParse(value);
                        if (days == null || days <= 0) {
                          return 'Please enter a valid number of days';
                        }
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanType() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Plan Type',
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _buildRadioTile('In Weight', 'planType')),
              const SizedBox(width: 16),
              Expanded(child: _buildRadioTile('In Rupees', 'planType')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String value, String type) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: grey1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(value),
        ),
        leading: SizedBox(
          height: 20,
          width: 20,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Obx(
              () => Radio<String>(
                value: value,
                groupValue:
                    type == 'planTimeFrame'
                        ? controller.planTimeFrame.value
                        : controller.planType.value,
                activeColor: secondaryColor,
                onChanged:
                    type == 'planTimeFrame'
                        ? controller.setPlanTimeFrame
                        : (controller.planTimeFrame.value == 'Monthly Plan'
                            ? controller.setPlanType
                            : null),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Payment Details',
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Obx(
                () => CustomTextField(
                  controller: controller.minSipAmountController,
                  name: "Mini SIP Amount*",
                  hintText: 'Min Amount',
                  width: Get.width * 0.3,
                  enabled: controller.isSipFieldsEnabled.value,
                  validator: (value) {
                    if (controller.isSipFieldsEnabled.value) {
                      if (value == null || value.isEmpty) {
                        return 'Minimum SIP amount is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => CustomTextField(
                  controller: controller.maxSipAmountController,
                  name: "Enter Max SIP Amount*",
                  hintText: 'Max Amount',
                  width: Get.width * 0.3,
                  enabled: controller.isSipFieldsEnabled.value,
                  validator: (value) {
                    if (controller.isSipFieldsEnabled.value) {
                      if (value == null || value.isEmpty) {
                        return 'Maximum SIP amount is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                      double? minSip = double.tryParse(
                        controller.minSipAmountController.text,
                      );
                      double? maxSip = double.tryParse(value);
                      if (minSip != null &&
                          maxSip != null &&
                          maxSip <= minSip) {
                        return 'Max amount must be greater than min amount';
                      }
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => CustomTextField(
              name: "Prefixed Amount",
              width: Get.width * 0.3,
              controller: controller.prefixedAmountController,
              enabled: controller.isPrefixedFieldEnabled.value,
              validator: (value) {
                if (controller.isPrefixedFieldEnabled.value) {
                  if (value == null || value.isEmpty) {
                    return 'Prefixed amount is required';
                  }
                  List<String> amounts = value.split(',');
                  if (amounts.length > 5) {
                    return 'Maximum 5 values allowed';
                  }
                  for (String amount in amounts) {
                    if (int.tryParse(amount.trim()) == null) {
                      return 'Please enter valid amounts';
                    }
                  }
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const CustomText(
            text:
                '*Note- Enter upto 5 values each seperated by comma.(1000,5000,10000,50000,100000)*',
            fontSize: 12,
            color: secondaryColor,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 40),
          const CustomText(
            text: 'Payment Gateway Charges',
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
          Obx(
            () => CheckboxListTile(
              contentPadding: const EdgeInsets.all(0),
              controlAffinity: ListTileControlAffinity.leading,
              title: const CustomText(
                text: 'Charge customers for payment gateway fees.',
                fontSize: 16,
              ),
              value: controller.chargeGatewayFees.value,
              onChanged: controller.setChargeGatewayFees,
              checkColor: whiteColor,
              activeColor: secondaryColor,
            ),
          ),
          const SizedBox(height: 40),
          BulletPointsTextField(
            controller: controller.planBenefitsController,
            name: "Plan Benefits",
            width: Get.width * 0.6,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim() == '•') {
                return 'Plan benefits are required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: whiteColor,
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.dialog(const AddRemarkDialog()),
            child: Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, color: primaryColor),
                  SizedBox(width: 5),
                  CustomText(
                    text: "Remarks",
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: controller.resetFields,
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
                  text: "Discard",
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: Get.width * 0.01),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                if (controller.validateAllFields()) {
                  SidebarController sidebarController =
                      Get.find<SidebarController>();
                  sidebarController.navigateToWidget(
                    newChild: SetupJewelleryPlanBenefitsPage(),
                  );
                }
              },
              child: Ink(
                height: 38,
                width: 140,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Next",
                      fontSize: 16,
                      color: whiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BulletPointsTextField extends StatefulWidget {
  final String? name;
  final double? width;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? enabled;
  final Color? nameColor;
  final Color? borderColor;
  final AutovalidateMode? autovalidateMode;

  const BulletPointsTextField({
    super.key,
    this.name,
    this.width,
    this.controller,
    this.validator,
    this.enabled,
    this.nameColor,
    this.borderColor,
    this.autovalidateMode,
  });

  @override
  State<BulletPointsTextField> createState() => _BulletPointsTextFieldState();
}

class _BulletPointsTextFieldState extends State<BulletPointsTextField> {
  late TextEditingController _effectiveController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
    if (_effectiveController.text.isEmpty) {
      _effectiveController.text = '• ';
      _effectiveController.selection = TextSelection.fromPosition(
        const TextPosition(offset: 2),
      );
    }
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        final text = _effectiveController.text;
        final selection = _effectiveController.selection;
        final beforeCursor = text.substring(0, selection.baseOffset);
        final afterCursor = text.substring(selection.baseOffset);

        final newText = '$beforeCursor\n• $afterCursor';

        _effectiveController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: beforeCursor.length + 3),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.name != null) ...[
          CustomText(
            text: widget.name!,
            color: widget.nameColor ?? blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          const SizedBox(height: 8),
        ],
        FormField<String>(
          validator: (_) => widget.validator?.call(_effectiveController.text),
          autovalidateMode: widget.autovalidateMode,
          builder: (FormFieldState<String> state) {
            return SizedBox(
              width: widget.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RawKeyboardListener(
                    focusNode: _focusNode,
                    onKey: _handleKeyPress,
                    child: TextFormField(
                      controller: _effectiveController,
                      enabled: widget.enabled,
                      maxLines: null,
                      minLines: 3,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Satoshi',
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          _effectiveController.text = '• ';
                          _effectiveController.selection =
                              const TextSelection.collapsed(offset: 2);
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 12.0,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.borderColor ?? secondaryColor,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.borderColor ?? secondaryColor,
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        errorStyle: const TextStyle(
                          color: redTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _effectiveController.dispose();
    }
    super.dispose();
  }
}
