import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/model/get_user_commodity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/view/user_locker_card_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/view/new_delivery_party_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/view_model/new_delivery_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/model/get_commodities_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class NewDeliveryPage extends StatefulWidget {
  const NewDeliveryPage({super.key});

  @override
  State<NewDeliveryPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<NewDeliveryPage> {
  final NewDeliveryController controller = Get.put<NewDeliveryController>(
    NewDeliveryController(),
  );
  final PartyDetailsController partyDetailsController =
      Get.put<PartyDetailsController>(PartyDetailsController());

  final FocusNode partyDetailsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
                HeaderWidget(
                  header: 'Delivery Details',
                  wantBackButton: true,
                  onBackButtonTap: () {
                    SidebarController sidebarController = Get.find();
                    sidebarController.popBackSelectedWidget();
                  },
                ),
                const SizedBox(height: 16),
                // NewBookingPartyDetailsWidget(
                //   isPurchase: true,
                // ),
                _buildMobileVerify(),
                _buildUserLockerBalance(),
                _buildBookingDetails(),
                const Spacer(),
                _footerWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileVerify() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width * 0.4,
            child: NewDeliveryPartyDetailsWidget(
              isPurchase: true,
              focusNode: partyDetailsFocusNode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
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
              Obx(() {
                final apiResponse =
                    controller.getCommoditiesTypesResponse.value;

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
                  items: controller.commodityTypes,
                  selectedItem: controller.selectedCommodityType.value,
                  onChanged: (GetCommoditiesResponse? value) {
                    controller.setSelectedCommodityType(value);
                  },
                  itemAsString:
                      (GetCommoditiesResponse? type) => type?.commodity ?? '',
                );
              }),
              const SizedBox(width: 16),
              CustomTextField(
                controller: controller.weightController,
                name: "Weight (gms)",
                hintText: 'Enter Weight',
                nameColor: blackColor,
                width: Get.width * 0.2,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildUserLockerBalance() {
    return Obx(
      () =>
          controller.showUserLockerBalance.value
              ? Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'User Locker Balance',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          final response =
                              controller.getUserCommodityResponse.value;

                          if (response.status == Status.LOADING) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
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
                                      // Calculate totals for buy and deliver categories
                                      final buyData = commodity.data
                                          ?.firstWhere(
                                            (d) =>
                                                d.category?.toLowerCase() ==
                                                'buy',
                                            orElse: () => DatumDatum(),
                                          );

                                      final deliverData = commodity.data
                                          ?.firstWhere(
                                            (d) =>
                                                d.category?.toLowerCase() ==
                                                'deliver',
                                            orElse: () => DatumDatum(),
                                          );

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                        ),
                                        child: UserLockerCardWidget(
                                          width: Get.width * 0.18,
                                          type: commodity.commodity ?? 'N/A',
                                          totalAmount:
                                              buyData?.totalAmount
                                                  ?.toStringAsFixed(2) ??
                                              '0.00',
                                          totalWeight:
                                              '${commodity.weight?.toStringAsFixed(3) ?? '0.000'} gms',
                                          buyAmount:
                                              buyData?.totalAmount
                                                  ?.toStringAsFixed(2) ??
                                              '0.00',
                                          buyCount:
                                              '${buyData?.orderCount ?? 0}',
                                          deliverAmount:
                                              deliverData?.totalAmount
                                                  ?.toStringAsFixed(2) ??
                                              '0.00',
                                          deliverCount:
                                              '${deliverData?.orderCount ?? 0}',
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
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: whiteColor,
      child: Row(
        children: [
          InkWell(
            onTap: () async {
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
                  SizedBox(width: 4),
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomText(
              //   text: 'Total',
              //   fontSize: 12,
              //   color: primaryColor,
              // ),
              // SizedBox(height: 4),
              // CustomText(
              //   text: '6,000',
              //   fontSize: 16,
              // )
            ],
          ),
          SizedBox(width: Get.width * 0.01),
          InkWell(
            onTap: () {
              controller.clearAllFields();
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
          // Update the save button section in _footerWidget()
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                controller.handleSaveWithOTP();
                // await controller.createNewDelivery();

                // if (controller.newDeliveryResponse.value.status ==
                //     Status.COMPLETED) {
                //   Get.back();
                // }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Save",
                          fontSize: 16,
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: CustomText(
                            text: "Ctrl + S",
                            fontSize: 12,
                            color: whiteColor,
                            fontWeight: FontWeight.w700,
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
    );
  }
}
