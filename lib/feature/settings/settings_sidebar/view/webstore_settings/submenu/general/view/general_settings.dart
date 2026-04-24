import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/general_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/view_model/webstore_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  late final GeneralSettingsController controller;

  @override
  void initState() {
    super.initState();
    // Try to find existing controller first, create only if not found
    try {
      controller = Get.find<GeneralSettingsController>(tag: 'generalSettings');
      log('Found existing GeneralSettingsController');
    } catch (e) {
      controller = Get.put(GeneralSettingsController(), tag: 'generalSettings');
      log('Created new GeneralSettingsController');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'General Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
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
                              "Charges",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Content area
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Levy PG charges
                            _buildToggleRow(
                              'Levy PG charges on customers',
                              controller.levyPGCharges,
                              () => controller.toggleBoolValue(
                                controller.levyPGCharges,
                              ),
                              'Yes',
                              'No',
                            ),
                            const SizedBox(height: 16),

                            // Levy shipping charges with amount field
                            _buildShippingChargesRow(),
                            const SizedBox(height: 16),

                            // Advance payment % for custom order
                            _buildTextFieldRow(
                              'Advance payment % for custom order',
                              controller.advancePaymentController,
                              '%',
                              isPercentage: true,
                            ),
                            const SizedBox(height: 16),

                            // Add additional VA for webstore live stock
                            _buildTextFieldRow(
                              'Add additional VA for webstore live stock',
                              controller.additionalVAController,
                              '%',
                              isPercentage: true,
                            ),
                            const SizedBox(height: 16),

                            // Add additional MC for webstore live stock
                            _buildTextFieldRow(
                              'Add additional MC for webstore live stock',
                              controller.additionalMCController,
                              '₹',
                              isPercentage: false,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        CustomDashedLineWidget(width: Get.width),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Text(
                              "Live Stock Listing",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              " (Item with no images won't be listed)",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Radio button options
                        Obx(
                          () => _buildRadioOption(
                            'List all pieces on webstore',
                            LiveStockListingOption.listAll,
                            controller.selectedListingOption.value,
                            (value) => controller.setListingOption(value!),
                            showAction: false,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Obx(
                          () => _buildRadioOption(
                            'List Head wise',
                            LiveStockListingOption.listHeadWise,
                            controller.selectedListingOption.value,
                            (value) => controller.setListingOption(value!),
                            showAction: true,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Obx(
                          () => _buildRadioOption(
                            'List design wise',
                            LiveStockListingOption.listDesignWise,
                            controller.selectedListingOption.value,
                            (value) => controller.setListingOption(value!),
                            showAction: true,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Spacer(),
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
                                                  .updateGeneralSettings(),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    String label,
    LiveStockListingOption value,
    LiveStockListingOption groupValue,
    ValueChanged<LiveStockListingOption?> onChanged, {
    bool showAction = false,
  }) {
    return Row(
      children: [
        Radio<LiveStockListingOption>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        if (showAction)
          InkWell(
            onTap: () {
              // Get the webstore settings controller
              final webstoreController = Get.find<WebstoreSettingsController>(
                tag: 'webstoreSettings',
              );

              // Navigate to the appropriate page based on the value
              if (value == LiveStockListingOption.listHeadWise) {
                webstoreController.navigateToPage('head_wise_listing');
              } else if (value == LiveStockListingOption.listDesignWise) {
                webstoreController.navigateToPage('design_wise_listing');
              }
            },
            child: const Text(
              'Choose/View',
              style: TextStyle(
                fontSize: 14,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
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
          flex: 3,
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
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildShippingChargesRow() {
    return Obx(() {
      return Row(
        children: [
          const SizedBox(width: 8),
          const Expanded(
            flex: 3,
            child: Text(
              'Levy shipping charges on customers',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Text(
                  controller.levyShippingCharges.value ? 'Yes' : 'No',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                CustomToggleSwitch(
                  value: controller.levyShippingCharges.value,
                  onChanged:
                      (_) => controller.toggleBoolValue(
                        controller.levyShippingCharges,
                      ),
                ),

                // Conditionally show the amount field
                if (controller.levyShippingCharges.value) ...[
                  const SizedBox(width: 24),
                  const Text(
                    'Add amount',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 150,
                    height: 36,
                    child: TextField(
                      controller: controller.shippingAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        // hintText: 'Enter amount',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: 24),
                  const Text(
                    'Add amount',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 150,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      );
    });
  }

  Widget _buildTextFieldRow(
    String label,
    TextEditingController controller,
    String suffix, {
    required bool isPercentage,
  }) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Expanded(
          flex: 6,
          child: Row(
            children: [
              SizedBox(
                width: 150,
                height: 36,
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters:
                      isPercentage
                          ? [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d{0,3}\.?\d{0,2}'),
                            ),
                            // Limit to 100 for percentage
                            TextInputFormatter.withFunction((
                              oldValue,
                              newValue,
                            ) {
                              if (newValue.text.isEmpty) return newValue;
                              final value = double.tryParse(newValue.text);
                              if (value != null && value > 100) {
                                return oldValue;
                              }
                              return newValue;
                            }),
                          ]
                          : [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                  decoration: InputDecoration(
                    // hintText: 'Enter value',
                    suffixText: suffix,
                    suffixStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
