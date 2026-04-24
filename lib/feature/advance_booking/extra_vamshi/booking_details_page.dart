import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/party_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        children: [
          CustomHeaderWidget(header: "New Booking", wantBackButton: true),
          const SizedBox(height: 15),
          _buildMobileVerify(),
          Flexible(child: _buildBookingDetails()),
          _footerWidget(),
        ],
      ),
    );
  }

  Widget _buildMobileVerify() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width * 0.4,
            child: PartyDetailsWidget(isPurchase: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                  controller: phoneController,
                  name: "Weight (gms)",
                  hintText: 'Enter weight',
                  nameColor: blackColor,
                  width: Get.width * 0.2,
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: CustomTextField(
                  controller: phoneController,
                  name: "Rate/gms",
                  nameColor: blackColor,
                  width: Get.width * 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const CustomText(
            text:
                '*Note- You can collect the advance amount ₹6666.00 as per your booking terms of 50% *',
            fontSize: 12,
            color: primaryColor,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: phoneController,
            name: "Advance Payable Amount",
            hintText: 'Enter Amount',
            nameColor: blackColor,
            width: Get.width * 0.4,
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Total', fontSize: 12, color: primaryColor),
              SizedBox(height: 3),
              CustomText(text: '6,000', fontSize: 16),
            ],
          ),
          SizedBox(width: Get.width * 0.01),
          InkWell(
            onTap: () {},
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
              onTap: () {},
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Save",
                      fontSize: 16,
                      color: whiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(width: 5),
                    CustomText(
                      text: "Ctrl + S",
                      fontSize: 12,
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
