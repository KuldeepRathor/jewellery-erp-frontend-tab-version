import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimation_rate_carat_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/search_mobile_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class EstimationDetailsWidget extends StatelessWidget {
  EstimationDetailsWidget({super.key, required this.partySearchFocusNode});
  final FocusNode partySearchFocusNode;
  final EstimationViewModel estimationViewModel = Get.find();
  final EstimationSearchPartyController estimationSearchPartyController =
      Get.find<EstimationSearchPartyController>();
  final EstimationItemDetailsController estimationItemDetailsController =
      Get.find<EstimationItemDetailsController>();

  final RBACController rbacController = Get.find<RBACController>();
  final RateCaratInputController rateController =
      Get.find<RateCaratInputController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        // height: 90,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // CustomTextField(
                //   name: "Rate/gm",
                //   width: 250,
                //   autofocus: true,
                //   // controller: controller.designCodeController,
                //   // onChanged: (value) => _showRetagDialog(),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Enter Design Code";
                //     }
                //     return null;
                //   },
                // ),
                Obx(
                  () => RateCaratInput(
                    readOnly:
                        estimationViewModel.isFastMode.value &&
                        (rbacController.hasAction(1102) == false),
                    onChanged: (rate, carat) {
                      if (estimationViewModel.isFastMode.value == false &&
                          rbacController.hasAction(1102)) {
                        estimationItemDetailsController.onRateChanged(
                          rate,
                          carat,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // CustomTextField(
                //   name: "Search Mobile Number",
                //   width: 250,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Enter Design Code";
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(
                  width: 250,
                  child: EstimationSearchPartyDropdown(
                    controller: estimationSearchPartyController,
                    focusNode: partySearchFocusNode,
                  ),
                ),
              ],
            ),

            // mode estimate number
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CustomText(
                      text: "Mode",
                      fontSize: 12,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Row(
                        children: [
                          // CustomText(
                          //   text: "Correction Mode",
                          //   fontSize: 14,
                          //   fontFamily: 'Satoshi',
                          //   fontWeight: FontWeight.w500,
                          //   color: estimationViewModel.isFastMode.value == false
                          //       ? redTextColor
                          //       : grey2,
                          // ),
                          CustomText(
                            text: "Fast Mode",
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color:
                                estimationViewModel.isFastMode.value
                                    ? totalGreenColor
                                    : grey2,
                          ),
                          const SizedBox(width: 16),
                          CustomToggleSwitch(
                            // focusNode: focusNode,
                            canRequestFocus: false,
                            value: estimationViewModel.isFastMode.value,
                            onChanged: (_) {
                              PermissionGuardUtil.withActionPermission(
                                2103,
                                () {
                                  estimationViewModel.toggleFastMode();
                                },
                              );
                            },
                          ),
                          // const SizedBox(
                          //   width: 16,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(color: grey2, height: 60, width: 2),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CustomText(
                      text: "Estimate No:",
                      fontSize: 12,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Row(
                        children: [
                          CustomText(
                            text:
                                estimationSearchPartyController
                                    .estimationNumber
                                    .value,
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
