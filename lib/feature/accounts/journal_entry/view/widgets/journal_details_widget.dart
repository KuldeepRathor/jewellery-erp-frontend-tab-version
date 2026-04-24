import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view/widgets/posting_date_field_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view_model/journal_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class JournalDetailsWidget extends StatelessWidget {
  JournalDetailsWidget({super.key});
  final JournalViewModel journalViewModel = Get.find<JournalViewModel>();

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
        child: Form(
          key: journalViewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: "Entry Details",
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      PostingDateField(journalViewModel: journalViewModel),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(color: grey2, height: 60, width: 2),
                      ),
                      CustomTextField(
                        name: "Enter Reference",
                        width: 250,
                        controller: journalViewModel.referenceTextController,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Enter Reference";
                        //   }
                        //   return null;
                        // },
                      ),
                    ],
                  ),

                  // mode estimate number
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(color: grey2, height: 60, width: 2),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CustomText(
                            text: "Voucher Number:",
                            fontSize: 12,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => Row(
                              children: [
                                CustomText(
                                  text: journalViewModel.voucherNumber.value,
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
            ],
          ),
        ),
      ),
    );
  }
}
