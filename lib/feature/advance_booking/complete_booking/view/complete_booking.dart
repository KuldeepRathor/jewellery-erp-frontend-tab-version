// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/complete_booking/view_model/complete_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class CompleteBookingDialog extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  CompleteBookingDialog({super.key, required this.bookingId});

  final String bookingId;
  late final CompleteBookingController controller;
  @override
  Widget build(BuildContext context) {
    controller = Get.put(CompleteBookingController(bookingId: bookingId));
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
        ),
        width: Get.width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderPopup(context),
            Expanded(child: _buildBodyPopup(context)),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderPopup(BuildContext context) {
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
            text: 'Complete Advance Booking',
            fontSize: 16,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: redTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPopup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const CustomText(
            text: 'Completion Date',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          InkWell(
            onTap: () => controller.selectDate(context),
            child: SizedBox(
              width: Get.width * 0.2,
              child: AbsorbPointer(
                child: CustomTextField(
                  borderColor: grey1,
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                  controller: controller.completionDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Completion Date missing";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Obx(
            () =>
                controller.errorMessage.isNotEmpty
                    ? Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    )
                    : const SizedBox.shrink(),
          ),
          CustomTextField(
            controller: controller.invoiceController,
            name: "Invoice Number",
            nameColor: blackColor,
            width: Get.width * 0.2,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: Get.width,
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
          Obx(
            () => Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap:
                    controller.isLoading.value
                        ? null
                        : controller.saveBookingCompletion,
                child: Ink(
                  height: 38,
                  width: 140,
                  decoration: BoxDecoration(
                    color:
                        controller.isLoading.value
                            ? primaryColor.withOpacity(0.7)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.isLoading.value)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      else
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
          ),
        ],
      ),
    );
  }
}
