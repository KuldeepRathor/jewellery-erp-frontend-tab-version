import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/party_details_adapter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_new_party_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';

class CreateOrderSearchPartyDropdown extends StatelessWidget {
  final CreateOrderPartyDetailsController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const CreateOrderSearchPartyDropdown({
    super.key,
    required this.controller,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Obx(() {
          return PartyDropdownAdapter(
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
                // Then add 'ADD_NEW' as the last item in the list
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
      if (nextFocusNode != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          nextFocusNode!.requestFocus();
        });
      }
    } else if (item == ADD_NEW) {
      // Wait for the dialog result
      final result = await Get.dialog<dynamic>(const AddNewPartyDialog());

      // If a new customer/vendor was created, set it as selected
      if (result is CustomerSearchValue) {
        controller.updateWithNewCustomer(result);
        controller.setSelectedContact(result);
        controller.searchController.value.text = result.name ?? '';
      } else if (result is VendorSearchValue) {
        controller.updateWithNewVendor(result);
        controller.setSelectedContact(result);
        controller.searchController.value.text = result.name ?? '';
      }

      // Ensure the text field shows the selection
      controller.searchController.value.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.searchController.value.text.length),
      );

      if (nextFocusNode != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          nextFocusNode!.requestFocus();
        });
      }
    }

    FocusManager.instance.primaryFocus?.nextFocus();
  }
}
