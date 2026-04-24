import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';

class HoldItemsFooterWidget extends StatelessWidget {
  const HoldItemsFooterWidget({
    super.key,
    required this.totalPriceValue,
    required this.onPrimaryBtnTap,
    required this.primaryBtnText,
    required this.onDiscardTap,
    required this.initialRemarksString,
    required this.onRemarksAdded,
    required this.onRemarksDiscarded,
  });
  final String totalPriceValue;
  final String primaryBtnText;
  final void Function()? onPrimaryBtnTap;
  final void Function()? onDiscardTap;
  final void Function(String remark)? onRemarksAdded;
  final void Function()? onRemarksDiscarded;
  final String initialRemarksString;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () async {
                  String? remarks = await Get.dialog(
                    AddRemarkDialog(initialTextString: initialRemarksString),
                  );
                  if (remarks != null) {
                    onRemarksAdded!(remarks);
                  } else {
                    onRemarksDiscarded!();
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined, color: primaryColor),
                    SizedBox(width: 6),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CustomText(
                  text: 'Total Balance:',
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                GetBuilder<SalesPaymentDetailsController>(
                  builder: (controller) {
                    String balanceAmount =
                        controller.balanceAmountController.text;
                    String amountToDisplay = balanceAmount;

                    return CustomText(
                      text: '₹ $amountToDisplay',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    );
                  },
                ),
              ],
            ),
            SizedBox(width: Get.width * 0.02),
            SingleChildScrollView(
              child: Row(
                children: [
                  InkWell(
                    // onTap: () {
                    //   Get.dialog(AttentionDialog());
                    //   // itemDetailsController.clearControllers();
                    // },
                    onTap: onDiscardTap,
                    child: Container(
                      height: 38,
                      width: 140,
                      // width: Get.width * 0.045,
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

                      // onTap: () async {
                      //   bool value = itemDetailsController.validateRow();
                      //   if (value == true) {
                      //     Get.dialog(const PaymentDetailsDialog());
                      //   }
                      // },
                      onTap: onPrimaryBtnTap,
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
                            CustomText(
                              text: primaryBtnText,
                              fontSize: 16,
                              color: whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                            const CustomText(
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
