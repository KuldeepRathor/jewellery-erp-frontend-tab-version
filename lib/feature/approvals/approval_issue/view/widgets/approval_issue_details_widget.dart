import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view_model/approval_issue_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_calendar.dart';

class ApprovalIssueDetailsWidget extends StatefulWidget {
  const ApprovalIssueDetailsWidget({super.key});

  @override
  State<ApprovalIssueDetailsWidget> createState() =>
      _ApprovalIssueDetailsWidgetState();
}

class _ApprovalIssueDetailsWidgetState
    extends State<ApprovalIssueDetailsWidget> {
  final ApprovalIssueDetailsController controller =
      Get.find<ApprovalIssueDetailsController>();
  @override
  void initState() {
    super.initState();
    controller.setDefaultDate();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: onNormalKeyEvent,
      canRequestFocus: false,
      child: Form(
        key: controller.formKey,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Issue Details',
                        color: blackColor,
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Approval Issue Number",
                              color: primaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(height: 4),
                            Obx(
                              () => Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  border: Border.all(color: grey1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      CustomText(
                                        text:
                                            controller
                                                .approvalIssueNumber
                                                .value,
                                        fontSize: 16,
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w500,
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
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomDateField(
                          controller: controller.approvalDateController,
                          labelText: "Approval Date",
                          onTap:
                              (context) => controller.selectDate(
                                context,
                                controller.approvalDateController,
                              ),
                        ),
                      ),
                      // Expanded(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       const CustomText(
                      //         text: "Approval Date",
                      //         color: primaryTextColor,
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //       InkWell(
                      //         onTap: () => controller.selectDate(context),
                      //         child: Obx(() => AbsorbPointer(
                      //               child: CustomTextField(
                      //                 borderColor: grey1,
                      //                 suffixIcon: const Icon(
                      //                     Icons.calendar_month_outlined),
                      //                 controller: TextEditingController(
                      //                     text: controller.approvalDate.value),
                      //                 validator: (value) {
                      //                   if (value == null || value.isEmpty) {
                      //                     return "Approval Date missing";
                      //                   }
                      //                   return null;
                      //                 },
                      //               ),
                      //             )),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
