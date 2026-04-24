import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key, required this.isEditMode});
  final bool isEditMode;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DesignSettingsController>();
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onNormalKeyEvent(node, event, []),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFF111111),
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => _buildToggleOption(
                    controller.isTaggingEnabled.value ? 'Tag' : "No Tag",
                    controller.isTaggingEnabled.value,
                    controller.toggleTagging,
                    focusNode: controller.tagFocusNode,
                  ),
                ),
                const SizedBox(width: 16),
                Obx(
                  () => _buildToggleOption(
                    'Stone Cost',
                    controller.isStoneCostEnabled.value,
                    controller.toggleStoneCost,
                    focusNode: controller.stoneFocusNode,
                  ),
                ),
              ],
            ),
            Obx(() {
              // Only show design code field when tagging is disabled
              if (!controller.isTaggingEnabled.value) {
                return Form(
                  key: controller.formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CustomTextField(
                      name: "Tag Code",
                      // readOnly: widget.isEditMode,
                      autofocus: true,
                      controller: controller.tagCodeController,
                      focusNode: controller.tagCodeFocusNode,
                      onChanged: (value) {
                        final capitalizedValue = value.toUpperCase();
                        final currentCursorPosition =
                            controller.tagCodeController.selection.baseOffset;
                        controller.tagCodeController.value = TextEditingValue(
                          text: capitalizedValue,
                          selection: TextSelection.collapsed(
                            offset: currentCursorPosition,
                          ),
                        );
                        controller.checkCodeAvailability(capitalizedValue);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Design Code";
                        }
                        if (!controller.isCodeAvailable.value) {
                          return 'Code already exists';
                        }
                        return null;
                      },
                      suffixIcon: Obx(() {
                        if (controller.isCheckingCode.value) {
                          return const SizedBox(
                            width: 10,
                            height: 10,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 4),
                            ),
                          );
                        }
                        if (controller.tagCodeController.text.isNotEmpty) {
                          if (!controller.isCodeAvailable.value) {
                            return const Icon(Icons.error, color: Colors.red);
                          }
                          if (controller.isCodeAvailable.value) {
                            return const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String label,
    bool value,
    VoidCallback onToggle, {
    required FocusNode focusNode,
  }) {
    log("Focus is ${focusNode.hasFocus}");
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        focusNode: focusNode,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color:
                    focusNode.hasPrimaryFocus
                        ? Colors.blue
                        : const Color(0xFFE6E8FF),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 110, minWidth: 70),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomToggleSwitch(
                canRequestFocus: false,
                value: value,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
