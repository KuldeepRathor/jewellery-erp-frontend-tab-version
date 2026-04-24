import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/get_deisgn_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/view_model/edit_tagged_items_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_vendor_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response_v2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class ChangesWidget extends StatelessWidget {
  ChangesWidget({super.key, required this.context});

  final BuildContext context;

  final EditTaggedItemsViewModel controller =
      Get.find<EditTaggedItemsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'Changes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // First Row: Design and Size
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Design Dropdown
                    _designDropdown(context),
                    const SizedBox(width: 26),
                    // Size Dropdown
                    _sizeDropdown(context),
                  ],
                ),
                const SizedBox(height: 16),

                // Second Row: Vendor and Purity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Vendor Dropdown
                    _vendorDropdown(context),
                    const SizedBox(width: 26),
                    // Purity Dropdown
                    _purityDropdown(context),
                  ],
                ),
                const SizedBox(height: 16),

                // Third Row: Gross Weight and Net Weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      controller: controller.grWtController,
                      width: Get.width * 0.25,
                      isRequired: true,
                      name: "Gross Weight",
                      nameColor: primaryColor,
                      onEditingComplete: () {
                        if (controller.grWtController.text.isNotEmpty) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Gross Weight is required';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: controller.netWtController,
                      width: Get.width * 0.25,
                      isRequired: true,
                      name: "Net Weight",
                      nameColor: primaryColor,
                      onEditingComplete: () {
                        if (controller.netWtController.text.isNotEmpty) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Net Weight is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Fourth Row: Rate and HUID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      controller: controller.rateController,
                      width: Get.width * 0.25,
                      isRequired: true,
                      name: "Rate/gm or PC rate",
                      nameColor: primaryColor,
                      onEditingComplete: () {
                        if (controller.rateController.text.isNotEmpty) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Rate is required';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: controller.huidController,
                      width: Get.width * 0.25,
                      isRequired: false,
                      name: "HUID",
                      nameColor: primaryColor,
                      onEditingComplete: () {
                        if (controller.huidController.text.isNotEmpty) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.075),

                CustomDashedLineWidget(width: Get.width),
                SizedBox(height: Get.height * 0.075),

                // Display calculated values from API response
                Obx(() {
                  final data = controller.getTaggingItemResponse.value.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ItemDetailsWidget(
                        headerText: "Wastage",
                        valueText:
                            data?.va != null
                                ? "${data?.va ?? ''} ${data?.designWastageType ?? ''}"
                                : "N/A",
                      ),
                      _ItemDetailsWidget(
                        headerText: "MC",
                        valueText:
                            data?.mc != null
                                ? "${data?.mc ?? ''} ${data?.designMakingChargesType ?? ''}"
                                : "N/A",
                      ),
                      _ItemDetailsWidget(
                        headerText: "MC Total",
                        valueText:
                            data?.mcTotal != null
                                ? "₹ ${data?.mcTotal ?? ''}"
                                : "N/A",
                      ),
                      _ItemDetailsWidget(
                        headerText: "Rate",
                        valueText:
                            data?.rate != null
                                ? "₹ ${data?.rate ?? ''}"
                                : "N/A",
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _designDropdown(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.25,
      child: Column(
        children: [
          const Row(
            children: [
              CustomText(
                text: 'Design Name',
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Obx(() {
            // Handle loading state
            if (controller.getDesignDropdownResponse.value.status ==
                Status.LOADING) {
              return Container(
                height: 38.0,
                decoration: BoxDecoration(
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            // Handle error state
            if (controller.getDesignDropdownResponse.value.status ==
                Status.ERROR) {
              return Container(
                height: 38.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'Failed to load designs',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              );
            }

            // Render the dropdown when data is loaded
            return GenericAutocompleteDropdown<GetDesignDropdownValue>(
              controller: TextEditingController(
                text: controller.selectedDesign.value?.name ?? '',
              ),
              focusNode: controller.designFocusNode,
              items:
                  controller.getDesignDropdownResponse.value.data?.values ??
                  const [],
              getDisplayValue:
                  (GetDesignDropdownValue designValue) =>
                      designValue.name ?? "",
              onSelected: (GetDesignDropdownValue value) async {
                // Fetch full design details
                if (value.id != null) {
                  final fullDesign = await controller.fetchDesignDetails(
                    value.id!,
                  );
                  if (fullDesign != null) {
                    controller.setSelectedDesign(fullDesign);
                  }
                }
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              enabled: true,
              isLastRow: true,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              fieldHeight: 38.0,
              borderColor: secondaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Design is required';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              autofocus: false,
            );
          }),
        ],
      ),
    );
  }

  SizedBox _purityDropdown(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.25,
      child: Column(
        children: [
          const Row(
            children: [
              CustomText(
                text: 'Purity',
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Obx(() {
            // Handle loading state
            if (controller.getPurityResponse.value.status == Status.LOADING) {
              return Container(
                height: 38.0,
                decoration: BoxDecoration(
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            // Handle error state
            if (controller.getPurityResponse.value.status == Status.ERROR) {
              return Container(
                height: 38.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'Failed to load purities',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              );
            }

            // Render the dropdown when data is loaded
            return GenericAutocompleteDropdown<GetPurityValue>(
              controller: TextEditingController(
                text: controller.selectedPurity.value?.purityName ?? '',
              ),
              focusNode: controller.purityFocusNode,
              items:
                  controller.getPurityResponse.value.data?.values ?? const [],
              getDisplayValue:
                  (GetPurityValue purityValue) => purityValue.purityName ?? "",
              onSelected: (GetPurityValue value) {
                controller.setSelectedPurity(value: value);
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              enabled: true,
              isLastRow: true,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              fieldHeight: 38.0,
              borderColor: secondaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Purity is required';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              autofocus: false,
            );
          }),
        ],
      ),
    );
  }

  SizedBox _vendorDropdown(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.25,
      child: Column(
        children: [
          const Row(
            children: [
              CustomText(
                text: 'Vendor',
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Obx(() {
            // Handle loading state
            if (controller.getVendorDropdownResponse.value.status ==
                Status.LOADING) {
              return Container(
                height: 38.0,
                decoration: BoxDecoration(
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            // Handle error state
            if (controller.getVendorDropdownResponse.value.status ==
                Status.ERROR) {
              return Container(
                height: 38.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'Failed to load vendors',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              );
            }

            // Render the dropdown when data is loaded
            return GenericAutocompleteDropdown<GetVendorDropdownValue>(
              controller: TextEditingController(
                text: controller.selectedVendorCode.value ?? '',
              ),
              focusNode: controller.vendorFocusNode,
              items:
                  controller.getVendorDropdownResponse.value.data?.values ??
                  const [],
              getDisplayValue:
                  (GetVendorDropdownValue vendorValue) =>
                      vendorValue.code ?? "",
              onSelected: (GetVendorDropdownValue value) {
                controller.setSelectedVendor(value.id ?? '', value.code ?? '');
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              enabled: true,
              isLastRow: true,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              fieldHeight: 38.0,
              borderColor: secondaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vendor is required';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              autofocus: false,
            );
          }),
        ],
      ),
    );
  }

  SizedBox _sizeDropdown(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.25,
      child: Column(
        children: [
          const Row(
            children: [
              CustomText(
                text: 'Size',
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            // Show loading or empty state based on design selection
            if (controller.selectedDesign.value == null) {
              return Container(
                height: 38.0,
                decoration: BoxDecoration(
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Select design first',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            }

            // If no sizes available
            if (controller.availableSizes.isEmpty) {
              return Container(
                height: 38.0,
                decoration: BoxDecoration(
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'No sizes available',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            }

            // Render the dropdown when sizes are available
            return GenericAutocompleteDropdown<SizeGroup>(
              controller: TextEditingController(
                text: controller.selectedSizeName.value ?? '',
              ),
              focusNode: controller.sizeFocusNode,
              items: controller.availableSizes,
              getDisplayValue: (SizeGroup sizeGroup) => sizeGroup.size ?? "",
              onSelected: (SizeGroup value) {
                controller.setSelectedSize(value.id, value.size);
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              enabled: true,
              isLastRow: true,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              fieldHeight: 38.0,
              borderColor: secondaryColor,
              validator: (value) {
                // Size is optional, so no validation
                return null;
              },
              keyboardType: TextInputType.text,
              autofocus: false,
            );
          }),
        ],
      ),
    );
  }
}

class _ItemDetailsWidget extends StatelessWidget {
  final String headerText;
  final String valueText;

  const _ItemDetailsWidget({required this.headerText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: headerText,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: primaryColor,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: valueText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ],
    );
  }
}
