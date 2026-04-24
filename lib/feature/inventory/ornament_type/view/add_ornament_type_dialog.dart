// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/ornament_type/view_model/ornament_type_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/metal_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response_v2.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class AddSaveIntent extends Intent {
  const AddSaveIntent();
}

class AddNewOrnamentTypeDialog extends StatefulWidget {
  final String? ornamentId;

  const AddNewOrnamentTypeDialog({super.key, this.ornamentId});

  @override
  State<AddNewOrnamentTypeDialog> createState() =>
      _AddNewOrnamentTypeDialogState();
}

class _AddNewOrnamentTypeDialogState extends State<AddNewOrnamentTypeDialog> {
  final OrnamentTypeController controller = Get.put(OrnamentTypeController());
  final FocusNode gstFocusNode = FocusNode();
  final FocusNode purityFocusNode = FocusNode();
  final FocusNode metalServiceFocusNode = FocusNode();
  final FocusNode stoneToggleFocusNode = FocusNode();
  final FocusNode oldGoldToggleFocusNode = FocusNode();
  final FocusNode serviceToggleFocusNode = FocusNode();
  final RBACController rbacController = Get.find<RBACController>();
  @override
  void initState() {
    super.initState();
    controller.getMetalTypes();
    controller.getSelectedPurity();
    if (widget.ornamentId != null) {
      controller.getOrnamentTypeById(widget.ornamentId ?? "");
    }
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
              onInvoke: (AddSaveIntent intent) {
                handleSaveorEdit();

                return;
              },
            ),
          },
          child: Form(
            key: controller.formKey,
            child: Focus(
              onKeyEvent: (node, event) {
                return onNormalKeyEvent(node, event, [
                  purityFocusNode,
                  metalServiceFocusNode,
                ]);
              },
              child: Container(
                width: Get.width * .62,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(controller),
                    SingleChildScrollView(
                      child: Obx(() => _buildOrnamentFormWithData(controller)),
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

  void handleSaveorEdit() {
    bool hasEditPermssion = rbacController.hasAction(4353);
    bool isEdit = widget.ornamentId != null;
    if (isEdit) {
      if (hasEditPermssion) {
        if (controller.formKey.currentState!.validate()) {
          controller.submitOrnamentType(widget.ornamentId);
        }
      } else {
        showErrorToast(message: "You don't have the edit permission");
      }
    } else {
      if (controller.formKey.currentState!.validate()) {
        controller.submitOrnamentType(widget.ornamentId);
      }
    }
  }

  Widget _buildOrnamentFormWithData(OrnamentTypeController controller) {
    if (controller.getOrnamentTypeByIdResponse.value.status == Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.getOrnamentTypeByIdResponse.value.status ==
        Status.ERROR) {
      return Center(
        child: Text(
          controller.getOrnamentTypeByIdResponse.value.message ??
              "Something went wrong",
        ),
      );
    }
    return _buildOrnamentForm(controller);
  }

  Widget _buildOrnamentForm(OrnamentTypeController controller) {
    return Padding(
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
          Wrap(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                controller.isCodeAvailable.value;
                return CustomTextField(
                  controller: controller.ornamentCodeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  isRequired: true,
                  width: Get.width * 0.1,
                  name: "Code",
                  nameColor: primaryColor,
                  capitalizeText: true,
                  readOnly: widget.ornamentId == null ? false : true,
                  autofocus: true,
                  onEditingComplete: () {
                    if (controller.isCodeAvailable.value &&
                        controller.ornamentCodeController.text.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  onChanged: (p0) {
                    final capitalizedValue = p0.toUpperCase();
                    final currentCursorPosition =
                        controller.ornamentCodeController.selection.baseOffset;
                    controller.ornamentCodeController.value = TextEditingValue(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(
                        offset: currentCursorPosition,
                      ),
                    );
                    controller.checkCodeAvailability(
                      capitalizedValue,
                      "ornament",
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
                    if ((controller.ornamentCodeController.text.isNotEmpty &&
                            controller.isCodeAvailable.value) ||
                        widget.ornamentId != null) {
                      return const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      );
                    }
                    if (!controller.isCodeAvailable.value) {
                      return const Icon(Icons.error, color: Colors.red);
                    }

                    return const SizedBox.shrink();
                  }),
                );
              }),
              const SizedBox(width: 16),
              CustomTextField(
                controller: controller.ornamentNameController,
                width: Get.width * 0.1,
                isRequired: true,
                name: "Name",
                nameColor: primaryColor,
                onEditingComplete: () {
                  if (controller.ornamentNameController.text.isNotEmpty) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(width: 16),
              Obx(
                () => CustomTextField(
                  controller: controller.hsnCodeController,
                  isRequired: true,
                  width: Get.width * 0.1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  name:
                      "${controller.currentCodeType.value.toUpperCase()} Code",
                  nameColor: primaryColor,
                  onEditingComplete: () {
                    if (controller.hsnCodeController.text.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${controller.currentCodeType.value} Code is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: Get.width * 0.1,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        CustomText(
                          text: 'Metal/Service Type',
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
                    GenericAutocompleteDropdown<MetalTypeResponse>(
                      controller: TextEditingController(
                        text:
                            controller.selectedMetalType.value?.typeName ?? '',
                      ),
                      focusNode: metalServiceFocusNode,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      maxWidthForOptions: DROPDOWN_OPTIONS_MIN_WIDTH,
                      items: controller.metalTypes,
                      getDisplayValue:
                          (MetalTypeResponse type) => type.typeName ?? "",
                      onSelected: (MetalTypeResponse value) {
                        controller.setSelectedMetalType(value);
                        purityFocusNode.requestFocus();
                      },
                      enabled: true,
                      isLastRow: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      fieldHeight: 38.0,
                      borderColor: secondaryColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Metal/Service Type is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      autofocus: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: Get.width * 0.1,
                child: Column(
                  children: [
                    Obx(() {
                      final bool isPurityRequired =
                          !controller.isStone.value &&
                          !controller.isOldGold.value &&
                          !controller.isService.value;

                      return Row(
                        children: [
                          const CustomText(
                            text: 'Purity',
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          if (isPurityRequired)
                            const Text(
                              ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      );
                    }),
                    GenericAutocompleteDropdown<GetPurityValue>(
                      controller: TextEditingController(
                        // Display the purity_name in the text field
                        text: controller.selectedPurity.value?.purityName ?? '',
                      ),
                      focusNode: purityFocusNode,
                      items:
                          controller.getPurityResponse.value.data?.values ?? [],
                      // Display purity_name in dropdown
                      getDisplayValue:
                          (GetPurityValue purityValue) =>
                              purityValue.purityName ?? "",
                      onSelected: (GetPurityValue value) {
                        controller.setSelectedPurity(value: value);
                        gstFocusNode.requestFocus();
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      enabled: true,
                      isLastRow: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      fieldHeight: 38.0,
                      borderColor: secondaryColor,
                      validator: (value) {
                        final bool isPurityRequired =
                            !controller.isStone.value &&
                            !controller.isOldGold.value &&
                            !controller.isService.value;
                        if (isPurityRequired &&
                            (value == null || value.isEmpty)) {
                          return 'Purity is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      autofocus: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CustomTextField(
                controller: controller.gstPercentController,
                inputFormatters: [
                  AmountInputFormatter(), // 2 decimal places for GST percentage
                ],
                width: Get.width * 0.1,
                name: "GST %",
                focusNode: gstFocusNode,
                isRequired: true,
                nameColor: primaryColor,
                suffixIcon: const Icon(Icons.percent),
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  String? validationResult = validateGSTField(
                    controller.gstPercentController.text,
                  );
                  if (validationResult == null) {
                    // null means validation passed
                    FocusScope.of(context).nextFocus();
                  } else {
                    // Keep focus on this field and show validation message
                    gstFocusNode.requestFocus();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'GST % is required';
                  }

                  // Check for valid number
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }

                  // Check for decimal places
                  if (value.contains('.')) {
                    String decimals = value.split('.')[1];
                    if (decimals.length > 2) {
                      return 'Maximum 2 decimal places allowed';
                    }
                  }

                  // Check if the value is within a reasonable range (0-100)
                  double gstValue = double.parse(value);
                  if (gstValue < 0 || gstValue > 100) {
                    return 'GST % must be between 0 and 100';
                  }

                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const CustomText(
            text: "Balance",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                inputFormatters: [
                  WeightInputFormatter(), // 3 decimal places for weight
                ],
                controller: controller.openingWeightController,
                width: Get.width * 0.1,
                name: "Opening Weight (gm)",
                nameColor: primaryColor,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Weight is required';
                  // }
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(width: 16),
              CustomTextField(
                inputFormatters: [
                  AmountInputFormatter(), // 2 decimal places for amount
                ],
                controller: controller.openingAmountController,
                width: Get.width * 0.1,
                name: "Opening Amount",
                nameColor: primaryColor,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Amount is required';
                  // }
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(width: 16),
              CustomTextField(
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Only integer values for quantity
                ],
                controller: controller.openingQuantityController,
                width: Get.width * 0.1,
                name: "Opening Quantity",
                nameColor: primaryColor,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Amount is required';
                  // }
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
          const SizedBox(height: 16),
          const CustomText(
            text: "Configuration",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Obx(
                () => _buildToggleOption(
                  "Is Stone",
                  controller.isStone.value,
                  () {
                    controller.isStone.value = !controller.isStone.value;
                    controller.selectedPurity.value = null;
                  },
                  focusNode: stoneToggleFocusNode,
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => _buildToggleOption(
                  "Is Old Ornament",
                  controller.isOldGold.value,
                  () {
                    controller.isOldGold.value = !controller.isOldGold.value;
                  },
                  focusNode: oldGoldToggleFocusNode,
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => _buildToggleOption(
                  "Is Service",
                  controller.isService.value,
                  () {
                    controller.isService.value = !controller.isService.value;
                    controller.selectedPurity.value = null;
                  },
                  focusNode: serviceToggleFocusNode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(OrnamentTypeController controller) {
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
              text:
                  widget.ornamentId == null
                      ? 'Add New Ornament/Service Type'
                      : 'Edit Ornament/Service Type',
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

  Widget _buildFooter(OrnamentTypeController controller) {
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
              handleSaveorEdit();
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
                  if (controller.addOrnamentTypeResponse.value.status ==
                      Status.LOADING) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: widget.ornamentId == null ? "Save" : "Update",
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

  String? validateGSTField(String? value) {
    // Required field check
    if (value == null || value.isEmpty) {
      return 'GST % is required';
    }

    // Valid number check
    if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }

    // Decimal places check
    if (value.contains('.')) {
      String decimals = value.split('.')[1];
      if (decimals.length > 2) {
        return 'Maximum 2 decimal places allowed';
      }
    }

    // Range check (0-100)
    double gstValue = double.parse(value);
    if (gstValue < 0 || gstValue > 100) {
      return 'GST % must be between 0 and 100';
    }

    return null; // Validation passed
  }

  Widget _buildToggleOption(
    String label,
    bool value,
    VoidCallback onToggle, {
    required FocusNode focusNode,
  }) {
    // log("Focus is ${focusNode.hasFocus}");
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
                constraints: const BoxConstraints(minWidth: 70),
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
