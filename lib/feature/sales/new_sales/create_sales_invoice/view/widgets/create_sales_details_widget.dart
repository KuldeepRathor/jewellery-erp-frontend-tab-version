import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimation_rate_carat_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_customer_info_card_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_search_mobile_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class CreateSalesDetailsWidget extends StatelessWidget {
  CreateSalesDetailsWidget({super.key, required this.partySearchFocusNode});
  final FocusNode partySearchFocusNode;
  final FocusNode estimateNumberFocusNode = FocusNode();

  final CreateSalesEstimationSearchPartyController
  createSalesEstimationSearchPartyController =
      Get.find<CreateSalesEstimationSearchPartyController>();
  final CreateSalesViewModel createSalesViewModel =
      Get.find<CreateSalesViewModel>();
  final CreateSalesItemDetailsController createSalesItemDetailsController =
      Get.find<CreateSalesItemDetailsController>();

  final RBACController rbacController = Get.find<RBACController>();
  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent:
          (node, event) =>
              onNormalKeyEvent(node, event, [partySearchFocusNode]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          // height: 90,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        // CustomTextField(
                        //   name: "Rate/gm",
                        //   width: 250,
                        //   autofocus: true,
                        //   // controller: controller.designCodeController,
                        //   // onChanged: (value) => _showRetagDialog(),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return "Enter Design Code";
                        //     }
                        //     return null;
                        //   },
                        // ),
                        SizedBox(
                          width: 250,
                          child: CreateSalesSearchPartyDropdown(
                            controller:
                                createSalesEstimationSearchPartyController,
                            focusNode: partySearchFocusNode,
                            estimateNumberFocusNode: estimateNumberFocusNode,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Obx(
                          () => RateCaratInput(
                            readOnly:
                                createSalesViewModel.isFastMode.value &&
                                (rbacController.hasAction(1102) == false),
                            onChanged: (rate, carat) {
                              if (createSalesViewModel.isFastMode.value ==
                                      false &&
                                  rbacController.hasAction(1102)) {
                                createSalesItemDetailsController.onRateChanged(
                                  rate,
                                  carat,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        // CustomTextField(
                        //   name: "Reference Invoice Number",
                        //   width: 250,
                        //   // validator: (value) {
                        //   //   // if (value == null || value.isEmpty) {
                        //   //   //   return "Enter Design Code";
                        //   //   // }
                        //   //   // return null;
                        //   // },
                        //   controller:
                        //       createSalesViewModel.referenceInvoicTextController,
                        //   capitalizeText: true,
                        // ),
                        // const SizedBox(
                        //   width: 16,
                        // ),
                        SizedBox(
                          width: 250,
                          child: RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: (RawKeyEvent event) {
                              if (event is RawKeyDownEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.enter) {
                                // Stop propagation by consuming the event
                                if (createSalesViewModel
                                    .estimateNumberTextController
                                    .text
                                    .isNotEmpty) {
                                  // Execute fetch functionality
                                  createSalesViewModel.getSaleByEstimateNumber(
                                    estimateNumber:
                                        createSalesViewModel
                                            .estimateNumberTextController
                                            .text,
                                  );
                                  // Prevent default enter behavior
                                  return;
                                }
                              }
                            },
                            child: CustomTextField(
                              name: "Enter Estimate Number",
                              width: 250,
                              focusNode: estimateNumberFocusNode,
                              onEditingComplete: () {
                                // This will be called when Enter is pressed
                                if (createSalesViewModel
                                    .estimateNumberTextController
                                    .text
                                    .isNotEmpty) {
                                  createSalesViewModel.getSaleByEstimateNumber(
                                    estimateNumber:
                                        createSalesViewModel
                                            .estimateNumberTextController
                                            .text,
                                  );

                                  // Manually maintain focus in this field or set to next appropriate field
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(estimateNumberFocusNode);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Estimate Code";
                                }
                                return null;
                              },
                              controller:
                                  createSalesViewModel
                                      .estimateNumberTextController,
                              capitalizeText: true,
                              onChanged: (value) {
                                final textController =
                                    createSalesViewModel
                                        .estimateNumberTextController;
                                final capitalizedValue = value.toUpperCase();
                                final currentCursorPosition =
                                    textController.selection.baseOffset;
                                textController.value = TextEditingValue(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(
                                    offset: currentCursorPosition,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // const SizedBox(
                        //   width: 16,
                        // ),
                        // Column(
                        //   children: [
                        //     const CustomText(
                        //       text: "",
                        //       color: blackColor,
                        //       fontWeight: FontWeight.w700,
                        //       fontSize: 12,
                        //     ),
                        //     const SizedBox(
                        //       height: 6,
                        //     ),
                        //     Obx(
                        //       () => CustomInkButton(
                        //         onPressed: () {
                        //           createSalesViewModel.getSaleByEstimateNumber(
                        //               estimateNumber: createSalesViewModel
                        //                   .estimateNumberTextController.text);
                        //         },
                        //         text: "Fetch",
                        //         isLoading: createSalesViewModel
                        //                 .getSaleByEstimationNumberResponse
                        //                 .value
                        //                 .status ==
                        //             Status.LOADING,
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                    const SizedBox(width: 16),
                    // mode estimate number
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const CustomText(
                              text: "Mode (ALT+F):",
                              fontSize: 12,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => Row(
                                children: [
                                  CustomText(
                                    text: "Correction Mode",
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    color:
                                        createSalesViewModel.isFastMode.value ==
                                                false
                                            ? redTextColor
                                            : grey2,
                                  ),
                                  const SizedBox(width: 16),
                                  CustomToggleSwitch(
                                    // focusNode: focusNode,
                                    canRequestFocus: false,
                                    value:
                                        createSalesViewModel.isFastMode.value,
                                    onChanged: (_) {
                                      PermissionGuardUtil.withActionPermission(
                                        1103,
                                        () {
                                          createSalesViewModel.toggleFastMode();
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  CustomText(
                                    text: "Fast Mode",
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    color:
                                        createSalesViewModel.isFastMode.value
                                            ? totalGreenColor
                                            : grey2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(color: grey2, height: 60, width: 2),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomText(
                                  text: "Sales Number:",
                                  fontSize: 12,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                                // const SizedBox(width: 8),
                                // InkWell(
                                //   onTap: () {
                                //     createSalesViewModel.loadSequencesDropdown();
                                //   },
                                //   child: Container(
                                //     padding: const EdgeInsets.all(4),
                                //     decoration: BoxDecoration(
                                //       color: primaryColor.withOpacity(0.1),
                                //       borderRadius: BorderRadius.circular(4),
                                //     ),
                                //     child: const Icon(
                                //       Icons.refresh,
                                //       size: 14,
                                //       color: primaryColor,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 200,
                              child: _buildSalesNumberDropdown(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Obx(() {
                    CustomerSearchValue? customerSearchValue;
                    VendorSearchValue? vendorSearchValue;
                    if (createSalesEstimationSearchPartyController
                            .selectedParty
                            .value
                        is CustomerSearchValue) {
                      customerSearchValue =
                          createSalesEstimationSearchPartyController
                              .selectedParty
                              .value;
                    } else {
                      vendorSearchValue =
                          createSalesEstimationSearchPartyController
                              .selectedParty
                              .value;
                    }
                    return CustomerInfoCard(
                      customerName:
                          customerSearchValue?.name ??
                          vendorSearchValue?.name ??
                          '-',
                      sgstNumber:
                          customerSearchValue?.gstNumber ??
                          vendorSearchValue?.gstNumber ??
                          "-",
                      address:
                          customerSearchValue
                              ?.address
                              ?.firstOrNull
                              ?.addressLine1 ??
                          vendorSearchValue
                              ?.address
                              ?.firstOrNull
                              ?.addressLine1 ??
                          '-',
                      balancePayment:
                          createSalesEstimationSearchPartyController
                              .getPartyBalanceResponse
                              .value
                              .data
                              ?.values
                              ?.firstOrNull
                              ?.balanceDifference ??
                          "-",
                      onViewLedger: () {
                        // Handle ledger view action
                      },
                      onEdit: () {
                        // Handle edit action
                        String? customerId =
                            createSalesEstimationSearchPartyController
                                .selectedParty
                                .value
                                ?.id;
                        Get.dialog(AddCustomerDialog(customerId: customerId));
                      },
                    );
                  }),
                  const Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CustomText(
                            text: "in Store Sale",
                            fontSize: 12,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => Row(
                              children: [
                                CustomText(
                                  text: "No",
                                  fontSize: 14,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
                                  color:
                                      createSalesViewModel.isFastMode.value ==
                                              false
                                          ? redTextColor
                                          : grey2,
                                ),
                                const SizedBox(width: 16),
                                CustomToggleSwitch(
                                  // focusNode: focusNode,
                                  canRequestFocus: false,
                                  value: createSalesViewModel.isStoreSale.value,
                                  onChanged: (_) {
                                    createSalesViewModel.toggleStoreSale();
                                  },
                                ),
                                const SizedBox(width: 16),
                                CustomText(
                                  text: "Yes",
                                  fontSize: 14,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
                                  color:
                                      createSalesViewModel.isFastMode.value
                                          ? totalGreenColor
                                          : grey2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesNumberDropdown() {
    return Obx(() {
      final status =
          createSalesViewModel.sequencesDropdownResponse.value.status;

      // Use the constant to get metal type name
      final metalTypeName = MetalTypeUtils.getName(
        createSalesViewModel.selectedMetalType.value,
      );

      if (status == Status.LOADING) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              CustomText(
                text: 'Loading $metalTypeName...',
                fontSize: 12,
                color: Colors.grey,
              ),
            ],
          ),
        );
      }

      if (status == Status.ERROR) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.red[50],
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[600], size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: CustomText(
                  text: 'Failed to load $metalTypeName',
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
              InkWell(
                onTap: () {
                  createSalesViewModel.loadSequencesDropdown();
                },
                child: Icon(Icons.refresh, color: Colors.red[600], size: 16),
              ),
            ],
          ),
        );
      }
      if (status == Status.COMPLETED &&
          createSalesViewModel.sequencesDropdownList.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.orange[50],
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange[600], size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: CustomText(
                  text: 'No sequences for $metalTypeName',
                  fontSize: 12,
                  color: Colors.orange[800]!,
                ),
              ),
            ],
          ),
        );
      }
      return GenericAutocompleteDropdown<GetSequencesDropdownValue>(
        controller: createSalesViewModel.sequencesDropdownController,
        focusNode: createSalesViewModel.sequencesDropdownFocusNode,
        items: createSalesViewModel.sequencesDropdownList,
        getDisplayValue: (item) => item.value ?? '',
        borderColor: primaryColor,
        onSelected: (item) {
          createSalesViewModel.setSelectedSequence(item);
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.nextFocus();
        },
        validator: (value) {
          if (createSalesViewModel.selectedSequence.value == null ||
              (value?.trim().isEmpty ?? true)) {
            return 'Sales Number is required';
          }
          return null;
        },
        enabled: createSalesViewModel.sequencesDropdownList.isNotEmpty,
      );
    });
  }
}
