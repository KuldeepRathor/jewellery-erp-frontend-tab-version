import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/kyc_settings/view_model/kyc_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class KycSettingsPage extends StatefulWidget {
  const KycSettingsPage({super.key});

  @override
  State<KycSettingsPage> createState() => _KycSettingsPageState();
}

class _KycSettingsPageState extends State<KycSettingsPage> {
  late final KycSettingsController controller;

  @override
  void initState() {
    super.initState();
    // Try to find existing controller first, create only if not found
    try {
      controller = Get.find<KycSettingsController>();
    } catch (e) {
      controller = Get.put(KycSettingsController());
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
                    'KYC Settings',
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

                final data = controller.getOrgKycSettingsResponse.value.data;

                return SingleChildScrollView(
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
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // KYC Status Section
                          const Text(
                            "KYC Status",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildInfoRow(
                            'KYC Enabled',
                            data?.isKycEnabled == true ? 'Yes' : 'No',
                            valueColor:
                                data?.isKycEnabled == true
                                    ? Colors.green
                                    : Colors.red,
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            'Low on Credits',
                            data?.isLowOnCredits == true ? 'Yes' : 'No',
                            valueColor:
                                data?.isLowOnCredits == true
                                    ? Colors.red
                                    : Colors.green,
                          ),

                          const SizedBox(height: 24),
                          CustomDashedLineWidget(width: Get.width),
                          const SizedBox(height: 24),

                          // Credits Information
                          const Text(
                            "Credits Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildInfoRow(
                            'Credits Remaining',
                            data?.creditsRemaining ?? "0",
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            'Credits Used',
                            data?.creditsUsed ?? "0",
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            'Minimum Credits Required',
                            data?.minimumCreditsRequired ?? "0",
                          ),

                          const SizedBox(height: 24),
                          CustomDashedLineWidget(width: Get.width),
                          const SizedBox(height: 24),

                          // Verification Charges
                          const Text(
                            "Verification Charges",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildInfoRow(
                            'Aadhaar KYC Charges',
                            data?.aadhaarKycCharges ?? "0",
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            'PAN KYC Charges',
                            data?.panKycCharges ?? "0",
                          ),

                          const SizedBox(height: 24),
                          CustomDashedLineWidget(width: Get.width),
                          const SizedBox(height: 24),

                          // Verification Counts
                          const Text(
                            "Verification Statistics",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildInfoRow(
                            'PAN Verifications',
                            data?.panVerificationCount?.toString() ?? '0',
                          ),
                          const SizedBox(height: 12),

                          _buildInfoRow(
                            'Aadhaar Verifications',
                            data?.aadhaarVerificationCount?.toString() ?? '0',
                          ),

                          const SizedBox(height: 24),
                          CustomDashedLineWidget(width: Get.width),
                          const SizedBox(height: 24),

                          // Editable Limits Section
                          const Text(
                            "Transaction Limits (Editable)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildEditableFieldRow(
                            'Transaction Limit',
                            controller.transactionLimitController,
                            '₹',
                          ),
                          const SizedBox(height: 16),

                          _buildEditableFieldRow(
                            'Daily Limit',
                            controller.dailyLimitController,
                            '₹',
                          ),
                          const SizedBox(height: 16),

                          _buildEditableFieldRow(
                            'Monthly Limit',
                            controller.monthlyLimitController,
                            '₹',
                          ),
                          const SizedBox(height: 16),

                          _buildEditableFieldRow(
                            'Yearly Limit',
                            controller.yearlyLimitController,
                            '₹',
                          ),

                          const SizedBox(height: 32),

                          // Action Buttons
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
                                                controller.updateKycSettings(),
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
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Build read-only info row
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // Build editable field row
  Widget _buildEditableFieldRow(
    String label,
    TextEditingController controller,
    String suffix,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        Expanded(
          flex: 6,
          child: SizedBox(
            height: 40,
            child: TextFormField(
              controller: controller,
              inputFormatters: [AmountInputFormatter()],
              decoration: InputDecoration(
                suffixText: suffix,
                suffixStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
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
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
