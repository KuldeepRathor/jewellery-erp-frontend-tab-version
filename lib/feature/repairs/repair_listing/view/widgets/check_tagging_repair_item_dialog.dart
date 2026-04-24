import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view_model/repair_status_controlller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class CheckTaggingRepairItemDialog extends StatelessWidget {
  final String repairId;
  final String status;

  const CheckTaggingRepairItemDialog({
    super.key,
    required this.repairId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final RepairStatusController controller = Get.put<RepairStatusController>(
      RepairStatusController(initialStatus: status, repairId: repairId),
    );

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
                    return;
                  },
                ),
          },
          child: Focus(
            autofocus: true,
            child: Container(
              height: Get.height * .45,
              width: Get.width * .4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildAssignedToForm(controller)),
                    _buildFooter(controller),
                  ],
                ),
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
            text: 'Verify Tagging Line Item',
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

  Widget _buildAssignedToForm(RepairStatusController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomTextField(
                  width: Get.width * 0.1,
                  name: "Code",
                  controller: controller.tagNoController,
                ),
                const SizedBox(width: 8),
                CustomTextField(
                  width: Get.width * 0.1,
                  name: "Tag No",
                  controller: controller.codeController,
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    const SizedBox(height: 24),
                    Obx(
                      () => CustomButton1(
                        buttonName: "Fetch Details",
                        onTap:
                            controller.isLoadingTagging.value
                                ? null
                                : controller.fetchTaggingDetails,
                        isLoading: controller.isLoadingTagging.value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display tagging details
            Obx(() {
              final details = controller.taggingDetails.value;
              if (details == null) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    'Tag Number:',
                    details.tagNumber?.toString() ?? 'N/A',
                  ),
                  _buildDetailRow('Code:', details.code ?? 'N/A'),
                  _buildDetailRow(
                    'Pieces:',
                    details.pieces?.toString() ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Gross Weight:',
                    details.grossWeight ?? 'N/A',
                  ),
                  _buildDetailRow('Net Weight:', details.netWeight ?? 'N/A'),
                  _buildDetailRow('Purity:', details.purity ?? 'N/A'),
                  if (details.design != null)
                    _buildDetailRow('Design:', details.design?.name ?? 'N/A'),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          CustomText(
            text: label,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 8),
          CustomText(text: value, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildFooter(RepairStatusController controller) {
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
          Obx(
            () => InkWell(
              onTap:
                  controller.isLoading.value
                      ? null
                      : controller.updateStatusWithTagging,
              child: Container(
                width: 120,
                height: 38,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child:
                      controller.isLoading.value
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
