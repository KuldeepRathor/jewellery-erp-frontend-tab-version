import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/extra_vamshi/add_advance_details.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddAdvanceAmountPage extends StatefulWidget {
  const AddAdvanceAmountPage({super.key});

  @override
  State<AddAdvanceAmountPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<AddAdvanceAmountPage> {
  final phoneController = TextEditingController();
  final invoiceController = TextEditingController();
  final completionDateController = TextEditingController();
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
            // child: PartyDetailsWidget(
            //   isPurchase: true,
            // ),
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
              onTap: () async {
                Get.dialog(_paymentDetailsPopup());
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
                          padding: EdgeInsets.only(top: 5.0),
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

  Widget _paymentDetailsPopup() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        // padding: const EdgeInsets.all(20),
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
        ),
        width: Get.width * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderPopup(),
            Expanded(child: _buildBodyPopup()),
            _savePopup(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderPopup() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
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
            text: 'Payment Details',
            fontSize: 16,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: redTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPopup() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const CustomText(
                  text: 'Payment Summary',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: 'Booking Amount', fontSize: 16),
                    CustomText(text: '5000.00', fontSize: 16),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CustomDashedLineWidget(width: Get.width),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: 1,
          height: 200,
          color: primaryColor,
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const CustomText(
                  text: 'Payment Method Details',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 15),
                Table(
                  // columnWidths: vendor_column_widths,
                  children: const [
                    TableRow(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: secondaryColor,
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: ' Amount (₹)',
                              color: whiteColor,
                              fontSize: 16,
                            ),
                            CustomText(
                              text: 'Method',
                              color: whiteColor,
                              fontSize: 16,
                            ),
                            CustomText(
                              text: 'Date',
                              color: whiteColor,
                              fontSize: 16,
                            ),
                            CustomText(
                              text: 'POS/Bank',
                              color: whiteColor,
                              fontSize: 16,
                            ),
                            CustomText(
                              text: 'UPI/IFTR/Cn.',
                              color: whiteColor,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: ' 5,000', fontSize: 16),
                            CustomText(text: 'Cheque', fontSize: 16),
                            CustomText(text: '14/12/2024', fontSize: 16),
                            CustomText(text: 'SBI', fontSize: 16),
                            CustomText(text: '524000', fontSize: 16),
                            Icon(Icons.delete, color: redTextColor),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CustomDashedLineWidget(width: Get.width),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _savePopup() {
    return Container(
      width: Get.width,
      //  height: 50,
      padding: const EdgeInsets.all(10),
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
        children: [
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.pop(context);
                SidebarController sidebarController =
                    Get.find<SidebarController>();
                sidebarController.navigateToWidget(
                  newChild: const AddAdvanceDetails(),
                );
              },
              child: Ink(
                height: 38,
                width: 140,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: "Save",
                          fontSize: 16,
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          color: grey1,
                          child: const CustomText(
                            text: "Ctrl + S",
                            fontSize: 12,
                            color: primaryColor,
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
