import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/get_savings_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/view/new_plan_party_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/view/new_plan_paymnet_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/view_model/new_plan_paymnet_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/view_model/start_new_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class StartNewPlan extends StatefulWidget {
  const StartNewPlan({super.key});

  @override
  StartNewPlanState createState() => StartNewPlanState();
}

class StartNewPlanState extends State<StartNewPlan> {
  final PartyDetailsController partyDetailsController =
      Get.put<PartyDetailsController>(PartyDetailsController());

  final RemarksController remarksController = Get.find<RemarksController>();
  final StartNewPlanController controller = Get.put<StartNewPlanController>(
    StartNewPlanController(),
  );
  final NewPlanPaymentDetailsController newPlanPaymentDetailsController =
      Get.put(NewPlanPaymentDetailsController());

  final FocusNode partyDetailsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    remarksController.purchaseRemarks.value = "";
    partyDetailsController.clearControllers();
    controller.getSavingsPlan();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      partyDetailsFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    partyDetailsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        MoveToNextScreenIntent: CallbackAction<MoveToNextScreenIntent>(
          onInvoke: (intent) async {
            bool partySelected =
                partyDetailsController.selectedParty.value != null;
            if (partySelected == true) {
              // Get.dialog(const PaymentDetailsDialog());
            } else {
              if (partySelected == false) {
                showErrorToast(message: "Please select Party");
              } else {
                showErrorToast(message: "Please enter valid data");
              }
            }
            return;
          },
        ),
        EditPartyIntent: CallbackAction<EditPartyIntent>(
          onInvoke: (intent) {
            final selectedParty = partyDetailsController.selectedParty.value;
            if (selectedParty == null) {
              return;
            }

            if (selectedParty is CustomerSearchValue) {
              Get.dialog(AddCustomerDialog(customerId: selectedParty.id));
            } else if (selectedParty is VendorSearchValue) {
              Get.dialog(AddVendorDialog(vendorId: selectedParty.id));
            }
            return;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const MoveToNextScreenIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyE):
              const EditPartyIntent(),
        },
        child: FocusScope(
          autofocus: true,
          child: Container(
            color: grey1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      header: 'Start New Plan',
                      wantBackButton: true,
                      onBackButtonTap: () {
                        SidebarController sidebarController = Get.find();
                        sidebarController.popBackSelectedWidget();
                        controller.resetFields();
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: NewPlanPartyDetailsWidget(
                                      isPurchase: true,
                                      focusNode: partyDetailsFocusNode,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(flex: 2, child: SizedBox()),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 220,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const CustomText(
                                              text: 'Choose Plan',
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                // Plan Type Dropdown
                                                Obx(() {
                                                  final response =
                                                      controller
                                                          .getSavingsPlanResponse
                                                          .value;
                                                  if (response.status ==
                                                      Status.LOADING) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (response.status ==
                                                      Status.ERROR) {
                                                    return Center(
                                                      child: Text(
                                                        response.message ??
                                                            'Error loading plans',
                                                      ),
                                                    );
                                                  }
                                                  return CustomDropdownField<
                                                    GetSavingsPlanValue
                                                  >(
                                                    name: 'Plan Type',
                                                    nameFont: 12,
                                                    textColor: primaryColor,
                                                    width: Get.width * .3,
                                                    items: controller.planTypes,
                                                    selectedItem:
                                                        controller
                                                            .selectedPlanType
                                                            .value,
                                                    onChanged: (
                                                      GetSavingsPlanValue?
                                                      value,
                                                    ) {
                                                      controller
                                                          .setSelectedPlanType(
                                                            value,
                                                          );
                                                    },
                                                    itemAsString:
                                                        (
                                                          GetSavingsPlanValue?
                                                          type,
                                                        ) => type?.name ?? '',
                                                  );
                                                }),
                                                const SizedBox(width: 16),
                                                Obx(() {
                                                  final selectedPlan =
                                                      controller
                                                          .selectedPlanType
                                                          .value;
                                                  if (selectedPlan == null) {
                                                    return const SizedBox();
                                                  }
                                                  return CustomTextField(
                                                    name: 'SIP Amount',
                                                    width: Get.width * 0.15,
                                                    hintText:
                                                        "${selectedPlan.minimum ?? 'N/A'} - ${selectedPlan.maximum ?? 'N/A'}",
                                                    controller:
                                                        controller
                                                            .sipAmountController,
                                                  );
                                                }),
                                                const SizedBox(width: 16),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(bottom: 0, left: 0, right: 0, child: FooterWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final SidebarController sidebarController = Get.find();
  // final NewPlanPaymentDetailsController newPlanPaymentDetailsController =
  //     Get.put(NewPlanPaymentDetailsController());
  final StartNewPlanController controller = Get.put<StartNewPlanController>(
    StartNewPlanController(),
  );

  FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            SizedBox(width: Get.width * 0.02),
            SingleChildScrollView(
              child: Row(
                children: [
                  // Obx(
                  //   () => CustomText(
                  //     text:
                  //         '₹ $newPlanPaymentDetailsController.installmentAmountController.text',
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  // Obx(() => CustomText(
                  //       text:
                  //           '₹ ${newPlanPaymentDetailsController.installmentAmount.value}',
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w700,
                  //     )),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      controller.resetFields();
                      sidebarController.popBackSelectedWidget();
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
                        if (controller.sipAmountController.text.isEmpty) {
                          showErrorToast(message: "Please enter SIP amount");
                          return;
                        }
                        Get.dialog(const NewPlanPaymentDetailsDialog());
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
                            CustomText(
                              text: " (ctrl + s)",
                              fontSize: 16,
                              color: whiteColor,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
