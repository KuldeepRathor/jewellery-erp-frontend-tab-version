import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/party_details_adapter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_transaction_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/view_model/lot_entry_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_mult_select_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class LotEntryDialog extends StatefulWidget {
  final GetLotEntriesValue? lotData; // Data for edit mode

  const LotEntryDialog({super.key, this.lotData});

  @override
  State<LotEntryDialog> createState() => _LotEntryDialogState();
}

class _LotEntryDialogState extends State<LotEntryDialog> {
  late LotEntryController controller;

  // Keyboard shortcuts
  final Map<ShortcutActivator, Intent> _shortcuts = {
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
        const SaveIntent(),
  };

  @override
  void initState() {
    super.initState();

    // Initialize controller
    controller = Get.put(LotEntryController());

    // If edit mode, prefill the form with existing data
    if (widget.lotData != null) {
      controller.fetchLotEntryById(widget.lotData!.id!);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.transactionTypeFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: {
          SaveIntent: CallbackAction<SaveIntent>(
            onInvoke: (intent) {
              controller.handleSaveShortcut();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              width: Get.width * 0.5,
              padding: const EdgeInsets.all(24),
              child: Obx(() {
                Status currentStatus =
                    controller.lotEntryDetailResponse.value.status;
                if (currentStatus == Status.LOADING) {
                  return _buildLoadingState('Loading lot entry details...');
                }

                // Show error state when fetching lot entry details fails
                if (currentStatus == Status.ERROR) {
                  return _buildErrorState(
                    'Failed to load lot entry details',
                    controller.lotEntryDetailResponse.value.message ??
                        'Unknown error',
                  );
                }
                return buildForm();
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          CustomText(text: message, color: primaryColor),
        ],
      ),
    );
  }

  // Error state widget
  Widget _buildErrorState(String title, String message) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          CustomText(
            text: title,
            color: Colors.red,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          const SizedBox(height: 8),
          CustomText(text: message, color: Colors.red, fontSize: 14),
          const SizedBox(height: 24),
          CustomInkButton(
            onPressed: () => Get.back(),
            text: "Close",
            textColor: Colors.white,
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => CustomText(
                  text:
                      controller.isEditMode.value
                          ? 'Edit Lot Entry'
                          : 'Lot Entry',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form fields in a grid layout
          Wrap(
            spacing: 16,
            runSpacing: 32,
            children: [
              // First row - Transaction Type
              SizedBox(
                width: Get.width * 0.23,
                child: _buildTransactionTypeField(),
              ),

              // Invoice Number
              SizedBox(
                width: Get.width * 0.23,
                child: _buildInvoiceNumberField(),
              ),

              // Second row - Supplier with PartyDropdownAdapter
              SizedBox(
                width: Get.width * 0.23,
                child: _buildSupplierDropdown(),
              ),

              // Pieces
              SizedBox(
                width: Get.width * 0.23,
                child: CustomTextField(
                  name: 'Pcs',
                  controller: controller.pcsController,
                  focusNode: controller.pcsFocusNode,
                  keyboardType: TextInputType.number,
                  validator: controller.validatePieces,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.nextFocus();
                  },
                ),
              ),

              // Third row - Gross Weight
              SizedBox(
                width: Get.width * 0.23,
                child: CustomTextField(
                  name: 'G. Wt (gm)',
                  controller: controller.grossWtController,
                  focusNode: controller.grossWtFocusNode,
                  keyboardType: TextInputType.number,
                  validator: controller.validateGrossWeight,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.nextFocus();
                  },
                  onChanged: (value) {
                    // Update net weight when gross weight changes
                    controller.updateNetWeight(value);
                  },
                ),
              ),

              // Net Weight
              SizedBox(
                width: Get.width * 0.23,
                child: CustomTextField(
                  name: 'N. Wt (gm)',
                  controller: controller.netWtController,
                  focusNode: controller.netWtFocusNode,
                  keyboardType: TextInputType.number,
                  validator: controller.validateNetWeight,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.nextFocus();
                  },
                ),
              ),

              // Fourth row - Purity (now using API data)
              SizedBox(width: Get.width * 0.23, child: _buildPurityDropdown()),
            ],
          ),

          const SizedBox(height: 32),

          // API status indicators
          Obx(() {
            if (controller.isLoading) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 16),
                    CustomText(
                      text:
                          controller.isEditMode.value
                              ? 'Updating lot entry...'
                              : 'Creating lot entry...',
                      color: primaryColor,
                    ),
                  ],
                ),
              );
            }

