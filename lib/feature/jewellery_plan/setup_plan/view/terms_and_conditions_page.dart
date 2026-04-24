import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/create_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/terms_and_condition_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  final TermsConditionsController controller = Get.put(
    TermsConditionsController(),
  );
  final CreateJewelleryPlanController createJewelleryPlanController = Get.put(
    CreateJewelleryPlanController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeaderWidget(header: "Create Plan", wantBackButton: true),
          _buildSubHeader(),
          Expanded(child: _termsWidget()),
          _footerWidget(),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Plan Details',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Obx(
                () =>
                    controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : CustomDropdownField<String>(
                          name: 'Choose Template*',
                          nameFont: 12,
                          textColor: primaryColor,
                          width: Get.width * 0.3,
                          items:
                              controller.termsTemplates.isEmpty
                                  ? ["No templates available"]
                                  : controller.termsTemplates
                                      .map((template) => template.text ?? '')
                                      .where((text) => text.isNotEmpty)
                                      .toList(),
                          selectedItem:
                              controller.planType.value.isEmpty &&
                                      controller.termsTemplates.isNotEmpty
                                  ? controller.termsTemplates[0].text ?? ""
                                  : controller.planType.value,
                          onChanged: controller.setPlanType,
                        ),
              ),
              const SizedBox(width: 20),
              _planTypeWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _planTypeWidget() {
    return Container(
      width: Get.width * 0.3,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: grey2,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Obx(() {
        // Calculate amount display
        String amountDisplay = '';
        if (createJewelleryPlanController
                .minSipAmountController
                .text
                .isNotEmpty &&
            createJewelleryPlanController
                .maxSipAmountController
                .text
                .isNotEmpty) {
          amountDisplay =
              '${createJewelleryPlanController.minSipAmountController.text} - ${createJewelleryPlanController.maxSipAmountController.text}';
        } else if (createJewelleryPlanController
            .prefixedAmountController
            .text
            .isNotEmpty) {
          amountDisplay =
              createJewelleryPlanController.prefixedAmountController.text;
        }

        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Plan Type',
                  fontSize: 12,
                  color: primaryColor,
                ),
                CustomText(
                  text: createJewelleryPlanController.planType.value,
                  fontSize: 12,
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Month',
                  fontSize: 12,
                  color: primaryColor,
                ),
                CustomText(
                  text: createJewelleryPlanController.planDuration.value,
                  fontSize: 12,
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Plan Amount',
                  fontSize: 12,
                  color: primaryColor,
                ),
                CustomText(
                  text: amountDisplay.isEmpty ? '0.00' : amountDisplay,
                  fontSize: 12,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _termsWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Terms & Conditions Details',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          const CustomText(
            text: 'Plan Terms & Conditions*',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          const SizedBox(height: 5),
          CustomTextField(
            controller: controller.planTermsAndConditionController,
            maxLines: 5,
            validator: controller.validateTermsContent,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 4),
          // const CustomText(
          //   text: 'Terms and conditions must be at least 50 characters long',
          //   fontSize: 12,
          //   color: Colors.grey,
          // ),
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
            onTap: () {
              Get.dialog(const AddRemarkDialog());
            },
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
            onTap: controller.handleDiscard,
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
                createJewelleryPlanController.createJewelleryPlan();
              },
              // controller.isLoading.value ? null : () async {
              // if (controller.validateFields()) {
              //   controller.handleNext();
              // }
              // },
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
