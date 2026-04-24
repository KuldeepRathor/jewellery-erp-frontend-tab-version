import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/quick_old_gold/quick_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class QuickOldGoldDialog extends StatelessWidget {
  const QuickOldGoldDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final QuickOldGoldController controller =
        Get.find<QuickOldGoldController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveQuickOldGoldEstimateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveQuickOldGoldEstimateIntent:
                CallbackAction<SaveQuickOldGoldEstimateIntent>(
                  onInvoke: (SaveQuickOldGoldEstimateIntent intent) {
                    controller.handleDone();
                    return;
                  },
                ),
          },
          child: Container(
            height: Get.height * .65,
            width: Get.width * .5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: controller.quickOldGoldFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Expanded(child: _buildOldGoldForm(controller)),
                  _buildFooter(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
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
            text: 'Add Old Gold',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildOldGoldForm(QuickOldGoldController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Old Gold Details",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  autofocus: true,
                  controller: controller.estimateNumberController,
                  name: 'Estimate Number',
                  width: Get.width * .2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Estimate details';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  const CustomText(text: ""),
                  Obx(
                    () => CustomButton1(
                      buttonName: 'Fetch Details',
                      isLoading:
                          controller.getQuickOldGoldResponse.value.status ==
                          Status.LOADING,
                      onTap: controller.fetchQuickOldGold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              final response = controller.getQuickOldGoldResponse.value;

              switch (response.status) {
                case Status.LOADING:
                  return const Center(child: CircularProgressIndicator());

                case Status.COMPLETED:
                  if (response.data?.values == null ||
                      response.data!.values!.isEmpty) {
                    return const Center(child: Text('No old gold items found'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CustomText(
                            text: "Found Items:",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: controller.selectAllItems,
                            child: const Text('Select All'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: controller.clearSelection,
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const CustomDashedLineWidget(width: double.infinity),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: response.data!.values!.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = response.data!.values![index];
                            final bool isReceived = controller.isItemReceived(
                              index,
                            );

                            return Obx(
                              () => CheckboxListTile(
                                enableFeedback: true,
                                value: controller.isItemSelected(index),
                                onChanged:
                                    isReceived
                                        ? (bool? value) => controller
                                            .toggleItemSelection(index)
                                        : null,
                                title: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        isReceived
                                            ? Colors.grey[50]
                                            : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          isReceived
                                              ? Colors.transparent
                                              : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.description ??
                                                  'No description',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color:
                                                    isReceived
                                                        ? Colors.black
                                                        : Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  'Code: ${item.code ?? 'N/A'}',
                                                  style: TextStyle(
                                                    color:
                                                        isReceived
                                                            ? Colors.grey
                                                            : Colors.grey[400],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isReceived
                                                            ? Colors.green[100]
                                                            : Colors
                                                                .orange[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    isReceived
                                                        ? 'Received'
                                                        : 'Not Received',
                                                    style: TextStyle(
                                                      color:
                                                          isReceived
                                                              ? Colors
                                                                  .green[800]
                                                              : Colors
                                                                  .orange[800],
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Net Wt: ${item.netWeight ?? '0'} g',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                isReceived
                                                    ? Colors.black87
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Purity: ${item.purityType ?? 'N/A'}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                isReceived
                                                    ? Colors.black87
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Amount: ${item.amount ?? '0'}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                isReceived
                                                    ? Colors.black87
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                enabled: isReceived,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );

                case Status.ERROR:
                  return Center(
                    child: Text(
                      response.message ?? 'Error occurred',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );

                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(QuickOldGoldController controller) {
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
            onTap: controller.handleDone,
            child: Container(
              width: 120,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Obx(
                  () =>
                      controller.getQuickOldGoldResponse.value.status ==
                              Status.LOADING
                          ? const CircularProgressIndicator(color: whiteColor)
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Done",
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: " (ctrl + s)",
                                color: whiteColor,
                                fontStyle: FontStyle.italic,
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
