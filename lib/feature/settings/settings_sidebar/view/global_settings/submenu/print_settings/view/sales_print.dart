import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/view_model/sales_print_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class SalesInvoicePrint extends StatefulWidget {
  const SalesInvoicePrint({super.key});

  @override
  State<SalesInvoicePrint> createState() => _SalesInvoicePrintState();
}

class _SalesInvoicePrintState extends State<SalesInvoicePrint> {
  // Controller instance
  late final SalesInvoicePrintController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SalesInvoicePrintController());
  }

  @override
  void dispose() {
    Get.delete<SalesInvoicePrintController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
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
                // Top row with title and print button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sales Invoice Template Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Obx(
                      () =>
                          controller.hasError.value
                              ? TextButton.icon(
                                onPressed:
                                    () =>
                                        controller
                                            .getSalesInvoicePrintTemplateData(),
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Retry',
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                              : const CustomButton1(buttonName: "Print Sample"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const CustomDashedLineWidget(width: double.infinity),
                const SizedBox(height: 16),

                // Error message if loading failed
                Obx(
                  () =>
                      controller.hasError.value
                          ? Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Error loading template',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Using default values. You can edit and save, or try reloading.',
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                                if (controller
                                    .errorMessage
                                    .value
                                    .isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Details: ${controller.errorMessage.value}',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                          : const SizedBox.shrink(),
                ),

                // Content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column - Show Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Template Selection
                              _buildSectionTitle("Choose Template"),
                              const SizedBox(height: 16),

                              // Template selection row
                              Row(
                                children: [
                                  Obx(() => _buildTemplateOption(1)),
                                  const SizedBox(width: 16),
                                  Obx(() => _buildTemplateOption(2)),
                                  const SizedBox(width: 16),
                                  Obx(() => _buildTemplateOption(3)),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Show Details Section
                              _buildSectionTitle("Show Details"),
                              const SizedBox(height: 16),

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
                                            (val) =>
                                                controller.setVAPercentageType(
                                                  'percentage',
                                                ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRadioOption(
                                            'grams',
                                            'Grams',
                                            controller.showVAPercentage.value,
                                            (val) => controller
                                                .setVAPercentageType('grams'),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRadioOption(
                                            'both',
                                            'Both',
                                            controller.showVAPercentage.value,
                                            (val) => controller
                                                .setVAPercentageType('both'),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRadioOption(
                                            'amount',
                                            'Amount',
                                            controller.showVAPercentage.value,
                                            (val) => controller
                                                .setVAPercentageType('amount'),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRadioOption(
                                            'none',
                                            'None',
                                            controller.showVAPercentage.value,
                                            (val) => controller
                                                .setVAPercentageType('none'),
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
                                            (val) => controller.setVAGramsType(
                                              'percentage',
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRadioOption(
                                            'grams',
                                            'Grams',
                                            controller.showVAGrams.value,
                                            (val) => controller.setVAGramsType(
                                              'grams',
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRadioOption(
                                            'both',
                                            'Both',
                                            controller.showVAGrams.value,
                                            (val) => controller.setVAGramsType(
                                              'both',
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRadioOption(
                                            'amount',
                                            'Amount',
                                            controller.showVAGrams.value,
                                            (val) => controller.setVAGramsType(
                                              'amount',
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRadioOption(
                                            'none',
                                            'None',
                                            controller.showVAGrams.value,
                                            (val) => controller.setVAGramsType(
                                              'none',
                                            ),
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

                              // Number of print copies for PAN Invoice
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    flex: 6,
                                    child: Text(
                                      'No. of print copies for PAN Invoice',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 70,
                                    child: Obx(
                                      () => TextField(
                                        controller: TextEditingController(
                                          text:
                                              controller.panCopies.value
                                                  .toString(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 12,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        onChanged: controller.updatePanCopies,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Number of print copies for Balance Invoice
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    flex: 6,
                                    child: Text(
                                      'No. of print copies for Balance Invoice',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 70,
                                    child: Obx(
                                      () => TextField(
                                        controller: TextEditingController(
                                          text:
                                              controller.balanceCopies.value
                                                  .toString(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 12,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        onChanged:
                                            controller.updateBalanceCopies,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Print Old details Slip with Invoice
                              _buildToggleRow(
                                'Print Old details Slip with Invoice',
                                controller.printOldDetails,
                                () => controller.toggleBoolValue(
                                  controller.printOldDetails,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Print Item Difference Slip with Invoice
                              _buildToggleRow(
                                'Print Item Difference Slip with Invoice',
                                controller.printItemDifference,
                                () => controller.toggleBoolValue(
                                  controller.printItemDifference,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Print Estimate with invoice
                              _buildToggleRow(
                                'Print Estimate with invoice',
                                controller.printEstimateWithInvoice,
                                () => controller.toggleBoolValue(
                                  controller.printEstimateWithInvoice,
                                ),
                              ),
                              const SizedBox(height: 24),

                              const CustomDashedLineWidget(
                                width: double.infinity,
                              ),
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
                                      value:
                                          controller
                                              .showAdditionalMessage
                                              .value,
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
                                  visible:
                                      controller.showAdditionalMessage.value,
                                  child: TextField(
                                    controller:
                                        controller.additionalMessageController,
                                    focusNode:
                                        controller.additionalMessageFocusNode,
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

                        // Vertical divider
                        const SizedBox(width: 16),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Color(0xFFEEEEEE),
                        ),
                        const SizedBox(width: 16),

                        // Right column - Edit Display Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("Edit Display Name"),
                              const SizedBox(height: 16),

                              // Two-column header
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: const Text(
                                        'Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: const Text(
                                        'Display Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Scheme Name
                              _buildNameDisplayRow(
                                'Scheme Disct',
                                controller.schemeNameController,
                                controller.schemeNameFocusNode,
                              ),

                              // Rate Display
                              _buildNameDisplayRow(
                                'Rate Disct',
                                controller.rateDisplayController,
                                controller.rateDisplayFocusNode,
                              ),

                              // Discount
                              _buildNameDisplayRow(
                                'Discount',
                                controller.discountDisplayController,
                                controller.discountDisplayFocusNode,
                              ),

                              // Additional Less
                              _buildNameDisplayRow(
                                'Additional Less',
                                controller.additionalDisplayController,
                                controller.additionalDisplayFocusNode,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom buttons
                const SizedBox(height: 16),
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
                                          .updateSalesInvoicePrintTemplate(),
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

  // Helper method to build a section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Helper method to build a template option
  Widget _buildTemplateOption(int templateId) {
    return GestureDetector(
      onTap: () => controller.setSelectedTemplate(templateId),
      child: Container(
        width: 120,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color:
                controller.selectedTemplate.value == templateId
                    ? Colors.green
                    : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(child: Text('Template $templateId')),
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

  // Helper method to build display name row
  Widget _buildNameDisplayRow(
    String name,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(name, style: const TextStyle(fontSize: 14)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
