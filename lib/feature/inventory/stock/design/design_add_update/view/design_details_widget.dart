import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/generic_attention_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/metal_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/get_stock_head_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class DesignDetailsWidget extends StatefulWidget {
  const DesignDetailsWidget({
    super.key,
    required this.isEditMode,
    required this.metal_type,
  });

  final bool isEditMode;
  final String metal_type;

  @override
  State<DesignDetailsWidget> createState() => _DesignDetailsWidgetState();
}

class _DesignDetailsWidgetState extends State<DesignDetailsWidget> {
  final controller = Get.find<DesignDetailsController>();
  final designSettingsController = Get.find<DesignSettingsController>();
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();

    if (!widget.isEditMode) {
      controller.getMetalTypes();
      controller.getOrnamentsTypeListingDetails(widget.metal_type);
      controller.getStockHeadListingDetails(query: widget.metal_type);
    }
  }

  void _showRetagDialog() {
    if (!_hasShownDialog && widget.isEditMode) {
      _hasShownDialog = true;
      Get.dialog(
        GenericAttentionDialog(
          title: 'Attention',
          message: 'Please retag the earlier designs.',
          actions: [
            DialogAction(
              text: 'Close',
              onPressed: () {
                // Handle 'No' action
                Get.back();
              },
              shortcut: 'esc',
            ),
            DialogAction(
              text: 'Okay',
              onPressed: () {
                // Handle 'Yes' action
                log("From parent");
                Get.back();
              },
              isDefault: true,
              shortcut: 'Enter',
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent:
          (node, event) => onNormalKeyEvent(node, event, [
            controller.metalServiceTypeFocusNode,
            controller.stockHeadFocusNode,
          ]),
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
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Details',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isEditMode)
                    Expanded(
                      flex: 1,
                      child: CustomTextField(
                        name: "Design Code",
                        autofocus: true,
                        isRequired: true,
                        readOnly: widget.isEditMode,
                        controller: controller.designCodeController,
                        focusNode: controller.designCodeFocusNode,
                        onChanged: (value) {
                          _showRetagDialog();
                          final capitalizedValue = value.toUpperCase();
                          final currentCursorPosition =
                              controller
                                  .designCodeController
                                  .selection
                                  .baseOffset;
                          controller
                              .designCodeController
                              .value = TextEditingValue(
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                ),
                              ),
                            );
                          }
                          if (controller.designCodeController.text.isNotEmpty) {
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
                  // Visibility(
                  //   visible: widget.isEditMode,
                  //   child: const SizedBox(width: 16),
                  // ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      name: "Design Name",
                      autofocus: true,
                      isRequired: true,
                      controller: controller.designNameController,
                      focusNode: controller.designNameFocusNode,
                      onChanged: (value) => _showRetagDialog(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Design Name";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            CustomText(
                              text: 'Metal/Service Type',
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
                                controller.selectedMetalType.value?.typeName ??
                                '',
                          ),
                          focusNode: controller.metalServiceTypeFocusNode,
                          items: controller.metalTypes,
                          getDisplayValue:
                              (MetalTypeResponse type) => type.typeName ?? "",

                          maxWidthForOptions: DROPDOWN_OPTIONS_MAX_WIDTH,
                          onSelected: (MetalTypeResponse value) async {
                            await controller.setSelectedMetalType(value);

                            controller.stockHeadFocusNode.requestFocus();
                          },
                          enabled: widget.isEditMode == false,
                          isLastRow: true,
                          padding: const EdgeInsets.only(top: 8),
                          fieldHeight: 38.0,
                          borderColor: secondaryColor,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Metal/Service Type is required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          onEditingComplete: () {
                            FocusManager.instance.primaryFocus?.nextFocus();
                          },
                          // autofocus: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            CustomText(
                              text: "Stock Head",
                              color: blackColor,
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
                        Obx(() {
                          return GenericAutocompleteDropdown<
                            GetStockHeadDropdownValue
                          >(
                            controller: TextEditingController(
                              text:
                                  controller.selectedStockHead.value?.name ??
                                  '',
                            ),
                            focusNode: controller.stockHeadFocusNode,
                            padding: const EdgeInsets.only(top: 8),
                            items:
                                controller
                                    .getStockHeadListingResponse
                                    .value
                                    .data
                                    ?.values ??
                                [],
                            maxWidthForOptions: DROPDOWN_OPTIONS_MAX_WIDTH,
                            getDisplayValue:
                                (GetStockHeadDropdownValue head) =>
                                    head.name ?? '',
                            onSelected: (GetStockHeadDropdownValue value) {
                              controller.setStockHead(value.id ?? '');
                              designSettingsController.tagFocusNode
                                  .requestFocus();
                            },
                            enabled: !widget.isEditMode,
                            isLastRow: true,
                            fieldHeight: 38.0,
                            maxHeight: 150.0,
                            borderColor: secondaryColor,
                            onEditingComplete: () {
                              FocusManager.instance.primaryFocus?.nextFocus();
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