            if (controller.hasError) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomText(
                  text: 'Error: ${controller.errorMessage}',
                  color: Colors.red,
                ),
              );
            }

            return const SizedBox.shrink();
          }),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // CustomInkButton(
              //   onPressed: controller.resetForm,
              //   text: "Reset",
              //   // backgroundColor: Colors.grey[300],
              //   textColor: blackColor,
              // ),
              const SizedBox(width: 16),
              Obx(
                () => CustomInkButton(
                  onPressed: controller.submitForm,
                  isLoading: controller.isLoading,
                  width: 160,
                  text:
                      controller.isEditMode.value
                          ? "Update (CTRL+S)"
                          : "Save (CTRL+S)",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Replace the existing Invoice Number field with this implementation
  Widget _buildInvoiceNumberField() {
    return SizedBox(
      width: Get.width * 0.23,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Invoice No.',
            color: blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          Obx(() {
            controller.invoiceNumbersResponse.value.status;

            return GenericAutocompleteDropdown<String>(
              controller: controller.invoiceNoController,
              padding: const EdgeInsets.only(top: 8),
              isLastRow: true,
              focusNode: controller.invoiceNoFocusNode,
              items: controller.invoiceNumbers,
              getDisplayValue: (item) => item,
              onSelected: (item) {
                controller.setSelectedInvoice(item);
                controller.supplierFocusNode.requestFocus();
              },
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.nextFocus();
              },
              // validator: controller.validateInvoiceNo,
              customOptionsBuilder: (TextEditingValue textEditingValue) async {
                final searchQuery = textEditingValue.text;

                // If we have a search query, trigger an API call
                if (controller.selectedTransactionType.value?.transactionType !=
                    null) {
                  // Only fetch if the query is still the same (user hasn't typed more)
                  await controller.fetchInvoiceNumbers(
                    transactionType:
                        controller
                            .selectedTransactionType
                            .value!
                            .transactionType!,
                    resetList: true,
                    query: searchQuery,
                  );
                }

                // Filter the current list while waiting for API results
                if (searchQuery.isEmpty) {
                  return controller.invoiceNumbers;
                } else {
                  return controller.invoiceNumbers
                      .where(
                        (invoice) => invoice.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();
                }
              },
            );
          }),
        ],
      ),
    );
  }

  // Replace the Transaction Type field in the form with this implementation
  Widget _buildTransactionTypeField() {
    return SizedBox(
      width: Get.width * 0.23,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Transaction Type',
            color: blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          Obx(() {
            controller.lotTransactionTypesResponse.value.status;

            return GenericAutocompleteDropdown<LotTransactionTypesResponse>(
              controller: controller.transactionTypeController,
              isLastRow: true,
              padding: const EdgeInsets.only(top: 8),
              focusNode: controller.transactionTypeFocusNode,
              items: controller.lotTransactionTypes,
              autofocus: true,
              getDisplayValue: (item) => item.transactionType ?? "",
              onSelected: (item) {
                controller.onTransactionTypeSelected(item: item);
                controller.invoiceNoFocusNode.requestFocus();
              },
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.nextFocus();
              },
              // validator: controller.validateTransactionType,
            );
          }),
        ],
      ),
    );
  }

  // Build the supplier dropdown using PartyDropdownAdapter
  Widget _buildSupplierDropdown() {
    return Obx(() {
      controller.isVendorLoading.value;

      return PartyDropdownAdapter(
        label: 'Supplier',
        width: double.maxFinite,
        controller: controller.supplierController,
        focusNode: controller.supplierFocusNode,
        items:
            const [], // We don't use this as we'll provide a custom options builder
        onSelected: (party) {
          if (party is VendorSearchValue) {
            controller.setSelectedVendor(party);
          }
          controller.pcsFocusNode.requestFocus();
        },

        // validator: controller.validateSupplier,
        customOptionsBuilder: (TextEditingValue textEditingValue) async {
          // When user types, search for vendors
          final vendors = await controller.searchVendors(textEditingValue.text);
          return vendors.map((vendor) => PartyDetails(vendor));
        },
      );
    });
  }

  // Build the purity dropdown with API-loaded purities
  Widget _buildPurityDropdown() {
    return Obx(() {
      controller.getPurityResponse.value.status;

      return Obx(
        () => CustomMultiSelectDropdown<String>(
          name: 'Purity',
          width: Get.width * 0.23,
          items: controller.purities,
          selectedItems: controller.selectedPurities.toList(),
          displayStringForOption: (item) => item,
          onChanged: (values) {
            controller.selectedPurities.clear();
            controller.selectedPurities.addAll(values);
          },
          focusNode: controller.purityFocusNode,
          // validator: (values) {
          //   return controller.validatePurities(controller.selectedPurities);
          // },
        ),
      );
    });
  }
}

// Custom intent for save action
class SaveIntent extends Intent {
  const SaveIntent();
}
