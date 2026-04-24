// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/cancel_booking/view_model/cancel_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class CancelBookingPage extends StatefulWidget {
  const CancelBookingPage({super.key, required this.bookingId});
  final String bookingId;
  @override
  State<CancelBookingPage> createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage> {
  final CancelBookingController controller = Get.put<CancelBookingController>(
    CancelBookingController(),
  );
  String? _paymentMode = "Cash";
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        children: [
          CustomHeaderWidget(header: "Cancel Booking", wantBackButton: true),
          const SizedBox(height: 15),
          _buildBookingDetails(),
          const SizedBox(height: 15),
          Flexible(child: _buildPaymentsDetails()),
          const SizedBox(height: 15),
          _footerWidget(),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Booking Details',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Booking ID',
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 5),
                      CustomText(text: 'H6', fontSize: 16),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    width: 1,
                    color: grey2,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Customer Name',
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 5),
                      CustomText(text: 'Koshish Dave', fontSize: 16),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    width: 1,
                    color: grey2,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Phone Number',
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 5),
                      CustomText(text: '+91 62666759580', fontSize: 16),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    width: 1,
                    color: grey2,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Amount Paid',
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 5),
                      CustomText(text: '5,000', fontSize: 16),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    width: 1,
                    color: grey2,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Booking Rate/gm',
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 5),
                      CustomText(text: '6,000.00', fontSize: 16),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    width: 1,
                    color: grey2,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Booking Weight',
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 5),
                      CustomText(text: '5200 gms', fontSize: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Plan Status',
                fontSize: 12,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 5),
              CustomText(text: 'Active', fontSize: 16, color: totalGreenColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsDetails() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Payment Details',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: CustomTextField(
                  controller: amountController,
                  name: "Amount Collected",
                  nameColor: blackColor,
                  width: Get.width * 0.2,
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: CustomTextField(
                  controller: amountController,
                  name: "Deductions",
                  nameColor: blackColor,
                  width: Get.width * 0.2,
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: CustomTextField(
                  controller: amountController,
                  name: "Amount Payable",
                  nameColor: blackColor,
                  width: Get.width * 0.2,
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Cancel Date",
                      color: primaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectDate(
                          context,
                          controller.cancelDateController,
                        );
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          borderColor: grey1,
                          suffixIcon: const Icon(Icons.calendar_month_outlined),
                          controller: controller.cancelDateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Invoice Created Date missing";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: CustomDashedLineWidget(width: Get.width),
          ),
          const CustomText(
            text: 'Payment Mode',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: CustomDropdownField<String>(
                  name: 'Payment Mode',
                  nameFont: 12,
                  textColor: primaryColor,
                  width: Get.width * 0.2,
                  items: const ["Cash", "Card"],
                  selectedItem: _paymentMode,
                  onChanged: (value) {
                    setState(() {
                      _paymentMode = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: CustomTextField(
                  controller: amountController,
                  name: "Bank",
                  nameColor: blackColor,
                  width: Get.width * 0.2,
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Payment Date",
                      color: primaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      width: Get.width * 0.2,
                      child: InkWell(
                        onTap: () {
                          controller.selectDate(
                            context,
                            controller.paymentDateController,
                          );
                        },
                        child: AbsorbPointer(
                          child: CustomTextField(
                            borderColor: grey1,
                            suffixIcon: const Icon(
                              Icons.calendar_month_outlined,
                            ),
                            controller: controller.paymentDateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return " Payment Date missing";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: CustomDashedLineWidget(width: Get.width),
          ),
          const CustomText(
            text: 'Add Note',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          Container(
            height: Get.height * 0.1,
            width: Get.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            // child:  CustomTextField(
            //         controller: amountController,
            //         // name: "Bank",
            //         keyboardType: TextInputType.multiline,
            //         nameColor: blackColor,
            //         ``
            //         // width: Get.width * 0.2,
            //       ),
            child: TextField(
              controller: notesController,
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your notes here...",
              ),
            ),
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
            onTap: () {
              Get.dialog(_cancellationPopup());
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
              onTap: () async {},
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
                        CustomText(
                          text: "Ctrl + S",
                          fontSize: 12,
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
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

  Widget _cancellationPopup() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
        ),
        width: Get.width * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText(
              text: 'Cancellation Confirmation',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            const CustomText(
              text:
                  'Are you sure that you want to proceed with cancel the existing booking?',
              fontSize: 16,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 38,
                    width: 140,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Center(
                      child: CustomText(
                        text: "Discard(esc)",
                        fontSize: 16,
                        color: whiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      Navigator.pop(context);
                      Get.dialog(_confirmationCancellation());
                    },
                    child: Ink(
                      height: 38,
                      // width: 140,
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
                                text: "Save & Print",
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
    );
  }

  Widget _confirmationCancellation() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
        ),
        width: Get.width * 0.3,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: totalGreenColor, size: 50),
            SizedBox(height: 20),
            CustomText(
              text: 'Advance booking has been cancelled successfully',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              maxLines: 2,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
