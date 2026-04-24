import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimation_rate_carat_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_customer_info_card_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/models/get_sales_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/widgets/sales_return_search_party_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class SalesReturnDetailsWidget extends StatelessWidget {
  SalesReturnDetailsWidget({super.key});

  final SalesReturnSearchPartyController salesReturnSearchPartyController =
      Get.put(SalesReturnSearchPartyController());
  final SalesReturnViewmodel salesReturnViewmodel = Get.put(
    SalesReturnViewmodel(),
  );
  KeyEventResult handleSalesInvoiceKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        // If Enter is pressed without Shift
        if (!HardwareKeyboard.instance.isShiftPressed) {
          // If we have options, select the first one
          if (salesReturnViewmodel.salesInvoiceOptions.isNotEmpty) {
            salesReturnViewmodel.setSelectedSalesInvoice(
              salesReturnViewmodel.salesInvoiceOptions.first,
            );
            FocusManager.instance.primaryFocus?.nextFocus();
            return KeyEventResult.handled;
          }
        }
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: SalesReturnSearchPartyDropdown(
                        controller: salesReturnSearchPartyController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    RateCaratInput(onChanged: (rate, carat) {}),
                    const SizedBox(width: 16),
                    // CustomTextField(
                    //   name: "Enter Sales Invoice Number",
                    //   width: 250,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Enter Design Code";
                    //     }
                    //     return null;
                    //   },
                    //   focusNode: salesReturnViewmodel.salesNumberFocusNode,
                    //   controller:
                    //       salesReturnViewmodel.salesNumberTextController,
                    //   capitalizeText: true,
                    //   onEditingComplete: () {
                    //     FocusManager.instance.primaryFocus?.nextFocus();
                    //     salesReturnViewmodel.getSaleBySalesNumber(
                    //         saleNumber: salesReturnViewmodel
                    //             .salesNumberTextController.text);
                    //   },
                    //   onChanged: (value) {
                    //     final textController =
                    //         salesReturnViewmodel.salesNumberTextController;
                    //     final capitalizedValue = value.toUpperCase();
                    //     final currentCursorPosition =
                    //         textController.selection.baseOffset;
                    //     textController.value = TextEditingValue(
                    //       text: capitalizedValue,
                    //       selection: TextSelection.collapsed(
                    //         offset: currentCursorPosition,
                    //       ),
                    //     );
                    //   },
                    // ),
                    // Replace this section in your sales_return_details_widget.dart
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Sales Invoice Number",
                          color: primaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 250,
                          child: GenericAutocompleteDropdown<
                            GetSalesDropdownValue
                          >(
                            controller:
                                salesReturnViewmodel
                                    .salesInvoiceSearchController,
                            focusNode:
                                salesReturnViewmodel.salesInvoiceFocusNode,
                            items: salesReturnViewmodel.salesInvoiceOptions,
                            getDisplayValue:
                                (invoice) => invoice.saleNumber ?? 'N/A',
                            onSelected: (value) async {
                              salesReturnViewmodel.setSelectedSalesInvoice(
                                value,
                              );
                              // Move focus to next field if needed
                            },
                            customOptionsBuilder: (textEditingValue) async {
                              await salesReturnViewmodel.searchSalesInvoices(
                                textEditingValue.text,
                              );
                              return salesReturnViewmodel.salesInvoiceOptions
                                  .toList();
                            },
                            borderColor: secondaryColor,
                            fieldHeight: 38,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Sales Invoice Number";
                              }
                              return null;
                            },
                            autofocus: false,
                            isLastRow: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      children: [
                        CustomText(
                          text: "",
                          color: blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        SizedBox(height: 6),
                        // Obx(
                        //   () => CustomInkButton(
                        //     onPressed: () {
                        //       salesReturnViewmodel.getSaleBySalesNumber(
                        //           saleNumber: salesReturnViewmodel
                        //               .salesNumberTextController.text);
                        //     },
                        //     text: "Fetch",
                        //     isLoading: salesReturnViewmodel
                        //             .getSaleBySalesNumberResponse
                        //             .value
                        //             .status ==
                        //         Status.LOADING,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),

                // mode estimate number
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CustomText(
                          text: "Mode:",
                          fontSize: 12,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => Row(
                            children: [
                              const CustomText(
                                text: "Correction Mode",
                                fontSize: 14,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                                color: grey2,
                              ),
                              const SizedBox(width: 16),
                              CustomToggleSwitch(
                                // focusNode: focusNode,
                                canRequestFocus: false,
                                value: salesReturnViewmodel.isFastMode.value,
                                onChanged:
                                    (_) =>
                                        salesReturnViewmodel.toggleFastMode(),
                              ),
                              const SizedBox(width: 16),
                              CustomText(
                                text:
                                    salesReturnViewmodel.isFastMode.value
                                        ? "Fast Mode"
                                        : "",
                                fontSize: 14,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                                color: totalGreenColor,
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
                              text: "Sales Return Number:",
                              fontSize: 12,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 200,
                          child: _buildSalesNumberDropdown(),
                        ),
                      ],
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     const CustomText(
                    //       text: "Sales Return Number:",
                    //       fontSize: 12,
                    //       fontFamily: 'Satoshi',
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //     const SizedBox(
                    //       height: 16,
                    //     ),
                    //     Row(
                    //       children: [
                    //         Obx(
                    //           () => CustomText(
                    //             text: salesReturnViewmodel.salesNumber.value,
                    //             fontSize: 16,
                    //             fontFamily: 'Satoshi',
                    //             fontWeight: FontWeight.w700,
                    //             color: primaryColor,
                    //           ),
                    //         ),
                    //       ],
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              CustomerSearchValue? customerSearchValue;
              VendorSearchValue? vendorSearchValue;
              if (salesReturnSearchPartyController.selectedParty.value
                  is CustomerSearchValue) {
                customerSearchValue =
                    salesReturnSearchPartyController.selectedParty.value;
              } else if (salesReturnSearchPartyController.selectedParty.value
                  is VendorSearchValue) {
                vendorSearchValue =
                    salesReturnSearchPartyController.selectedParty.value;
              }
              return CustomerInfoCard(
                customerName:
                    customerSearchValue?.name ?? vendorSearchValue?.name ?? '-',
                sgstNumber:
                    customerSearchValue?.gstNumber ??
                    vendorSearchValue?.gstNumber ??
                    "-",
                address:
                    customerSearchValue?.address?.firstOrNull?.addressLine1 ??
                    vendorSearchValue?.address?.firstOrNull?.addressLine1 ??
                    '-',
                balancePayment:
                    salesReturnSearchPartyController
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
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesNumberDropdown() {
    return Obx(() {
      final status =
          salesReturnViewmodel.sequencesDropdownResponse.value.status;

      if (status == Status.LOADING) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              CustomText(text: 'Loading...', fontSize: 12, color: Colors.grey),
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
              const Expanded(
                child: CustomText(
                  text: 'Failed to load',
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
              InkWell(
                onTap: () {
                  salesReturnViewmodel.loadSequencesDropdown();
                },
                child: Icon(Icons.refresh, color: Colors.red[600], size: 16),
              ),
            ],
          ),
        );
      }

      return GenericAutocompleteDropdown<GetSequencesDropdownValue>(
        controller: salesReturnViewmodel.sequencesDropdownController,
        focusNode: salesReturnViewmodel.sequencesDropdownFocusNode,
        items: salesReturnViewmodel.sequencesDropdownList,
        getDisplayValue: (item) => item.value ?? '',
        borderColor: primaryColor,
        onSelected: (item) {
          salesReturnViewmodel.setSelectedSequence(item);
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.nextFocus();
        },
        validator: (value) {
          if (salesReturnViewmodel.selectedSequence.value == null ||
              (value?.trim().isEmpty ?? true)) {
            return 'Sales Number is required';
          }
          return null;
        },
        enabled: salesReturnViewmodel.sequencesDropdownList.isNotEmpty,
      );
    });
  }
}
