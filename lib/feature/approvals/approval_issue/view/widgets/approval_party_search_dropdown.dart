import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/party_details_adapter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';

class ApprovalPartySearchDropdown extends StatelessWidget {
  final PartyDetailsController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool isPurchase;

  const ApprovalPartySearchDropdown({
    super.key,
    required this.controller,
    this.focusNode,
    this.nextFocusNode,
    required this.isPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Obx(() {
          return PartyDropdownAdapter(
            width: constraints.maxWidth,
            label: 'Search by name, phone, or code',
            controller: controller.searchController.value,
            focusNode: focusNode ?? FocusNode(),
            items: const [],
            onSelected: (value) => _onItemSelected(value),
            validator: (value) {
              // Add validation if needed
              return null;
            },
            customOptionsBuilder: (textValue) async {
              if (textValue.text != ADD_NEW) {
                final searchText = textValue.text;
                controller.lastSearchQuery.value = searchText;

                await controller.searchParties(searchText);
              }

              // Map the search results to PartyDetails objects
              return controller.partyDetails
                  .map((party) => PartyDetails(party))
                  .toList()
                // Then add 'ADD_NEW' as the last item
                ..add(PartyDetails(ADD_NEW));
            },
          );
        });
      },
    );
  }

  Future<void> _onItemSelected(dynamic item) async {
    if (item is CustomerSearchValue || item is VendorSearchValue) {
      await controller.setSelectedContact(item);

      // Handle invoice number fetching based on party type
      _handleInvoiceNumberFetch(item);

      // Move focus to next field
      if (nextFocusNode != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          nextFocusNode!.requestFocus();
        });
      }
    } else if (item == ADD_NEW) {
      // Show dialog based on whether we're in purchase mode
      final result = await _showAddPartyDialog();

      if (result != null) {
        if (result is CustomerSearchValue) {
          controller.updateWithNewCustomer(result);
        } else if (result is VendorSearchValue) {
          controller.updateWithNewVendor(result);
        }

        await controller.setSelectedContact(result);
        _handleInvoiceNumberFetch(result);

        controller.searchController.value.text = result.name ?? '';

        // Ensure the text field shows the selection
        controller
            .searchController
            .value
            .selection = TextSelection.fromPosition(
          TextPosition(offset: controller.searchController.value.text.length),
        );

        if (nextFocusNode != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            nextFocusNode!.requestFocus();
          });
        }
      } else {
        // If dialog was cancelled, clear the search
        controller.searchController.value.text = "";
      }
    }

    FocusManager.instance.primaryFocus?.nextFocus();
  }

  Future<dynamic> _showAddPartyDialog() async {
    // Show a dialog to let user choose between Customer and Vendor
    final partyType = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Add New Party'),
        content: const Text('What type of party would you like to add?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: 'customer'),
            child: const Text('Customer'),
          ),
          TextButton(
            onPressed: () => Get.back(result: 'vendor'),
            child: const Text('Vendor'),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );

    if (partyType == 'customer') {
      return await Get.dialog<CustomerSearchValue?>(
        AddCustomerDialog(userData: controller.lastSearchQuery.value),
      );
    } else if (partyType == 'vendor') {
      return await Get.dialog<VendorSearchValue?>(const AddVendorDialog());
    }

    return null;
  }

  void _handleInvoiceNumberFetch(dynamic item) {
    // Import and use VendorBillDetailsController if needed
    try {
      final vendorBillDetailsController =
          Get.find<VendorBillDetailsController>();

      if (item is CustomerSearchValue) {
        if (isPurchase) {
          vendorBillDetailsController.fetchNextInvoiceNumber(
            invoiceType: "invoice_number_customer",
          );
        } else {
          vendorBillDetailsController.fetchNextInvoiceNumber(
            invoiceType: "return_invoice_number_customer",
          );
        }
      } else if (item is VendorSearchValue) {
        if (isPurchase) {
          vendorBillDetailsController.fetchNextInvoiceNumber(
            invoiceType: "invoice_number_vendor",
          );
        } else {
          vendorBillDetailsController.fetchNextInvoiceNumber(
            invoiceType: "return_invoice_number_vendor",
          );
        }
      }
    } catch (e) {
      // Handle if VendorBillDetailsController is not found
      debugPrint('VendorBillDetailsController not found: $e');
    }
  }
}
