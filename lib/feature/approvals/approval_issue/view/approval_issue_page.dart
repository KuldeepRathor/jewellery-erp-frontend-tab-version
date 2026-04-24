import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view/widgets/animated_issue_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view/widgets/approval_issue_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view/widgets/approval_issue_party_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view/widgets/approval_issue_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view_model/approval_issue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view_model/approval_issue_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view_model/approval_issue_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

class SubmitApprovalIssueIntent extends Intent {
  const SubmitApprovalIssueIntent();
}

class ApprovalIssuePage extends StatefulWidget {
  const ApprovalIssuePage({super.key});

  @override
  State<ApprovalIssuePage> createState() => _ApprovalIssuePageState();
}

class _ApprovalIssuePageState extends State<ApprovalIssuePage> {
  final PartyDetailsController partyDetailsController = Get.put(
    PartyDetailsController(),
  );
  final ApprovalIssueDetailsController issueDetailsController = Get.put(
    ApprovalIssueDetailsController(),
  );
  final ApprovalIssueItemDetailsController approvalItemDetailsController =
      Get.put(ApprovalIssueItemDetailsController());
  final ApprovalIssueController _approvalIssueController = Get.put(
    ApprovalIssueController(),
  );
  final FocusNode partyDetailsFocusNode = FocusNode();
  final FocusNode vendorBillDetailsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _approvalIssueController.clearControllers();
    partyDetailsController.clearControllers();
    issueDetailsController.clearControllers();
    approvalItemDetailsController.clearControllers();

    issueDetailsController.fetchApprovalIssueNumber();
    issueDetailsController.setDefaultDate();
    _approvalIssueController.searchEmployees('');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      partyDetailsFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    partyDetailsFocusNode.dispose();
    vendorBillDetailsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        SubmitApprovalIssueIntent: CallbackAction<SubmitApprovalIssueIntent>(
          onInvoke: (intent) async {
            await _approvalIssueController.submitApprovalIssueRecord();
            return null;
          },
        ),
        DiscardIntent: CallbackAction<DiscardIntent>(
          onInvoke: (intent) {
            _approvalIssueController.clearControllers();
            return;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SubmitApprovalIssueIntent(),
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
                      header: 'Approval Issue',
                      wantBackButton: true,
                      onBackButtonTap: () {
                        _approvalIssueController.clearControllers();
                        partyDetailsController.clearControllers();
                        issueDetailsController.clearControllers();
                        approvalItemDetailsController.clearControllers();

                        // Navigate back
                        SidebarController sidebarController = Get.find();
                        sidebarController.popBackSelectedWidget();
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
                                    flex: 3,
                                    child: ApprovalIssuePartyDetailsWidget(
                                      isPurchase: true,
                                      focusNode: partyDetailsFocusNode,
                                      nextFocusNode:
                                          _approvalIssueController
                                              .approverDropdownFocusNode,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    flex: 2,
                                    child: ApprovalIssueDetailsWidget(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const ApprovalIssueItemDetailsWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FooterWidget(),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(
                    () => AnimatedIssueItemDetailsWidget(
                      isVisible:
                          approvalItemDetailsController
                              .isItemDetailsVisible
                              .value,
                      onClose:
                          () => approvalItemDetailsController.hideItemDetails(),
                    ),
                  ),
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
  final ApprovalIssueController _approvalIssueController = Get.put(
    ApprovalIssueController(),
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
                  AddRemarkDialog(
                    initialTextString: _approvalIssueController.remarks.value,
                  ),
                );
                if (result != null) {
                  _approvalIssueController.remarks.value = result;
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
                      _approvalIssueController.clearControllers();
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
                        _approvalIssueController.submitApprovalIssueRecord();
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
