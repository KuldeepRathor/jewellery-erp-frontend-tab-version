import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/counter/counter_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class AddSaveIntent extends Intent {
  const AddSaveIntent();
}

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final TaggingController controller = Get.find();
  late final FocusNode _dialogFocusNode;

  @override
  void initState() {
    super.initState();
    _dialogFocusNode = FocusNode();
    // controller.printerNameController.value.text =
    //     controller.printerSettings.printerName;
    // controller.scalePortController.value.text =
    //     controller.printerSettings.scalePort;

    // Add a longer delay and ensure focus is captured
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _dialogFocusNode.requestFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _dialogFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Focus(
        autofocus: true,
        focusNode: _dialogFocusNode,
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                const AddSaveIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              AddSaveIntent: CallbackAction<AddSaveIntent>(
                onInvoke: (AddSaveIntent intent) {
                  log("Save called");
                  controller.saveSettings();
                  Get.back();
                  return null;
                },
              ),
            },
            child: Container(
              height: Get.height * .6,
              width: Get.width * .3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                // key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(controller),
                    _buildSettingsForm(controller),
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

  Expanded _buildSettingsForm(TaggingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Weight Input",
                    fontSize: 14,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Obx(
                    () => _buildToggleOption(
                      "Manual",
                      'Auto',
                      controller.isAutoWeightInput.value,
                      controller.toggleWeightInput,
                      focusNode: FocusNode(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Counter",
                    fontSize: 14,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Obx(
                    () => Row(
                      children: [
                        // Material(
                        //   color: Colors.transparent,
                        //   child: InkWell(
                        //     onTap: () => controller.setIsCounterDefault(true),
                        //     child: Container(
                        //       height: 38,
                        //       width: Get.width * 0.05,
                        //       decoration: BoxDecoration(
                        //         border: Border.all(
                        //           color: controller.isCounterDefault.value
                        //               ? primaryColor
                        //               : grey2,
                        //         ),
                        //         borderRadius: BorderRadius.circular(8),
                        //         color: controller.isCounterDefault.value
                        //             ? primaryColor
                        //             : Colors.transparent,
                        //       ),
                        //       child: Center(
                        //         child: CustomText(
                        //           text: "Default",
                        //           color: controller.isCounterDefault.value
                        //               ? whiteColor
                        //               : blackColor,
                        //           fontSize: 16,
                        //           fontFamily: 'Satoshi',
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(width: Get.width * 0.01),
                        CustomDropdownField<CounterValue>(
                          width: Get.width * .145,
                          items: controller.counter,
                          selectedItem: controller.selectedCounter.value,
                          onChanged: (CounterValue? value) {
                            controller.setSelectedCounter(value);
                          },
                          itemAsString:
                              (CounterValue? type) => type?.counterName ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: "Print Tag",
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Obx(
                        () => _buildToggleOption(
                          'No',
                          "Yes",
                          controller.isprintTag.value,
                          controller.togglePrintTag,
                          focusNode: FocusNode(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  CustomTextField(
                    width: Get.width * .05,
                    autofocus: true,
                    controller: controller.printTagController.value,
                    name: "Count",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: "HUID Required"),
                  Obx(
                    () => _buildToggleOption(
                      'No',
                      "Yes",
                      controller.isHuidRequired.value,
                      controller.toggleHuidRequired,
                      focusNode: FocusNode(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              // Add Printer Settings Section
              const Divider(height: 32),
              const CustomText(
                text: "Hardware Settings",
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 16),

              // Label Printer Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Label Printer Name",
                    fontSize: 14,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  CustomTextField(
                    width: Get.width * .25,
                    controller: controller.printerNameController.value,
                    name: "Printer Name",
                    hintText: "Enter printer name (e.g., GODEX G500)",
                    // onChanged: (value) {
                    //   controller.printerSettings.updatePrinterName(value);
                    // },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Scale Port Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Weighing Scale Port",
                    fontSize: 14,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  CustomTextField(
                    width: Get.width * .25,
                    controller: controller.scalePortController.value,
                    name: "Scale Port",
                    hintText: "Enter port name (e.g., COM8)",
                    // onChanged: (value) {
                    //   controller.printerSettings.updateScalePort(value);
                    // },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String label1,
    String label2,
    bool value,
    VoidCallback onToggle, {
    required FocusNode focusNode,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE6E8FF)),
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
                  label1,
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
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(maxWidth: 110, minWidth: 70),
                child: Text(
                  label2,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TaggingController controller) {
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
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: 'Settings',
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(TaggingController controller) {
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
            onTap: () {
              controller.saveSettings();
              Get.back();
            },
            child: Container(
              width: 120,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Row(
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
        ],
      ),
    );
  }
}
