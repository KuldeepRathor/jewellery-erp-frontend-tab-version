import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view/widgets/approval_receipt_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view/widgets/approval_receipt_party_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view_model/approval_receipt_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view_model/approval_receipt_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view_model/approval_receipt_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg_flutter.dart';

class SubmitApprovalReceiptIntent extends Intent {
  const SubmitApprovalReceiptIntent();
}

class ApprovalReceiptPage extends StatefulWidget {
  const ApprovalReceiptPage({super.key});

  @override
  State<ApprovalReceiptPage> createState() => _ApprovalReceiptPageState();
}

class _ApprovalReceiptPageState extends State<ApprovalReceiptPage> {
  final ApprovalReceiptPartyDetailsController partyDetailsController = Get.put(
    ApprovalReceiptPartyDetailsController(),
  );

  final ApprovalReceiptItemDetailsController approvalItemDetailsController =
      Get.put(ApprovalReceiptItemDetailsController());

  final ApprovalReceiptController controller =
      Get.put<ApprovalReceiptController>(ApprovalReceiptController());

  final FocusNode partyDetailsFocusNode = FocusNode();

  final FocusNode approvalDateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request focus on approval issue dropdown instead of party details
      partyDetailsController.approvalIssueFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    partyDetailsFocusNode.dispose();
    approvalDateFocusNode.dispose();
    partyDetailsController.approvalIssueFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        SubmitApprovalReceiptIntent:
            CallbackAction<SubmitApprovalReceiptIntent>(
              onInvoke: (intent) async {
                await controller.submitApprovalReceiptRecord();
                return null;
              },
            ),
        DiscardIntent: CallbackAction<DiscardIntent>(
          onInvoke: (intent) {
            controller.clearControllers();
            return;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SubmitApprovalReceiptIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
        },
        child: FocusScope(
          autofocus: true,
          child: Scaffold(
            backgroundColor: grey1,
            body: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      header: 'Approval Receipt',
                      wantBackButton: true,
                      onBackButtonTap: () {
                        SidebarController sidebarController = Get.find();
                        sidebarController.popBackSelectedWidget();
                        controller.clearControllers();
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ApprovalReceiptPartyDetailsWidget(
                                      isPurchase: true,
                                      focusNode: partyDetailsFocusNode,
                                      nextFocusNode: approvalDateFocusNode,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const ApprovalReceiptItemDetailsWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FooterWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final SidebarController sidebarController = Get.find();
  final ApprovalReceiptController controller =
      Get.put<ApprovalReceiptController>(ApprovalReceiptController());
  final ApprovalReceiptItemDetailsController itemDetailsController =
      Get.put<ApprovalReceiptItemDetailsController>(
        ApprovalReceiptItemDetailsController(),
      );
  final ApprovalReceiptPartyDetailsController partyDetailsController =
      Get.put<ApprovalReceiptPartyDetailsController>(
        ApprovalReceiptPartyDetailsController(),
      );

  FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                final result = await Get.dialog(
                  AddRemarkDialog(initialTextString: controller.remarks.value),
                );
                if (result != null) {
                  controller.remarks.value = result as String;
                }
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
            SizedBox(width: Get.width * 0.02),
            SingleChildScrollView(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      controller.clearControllers();
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
                        await controller.submitApprovalReceiptRecord();
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
                            CustomText(
                              text: "Next",
                              fontSize: 16,
                              color: whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomText(
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
