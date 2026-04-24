import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/get_jewellery_plan_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/jewellery_plan/jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class JewelleryPlanDialog extends StatefulWidget {
  const JewelleryPlanDialog({super.key});

  @override
  State<JewelleryPlanDialog> createState() => _JewelleryPlanDialogState();
}

class _JewelleryPlanDialogState extends State<JewelleryPlanDialog> {
  final JewelleryPlanController controller =
      Get.find<JewelleryPlanController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const SaveJewelleryPlanIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              SaveJewelleryPlanIntent: CallbackAction<SaveJewelleryPlanIntent>(
                onInvoke: (SaveJewelleryPlanIntent intent) {
                  controller.submitBooking();
                  return null;
                },
              ),
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildBody()),
                    _buildFooter(),
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
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Add Jewellery Plans',
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () {
              Get.back();
              controller.clearControllers();
            },
            icon: const Icon(Icons.close, color: Colors.red, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSearchSection(),
            const SizedBox(height: 24),
            _buildFetchedPlanDetails(),
            const SizedBox(height: 24),
            _buildSelectedPlans(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Search Plan",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                autofocus: true,
                controller: controller.bookingDetailsController,
                // name: 'Plan ID/ Customer name/ Phone number',
                name: 'Plan ID',
                validator: (value) {
                  if (controller.selectedJewelleryPlans.isEmpty) {
                    return 'Please add at least one plan';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  width: 120,
                  child: Obx(
                    () => CustomButton1(
                      buttonName: 'Fetch Details',
                      isLoading: controller.isFetchingDetails.value,
                      onTap: controller.fetchJewelleryPlan,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFetchedPlanDetails() {
    return Obx(
      () => Visibility(
        visible:
            controller.getJewelleryPlanResponse.value.status ==
            Status.COMPLETED,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomDashedLineWidget(width: double.infinity),
            const SizedBox(height: 24),
            const CustomText(
              text: "Fetched Plan Details",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 16),
            Obx(
              () => _buildPlanDetailsCard(
                controller.getJewelleryPlanResponse.value,
                showAddButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const CustomDashedLineWidget(width: double.infinity),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPlans() {
    return Obx(
      () => Visibility(
        visible: controller.selectedJewelleryPlans.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Selected Plans",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text:
                        "Total Redeemable: ₹${controller.totalRedeemableAmount.value.toStringAsFixed(2)}",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children:
                  controller.selectedJewelleryPlans.map((plan) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSelectedPlanCard(plan),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPlanCard(JewelleryPlanResponse plan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildPlanDetails(plan)),
          IconButton(
            onPressed: () => controller.removeJewelleryPlan(plan),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetails(JewelleryPlanResponse plan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailColumn('Plan ID', plan.code ?? ''),
        _buildDetailColumn('Plan Name', plan.planName ?? ''),
        _buildDetailColumn('Type', plan.type ?? ""),
        _buildDetailColumn('Amount', '₹ ${plan.amount ?? ""}'),
        // _buildDetailColumn('Start Date', convertDateTimeToString(plan.sDate)),
        _buildDetailColumn('Start Date', (plan.startDate ?? "")),
        _buildDetailColumn('Duration', '${plan.planDuration}'),
        _buildDetailColumn('Installments', '${plan.installments}'),
        _buildDetailColumn('Total Weight', '${plan.totalWeight}'),
        _buildDetailColumn(
          'Redeemable Amount',
          plan.redeemableAmount?.toStringAsFixed(3) ?? "0",
        ),
      ],
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return SizedBox(
      // width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 4),
          CustomText(text: value, fontSize: 15, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _buildPlanDetailsCard(
    ApiResponse<JewelleryPlanResponse> response, {
    bool showAddButton = false,
  }) {
    switch (response.status) {
      case Status.LOADING:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        );

      case Status.ERROR:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  response.message ?? 'Error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

      case Status.COMPLETED:
        final plan = response.data;
        if (plan == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPlanDetails(plan)),
              if (showAddButton)
                CustomInkButton(
                  width: 120,
                  onPressed: () {
                    controller.addJewelleryPlan();
                  },
                  text: "+ Add",
                  backgroundColor: Colors.transparent,
                  textColor: primaryColor,
                  focusColor: Colors.blue.withOpacity(0.3),
                ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 140,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.submitBooking();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Obx(
                () =>
                    controller.isLoading.value
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                            strokeWidth: 2,
                          ),
                        )
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
                              fontSize: 12,
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
}
