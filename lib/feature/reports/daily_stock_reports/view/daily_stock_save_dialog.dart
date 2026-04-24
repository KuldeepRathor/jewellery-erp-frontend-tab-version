import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/model/daily_stock_report_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/view_model/daily_stock_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddSaveIntent extends Intent {
  const AddSaveIntent();
}

class DailyStockSaveDialog extends GetView<DailyStockReportViewModel> {
  final DailyStockResponseModel dailyStockResponseModel;
  const DailyStockSaveDialog({
    required this.dailyStockResponseModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: !controller.sunbmittedSuccess.value,
        replacement: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: SizedBox(
            height: Get.height * .25,
            width: Get.width * .3,
            child: successWidget(),
          ),
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.keyS,
                  ):
                  const AddSaveIntent(),
            },
            child: Actions(
              actions: {
                AddSaveIntent: CallbackAction<AddSaveIntent>(
                  onInvoke: (intent) {
                    controller.submitDailyStock(dailyStockResponseModel);
                    return null;
                  },
                ),
              },
              child: FocusScope(
                autofocus: true,
                onKeyEvent: onNormalKeyEvent,
                child: Obx(
                  () =>
                      controller.isSubmitDailyStockLoading.value
                          ? SizedBox(
                            height: Get.height * .6,
                            width: Get.width * .3,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                          : Container(
                            height: Get.height * .6,
                            width: Get.width * .3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildHeader(controller),
                                  (controller.sunbmittedSuccess.value)
                                      ? successWidget()
                                      : _buildSettingsForm(controller),
                                  if (!controller.sunbmittedSuccess.value)
                                    _buildFooter(controller),
                                ],
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Expanded _buildSettingsForm(DailyStockReportViewModel controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CustomText(
                  text: "Counter Name - ",
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  text: "${dailyStockResponseModel.counterName}",
                  fontSize: 14,
                  color: primaryColor,
                  fontFamily: 'Satoshi',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const CustomDashedLineWidget(width: double.infinity),
            SizedBox(height: Get.height * 0.02),
            const Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Stock Head",
                    fontSize: 14,
                    fontFamily: 'Satoshi',
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Count",
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: "                  \t",
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 8),
              child: CustomDashedLineWidget(width: double.infinity),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dailyStockResponseModel.totalItems ?? 0,
                itemBuilder: (context, index) {
                  final stockHead = dailyStockResponseModel.stockHeads![index];

                  return Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: stockHead.name ?? 'No Name',
                                  fontSize: 14,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: CustomTextField(
                                  width: Get.width * 0.3,
                                  autofocus: index == 0 ? true : false,
                                  controller:
                                      controller
                                          .controllers[index]
                                          .counterNumber,
                                  hintText: "Enter count",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const CustomDashedLineWidget(width: double.infinity),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DailyStockReportViewModel controller) {
    return Container(
      height: 64,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: grey2,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 0.0),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: 'Stock Heads ',
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(DailyStockReportViewModel controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              controller.submitDailyStock(dailyStockResponseModel);
            },
            child: Container(
              width: 120,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonShortcutWidget(
                      buttonName: "Save",
                      shortcut: "Ctrl + S",
                      color: whiteColor,
                      shortcutButtonColor: primaryColor,
                      shortcutButtonBackgroundColor: grey1,
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

  Widget successWidget() {
    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        fit: StackFit.loose,
        children: [
          Positioned(
            top: -19,
            right: -14,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: redTextColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const CustomText(text: ' X ', color: whiteColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: greenColor, width: 5),
                  ),
                  child: const Icon(Icons.check, color: greenColor, size: 75),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Stock head count has been sent for Verification successfully!',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Center the text
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
