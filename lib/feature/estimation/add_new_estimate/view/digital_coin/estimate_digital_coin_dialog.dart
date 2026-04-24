import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/model/get_user_commodity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/view/user_locker_card_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/view_model/new_delivery_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/get_commodities_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/digital_coin/estimation_digital_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class EstimationDigitalGoldDialog extends StatelessWidget {
  const EstimationDigitalGoldDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final EstimationDigitalGoldController controller =
        Get.find<EstimationDigitalGoldController>();

    // final NewDeliveryController newDeliveryController =
    //     Get.put<NewDeliveryController>(NewDeliveryController());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveQuickOldGoldEstimateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveQuickOldGoldEstimateIntent:
                CallbackAction<SaveQuickOldGoldEstimateIntent>(
                  onInvoke: (SaveQuickOldGoldEstimateIntent intent) {
                    return;
                  },
                ),
          },
          child: Container(
            height: Get.height * .775,
            width: Get.width * .55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: controller.quickOldGoldFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Expanded(child: _buildDigitalGoldForm(controller)),
                  _buildFooter(controller),
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
            text: 'Add Digital Gold',
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

  Widget _buildDigitalGoldForm(EstimationDigitalGoldController controller) {
    final NewDeliveryController newDeliveryController =
        Get.put<NewDeliveryController>(NewDeliveryController());
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Digital Gold Details",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  autofocus: true,
                  controller: controller.phoneNumberController,
                  name: 'Mobile Number',
                  width: Get.width * .2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Estimate details';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  const CustomText(text: ""),
                  Obx(
                    () => CustomButton1(
                      buttonName: 'Fetch Details',
                      isLoading:
                          newDeliveryController
                              .getDigitalCoinUserDataResponse
                              .value
                              .status ==
                          Status.LOADING,
                      onTap: () {
                        if (controller
                            .phoneNumberController
                            .value
                            .text
                            .isNotEmpty) {
                          newDeliveryController.verifyUser(
                            controller.phoneNumberController.value.text,
                          );
                        } else {
                          showErrorToast(
                            message: "Please enter a phone number to verify",
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          _buildUserLockerBalance(),
          _buildBookingDetails(),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    final NewDeliveryController newDeliveryController =
        Get.find<NewDeliveryController>();
    final EstimationDigitalGoldController controller =
        Get.find<EstimationDigitalGoldController>();

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Other Details',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              // Commodity Type Dropdown
              Obx(() {
                final apiResponse =
                    newDeliveryController.getCommoditiesTypesResponse.value;
                if (apiResponse.status == Status.LOADING) {
                  return const SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (apiResponse.status == Status.ERROR) {
                  return CustomText(
                    text: 'Error: ${apiResponse.message}',
                    color: Colors.red,
                  );
                }

                return CustomDropdownField<GetCommoditiesResponse>(
                  name: 'Commodity Type',
                  nameFont: 12,
                  textColor: primaryColor,
                  width: Get.width * .2,
                  items: newDeliveryController.commodityTypes,
                  selectedItem: controller.selectedCommodityType.value,
                  onChanged: (GetCommoditiesResponse? value) {
                    controller.updateSelectedCommodity(
                      value,
                      newDeliveryController.getUserCommodityResponse.value.data,
                    );
                  },
                  itemAsString:
                      (GetCommoditiesResponse? type) => type?.commodity ?? '',
                );
              }),

              const SizedBox(width: 16),

              // Weight Input Field
              SizedBox(
                width: Get.width * 0.2,
                child: CustomTextField(
                  controller: controller.weightController,
                  name: "Weight (gms)",
                  hintText: 'Enter Weight',
                  nameColor: blackColor,
                  onChanged: (value) {
                    controller.validateWeight(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Available Balance Text
          Obx(() {
            final balance = controller.availableLockerBalance.value;
            if (balance > 0) {
              return CustomText(
                text: 'Available Balance: $balance gms',
                color: primaryColor,
                fontSize: 12,
              );
            }
            return const SizedBox.shrink();
          }),

          // Validation Message
          Obx(() {
            if (!controller.isWeightValid.value &&
                controller.weightController.text.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: CustomText(
                  text:
                      'Weight must be between 0 and ${controller.availableLockerBalance.value} gms',
                  color: Colors.red,
                  fontSize: 12,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildUserLockerBalance() {
    final NewDeliveryController newDeliveryController =
        Get.put<NewDeliveryController>(NewDeliveryController());

    return Expanded(
      // Wrap with Expanded to take remaining vertical space
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          // Use Column to organize content vertically
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'User Locker Balance',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            const SizedBox(height: 16),
            Expanded(
              // Wrap the Obx with Expanded to take remaining space
              child: Obx(() {
                final response =
                    newDeliveryController.getUserCommodityResponse.value;

                if (response.status == Status.LOADING) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (response.status == Status.ERROR) {
                  return Center(
                    child: CustomText(
                      text: 'Error: ${response.message}',
                      color: Colors.red,
                    ),
                  );
                }

                if (response.status == Status.COMPLETED &&
                    response.data?.data != null) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          response.data!.data!.map((commodity) {
                            final buyData = commodity.data?.firstWhere(
                              (d) => d.category?.toLowerCase() == 'buy',
                              orElse: () => DatumDatum(),
                            );

                            final deliverData = commodity.data?.firstWhere(
                              (d) => d.category?.toLowerCase() == 'deliver',
                              orElse: () => DatumDatum(),
                            );

                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: UserLockerCardWidget(
                                width: Get.width * 0.16,
                                type: commodity.commodity ?? 'N/A',
                                totalAmount:
                                    buyData?.totalAmount?.toStringAsFixed(2) ??
                                    '0.00',
                                totalWeight:
                                    '${commodity.weight?.toStringAsFixed(3) ?? '0.000'} gms',
                                buyAmount:
                                    buyData?.totalAmount?.toStringAsFixed(2) ??
                                    '0.00',
                                buyCount: '${buyData?.orderCount ?? 0}',
                                deliverAmount:
                                    deliverData?.totalAmount?.toStringAsFixed(
                                      2,
                                    ) ??
                                    '0.00',
                                deliverCount: '${deliverData?.orderCount ?? 0}',
                              ),
                            );
                          }).toList(),
                    ),
                  );
                }

                return const Center(
                  child: CustomText(
                    text: 'No data available',
                    color: Colors.grey,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(EstimationDigitalGoldController controller) {
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
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GetBuilder<EstimationDigitalGoldController>(
            builder: (controller) {
              final isValid = controller.isCurrentSelectionValid();
              return InkWell(
                onTap:
                    isValid
                        ? () {
                          if (controller.quickOldGoldFormKey.currentState
                                  ?.validate() ??
                              false) {
                            log(
                              'Selected Commodity: ${controller.selectedCommodityType.value?.commodity}',
                            );
                            log(
                              'Entered Weight: ${controller.enteredWeight.value}',
                            );
                            log(
                              'Available Balance: ${controller.availableLockerBalance.value}',
                            );
                            log(
                              "Calculated Amount${controller.calculatedAmount.value}",
                            );
                            Get.back(
                              result: {
                                'commodity':
                                    controller.selectedCommodityType.value,
                                'weight': controller.enteredWeight.value,
                              },
                            );
                          }
                        }
                        : null,
                child: Container(
                  width: 120,
                  height: 38,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Done",
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomText(
                          text: " (ctrl + s)",
                          color: whiteColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
