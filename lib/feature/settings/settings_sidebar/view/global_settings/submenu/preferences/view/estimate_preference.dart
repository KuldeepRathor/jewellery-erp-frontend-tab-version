import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/view_model/estimate_preference_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class EstimatePreference extends StatefulWidget {
  const EstimatePreference({super.key});

  @override
  State<EstimatePreference> createState() => _EstimatePreferenceState();
}

class _EstimatePreferenceState extends State<EstimatePreference> {
  late final EstimatePreferenceController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EstimatePreferenceController());
  }

  @override
  void dispose() {
    Get.delete<EstimatePreferenceController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with title
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Estimate Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add Sales Person Details
                        _buildToggleRow(
                          'Add Sales Person Details',
                          controller.addSalesPerson,
                          () => controller.toggleBoolValue(
                            controller.addSalesPerson,
                          ),
                          'Yes',
                          'No',
                        ),
                        const SizedBox(height: 16),

                        // Reduce in VA/MC first
                        _buildToggleRow(
                          'Reduce in VA/MC first',
                          controller.reduceInVAMC,
                          () => controller.toggleBoolValue(
                            controller.reduceInVAMC,
                          ),
                          'VA',
                          'MC',
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Bottom buttons
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.resetAllFields();
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
                      const SizedBox(width: 8),
                      Obx(
                        () => CustomButton1(
                          buttonName: "Save (Ctrl + S)",
                          onTap:
                              controller.isUpdating.value
                                  ? null
                                  : () =>
                                      controller
                                          .updateEstimatePreference(), // Fixed method name
                          isLoading: controller.isUpdating.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildToggleRow(
    String label,
    RxBool value,
    VoidCallback onToggle,
    String trueText,
    String falseText,
  ) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Obx(
                () => Text(
                  value.value ? trueText : falseText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => CustomToggleSwitch(
                  value: value.value,
                  onChanged: (_) => onToggle(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
