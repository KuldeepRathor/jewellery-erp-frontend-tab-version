import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view/counter_transfer_item_details.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view/widgets/counter_transfer_header.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view_model/counter_transfer_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view_model/counter_transfer_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

class CounterTransfer extends StatefulWidget {
  const CounterTransfer({super.key});

  @override
  State<CounterTransfer> createState() => _CounterTransferState();
}

class _CounterTransferState extends State<CounterTransfer> {
  final CounterTransferItemDetailsController controller =
      Get.put<CounterTransferItemDetailsController>(
        CounterTransferItemDetailsController(),
      );
  final CounterTransferController counterTransferController = Get.put(
    CounterTransferController(),
  );
  final SidebarController sidebarController = Get.find();
  @override
  void initState() {
    super.initState();
    counterTransferController.searchCounters("");
    counterTransferController.searchEmployees("");
    controller.getCodeList();
  }

  @override
  void dispose() {
    counterTransferController.resetValues();
    controller.clearForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Actions(
        actions: <Type, Action<Intent>>{
          SaveCounterTransferIntent: CallbackAction<SaveCounterTransferIntent>(
            onInvoke: (SaveCounterTransferIntent intent) async {
              controller.controllers.removeWhere(
                (element) => element.existingTagNumber.text.isEmpty,
              );
              await Future.delayed(const Duration(milliseconds: 100));

              if (controller.formKey.currentState?.validate() ?? false) {
                await controller.submitCounterTransfer();
              }
              return null;
            },
          ),
          DiscardIntent: CallbackAction<DiscardIntent>(
            onInvoke: (intent) {
              controller.clearForm();
              sidebarController.popBackSelectedWidget();
              return;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const SaveCounterTransferIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
                const DiscardIntent(),
          },
          child: FocusScope(
            autofocus: true,
            child: Stack(
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
                      header: 'Counter Tranfer',
                      wantBackButton: true,
                      onBackButtonTap: () {
                        SidebarController sidebarController = Get.find();
                        sidebarController.popBackSelectedWidget();
                      },
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CounterTransferHeader(),
                            SizedBox(height: 16),
                            Expanded(child: CounterTransferItemDetails()),
                          ],
                        ),
                      ),
                    ),
                    FooterWidget(controller),
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
  final CounterTransferItemDetailsController controller; // Add this

  FooterWidget(this.controller, {super.key}); // Fix constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.01,
          vertical: Get.height * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            SizedBox(width: Get.width * 0.02),
            SingleChildScrollView(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      controller.clearForm();
                      sidebarController.popBackSelectedWidget();
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
                        controller.controllers.removeWhere(
                          (element) => element.existingTagNumber.text.isEmpty,
                        );
                        await Future.delayed(const Duration(milliseconds: 100));
                        if (controller.formKey.currentState?.validate() ??
                            false) {
                          await controller.submitCounterTransfer();
                        }
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
