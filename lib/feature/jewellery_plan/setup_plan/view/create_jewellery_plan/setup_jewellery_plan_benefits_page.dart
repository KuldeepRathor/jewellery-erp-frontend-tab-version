import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/terms_and_conditions_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/design_selection_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/design_selection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/setup_jewellery_plan_benefits_controler.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class SetupJewelleryPlanBenefitsPage extends StatelessWidget {
  SetupJewelleryPlanBenefitsPage({super.key});
  final SetupJewelleryPlanBenefitsController controller = Get.put(
    SetupJewelleryPlanBenefitsController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Focus(
        child: Form(
          key: controller.formKey,
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
                  CustomHeaderWidget(
                    header: "Create Plan",
                    wantBackButton: true,
                    onBackButtonTap: () {
                      SidebarController sidebarController = Get.find();
                      sidebarController.popBackSelectedWidget();
                    },
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(flex: 2, child: _buildPlanBenefitsWidget()),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  _footerWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanBenefitsWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Setup Plan Benefits',
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CustomTextField(
                controller: controller.vaBenefitController,
                name: "Grant VA benefit of*",
                nameColor: primaryColor,
                hintText: 'Enter % of VA benefit customer shall receive',
                width: Get.width * 0.275,
                validator: controller.validatePercentage,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
              ),
              const SizedBox(width: 16),
              CustomTextField(
                controller: controller.vaBenefitUptoController,
                name: "Upto*",
                nameColor: primaryColor,
                hintText: 'Max VA % Applicable',
                width: Get.width * 0.275,
                validator: controller.validatePercentage,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CustomTextField(
                controller: controller.mcBenefitController,
                name: "Grant MC benefit of*",
                nameColor: primaryColor,
                hintText: 'Enter % of MC benefit customer shall receive',
                width: Get.width * 0.275,
                validator: controller.validatePercentage,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
              ),
              const SizedBox(width: 16),
              CustomTextField(
                controller: controller.mcBenefitUptoController,
                name: "Upto*",
                nameColor: primaryColor,
                hintText: 'Max MC % Applicable',
                width: Get.width * 0.275,
                validator: controller.validatePercentage,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Obx(
                () => CustomDropdownField<GetStoneRatesValue>(
                  name: 'Stone Type',
                  nameFont: 12,
                  textColor: primaryColor,
                  width: Get.width * .15,
                  items: controller.stoneType,
                  selectedItem: controller.selectedStoneType.value,
                  onChanged: (GetStoneRatesValue? value) {
                    controller.setStoneType(value);
                  },
                  itemAsString: (GetStoneRatesValue? type) => type?.name ?? '',
                ),
              ),
              const SizedBox(width: 16),
              CustomTextField(
                controller: controller.stoneBenefitController,
                name: "Grant stone benefit of*",
                nameColor: primaryColor,
                hintText: 'Enter % of stone cost benefit',
                width: Get.width * 0.275,
                validator: controller.validatePercentage,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => CustomDropdownField<String>(
              name: 'Grant Installment Bonus of (Months)',
              nameFont: 12,
              textColor: primaryColor,
              width: Get.width * 0.275,
              items: controller.installmentBonusOptions,
              selectedItem: controller.installmentBonus.value,
              onChanged: controller.setInstallmentBonus,
            ),
          ),
          const SizedBox(height: 40),
          const CustomText(
            text: 'Collect GST from customers',
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  width: Get.width * 0.175,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: grey1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Obx(
                    () => ListTile(
                      title: const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: CustomText(text: 'Charge GST', fontSize: 16),
                      ),
                      leading: SizedBox(
                        height: 20,
                        width: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Radio<String>(
                            value: 'Charge GST',
                            groupValue: controller.gstType.value,
                            activeColor: secondaryColor,
                            onChanged: controller.setGstType,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Container(
                  height: 40,
                  width: Get.width * 0.175,
                  decoration: BoxDecoration(
                    border: Border.all(color: grey1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Obx(
                    () => ListTile(
                      title: const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: CustomText(
                          text: 'Offer GST in Benefits',
                          fontSize: 16,
                        ),
                      ),
                      leading: SizedBox(
                        height: 20,
                        width: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Radio<String>(
                            value: 'Offer GST in Benefits',
                            groupValue: controller.gstType.value,
                            activeColor: secondaryColor,
                            onChanged: controller.setGstType,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSelectedDesignsWidget(),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Get.dialog(DesignSelectionDialog());
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 38,
                  decoration: BoxDecoration(
                    color: grey1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Select Design",
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(width: 5),
                        CustomText(
                          text: "Ctrl + S",
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSelectedDesignsWidget() {
    DesignSelectionController designSelectionController = Get.put(
      DesignSelectionController(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Selected Designs',
          fontSize: 12,
          color: primaryColor,
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            width: Get.width * 0.275,
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                designSelectionController.selectedDesignsList.isEmpty
                    ? const CustomText(
                      text: 'No designs selected',
                      fontSize: 14,
                      color: Colors.grey,
                    )
                    : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          designSelectionController.selectedDesignsList.map((
                            design,
                          ) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: grey1,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: CustomText(
                                      text: design.name ?? '',
                                      fontSize: 14,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      designSelectionController
                                          .selectedDesignsList
                                          .remove(design);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
          ),
        ),
      ],
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
                if (controller.validateForm()) {
                  SidebarController sidebarController =
                      Get.find<SidebarController>();
                  sidebarController.navigateToWidget(
                    newChild: const TermsAndConditionsPage(),
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
