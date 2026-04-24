import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter/view_model/counter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddSaveIntent extends Intent {
  const AddSaveIntent();
}

class AddCounterDialog extends StatefulWidget {
  const AddCounterDialog({super.key});

  @override
  State<AddCounterDialog> createState() => _AddCounterDialogState();
}

class _AddCounterDialogState extends State<AddCounterDialog> {
  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const AddSaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            AddSaveIntent: CallbackAction<AddSaveIntent>(
              onInvoke: (AddSaveIntent intent) => controller.addCounter(),
            ),
          },
          child: Container(
            height: Get.height * .4,
            width: Get.width * .375,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(controller),
                  _buildCounterForm(controller),
                  _buildFooter(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildCounterForm(CounterController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Details",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  autofocus: true,
                  controller: controller.counterCodeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  width: Get.width * 0.1,
                  name: "Counter Code",
                  nameColor: primaryColor,
                  capitalizeText: true,
                  onChanged: (p0) {
                    final capitalizedValue = p0.toUpperCase();
                    final currentCursorPosition =
                        controller.counterCodeController.selection.baseOffset;
                    controller.counterCodeController.value = TextEditingValue(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(
                        offset: currentCursorPosition,
                      ),
                    );
                    controller.checkCodeAvailability(
                      capitalizedValue,
                      "counter",
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Code is required';
                    }
                    if (!controller.isCodeAvailable.value) {
                      return 'This code is already taken';
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
                    if (!controller.isCodeAvailable.value) {
                      return const Icon(Icons.error, color: Colors.red);
                    }
                    if (controller.counterCodeController.text.isNotEmpty &&
                        controller.isCodeAvailable.value) {
                      return const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ),
                const SizedBox(width: 16),
                CustomTextField(
                  controller: controller.counterNameController,
                  width: Get.width * 0.1,
                  name: "Counter Name",
                  nameColor: primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Default Counter",
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    Row(
                      children: [
                        const CustomText(text: "No"),
                        Obx(
                          () => Transform.scale(
                            scale: 0.6,
                            child: Switch(
                              value: controller.isDefault.value,
                              onChanged: (value) {
                                controller.toggleIsDefault();
                              },
                              activeColor: whiteColor,
                              activeTrackColor: totalGreenColor,
                            ),
                          ),
                        ),
                        const CustomText(text: "Yes"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(CounterController controller) {
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
              text: 'Add New Counter',
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            IconButton(
              onPressed: () {
                Get.back();
                controller.resetFields();
              },
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(CounterController controller) {
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
              if (controller.formKey.currentState!.validate()) {
                controller.addCounter();
              }
            },
            child: Container(
              width: 120,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Obx(() {
                  if (controller.addCounterResponse.value.status ==
                      Status.LOADING) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return const Row(
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
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
