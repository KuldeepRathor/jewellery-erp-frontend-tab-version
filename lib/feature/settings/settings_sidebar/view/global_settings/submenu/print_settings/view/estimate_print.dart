import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/view/estimate_dummy_print.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/view_model/estimate_print_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class EstimatePrint extends StatefulWidget {
  const EstimatePrint({super.key});

  @override
  State<EstimatePrint> createState() => _EstimatePrintState();
}

class _EstimatePrintState extends State<EstimatePrint> {
  // Controller instance
  late final EstimatePrintController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EstimatePrintController());
  }

  @override
  void dispose() {
    Get.delete<EstimatePrintController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
              // Top row with title and print button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Estimate Template Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  CustomButton1(
                    buttonName: "Print Sample",
                    onTap: () {
                      generateThermalReceipt();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const CustomDashedLineWidget(width: double.infinity),
              const SizedBox(height: 16),

              // Content area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show % VA in
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'Show % VA in',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Obx(
                              () => Row(
                                children: [
                                  _buildRadioOption(
                                    'percentage',
                                    '%',
                                    controller.showVAPercentage.value,
                                    (val) => controller.setVAPercentageType(
                                      'percentage',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildRadioOption(
                                    'grams',
                                    'Grams',
                                    controller.showVAPercentage.value,
                                    (val) =>
                                        controller.setVAPercentageType('grams'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildRadioOption(
                                    'both',
                                    'Both',
                                    controller.showVAPercentage.value,
                                    (val) =>
                                        controller.setVAPercentageType('both'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildRadioOption(
                                    'amount',
                                    'Amount',
                                    controller.showVAPercentage.value,
                                    (val) => controller.setVAPercentageType(
                                      'amount',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildRadioOption(
                                    'none',
                                    'None',
                                    controller.showVAPercentage.value,
                                    (val) =>
                                        controller.setVAPercentageType('none'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Show gms VA in
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'Show gms VA in',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Obx(
                              () => Row(
                                children: [
                                  _buildRadioOption(
                                    'percentage',
                                    '%',
                                    controller.showVAGrams.value,
                                    (val) =>
                                        controller.setVAGramsType('percentage'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildRadioOption(
                                    'grams',
                                    'Grams',
                                    controller.showVAGrams.value,
                                    (val) => controller.setVAGramsType('grams'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildRadioOption(
                                    'both',
                                    'Both',
                                    controller.showVAGrams.value,
                                    (val) => controller.setVAGramsType('both'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildRadioOption(
                                    'amount',
                                    'Amount',
                                    controller.showVAGrams.value,
                                    (val) =>
                                        controller.setVAGramsType('amount'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildRadioOption(
                                    'none',
                                    'None',
                                    controller.showVAGrams.value,
                                    (val) => controller.setVAGramsType('none'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Show MC total sum
                      _buildToggleRow(
                        'Show MC total sum',
                        controller.showMCTotalSum,
                        () => controller.toggleBoolValue(
                          controller.showMCTotalSum,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Show Vendor Code
                      _buildToggleRow(
                        'Show Vendor Code',
                        controller.showVendorCode,
                        () => controller.toggleBoolValue(
                          controller.showVendorCode,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Show Stock Age
                      _buildToggleRow(
                        'Show Stock Age',
                        controller.showStockAge,
                        () =>
                            controller.toggleBoolValue(controller.showStockAge),
                      ),
                      const SizedBox(height: 16),

                      // Show Rate Valid Till
                      _buildToggleRow(
                        'Show Rate Valid Till',
                        controller.showRateValidTill,
                        () => controller.toggleBoolValue(
                          controller.showRateValidTill,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildToggleRow(
                        'Show Emp Code',
                        controller.showEmpCode,
                        () =>
                            controller.toggleBoolValue(controller.showEmpCode),
                      ),
                      const SizedBox(height: 24),

                      const CustomDashedLineWidget(width: double.infinity),
                      const SizedBox(height: 16),

                      // Show Additional Message
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          const Text(
                            'Show Additional Message',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => CustomToggleSwitch(
                              value: controller.showAdditionalMessage.value,
                              onChanged:
                                  (_) => controller.toggleBoolValue(
                                    controller.showAdditionalMessage,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Additional Message Text Field
                      Obx(
                        () => Visibility(
                          visible: controller.showAdditionalMessage.value,
                          child: TextField(
                            controller: controller.additionalMessageController,
                            focusNode: controller.additionalMessageFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Enter additional message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6E8FF),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            maxLines: 5,
                          ),
                        ),
                      ),
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
                                    controller.updateEstimatePrintTemplate(),
                        isLoading: controller.isUpdating.value,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a toggle row
  Widget _buildToggleRow(String label, RxBool value, VoidCallback onToggle) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          flex: 8,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Obx(
          () => Text(
            value.value ? 'Yes' : 'No',
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
    );
  }

  // Helper method to build a radio option
  Widget _buildRadioOption(
    String value,
    String label,
    String groupValue,
    Function(String?) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
