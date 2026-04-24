import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/view_model/add_stone_rates_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class AddSaveIntent extends Intent {
  const AddSaveIntent();
}

class AddStoneRatesDialog extends StatefulWidget {
  final String? stoneRateId;

  const AddStoneRatesDialog({super.key, this.stoneRateId});

  @override
  State<AddStoneRatesDialog> createState() => _AddStoneRatesDialogState();
}

class _AddStoneRatesDialogState extends State<AddStoneRatesDialog> {
  final AddStoneRatesController controller = Get.put(AddStoneRatesController());

  final FocusNode ornamentCodeFocusNode = FocusNode();
  final FocusNode stoneNameFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCodeList();
      // ornamentCodeFocusNode.requestFocus();
      // stoneNameFocusNode.requestFocus();
      if (widget.stoneRateId != null) {
        controller.getStoneRateById(widget.stoneRateId!);
      }
    });
  }

  @override
  void dispose() {
    controller.resetFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onInvoke:
                  (AddSaveIntent intent) =>
                      controller.submitStoneRates(widget.stoneRateId),
            ),
          },
          child: FocusScope(
            // autofocus: true,
            onKeyEvent:
                (node, event) =>
                    onNormalKeyEvent(node, event, [ornamentCodeFocusNode]),
            child: Container(
              // height: Get.height * .59,
              width: Get.width * .7,
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
                    SingleChildScrollView(
                      child: _buildStoneRatesForm(controller),
                    ),
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

  Widget _buildStoneRatesForm(AddStoneRatesController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "Stone Charges Details",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              Row(
                children: [
                  Obx(
                    () => CustomToggleSwitch(
                      value: controller.isOtherMix.value,
                      onChanged: (value) => controller.toggleIsOtherMix(value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const CustomText(
                    text: "Is Other Mix",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            child: Wrap(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  controller.isCodeAvailable.value;
                  return CustomTextField(
                    autofocus: true,
                    isRequired: true,
                    controller: controller.stoneRatesCodeController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    width: Get.width * 0.13,
                    name: "Stone Code",
                    nameColor: primaryColor,
                    capitalizeText: true,
                    onChanged: (p0) {
                      final capitalizedValue = p0.toUpperCase();
                      final currentCursorPosition =
                          controller
                              .stoneRatesCodeController
                              .selection
                              .baseOffset;
                      controller
                          .stoneRatesCodeController
                          .value = TextEditingValue(
                        text: capitalizedValue,
                        selection: TextSelection.collapsed(
                          offset: currentCursorPosition,
                        ),
                      );
                      controller.checkCodeAvailability(
                        capitalizedValue,
                        "stone_rate",
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
                      if (controller.stoneRatesCodeController.text.isNotEmpty &&
                          controller.isCodeAvailable.value) {
                        return const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  );
                }),
                const SizedBox(width: 16),
                _buildCodeDropdown(focusNode: ornamentCodeFocusNode),
                const SizedBox(width: 16),
                Obx(
                  () => CustomTextField(
                    focusNode: stoneNameFocusNode,
                    isRequired: !controller.isOtherMix.value,
                    controller: controller.stoneRatesNameController,
                    width: Get.width * 0.25,
                    name: "Stone Name",
                    nameColor: primaryColor,
                    validator: (value) {
                      if (!controller.isOtherMix.value &&
                          (value == null || value.isEmpty)) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                _buildRateField(controller),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const CustomText(
            text: "Advance Filter",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: controller.colorController,
                width: Get.width * 0.13,
                name: "Color",
                nameColor: primaryColor,
                onChanged: (value) {
                  final capitalizedValue = value.toUpperCase();
                  final currentCursorPosition =
                      controller.colorController.selection.baseOffset;
                  controller.colorController.value = TextEditingValue(
                    text: capitalizedValue,
                    selection: TextSelection.collapsed(
                      offset: currentCursorPosition,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              CustomTextField(
                controller: controller.cutController,
                width: Get.width * 0.13,
                name: "Cut",
                nameColor: primaryColor,
              ),
              const SizedBox(width: 16),
              CustomTextField(
                controller: controller.clarityController,
                width: Get.width * 0.13,
                name: "Clarity",
                nameColor: primaryColor,
              ),
              const SizedBox(width: 16),
              CustomTextField(
                inputFormatters: [AmountInputFormatter()],
                controller: controller.buybackController,
                width: Get.width * 0.13,
                name: "Buyback %",
                nameColor: primaryColor,
                suffixIcon: const Icon(Icons.percent),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                  }
                  return null;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AddStoneRatesController controller) {
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
            CustomText(
              text: widget.stoneRateId == null ? 'Add New Stone' : 'Edit Stone',
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

  Widget _buildFooter(AddStoneRatesController controller) {
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
                controller.submitStoneRates(widget.stoneRateId);
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
                  if (controller.editStoneRatesResponse.value.status ==
                          Status.LOADING ||
                      controller.addStoneRatesResponse.value.status ==
                          Status.LOADING) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: widget.stoneRateId == null ? "Done" : "Update",
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                      const CustomText(
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

  Widget _buildCodeDropdown({required FocusNode focusNode}) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "Ornament Code",
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            width: Get.width * 0.13,
            child: GenericAutocompleteDropdown<GetAllOrnamentsResponseValue>(
              controller: controller.ornamentCodeController,
              focusNode: focusNode,
              items: controller.ornamentCodeList,
              maxWidthForOptions: DROPDOWN_OPTIONS_MAX_WIDTH,
              getDisplayValue: (item) => item.code ?? '',
              onSelected: (value) {
                controller.setSelectedcode(value);
                stoneNameFocusNode.requestFocus();
              },
              enabled:
                  controller
                      .inventoryViewmodel
                      .getAllOrnamentsResponse
                      .value
                      .status ==
                  Status.COMPLETED,
              isLastRow: true,
              fieldHeight: 38,
              borderColor: secondaryColor,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Code";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateField(AddStoneRatesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                text: "Rate",
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              if (!controller.isOtherMix.value)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: Get.width * 0.13,
          child: Focus(
            canRequestFocus: false,
            onKeyEvent: (node, event) {
              if (event.logicalKey == LogicalKeyboardKey.keyC &&
                  HardwareKeyboard.instance.isAltPressed &&
                  (event is KeyDownEvent)) {
                final currentIndex = controller.rateTypeItems.indexOf(
                  controller.selectedRateType.value,
                );
                final nextIndex =
                    (currentIndex + 1) % controller.rateTypeItems.length;
                controller.onRateTypeChanged(
                  controller.rateTypeItems[nextIndex],
                );
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: Obx(
              () => TextFormField(
                controller: controller.ratesController,
                inputFormatters: [AmountInputFormatter()],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  isDense: true,
                  suffixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: controller.selectedRateType.value,
                          color: secondaryColor,
                        ),
                        const SizedBox(width: 4),
                        const CustomText(
                          text: "(Alt+C)",
                          color: Colors.grey,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: secondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: secondaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: secondaryColor,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (!controller.isOtherMix.value) {
                    if (value == null || value.isEmpty) {
                      return 'Rate is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                  } else if (value != null &&
                      value.isNotEmpty &&
                      double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
