import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/new_booking/view/new_booking_party_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/new_booking/view/new_booking_paymnet_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/new_booking/view_model/new_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class NewBookingPage extends StatefulWidget {
  const NewBookingPage({super.key});

  @override
  State<NewBookingPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<NewBookingPage> {
  final NewBookingController controller = Get.put<NewBookingController>(
    NewBookingController(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Focus(
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
                  header: 'New Booking',
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
            child: NewBookingPartyDetailsWidget(
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
            text: 'Booking Details',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: CustomTextField(
                  controller: controller.weightController,
                  name: "Weight (gms)",
                  hintText: 'Enter weight',
                  nameColor: blackColor,
                  width: Get.width * 0.2,
                  onChanged: controller.onWeightChanged,
                ),
              ),
              const SizedBox(width: 16),
              // Flexible(
              //   child: CustomTextField(
              //     controller: weightController,
              //     name: "Rate/gms",
              //     nameColor: blackColor,
              //     width: Get.width * 0.2,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => CustomText(
              text: controller.noteText.value,
              fontSize: 12,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: controller.advancePayableAmountController,
            name: "Advance Payable Amount",
            hintText: 'Enter Amount',
            nameColor: blackColor,
            width: Get.width * 0.4,
          ),
          const SizedBox(height: 16),
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
              controller.clearControllers();
              partyDetailsController.clearControllers();
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
              onTap: () async {
                if (controller.validateBooking()) {
                  Get.dialog(const NewBookingPaymentDetailsDialog());
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
