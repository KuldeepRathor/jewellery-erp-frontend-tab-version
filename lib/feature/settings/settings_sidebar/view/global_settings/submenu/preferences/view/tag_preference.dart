import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/view_model/tag_preference_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class TagPreference extends StatefulWidget {
  const TagPreference({super.key});

  @override
  State<TagPreference> createState() => _TagPreferenceState();
}

class _TagPreferenceState extends State<TagPreference> {
  // Controller instance
  late final TagPreferenceController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TagPreferenceController());
  }

  @override
  void dispose() {
    Get.delete<TagPreferenceController>();
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
                      "Tagging Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lot based tagging only
                        _buildToggleRow(
                          'Lot based tagging only',
                          controller.lotBasedTaggingOnly,
                          () => controller.toggleBoolValue(
                            controller.lotBasedTaggingOnly,
                          ),
                          'Yes',
                          'No',
                        ),
                        const SizedBox(height: 20),

                        // Create purchase lot auto
                        _buildToggleRow(
                          'Create purchase lot auto',
                          controller.createPurchaseLotAuto,
                          () => controller.toggleBoolValue(
                            controller.createPurchaseLotAuto,
                          ),
                          'Yes',
                          'No',
                        ),
                        const SizedBox(height: 20),

                        // Create Material in lot auto
                        _buildToggleRow(
                          'Create Material in lot auto',
                          controller.createMaterialInLotAuto,
                          () => controller.toggleBoolValue(
                            controller.createMaterialInLotAuto,
                          ),
                          'Yes',
                          'No',
                        ),
                        const SizedBox(height: 20),

                        // Create Sales Return in lot auto
                        _buildToggleRow(
                          'Create Sales Return in lot auto',
                          controller.createSalesReturnInLotAuto,
                          () => controller.toggleBoolValue(
                            controller.createSalesReturnInLotAuto,
                          ),
                          'Yes',
                          'No',
                        ),
                        const SizedBox(height: 20),

                        // Create Stock diff in lot auto
                        _buildToggleRow(
                          'Create Stock diff in lot auto',
                          controller.createStockDiffInLotAuto,
                          () => controller.toggleBoolValue(
                            controller.createStockDiffInLotAuto,
                          ),
                          'Yes',
                          'No',
                        ),
                        const SizedBox(height: 20),
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
                                  : () => controller.updateTagPreference(),
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
