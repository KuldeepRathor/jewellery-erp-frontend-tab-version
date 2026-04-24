// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view/widgets/animated_stock_issue_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view/widgets/stock_issue_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view/widgets/stock_issue_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/add_stock_issue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/stock_issue_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/stock_issue_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

// Define the intents for keyboard shortcuts
class SubmitStockIssueIntent extends Intent {
  const SubmitStockIssueIntent();
}

class DiscardStockIssueIntent extends Intent {
  const DiscardStockIssueIntent();
}

class AddStockIssuePage extends StatefulWidget {
  const AddStockIssuePage({super.key});

  @override
  State<AddStockIssuePage> createState() => _AddStockIssuePageState();
}

class _AddStockIssuePageState extends State<AddStockIssuePage> {
  final StockIssueDetailsController issueDetailsController = Get.put(
    StockIssueDetailsController(),
  );
  final StockIssueItemDetailsController stockIssueItemDetailsController =
      Get.put(StockIssueItemDetailsController());
  final AddStockIssueController addStockIssueController = Get.put(
    AddStockIssueController(),
  );

  final FocusNode approvalFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus after the widget is built
    issueDetailsController.fetchStockIssueNumber();
    issueDetailsController.searchEmployees('');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      approvalFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    approvalFocusNode.dispose();
    addStockIssueController.clearControllers();
    super.dispose();
  }

  void _handleDiscard() {
    addStockIssueController.clearControllers();
    issueDetailsController.fetchStockIssueNumber();
    SidebarController sidebarController = Get.find();
    sidebarController.popBackSelectedWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SubmitStockIssueIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardStockIssueIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SubmitStockIssueIntent: CallbackAction<SubmitStockIssueIntent>(
              onInvoke: (intent) async {
                await addStockIssueController.submitStockIssueRecord();
                return null;
              },
            ),
            DiscardStockIssueIntent: CallbackAction<DiscardStockIssueIntent>(
              onInvoke: (intent) {
                _handleDiscard();
                return null;
              },
            ),
          },
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
                      header: 'New Issue',
                      wantBackButton: true,
                      onBackButtonTap: () {
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
                                    child: StockIssueDetailsWidget(
                                      focusNode: approvalFocusNode,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const StockIssueItemDetailsWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FooterWidget(
                      onDiscard: _handleDiscard,
                      onSubmit:
                          () =>
                              addStockIssueController.submitStockIssueRecord(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(
                    () => AnimatedStockIssueItemDetailsWidget(
                      isVisible:
                          stockIssueItemDetailsController
                              .isItemDetailsVisible
                              .value,
                      onClose:
                          () =>
                              stockIssueItemDetailsController.hideItemDetails(),
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
  final Function onDiscard;
  final Function onSubmit;
  final SidebarController sidebarController = Get.find();

  FooterWidget({super.key, required this.onDiscard, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final AddStockIssueController addStockIssueController = Get.put(
      AddStockIssueController(),
    );
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
                    initialTextString: addStockIssueController.remarks.value,
                  ),
                );
                if (result != null) {
                  addStockIssueController.remarks.value = result;
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
                    onTap: () => onDiscard(),
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
                          CustomText(
                            text: "Discard",
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          // CustomText(
                          //   text: " (ctrl + d)",
                          //   fontSize: 16,
                          //   color: primaryColor,
                          //   fontStyle: FontStyle.italic,
                          //   fontWeight: FontWeight.w400,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.01),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => onSubmit(),
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
                              text: "Save",
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
