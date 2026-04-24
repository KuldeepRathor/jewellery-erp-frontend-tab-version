import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/party_details_adapter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';

class CreateSalesSearchPartyDropdown extends StatelessWidget {
  final CreateSalesEstimationSearchPartyController controller;
  final FocusNode? focusNode;

  final FocusNode? estimateNumberFocusNode;

  const CreateSalesSearchPartyDropdown({
    super.key,
    required this.controller,
    this.focusNode,
    this.estimateNumberFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Obx(() {
          return PartyDropdownAdapter(
            label: 'Search Mobile Number',
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
                // Then add 'ADD_NEW' as the last item in the list - using the same string format as in original
                ..add(PartyDetails(ADD_NEW));
            },
          );
        });
      },
    );
  }

  Future<void> _onItemSelected(dynamic item) async {
    if (item is CustomerSearchValue || item is VendorSearchValue) {
      controller.setSelectedContact(item);
      if (estimateNumberFocusNode != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          estimateNumberFocusNode!.requestFocus();
        });
      }
    } else if (item == ADD_NEW) {
      // Wait for the dialog result
      final newCustomer = await Get.dialog<CustomerSearchValue?>(
        AddCustomerDialog(userData: controller.lastSearchQuery.value),
      );

      // If a new customer was created, set it as selected
      if (newCustomer != null) {
        controller.updateWithNewCustomer(newCustomer);
        controller.setSelectedContact(
          newCustomer,
          nextFocusNode: estimateNumberFocusNode,
        );

        controller.searchController.value.text = newCustomer.name ?? '';

        // Ensure the text field shows the selection
        controller
            .searchController
            .value
            .selection = TextSelection.fromPosition(
          TextPosition(offset: controller.searchController.value.text.length),
        );
        if (estimateNumberFocusNode != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            estimateNumberFocusNode!.requestFocus();
          });
        }
      } else {
        // If dialog was cancelled, clear the search
        controller.searchController.value.text = "";
      }
    }

    FocusManager.instance.primaryFocus?.nextFocus();
    FocusManager.instance.primaryFocus?.nextFocus();
    FocusManager.instance.primaryFocus?.nextFocus();
  }
}
